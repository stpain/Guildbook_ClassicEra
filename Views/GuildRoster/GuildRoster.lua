local name, addon = ...;

GuildbookGuildRosterMixin = {
    name = "GuildRoster",
}

function GuildbookGuildRosterMixin:OnLoad()

    addon.AddView(self)
end

function GuildbookGuildRosterMixin:OnShow()

    local t = {}
    for nameRealm, data in pairs(addon.characters) do
        table.insert(t, data)
    end

    self.rosterListview.DataProvider:Flush()
    self.rosterListview.DataProvider:InsertTable(t)
end