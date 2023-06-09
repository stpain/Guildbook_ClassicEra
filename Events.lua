local name, addon = ...;

local Guild = addon.Guild;
local Character = addon.Character;
local Database = addon.Database;
local Talents = addon.Talents;
local Tradeskills = addon.Tradeskills;

local e = CreateFrame("FRAME");
e:RegisterEvent('GUILD_ROSTER_UPDATE')
e:RegisterEvent('GUILD_RANKS_UPDATE')
e:RegisterEvent('ADDON_LOADED')
e:RegisterEvent('PLAYER_ENTERING_WORLD')
e:RegisterEvent('PLAYER_LEVEL_UP')
e:RegisterEvent('TRADE_SKILL_UPDATE')
e:RegisterEvent('TRADE_SKILL_SHOW')
e:RegisterEvent('CRAFT_UPDATE')
e:RegisterEvent('RAID_ROSTER_UPDATE')
e:RegisterEvent('BANKFRAME_OPENED')
e:RegisterEvent('BANKFRAME_CLOSED')
--e:RegisterEvent('BAG_UPDATE')
e:RegisterEvent('BAG_UPDATE_DELAYED')
e:RegisterEvent('CHAT_MSG_GUILD')
e:RegisterEvent('CHAT_MSG_WHISPER')
e:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
e:RegisterEvent('CHAT_MSG_SYSTEM')
e:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
e:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
e:RegisterEvent('ZONE_CHANGED_NEW_AREA')
e:RegisterEvent('CHARACTER_POINTS_CHANGED')
e:RegisterEvent('UNIT_AURA')
e:RegisterEvent("PLAYER_REGEN_DISABLED")
e:RegisterEvent("PLAYER_REGEN_ENABLED")
e:RegisterEvent("SKILL_LINES_CHANGED")

e:SetScript("OnEvent", function(self, event, ...)
    if self[event] then
        self[event](self, ...)
    end
end)

function e:PLAYER_REGEN_DISABLED()
    addon:TriggerEvent("Player_Regen_Disabled")
end

function e:PLAYER_REGEN_ENABLED()
    addon:TriggerEvent("Player_Regen_Enabled")
end

function e:CHAT_MSG_WHISPER_INFORM(...)
    local msg, target = ...;
    local guid = select(12, ...)
    addon:TriggerEvent("Chat_OnMessageSent", {
        target = target,
        message = msg,
        guid = guid,
        channel = "whisper",
    })
end

function e:CHAT_MSG_WHISPER(...)
    local msg, sender = ...;
    local guid = select(12, ...)
    addon:TriggerEvent("Chat_OnMessageReceived", {
        sender = sender,
        message = msg,
        guid = guid,
        channel = "whisper",
    })
end

function e:CHAT_MSG_GUILD(...)
    local msg, sender = ...;
    local guid = select(12, ...)
    addon:TriggerEvent("Chat_OnMessageReceived", {
        sender = sender,
        message = msg,
        guid = guid,
        channel = "guild",
    })
end

--[[
--- not used at the moment
function Guildbook.GetInstanceInfo()
    local t = {}
    if GetNumSavedInstances() > 0 then
        for i = 1, GetNumSavedInstances() do
            local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
            tinsert(t, { Name = name, ID = id, Resets = reset, Encounters = numEncounters, Progress = encounterProgress })
            local msg = string.format("name=%s, id=%s, reset=%s, difficulty=%s, locked=%s, numEncounters=%s", tostring(name), tostring(id), tostring(reset), tostring(difficulty), tostring(locked), tostring(numEncounters))
            --print(msg)
        end
    end
    return t
end

function Guildbook:CHAT_MSG_SYSTEM(...)
    local msg = ...
    local onlineMsg = ERR_FRIEND_ONLINE_SS:gsub("%[",""):gsub("%]",""):gsub("%%s", ".*") ERR_GUILD_DEMOTE_SSS:gsub("%[",""):gsub("%]",""):gsub("%%s", ".*")
    if msg:find(onlineMsg) then
        local name, _ = strsplit(" ", msg)
        local brokenLink = name:sub(2, #name-1)
        local player = brokenLink:sub(brokenLink:find(":")+1, brokenLink:find("%[")-1)
        if player then
            if not self.onlineMembers then
                self.onlineMembers = {}
            end
            self.onlineMembers[player] = true
            DEBUG("event", "CHAT_MSG_SYSTEM", string.format("set %s as online", player))
        end
    end
    local offlineMsg = ERR_FRIEND_OFFLINE_S:gsub("%%s", ".*")
    if msg:find(offlineMsg) then
        local player, _ = strsplit(" ", msg)
        if player then
            if not self.onlineMembers then
                self.onlineMembers = {}
            end
            self.onlineMembers[player] = false
            DEBUG("event", "CHAT_MSG_SYSTEM", string.format("set %s as offline", player))
        end
    end
end

ERR_GUILDEMBLEM_COLORSPRESENT = "Your guild already has an emblem!";
ERR_GUILDEMBLEM_INVALIDVENDOR = "That's not an emblem vendor!";
ERR_GUILDEMBLEM_INVALID_TABARD_COLORS = "Invalid Guild Emblem colors.";
ERR_GUILDEMBLEM_NOGUILD = "You are not part of a guild!";
ERR_GUILDEMBLEM_NOTENOUGHMONEY = "You can't afford to do that.";
ERR_GUILDEMBLEM_NOTGUILDMASTER = "Only guild leaders can create emblems.";
ERR_GUILDEMBLEM_SAME = "Not saved, your tabard is already like that.";
ERR_GUILDEMBLEM_SUCCESS = "Guild Emblem saved.";
ERR_GUILD_ACCEPT = "You have joined the guild.";
ERR_GUILD_AND_COMMUNITIES_UNAVAILABLE = "Guilds and Communities are currently unavailable";
ERR_GUILD_BANK_BOUND_ITEM = "You cannot store soulbound items in the guild bank";
ERR_GUILD_BANK_CONJURED_ITEM = "You cannot store conjured items in the guild bank";
ERR_GUILD_BANK_EQUIPPED_ITEM = "You must unequip that item first";
ERR_GUILD_BANK_FULL = "This guild bank tab is full";
ERR_GUILD_BANK_QUEST_ITEM = "You cannot store quest items in the guild bank";
ERR_GUILD_BANK_VOUCHER_FAILED = "You must purchase all guild bank tabs before using this voucher.";
ERR_GUILD_BANK_WRAPPED_ITEM = "You cannot store wrapped items in the guild bank";
ERR_GUILD_BANK_WRONG_TAB = "Incorrect bank tab";
ERR_GUILD_CREATE_S = "%s created.";
ERR_GUILD_DECLINE_AUTO_S = "%s is declining all guild invitations.";
ERR_GUILD_DECLINE_S = "%s declines your guild invitation.";
ERR_GUILD_DEMOTE_SS = "%s  has been demoted to %s.";
ERR_GUILD_DEMOTE_SSS = "%s has demoted %s to %s.";
ERR_GUILD_DISBANDED = "Guild has been disbanded.";
ERR_GUILD_DISBAND_S = "%s has disbanded the guild.";
ERR_GUILD_DISBAND_SELF = "You have disbanded the guild.";
ERR_GUILD_FOUNDER_S = "Congratulations, you are a founding member of %s!";
ERR_GUILD_INTERNAL = "Internal guild error.";
ERR_GUILD_INVITE_S = "You have invited %s to join your guild.";
ERR_GUILD_INVITE_SELF = "You can't invite yourself to a guild.";
ERR_GUILD_JOIN_S = "%s has joined the guild.";
ERR_GUILD_LEADER_CHANGED_SS = "%s has made %s the new Guild Master.";
ERR_GUILD_LEADER_IS_S = "%s is the leader of your guild.";
ERR_GUILD_LEADER_LEAVE = "You must promote a new Guild Master using /gleader before leaving the guild.";
ERR_GUILD_LEADER_REPLACED = "Because the previous guild master %s has not logged in for an extended time, %s has become the new Guild Master.";
ERR_GUILD_LEADER_S = "%s has been promoted to Guild Master.";
ERR_GUILD_LEADER_SELF = "You are now the Guild Master.";
ERR_GUILD_LEAVE_RESULT = "You have left the guild.";
ERR_GUILD_LEAVE_S = "%s has left the guild.";
ERR_GUILD_NAME_EXISTS_S = "There is already a guild named \"%s\".";
ERR_GUILD_NAME_INVALID = "Invalid guild name.";
ERR_GUILD_NOT_ALLIED = "Only Battle.net friends can be invited from the opposing faction.";
ERR_GUILD_NOT_ENOUGH_MONEY = "The guild bank does not have enough money";
ERR_GUILD_PERMISSIONS = "You don't have permission to do that.";
ERR_GUILD_PLAYER_NOT_FOUND_S = "\"%s\" not found.";
ERR_GUILD_PLAYER_NOT_IN_GUILD = "You are not in a guild.";
ERR_GUILD_PLAYER_NOT_IN_GUILD_S = "%s is not in your guild.";
ERR_GUILD_PROMOTE_SSS = "%s has promoted %s to %s.";
ERR_GUILD_QUIT_S = "You are no longer a member of %s.";
ERR_GUILD_RANKS_LOCKED = "Temporary guild error.  Please try again!";
ERR_GUILD_RANK_IN_USE = "That guild rank is currently in use.";
ERR_GUILD_RANK_TOO_HIGH_S = "%s's rank is too high";
ERR_GUILD_RANK_TOO_LOW_S = "%s is already at the lowest rank";
ERR_GUILD_REMOVE_SELF = "You have been kicked out of the guild.";
ERR_GUILD_REMOVE_SS = "%s has been kicked out of the guild by %s.";
ERR_GUILD_REP_TOO_LOW = "Your guild reputation isn't high enough to do that.";
ERR_GUILD_TOO_MUCH_MONEY = "The guild bank is at gold limit";
ERR_GUILD_TRIAL_ACCOUNT_TRIAL = "Free Trial accounts cannot join guilds.";
ERR_GUILD_TRIAL_ACCOUNT_VETERAN = "This account cannot join guilds without an existing character in the guild.";
ERR_GUILD_UNDELETABLE_DUE_TO_LEVEL = "Your guild is too high level to be deleted.";
ERR_GUILD_WITHDRAW_LIMIT = "You cannot withdraw that much from the guild bank.";

]]

function e:ADDON_LOADED()
    
    --hooks
    -- GuildFramePromoteButton:HookScript("OnClick", function()
    
    -- end)
    -- GuildFrameDemoteButton:HookScript("OnClick", function()
    
    -- end)

end


function e:CHAT_MSG_SYSTEM(...)
    local msg = ...
    if msg:find(ERR_GUILD_DEMOTE_SSS:gsub("%%s", "(.*)")) then
        local who, _, _, member, _, rank = strsplit(" ", msg)
        print("guild demote", who, member, rank)

    elseif msg:find(ERR_GUILD_PROMOTE_SSS:gsub("%%s", "(.*)")) then
        local who, _, _, member, _, rank = strsplit(" ", msg)
        print("guild promote", who, member, rank)

    elseif msg:find(ERR_GUILD_JOIN_S:gsub("%%s", "(.*)")) then
        local who = strsplit(" ", msg)
        print("guild join", who)
    end
end

function e:GUILD_RANKS_UPDATE()
    
end

--[[
    GUILD BANK EVENTS

    the job here is to scan the players bags and bank if they have the guildbank keyword in their public not
]]
local bankScanned = false
function e:BANKFRAME_CLOSED()
    if bankScanned == false then
        if addon.characters[addon.thisCharacter] then
            local bags = addon.api.classic.scanPlayerContainers(true)
    
            if addon.guilds[addon.thisGuild] then
                addon.guilds[addon.thisGuild].banks[addon.thisCharacter] = time();
    
                if not addon.guilds[addon.thisGuild].bankRules[addon.thisCharacter] then
                    addon.guilds[addon.thisGuild].bankRules[addon.thisCharacter] = {
                        shareBags = false,
                        shareBank = false,
                        shareCopper = false,
                        shareRank = 0,
                    }
                    print("No rules exist for this Guild Bank, items scanned but not shared, go to settings to select rules")
                end

            end
            addon.characters[addon.thisCharacter]:SetContainers(bags)
        end
    end
    bankScanned = not bankScanned;
end
function e:BANKFRAME_OPENED()
    if addon.characters[addon.thisCharacter] then
        local bags = addon.api.classic.scanPlayerContainers(true)
        DevTools_Dump(bags)
        if addon.guilds[addon.thisGuild] then
            addon.guilds[addon.thisGuild].banks[addon.thisCharacter] = time();

            if not addon.guilds[addon.thisGuild].bankRules[addon.thisCharacter] then
                addon.guilds[addon.thisGuild].bankRules[addon.thisCharacter] = {
                    shareBags = false,
                    shareBank = false,
                    shareCopper = false,
                    shareRank = 0,
                }
                print("No rules exist for this Guild Bank, items scanned but not shared, go to settings to select rules")
            end

            addon.characters[addon.thisCharacter]:SetContainers(bags)
        end
        addon.characters[addon.thisCharacter]:SetContainers(bags)
    end
end

--this means you can view your alts items
function e:BAG_UPDATE_DELAYED()
    if addon.characters and addon.characters[addon.thisCharacter] then
        local bags = addon.api.classic.scanPlayerContainers()
        addon.characters[addon.thisCharacter]:SetContainers(bags)
    end
end


--dont need to send aura info everytime they change
function e:UNIT_AURA()
    -- local auras = addon.api.classic.getPlayerAuras()
    -- if addon.characters[addon.thisCharacter] then
    --     addon.characters[addon.thisCharacter]:SetAuras("current", auras)
    -- end
end

function e:PLAYER_EQUIPMENT_CHANGED()

    --when equipment changes it can change stats, resistances so grab those as well
    local equipment = addon.api.classic.getPlayerEquipment()
    local currentStats = addon.api.classic.getPaperDollStats()
    local resistances = addon.api.classic.getPlayerResistances(UnitLevel("player"))
    local auras = addon.api.classic.getPlayerAuras()

    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetInventory("current", equipment, true)
        addon.characters[addon.thisCharacter]:SetPaperdollStats("current", currentStats, true)
        addon.characters[addon.thisCharacter]:SetResistances("current", resistances, true)
        addon.characters[addon.thisCharacter]:SetAuras("current", auras, true)
    end
end

function e:CHARACTER_POINTS_CHANGED(delta)
    if delta == 1 then
        --leveled up
        --addon.characters[addon.thisCharacter]:SetLevel()
    end
    local talents = addon.api.classic.getPlayerTalents()
    --DevTools_Dump(talents)
    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetTalents("current", talents, true)
    end
end

function e:ZONE_CHANGED_NEW_AREA()
    --print("zone changed")
	local mapID = C_Map.GetBestMapForUnit("player")
    if type(mapID) == "number" then
        local zone = C_Map.GetMapInfo(mapID).name
        --print(GetZoneText(), zone)
        if zone and addon.characters[addon.thisCharacter] then
            addon.characters[addon.thisCharacter]:SetOnlineStatus({
                zone = zone,
                isOnline = true,
            }, true) --broadcast this info as it sets where you are and if you are online
        end
    end
end

function e:PLAYER_ENTERING_WORLD()
    local name, realm = UnitFullName("player")
    if not realm then
        realm = GetNormalizedRealmName()
    end
    addon.thisCharacter = string.format("%s-%s", name, realm)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD");

    -- Talents:GetPlayerTalentInfo()

    Database:Init()
end

local classFileNameToClassId = {
    WARRIOR	= 1,
    PALADIN	= 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK	= 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12,
    EVOKER = 13,
}
addon.initialGuildRosterScanned = false
function e:GUILD_ROSTER_UPDATE()

    local guildName;
    if IsInGuild() and GetGuildInfo("player") then
        local name, _, _, _ = GetGuildInfo('player')
        guildName = name;
    end

    if guildName then

        addon.thisGuild = guildName;

        if not Database.db.chats.guild[guildName] then
            Database.db.chats.guild[guildName] = {
                history = {},
                lastActive = 0,

            }
        end

        local isNew = false;
        if not Database.db.guilds[guildName] then
            Database.db.guilds[guildName] = {
                members = {},
                calendar = {
                    activeEvents = {},
                    deletedEvents = {},
                },
                banks = {},
                bankRules = {},
                logs = {
                    general = {},
                    members = {}, --use this for people joining/leaving the guild
                    promotions = {}, --use this for members being promoted/demoted
                    guildbank = {}, --use this for guild bank withdraw etc
                },
                info = {},
                achievements = {},
            }
            isNew = true;
        end
        if not addon.guilds[guildName] then
            addon.guilds[guildName] = Database.db.guilds[guildName]
        end

        local members = {}
        local totalMembers, onlineMember, _ = GetNumGuildMembers()
        for i = 1, totalMembers do
            --local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
            local name, rankName, rankIndex, level, _, zone, publicNote, officerNote, isOnline, status, class, _, _, _, _, _, guid = GetGuildRosterInfo(i)
        
            if publicNote:lower():find("guildbank") then

                --add the bank character if not exists
                if not addon.guilds[guildName].banks[name] then
                    addon.guilds[guildName].banks[name] = 0;
                    addon.guilds[guildName].bankRules[name] = {
                        shareBanks = false,
                        shareBags = false,
                        shareRank = 0,
                        shareCopper = false,
                    }
                end
            else

                --remove bank if no longer set
                if Database.db.guilds[guildName].banks[name] then
                    Database.db.guilds[guildName].banks[name] = nil
                end
            end
            members[name] = true;

            --the easiest way to do this is just access the saved variables rather than add calls just to be fancy
            if not Database.db.characterDirectory[name] then
                local character = {
                    guid = guid,
                    name = name,
                    class = classFileNameToClassId[class],
                    gender = false,
                    level = level,
                    race = false,
                    rank = rankIndex,
                    onlineStatus = {
                        isOnline = isOnline,
                        zone = zone,
                    },
                    alts = {},
                    mainCharacter = false,
                    --rankName = rankName,
                    publicNote = publicNote,
                    mainSpec = false,
                    offSpec = false,
                    mainSpecIsPvP = false,
                    offSpecIsPvP = false,
                    profile = {},
                    profession1 = "-",
                    profession1Level = 0,
                    profession1Spec = false,
                    profession1Recipes = {},
                    profession2 = "-",
                    profession2Level = 0,
                    profession2Spec = false,
                    profession2Recipes = {},
                    cookingLevel = 0,
                    cookingRecipes = {},
                    fishingLevel = 0,
                    firstAidLevel = 0,
                    firstAidRecipes = {},
                    talents = {},
                    --Glyphs = glyphs,
                    inventory = {
                        current = {},
                    },
                    --CurrentInventory = currentInventory,
                    paperDollStats = {
                        current = {},
                    },
                    resistances = {
                        current = {},
                    },
                    auras = {
                        current = {},
                    },
                    containers = {},
                    --CurrentPaperdollStats = currentPaperdollStats or {},
                }
                Database:InsertCharacter(character)
                
            end

            if not addon.characters[name] then
                addon.characters[name] = Character:CreateFromData(Database.db.characterDirectory[name])
                --addon.characters[name]:RegisterCallbacks()
            end

            -- addon.characters[name]:SetOnlineStatus({
            --     isOnline = isOnline,
            --     zone = zone,
            -- })
            -- addon.characters[name]:SetLevel(level)
            -- addon.characters[name]:SetRank(rankIndex)
            -- addon.characters[name]:SetPublicNote(publicNote)
            addon.characters[name].data.onlineStatus = {
                isOnline = isOnline,
                zone = zone,
            }
            addon.characters[name].data.level = level
            addon.characters[name].data.rank = rankIndex
            addon.characters[name].data.publicNote = publicNote
            
            if i == totalMembers then

                addon.guilds[guildName].members = members;

                if isNew == true then
                    local now = time();
                    table.insert(addon.guilds[guildName].logs.general, {
                        timestamp = now,
                        message = string.format("%s created", guildName)
                    })
                    -- for name, _ in pairs(members) do
                    --     table.insert(addon.guilds[guildName].logs.members, {
                    --         timestamp = now,
                    --         message = string.format("%s joined the guild", name)
                    --     })
                    -- end
                end

                local objsRemoved = false;
                for name, obj in pairs(addon.characters) do
                    if not members[obj.data.name] then
                        addon.characters[name] = nil;
                        objsRemoved = true;
                    end
                end
                if objsRemoved then
                    collectgarbage()
                end

                addon:TriggerEvent("Blizzard_OnGuildRosterUpdate", guildName)

                if addon.initialGuildRosterScanned == false then
                    addon:TriggerEvent("Blizzard_OnInitialGuildRosterScan", guildName)
                    addon.initialGuildRosterScanned = true;
                end
            end
        end
    end
end

local function processSkillLines(skills)
    if addon.characters and addon.characters[addon.thisCharacter] then
        for tradeskillId, level in pairs(skills) do
            if tradeskillId == 129 then
                addon.characters[addon.thisCharacter]:SetFirstAidLevel(level, true)
            elseif tradeskillId == 185 then
                addon.characters[addon.thisCharacter]:SetCookingLevel(level, true)
            elseif tradeskillId == 356 then
                addon.characters[addon.thisCharacter]:SetFishingLevel(level, true)
            else
                if addon.characters[addon.thisCharacter].data.profession1 == "-" then
                    addon.characters[addon.thisCharacter]:SetTradeskill(1, tradeskillId, true);
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(1, level, true)
                    return;
                else
                    if (addon.characters[addon.thisCharacter].data.profession2 == "-") and (addon.characters[addon.thisCharacter].data.profession1 ~= tradeskillId) then
                        addon.characters[addon.thisCharacter]:SetTradeskill(2, tradeskillId, true);
                        addon.characters[addon.thisCharacter]:SetTradeskillLevel(2, level, true)
                        return;
                    end
                end
                if addon.characters[addon.thisCharacter].data.profession1 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(1, level, true)
                elseif addon.characters[addon.thisCharacter].data.profession2 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(2, level, true)
                end
            end
        end
    end
end

function e:SKILL_LINES_CHANGED()
    local skills = addon.api.classic.getPlayerSkillLevels()
    processSkillLines(skills)
end

function e:TRADE_SKILL_SHOW()
    local skills = addon.api.classic.getPlayerSkillLevels()
    processSkillLines(skills)
end

--rather than have this method on all character objs when only the players character needs it
--i just made it a local func here
local function setCharacterTradeskill(prof, recipes)

    if addon.characters and addon.characters[addon.thisCharacter] then
        
        if prof == 185 then
            addon.characters[addon.thisCharacter]:SetCookingRecipes(recipes, true)
            return;
        end

        if prof == 129 then
            addon.characters[addon.thisCharacter]:SetFirstAidRecipes(recipes, true)
            return
        end

        if prof == 356 then
            
            return;
        end

        if addon.characters[addon.thisCharacter].data.profession1 == "-" then
            addon.characters[addon.thisCharacter]:SetTradeskill(1, prof, true);
            addon.characters[addon.thisCharacter]:SetTradeskillRecipes(1, recipes, true)
            return;
        else
            if addon.characters[addon.thisCharacter].data.profession1 == prof then
                addon.characters[addon.thisCharacter]:SetTradeskillRecipes(1, recipes, true)
                return;
            end
        end

        if addon.characters[addon.thisCharacter].data.profession2 == "-" then
            addon.characters[addon.thisCharacter]:SetTradeskill(2, prof, true);
            addon.characters[addon.thisCharacter]:SetTradeskillRecipes(2, recipes, true)
            return;
        else
            if addon.characters[addon.thisCharacter].data.profession2 == prof then
                addon.characters[addon.thisCharacter]:SetTradeskillRecipes(2, recipes, true)
                return;
            end
        end
    end
end

function e:CRAFT_UPDATE()

    local skills = addon.api.classic.getPlayerSkillLevels()
    processSkillLines(skills)

    local recipes = {}
    local prof;
    local numTradeskills = GetNumCrafts()

    for i = 1, numTradeskills do
        local name, craftSubSpellName, _type, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(i)
        if name and (_type == "optimal" or _type == "medium" or _type == "easy" or _type == "trivial") then
            local _, _, _, _, _, _, spellID = GetSpellInfo(name)
            if spellID then
                for k, v in ipairs(addon.itemData) do
                    if v.spellID == spellID then
                        table.insert(recipes, v.spellID)
                        prof = v.professionID;
                    end
                end
            end
        end
    end

    setCharacterTradeskill(prof, recipes)
    --addon:TriggerEvent("Blizzard_OnTradeskillUpdate", prof, recipes)
end

function e:TRADE_SKILL_UPDATE()

    local skills = addon.api.classic.getPlayerSkillLevels()
    processSkillLines(skills)

    local recipes = {}
    local prof;
    local numTradeskills = GetNumTradeSkills()

    for i = 1, numTradeskills do
        local name, _type, _, _, _ = GetTradeSkillInfo(i)
        if name and (_type == "optimal" or _type == "medium" or _type == "easy" or _type == "trivial") then
            local itemLink = GetTradeSkillItemLink(i)
            if itemLink then
                local id = GetItemInfoFromHyperlink(itemLink)
                if id then
                    for k, v in ipairs(addon.itemData) do
                        if v.itemID == id then
                            table.insert(recipes, v.spellID)
                            prof = v.professionID;
                        end
                    end
                end
            end
        end
    end

    setCharacterTradeskill(prof, recipes)
    --addon:TriggerEvent("Blizzard_OnTradeskillUpdate", prof, recipes)
end


function e:Database_OnInitialised()
    GuildRoster()

    if not Database.db.myCharacters[addon.thisCharacter] then
        Database.db.myCharacters[addon.thisCharacter] = false;
        print("Registered character:", addon.thisCharacter)
    end
end

addon:RegisterCallback("Database_OnInitialised", e.Database_OnInitialised, e)