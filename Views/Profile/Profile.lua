local name, addon = ...;

local L = addon.Locales
local Talents = addon.Talents;
local Tradeskills = addon.Tradeskills;
local Character = addon.Character;

local statsSchema = {
    {
        header = "attributes",
        stats = {
            { key = "Strength", displayName = L["STRENGTH"], },
            { key = "Agility", displayName = L["AGILITY"], },
            { key = "Stamina", displayName = L["STAMINA"], },
            { key = "Intellect", displayName = L["INTELLECT"], },
            { key = "Spirit", displayName = L["SPIRIT"], },
        },
    },
    {
        header = "defence",
        stats = {
            { key = "Armor", displayName = L["ARMOR"], },
            { key = "Defence", displayName = L["DEFENSE"], },
            { key = "Dodge", displayName = L["DODGE"], },
            { key = "Parry", displayName = L["PARRY"], },
            { key = "Block", displayName = L["BLOCK"], },
        },
    },
    {
        header = "melee",
        stats = {
            { key = "Expertise", displayName = L["EXPERTISE"], },
            { key = "MeleeHit", displayName = L["HIT_CHANCE"], },
            { key = "MeleeCrit", displayName = L["MELEE_CRIT"], },
            { key = "MeleeDmgMH", displayName = L["MH_DMG"], },
            { key = "MeleeDpsMH", displayName = L["MH_DPS"], },
            { key = "MeleeDmgOH", displayName = L["OH_DMG"], },
            { key = "MeleeDpsOH", displayName = L["OH_DPS"], },
        },
    },
    {
        header = "ranged",
        stats = {
            { key = "RangedHit", displayName = L["RANGED_HIT"], },
            { key = "RangedCrit", displayName = L["RANGED_CRIT"], },
            { key = "RangedDmg", displayName = L["RANGED_DMG"], },
            { key = "RangedDps", displayName = L["RANGED_DPS"], },
        },
    },
    {
        header = "spell",
        stats = {
            { key = "Haste", displayName = L["SPELL_HASTE"], },
            { key = "ManaRegen", displayName = L["MANA_REGEN"], },
            { key = "ManaRegenCasting", displayName = L["MANA_REGEN_CASTING"], },
            { key = "SpellHit", displayName = L["SPELL_HIT"], },
            { key = "SpellCrit", displayName = L["SPELL_CRIT"], },
            { key = "HealingBonus", displayName = L["HEALING_BONUS"], },
            { key = "SpellDmgHoly", displayName = L["SPELL_DMG_HOLY"], },
            { key = "SpellDmgFrost", displayName = L["SPELL_DMG_FROST"], },
            { key = "SpellDmgShadow", displayName = L["SPELL_DMG_SHADOW"], },
            { key = "SpellDmgArcane", displayName = L["SPELL_DMG_ARCANE"], },
            { key = "SpellDmgFire", displayName = L["SPELL_DMG_FIRE"], },
            { key = "SpellDmgNature", displayName = L["SPELL_DMG_NATURE"], },
        },
    },
}

GuildbookProfileMixin = {
    name = "Profile",
}

function GuildbookProfileMixin:OnLoad()
    
    addon.AddView(self)

    addon:RegisterCallback("Character_OnProfileSelected", self.LoadCharacter, self)
    addon:RegisterCallback("Character_OnDataChanged", self.Update, self)
    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)

    self:UpdateLayout()
end

function GuildbookProfileMixin:Character_OnDataChanged(character)
    if self.character and (self.character.data.guid == character.data.guid) then
        self:Update()
    end
end

function GuildbookProfileMixin:LoadCharacter(character)
    self.character = character;
    self.sidePane.background:SetAtlas(string.format("transmog-background-race-%s", self.character:GetRace().clientFileString:lower()))

    self:Update()
    GuildbookUI:SelectView(self.name)
    self.anim:Play()
end

function GuildbookProfileMixin:UpdateLayout()
    local x, y = self:GetSize()

    local sidePaneWidth = x * 0.21

    self.sidePane:Show()
    self.sidePane:SetWidth(sidePaneWidth)
    self.inventory:SetWidth(x-sidePaneWidth)
    self.inventory.equipmentListview:SetWidth((x-sidePaneWidth) * 0.65)
    self.inventory.statsListview:SetWidth((x-sidePaneWidth) * 0.35)

    if x < 600 then
        self.sidePane:SetWidth(1)
        self.sidePane:Hide()
        self.inventory:SetWidth(x-1)
        self.inventory.equipmentListview:SetWidth((x-1) * 0.65)
        self.inventory.statsListview:SetWidth((x-1) * 0.35)
    end
end



function GuildbookProfileMixin:Update()

    --self.sidePane.anim:Play()

    if not self.character then
        return
    end

    self.sidePane.name:SetText(self.character.data.name)
    self.sidePane.mainSpec:SetText(self.character.data.mainSpec)

    self.sidePane.listview.DataProvider:Flush()
    
    if type(self.character.data.profession1) == "number" then
        self.sidePane.listview.DataProvider:Insert({
            atlas = Tradeskills:TradeskillIDToAtlas(self.character.data.profession1),
            label = string.format("%s [%d]", 
                Tradeskills:GetLocaleNameFromID(self.character.data.profession1), 
                self.character.data.profession1Level
            ),
            onMouseDown = function()
                addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession1, self.character.data.profession1Recipes)
            end,
        })
    end

    if type(self.character.data.profession2) == "number" then
        self.sidePane.listview.DataProvider:Insert({
            atlas = Tradeskills:TradeskillIDToAtlas(self.character.data.profession2),
            label = string.format("%s [%d]", 
                Tradeskills:GetLocaleNameFromID(self.character.data.profession2), 
                self.character.data.profession2Level
            ),
            onMouseDown = function()
                addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession2, self.character.data.profession2Recipes)
            end,
        })
    end

    self.sidePane.listview.DataProvider:Insert({
        atlas = Tradeskills:TradeskillIDToAtlas(185),
        label = string.format("%s [%d]", 
            Tradeskills:GetLocaleNameFromID(185), 
            self.character.data.cookingLevel
        ),
        onMouseDown = function()
            addon:TriggerEvent("Character_OnTradeskillSelected", 185, self.character.data.cookingRecipes)
        end,
    })

    self.sidePane.listview.DataProvider:Insert({
        atlas = Tradeskills:TradeskillIDToAtlas(129),
        label = string.format("%s [%d]", 
            Tradeskills:GetLocaleNameFromID(129), 
            self.character.data.firstAidLevel
        ),
        onMouseDown = function()
            addon:TriggerEvent("Character_OnTradeskillSelected", 129, self.character.data.firstAidRecipes)
        end,
    })

    self.sidePane.listview.DataProvider:Insert({
        atlas = Tradeskills:TradeskillIDToAtlas(356),
        label = string.format("%s [%d]", 
            Tradeskills:GetLocaleNameFromID(356), 
            self.character.data.fishingLevel
        ),
        onMouseDown = nil,
    })

    --inventory select button
    self.sidePane.listview.DataProvider:Insert({
        atlas = "Mobile-CombatIcon",
        label = L["INVENTORY"], 
        onMouseDown = nil,
    })

    self.sidePane.listview.DataProvider:Insert({
        atlas = "Mobile-QuestIcon",
        label = L["TALENTS"], 
        onMouseDown = nil,
    })

    local _, class = GetClassInfo(self.character.data.class);
    
    self.inventory.equipmentListview.background:SetAtlas(string.format("dressingroom-background-%s", class:lower()))
    self.inventory.statsListview.background:SetAtlas(string.format("UI-Character-Info-%s-BG", class:lower()))


    local stats = {}
    table.insert(stats, {
        isHeader = true,
        label = "Defense",
    })
    for i = 1, 5 do
        table.insert(stats, {
            isHeader = false,
            label = "Stat "..i,
            showBounce = ((i % 2) == 0) and true or false,
        })
    end
    table.insert(stats, {
        isHeader = true,
        label = "Melee",
    })

    self.inventory.statsListview.DataProvider:Flush()
    if self.character.data.paperDollStats.current and self.character.data.paperDollStats.current.attributes then
        local stats = {}

        for k, statGroup in ipairs(statsSchema) do
            table.insert(stats, {
                isHeader = true,
                label = L[statGroup.header],
            })
            for i, v in ipairs(statGroup.stats) do
                local statValue = self.character.data.paperDollStats.current[statGroup.header][v.key]
                if type(statValue) == "table" then
                    if statValue and statValue.Base and statValue.Mod then
                        table.insert(stats, {
                            isHeader = false,
                            label = string.format("%s %s", v.displayName, statValue.Base + statValue.Mod),
                            showBounce = ((i % 2) == 0) and true or false,
                        })
                    end
                else
                    table.insert(stats, {
                        isHeader = false,
                        label = string.format("%s %s", v.displayName, statValue or "-"),
                        showBounce = ((i % 2) == 0) and true or false,
                    })
                end
            end
        end
        self.inventory.statsListview.DataProvider:InsertTable(stats)
    end


    self.inventory.equipmentListview.DataProvider:Flush()

    local t = {}
    for k, v in ipairs(addon.data.inventorySlots) do
        if self.character.data.inventory.current[v.slot] then
            self.inventory.equipmentListview.DataProvider:Insert({
                label = self.character.data.inventory.current[v.slot],
                icon = v.icon,
                link = self.character.data.inventory.current[v.slot],
            })
        else
            self.inventory.equipmentListview.DataProvider:Insert({
                label = "-",
                icon = v.icon,
            })
        end
    end

end