local name, addon = ...;

GuildbookGuildRosterMixin = {
    name = "GuildRoster",
    showOffline = false,
}

function GuildbookGuildRosterMixin:OnLoad()

    addon:RegisterCallback("Blizzard_OnGuildRosterUpdate", self.Blizzard_OnGuildRosterUpdate, self)

    self.showOffline.label:SetText("Show Offline")
    self.showOffline:SetScript("OnClick", function()
        self.showOffline = not self.showOffline;
        self:Update()
    end)

    addon.AddView(self)
end

function GuildbookGuildRosterMixin:Update()


    self.rosterListview.DataProvider:Flush()

    local t = {}
    for nameRealm, obj in pairs(addon.characters) do
        if self.showOffline then
            table.insert(t, obj)
        else
            if obj.data.onlineStatus.isOnline then
                table.insert(t, obj)
            end
        end
    end

    table.sort(t, function(a, b)
        if a.data.class == b.data.class then
            return a.data.name < b.data.name
        else
            return a.data.class < b.data.class
        end
    end)

    self.rosterListview.DataProvider:InsertTable(t)
end

function GuildbookGuildRosterMixin:Blizzard_OnGuildRosterUpdate()
    self:Update()
end

function GuildbookGuildRosterMixin:OnShow()
    GuildRoster() --this will trigger a callback to self:Update
end