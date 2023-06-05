local name, addon = ...;

GuildbookGuildTreeMixin = {
    name = "GuildTree",
}

function GuildbookGuildTreeMixin:OnLoad()

    addon:RegisterCallback("Blizzard_OnGuildRosterUpdate", self.Blizzard_OnGuildRosterUpdate, self)

    addon.AddView(self)
end

function GuildbookGuildTreeMixin:Blizzard_OnGuildRosterUpdate()
    self:Update()
end

function GuildbookGuildTreeMixin:OnShow()
    self:Update()
end

function GuildbookGuildTreeMixin:Update()

    self.listview.DataProvider:Flush()

    local ranks = {}
    local totalMembers, onlineMembers, _ = GetNumGuildMembers()
    for i = 1, totalMembers do
        local name, rankName, rankIndex = GetGuildRosterInfo(i)
        if not ranks[rankIndex] then
            ranks[rankIndex] = {
                name = rankName,
                members = {},
            }
        end
        if addon.characters[name] then
            table.insert(ranks[rankIndex].members, addon.characters[name])
        end
    end

    local rankHeadersAdded = {}
    for i = 0, 20 do
        if ranks[i] then
            local rank = ranks[i]
            if not rankHeadersAdded[rank.name] then
                rankHeadersAdded[rank.name] = true

                if #rank.members < 9 then
                    self.listview.DataProvider:Insert({
                        showHeader = true,
                        header = rank.name,
                        characters = rank.members,
                    })
                else
                    local numRows = math.ceil(#rank.members / 8)
                    for i = 1, numRows do
                        local charactersThisRow = {}
                        for j = ((i * 8) - 7), (i * 8) do
                            if rank.members[j] then
                                table.insert(charactersThisRow, rank.members[j])
                            end
                        end
                        self.listview.DataProvider:Insert({
                            showHeader = false,
                            header = "",
                            characters = charactersThisRow,
                        })
                    end
                end
            end
        end
    end

end
