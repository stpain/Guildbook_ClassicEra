local name, addon = ...;
local L = addon.Locales;

GuildbookGuildRosterMixin = {
    name = "GuildRoster",
    showOffline = false,
    showMyCharacters = false,
    selectedClass = false,
    selectedMinLevel = 1,
    selectedMaxLevel = 60,
    helptips = {},
}

function GuildbookGuildRosterMixin:OnLoad()

    addon:RegisterCallback("Blizzard_OnGuildRosterUpdate", self.Blizzard_OnGuildRosterUpdate, self)
    addon:RegisterCallback("Roster_OnSelectionChanged", self.Update, self)

    self.rosterHelptip:SetText(L.ROSTER_LISTVIEW_HT)
    table.insert(self.helptips, self.rosterHelptip)

    self.selectedRank = false

    local classesAdded = {}
    local classMenu = {}
    for i = 1, 12 do
        --if i ~= 10 then
            local locale, eng, id = GetClassInfo(i)
            --print(">> class info", i, locale, eng, id)
            if id and (not classesAdded[eng]) then
                table.insert(classMenu, {
                    text = RAID_CLASS_COLORS[eng]:WrapTextInColorCode(locale),
                    sortID = locale,
                    icon = nil,
                    func = function()
                        self.selectedClass = id
                        self:Update()
                    end,
                })
                classesAdded[eng] = true
            end
        --end
    end
    table.sort(classMenu, function (a, b)
        return a.sortID < b.sortID;
    end)
    table.insert(classMenu, 1, {
        text = ALL,
        icon = nil,
        func = function()
            self.selectedClass = false
            self:Update()
        end,
    })
    self.classFilter:SetMenu(classMenu);
    self.classFilter:SetText(ALL)

    self.joinedSort.state = 0
    self.joinedSort:SetScript("OnClick", function ()
        if self.joinedSort.state == 0 then
            self:Update(0)
            self.joinedSort.state = 1
        else
            self:Update(1)
            self.joinedSort.state = 0
        end
    end)

    local sliders = {
        ["Min level"] = "minLevel",
        ["Max level"] = "maxLevel",
    }

    for label, slider in pairs(sliders) do

        self[slider].label:SetText(label)

        -- _G[self[slider]:GetName().."Low"]:SetText(" ")
        -- _G[self[slider]:GetName().."High"]:SetText(" ")
        -- _G[self[slider]:GetName().."Text"]:SetText(" ")

        self[slider]:SetScript("OnMouseWheel", function(s, delta)
            s:SetValue(s:GetValue() + delta)
        end)
    end

    self.minLevel:SetMinMaxValues(self.selectedMinLevel, self.selectedMaxLevel)
    self.maxLevel:SetMinMaxValues(self.selectedMinLevel, self.selectedMaxLevel)

    self.minLevel:SetScript("OnValueChanged", function(s)
        s.value:SetText(math.ceil(s:GetValue()))
        self.selectedMinLevel = math.ceil(s:GetValue())
        self:Update()
    end)
    self.maxLevel:SetScript("OnValueChanged", function(s)
        s.value:SetText(math.ceil(s:GetValue()))
        self.selectedMaxLevel = math.ceil(s:GetValue())
        self:Update()
    end)


    self.showOfflineCheckbox.label:SetText("Show Offline")
    self.showOfflineCheckbox:SetScript("OnClick", function()
        self.showOffline = not self.showOffline;
        self:Update()
    end)

    self.showMyCharactersCheckbox.label:SetText("My Characters")
    self.showMyCharactersCheckbox:SetScript("OnClick", function()
        self.showMyCharacters = not self.showMyCharacters;
        self:Update()
    end)

    addon.AddView(self)
end

function GuildbookGuildRosterMixin:Update(sortJoinedState)

    -- local function filterRoster(key, val)
    --     return function(character)
    --         if character.data[key] then
    --             if character.data[key] == val then
    --                 return true;
    --             end
    --         end
    --     end
    -- end


    local ranks = {
        {
            text = "ALL",
            func = function()
                self.selectedRank = false
                self:Update()
            end,
        }
    }
    for i = 1, GuildControlGetNumRanks() do
        local name = GuildControlGetRankName(i)
        if name then
            table.insert(ranks, {
                text = name,
                func = function()
                    self.selectedRank = i
                    self:Update()
                end,
            })
        end
    end
    self.rankFilter:SetText(RANK);
    self.rankFilter:SetMenu(ranks);

    local t = {}
    for nameRealm, character in pairs(addon.characters) do

        --if Database.db.guilds[addon.thisGuild].members[nameRealm] then

        local match = false;
        -- for k, filter in ipairs(filters) do
        --     if not filter(character) then
        --         match = false;
        --     end
        -- end

        if self.showMyCharacters then
            if addon.api.characterIsMine(character.data.name) then
                match = true;
            end
        else
            if (character.data.level >= self.selectedMinLevel) and (character.data.level <= self.selectedMaxLevel) then
                if self.selectedClass and (character.data.class == self.selectedClass) then
                    if self.showOffline == false then
                        match = character.data.onlineStatus.isOnline
                    else
                        match = true
                    end
                elseif self.selectedClass == false then
                    if self.showOffline == false then
                        match = character.data.onlineStatus.isOnline
                    else
                        match = true
                    end
                end
            end
        end

        if self.selectedRank ~= false then
            if (character.data.rank + 1) == self.selectedRank then
                match = true;
            else
                match = false;
            end
        end

        if match then
            table.insert(t, character)
        end
    end

    --[[
        TODO:
            improve the sort and filter systems
    ]]
    if sortJoinedState then
        table.sort(t, function(a, b)
            if sortJoinedState == 0 then
                return a.data.joined < b.data.joined
            else
                return a.data.joined > b.data.joined
            end
        end)
    else
        table.sort(t, function(a, b)
            if a.data.level and b.data.level then
                if a.data.level == b.data.level then
                    if a.data.onlineStatus.zone and b.data.onlineStatus.zone then
                        if (a.data.onlineStatus.zone == b.data.onlineStatus.zone) then
                            return a.data.class < b.data.class
                        else
                            return a.data.onlineStatus.zone < b.data.onlineStatus.zone
                        end
                    else
                        return a.data.class < b.data.class
                    end
                else
                    return a.data.level > b.data.level
                end
            else
                return a.data.class < b.data.class
            end
        end)
    end

    local i = 0;
    for k, v in ipairs(t) do
        if (i % 2 == 0) then
            v.showBackground = true
        else
            v.showBackground = false
        end
        i = i + 1;
    end
    
    local dp = CreateDataProvider(t)
    self.rosterListview.scrollView:SetDataProvider(dp)

end

function GuildbookGuildRosterMixin:Blizzard_OnGuildRosterUpdate()
    self:Update()
end

function GuildbookGuildRosterMixin:OnShow()
    GuildRoster() --this will trigger a callback to self:Update
end