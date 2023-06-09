local name, addon = ...;

--[[
    Guildbook.ContextMenu_Separator = "|TInterface/COMMON/UI-TooltipDivider:8:150|t"
Guildbook.ContextMenu_Separator_Wide = "|TInterface/COMMON/UI-TooltipDivider:8:250|t"



                privacy = {
                    shareInventoryMinRank = lowestRank,
                    shareTalentsMinRank = lowestRank,
                    shareProfileMinRank = lowestRank,
                },
                modifyDefaultGuildRoster = true,
                showTooltipTradeskills = true,
                showTooltipTradeskillsRecipes = true,
                showMinimapButton = true,
                showMinimapCalendarButton = true,
                showTooltipCharacterInfo = true,
                showTooltipMainCharacter = true,
                showTooltipMainSpec = true,
                showTooltipProfessions = true,
                parsePublicNotes = false,
                showInfoMessages = true,
                blockCommsDuringCombat = true,
                blockCommsDuringInstance = true,

    GameTooltip:HookScript("OnTooltipSetItem", function(self)
        if not GUILDBOOK_GLOBAL then
            return;
        end
        local name, link = GameTooltip:GetItem()
        if link then
            local itemID = GetItemInfoInstant(link)
            if itemID then
                if GUILDBOOK_GLOBAL.config and GUILDBOOK_GLOBAL.config.showTooltipTradeskills and Guildbook.tradeskillRecipes then
                    local headerAdded = false;
                    local profs = {}
                    for k, recipe in ipairs(Guildbook.tradeskillRecipes) do
                        if recipe.reagents then
                            for id, _ in pairs(recipe.reagents) do
                                if id == itemID then
                                    if headerAdded == false then
                                        --self:AddLine(" ")
                                        self:AddLine(Guildbook.ContextMenu_Separator_Wide)
                                        self:AddLine(L["TOOLTIP_ITEM_RECIPE_HEADER"])
                                        headerAdded = true;
                                    end
                                    if not profs[recipe.profession] then
                                        profs[recipe.profession] = true
                                        if GUILDBOOK_GLOBAL.config.showTooltipTradeskillsRecipes then
                                            self:AddLine(" ")
                                        end
                                        self:AddLine(Guildbook.Data.Profession[recipe.profession].FontStringIconMEDIUM.."  "..recipe.profession)
                                    end
                                    if GUILDBOOK_GLOBAL.config.showTooltipTradeskillsRecipes then
                                        self:AddLine(recipe.name, 1,1,1,1)
                                    end
                                end
                            end
                        end
                    end
                    if headerAdded == true then
                        self:AddLine(Guildbook.ContextMenu_Separator_Wide)
                        --self:AddLine(" ")
                    end
                end
            end
        end

        -- local characters = {}
        -- if 1 == 1 then -- place holder for a options setting
        --     if GUILDBOOK_GLOBAL.MySacks then
        --         if GUILDBOOK_GLOBAL.MySacks.Banks then
        --             for guid, items in pairs(GUILDBOOK_GLOBAL.MySacks.Banks) do
        --                 if items[itemID] then
        --                     table.insert(characters, {
        --                         guid = guid,
        --                         count = items[itemID].count,
        --                     })
        --                 end
        --             end
        --         end
        --     end
        -- end

    end)

    local tooltipIcon = CreateFrame("FRAME", "GuildbookTooltipIcon")
    tooltipIcon:SetSize(1,1)
    tooltipIcon.icon = tooltipIcon:CreateTexture(nil, "BACKGROUND")
    tooltipIcon.icon:SetAllPoints()
    -- hook the tooltip for guild characters
    GameTooltip:HookScript('OnTooltipSetUnit', function(self)
        if not GUILDBOOK_GLOBAL then
            return;
        end
        if GUILDBOOK_GLOBAL.config.showTooltipCharacterInfo == false then
            return;
        end
        local _, unit = self:GetUnit()
        local guid = unit and UnitGUID(unit) or nil
        if guid and guid:find('Player') then
            local character = Guildbook:GetCharacterFromCache(guid)
            if not character then
                return;
            end
            -- Guildbook:SendProfileRequest(character.Name)
            -- Guildbook:CharacterDataRequest(character.Name)
            self:AddLine(" ")
            self:AddLine('Guildbook:', 0.00, 0.44, 0.87, 1)
            if GUILDBOOK_GLOBAL.config.showTooltipMainSpec == true then
                if character.MainSpec then
                    local mainSpec = false;
                    if character.MainSpec == "Bear" then
                        mainSpec = "Guardian"
                    elseif character.MainSpec == "Cat" then
                        mainSpec = "Feral"
                    elseif character.MainSpec == "Beast Master" or character.MainSpec == "BeastMaster" then
                        mainSpec = "BeastMastery"
                    end
                    local iconString = CreateAtlasMarkup(string.format("GarrMission_ClassIcon-%s-%s", character.Class, mainSpec and mainSpec or character.MainSpec), 24,24)
                    self:AddLine(iconString.. "  |cffffffff"..character.MainSpec)
                end
            end
            if GUILDBOOK_GLOBAL.config.showTooltipProfessions == true then
                if character.Profession1 ~= '-' and Guildbook.Data.Profession[character.Profession1] then
                    self:AddDoubleLine(character.Profession1, character.Profession1Level, 1,1,1,1,1,1,1,1)
                end
                if character.Profession2 ~= '-' and Guildbook.Data.Profession[character.Profession2] then
                    self:AddDoubleLine(character.Profession2, character.Profession2Level, 1,1,1,1,1,1,1,1)
                end
            end
            --self:AddTexture(Guildbook.Data.Class[character.Class].Icon,{width = 36, height = 36})
            if 1 == 1 then
                if character.profile then
                    self:AddLine(" ")
                    self:AddLine(character.profile.realBio, 1,1,1,1, 1)
                end
            end
            if GUILDBOOK_GLOBAL.config.showTooltipMainCharacter == true then
                if character.MainCharacter then
                    local main = Guildbook:GetCharacterFromCache(character.MainCharacter)
                    if main then
                        self:AddDoubleLine(L['MAIN_CHARACTER'], main.Name, 1, 1, 1, 1, 1, 1, 1, 1) 
                    end
                end
            end
        end
    end)
]]

local Database = addon.Database;
local L = addon.Locales;
local Character = addon.Character;
local json = LibStub('JsonLua-1.0');

GuildbookMixin = {
    views = {},
    debugLog = {},
    viewHistory = {},
    helptipsShown = false,
}

function GuildbookMixin:UpdateLayout()

    for k, v in pairs(self.views) do
        if v.UpdateLayout then
            v:UpdateLayout()
        end
    end

    addon:TriggerEvent("UI_OnSizeChanged")
end

function GuildbookMixin:OnLoad()
    
    self:RegisterForDrag("LeftButton")
    self.resize:Init(self, 600, 450, 1100, 650)

    self.resize:HookScript("OnMouseDown", function()
        self.isRefreshEnabled = true;
    end)
    self.resize:HookScript("OnMouseUp", function()
        self.isRefreshEnabled = false;
    end)

    self:SetScript("OnHide", function()
        collectgarbage("collect")
    end)

    SetPortraitToTexture(GuildbookUIPortrait,134068)
    self.portraitButton:SetScript("OnMouseDown", function()
        if addon.characters and addon.characters[addon.thisCharacter] then
            addon:TriggerEvent("Character_OnProfileSelected", addon.characters[addon.thisCharacter])
        end
    end)

    addon:RegisterCallback("Database_OnInitialised", self.Database_OnInitialised, self)
    addon:RegisterCallback("StatusText_OnChanged", self.SetStatausText, self)
    addon:RegisterCallback("Player_Regen_Enabled", self.Player_Regen_Enabled, self)
    addon:RegisterCallback("Player_Regen_Disabled", self.Player_Regen_Disabled, self)
    addon:RegisterCallback("Blizzard_OnInitialGuildRosterScan", self.Blizzard_OnInitialGuildRosterScan, self)

    self.ribbon.searchBox:SetScript("OnEnterPressed", function(searchBox)
        self:SelectView("Search")
        self:Search(searchBox:GetText())
    end)
    self.ribbon.searchBox:SetScript("OnTextChanged", function(searchBox)
        if searchBox:GetText():sub(1,1) == ">" then
            self:ShowSpecialFrame(searchBox:GetText():sub(2))
        end
    end)

    self.ribbon.viewHistoryBack.background:SetAtlas("glueannouncementpopup-arrow")
    self.ribbon.viewHistoryBack.background:SetTexCoord(1.0, 0.0, 0.0, 1.0)
    self.ribbon.viewHistoryBack:SetScript("OnMouseDown", function ()
        local viewHistoryLen = #self.viewHistory;
        if viewHistoryLen > 1 then
            self:SelectView(self.viewHistory[(viewHistoryLen - 1)])
            table.remove(self.viewHistory, viewHistoryLen)
            table.remove(self.viewHistory, viewHistoryLen - 1) --as we just selected the previous view it needs to be removed else its doubled
        end
    end)

    self.settings:SetScript("OnMouseDown", function()
        self:SelectView("Settings")
    end)
    self.help:SetScript("OnMouseDown", function()
        self:ToggleHelptips()
    end)

    self:SetupImportExport()
end

function GuildbookMixin:Player_Regen_Disabled()
    self:Hide()
end

function GuildbookMixin:Player_Regen_Enabled()

end

function GuildbookMixin:ToggleHelptips()
    self.helptipsShown = not self.helptipsShown;

    for name, view in pairs(self.views) do
        if view.helptips then
            for k, tip in ipairs(view.helptips) do
                tip:SetShown(self.helptipsShown)
            end
        end
    end
end

function GuildbookMixin:SetupImportExport()

    self.import.importExportEditbox.EditBox:SetMaxLetters(1000000000)

    local testData = {
        name = "calendar",
        data = {
            {
                foo = 1,
                bar = false,
            }
        },
        version = 0.1,
    }
    self.import.importExportEditbox.EditBox:SetText(json.encode(testData))
    
    self.import.importData:SetScript("OnClick", function()
        local data = self.import.importExportEditbox.EditBox:GetText()
        if data and (data ~= "") and (data ~= " ") then
            Database:ImportData(data);
        end
    end)
end

function GuildbookMixin:ShowSpecialFrame(frame)
    for k, v in ipairs(self.specialFrames) do
        v:Hide()
    end
    if self[frame] then
        self.content:Hide()
        self[frame]:Show()
    end
end

function GuildbookMixin:SetStatausText(text)
    self.statusText:SetText(text)
    --self:LogDebugMessage("info", text)
end

function GuildbookMixin:OnUpdate()
    if not self:IsVisible() then
        return
    end
    if self.isRefreshEnabled then
        self:UpdateLayout()
    end

    -- UpdateAddOnMemoryUsage()
    -- local mem = GetAddOnMemoryUsage(name)

    local mem = 0.4
    local fr = GetFramerate()
    self.memoryUsage:SetText(string.format("fps: %d mem: %d", math.floor(fr), math.floor(mem)))
end

function GuildbookMixin:OnEvent()
    
end

function GuildbookMixin:SelectView(view)
    self.content:Show()
    for k, v in pairs(self.views) do
        v:Hide()
    end
    for k, v in ipairs(self.specialFrames) do
        v:Hide()
    end
    if self.views[view] then
        self.views[view]:Show()
        table.insert(self.viewHistory, view)
--        DevTools_Dump(self.viewHistory)
    end
end

function GuildbookMixin:AddView(view)
    self.views[view.name] = view;
    view:SetParent(self.content)
    view:SetAllPoints()
    view:Hide()

    if view.helptips then
        for k, tip in ipairs(view.helptips) do
            tip:Hide()
        end
    end

    if self.ribbon[view.name:lower()] then
        self.ribbon[view.name:lower()]:SetScript("OnMouseDown", function()
            self:SelectView(view.name)
        end)
    end
end
function addon.AddView(view)
    GuildbookUI:AddView(view)
end

function GuildbookMixin:Blizzard_OnInitialGuildRosterScan(guildName)

    --So the addon should now have the guild and characters tables set, but lets hold it 1 second
    C_Timer.After(1, function()

        --atm this will re set the data which is used o trigger the braodcast
        --TODO: update this to check for data and then broadcast, save the extra fun calls
        local equipment = addon.api.classic.getPlayerEquipment()
        local currentStats = addon.api.classic.getPaperDollStats()
        local resistances = addon.api.classic.getPlayerResistances(UnitLevel("player"))
        local auras = addon.api.classic.getPlayerAuras()
        local talents = addon.api.classic.getPlayerTalents()

        if addon.characters[addon.thisCharacter] then
            addon.characters[addon.thisCharacter]:SetTalents("current", talents, true)
            addon.characters[addon.thisCharacter]:SetInventory("current", equipment, true)
            addon.characters[addon.thisCharacter]:SetPaperdollStats("current", currentStats, true)
            addon.characters[addon.thisCharacter]:SetResistances("current", resistances, true)
            addon.characters[addon.thisCharacter]:SetAuras("current", auras, true)

            if addon.characters[addon.thisCharacter].data.mainSpec then
                addon:TriggerEvent("Character_BroadcastChange", addon.characters[addon.thisCharacter], "SetSpec", "mainSpec")
            end
        end
    end)

end

function GuildbookMixin:Database_OnInitialised()
    self:CreateMinimapButtons()
    self:CreateSlashCommands()
    if addon.characters[addon.thisCharacter] then
        self.ribbon.myProfile.background:SetAtlas(addon.characters[addon.thisCharacter]:GetProfileAvatar())
    end
--minortalents-icon-book socialqueuing-icon-eye

    --experimental
    -- local hbd = LibStub("HereBeDragons-2.0")
    -- local currentMapID = C_Map.GetBestMapForUnit('player')
    -- if not currentMapID then
    --     return
    -- else
    --     local currentMapPosition = C_Map.GetPlayerMapPosition(currentMapID, 'player')
    --     local x, y, instance = hbd:GetWorldCoordinatesFromZone(currentMapPosition.x, currentMapPosition.y, currentMapID)

    --     print(x, y)
    -- end
end

function GuildbookMixin:CreateSlashCommands()
    SLASH_GUILDBOOK1 = '/guildbook'
    SLASH_GUILDBOOK2 = '/gbk'
    SLASH_GUILDBOOK3 = '/gb'
    SlashCmdList['GUILDBOOK'] = function(msg)
        if msg == "" then
            self:Show()
        end
    end
end

function GuildbookMixin:CreateMinimapButtons()

    local ldb = LibStub("LibDataBroker-1.1")
    --[[
    self.MinimapButton = ldb:NewDataObject('GuildbookMinimapIcon', {
        type = "launcher",
        icon = 134068,
        OnClick = function(_, button)
            if button == "RightButton" then
                if InterfaceOptionsFrame:IsVisible() then
                    InterfaceOptionsFrame:Hide()
                else
                    InterfaceOptionsFrame_OpenToCategory(name)
                    InterfaceOptionsFrame_OpenToCategory(name)
                end
            elseif button == 'MiddleButton' then
                if IsShiftKeyDown() then
                    FriendsFrame:Show()
                else
                    ToggleFriendsFrame(3)
                end
            elseif button == "LeftButton" then
                self:SetShown(not self:IsVisible())
            end
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:AddLine(tostring('|cff0070DE'..name))
            tooltip:AddDoubleLine(L["MINIMAP_TOOLTIP_LEFTCLICK"])
            tooltip:AddDoubleLine(L["MINIMAP_TOOLTIP_LEFTCLICK_SHIFT"])
            tooltip:AddDoubleLine(L["MINIMAP_TOOLTIP_RIGHTCLICK"])
            tooltip:AddDoubleLine(L["MINIMAP_TOOLTIP_MIDDLECLICK"])
        end,
    })
    self.MinimapIcon = LibStub("LibDBIcon-1.0")
    self.MinimapIcon:Register('GuildbookMinimapIcon', self.MinimapButton, GUILDBOOK_GLOBAL.minimapButton)
    ]]

    if not _G['LibDBIcon10_GuildbookMinimapCalendarIcon'] then
        self.MinimapCalendarButton = ldb:NewDataObject('GuildbookMinimapCalendarIcon', {
            type = "data source",
            icon = 134939,
            OnClick = function(_, button)
                self:SetShown(not self:IsVisible())
            end,
            OnTooltipShow = function(tooltip)
                if not tooltip or not tooltip.AddLine then return end
                tooltip:AddLine(tostring('|cff0070DE'..name))
            end,
        })
        self.MinimapCalendarIcon = LibStub("LibDBIcon-1.0")
        self.MinimapCalendarIcon:Register('GuildbookMinimapCalendarIcon', self.MinimapCalendarButton, GUILDBOOK_GLOBAL.calendarButton)
        for i = 1, _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:GetNumRegions() do
            local region = select(i, _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:GetRegions())
            if (region:GetObjectType() == 'Texture') then
                region:Hide()
            end
        end
        -- modify the minimap icon to match the blizz calendar button
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:SetSize(44,44)
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:GetNormalTexture():SetTexCoord(0.0, 0.390625, 0.0, 0.78125)
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:GetPushedTexture():SetTexCoord(0.5, 0.890625, 0.0, 0.78125)
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon'].Text = _G['LibDBIcon10_GuildbookMinimapCalendarIcon']:CreateFontString(nil, 'OVERLAY', 'GameFontBlack')
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon'].Text:SetPoint('CENTER', -1, -1)
        _G['LibDBIcon10_GuildbookMinimapCalendarIcon'].Text:SetText(date('*t').day)
        -- setup a ticker to update the date, kinda overkill maybe ?
        C_Timer.NewTicker(1, function()
            _G['LibDBIcon10_GuildbookMinimapCalendarIcon'].Text:SetText(date('*t').day)
        end)
    end
end

function GuildbookMixin:Search(text)
    addon:TriggerEvent("Guildbook_OnSearch", text)
end














--[[


local fileID = 521743;

local itemsPerPage = 25;

local viewer = CreateFrame("Frame", "hslTextureViewer", UIParent, "BasicFrameTemplateWithInset")
viewer:SetSize(810, 550)
viewer:SetPoint("CENTER", 0, 0)
viewer:SetMovable(true)
viewer:EnableMouse(true)
viewer:RegisterForDrag("LeftButton")
viewer:SetScript("OnDragStart", viewer.StartMoving)
viewer:SetScript("OnDragStop", viewer.StopMovingOrSizing)
viewer:Hide()

viewer.editbox = CreateFrame("EDITBOX", nil, viewer, "InputBoxTemplate")
viewer.editbox:SetPoint("TOP", 0, 0)
viewer.editbox:SetSize(100, 20)
viewer.editbox:SetAutoFocus(false)
viewer.editbox:SetScript("OnTextChanged", function(self)
    if tonumber(self:GetText()) then
        fileID = self:GetText()
        for i = 1, itemsPerPage do
            viewer.textures[i].texture:SetTexture(fileID + i)
            viewer.textures[i].text:SetText(fileID + i)
        end
    end
end)

viewer.prev = CreateFrame("BUTTON", nil, viewer, "UIPanelButtonTemplate")
viewer.prev:SetPoint("RIGHT", viewer.editbox, "LEFT", -20, 0)
viewer.prev:SetSize(80, 20)
viewer.prev:SetText("Prev")
viewer.prev:SetScript("OnClick", function(self)
    fileID = fileID - itemsPerPage
    for i = 1, itemsPerPage do
        viewer.textures[i].texture:SetTexture(fileID + i)
        viewer.textures[i].text:SetText(fileID + i)
    end
    viewer.editbox:ClearFocus()
end)

viewer.next = CreateFrame("BUTTON", nil, viewer, "UIPanelButtonTemplate")
viewer.next:SetPoint("LEFT", viewer.editbox, "RIGHT", 20, 0)
viewer.next:SetSize(80, 20)
viewer.next:SetText("Next")
viewer.next:SetScript("OnClick", function(self)
    fileID = fileID + itemsPerPage
    for i = 1, itemsPerPage do
        viewer.textures[i].texture:SetTexture(fileID + i)
        viewer.textures[i].text:SetText(fileID + i)
    end
    viewer.editbox:ClearFocus()
end)

viewer.textures = {}
local i = 1;
for row = 0, 4 do
    for col = 0, 4 do
        local t = viewer:CreateTexture(nil, "ARTWORK")
        t:SetSize(155, 82.5)
        t:SetPoint("TOPLEFT", (col * 155) + 20, (row * -100) - 30)
        local f = viewer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f:SetPoint("BOTTOM", t, "BOTTOM", 0, -14)
        viewer.textures[i] = {
            texture = t,
            text = f,
        }
        i = i + 1
    end
end

]]