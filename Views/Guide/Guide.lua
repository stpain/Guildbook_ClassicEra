local name, addon = ...;
local L = addon.Locales;
local Database = addon.Database;


GuildbookGuideMixin = {
    name = "Guide",
    selectedInstance = "",
    selectedInstanceMapID = 1,
    helptips = {},
    tabs = {
        "lore",
        "loot",
        "maps",
    },
    selectedTab = 1,
}

function GuildbookGuideMixin:OnLoad()

    self.previousTab:SetScript("OnClick", function()
        self.selectedTab = self.selectedTab - 1;
        if self.selectedTab < 1 then
            self.selectedTab = 1;
        end
        self:SelectTab(self.selectedTab)
    end)
    self.nextTab:SetScript("OnClick", function()
        self.selectedTab = self.selectedTab + 1;
        if self.selectedTab > 3 then
            self.selectedTab = 3;
        end
        self:SelectTab(self.selectedTab)
    end)

    self.maps.previous:SetNormalTexture(130869)
    self.maps.previous:SetPushedTexture(130868)
    self.maps.previous:SetScript("OnClick", function()
        if self.selectedInstance then
            self.selectedInstanceMapID = self.selectedInstanceMapID - 1;
            if self.selectedInstanceMapID < 1 then
                self.selectedInstanceMapID = 1;
            end
            self.maps.background:SetTexture(self.selectedInstance.maps[self.selectedInstanceMapID])
        end
    end)
    self.maps.next:SetNormalTexture(130866)
    self.maps.next:SetPushedTexture(130865)
    self.maps.next:SetScript("OnClick", function()
        if self.selectedInstance then
            self.selectedInstanceMapID = self.selectedInstanceMapID + 1;
            if self.selectedInstanceMapID > #self.selectedInstance.maps then
                self.selectedInstanceMapID = #self.selectedInstance.maps;
            end
            self.maps.background:SetTexture(self.selectedInstance.maps[self.selectedInstanceMapID])
        end
    end)

    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)

    local dungeonMenu = {}
    for k, v in ipairs(addon.dungeons) do
        table.insert(dungeonMenu,{
            text = v.name,
            func = function()
                self:LoadData(v)
            end,
        })
    end

    self.instanceDropdown:SetMenu(dungeonMenu)


    addon.AddView(self)
end

function GuildbookGuideMixin:SelectTab(tabID)
    for k, tab in ipairs(self.tabs) do
        self[tab]:Hide()
    end
    self[self.tabs[tabID]]:Show()
end

function GuildbookGuideMixin:UpdateLayout()

    local x, y = self:GetSize()

    if x < 650 then
        
        self.lore.info:SetWidth(1)
        self.lore.info:Hide()
        self.lore.lore:SetHeight((y - 40) / 2)
    else

        self.lore.info:SetWidth(x * 0.4)
        self.lore.info:Show()
        self.lore.lore:SetHeight((y - 40) / 2)
    end
end

function GuildbookGuideMixin:LoadData(data)

    self.selectedInstance = data;

    self.lore.info.loreArtwork:SetTexture(data.loreArtFileID)
    self.lore.info.meta:SetText(string.format("%s\n%s\n%s-%s", data.name, data.meta.zone, data.meta.minLevel, data.meta.maxLevel))

    self.lore.lore.text:SetText(data.history)

    local t = {}
    for k, v in ipairs(data.bosses) do
        table.insert(t, {
            label = v,
        })
    end
    local dp = CreateDataProvider(t)
    self.loot.encounterListview.scrollView:SetDataProvider(dp)

    self.maps.background:SetTexture(data.maps[self.selectedInstanceMapID])
    if #data.maps > 1 then
        
    else

    end
end