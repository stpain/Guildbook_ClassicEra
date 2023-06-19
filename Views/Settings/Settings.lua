local name, addon = ...;
local L = addon.Locales
local Database = addon.Database;

GuildbookSettingsMixin = {
    name = "Settings",
    panelsLoaded = {
        character = false,
        guild = false,
        guildBank = false,
        tradeskills = false,
        chat = false,
    }
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
            label = "Chat",
            atlas = "socialqueuing-icon-group",
            func = function ()
                self:SelectCategory("chat")
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

    self.content.character.general:SetText(L.SETTINGS_CHARACTER_GENERAL)
    self.content.chat.general:SetText(L.SETTINGS_CHAT_GENERAL)
    self.content.addon.general:SetText(L.SETTINGS_ADDON_GENERAL)

    self.content.character:SetScript("OnShow", function()
        self:CharacterPanel_OnShow()
    end)
    self.content.guildBank:SetScript("OnShow", function()
        self:GuildBankPanel_OnShow()
    end)
    self.content.chat:SetScript("OnShow", function()
        self:ChatPanel_OnShow()
    end)

    self.categoryListview.DataProvider:InsertTable(categories)

    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)
    addon:RegisterCallback("Database_OnInitialised", self.Database_OnInitialised, self)


    --quickly added for testing
    self.content.addon.factoryReset:SetScript("OnClick", function()
        Database:Reset()
    end)
    self.content.addon.debug.label:SetText(L.SETTINGS_ADDON_DEBUG_LABEL)
    self.content.addon.debug:SetScript("OnClick", function(cb)
        Database.db.debug = cb:GetChecked()
    end)

    addon.AddView(self)
end


function GuildbookSettingsMixin:UpdateLayout()
    local x, y = self.content:GetSize()

    local characterScroll = self.content.character.scrollFrame.scrollChild;

    if x < 650 then
        
        characterScroll.myCharacters:ClearAllPoints()
        characterScroll.myCharacters:SetPoint("TOP", characterScroll.specializations, "BOTTOM", 0, -10)


    else

        characterScroll.myCharacters:ClearAllPoints()
        characterScroll.myCharacters:SetPoint("TOPLEFT", characterScroll.specializations, "TOPRIGHT", 20, 0)
    end

end

function GuildbookSettingsMixin:CharacterPanel_OnShow()

    local x, y = self.content:GetSize()

    local panel = self.content.character.scrollFrame.scrollChild;

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

function GuildbookSettingsMixin:GuildBankPanel_OnShow()

    self.content.guildBank.listview.DataProvider:Flush()
    local t = {}
    if addon.characters then
        for k, character in pairs(addon.characters) do
            if character.data.publicNote:lower() == "guildbank" then
                table.insert(t, {
                    character = character,
                })
            end
        end
    end

    self.content.guildBank.listview.DataProvider:InsertTable(t)
end



function GuildbookSettingsMixin:SelectCategory(category)

    for k, v in ipairs(self.content.panels) do
        v:Hide()
    end
    if self.content[category] then
        self.content[category]:Show()
    end
end


function GuildbookSettingsMixin:ChatPanel_OnShow()

    if not self.panelsLoaded.chat then

        local chatSliders = {
            ["Guild history limit"] = "chatGuildHistoryLimit",
            ["Whisper history limit"] = "chatWhisperHistoryLimit",
        }
    
        for label, slider in pairs(chatSliders) do
    
            self.content.chat[slider].label:SetText(label)
            self.content.chat[slider]:SetMinMaxValues(10, 100)
    
            _G[self.content.chat[slider]:GetName().."Low"]:SetText(" ")
            _G[self.content.chat[slider]:GetName().."High"]:SetText(" ")
            _G[self.content.chat[slider]:GetName().."Text"]:SetText(" ")
    
            self.content.chat[slider]:SetScript("OnMouseWheel", function(s, delta)
                s:SetValue(s:GetValue() + delta)
            end)
    
            self.content.chat[slider]:SetScript("OnValueChanged", function(s)
                local val = math.ceil(s:GetValue())
                s.value:SetText(val)
                Database:SetConfig(slider, val)

                --make 2nd table copy over history limit and nil and set as new
            end)
        end

        self.panelsLoaded.chat = true;
    end

end

function GuildbookSettingsMixin:Database_OnInitialised()

    self.content.addon.debug:SetChecked(Database.db.debug)

    self.content.chat.chatGuildHistoryLimit:SetValue(Database.db.config.chatGuildHistoryLimit)
    self.content.chat.chatWhisperHistoryLimit:SetValue(Database.db.config.chatWhisperHistoryLimit)
end

