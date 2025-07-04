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
local Tradeskills = addon.Tradeskills;
local Talents = addon.Talents;
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
    self.resize:Init(self, 1000, 640, 1400, 820)

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
    addon:RegisterCallback("LogDebugMessage", self.LogDebugMessage, self)

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

    self:SetupDebugWindow()
end

function GuildbookMixin:LogDebugMessage()

    local t = {}

    if type(self.debug.debugTypeFilter) == "number" then
        for k, v in ipairs(addon.debugMessages) do
            if v.debugTypeID == self.debug.debugTypeFilter then
                table.insert(t, v)
            end
        end
        self.debug.messageLogListview.scrollView:SetDataProvider(CreateDataProvider(t))
    else

        self.debug.messageLogListview.scrollView:SetDataProvider(CreateDataProvider(addon.debugMessages))
    end
    
end

function GuildbookMixin:SetupDebugWindow()
    self.debug.clearLog:SetScript("OnClick", function()
        addon.debugMessages = {}
    end)

    self.debug.debugTypeFilter = false
    self.debug.debugTypeDropdown:SetMenu({
        {
            text = "All",
            func = function()
                self.debug.debugTypeFilter = false;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Comms",
            func = function()
                self.debug.debugTypeFilter = 3;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Comms In",
            func = function()
                self.debug.debugTypeFilter = 4;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Comms Out",
            func = function()
                self.debug.debugTypeFilter = 5;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Info",
            func = function()
                self.debug.debugTypeFilter = 2;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Warnings",
            func = function()
                self.debug.debugTypeFilter = 1;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Tradeskills",
            func = function()
                self.debug.debugTypeFilter = 7;
                self:LogDebugMessage()
            end,
        },
        {
            text = "Character",
            func = function()
                self.debug.debugTypeFilter = 8;
                self:LogDebugMessage()
            end,
        },
    })




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
    addon.LogDebugMessage("info", text)
end

function GuildbookMixin:OnUpdate()
    if not self:IsVisible() then
        return
    end
    if self.isRefreshEnabled then
        self:UpdateLayout()
    end

    -- if Database.db.debug then
    --     local mem = 0;
    --     UpdateAddOnMemoryUsage()
    --     mem = GetAddOnMemoryUsage(name)

    --     local fr = GetFramerate()
    --     self.memoryUsage:SetText(string.format("fps: %d mem: %d", math.floor(fr), math.floor(mem)))
    -- end
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
    self:Show()
end
-- function addon.SelectView(view)
--     GuildbookUI:SelectView(view)
-- end

function GuildbookMixin:AddView(view)
    --print(string.format("adding view [%s]", view.name))
    self.views[view.name] = view;
    view:SetParent(self.content)
    view:SetAllPoints()

    if view.UpdateLayout then
        view:UpdateLayout()
    end

    view:Hide()

    if view.helptips then
        for k, tip in ipairs(view.helptips) do
            tip:Hide()
        end
    end

    if self.ribbon[view.name:lower()] then
        --print(string.format("setting OnMouseDown script for [%s]", view.name))
        self.ribbon[view.name:lower()]:SetScript("OnMouseDown", function()
            self:SelectView(view.name)
        end)
    end

    --make home visible
    if view.name == "Home" then
        self:SelectView(view.name)
    end
end
function addon.AddView(view)
    GuildbookUI:AddView(view)
end

function GuildbookMixin:Blizzard_OnInitialGuildRosterScan(guildName)

    --So the addon should now have the guild and characters tables set, but lets hold it 1 second
    C_Timer.After(1, function()

        --get latest data and transmit to guild
        if addon.characters[addon.thisCharacter] then

            --if there is no main character data then set this character as main
            if addon.characters[addon.thisCharacter].data.mainCharacter == false then

                --first check if another of the players alts exists with the main character data set
                local mainCharacterNameOrFalse = Database:GetMainForGuild(addon.thisGuild)

                --if the return is a strign it will be the name of the main, otherwise false
                if type(mainCharacterNameOrFalse) == "string" then
                    addon.characters[addon.thisCharacter]:SetMainCharacter(mainCharacterNameOrFalse)
                else
                    addon.characters[addon.thisCharacter]:SetMainCharacter(addon.characters[addon.thisCharacter].data.name)
                end

                --fetch your characters for the guild
                local alts = Database:GetMyCharactersForGuild(addon.thisGuild)
                addon.characters[addon.thisCharacter]:UpdateAlts(alts, true)
            else

                --if a main character has been set we need to call UpdateAlts on that character object for the correct name
                local mainCharacter = addon.characters[addon.thisCharacter]:GetMainCharacter()
                if type(mainCharacter) == "string" then
                    if addon.characters[mainCharacter] then
                        local alts = Database:GetMyCharactersForGuild(addon.thisGuild)
                        addon.characters[mainCharacter]:UpdateAlts(alts, true)
                    end
                end
            end
        end
    end)

end


function GuildbookMixin:Database_OnInitialised()
    self:CreateMinimapButtons()
    self:CreateSlashCommands()

    self:Hide()

    Tradeskills.BuildEnchanterNameToSpellID()

    C_Timer.After(5, function()
        addon:AddMailAttachmentButton()

        --load all player characters and alts
        for nameRealm, _ in pairs(Database.db.myCharacters) do
            local character = Database:GetCharacter(nameRealm)
            if type(character) == "table" then
                if not addon.characters then
                    return
                end
                if not addon.characters[nameRealm] then
                    addon.characters[nameRealm] = Character:CreateFromData(character)
                end
            end 
        end

    end)
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

function GuildbookMixin:UpdateMinimapTooltip()

    GameTooltip:ClearLines()

    GameTooltip:AddLine(tostring('|cff0070DE'..name))

    local t = {} --addon.characters[name].data.onlineStatus
    if addon.characters then
        for name, obj in pairs(addon.characters) do
            if (name ~= nil) and (obj.data.class ~= nil) and (obj.data.level ~= nil) and obj.data.onlineStatus.isOnline then
                table.insert(t, {
                    name = obj.data.name,
                    displayName = obj:GetName(true, "short"),
                    classID = obj.data.class,
                    level = obj.data.level,
                    zone = obj.data.onlineStatus.zone or "-",
                })
            end
        end
        table.sort(t, function(a, b)
            if a.zone == b.zone then
                if a.classID == b.classID then
                    if a.level == b.level then
                        return a.name < b.name;
                    else
                        return a.level > b.level;
                    end
                else
                    return a.classID < b.classID;
                end
            else
                return a.zone < b.zone;
            end
        end)

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Members online")
        for i = 1, #t do
            if i < 26 then
                GameTooltip:AddDoubleLine(string.format("|cffffffff[%d]|r %s", t[i].level, t[i].displayName), string.format("|cffffffff%s", t[i].zone))
            end
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Left click to open", 1,1,1)
    end

    GameTooltip:Show()
end

function GuildbookMixin:CreateMinimapButtons()

    local ldb = LibStub("LibDataBroker-1.1")

    if not _G['LibDBIcon10_GuildbookMinimapButton'] then
        self.MinimapButtonDataObject = ldb:NewDataObject('GuildbookMinimapButton', {
            type = "launcher",
            icon = 134068,
            OnClick = function(_, button)
                self:SetShown(not self:IsVisible())
            end,
        })
        self.MinimapCalendarIcon = LibStub("LibDBIcon-1.0")
        self.MinimapCalendarIcon:Register('GuildbookMinimapButton', self.MinimapButtonDataObject, Database.db.calendarButton)
    end

    _G['LibDBIcon10_GuildbookMinimapButton'].UpdateTooltip = function()
        self:UpdateMinimapTooltip()
    end

    _G['LibDBIcon10_GuildbookMinimapButton']:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
        s:UpdateTooltip()
    end)
    _G['LibDBIcon10_GuildbookMinimapButton']:SetScript("OnLeave", function(s)
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)




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





-- -- create the available tags array
-- local tags = { "Sell", "Auction", "Vendor", }

-- -- saved variables table
-- local savedVariableTable = {}

-- -- modify the bag buttons, adding a new property with the key 'tagID'
-- for i = 1, 40 do
--     local bagSlotButton = _G["foo"];

--     bagSlotButton.tagID = 0;

--     -- hook the mouse down event
--     bagSlotButton:HookScript("OnMouseDown", function(self, button)
    
--         -- use alt and right button to avoid game ploay interactions
--         if (button == "RightButton") and IsAltKeyDown() then

--             -- increment the new property
--             self.tagID = self.tagID + 1
--         end

--         -- if the tagID goes beyond tags length return it 0 (0 will create a nil effect as tables start at 1)
--         if self.tagID > #tags then
--             self.tagID = 0;
--         end

--         -- update the saved variables table for this item, can get item data from bag/slot api
--         savedVariableTable[itemName] = self.tagID

--     end)
-- end

-- -- sudo tooltip update
-- function UpdateTooltip(tt)

--     -- check if saved variable table has this item and it the tags table has a matching index
--     if savedVariableTable[itemName] and tags[savedVariableTable[itemName]] then

--         -- add a line to the tooltip
--         tt:AddLine(tags[savedVariableTable[itemName]])
--     end
-- end






GuildbookUpdatesMixin = {}

function GuildbookUpdatesMixin:OnLoad()
    addon:RegisterCallback("Blizzard_OnInitialGuildRosterScan", self.SayHello, self)
end


function GuildbookUpdatesMixin:SayHello()
    
    local version = tonumber(GetAddOnMetadata(name, "Version"));

    if version > Database.db.version then

        self.versionHeader:SetText("version: "..addon.changeLog[1].version)
        self.text:SetText("|cffffffff"..addon.changeLog[1].notes)

        self.accept:SetScript("OnClick", function()
            Database.db.version = version;
            self:Hide()
        end)

        if type(addon.changeLog[1].icon) == "string" then
            self.icon:SetAtlas(addon.changeLog[1].icon)
        elseif type(addon.changeLog[1].icon) == "number" then
            self.icon:SetTexture(addon.changeLog[1].icon)
        end

        self:Show()

    end
end



-- local t = {}

-- for i = 1, 10 do
--     t[i] = {
--         name = string.format("Text Item %d", i),
--     }
-- end

-- local FooMixin = {}
-- function FooMixin:SetVar(var)
--     self.bar = var;
-- end

-- function FooMixin:GetVar()
--     return self.bar;
-- end

-- function FooMixin:GetName(i)
--     return self[i].name;
-- end

-- local x = Mixin(t, FooMixin)

-- print(x:GetName(3)) --Text Item 3 prints















-- GuildbookMailMixin = {}

-- function GuildbookMailMixin:OnLoad()
    
-- end






function GuildbookMixin:SetupInterface()

    local  content = CreateFrame("Frame", "GblContentContainer", CommunitiesFrame)
    content:SetPoint("TOPLEFT", CommunitiesFrame.CommunitiesList, "TOPRIGHT", 31, -46)
    content:SetPoint("BOTTOMRIGHT", CommunitiesFrame, -26, 28)
    content.background = content:CreateTexture(nil, "BACKGROUND")
    content.background:SetAtlas("Tooltip-NineSlice-Center")
    content.background:SetAllPoints()

    CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame:SetHeight(200)

    CommunitiesFrame.GblContentContainer = content;
    CommunitiesFrame.GuildBenefitsFrame:Hide()

    CommunitiesFrame.GuildBenefitsTab:SetScript("OnShow", function(button)
        button:Hide()
    end)
    CommunitiesFrame.GuildBenefitsTab:Hide()

    COMMUNITIES_FRAME_DISPLAY_MODES.GUILDBOOK = {
    "GblContentContainer",
    --"CommunitiesList",
    }
    COMMUNITIES_FRAME_DISPLAY_MODES.GUILD_BENEFITS = nil

    local function ShowGuildTabs(bool)
        CommunitiesFrame.ChatTab:SetShown(bool);
        CommunitiesFrame.RosterTab:SetShown(bool);
        --CommunitiesFrame.GuildBenefitsTab:SetShown(bool);
        CommunitiesFrame.GuildInfoTab:SetShown(bool);
    end

    GBL = {}
    GBL.Name = "GuildbookLight"

    GBL.TabButton = CreateFrame("CheckButton", GBL.Name.."TabButton", CommunitiesFrame, "CommunitiesFrameTabTemplate")
    GBL.TabButton.displayMode = COMMUNITIES_FRAME_DISPLAY_MODES.GUILDBOOK;
    GBL.TabButton:SetPoint("TOPLEFT", CommunitiesFrame.GuildInfoTab, "BOTTOMLEFT", 0, -20)
    GBL.TabButton.Icon:SetAtlas("Mobile-Blacksmithing")

    hooksecurefunc(CommunitiesFrame, "UpdateCommunitiesTabs", function()
        ShowGuildTabs(true)
        GBL.TabButton:SetChecked(CommunitiesFrame.displayMode == COMMUNITIES_FRAME_DISPLAY_MODES.GUILDBOOK)
    end)


        -- hooksecurefunc(CommunitiesFrame, "SetDisplayMode", function(CommunitiesFrame)
    --     DevTools_Dump(CommunitiesFrame.displayMode)
    --     local subframesToUpdate = {};
    --     for i, mode in pairs(COMMUNITIES_FRAME_DISPLAY_MODES) do
    --         for j, subframe in ipairs(mode) do
    --             subframesToUpdate[subframe] = subframesToUpdate[subframe] or mode == CommunitiesFrame.displayMode;
    --             --print(i, CommunitiesFrame.displayMode, subframe, subframesToUpdate[subframe])
    --         end
    --     end
    
    --     if CommunitiesFrame:IsShowingApplicantList() then
    --         CommunitiesFrame:UpdateSeenApplicants();
    --     end
    
    --     for subframe, shouldShow in pairs(subframesToUpdate) do
    --         CommunitiesFrame[subframe]:SetShown(shouldShow);
    --     end
    -- end)
end







function GuildbookMixin:CreateCursorBuddy()

    if 1 == 1 then
        return
    end


    local frame = CreateFrame("Frame")
    NineSliceUtil.ApplyLayout(frame, addon.api.getNineSliceTooltipBorder(10))

    frame:SetSize(80, 80)

    local function updatePosition()
        local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
        --frame:SetPoint("CENTER", nil, "BOTTOMLEFT", x / uiScale, y / uiScale)
        frame:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", x, y)
    end



    frame:SetScript("OnUpdate", function()
    
        updatePosition()
    end)

end