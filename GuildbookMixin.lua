local name, addon = ...;

local L = addon.Locales;
local Character = addon.Character;

GuildbookMixin = {
    views = {},
    debugLog = {},
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
    self.resize:Init(self, 550, 450, 1100, 650)

    self.resize:HookScript("OnMouseDown", function()
        self.isRefreshEnabled = true;
    end)
    self.resize:HookScript("OnMouseUp", function()
        self.isRefreshEnabled = false;
    end)

    SetPortraitToTexture(GuildbookUIPortrait,134068)

    addon:RegisterCallback("Database_OnInitialised", self.Database_OnInitialised, self)
    addon:RegisterCallback("StatusText_OnChanged", self.SetStatausText, self)

    self.ribbon.searchBox:SetScript("OnTextChanged", function(searchBox)
        if searchBox:GetText() == ">debug" then
            self.content:Hide()
            self.debug:Show()
        else
            self.content:Show()
            self.debug:Hide()
        end
    end)

end

function GuildbookMixin:SetStatausText(text)
    self.statusText:SetText(text)

    -- table.insert(self.debugLog, {
    --     label = string.format("[%s] %s", date("*T"), text)
    -- })

    self.debug.messageLogListview.DataProvider:Insert({
        label = string.format("[%s] %s", date("%T"), text),
        atlas = "services-icon-warning",
    })
    self.debug.messageLogListview.scrollBox:ScrollToEnd()
end

function GuildbookMixin:OnUpdate()
    if not self:IsVisible() then
        return
    end
    if self.isRefreshEnabled then
        self:UpdateLayout()
    end
end

function GuildbookMixin:OnEvent()
    
end

function GuildbookMixin:SelectView(view)
    self.content:Show()
    self.debug:Hide()
    for k, v in pairs(self.views) do
        v:Hide()
    end
    if self.views[view] then
        self.views[view]:Show()
    end
end

function GuildbookMixin:AddView(view)
    self.views[view.name] = view;
    view:SetParent(self.content)
    view:SetAllPoints()
    view:Hide()

    if self.ribbon[view.name:lower()] then
        self.ribbon[view.name:lower()]:SetScript("OnMouseDown", function()
            self:SelectView(view.name)
        end)
    end
end

function addon.AddView(view)
    GuildbookUI:AddView(view)
end

function GuildbookMixin:Database_OnInitialised()
    self:CreateMinimapButtons()
    if addon.characters[addon.thisCharacter] then
        self.ribbon.profile.background:SetAtlas(addon.characters[addon.thisCharacter]:GetProfileAvatar())
    end
end

function GuildbookMixin:CreateMinimapButtons()
    local ldb = LibStub("LibDataBroker-1.1")
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
end
