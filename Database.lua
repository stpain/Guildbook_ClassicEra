local name, addon = ...;

local json = LibStub('JsonLua-1.0');

local Database = {}

local configUpdates = {

    --tradeskills
    tradeskillsRecipesListviewShowItemID = false,
    tradeskillsShareCooldowns = false,
    tradeskillsShowAllRecipeInfoTooltip = false,
    tradeskillsShowMyRecipeInfoTooltip = false,
    tradeskillsShowAllRecipesUsingTooltip = false,
    tradeskillsShowMyRecipesUsingTooltip = false,

    --settings
    chatGuildHistoryLimit = 30,
    chatWhisperHistoryLimit = 30,

    guildbankAutoShareItems = false,

    modBlizzRoster = false,
    blizzRosterShowOffline = false,

    enableItemLists = true,
}

local dbUpdates = {
    calendar = {
        events = {},
    },
    dailies = {
        quests = {},
        characters = {},
    },
    chats = { --some errors about this causing a bug, maybe old version not getting update in the past
        guild = {},
        guildOfficer = {},
    },
    --agenda = {},
    news = {},

    itemLists = {},

    --can also use a string for sub keys
    --added to fix errors where a key exists but not a new sub key
    ["chats.guildOfficer"] = {},


    recruitment = {},
}
local dbToRemove = {
    "worldEvents",
    "calendar.birthdays"
}

function Database:Init()

    local version = tonumber(C_AddOns.GetAddOnMetadata(name, "Version"));
    if not version then
        version = 0.1
    end

    if not GUILDBOOK_GLOBAL then
        GUILDBOOK_GLOBAL = {
            config = {
                chatGuildHistoryLimit = 50,
                chatWhisperHistoryLimit = 50,
            },
            minimapButton = {},
            calendarButton = {},
            guilds = {},
            myCharacters = {},
            characterDirectory = {},
            chats = {
                guild = {},
                guildOfficer = {},
            },
            debug = false,
            version = version,
            calendar = {
                events = {},
            },
            dailies = {
                quests = {},
                characters = {},
            },
        }
    end

    --potential bug with users who have older saved variable
    if not GUILDBOOK_GLOBAL.version then
        GUILDBOOK_GLOBAL.version = version;
    end

    self.db = GUILDBOOK_GLOBAL;

    for k, v in pairs(dbUpdates) do
        if k:find(".", nil, true) then
            local k1, k2 = strsplit(".", k)
            if k1 and k2 then
                if self.db[k1] then
                    self.db[k1][k2] = v
                end
            end
        else
            if not self.db[k] then
                self.db[k] = v;
            end
        end
    end
    for k, v in ipairs(dbToRemove) do
        if v:find(".") then
            local k1, k2 = strsplit(".", v)
            if k1 and k2 then
                if self.db[k1] and self.db[k1][k2] then
                    self.db[k1][k2] = nil
                    addon.LogDebugMessage("warning", string.format("removed %s from %s", k2, k1))
                end
            end
        else
            self.db[v] = nil;
            addon.LogDebugMessage("warning", string.format("removed %s from db", v))
        end
    end

    for k, v in pairs(configUpdates) do
        if not self.db.config[k] then
            self.db.config[k] = v;
        end
    end

    --there might be old data so clear it out
    if type(GUILDBOOK_CHARACTER) == "table" then
        if not GUILDBOOK_CHARACTER.syncData then
            GUILDBOOK_CHARACTER = nil;
        end
    end


    --per character settings
    if not GUILDBOOK_CHARACTER then
        GUILDBOOK_CHARACTER = {
            syncData = {
                mainCharacter = 0,
                publicNote = 0,
                mainSpec = 0,
                offSpec = 0,
                mainSpecIsPvP = 0,
                offSpecIsPvP = 0,
                profile = 0,
                profession1 = 0,
                profession1Level = 0,
                profession1Spec = 0,
                profession1Recipes = 0,
                profession2 = 0,
                profession2Level = 0,
                profession2Spec = 0,
                profession2Recipes = 0,
                cookingLevel = 0,
                cookingRecipes = 0,
                fishingLevel = 0,
                firstAidLevel = 0,
                firstAidRecipes = 0,
                talents = 0,
                glyphs = 0,
                inventory = 0,
                paperDollStats = 0,
                resistances = 0,
                auras = 0,
                containers = 0,
                lockouts = 0,
            },
        }
    end

    self.charDb = GUILDBOOK_CHARACTER;


    addon:TriggerEvent("StatusText_OnChanged", "[Database_OnInitialised]")
    addon:TriggerEvent("Database_OnInitialised")
end

function Database:CleanGuilds()
    if self.db then
        for guildName, guild in pairs(self.db.guilds) do
            guild.info = nil
            guild.logs = {}
            guild.calendar = {}
        end
    end
end

function Database:DeleteList(list)
    if self.db and self.db.itemLists and self.db.itemLists[list] then
        self.db.itemLists[list] = nil;
    end
end

function Database:AddItemToList(list, item)
    if self.db and self.db.itemLists then
        if not self.db.itemLists[list] then
            self.db.itemLists[list] = {}
        end
        table.insert(self.db.itemLists[list], item)
    end
end

function Database:GetItemLists()
    if self.db and self.db.itemLists then
        return self.db.itemLists
    end
    return {};
end

function Database:GetItemListItems(list)
    if self.db and self.db.itemLists then
        return self.db.itemLists[list] or {};
    end
end

function Database:UpdateGuildbankRules(guild, bank, rules)
    if self.db and self.db.guilds[guild] then
        self.db.guilds[guild].bankRules[bank] = rules
        addon:TriggerEvent("StatusText_OnChanged", string.format("[UpdateGuildbankRules] set rules for %s", bank))

        --remove data as per rule changes
        if addon.thisCharacter and (bank ~= addon.thisCharacter) then
            if addon.characters and addon.characters[bank] then
                if rules.shareBags == false then
                    addon.characters[bank].data.containers.bags = {
                        items = {
                        },
                        slotsFree = 0,
                        slotsUsed = 0,
                    }
                    addon:TriggerEvent("StatusText_OnChanged", string.format("[UpdateGuildbankRules] removed bags data %s", bank))
                end
                if rules.shareBanks == false then
                    addon.characters[bank].data.containers.bank = {
                        items = {
                        },
                        slotsFree = 0,
                        slotsUsed = 0,
                    }
                    addon:TriggerEvent("StatusText_OnChanged", string.format("[UpdateGuildbankRules] removed banks data %s", bank))
                end
            end
        end
    end
end

function Database:Reset()

    GUILDBOOK_GLOBAL = nil;

    addon.guilds = {}
    addon.characters = {}

    self:Init()
end

function Database:InsertNewsEvent(event)
    if self.db and self.db.news then
        event.timestamp = time()
        table.insert(self.db.news, 1, event)
        addon:TriggerEvent("Database_OnNewsEventAdded", event)
    end
end

function Database:ResetKey(key, newVal)
    if self.db[key] then
        self.db[key] = newVal;
    end
end

function Database:ImportData(data)
    local import = json.decode(data)
    if import then
        if import.name and import.data and import.version then
            DevTools_Dump(import)
        end
    end
end

function Database:ExportData(key)
    if key and self.db[key] then
        local export = json.encode(self.db[key])
        return export
    end
end

function Database:InsertCharacter(character)
    if self.db then
        self.db.characterDirectory[character.name] = character;
        addon:TriggerEvent("StatusText_OnChanged", string.format("[InsertCharacter] %s", character.name))
    end
end

function Database:DeleteCharacter(nameRealm)
    if self.db then
         if self.db.characterDirectory[nameRealm] then
            self.db.characterDirectory[nameRealm] = nil;
                if addon.characters[nameRealm] then
                    addon.characters[nameRealm] = nil;
                end
            addon:TriggerEvent("Database_OnCharacterRemoved", nameRealm)
         end
    end
end

function Database:GetCharacter(nameRealm)
    if self.db and self.db.characterDirectory[nameRealm] then
        return self.db.characterDirectory[nameRealm];
    end
end

function Database:GetCharacterNameFromGUID(guid)
    if self.db and self.db.characterDirectory then
        for nameRealm, data in pairs(self.db.characterDirectory) do
            if data.guid and (data.guid == guid) then
                return nameRealm;
            end
        end
    end
end


--failed approach
function Database:GetCharacterGuild(nameRealm)
    if self.db then
        for guildName, info in pairs(self.db.guilds) do
            for name, _ in pairs(info.members) do
                if name == nameRealm then
                    return guildName
                end
            end
        end
    end
    return "unknown";
end

function Database:InsertCalendarEvent(event)
    if self.db and self.db.calendar then
        if not self.db.calendar.events then
            self.db.calendar.events = {}
        end
        event.guid = string.format("CalendarEvent-%s", time())
        table.insert(self.db.calendar.events, event)
        addon:TriggerEvent("Database_OnCalendarDataChanged")
    end
end

function Database:DeleteCalendarEvent(event)
    if self.db and self.db.calendar and self.db.calendar.events then
        local keyToRemove;
        for k, v in ipairs(self.db.calendar.events) do
            if (v.guid == event.guid) then
                keyToRemove = k
            end
        end
        if keyToRemove then
            table.remove(self.db.calendar.events, keyToRemove)
            addon:TriggerEvent("Database_OnCalendarDataChanged")
        end
    end
end

function Database:GetCalendarEventsBetween(_from, _to)

    local t = {}
    if not _to then
        _to = _from
    end
    local from = time(_from)
    local to = time(_to)
    if self.db and self.db.calendar and self.db.calendar.events then
        for k, event in ipairs(self.db.calendar.events) do
            if (event.timestamp >= from) and (event.timestamp <= to) then
                table.insert(t, event)
            end
        end
    end
    return t;
end

function Database:GetCalendarEventsForPeriod(fromTimestamp, period)

    local t = {}
    period = period or 1
    local to = fromTimestamp + (60*60*24*period)

    if self.db and self.db.calendar and self.db.calendar.events then
        for k, event in ipairs(self.db.calendar.events) do
            if (event.timestamp >= fromTimestamp) and (event.timestamp <= to) then
                table.insert(t, event)
            end
        end
    end
    return t;
end

function Database:SetConfig(conf, val)
    if self.db and self.db.config then
        self.db.config[conf] = val
        addon:TriggerEvent("Database_OnConfigChanged", conf, val)
    end
end

function Database:GetConfig(conf)
    if self.db and self.db.config then
        return self.db.config[conf];
    end
    return false;
end

function Database:GetDailyQuestInfo(questID)
    if self.db and self.db.dailies and self.db.dailies.quests[questID] then
        return self.db.dailies.quests[questID]
    end
    return false;
end

function Database:GetDailyQuestIDsForCharacter(nameRealm, onlyFavourites)
    local t = {}
    if self.db and self.db.dailies and self.db.dailies.characters[nameRealm] then
        for questID, turnInInfo in pairs(self.db.dailies.characters[nameRealm]) do
            if onlyFavourites then
                if onlyFavourites == turnInInfo.isFavorite then
                    table.insert(t, questID)
                end
            else
                table.insert(t, questID)
            end
        end
    end
    return t;
end

function Database:GetDailyQuestInfoForCharacter(nameRealm, onlyFavourites)
    local t = {}
    if self.db and self.db.dailies and self.db.dailies.characters[nameRealm] then
        for questID, turnInInfo in pairs(self.db.dailies.characters[nameRealm]) do
            local turnIn = {}
            for k, v in pairs(turnInInfo) do
                turnIn[k] = v;
            end
            turnIn.questID = questID;
            if onlyFavourites then
                if onlyFavourites == turnInInfo.isFavorite then
                    table.insert(t, turnIn)
                end
            else
                table.insert(t, turnIn)
            end
        end
    end
    return t;
end

function Database:SetCharacterSyncData(key, val)
    if self.charDb then
        self.charDb.syncData[key] = val;
    end
end


function Database:GetCharacterSyncData(key)
    if self.charDb then
        return self.charDb.syncData[key];
    end
    return 0;
end





function Database:InsertRecruitmentCSV(csv)
    if self.db and self.db.recruitment then
        
        local existingEntries = {}
        for k, v in ipairs(self.db.recruitment) do
            existingEntries[v.name] = true;
        end

        for k, v in ipairs(csv) do
            if not existingEntries[v.name] then
                table.insert(self.db.recruitment, v)
            end
        end
    end
end

function Database:DeleteAllRecruit()
    if self.db and self.db.recruitment then
        self.db.recruitment = {}
    end
end

function Database:GetAllRecruitment()
    if self.db and self.db.recruitment then
        return self.db.recruitment;
    end
    return {};
end

function Database:CleanUpRecruitment()
    if self.db and self.db.recruitment then
        for k, v in ipairs(self.db.recruitment) do
            v.isSelected = nil;
        end
    end
end



addon.Database = Database;