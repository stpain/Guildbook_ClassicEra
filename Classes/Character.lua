

local _, addon = ...;

local Character = {};
local Tradeskills = addon.Tradeskills;
local L = addon.Locales;


--will use a specID as found from spellbook tabs-1 (ignore general) and then get the spec name from this table
--for display the name value can be used to grab the locale
local classData = {
    -- DEATHKNIGHT = { 
    --     specializations={'Frost','Blood','Unholy'} 
    -- },
    DRUID = { 
        specializations={'Balance', 'Cat' ,'Bear', 'Restoration',}
    },
    HUNTER = { 
        specializations={'Beast Master', 'Marksmanship','Survival',} 
    },
    MAGE = { 
        specializations={'Arcane', 'Fire','Frost',} 
    },
    PALADIN = { 
        specializations={'Holy','Protection','Retribution',} 
    },
    PRIEST = { 
        specializations={'Discipline','Holy','Shadow',} 
    },
    ROGUE = { 
        specializations={'Assassination','Combat','Subtlety',} -- outlaw could need adding in here
    },
    SHAMAN = { 
        specializations={'Elemental', 'Enhancement', 'Restoration'} 
    },
    WARLOCK = {  
        specializations={'Affliction','Demonology','Destruction',} 
    },
    WARRIOR = { 
        specializations={'Arms','Fury','Protection',} 
    },
}

local raceFileStringToId = {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Scourge = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Goblin = 9,
    BloodElf = 10,
    Draenei = 11,

    Worgen = 22,
    Pandaren = 24,
    PandarenAlliance = 25,
    PandarenHorde = 26,
}

function Character:GetGuid()
    return self.data.guid;
end

function Character:SetGuid(guid)
    self.data.guid = guid;
end

function Character:SetOnlineStatus(info)
    self.data.onlineStatus = info;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "onlineStatus", self.data.name))
end

function Character:GetOnlineStatus()
    return self.data.onlineStatus;
end


function Character:SetName(name)
    self.data.name = name;
end

function Character:GetName()
    return self.data.name;
end

function Character:SetRank(index)
    if self.data.rank ~= index then
        self.data.rank = index;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "rank", self.data.name))
    end
end

function Character:GetRank()
    return self.data.rank;
end

function Character:SetLevel(level)
    if self.data.level ~= level then
        self.data.level = level;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "level", self.data.name))
    end
end

function Character:GetLevel()
    return self.data.level;
end


function Character:SetRace(race)
    if self.data.race ~= race then
        self.data.race = race;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "race", self.data.name))
    end
end

function Character:GetRace()
    local raceInfo = C_CreatureInfo.GetRaceInfo(self.data.race)
    return raceInfo;
end


function Character:SetClass(class)
    self.data.class = class;
end

function Character:GetClass()
    return self.data.class;
end


function Character:SetGender(gender)
    if self.data.gender ~= gender then
        self.data.gender = gender;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "gender", self.data.name))
    end
end

function Character:GetGender()
    return self.data.gender;
end


function Character:SetPublicNote(note)
    if self.data.publicNote ~= note then
        self.data.publicNote = note;
        addon:TriggerEvent("Character_OnDataChanged", self)
        addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "public note", self.data.name))
    end
end

function Character:GetPublicNote()
    return self.data.publicNote;
end

function Character:SetContainers(containers)
    self.data.containers = containers;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "containers", self.data.name))
end

function Character:GetContainers(containers)
    return self.data.containers;
end

function Character:GetSpecializations()
    return classData[self.data.class].specializations;
end

function Character:SetSpec(spec, specID)
    if spec == "primary" then
        self.data.mainSpec = specID; 
    elseif spec == "secondary" then
        self.data.offSpec = specID;
    end
    --print("set spec", spec, specID)
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "spec", self.data.name))
end

function Character:GetSpec(spec)
    if type(self.data.class) == "number" then
        local _, class = GetClassInfo(self.data.class);
        if spec == "primary" then
            local specName = classData[class].specializations[self.data.mainSpec]
            return L[specName], specName, self.data.mainSpec;
        elseif spec == "secondary" then
            local specName = classData[class].specializations[self.data.offSpec]
            return L[specName], specName, self.data.offSpec;
        end
    else

    end
end


function Character:SetSpecIsPvp(spec, isPvp)
    --print("set isPvp", spec, isPvp)
    if spec == "primary" then
        self.data.mainSpecIsPvP = isPvp;
    elseif spec == "secondary" then
        self.data.offSpecIsPvP = isPvp;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetSpecIsPvp(spec)
    if spec == "primary" then
        return self.data.mainSpecIsPvP;
    elseif spec == "secondary" then
        return self.data.offSpecIsPvP;
    end
end


function Character:SetTradeskill(slot, id)
    if slot == 1 then
        self.data.profession1 = id;
    elseif slot == 2 then
        self.data.profession2 = id;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "tradeskill", self.data.name))
end

function Character:GetTradeskill(slot)
    if slot == 1 then
        return self.data.profession1;
    elseif slot == 2 then
        return self.data.profession2;
    end
end


function Character:SetTradeskillLevel(slot, level)
    if slot == 1 then
        self.data.profession1Level = level;
    elseif slot == 2 then
        self.data.profession2Level = level;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "tradeskill level", self.data.name))
end

function Character:GetTradeskillLevel(slot)
    if slot == 1 then
        return self.data.profession1Level;
    elseif slot == 2 then
        return self.data.profession2Level;
    end
end


function Character:SetTradeskillSpec(slot, spec)
    if slot == 1 then
        self.data.profession1Spec = spec;
    elseif slot == 2 then
        self.data.profession2Spec = spec;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "tradeskill spec", self.data.name))
end

function Character:GetTradeskillSpec(slot)
    if slot == 1 then
        return self.data.profession1Spec;
    elseif slot == 2 then
        return self.data.profession2Spec;
    end
end


function Character:SetTradeskillRecipes(slot, recipes)
    if slot == 1 then
        self.data.profession1Recipes = recipes;
    elseif slot == 2 then
        self.data.profession2Recipes = recipes;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "tradeskill recipes", self.data.name))
end

function Character:GetTradeskillRecipes(slot)
    if slot == 1 then
        return self.data.profession1Recipes;
    elseif slot == 2 then
        return self.data.profession2Recipes;
    end
end


function Character:SetCookingRecipes(recipes)
    self.data.cookingRecipes = recipes;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "cooking recipes", self.data.name))
end

function Character:GetCookingRecipes()
    return self.data.cookingRecipes;
end


function Character:CanCraftItem(item)

    --grab item tradeskill first
    if item.professionID == 185 then
        if type(self.data.firstAidRecipes) == "table" then
            for k, spellID in ipairs(self.data.cookingRecipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    elseif item.professionID == 129 then
        if type(self.data.firstAidRecipes) == "table" then
            for k, spellID in ipairs(self.data.firstAidRecipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    else
        if type(self.data.profession1Recipes) == "table" then
            for k, spellID in ipairs(self.data.profession1Recipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    
        if type(self.data.profession2Recipes) == "table" then
            for k, spellID in ipairs(self.data.profession2Recipes) do
                if spellID == item.spellID then
                    return true;
                end
            end
        end
    end
    return false;
end


function Character:SetCookingLevel(level)
    self.data.cookingLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "cooking level", self.data.name))
end

function Character:GetCookingLevel()
    return self.data.cookingLevel;
end


function Character:SetFishingLevel(level)
    self.data.fishingLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "fishing level", self.data.name))
end

function Character:GetFishingLevel()
    return self.data.fishingLevel;
end

function Character:SetFirstAidRecipes(recipes)
    self.data.firstAidRecipes = recipes;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "first aid recipes", self.data.name))
end

function Character:GetFirstAidRecipes()
    return self.data.firstAidRecipes;
end

function Character:SetFirstAidLevel(level)
    self.data.firstAidLevel = level;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "first aid level", self.data.name))
end

function Character:GetFirstAidLevel()
    return self.data.firstAidLevel;
end


function Character:SetProfileDob(timeStamp)
    self.data.profile.dob = timeStamp;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileDob()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.dob;
end


function Character:SetProfileName(name)
    self.data.profile.name = name;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileName()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.name;
end


function Character:SetProfileBio(bio)
    self.data.profile.bio = bio;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetProfileBio()
    if not self.data.profile then
        return "";
    end
    return self.data.profile.bio;
end

--used to set dispaly text and detect when changes occur
function Character:GetProfile()
    local t = {};
    if not self.data.profile then
        return false;
    end
    t.name = self.data.profile.name;
    t.bio = self.data.profile.bio;
    t.mainSpec = self.data.mainSpec;
    t.mainSpecIsPvp = self.data.mainSpecIsPvP;
    t.offSpec = self.data.offSpec;
    t.offSpecIsPvP = self.data.offSpecIsPvP;
    t.mainCharacter = self.data.mainCharacter;
    t.alts = self.data.alts;
    return t;
end

function Character:SetTalents(spec, talents)
    if (#talents > 0) then
        self.data.talents[spec] = talents;
    end
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "talents", self.data.name))
end

function Character:GetTalents(spec)
    if self.data.talents[spec] then
        return self.data.talents[spec];
    end
end


-- function Character:SetGlyphs(spec, glyphs)

--     if (#glyphs > 0) then
--         self.data.glyphs[spec] = glyphs;
--     else
--         --print("glyphs", spec, "no data")
--     end
-- end

-- function Character:GetGlyphs(spec)
--     if self.data.glyphs[spec] then
--         return self.data.glyphs[spec];
--     end
-- end


function Character:SetInventory(set, inventory)
    self.data.inventory[set] = inventory;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "inventory (gear)", self.data.name))
end

function Character:GetInventory(set)
    return self.data.inventory[set] or {};
end

function Character:SetAuras(set, res)
    self.data.auras[set] = res;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "auras", self.data.name))
end

function Character:GetAuras(set)
    return self.data.auras[set] or {};
end

function Character:SetResistances(set, res)
    self.data.resistances[set] = res;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "resistances", self.data.name))
end

function Character:GetResistances(set)
    return self.data.resistances[set] or {};
end

function Character:SetPaperdollStats(set, stats)
    self.data.paperDollStats[set] = stats;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "stats", self.data.name))
end

function Character:GetPaperdollStats(set)
    if self.data.paperDollStats[set] then
        return self.data.paperDollStats[set] or {};
    end
end


function Character:SetMainCharacter(main)
    self.data.mainCharacter = main;
    addon:TriggerEvent("Character_OnDataChanged", self)
    addon:TriggerEvent("StatusText_OnChanged", string.format("[Character_OnDataChanged] set %s for %s", "main character", self.data.name))
end

function Character:GetMainCharacter()
    return self.data.mainCharacter;
end

function Character:SetAlts(alts)
    self.data.alts = alts;
    addon:TriggerEvent("Character_OnDataChanged", self)
end

function Character:GetAlts()
    return self.data.alts;
end


function Character:AddNewAlt(guid)
    table.insert(self.data.alts, guid)
end

function Character:RemoveAlt(guid)
    local i;
    for k, _guid in ipairs(self.data.alts) do
        if _guid == guid then
            i = k;
        end
    end
    if type(i) == "number" then
        table.remove(self.data.alts, i)
    end
end

function Character:GetTradeskillIcon(slot)
    if type(self.data["profession"..slot]) == "number" then
        return Tradeskills:TradeskillIDToAtlas(self.data["profession"..slot])
    end
    return "questlegendaryturnin";
end

function Character:GetProfileAvatar()
    if type(self.data.race) == "number" and type(self.data.gender) == "number" then
        local raceInfo = C_CreatureInfo.GetRaceInfo(self.data.race)
        local gender = (self.data.gender == 3) and "female" or "male" --GetPlayerInfoByGUID returns 2=MALE 3=FEMALE
        return string.format("raceicon-%s-%s", raceInfo.clientFileString:lower(), gender)
    else

    end
    return "questlegendaryturnin"
end

function Character:GetClassSpecAtlasName(spec)

    local _, s = self:GetSpec(spec)

    if s == "Beast Master" then
        s = "BeastMastery";
    end
    if s == "Cat" then
        s = "Feral";
    end
    if s == "Bear" then
        s = "Guardian";
    end
    if s == "Combat" then
        s = "Outlaw";
    end

    if type(self.data.class) == "number" then
        local _, c = GetClassInfo(self.data.class)
        
        if c and s then
            return string.format("GarrMission_ClassIcon-%s-%s", c, s)
        else
            if c then
                return string.format("classicon-%s", c):lower()
            end
        end
    end

    return "questlegendaryturnin";

end

function Character:RegisterCallbacks()
    addon:RegisterCallback("Blizzard_OnTradeskillUpdate", self.Blizzard_OnTradeskillUpdate, self)
end


function Character:Blizzard_OnTradeskillUpdate(prof, recipes)

    if self.data.guid == UnitGUID("player") then

        if prof == 185 then
            self:SetCookingRecipes(recipes)
            return;
        end

        if prof == 129 then
            self:SetFirstAidRecipes(recipes)
            return
        end

        if prof == 356 then
            
            return;
        end

        if self.data.profession1 == "-" then
            self:SetTradeskill(1, prof);
            self:SetTradeskillRecipes(1, recipes)
            return;
        else
            if self.data.profession1 == prof then
                self:SetTradeskillRecipes(1, recipes)
                return;
            end
        end

        if self.data.profession2 == "-" then
            self:SetTradeskill(2, prof);
            self:SetTradeskillRecipes(2, recipes)
            return;
        else
            if self.data.profession2 == prof then
                self:SetTradeskillRecipes(2, recipes)
                return;
            end
        end

        print("Both character professions set and no match available")

    end
end

function Character:CreateFromData_Old(data)
    if type(data) == "table" then
        return Mixin({
            data = {
                guid = data.guid,
                name = data.name,
                class = data.class,
                gender = data.gender,
                level = data.level,
                race = data.race,
                rankName = data.rankName,
                alts = data.alts,
                mainCharacter = data.mainCharacter or false,
                publicNote = data.publicNote,
                mainSpec = data.mainSpec,
                offSpec = data.offSpec,
                mainSpecIsPvP = data.mainSpecIsPvP,
                offSpecIsPvP = data.offSpecIsPvP,
                profile = data.profile or {},
                profession1 = data.profession1,
                profession1Level = data.profession1Level,
                profession1Spec = data.profession1Spec,
                profession1Recipes = data.profession1Recipes or {},
                profession2 = data.profession2,
                profession2Level = data.profession2Level,
                profession2Spec = data.profession2Spec,
                profession2Recipes = data.profession2Recipes or {},
                cookingLevel = data.cookingLevel,
                cookingRecipes = data.cookingRecipes or {},
                fishingLevel = data.fishingLevel,
                firstAidLevel = data.firstAidLevel,
                firstAidRecipes = data.firstAidRecipes,
                talents = data.talents or {},
                --glyphs = data.Glyphs or {},
                inventory = data.inventory,
                --currentInventory = data.currentInventory or {},
                paperDollStats = data.paperDollStats,
                --currentPaperdollStats = data.CurrentPaperdollStats or {},
                onlineStatus = {
                    isOnline = false,
                    zone = "",
                }
            },
        }, self)
    end
end


function Character:CreateFromData(data)
    --print(string.format("Created Character Obj [%s] at %s", data.name or "-", date('%H:%M:%S', time())))

    --lets crack player info
    if (data.race == false) or (data.gender == false) then
        self.ticker = C_Timer.NewTicker(1, function()
            local _, _, _, englishRace, sex = GetPlayerInfoByGUID(data.guid)
            if englishRace and sex then
                if addon.characters[data.name] then
                    addon.characters[data.name]:SetGender(sex)
                    addon.characters[data.name]:SetRace(raceFileStringToId[englishRace])
                    --print(string.format("Got race and gender info [%s] at %s", data.name or "-", date('%H:%M:%S', time())))
                    addon.characters[data.name].ticker:Cancel()
                end
            end
        end)
    end
    return Mixin({data = data}, self)
end


function Character:GetSavedVariablesData()
    local data = {
        guid = self.data.guid,
        name = self.data.name,
        class = self.data.class,
        gender = self.data.gender,
        level = self.data.level,
        race = self.data.race,
        alts = self.data.alts,
        mainCharacter = self.data.mainCharacter,
        rankName = self.data.rankName,
        publicNote = self.data.publicNote,
        mainSpec = self.data.mainSpec,
        offSpec = self.data.offSpec,
        mainSpecIsPvP = self.data.mainSpecIsPvP,
        offSpecIsPvP = self.data.offSpecIsPvP,
        profile = self.data.profile or {}, --profile here is lower on purpose, it was a typo error long time ago and teh saved var ended up with a lower p
        profession1 = self.data.profession1,
        profession1Level = self.data.profession1Level,
        profession1Spec = self.data.profession1Spec,
        profession1Recipes = self.data.profession1Recipes,
        profession2 = self.data.profession2,
        profession2Level = self.data.profession2Level,
        profession2Spec = self.data.profession2Spec,
        profession2Recipes = self.data.profession2Recipes,
        cookingLevel = self.data.cookingLevel,
        cookingRecipes = self.data.cookingRecipes or {},
        fishingLevel = self.data.fishingLevel,
        firstAidLevel = self.data.firstAidLevel,
        firstAidRecipes = self.data.firstAidRecipes or {},
        talents = self.data.talents,
        --Glyphs = self.data.glyphs,
        inventory = self.data.inventory,
        --CurrentInventory = self.data.currentInventory,
        paperDollStats = self.data.paperDollStats,
        --CurrentPaperdollStats = self.data.currentPaperdollStats or {},
    }
    return data;
end

function Character:ResetData()
    local name = self.data.name;
    local guid = self.data.guid;
    self.data = {
        name = "",
        level = 0,
        class = "",
        race = "",
        gender = "",
        guid = guid,

        mainCharacter = false,
        publicNote = "",
        alts = {},

        mainSpec = 1,
        mainSpecIsPvP = false,
        offSpec = 2,
        offSpecIsPvP = false,

        profession1 = "-",
        profession2 = "-",
        profession1Level = 0,
        profession2Level = 0,
        profession1Recipes = {},
        profession2Recipes = {},
        profession1Spec = 0,
        profession2Spec = 0,

        cookingRecipes = {},

        cookingLevel = 0,
        firstAidLevel = 0,
        firstAidRecipes = {},
        fishingLevel = 0,

        talents = {
            primary = {},
            secondary = {},
        },
        glyphs = {
            primary = {},
            secondary = {},
        },

        inventory = {},
        currentInventory = {},

        rankName = "",
        profile = {
            dob = false,
            name = "",
            bio = "",
            avatar = false,
        },

        paperDollStats = {
            current = {},
            primary = {},
            secondary = {},
        },
        --CurrentPaperdollStats = {},

        onlineStatus = {
            isOnline = false,
            zone = "",
        }
    }
    if guid == UnitGUID("player") then
        addon:TriggerEvent("Character_OnDataChanged")
    end
    --addon.DEBUG("func", "Character:ResetData", string.format("reset data for %s", name))
end

function Character:New()
    return Mixin({ 
        data = {
            name = "",
            level = 0;
            class = "",
            race = "",
            gender = "",

            mainCharacter = false,
            publicNote = "",
            alts = {},

            mainSpec = 1,
            mainSpecIsPvP = false,
            offSpec = 2,
            offSpecIsPvP = false,

            profession1 = "-",
            profession2 = "-",
            profession1Level = 0,
            profession2Level = 0,
            profession1Recipes = {},
            profession2Recipes = {},
            profession1Spec = 0,
            profession2Spec = 0,

            cooking = {},

            cookingLevel = 0,
            firstAidLevel = 0,
            firstAidRecipes = {},
            fishingLevel = 0,

            talents = {
                primary = {},
                secondary = {},
            },
            -- glyphs = {
            --     primary = {},
            --     secondary = {},
            -- },

            inventory = {},
            --currentInventory = {},

            rankName = "",
            profile = {
                dob = false,
                name = "",
                bio = "",
                avatar = false,
            },

            paperDollStats = {
                current = {},
                primary = {},
                secondary = {},
            },
            --CurrentPaperdollStats = {},
        },
    }, self)
end

addon.Character = Character;
