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

    -- self.previousTab:SetScript("OnClick", function()
    --     self.selectedTab = self.selectedTab - 1;
    --     if self.selectedTab < 1 then
    --         self.selectedTab = 1;
    --     end
    --     self:SelectTab(self.selectedTab)
    -- end)
    -- self.nextTab:SetScript("OnClick", function()
    --     self.selectedTab = self.selectedTab + 1;
    --     if self.selectedTab > 3 then
    --         self.selectedTab = 3;
    --     end
    --     self:SelectTab(self.selectedTab)
    -- end)

    self.mapsButton:SetScript("OnMouseDown", function()
        self:SelectTab(3)
    end)
    self.encountersButton:SetScript("OnMouseDown", function()
        self:SelectTab(2)
    end)
    self.infoButton:SetScript("OnMouseDown", function()
        self:SelectTab(1)
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

    self.lore.loot.gridview:InitFramePool("FRAME", "GuildbookCircleLootItemTemplate")
    --self.lore.loot.gridview:SetFixedColumnCount(5)
    self.lore.loot.gridview:SetMinMaxSize(80, 110)

    local dungeonMenu = {}
    for k, v in ipairs(addon.dungeons) do
        table.insert(dungeonMenu,{
            text = v.name,
            func = function()
                self:LoadData(v)
            end,
        })
    end

    local raidMenu = {
        {
            text = "Molten Core",
        },
        {
            text = "Blackwing Lair",
        },
        {
            text = [[Zul'gurub]],
        },
    }

    local homeMenu = {
        {
            text = "Dungeons",
            func = function()
                self.activityDropdown:SetMenu(dungeonMenu)
            end,
        },
        {
            text = "Raids",
            func = function()
                self.activityDropdown:SetMenu(raidMenu)
            end,
        },
    }

    self.homeDropdown:SetMenu(homeMenu)

    self:SetScript("OnShow", function()
        self:UpdateLayout()
    end)

    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)
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

    y = y - 40;

    if x < 650 then
        
        self.lore.info:SetWidth(1)
        self.lore.info:Hide()
        self.lore.history:SetSize((x - 1), y / 2)


    else

        self.lore.info:SetWidth(x * 0.4)
        self.lore.info:Show()
        self.lore.history:SetSize(x * 0.6, y / 2)

    end

    self.lore.history.text:SetText(self.selectedInstance.history)

    self.lore.loot.gridview:UpdateLayout()
    self.lore.loot.banner:SetSize(self.lore.history:GetWidth() * 0.33, 50)
    self.lore.loot.header:SetSize(self.lore.history:GetWidth() * 0.33, 40)
    self.lore.history.banner:SetSize(self.lore.history:GetWidth() * 0.33, 50)
    self.lore.history.header:SetSize(self.lore.history:GetWidth() * 0.33, 40)
end

function GuildbookGuideMixin:LoadData(data)

    self.selectedInstance = data;

    local loot = {}

    --this means only using ItemMixin once
    local updateLoot = function()
        table.sort(loot, function(a, b)
            return a.subClass < b.subClass;
        end)
        self.lore.loot.gridview:Flush() --doesn't use DataProvider
        for k, v in ipairs(loot) do
            self.lore.loot.gridview:Insert({
                icon = v.icon,
                link = v.link,
                colour = v.colour,
                subClass = v.subClass,
            })
            self.lore.loot.gridview:UpdateLayout()
        end


    end

    for boss, items in pairs(data.loot) do
        for k, id in ipairs(items) do
            local item = Item:CreateFromItemID(id)
            if not item:IsItemEmpty() then
                item:ContinueOnItemLoad(function()
                    local _, _, subClass = GetItemInfoInstant(id)
                    table.insert(loot, {
                        icon = item:GetItemIcon(),
                        link = item:GetItemLink(),
                        colour = item:GetItemQualityColor(),
                        boss = boss,
                        subClass = subClass,
                    })
                    updateLoot()
                end)
            end
        end
    end

    self.lore.info.loreArtwork:SetTexture(data.loreArtFileID)
    self.lore.info.meta:SetText(string.format("%s\n%s\n%s-%s", data.name, data.meta.zone, data.meta.minLevel, data.meta.maxLevel))

    --self.lore.history.text:SetFontObject(GameFontNormal_NoShadow)
    self.lore.history.text:GetFontString():SetTextColor(CreateColor(0.002, 0.002, 0.001))
    self.lore.history.text:SetText(data.history)

    local t1 = {}
    for k, boss in ipairs(data.bosses) do
        table.insert(t1, {
            label = boss,
            func = function()
                self.loot.lootListview.DataProvider:Flush()
                local t2 ={}
                for k, v in ipairs(loot) do
                    if v.boss == boss then
                        table.insert(t2, {
                            label = v.link,
                            texture = v.icon,
                        })
                    end
                end
                self.loot.lootListview.DataProvider:InsertTable(t2)
            end,
        })
    end
    local dp = CreateDataProvider(t1)
    self.loot.encounterListview.scrollView:SetDataProvider(dp)

    self.maps.background:SetTexture(data.maps[self.selectedInstanceMapID])
    if #data.maps > 1 then
        
    else

    end

end