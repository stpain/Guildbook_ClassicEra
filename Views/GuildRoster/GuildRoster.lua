local name, addon = ...;

GuildbookGuildRosterMixin = {
    name = "GuildRoster",
    showOffline = false,
    selectedClass = false,
    selectedMinLevel = 1,
    selectedMaxLevel = 60,
}

function GuildbookGuildRosterMixin:OnLoad()

    addon:RegisterCallback("Blizzard_OnGuildRosterUpdate", self.Blizzard_OnGuildRosterUpdate, self)

    local classMenu = {}
    for i = 1, GetNumClasses() do
        if i ~= 6 and i ~= 10 then
            local locale, eng, id = GetClassInfo(i)
            table.insert(classMenu, {
                text = locale,
                icon = nil,
                func = function()
                    self.selectedClass = id
                    self:Update()
                end,
            })
        end
    end
    table.insert(classMenu, {
        text = ALL,
        icon = nil,
        func = function()
            self.selectedClass = false
            self:Update()
        end,
    })
    self.classFilter:SetMenu(classMenu);
    self.classFilter:SetText(ALL)

    local sliders = {
        ["Min level"] = "minLevel",
        ["Max level"] = "maxLevel",
    }

    for label, slider in pairs(sliders) do

        self[slider].label:SetText(label)

        _G[self[slider]:GetName().."Low"]:SetText(" ")
        _G[self[slider]:GetName().."High"]:SetText(" ")
        _G[self[slider]:GetName().."Text"]:SetText(" ")

        self[slider]:SetScript("OnMouseWheel", function(s, delta)
            s:SetValue(s:GetValue() + delta)
        end)

        self[slider]:SetScript("OnValueChanged", function(s)
            s.value:SetText(math.ceil(s:GetValue()))

        end)
    end

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

    addon.AddView(self)
end

function GuildbookGuildRosterMixin:Update()

    local function generateClassFilter()
        return function(character)
            if self.selectedClass then
                if character.data.class == self.selectedClass then
                    return true
                end
            else
                return true
            end
        end
    end
    local function generateLevelFilter()
        return function(character)
            if (character.data.level >= self.selectedMinLevel) and (character.data.level <= self.selectedMaxLevel) then
                return true
            end
        end
    end

    local filters = {
        generateClassFilter(),
        generateLevelFilter(),
    }

    self.rosterListview.DataProvider:Flush()

    local t = {}
    for nameRealm, character in pairs(addon.characters) do
        local match = true;
        for k, filter in ipairs(filters) do
            if not filter(character) then
                match = false;
            end
        end
        if self.showOffline == false then
            match = character.data.onlineStatus.isOnline
        end
        if match then
            table.insert(t, character)
        end
    end

    table.sort(t, function(a, b)
        if a.data.level == b.data.level then
            if a.data.class == b.data.class then
                return a.data.name < b.data.name
            else
                return a.data.class < b.data.class
            end
        else
            return a.data.level > b.data.level
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