local name, addon = ...;

GuildbookGuildRosterMixin = {
    name = "GuildRoster",
}

function GuildbookGuildRosterMixin:OnLoad()

    addon:RegisterCallback("Blizzard_OnGuildRosterUpdate", self.Blizzard_OnGuildRosterUpdate, self)

    addon.AddView(self)
end

function GuildbookGuildRosterMixin:Update()

    self.rosterListview.DataProvider:Flush()

    local t = {}
    for nameRealm, obj in pairs(addon.characters) do
        table.insert(t, obj)
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
    self:Update()
end