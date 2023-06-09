local name, addon = ...;

local Database = addon.Database;

GuildbookSettingsMixin = {
    name = "Settings",
}

function GuildbookSettingsMixin:OnLoad()

    local categories = {
        {
            label = "Character",
            atlas = "GarrMission_MissionIcon-Recruit",
            func = function ()
                self:SelectCategory("character")
            end,
        },
        {
            label = "Guild",
            atlas = "GarrMission_MissionIcon-Logistics",
            func = function ()
                self:SelectCategory("guild")
            end,
        },
        {
            label = "Tradeskills",
            atlas = "GarrMission_MissionIcon-Blacksmithing",
            func = function ()
                self:SelectCategory("tradeskills")
            end,
        },
        {
            label = "Guild Bank",
            atlas = "ShipMissionIcon-Treasure-Mission",
            func = function ()
                self:SelectCategory("guildBank")
            end,
        },
        {
            label = "Addon",
            atlas = "GarrMission_MissionIcon-Engineering",
            func = function ()
                self:SelectCategory("addon")
            end,
        },
    }

    self.content.character:SetScript("OnShow", function()
        self:CharacterPanel_OnShow()
    end)

    self.categoryListview.DataProvider:InsertTable(categories)

    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)


    --quickly added for testing
    self.content.addon.factoryReset:SetScript("OnClick", function()
        Database:Reset()
    end)

    addon.AddView(self)
end

function GuildbookSettingsMixin:UpdateLayout()
    local x, y = self.content:GetSize()

    local characterPanel = self.content.character.scrollChild;

    if x < 600 then
        
        characterPanel.myCharacters:ClearAllPoints()
        characterPanel.myCharacters:SetPoint("TOP", characterPanel.specializations, "BOTTOM", 0, -10)


    else

        characterPanel.myCharacters:ClearAllPoints()
        characterPanel.myCharacters:SetPoint("TOPLEFT", characterPanel.specializations, "TOPRIGHT", 20, 0)
    end

end

function GuildbookSettingsMixin:CharacterPanel_OnShow()

    local x, y = self.content:GetSize()

    local panel = self.content.character.scrollChild;

    panel:SetSize(x-24, y)

    for i = 1, 4 do
        panel.specializations["spec"..i]:Hide()
    end

    if addon.characters and addon.characters[addon.thisCharacter] then
        local character = addon.characters[addon.thisCharacter];

        local specs = character:GetSpecializations()
        local atlasNames = character:GetClassSpecAtlasInfo()
        for k, spec in ipairs(specs) do
            if spec then
                panel.specializations["spec"..k].label:SetText(string.format("%s  %s", CreateAtlasMarkup(atlasNames[k], 22, 22), spec))
                panel.specializations["spec"..k]:Show()
                panel.specializations["spec"..k]:SetScript("OnClick", function(cb)
                    for i = 1, 4 do
                        panel.specializations["spec"..i]:SetChecked(false)
                    end
                    cb:SetChecked(true)
                    character:SetSpec("primary", k) --classic is solo spec
                end)
            end
        end
        if type(character.data.mainSpec) == "number" then
            panel.specializations["spec"..character.data.mainSpec]:SetChecked(true)
        end
    end

    panel.myCharacters.listview.DataProvider:Flush()
    local alts = {}
    if Database.db.myCharacters then
        for name, isMain in pairs(Database.db.myCharacters) do
            if addon.characters[name] then
                table.insert(alts, {
                    character = addon.characters[name],
                }) 
            end
        end
    end
    panel.myCharacters.listview.DataProvider:InsertTable(alts)
end

function GuildbookSettingsMixin:SelectCategory(category)

    for k, v in ipairs(self.content.panels) do
        v:Hide()
    end
    if self.content[category] then
        self.content[category]:Show()
    end
end