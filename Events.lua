local name, addon = ...;

local Character = addon.Character;
local Database = addon.Database;
local Talents = addon.Talents;

local e = CreateFrame("FRAME");
e:RegisterEvent('GUILD_ROSTER_UPDATE')
e:RegisterEvent('ADDON_LOADED')
e:RegisterEvent('PLAYER_ENTERING_WORLD')
e:RegisterEvent('PLAYER_LEVEL_UP')
e:RegisterEvent('TRADE_SKILL_UPDATE')
--e:RegisterEvent('TRADE_SKILL_SHOW')
e:RegisterEvent('CRAFT_UPDATE')
e:RegisterEvent('RAID_ROSTER_UPDATE')
e:RegisterEvent('BANKFRAME_OPENED')
e:RegisterEvent('BANKFRAME_CLOSED')
e:RegisterEvent('BAG_UPDATE')
e:RegisterEvent('CHAT_MSG_GUILD')
e:RegisterEvent('CHAT_MSG_WHISPER')
--e:RegisterEvent('CHAT_MSG_SYSTEM')
e:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
e:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
e:RegisterEvent('ZONE_CHANGED_NEW_AREA')
e:RegisterEvent('CHARACTER_POINTS_CHANGED')

e:SetScript("OnEvent", function(self, event, ...)
    if self[event] then
        self[event](self, ...)
    end
end)

function e:CHARACTER_POINTS_CHANGED(delta)
    if delta == 1 then
        --leveled up
    elseif delta == -1 then
        Talents:GetPlayerTalentInfo()
    end
end

function e:ZONE_CHANGED_NEW_AREA()
    --print("zone changed")
	local mapID = C_Map.GetBestMapForUnit("player")
    local zone = C_Map.GetMapInfo(mapID).name
	--print(GetZoneText(), zone)
    if addon.characters[addon.thisCharacter] then
        addon.characters[addon.thisCharacter]:SetOnlineStatus({
            zone = zone,
            isOnline = true,
        })
        --print("event zone changed",zone)
    end
end

function e:PLAYER_ENTERING_WORLD()
    Database:Init()
    local name, realm = UnitFullName("player")
    if not realm then
        realm = GetNormalizedRealmName()
    end
    addon.thisCharacter = string.format("%s-%s", name, realm)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    print("Registered character:", addon.thisCharacter)

    Talents:GetPlayerTalentInfo()
end

function e:GUILD_ROSTER_UPDATE()

    local guildName;
    if IsInGuild() and GetGuildInfo("player") then
        local name, _, _, _ = GetGuildInfo('player')
        guildName = name;
    end

    local playerLocation;

    if guildName then

        if not Database.db.guilds[guildName] then
            Database.db.guilds[guildName] = {
                members = {},
                calendar = {
                    activeEvents = {},
                    deletedEvents = {},
                },
                banks = {},
                logs = {},
                info = {},
            }
        end

        local members = {}
        local totalMembers, onlineMember, _ = GetNumGuildMembers()
        for i = 1, totalMembers do
            --local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
            local name, rankName, rankIndex, level, _, zone, publicNote, officerNote, isOnline, status, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
        
            members[name] = true;

            --the easiest way to do this is just access the saved variables rather than add calls just to be fancy
            if not Database.db.characterDirectory[name] then
                if not playerLocation then
                    playerLocation = PlayerLocation:CreateFromGUID(guid)
                else
                    playerLocation:SetGUID(guid)
                end
                if playerLocation:IsValid() then
                    local _, _, class = C_PlayerInfo.GetClass(playerLocation)
                    local race = C_PlayerInfo.GetRace(playerLocation)
                    local gender = C_PlayerInfo.GetSex(playerLocation)

                    local character = {
                        guid = guid,
                        name = name,
                        class = class,
                        gender = gender,
                        level = level,
                        race = race,
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
                        inventory = {},
                        --CurrentInventory = currentInventory,
                        paperDollStats = {},
                        --CurrentPaperdollStats = currentPaperdollStats or {},
                    }
                    Database:InsertCharacter(character)
                end
            end

            if not addon.characters[name] then
                addon.characters[name] = Character:CreateFromData(Database.db.characterDirectory[name])
                --DevTools_Dump(addon.characters[name])
            end

            addon.characters[name]:RegisterCallbacks()

            addon.characters[name]:SetOnlineStatus({
                isOnline = isOnline,
                zone = zone,
            })

            addon.characters[name]:SetLevel(level)
            addon.characters[name]:SetRank(rankIndex)
            addon.characters[name]:SetPublicNote(publicNote)
            
            if i == totalMembers then

                Database.db.guilds[guildName].members = members;

                if not addon.guilds[guildName] then
                    addon.guilds[guildName] = Database.db.guilds[guildName]
                end

                addon:TriggerEvent("Blizzard_OnGuildRosterUpdate", guildName)
            end
        end
    end
end

function e:CRAFT_UPDATE()

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
end

addon:RegisterCallback("Database_OnInitialised", e.Database_OnInitialised, e)