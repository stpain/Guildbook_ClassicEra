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
--e:RegisterEvent('BAG_UPDATE_DELAYED') --this would cause any character bag changes to overwrite whats in the bank
e:RegisterEvent('CHAT_MSG_GUILD')
e:RegisterEvent('CHAT_MSG_WHISPER')
--e:RegisterEvent('CHAT_MSG_SYSTEM')
e:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
e:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
e:RegisterEvent('ZONE_CHANGED_NEW_AREA')
e:RegisterEvent('CHARACTER_POINTS_CHANGED')
e:RegisterEvent('UNIT_AURA')

e:SetScript("OnEvent", function(self, event, ...)
    if self[event] then
        self[event](self, ...)
    end
end)

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


--- check the players current gear and calculate the mean item level

]]

function e:GUILD_RANKS_UPDATE()
    
end
function e:TRADE_SKILL_SHOW()
    local skills = addon.api.getPlayerSkillLevels()
    if addon.characters and addon.characters[addon.thisCharacter] then
        for tradeskillId, level in pairs(skills) do
            if tradeskillId == 129 then
                addon.characters[addon.thisCharacter]:SetFirstAidLevel(level)
            elseif tradeskillId == 185 then
                addon.characters[addon.thisCharacter]:SetCookingLevel(level)
            elseif tradeskillId == 356 then
                addon.characters[addon.thisCharacter]:SetFishingLevel(level)
            else
                if addon.characters[addon.thisCharacter].data.profession1 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(1, level)

                elseif addon.characters[addon.thisCharacter].data.profession2 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(2, level)
                end
            end
        end
    end
end

--[[
    GUILD BANK EVENTS

    the job here is to scan the players bags and bank if they have the guildbank keyword in their public not
]]
local bankScanned = false
function e:BANKFRAME_CLOSED()
    if bankScanned == false then
        if addon.characters[addon.thisCharacter] and (addon.characters[addon.thisCharacter].data.publicNote:lower() == "guildbank") then
            local bags = addon.api.scanPlayerContainers(true)
    
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
        end
    end
    bankScanned = not bankScanned;
end
function e:BANKFRAME_OPENED()
    if addon.characters[addon.thisCharacter] and (addon.characters[addon.thisCharacter].data.publicNote:lower() == "guildbank") then
        local bags = addon.api.scanPlayerContainers(true)

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
    end
end
-- function e:BAG_UPDATE_DELAYED()
--     if addon.characters[addon.thisCharacter] and (addon.characters[addon.thisCharacter].data.publicNote:lower() == "guildbank") then
--         local bags = addon.api.scanPlayerContainers()
--         addon.characters[addon.thisCharacter]:SetContainers(bags, true)
--         if addon.guilds[addon.thisGuild] then
--             addon.guilds[addon.thisGuild].banks[addon.thisCharacter] = time();
--         end
--     end
-- end



function e:UNIT_AURA()
    local auras = addon.api.getPlayerAuras()
    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetAuras("current", auras)
    end
end

function e:PLAYER_EQUIPMENT_CHANGED()

    --when equipment changes it can change stats, resistances so grab those as well
    local equipment = addon.api.getPlayerEquipment()
    local currentStats = addon.api.getPaperDollStats()
    local resistances = addon.api.getPlayerResistances(UnitLevel("player"))

    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetInventory("current", equipment)
        addon.characters[addon.thisCharacter]:SetPaperdollStats("current", currentStats)
        addon.characters[addon.thisCharacter]:SetResistances("current", resistances)
    end
end

function e:CHARACTER_POINTS_CHANGED(delta)
    if delta == 1 then
        --leveled up
        --addon.characters[addon.thisCharacter]:SetLevel()
    end
    local talents = addon.api.getPlayerTalents()
    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetTalents("current", talents)
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
function e:GUILD_ROSTER_UPDATE()

    local guildName;
    if IsInGuild() and GetGuildInfo("player") then
        local name, _, _, _ = GetGuildInfo('player')
        guildName = name;
    end

    if guildName then

        addon.thisGuild = guildName;

        if not Database.db.guilds[guildName] then
            Database.db.guilds[guildName] = {
                members = {},
                calendar = {
                    activeEvents = {},
                    deletedEvents = {},
                },
                banks = {},
                bankRules = {
                    shareBanks = false,
                    shareBags = false,
                    shareMinRank = 0,
                    shareCopper = false,
                },
                logs = {},
                info = {},
            }
        end

        local members, guids, banks = {},{},{}
        local totalMembers, onlineMember, _ = GetNumGuildMembers()
        for i = 1, totalMembers do
            --local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
            local name, rankName, rankIndex, level, _, zone, publicNote, officerNote, isOnline, status, class, _, _, _, _, _, guid = GetGuildRosterInfo(i)
        
            if publicNote:lower() == "guildbank" then
                banks[name] = true;
            else
                if Database.db.guilds[guildName].banks[name] then
                    Database.db.guilds[guildName].banks[name] = nil
                end
            end
            members[name] = true;

            table.insert(guids, guid)
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
                --DevTools_Dump(addon.characters[name])
                --print(addon.characters[name].data.class)
            end

            addon.characters[name]:RegisterCallbacks()

            addon.characters[name]:SetOnlineStatus({
                isOnline = isOnline,
                zone = zone,
            })

            --these values could change betwen roster updates
            addon.characters[name]:SetLevel(level)
            addon.characters[name]:SetRank(rankIndex)
            addon.characters[name]:SetPublicNote(publicNote)
            
            if i == totalMembers then

                Database.db.guilds[guildName].members = members;

                if not addon.guilds[guildName] then
                    addon.guilds[guildName] = Database.db.guilds[guildName]
                end

                for name, _ in pairs(banks) do
                    if not addon.guilds[guildName].banks[name] then
                        addon.guilds[guildName].banks[name] = 0;
                    end
                end

                addon:TriggerEvent("Blizzard_OnGuildRosterUpdate", guildName)
            end
        end
    end
end

function e:CRAFT_UPDATE()

    local skills = addon.api.getPlayerSkillLevels()
    if addon.characters and addon.characters[addon.thisCharacter] then
        for tradeskillId, level in pairs(skills) do
            if tradeskillId == 129 then
                addon.characters[addon.thisCharacter]:SetFirstAidLevel(level)
            elseif tradeskillId == 185 then
                addon.characters[addon.thisCharacter]:SetCookingLevel(level)
            elseif tradeskillId == 356 then
                addon.characters[addon.thisCharacter]:SetFishingLevel(level)
            else
                if addon.characters[addon.thisCharacter].data.profession1 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(1, level)

                elseif addon.characters[addon.thisCharacter].data.profession2 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(2, level)
                end
            end
        end
    end

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

    addon:TriggerEvent("Blizzard_OnTradeskillUpdate", prof, recipes)
end

function e:TRADE_SKILL_UPDATE()

    local skills = addon.api.getPlayerSkillLevels()
    if addon.characters and addon.characters[addon.thisCharacter] then
        for tradeskillId, level in pairs(skills) do
            if tradeskillId == 129 then
                addon.characters[addon.thisCharacter]:SetFirstAidLevel(level)
            elseif tradeskillId == 185 then
                addon.characters[addon.thisCharacter]:SetCookingLevel(level)
            elseif tradeskillId == 356 then
                addon.characters[addon.thisCharacter]:SetFishingLevel(level)
            else
                if addon.characters[addon.thisCharacter].data.profession1 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(1, level)

                elseif addon.characters[addon.thisCharacter].data.profession2 == tradeskillId then
                    addon.characters[addon.thisCharacter]:SetTradeskillLevel(2, level)
                end
            end
        end
    end

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

    addon:TriggerEvent("Blizzard_OnTradeskillUpdate", prof, recipes)
end


function e:Database_OnInitialised()
    GuildRoster()

    if not Database.db.myCharacters[addon.thisCharacter] then
        Database.db.myCharacters[addon.thisCharacter] = false;
        print("Registered character:", addon.thisCharacter)
    end
end

addon:RegisterCallback("Database_OnInitialised", e.Database_OnInitialised, e)