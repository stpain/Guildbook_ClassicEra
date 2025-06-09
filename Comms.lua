--[[
    Comms:
        The Comms class is used to send and receive data on the GUILD channel and WHISPER channel

        There is a queue system to prevent the addon spamming chat channels and disrupting other addon communications.
        The queue is simple, messages get added to the queue and are held for n number of seconds, during this time
        any new data of the same message type will cause the currently queued message to be updated rather than a new
        message added to the queue.
        Once a message dispatch time arrives the message will be sent and the remaining queued messages will have their
        dispatch time increased by n seconds. This means the addon will only send a message once every n seconds, and 
        where cases exists that a message might be spammed, it'll be caught by the initial delay.

        The guild bank messages ignore the queue and mostly use the WHISPER channel.
]]

local name, addon = ...;

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")
local Database = addon.Database;
local Character = addon.Character;
local C_Calendar = addon.Calendar;

local Comms = {
    prefix = "Guildbook", --name var was to long
    version = 1,

    --delay from transmit request to first dispatch attempt, this prevents spamming if a player opens/closes a panel that triggers a transmit
    queueWaitingTime = 4.0,

    --the time added to each message waiting in the queue, this limits how often a message can be dispatched
    queueExtendTime = 2.0,

     --limiter effect for the dispatcher onUpdate func, limits the onUpdate to once per second
    dispatcherElapsedDelay = 1.0,
    
    queue = {},
    dispatcher = CreateFrame("FRAME"),
    dispatcherElapsed = 0,
    paused = false,

    priorityEnums = {

    },
};


--this table should contain only the character.data[key] keys which we want to send
--[[
    for example, when the characters mainSpec changes, the character obj will notify to broadcast
    then this table will be checked for the key 'mainSpec' and its value passed on as an EVENT flag for the data payload
]]
Comms.characterKeyToEventName = {
    --containers = "CONTAINERS_TRANSMIT", --for guild banks -REMOVED THIS SYSTEM
    inventory = "INVENTORY_TRANSMIT",
    paperDollStats = "PAPERDOLL_STATS_TRANSMIT",
    talents = "TALENT_TRANSMIT",
    glyphs = "GLYPH_TRANSMIT",
    resistances = "RESISTANCE_TRANSMIT",
    auras = "AURA_TRANSMIT",
    alts = "ALTS_TRANSMIT",
    mainCharacter = "MAIN_CHARACTER_TRANSMIT",
    -- publicNote = self.data.publicNote,
    mainSpec = "SPEC_TRANSMIT",
    offSpec = "SPEC_TRANSMIT",
    -- mainSpecIsPvP = self.data.mainSpecIsPvP,
    -- offSpecIsPvP = self.data.offSpecIsPvP,
    profession1 = "TRADESKILL_TRANSMIT_PROF1",
    profession1Level = "TRADESKILL_TRANSMIT_PROF1_LEVEL",
    profession1Spec = "TRADESKILL_TRANSMIT_PROF1_SPEC",
    profession1Recipes = "TRADESKILL_TRANSMIT_PROF1_RECIPES",
    profession2 = "TRADESKILL_TRANSMIT_PROF2",
    profession2Level = "TRADESKILL_TRANSMIT_PROF2_LEVEL",
    profession2Spec = "TRADESKILL_TRANSMIT_PROF2_SPEC",
    profession2Recipes = "TRADESKILL_TRANSMIT_PROF2_RECIPES",
    cookingLevel = "TRADESKILL_TRANSMIT_COOKING_LEVEL",
    cookingRecipes = "TRADESKILL_TRANSMIT_COOKING_RECIPES",
    fishingLevel = "TRADESKILL_TRANSMIT_FISHING_LEVEL",
    firstAidLevel = "TRADESKILL_TRANSMIT_FIRSTAID_LEVEL",
    firstAidRecipes = "TRADESKILL_TRANSMIT_FIRSTAID_RECIPES",

    --CurrentInventory = self.data.currentInventory,
    --CurrentPaperdollStats = self.data.currentPaperdollStats or {},

}
-- Comms.messageEventToCharacterKey = {}
-- for k, v in pairs(Comms.characterKeyToEventName) do
--     Comms.messageEventToCharacterKey[v] = k
-- end


function Comms:Init()
    
    AceComm:Embed(self);
    self:RegisterComm(self.prefix);

    self.version = tonumber(C_AddOns.GetAddOnMetadata(name, "Version"));

    self.dispatcher:SetScript("OnUpdate", Comms.DispatcherOnUpdate)

    addon:TriggerEvent("StatusText_OnChanged", "[Comms:Init]")
    addon:RegisterCallback("Player_Regen_Enabled", self.Player_Regen_Enabled, self)
    addon:RegisterCallback("Player_Regen_Disabled", self.Player_Regen_Disabled, self)
end

--pause comms during combat
--this setup doesn't affect guild bank and non queue comms, however checking the banks wouuld likely be done in a city or rested area
function Comms:Player_Regen_Enabled()
    self.paused = false;
end

function Comms:Player_Regen_Disabled()
    self.paused = true;
end

---the purpose of this function is to check the queued mesages once per second and take action
---if there is a message and its dispatch time has been reached then push the message, then update remaining messages to dispatch at n second intervals
---if the queue is empty remove the onUpdate script
---@param self frame the dispatch frame
---@param elapsed number elapsed since last OnUpdate
function Comms.DispatcherOnUpdate(self, elapsed)

    if addon.api.isInGuild() == false then
        return
    end

    if Comms.paused then
        return;
    end

    Comms.dispatcherElapsed = Comms.dispatcherElapsed + elapsed;

    if Comms.dispatcherElapsed < Comms.dispatcherElapsedDelay then
        return;
    else
        Comms.dispatcherElapsed = 0;
    end

    if #Comms.queue == 0 then
        self:SetScript("OnUpdate", nil)
    else

        local now = time();

        --grab the message from the queue
        local message = Comms.queue[1];

        --if the message is due to go push it
        if message.dispatchTime < now then

            --here message.payload is the msg table not the msg table .payload
            if not message.payload.version then
                message.payload.version = Comms.version;
            end

            local priority = message.payload.priority or "NORMAL"

            local serialized = LibSerialize:Serialize(message.payload);
            local compressed = LibDeflate:CompressDeflate(serialized);
            local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

            Comms:SendCommMessage(Comms.prefix, encoded, message.channel, message.target, priority)
            addon.LogDebugMessage("comms_out", string.format("sending message [|cffE7B007%s|r] on channel [%s]", message.event, message.channel))

            --set remaining messages to dispatch in 'n' second intervals
            for i = 2, #Comms.queue do
                Comms.queue[i].dispatchTime = now + ((i - 1) * Comms.queueExtendTime)
                addon.LogDebugMessage("comms", string.format("updated dispatch time for [|cffE7B007%s|r] will dispatch at %s", Comms.queue[i].event, date("%T", Comms.queue[i].dispatchTime)))
            end

            --remove the message
            table.remove(Comms.queue, 1)
            if #Comms.queue == 0 then
                self:SetScript("OnUpdate", nil)
                addon.LogDebugMessage("comms", "Queue is empty, removed OnUpdate script")
            else
                addon.LogDebugMessage("comms", string.format("%d messages left in queue", #Comms.queue))
            end
        end
    end

end


-- local inInstance, instanceType = IsInInstance()
-- if instanceType ~= "none" then
--     local blockCommsDuringInstance = Database:GetConfigSetting("blockCommsDuringInstance");
--     if blockCommsDuringInstance == true then
--         addon:TriggerEvent("OnCommsBlocked", "blocked comms during instance")
--         return;
--     end
-- end
-- local inLockdown = InCombatLockdown()
-- if inLockdown then
--     local blockCommsDuringCombat = Database:GetConfigSetting("blockCommsDuringCombat");
--     if blockCommsDuringCombat == true then
--         addon:TriggerEvent("OnCommsBlocked", "blocked comms during combat")
--         return;
--     end
-- end

---the purpose of this queue function is to provide some relief to the addon comms channel
---if a message with the same type is queued more than once within a period of time (a waiting room if you like)
---the data of the message is kept and then sent after a timer.
---the timer delay is determined by the previous timer to keep messages spaced out
function Comms:QueueMessage(message, channel, target)

    local exists = false;
    for k, v in ipairs(self.queue) do
        --if (v.event == event) and (v.payload.method == message.payload.method) and (v.payload.subKey == message.payload.subKey) then
        if (v.event == message.event) then
            exists = true;
            v.payload = message
            addon.LogDebugMessage("comms", string.format("updated message payload for [|cffE7B007%s|r]", message.event))
        end
    end

    if exists == false then
        local dispatchTime = time() + self.queueWaitingTime
        table.insert(self.queue, {
            event = message.event,
            payload = message,
            channel = channel,
            target = target,
            dispatchTime = dispatchTime;
        })

        addon.LogDebugMessage("comms", string.format("queued [|cffE7B007%s|r] dispatch time %s", message.event, date("%T", dispatchTime)))
    end

    if self.dispatcher:GetScript("OnUpdate") == nil then
        self.dispatcher:SetScript("OnUpdate", self.DispatcherOnUpdate)
    end
end


function Comms:TransmitToTarget(event, data, target)
    local msg = {
        event = event,
        version = Comms.version,
        payload = data,
    }
    Comms:QueueMessage(msg, "WHISPER", target)
end

function Comms:TransmitToGuild(event, data)
    local msg = {
        event = event,
        version = Comms.version,
        payload = data,
    }
    Comms:QueueMessage(msg, "GUILD", nil)
end

function Comms:TransmitCharacterDataChanged(nameRealm, method, key, subKey, data)
    local msg = {
        event = self.characterKeyToEventName[key],
        version = Comms.version,
        payload = {
            method = method,
            key = key,
            subKey = subKey,
            data = data,
            nameRealm = nameRealm,
        },
    }
    Comms:QueueMessage(msg, "GUILD", nil)
end

function Comms:Character_BroadcastNewsEvent(news)
    if type(news) == "table" then
        local msg = {
            event = "CHARACTER_NEWS_BROADCAST",
            version = Comms.version,
            payload = news,
        }
        self:Transmit_NoQueue(msg, "GUILD", nil)
    end
end

function Comms:Transmit_NoQueue(msg, channel, target)
    local serialized = LibSerialize:Serialize(msg);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);
    self:SendCommMessage(self.prefix, encoded, channel, target, "NORMAL")
    addon.LogDebugMessage("comms_out", string.format("No queue message [%s] to %s", (msg.event or "-"), (target or "-")))
end

function Comms:OnCommReceived(prefix, message, distribution, sender)

    if prefix ~= self.prefix then 
        return 
    end
    local decoded = LibDeflate:DecodeForWoWAddonChannel(message);
    if not decoded then
        return;
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded);
    if not decompressed then
        return;
    end
    local success, data = LibSerialize:Deserialize(decompressed);
    if not success or type(data) ~= "table" then
        return;
    end

    local version = tonumber(data.version);

    --print(sender, data.version)
    if type(version) == "number" then

        if version >= self.version then

            --check the event key of the data
            --if we have a function for it then call it
            if Comms.events[data.event] then
                addon:TriggerEvent("StatusText_OnChanged", string.format("received [|cffE7B007%s|r] from %s", data.event, sender))
                Comms.events[data.event](Comms, sender, data)
            end
        else
            
            --inform user of an update?
        end

    end
end


function Comms:Character_OnDataReceived(sender, message)

    addon.LogDebugMessage("comms_in", string.format("[|cffE7B007%s|r] data incoming from %s for character > %s", message.event, sender, message.payload.nameRealm))

    --check we have a character object for the name realm
    if not addon.characters[message.payload.nameRealm] then
        addon.LogDebugMessage("comms_in", "no character found > creating character table")
        if Database.db.characterDirectory[message.payload.nameRealm] then
            addon.characters[message.payload.nameRealm] = Character:CreateFromData(Database.db.characterDirectory[message.payload.nameRealm])
            addon.LogDebugMessage("comms_in", "character created")
        end
    end

    if type(addon.characters[message.payload.nameRealm]) ~= "table" then
        addon.LogDebugMessage("comms_in", "no character found > comms exited")
        return
    end

    local character = addon.characters[message.payload.nameRealm]


    --the version check should prevent issues but worth checking for this
    if message.payload.key then

        --to improve the guild bank sync the container data is now shared on the GUILD channel as its better than looping 999 times and usign a WHISPER 
        --the goal here is to detect if this player should be able to view the data if not then exit

        if message.payload.key == "containers" then

            --to be setup

        else

            --the data will contain the characterObject method, check the function exists
            if character and character[message.payload.method] then
                
                addon.LogDebugMessage("comms_in", string.format("payload.method = %s", message.payload.method))
                
                --if a subKey was sent (talents primary/secondary etc) then check it exists on the characterObject
                if message.payload.subKey then

                    if character.data[message.payload.key] and character.data[message.payload.key][message.payload.subKey] then
                        character.data[message.payload.key][message.payload.subKey] = message.payload.data
                    end

                    addon.LogDebugMessage("comms_in", string.format("using payload.subKey = %s", message.payload.subKey))

                else

                    if message.payload.key then
                        character.data[message.payload.key] = message.payload.data
                    end

                    addon.LogDebugMessage("comms_in", string.format("using payload.key = %s", message.payload.key))
                end

                --because we set the data directly through table keys and not the object methods
                --the object wont trigger a data change event
                -- so we need to manually trigger it
                addon:TriggerEvent("Character_OnDataChanged", character)
            end
        end

    end
end


--Comms will be notified when character data changes
--check its the clients character and proceed with sending data
function Comms:Character_BroadcastChange(character, ...)

    --[[
        the only time a character object is passed the broadcast bool is from this clients player character, or one of their alts
        incoming comms from other guild members wont trigger the broadcast event

        this system will update the character.data[key][subkey] fields as required and notify the object was updated
    ]]

    local method, key, subKey = ...;

    if self.characterKeyToEventName[key] then

        local data;
        if subKey then
            data = character.data[key][subKey]
        else
            data = character.data[key]
        end

        -- DevTools_Dump({
        --     key = key,
        --     subKey = subKey,
        --     data = data,
        -- })

        if data then
            if method == "SetTradeskill" then
                --print("setting tradeskill", key, data)
            end
            self:TransmitCharacterDataChanged(character.data.name, method, key, subKey, data)
            Database:SetCharacterSyncData(key, time())
            addon.LogDebugMessage("comms", string.format("Character_OnDataChanged > %s has changed, sending to comms queue", key))
        else
            addon.LogDebugMessage("comms", string.format("no data found in character.data[%s]", key))
        end

    end
    
end





--feature removed as of cata


function Comms:Guildbank_TimeStampRequest(bank)
    local msg = {
        event = "GUILDBANK_TIMESTAMPS_REQUEST",
        version = self.version,
        payload = {
            bank = bank,
        }
    }
    self:Transmit_NoQueue(msg, "GUILD", nil) --this goes out to everyone, data replies use whisper channel
end

function Comms:Guildbank_OnTimestampsRequested(sender, message)

    local transmit = false;

    if not sender:find("-") then
        local realm = GetNormalizedRealmName()
        sender = string.format("%s-%s", sender, realm)
    end

    --see if this sender has access to any banks
    if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].banks[message.payload.bank] and addon.guilds[addon.thisGuild].bankRules[message.payload.bank] then
        if addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareBags or addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareBank then
            --DevTools_Dump(addon.characters[sender])
            if addon.characters[sender] and addon.characters[sender].data.rank then
                if addon.characters[sender].data.rank <= addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareRank then
                    transmit = true;
                end
            end
        end
    end

    --
    if transmit == true then
        local msg = {
            event = "GUILDBANK_TIMESTAMPS_TRANSMIT",
            version = self.version,
            payload = addon.guilds[addon.thisGuild].banks,
        }
        self:Transmit_NoQueue(msg, "WHISPER", sender)
    end
end

function Comms:Guildbank_OnTimestampsReceived(sender, message)
    addon:TriggerEvent("Guildbank_OnTimestampsReceived", sender, message)
end

function Comms:Guildbank_DataRequest(target, bank)
    local msg = {
        event = "GUILDBANK_DATA_REQUEST",
        version = self.version,
        payload = {
            bank = bank,
        }
    }
    self:Transmit_NoQueue(msg, "WHISPER", target)
end


function Comms:Guildbank_OnDataRequested(sender, message)

    if not sender:find("-") then
        local realm = GetNormalizedRealmName()
        sender = string.format("%s-%s", sender, realm)
    end

    if addon.characters and addon.characters[message.payload.bank] then

        local containers = {
            copper = 0,
            bags = {},
            bank = {},
        }

        --check if sharing gold as this could be different from items
        if addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareCopper then
            containers.copper = addon.characters[message.payload.bank].data.containers.copper
        end
        if addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareBags then
            containers.bags = addon.characters[message.payload.bank].data.containers.bags
        end
        if addon.guilds[addon.thisGuild].bankRules[message.payload.bank].shareBank then
            containers.bank = addon.characters[message.payload.bank].data.containers.bank
        end

        local msg = {
            event = "GUILDBANK_DATA_TRANSMIT",
            version = self.version,
            payload = {
                bank = message.payload.bank,
                containers = containers
            }
        }
        self:Transmit_NoQueue(msg, "WHISPER", sender)
    end
end

function Comms:Guildbank_OnDataReceived(sender, message)
    addon:TriggerEvent("Guildbank_OnDataReceived", sender, message)
end




function Comms:RequestCharacterData(nameRealm, data)
    
    if addon.characters[nameRealm] then
        if addon.characters[nameRealm].data.onlineStatus.isOnline then
            local msg = {
                event = "CHARACTER_DATA_REQUEST",
                version = self.version,
                payload = {
                    requestData = data,
                    target = nameRealm,
                }
            }
            local name = Ambiguate(nameRealm, "full")
            self:Transmit_NoQueue(msg, "WHISPER", name)
            addon.LogDebugMessage("comms", string.format("Sent data request to %s", name))
            addon:TriggerEvent("StatusText_OnChanged", string.format("Sent data request to %s", name))
        end
    end
end

function Comms:Character_OnDataRequest(sender, message)

    addon.LogDebugMessage("comms", string.format("Data request from %s", sender))
    addon:TriggerEvent("StatusText_OnChanged", string.format("Data request from %s", sender))

    if message and message.payload then

        if message.payload.requestData and message.payload.requestData:find(".", nil, true) then
            
            local key, subKey = strsplit(".", message.payload.requestData)
            if type(key) == "string" and type(subKey) == "string" then
                if addon.characters[addon.thisCharacter] and addon.characters[addon.thisCharacter].data[key] and addon.characters[addon.thisCharacter].data[key][subKey] then
                    
                    local msg = {
                        event = "CHARACTER_DATA_RESPONSE",
                        version = self.version,
                        payload = {
                            target = message.payload.target,
                            request = message.payload.requestData,
                            data = addon.characters[addon.thisCharacter].data[key][subKey];
                        }
                    }
                    self:Transmit_NoQueue(msg, "WHISPER", sender)
                    addon.LogDebugMessage("comms", string.format("Sent data response to %s", sender))
                    addon:TriggerEvent("StatusText_OnChanged", string.format("Sent data response to %s", sender))

                end
            else
                addon.LogDebugMessage("comms", string.format("Invalid keys from string split [%s]", sender))
            end
        else
            if addon.characters[addon.thisCharacter] and addon.characters[addon.thisCharacter].data[message.payload.requestData] then

                local msg = {
                    event = "CHARACTER_DATA_RESPONSE",
                    version = self.version,
                    payload = {
                        target = message.payload.target,
                        request = message.payload.requestData,
                        data = addon.characters[addon.thisCharacter].data[message.payload.requestData];
                    }
                }
                self:Transmit_NoQueue(msg, "WHISPER", sender)
                addon.LogDebugMessage("comms", string.format("Sent data response to %s", sender))
                addon:TriggerEvent("StatusText_OnChanged", string.format("Sent data response to %s", sender))
            end
        end

    end
end

function Comms:Character_OnDataResponse(sender, message)

    addon.LogDebugMessage("comms", string.format("Data response from %s", sender))
    addon:TriggerEvent("StatusText_OnChanged", string.format("Data response from %s", sender))

    if message.payload.request and message.payload.request:find(".", nil, true) then
        
        local key, subKey = strsplit(".", message.payload.request)
        if type(key) == "string" and type(subKey) == "string" then
            if message.payload.target and message.payload.data then
                if addon.characters and addon.characters[message.payload.target] then
                    addon.characters[message.payload.target].data[key][subKey] = message.payload.data;
                    addon:TriggerEvent("Character_OnDataChanged", addon.characters[message.payload.target])
                end
            end
        end
        
    else
        if message.payload.target and message.payload.request and message.payload.data then
            if addon.characters and addon.characters[message.payload.target] then
                addon.characters[message.payload.target].data[message.payload.request] = message.payload.data;
                addon:TriggerEvent("Character_OnDataChanged", addon.characters[message.payload.target])
            end
        end
    end

end

-- function Comms:Character_OnNewsBroadcast(sender, message)
--     addon:TriggerEvent("Character_OnNewsEvent", message.payload, sender)
-- end


local function encodeMessage(msg)
    local serialized = LibSerialize:Serialize(msg);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed); 
    return encoded;
end



--[[
    EVENT CREATED
]]
function Comms:TransmitCalendarEvent_Created(calendarEvent)
    local msg = {
        event = "CALENDAR_EVENT_CREATED",
        version = Comms.version,
        payload = calendarEvent
    }
    --the Comms queue system has a slight flaw if we try to use it for calendar events
    --the queue checks for the message event string and updates the data if another mesage of that event is queued
    --if this player creates and event, he message is queued, then they make another event, the first message is updated with the new data

    --[[
        TODO: consider if a new queue needs to be created for calendar events or if they are ok to just send without delay
        the no delay option does mean potentially better sync for guild members calendars
    ]]
    
    self:SendCommMessage(Comms.prefix, encodeMessage(msg), "GUILD", nil, "NORMAL")
end

function Comms:OnCalendarEventCreated(sender, message)

    --DevTools_Dump(message)

    if type(message) == "table" then

        --this will just do nothing if the calendar event already exists
        --the Database will check for this events ID and return out if it exists
        --print("Comms.OnCalendarEventCreated", message.payload.id)
        C_Calendar.CalendarEventCreate(message.payload)
    end
end

--[[
    EVENT DELETED
]]
function Comms:TransmitCalendarEvent_Deleted(calendarEventID)
    local msg = {
        event = "CALENDAR_EVENT_DELETED",
        version = Comms.version,
        payload = calendarEventID
    }

    self:SendCommMessage(Comms.prefix, encodeMessage(msg), "GUILD", nil, "NORMAL")
end

function Comms:OnCalendarEventDeleted(sender, message)

    --DevTools_Dump(message)
    
    if type(message) == "table" then

        --print("Comms.OnCalendarEventDeleted", message.payload)
        C_Calendar.DeleteCalendarEventID(message.payload)
    end
end

--[[
    ATTENDING CHANGED
]]
function Comms:TransmitCalendarEvent_AttendingChanged(eventID, nameRealm, statusInfo)
    local msg = {
        event = "CALENDAR_EVENT_ATTENDING_CHANGED",
        version = Comms.version,
        payload = {
            id = eventID,
            nameRealm = nameRealm,
            statusInfo = statusInfo, --this is a table with the status info
        }
    }
    self:SendCommMessage(Comms.prefix, encodeMessage(msg), "GUILD", nil, "NORMAL")
end

function Comms:OnCalendarEventAttendingChange(sender, message)

    --print("Comms.OnCalendarEventAttendingChange", sender)

    if type(message) == "table" then
        local success = C_Calendar.OnCalendarEventAttendingChanged(message.payload);

        --if we didnt have this event, we couldn't update it so request it
        if success == false then
            self:TransmitCalendarEvent_DataRequest(sender, message.payload.id)
        end
    end
end

--[[
    EVENT CHANGED
]]
function Comms:TransmitCalendarEvent_Changed(eventInfo)
    local msg = {
        event = "CALENDAR_EVENT_CHANGED",
        version = Comms.version,
        payload = eventInfo,
    }
    self:SendCommMessage(Comms.prefix, encodeMessage(msg), "GUILD", nil, "NORMAL")
end

--this is when the event owner changes the title desc or time
function Comms:OnCalendarEventChanged(sender, message)
    if type(message) == "table" then
        local success = C_Calendar.OnCalendarEventChanged(message.payload);

        --if we didnt have this event, we couldn't update it so request it
        if success == false then
            self:TransmitCalendarEvent_DataRequest(sender, message.payload.id)
        end
    end
end


--[[
    REQUEST EVENT DATA
]]
function Comms:TransmitCalendarEvent_DataRequest(sender, eventID)
    local msg = {
        event = "CALENDAR_REQUEST_EVENT_DATA",
        version = Comms.version,
        payload = eventID,
    }
    if sender == "GUILD" then
        self:SendCommMessage(Comms.prefix, encodeMessage(msg), "GUILD", nil, "NORMAL")
    else
        self:SendCommMessage(Comms.prefix, encodeMessage(msg), "WHISPER", sender, "NORMAL")
    end
end

--transmit data using the eventID
function Comms:OnCalendarEventRequestData(sender, message)
    --the sender didnt have the event so we need to send it to them
    if type(message) == "table" then
        if addon.calendarEvents and addon.calendarEvents[message.payload] then
            local msg = {
                event = "CALENDAR_EVENT_DATA_FULL",
                version = Comms.version,
                payload = addon.calendarEvents[message.payload]:GetData(), --GetData() return the obj.data which is a full event data table
            }
            self:SendCommMessage(Comms.prefix, encodeMessage(msg), "WHISPER", sender, "NORMAL")
        end
    end
end

function Comms:OnCalendarEventDataReceived(sender, message)
    if type(message) == "table" then
        C_Calendar.OnCalendarEventDataReceived(sender, message.payload)
    end
end


--[[
    REQUEST ALL EVENTS
]]
function Comms:RequestCalendarEvents()
    local msg = {
        --event = "CALENDAR_VERSION_REQUEST",
        event = "CALENDAR_DATA_REQUEST",
        version = Comms.version,
    }
    self:QueueMessage(msg, "GUILD")
end


--somebody wants event data so send it to them
function Comms:OnCalendarEventsRequested(sender, message)

    local calendarEvents = C_Calendar.GetCalendarEvents()
    if (#calendarEvents > 0) then
        -- local msg = {
        --     --event = "CALENDAR_VERSION_DATA",
        --     event = "CALENDAR_EVENT_DATA",
        --     version = Comms.version,
        --     payload = calendarEventVersions,
        -- }
        -- self:SendCommMessage(Comms.prefix, encodeMessage(msg), "WHISPER", sender, "NORMAL")

        local index = 1
        C_Timer.NewTicker(4.0, function()

            --print("sending event data", index, #calendarEvents)
        
            if calendarEvents[index] then
                local msg = {
                    event = "CALENDAR_EVENT_DATA_FULL", -- this falls through to Comms:OnCalendarEventDataReceived(sender, message)
                    version = Comms.version,
                    payload = calendarEvents[index]:GetData(),
                }
                self:SendCommMessage(Comms.prefix, encodeMessage(msg), "WHISPER", sender, "NORMAL")
            end

            index = index + 1;
        end, #calendarEvents)
    end
end

--incoming event version data, send it to the C_Calendar to process
-- function Comms:OnCalendarVersionsReceived(sender, message)
--     if type(message) == "table" then
--         C_Calendar.OnCalendarVersionsReceived(sender, message.payload)
--     end
-- end




--when a comms is received check the event type and pass to the relavent function
Comms.events = {

    CHARACTER_DATA_REQUEST = Comms.Character_OnDataRequest,
    CHARACTER_DATA_RESPONSE = Comms.Character_OnDataResponse,

    --CHARACTER_NEWS_BROADCAST = Comms.Character_OnNewsBroadcast,

    --character events
    --CONTAINERS_TRANSMIT = Comms.Character_OnDataReceived,
    INVENTORY_TRANSMIT = Comms.Character_OnDataReceived,
    PAPERDOLL_STATS_TRANSMIT = Comms.Character_OnDataReceived,
    RESISTANCE_TRANSMIT = Comms.Character_OnDataReceived,
    AURA_TRANSMIT = Comms.Character_OnDataReceived,
    TALENT_TRANSMIT = Comms.Character_OnDataReceived,
    GLYPH_TRANSMIT = Comms.Character_OnDataReceived,
    SPEC_TRANSMIT = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF1 = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF1_LEVEL = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF1_SPEC = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF1_RECIPES = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF2 = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF2_LEVEL = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF2_SPEC = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_PROF2_RECIPES = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_COOKING_LEVEL = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_COOKING_RECIPES = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_FISHING_LEVEL = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_FIRSTAID_LEVEL = Comms.Character_OnDataReceived,
    TRADESKILL_TRANSMIT_FIRSTAID_RECIPES = Comms.Character_OnDataReceived,

    ALTS_TRANSMIT = Comms.Character_OnDataReceived,
    MAIN_CHARACTER_TRANSMIT = Comms.Character_OnDataReceived,

    --calendar events
    CALENDAR_DATA_REQUEST = Comms.OnCalendarEventsRequested,
    --CALENDAR_VERSION_DATA = Comms.OnCalendarVersionsReceived,
    CALENDAR_EVENT_CHANGED = Comms.OnCalendarEventChanged,
    CALENDAR_EVENT_CREATED = Comms.OnCalendarEventCreated,
    CALENDAR_EVENT_DATA_FULL = Comms.OnCalendarEventDataReceived,
    CALENDAR_EVENT_DELETED = Comms.OnCalendarEventDeleted,
    CALENDAR_EVENT_ATTENDING_CHANGED = Comms.OnCalendarEventAttendingChange,
    CALENDAR_REQUEST_EVENT_DATA = Comms.OnCalendarEventRequestData,
 

    --guild bank events
    GUILDBANK_TIMESTAMPS_REQUEST = Comms.Guildbank_OnTimestampsRequested,
    GUILDBANK_DATA_REQUEST = Comms.Guildbank_OnDataRequested,
    GUILDBANK_TIMESTAMPS_TRANSMIT = Comms.Guildbank_OnTimestampsReceived,
    GUILDBANK_DATA_TRANSMIT = Comms.Guildbank_OnDataReceived,
}

addon:RegisterCallback("Guildbank_DataRequest", Comms.Guildbank_DataRequest, Comms)
addon:RegisterCallback("Guildbank_TimeStampRequest", Comms.Guildbank_TimeStampRequest, Comms)
addon:RegisterCallback("Character_BroadcastChange", Comms.Character_BroadcastChange, Comms)
addon:RegisterCallback("Database_OnInitialised", Comms.Init, Comms)
--addon:RegisterCallback("Database_OnNewsEventAdded", Comms.Character_BroadcastNewsEvent, Comms)

addon.Comms = Comms;