local name , addon = ...;

local L = addon.Locales;
local Database = addon.Database;
local CalendarEvent = addon.CalendarEvent;
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local C_Calendar = addon.Calendar


local BACK_FADE_START, BLACK_FADE_END = CreateColor(0,0,0,1), CreateColor(0,0,0,0)


GuildbookCalendarDayTileMixin = {
    CALENDAR_DAYBUTTON_NORMALIZED_TEX_WIDTH = 90 / 256 - 0.001,
    CALENDAR_DAYBUTTON_NORMALIZED_TEX_HEIGHT = 90 / 256 - 0.001,
}

function GuildbookCalendarDayTileMixin:OnLoad()
    
    local texLeft = random(0,1) * self.CALENDAR_DAYBUTTON_NORMALIZED_TEX_WIDTH;
    local texRight = texLeft + self.CALENDAR_DAYBUTTON_NORMALIZED_TEX_WIDTH;
    local texTop = random(0,1) * self.CALENDAR_DAYBUTTON_NORMALIZED_TEX_HEIGHT;
    local texBottom = texTop + self.CALENDAR_DAYBUTTON_NORMALIZED_TEX_HEIGHT;

    self.background:SetTexture(235428)
    self.background:SetTexCoord(texLeft, texRight, texTop, texBottom)

    self.backgroundFade:SetGradient("VERTICAL", BACK_FADE_START, BLACK_FADE_END)

    self.highlight:SetTexture(235438)
    self.highlight:SetTexCoord(0.0, 0.35, 0.0, 0.7)

    self.flash:SetTexture(235438)
    self.flash:SetTexCoord(0.0, 0.35, 0.0, 0.7)

    self.otherMonthOverlay:SetColorTexture(0,0,0,0.6)
    self.currentDayTexture:SetTexture(235433)
    self.currentDayTexture:SetTexCoord(0.05, 0.55, 0.05, 0.55)
    self.currentDayTexture:SetAlpha(0.7)

    -- self.worldEventTexture:SetTexture(235448)
    -- self.worldEventTexture:SetTexCoord(0.0, 0.71, 0.0, 0.71)

    self.holidayTextures = {}

    self.eventTexture:Hide()

    self.worldEvents = {}
    self.guildEvents = {}
    self.events = {}

    for i = 1, 3 do
        self["event"..i]:Raise()
        self["event"..i]:SetHeight(14)
        self["event"..i]:Hide()
    end

    self:SetScript("OnEnter", function()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(date("%d %B %Y", time(self.date)))
        --GameTooltip:AddLine(time(self.date))

        local zgMadnessBoss = C_Calendar.GetMadnessBoss(self.date.year, self.date.month, self.date.day)
        if type(zgMadnessBoss) == "string" then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("ZG Madness Boss")
            GameTooltip:AddLine(zgMadnessBoss, 1,1,1,1)
        end

        if self.events and (#self.events > 0) then
            --GameTooltip:AddLine(" ")

            local eventTypeIndex = 0
            for k, v in ipairs(self.events) do
                if v.eventType ~= eventTypeIndex then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(addon.CalendarEventTypeEnums[v.eventType])
                    eventTypeIndex = v.eventType
                end
                GameTooltip:AddLine(v.name, 1,1,1)
            end
        end

        if #self.charactersJoinedToday > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Members joined")
            for _, name in ipairs(self.charactersJoinedToday) do
                GameTooltip:AddLine(name)
            end
        end

        GameTooltip:Show()
    end)
    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)

end

local function GetGuildMembersJoinedForDay(dateTable)
    local ret = {}
    if addon.characters then
        for nameRealm, character in pairs(addon.characters) do
            local joinedDay = date("*t", character.data.joined)
            if joinedDay.day == dateTable.day and (joinedDay.month == dateTable.month) and (joinedDay.year == dateTable.year) then
                table.insert(ret, character:GetName(true, "short"))
            end
        end
    end
    return ret
end

function GuildbookCalendarDayTileMixin:SetDate(dateTable)
    self.date = dateTable;

    self.charactersJoinedToday = GetGuildMembersJoinedForDay(self.date)
end

function GuildbookCalendarDayTileMixin:ClearHolidayTextures()
    for k, v in ipairs(self.holidayTextures) do
        v:SetTexture(nil)
        v:Hide()
    end
end

function GuildbookCalendarDayTileMixin:HideEventButtons()
    for i = 1, 3 do
        self["event"..i].topLabel:SetText("")
        self["event"..i].bottomLabel:SetText("")
        self["event"..i]:SetScript("OnClick", nil)
        self["event"..i]:Hide()
    end
end





GuildbookCalendarMixin = {
    name = "Calendar",
}

function GuildbookCalendarMixin:UpdateLayout()
    local x, y = self:GetSize();

    local sidePanelWidth = (x * 0.3);

    local monthViewWidth = x - sidePanelWidth;

    self.dayTileWidth = monthViewWidth / 7;
    self.dayTileHeight = (y - 18) / 6;

    for k, v in ipairs(self.monthView.dayHeaders) do
        v.background:ClearAllPoints()
        v.background:SetWidth(self.dayTileWidth)
        v.background:SetPoint("TOPLEFT", (k-1) * self.dayTileWidth, 0)
        v.label:SetWidth(self.dayTileWidth)
        v.label:SetWidth(self.dayTileWidth)
        v.label:SetPoint("TOPLEFT", (k-1) * self.dayTileWidth, 0)
    end


    local i = 1;
    for week = 1, 6 do
        for day = 1, 7 do
            local tile = self.monthView.dayTiles[i]
            tile:ClearAllPoints()
            tile:SetSize(self.dayTileWidth, self.dayTileHeight)
            tile:SetPoint("TOPLEFT",  ((day - 1) * self.dayTileWidth), (((week - 1) * self.dayTileHeight) * -1) -18 )
            i = i + 1;

            for j = 1, 3 do
                tile["event"..j]:SetSize(self.dayTileWidth - 4 ,self.dayTileHeight / 4)
            end
        end
    end

    self.monthView:SetSize(monthViewWidth, y)
end

function GuildbookCalendarMixin:OnShow()
    self:MonthChanged()
    self:UpdateLayout()
end

function GuildbookCalendarMixin:UpdateCalendarEvents()

    local t = {}

    local daysInMonth = self:GetDaysInMonth(self.date.month, self.date.year)

    local from = {
        day = 1,
        month = self.date.month,
        year = self.date.year,
        hour = 0,
        min = 0,
        sec = 0,
    }


    local events = C_Calendar.GetCalendarEventsBetween(from, daysInMonth)

    table.sort(events, function(a, b)
        return a.data.scheduledTime < b.data.scheduledTime
    end)

    --DevTools_Dump(events)

    for k, v in ipairs(events) do
        table.insert(t, {
            label = string.format("|cffE5AC00%s|r\n%s", date("%Y-%m-%d", v.data.scheduledTime), v.data.title),
            onMouseDown = function(f, button)
                if button == "LeftButton" then
                    GuildbookCalendarEventFrame:LoadEvent(v)

                elseif button == "RightButton" then
                    MenuUtil.CreateContextMenu(f, function(f, rootDescription)
                        rootDescription:CreateTitle(v.data.title, WHITE_FONT_COLOR)
                        rootDescription:CreateDivider()
                        rootDescription:CreateButton("Delete Event", function()
                            C_Calendar.DeleteCalendarEventID(v.data.id, true)
                        end)
                    end)
                end
            end
        })
    end


    self.sidePanel.lockouts.scrollView:SetDataProvider(CreateDataProvider(t))
end


--local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
local lockoutKeys = {
    "Name",
    "ID",
    "Reset",
    "Difficulty",
    "Locked",
    "Extended",
    "instanceIDMostSig",
    "IsRaid",
    "MaxPlayers",
    "DifficultyName",
    "NumEncounters",
    "EncounterProgress",
}
function GuildbookCalendarMixin:UpdateLockouts()

    local instances = {};

    local t = {}
    local sortTable = {}

    if addon.characters then
        for nameRealm, character in pairs(addon.characters) do
            local lockouts = character:GetLockouts()
            for k, v in ipairs(lockouts) do
                local x = {}
                x.player = nameRealm
                for a, b in pairs(v) do
                    x[a] = b;
                end
                table.insert(sortTable, x)
            end
        end
    end

    table.sort(sortTable, function(a, b)
        if a.difficulty == b.difficulty then
            if a.name == b.name then
                return a.player < b.player
            else
                return a.name < b.name
            end
        else
            return a.difficulty > b.difficulty;
        end
    end)

    local inserted = {}
    for k, lockout in ipairs(sortTable) do
        if GetServerTime() < lockout.reset then

            local instanceName = lockout.name:lower():gsub("[%c%p%s]", "")
            local iconPath = "";
            local iconCoords = {0,1,0,1}

            local resetDate = date("*t", lockout.reset)

            --not ideal but dungeons and raids have different artwork
            if lockout.isRaid then
                iconPath = string.format("Interface/encounterjournal/ui-ej-dungeonbutton-%s", instanceName)
                iconCoords = {0.17578125, 0.49609375, 0.03125, 0.71875}         
            else
                iconPath = string.format("Interface/lfgframe/lfgicon-%s", instanceName)
            end

            local header = string.format("%s-%s", lockout.name, lockout.difficultyName)

            if not inserted[header] then

                table.insert(t, {
                    label = string.format("%s\n|cffE5AC00%s|r", lockout.name, lockout.difficultyName),
                    backgroundRGB = {r = 0.4, g = 0.4, b = 0.4,},
                    backgroundAlpha = 0.4,
                    icon = iconPath,
                    iconCoords = iconCoords,
                })
                inserted[header] = true;
            end

            table.insert(t, {
                label = string.format("%s\n|cffffffff%s|r", addon.characters[lockout.player]:GetName(true), date("%Y-%m-%d %H:%M:%S", lockout.reset)),
                -- atlas = addon.characters[player]:GetProfileAvatar(),
                -- showMask = true,
                onMouseEnter = function(f)
                    GameTooltip:SetOwner(f, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(name)
                    for k, v in pairs(lockout) do
                        GameTooltip:AddDoubleLine("|cffffffff"..k.."|r", tostring(v))
                    end
                    GameTooltip:Show()

                    for i, day in ipairs(self.monthView.dayTiles) do
                        if day.date and (day.date.month == resetDate.month) and (day.date.day == resetDate.day) then
                            day.anim:Play()
                        end
                    end
                end,
                onMouseLeave = function()
                    for i, day in ipairs(self.monthView.dayTiles) do
                        day.anim:Stop()
                    end
                end
            })

        end
    end


    self.sidePanel.lockouts.scrollView:SetDataProvider(CreateDataProvider(t))
end

function GuildbookCalendarMixin:OnTabSelected(tab, index)

    if index == 1 then
        self:UpdateLockouts()
        
    elseif index == 2 then
        self:UpdateCalendarEvents()
    end
end


-- local CALENDAR_MONTH_NAMES = {
-- 	MONTH_JANUARY,
-- 	MONTH_FEBRUARY,
-- 	MONTH_MARCH,
-- 	MONTH_APRIL,
-- 	MONTH_MAY,
-- 	MONTH_JUNE,
-- 	MONTH_JULY,
-- 	MONTH_AUGUST,
-- 	MONTH_SEPTEMBER,
-- 	MONTH_OCTOBER,
-- 	MONTH_NOVEMBER,
-- 	MONTH_DECEMBER,
-- };

function GuildbookCalendarMixin:OnLoad()

    self.sidePanel.lockouts.background:SetAtlas("QuestLogBackground")

    addon:RegisterCallback("Database_OnCalendarDataChanged", self.MonthChanged, self)
    addon:RegisterCallback("Calendar_OnCalendarEventDeleted", self.MonthChanged, self) --MonthChanged is maybe overkill as it'll redo the whole month data
    addon:RegisterCallback("Calendar_OnCalendarEventCreated", self.MonthChanged, self)

    self.tabsGroup = CreateRadioButtonGroup();

	self.tabsGroup:AddButtons({self.sidePanel.tab1, self.sidePanel.tab2});
	self.tabsGroup:SelectAtIndex(1);
	self.tabsGroup:RegisterCallback(ButtonGroupBaseMixin.Event.Selected, self.OnTabSelected, self);

    self.date = date("*t")

    self.weekdays = {
        L["MONDAY"],
        L["TUESDAY"],
        L["WEDNESDAY"],
        L["THURSDAY"],
        L["FRIDAY"],
        L["SATURDAY"],
        L["SUNDAY"],
    }


    self.dayTileWidth = 88;
    self.dayTileHeight = 64;

    self.monthView:SetWidth(self.dayTileWidth * 7)

    self.monthView.dayHeaders = {}
    for i = 0, 6 do
        local t = self.monthView:CreateTexture(nil, "ARTWORK")
        t:SetTexture(235428)
        t:SetTexCoord(0.0, 0.35, 0.71, 0.81)
        t:SetSize(self.dayTileWidth, 18)
        t:SetPoint("TOPLEFT", i * self.dayTileWidth, 0)

        local f = self.monthView:CreateFontString(nil, "OVERLAY", "GameFontWhite")
        f:SetSize(self.dayTileWidth, 18)
        f:SetPoint("TOPLEFT", i * self.dayTileWidth, 0)
        f:SetJustifyH("CENTER")
        f:SetJustifyV("MIDDLE")
        f:SetText(self.weekdays[i+1])

        self.monthView.dayHeaders[i+1] = {
            background = t,
            label = f,
        }
    end

    self.monthView.dayTiles = {}
    local i = 1;
    for week = 1, 6 do
        for day = 1, 7 do
            local tile = CreateFrame("FRAME", nil, self.monthView, "GuildbookCalendarDayTile")
            tile:SetPoint("TOPLEFT",  ((day - 1) * self.dayTileWidth), (((week - 1) * self.dayTileHeight) * -1) -18 )
            tile:SetSize(self.dayTileWidth, self.dayTileHeight)
            self.monthView.dayTiles[i] = tile;
            i = i + 1;
        end
    end


    self.sidePanel.previousMonth:SetNormalTexture(130869)
    self.sidePanel.previousMonth:SetPushedTexture(130868)
    self.sidePanel.previousMonth:SetScript("OnClick", function()
        if self.date.month == 1 then
            self.date.month = 12
            self.date.year = self.date.year - 1
        else
            self.date.month = self.date.month - 1
        end
        self:MonthChanged()
    end)
    self.sidePanel.nextMonth:SetNormalTexture(130866)
    self.sidePanel.nextMonth:SetPushedTexture(130865)
    self.sidePanel.nextMonth:SetScript("OnClick", function()
        if self.date.month == 12 then
            self.date.month = 1
            self.date.year = self.date.year + 1
        else
            self.date.month = self.date.month + 1
        end
        self:MonthChanged()
    end)


    self:MonthChanged()

    addon.AddView(self)
end

function GuildbookCalendarMixin:GetDaysInMonth(month, year)
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local d = days_in_month[month]
    -- check for leap year
    if (month == 2) then
        if year % 4 == 0 then
            if year % 100 == 0 then
                if year % 400 == 0 then
                    d = 29
                end
            else
                d = 29
            end
        end
    end
    return d
end

function GuildbookCalendarMixin:GetMonthStart(month, year)
    local today = date('*t')
    today.day = 0
    today.month = month
    today.year = year
    local monthStart = date('*t', time(today))
    return monthStart.wday
end


function GuildbookCalendarMixin:MonthChanged()

    --this appears to also update the default calendar, which is fine, the main thing is it means we can make use of calendar api using month offset
    C_Calendar.SetAbsMonth(self.date.month, self.date.year)

    addon:TriggerEvent("Calendar_OnMonthChanged")

    self.sidePanel.monthName:SetText(date("%B %Y", time(self.date)))
    local monthStart = self:GetMonthStart(self.date.month, self.date.year)
    local daysInMonth = self:GetDaysInMonth(self.date.month, self.date.year)

    if self.sidePanel.tab1:IsSelected() then
        self:UpdateLockouts()
    else
        self:UpdateCalendarEvents()
    end

    local daysInLastMonth = 0
    if self.date.month == 1 then
        daysInLastMonth = self:GetDaysInMonth(12, self.date.year - 1)
    else
        daysInLastMonth = self:GetDaysInMonth(self.date.month - 1, self.date.year)
    end

    local thisMonthDay, nextMonthDay = 1, 1
    for i, day in ipairs(self.monthView.dayTiles) do
        day:SetScript("OnMouseDown", nil)
        day:ClearHolidayTextures()
        day:HideEventButtons()
        day.backgroundFade:Hide()
        day.currentDayTexture:Hide()
        day.events = {}
        day.worldEvents = {}

        day.showMore:Hide()

        day:EnableMouse(false)
        day.dateLabel:SetText(' ')
        --day.worldEventTexture:SetTexture(nil)
        -- day.guildEventTexture:SetTexture(nil)
        local today = date("*t")
        if (thisMonthDay == today.day) and (self.date.month == today.month) then
            day.currentDayTexture:Show()
        end

        -- setup days in previous month
        if i < monthStart then
            day.dateLabel:SetText((daysInLastMonth - monthStart + 2) + (i - 1))
            day.dateLabel:SetTextColor(0.5, 0.5, 0.5, 1)
            day.otherMonthOverlay:Show()
            day.currentDayTexture:Hide()
        end

        -- setup current months days
        if (i >= monthStart) and (thisMonthDay <= daysInMonth) then
            day.dateLabel:SetText(thisMonthDay)
            day.dateLabel:SetTextColor(1,1,1,1)
            day.otherMonthOverlay:Hide()
            day:EnableMouse(true)

            --set the date for this day tile
            day:SetDate({
                day = thisMonthDay,
                month = self.date.month,
                year = self.date.year,
                hour = 0,
                min = 0,
                sec = 0,
            })

            --grab any guild events
            local guildEvents = C_Calendar.GetCalendarEventsBetween({
                year = self.date.year,
                month = self.date.month,
                day = thisMonthDay,
                hour = 0,
                min = 0,
                sec = 0
            },
            1)

            if #guildEvents > 0 then
                for k, v in ipairs(guildEvents) do

                    --for the tooltip sorting to work events need a type value
                    --this doesn't need to exist on the event data nor be sent via comms for now reason
                    --this day.events table *ONLY* drives the tooltip so we can drop the event obj concept here
                    table.insert(day.events, {
                        eventType = 1, --1 is for guild events this keeps them top of the tooltip
                        name = v.data.title
                    })
                end

                for j = 1, 3 do
                    if guildEvents[j] then
                        day["event"..j].topLabel:SetText(guildEvents[j].data.title)
                        day["event"..j].bottomLabel:SetText("")
                        day["event"..j]:SetScript("OnClick", function()
                            GuildbookCalendarEventFrame:LoadEvent(guildEvents[j])
                        end)
                        day["event"..j]:Show()
                    end
                end
            end

            --instance resets
            local instanceResets = C_Calendar.GetInstanceResets(0, thisMonthDay)
            if #instanceResets > 0 then
                day.backgroundFade:Show()

                for k, v in ipairs(instanceResets) do
                    table.insert(day.events, v)
                end

                --only do this if guildEvents left buttons available
                if #guildEvents < 3 then
                    for j = (#guildEvents + 1), 3 do
                        if instanceResets[j] then
                            day["event"..j].topLabel:SetText(instanceResets[j].name)
                            day["event"..j].bottomLabel:SetText(RESET)
                            day["event"..j]:Show()
                        end
                    end
                end

            end

            --grab the events for the day and loop in reverse order, do this as it seems larger events (events spanning weeks not just a day) are indexed lower
            --so going reverse we add the small single day events first and use a low number for the subLayer
            for i = C_Calendar.GetNumDayEvents(0, thisMonthDay), 1, -1 do
                local event = C_Calendar.GetHolidayInfo(0, thisMonthDay, i)
                local subLayer = 1
                if event then
                    if not day.holidayTextures[i] then
                        day.holidayTextures[i] = day:CreateTexture(nil, "BORDER")
                        day.holidayTextures[i]:SetAllPoints()
                        day.holidayTextures[i]:SetTexCoord(0.0, 0.71, 0.0, 0.71)
                    end
                    --day.holidayTextures[i]:SetDrawLayer("BORDER", subLayer)
                    day.holidayTextures[i]:SetDrawLayer("BORDER", event.drawLayer)
                    day.holidayTextures[i]:SetTexture(event.texture)
                    day.holidayTextures[i]:Show()

                    table.insert(day.events, event)
                end
                subLayer = subLayer + 1;
            end


            table.sort(day.events, function(a, b)
                return a.eventType < b.eventType
            end)

            if #day.events > 3 then
                day.showMore:Show()

                day.showMore:SetScript("OnClick", function()
                    MenuUtil.CreateContextMenu(parent, function(parent, rootDescription)
                        for _, event in ipairs(day.events) do
                            local menuButton = rootDescription:CreateButton(event.name, function()

                            end)
                        end
                    end)
                end)
            end

            day:SetScript("OnMouseDown", function(f, b)
                MenuUtil.CreateContextMenu(day, function(day, rootDescription)

                    rootDescription:CreateTitle(date("%Y-%m-%d", time(day.date)), WHITE_FONT_COLOR)
                    rootDescription:CreateDivider()

                    local createEventButton = rootDescription:CreateButton("New event", function()
                        GuildbookCalendarEventFrame:OpenForNewEvent(self.date)
                    end)


                end)
            end)

            thisMonthDay = thisMonthDay + 1
        end

        -- setup days in following month
        if i > (daysInMonth + (monthStart - 1)) then
            day.dateLabel:SetText(nextMonthDay)
            day.dateLabel:SetTextColor(0.5, 0.5, 0.5, 1)
            day.otherMonthOverlay:Show()
            day.currentDayTexture:Hide()

            for i = C_Calendar.GetNumDayEvents(1, nextMonthDay), 1, -1 do
                local event = C_Calendar.GetHolidayInfo(1, nextMonthDay, i)
                local subLayer = 1
                if event then
                    if not day.holidayTextures[i] then
                        day.holidayTextures[i] = day:CreateTexture(nil, "BORDER")
                        day.holidayTextures[i]:SetAllPoints()
                        day.holidayTextures[i]:SetTexCoord(0.0, 0.71, 0.0, 0.71)
                    end
                    day.holidayTextures[i]:SetDrawLayer("BORDER", subLayer)
                    day.holidayTextures[i]:SetTexture(event.texture)

                    table.insert(day.events, event)
                end
                subLayer = subLayer + 1;
            end

            nextMonthDay = nextMonthDay + 1
        end
    end
end




local attendingStatus = {
    [1] = "Yes",
    [2] = "Late",
    [3] = "Tentative",
    [4] = "Declined",
}



GuildbookCalendarEventAttendingListItemMixin = {}
function GuildbookCalendarEventAttendingListItemMixin:SetDataBinding(binding, height)
    self:SetHeight(height)

    self.name:SetText(binding.name or "")
    self.status:SetText(attendingStatus[binding.status] or "")
end

function GuildbookCalendarEventAttendingListItemMixin:ResetDataBinding()
    self.name:SetText("")
    self.status:SetText("")
end



--groupfinder-icon-class-hunter

local eventFrameDateTimeFormat = "%Y-%m-%d   %H:%M"
local iconSize = 20
local classIconStrings = {
    CreateAtlasMarkup("groupfinder-icon-class-warrior", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-paladin", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-hunter", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-rogue", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-priest", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-deathknight", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-shaman", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-mage", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-warlock", iconSize, iconSize),
    CreateAtlasMarkup("groupfinder-icon-class-monk", iconSize, iconSize), -- not used but keeps the indexes correct
    CreateAtlasMarkup("groupfinder-icon-class-druid", iconSize, iconSize),
}

local function GetClassCountString(war, pal, hun, rog, pri, sha, mage, warl, druid)
    return string.format("%s %d %s %d %s %d %s %d %s %d\n\n%s %d %s %d %s %d %s %d",
        classIconStrings[1], war,
        classIconStrings[2], pal,
        classIconStrings[11], druid,
        classIconStrings[5], pri,
        classIconStrings[7], sha,

        classIconStrings[3], hun,
        classIconStrings[4], rog,
        classIconStrings[8], mage,
        classIconStrings[9], warl
    )
end

GuildbookCalendarEventFrameMixin = {}
function GuildbookCalendarEventFrameMixin:OnLoad()

    NineSliceUtil.ApplyLayout(self, addon.Layouts.Flyout)
    NineSliceUtil.ApplyLayout(self.attendingList, addon.api.getNineSliceTooltipBorder(0))

    self.description.EditBox:SetMaxLetters(130)
    self.description.CharCount:SetShown(true);

    addon:RegisterCallback("Calendar_OnCalendarEventChanged", self.OnCalendarEventChanged, self)

    self:SetPropagateMouseClicks(false)
    self:SetPropagateMouseMotion(false)

    self.title:SetScript("OnTextChanged", function(editBox)
        if self.tempData then
            self.tempData.title = editBox:GetText()
        end
    end)

    self.description.EditBox:SetScript("OnTextChanged", function(editBox)
        if self.tempData then
            self.tempData.desc = editBox:GetText()
        end
    end)

    self.datePicker:SetScript("OnClick", function()
        GuildbookDatePicker:ClearAllPoints()
        GuildbookDatePicker:SetParent(self.datePicker)
        GuildbookDatePicker:SetPoint("TOPLEFT", self.datePicker, "BOTTOMLEFT")
        GuildbookDatePicker:SetCallback(function(timeSelected)
            self.tempData.scheduledTime = timeSelected
            self.datePicker:SetText(date(eventFrameDateTimeFormat, timeSelected))
        end)
        GuildbookDatePicker:Show()
    end)

    local statusMenu = {}
    for k, v in ipairs(attendingStatus) do
        table.insert(statusMenu, {
            text = v,
            func = function()
                if self.currentEvent then
                    --print("set attending status")
                    C_Calendar.SetCalendarEventAttendingChanged(self.currentEvent.data.id, addon.thisCharacter, string.format("%d-%d", k, GetServerTime()))
                end
            end,
        })
    end
    self.statusDropdown:SetScript("OnClick", function()
        MenuUtil.CreateContextMenu(self.statusDropdown, function(_, rootDescription)
            for k, v in ipairs(statusMenu) do
                rootDescription:CreateButton(v.text, v.func)
            end
        end)
    end)

    self:SetScript("OnHide", function()
        self.tempData = nil;
        self.currentEvent = nil;
        self.createEvent:SetText("Create Event")
        self.createEvent:SetEnabled(false)
        self.deleteEvent:SetEnabled(false)
        self.title:SetEnabled(false)
        self.description.EditBox:SetEnabled(false)
        self.datePicker:SetEnabled(false)
        self.statusDropdown:SetEnabled(false)

        self.title:SetText("")
        self.description.EditBox:SetText("")
        self:UpdateAttending()
    end)
end

--the event here is a mixin obj, the ui will want to use .data to access the event data
function GuildbookCalendarEventFrameMixin:LoadEvent(event)

    self.currentEvent = event;

    --DevTools_Dump(event)

    if type(event.data) == "table" then
        self.title:SetText(event.data.title or "")
        self.description.EditBox:SetText(event.data.desc or "")
        self.datePicker:SetText(date(eventFrameDateTimeFormat, event.data.scheduledTime))

        self:UpdateAttending(event.data.attending)

    else
        self:Hide()
        return
    end


    --check if this event belongs to us
    local ownerName, ownerRealm, created = strsplit("-", event.data.id)
    if (ownerName.."-"..ownerRealm) == addon.thisCharacter then

        --this will hold any changes made to the event while the frame is open
        --if we used any OnTextChanged to update automatically it would cause lots of Comms traffic - which is bad
        --this table should only exist if the vent is owned by this player
        self.tempData = {}

        self.title:SetEnabled(true)
        self.description.EditBox:SetEnabled(true)
        self.datePicker:SetEnabled(true)
        self.statusDropdown:SetEnabled(true)

        --turn this into an update event button as its our event
        self.createEvent:SetText("Update Event")
        self.createEvent:SetEnabled(true)
        self.createEvent:SetScript("OnClick", function()

            --update the event data from the tempData
            if self.tempData then
                local hasChanged = false
                if self.tempData.title then
                    event.data.title = self.tempData.title
                    hasChanged = true
                end
                if self.tempData.desc then
                    event.data.desc = self.tempData.desc
                    hasChanged = true
                end
                if self.tempData.scheduledTime then
                    event.data.scheduledTime = self.tempData.scheduledTime
                    hasChanged = true
                end

                if hasChanged == true then
                    --call C_Calendar to handle the update
                    C_Calendar.SetCalendarEventChanged(event)
                end
            end

        end)

        self.deleteEvent:SetEnabled(true)
        self.deleteEvent:SetScript("OnClick", function()
            C_Calendar.DeleteCalendarEventID(event.data.id, true)
            self:Hide()
        end)
    end

    self:Show()
end

function GuildbookCalendarEventFrameMixin:UpdateAttending(attending)

    local classCounts = {
        [1] = 0, --warrior
        [2] = 0, --paladin
        [3] = 0, --hunter
        [4] = 0, --rogue
        [5] = 0, --priest
        --[6] = 0, --deathknight
        [7] = 0, --shaman
        [8] = 0, --mage
        [9] = 0, --warlock
        --[10] = 0, --monk
        [11] = 0, --druid
    }
    local t = {}
    if type(attending) == "table" then
        for nameRealm, statusInfo in pairs(attending) do

            local statusID, _ = strsplit("-", statusInfo)
            statusID = tonumber(statusID)

            if type(statusID) == "number" then
                if addon.characters[nameRealm] then
                    local character = addon.characters[nameRealm]

                    --only count yes or late responses
                    if statusID < 3 then
                        classCounts[character.data.class] = classCounts[character.data.class] + 1
                    end

                    table.insert(t, {
                        name = character:GetName(true, "short"),
                        status = statusID,
                    })
                end
            end
        end

        table.sort(t, function(a, b)
            return a.status < b.status
        end)
    end

    self.classCounts:SetText(GetClassCountString(classCounts[1], classCounts[2], classCounts[3], classCounts[4], classCounts[5], classCounts[7], classCounts[8], classCounts[9], classCounts[11]))

    self.attendingList.scrollView:SetDataProvider(CreateDataProvider(t))

end

function GuildbookCalendarEventFrameMixin:OpenForNewEvent(dateTable)

    --print("OpenForNewEvent", year, month, day)
    
    self.tempData = {}

    if dateTable then
        local now = time(dateTable)
        self.tempData.scheduledTime = now
        self.datePicker:SetText(date(eventFrameDateTimeFormat, now))
    end


    --this scripts for these will check for a self.temp table no need to config them again
    self.title:SetEnabled(true)
    self.description.EditBox:SetEnabled(true)
    self.datePicker:SetEnabled(true)
    self.statusDropdown:SetEnabled(true)
    self.deleteEvent:SetEnabled(false)
    self.createEvent:SetEnabled(true)

    --make sure this is a create button again
    self.createEvent:SetScript("OnClick", function()

        if self.tempData.title and self.tempData.desc and self.tempData.scheduledTime then

            --create an event table
            local newEvent = CalendarEvent:CreateEventData(self.tempData.title, self.tempData.desc, self.tempData.scheduledTime)

            -- inform C_Calendar of new event
            C_Calendar.CalendarEventCreate(newEvent, true)
            self:Hide()

        else

        end
    end)
    self:Show()
end


--if an event changes lets update the frame if its visible
--the event object would have already been updated, so it doesn't need to be set as currentEvent
function GuildbookCalendarEventFrameMixin:OnCalendarEventChanged(event)

    -- print("======================")
    -- print("CalendarEvent_Changed")
    -- print("======================")

    --DevTools_Dump(event)

    if self:IsVisible() then

        --check this event matches the current event
        if self.currentEvent and (self.currentEvent.data.id == event.data.id) then

            --if the event isn't this players then its liekly to just be a change to the event title, desc or date
            self.title:SetText(event.data.title)
            self.description.EditBox:SetText(event.data.desc)
            self.datePicker:SetText(date(eventFrameDateTimeFormat, event.data.scheduledTime))

            --it could be somebody setting the attending status so load the data provider
            self:UpdateAttending(event.data.attending)

            --nothing else to do here
            --either its this players event and we've updated the UI in a roundabout way
            --or its not this players event and we've updated the UI to reflect the changes
        end
    end
end