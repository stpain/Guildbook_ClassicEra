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

local magicResistances = {
    {
        icon = 136222, --136116
        name = "arcane",
        id = 6,
    },
    {
        icon = 135813,
        name = "fire",
        id = 3,
    },
    {
        icon = 136074,
        name = "nature",
        id = 3,
    },
    {
        icon = 135849,
        name = "frost",
        id = 4,
    },
    {
        icon = 135945,
        name = "shadow",
        id = 5,
    },
}

GuildbookProfileMixin = {
    name = "Profile",
}

function GuildbookProfileMixin:OnLoad()

    self.inventory.resistanceGridview:InitFramePool("FRAME", "GuildbookResistanceFrame")
    self.inventory.resistanceGridview:SetFixedColumnCount(5)
    self.inventory.resistanceGridview.ScrollBar:Hide()

    for k, resistance in ipairs(magicResistances) do
        self.inventory.resistanceGridview:Insert({
            textureId = resistance.icon,
            resistanceId = resistance.id,
            resistanceName = resistance.name,
            type = "resistance",
        })
    end

    self.inventory.auraGridview:InitFramePool("FRAME", "GuildbookResistanceFrame")
    self.inventory.auraGridview:SetFixedColumnCount(8)
    self.inventory.auraGridview.ScrollBar:Hide()


    self.talents.tree1.talentsGridview:InitFramePool("FRAME", "GuildbookTalentIconFrame")
    self.talents.tree1.talentsGridview:SetFixedColumnCount(4)
    self.talents.tree1.talentsGridview.ScrollBar:Hide()

    C_Timer.After(1, function()
        for i = 1, 28 do
            self.talents.tree1.talentsGridview:Insert({
                label = string.format("Talent\n%d", i)
            })
        end
    end)
    
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
    self:UpdateLayout()
    GuildbookUI:SelectView(self.name)
    self.anim:Play()

end

function GuildbookProfileMixin:UpdateLayout()
    local x, y = self:GetSize()

    local sidePaneWidth = x * 0.21

    self.sidePane:Show()
    self.sidePane:SetWidth(sidePaneWidth)
    self.inventory:SetWidth(x-sidePaneWidth)

    local statsWidth = ((x-sidePaneWidth) * 0.35)

    self.inventory.resistanceGridview:SetWidth(statsWidth)
    self.inventory.resistanceGridview:SetHeight(statsWidth / 5)

    local auraCount = 0
    if self.character and self.character.data.auras.current then
        auraCount = #self.character.data.auras.current or 0;
    end
    if auraCount == 0 then
        self.inventory.auraGridview:SetHeight(1)
    else
        local auraIconWidth = statsWidth / 8;
        local numRows = math.ceil(auraCount / 8)
        self.inventory.auraGridview:SetHeight(auraIconWidth * numRows)
    end


    self.talents:SetWidth(x-sidePaneWidth)
    self.talents.tree1:SetWidth((x-sidePaneWidth) / 3)
    self.talents.tree2:SetWidth((x-sidePaneWidth) / 3)
    self.talents.tree3:SetWidth((x-sidePaneWidth) / 3)

    self.talents.tree1.talentsGridview:SetSize((x-sidePaneWidth) / 3, y)


    if x < 600 then

        statsWidth = ((x-1) * 0.35);

        self.sidePane:SetWidth(1)
        self.sidePane:Hide()
        self.inventory:SetWidth(x-1)

        self.inventory.resistanceGridview:SetWidth(statsWidth)
        self.inventory.resistanceGridview:SetHeight(statsWidth / 5)

        if auraCount == 0 then
            self.inventory.auraGridview:SetHeight(1)
        else
            local auraIconWidth = statsWidth / 8;
            local numRows = math.ceil(auraCount / 8)
            self.inventory.auraGridview:SetHeight(auraIconWidth * numRows)
        end

        self.talents:SetWidth(x-1)
        self.talents.tree1:SetWidth((x-1) / 3)
        self.talents.tree2:SetWidth((x-1) / 3)
        self.talents.tree3:SetWidth((x-1) / 3)

        self.talents.tree1.talentsGridview:SetSize((x-1) / 3, y)
    end

    self.inventory.resistanceGridview:UpdateLayout()
    self.inventory.auraGridview:UpdateLayout()

    self.talents.tree1.talentsGridview:UpdateLayout()
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
        onMouseDown = function()
            self.talents:Hide()
            self.inventory:Show()
        end,
    })

    self.sidePane.listview.DataProvider:Insert({
        atlas = "Mobile-QuestIcon",
        label = L["TALENTS"], 
        onMouseDown = function()
            self.inventory:Hide()
            self.talents:Show()
        end,
    })

    --resistances
    for k, frame in ipairs(self.inventory.resistanceGridview:GetFrames()) do
        --DevTools_Dump(frame)
        if self.character.data.resistances.current[frame.resistanceName] then
            frame.label:SetText(self.character.data.resistances.current[frame.resistanceName])
            frame:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self.inventory.resistanceGridview, "ANCHOR_TOPRIGHT")
                GameTooltip:AddLine(string.format("|cffffffff%s Resistance", frame.resistanceName:gsub("^%l", string.upper)))
                GameTooltip:AddLine(string.format("Resistance against level %d %d", self.character.data.level, self.character.data.resistances.current[frame.resistanceName]))
                GameTooltip:Show()
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
            end)
        end
    end

    --auras
    self.inventory.auraGridview:Flush()
    local auras = self.character.data.auras.current;
    -- local auras = {
    --     {
    --     spellId = 1459,
    --     },
    --     {
    --     spellId = 21850,
    --     },
    --     {
    --     spellId = 1459,
    --     },
    --     {
    --     spellId = 467,
    --     },
    --     {
    --     spellId = 1459,
    --     },
    --     {
    --     spellId = 774,
    --     },
    --     {
    --     spellId = 1459,
    --     },
    --     {
    --     spellId = 8936,
    --     },
    --     {
    --     spellId = 1459,
    --     },
    -- }
    if #auras > 0 then
        for k, aura in ipairs(auras) do
            local name, rank, icon = GetSpellInfo(aura.spellId)
            --print(name, icon)
            self.inventory.auraGridview:Insert({
                textureId = icon,
                label = "",
                onEnter = function()
                    GameTooltip:SetOwner(self.inventory.auraGridview, "ANCHOR_TOPRIGHT")
                    GameTooltip:SetSpellByID(aura.spellId)
                    GameTooltip:Show()
                end
            })
        end
    end

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





    --talents
    local artwork = Talents:GetClassTalentTreeArtwork(self.character.data.class)
    self.talents.tree1.background:SetTexture(artwork[1])
    self.talents.tree2.background:SetTexture(artwork[2])
    self.talents.tree3.background:SetTexture(artwork[3])

end


function GuildbookProfileMixin:CreateTalentUI()
    -- create talent grid
    self.talentIconframes = {}
    local colPoints = { 19.0, 78.0, 137.0, 196.0 }
    local rowPoints = { 19.0, 78.0, 137.0, 196.0, 255.0, 314.0, 373.0, 432.0, 491.0, 550.0, 609.0 } --257
    for spec = 1, 3 do
        self.talentIconframes[spec] = {}
        for row = 1, 7 do
            self.talentIconframes[spec][row] = {}
            for col = 1, 4 do
                local f = CreateFrame('FRAME', string.format("GuildbookProfileTalentsTree%dRow%dCol%d", spec, row, col), self.talents["tree"..spec], BackdropTemplateMixin and "BackdropTemplate")
                f:SetSize(28, 28)
                f:SetPoint('TOPLEFT', 13+((colPoints[col] * 0.83)), ((rowPoints[row] * 0.83) * -1) - 34)

                -- background texture inc border
                f.border = f:CreateTexture('$parentborder', 'BORDER')
                f.border:SetPoint('TOPLEFT', -7, 7)
                f.border:SetPoint('BOTTOMRIGHT', 7, -7)
                f.border:SetAtlas("orderhalltalents-spellborder")
                -- talent icon texture
                f.Icon = f:CreateTexture('$parentIcon', 'BACKGROUND')
                f.Icon:SetPoint('TOPLEFT', -2,2)
                f.Icon:SetPoint('BOTTOMRIGHT', 2,-2)
                -- talent points texture
                f.pointsBackground = f:CreateTexture('$parentPointsBackground', 'ARTWORK')
                f.pointsBackground:SetTexture(136960)
                f.pointsBackground:SetPoint('BOTTOMRIGHT', 16, -16)
                -- talents points font string
                f.Points = f:CreateFontString('$parentPointsText', 'OVERLAY', 'GameFontNormalSmall')
                f.Points:SetPoint('CENTER', f.pointsBackground, 'CENTER', 1, 0)

                f:SetScript('OnEnter', function(self)
                    if self.name then
                        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
                        --GameTooltip:SetSpellByID(self.spellID)
                        GameTooltip:AddLine(self.name)
                        GameTooltip:AddLine(string.format("|cffffffff%s / %s|r", self.rank, self.maxRank))
                        GameTooltip:Show()
                    else
                        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
                    end
                end)
                f:SetScript('OnLeave', function(self)
                    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
                end)


                self.talentIconframes[spec][row][col] = f
            end
        end
    end
end