local name, addon = ...;

local L = {}
local Database = addon.Database;
local CalendarEvent = addon.CalendarEvent;
local Comms;

--[[[
    TODO:
        This file has a lot of random local data, it should have a sort and tidy into a proper C_Calendar namespace
]]


local worldHolidayTextures = {
    midsummer = { start = 235474, ongoing = 235473, ends = 235472 },
    hallowsend = { start = 235462, ongoing = 235461, ends = 235460,},
}

local worldHolidayDurations = {
    midsummer = 14,
    hallowsend = 14,
}

local worldHolidayEvents = {
    [2025] = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {
            [21] = {
                { id = "midsummer", name = "MidSummer Fire Festival",}
            }
        },
        [7] = {},
        [8] = {},
        [9] = {},
        [10] = {
            [17] = {
                { id = "hallowsend", name = "Hallows End",}
            }
        },
        [11] = {},
        [12] = {},
    },
    [2026] = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {
            [21] = {
                { id = "midsummer", name = "MidSummer Fire Festival",}
            }
        },
        [7] = {},
        [8] = {},
        [9] = {},
        [10] = {
            [17] = {
                { id = "hallowsend", name = "Hallows End",}
            }
        },
        [11] = {},
        [12] = {},
    },
}


local darkmoonFaireTextures = {
	['Elwynn'] = {
		['Start'] = 235448,
		['OnGoing'] = 235447,
		['End'] = 235446,
	},
	['Mulgore'] = {
		['Start'] = 235451,
		['OnGoing'] = 235450,
		['End'] = 235449,
	},
	['TerokkarForest'] = {
		['Start'] = 235451,
		['OnGoing'] = 235450,
		['End'] = 235449,
	},
}

local darkmoonFaireSchedule = {
    [1] = "Elwynn Forest",
    [2] = "Thunder Bluff",
    [3] = "Terokkar Forest",
}

local battlegroundSchedule = {
    [1] = "Alterac Valley",
    [2] = "Warsong Gulch",
    [3] = "Arathi Basin",
}

if WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
    battlegroundSchedule[4] = "Eye of the Storm" --name check this
end

--this is used to get the name of the event
--the pvp battlegrounds use their schedule index values
local worldEventIDs = {
    [0] = "Darkmoon Faire",
    [1] = "Alterac Valley",
    [2] = "Warsong Gulch",
    [3] = "Arathi Basin",
    [4] = "Eye of the Storm",
    [5] = "Fishing Extravaganza"
}


local raidKeyToName = {
    moltencore = { name = "Molten Core", },
    blackwinglair = { name = "Blackwing lair", },
    onyxia = { name = "Onyxia", },
    templeofahnqiraj = { name = "AQ40 Temple of Ahn'Qiraj", },
    naxxramas = { name = "Naxxramas", },
    zulgurub = { name = "Zul'Gurub", },
    ruinsofahnqiraj = { name = "AQ20 Ruins of Ahn'Qiraj"},
}


--[[
    TBC stuff
]]
-- local raids = {
--     { name = L["Magtheridon"], textureKey = "magtheridonslair", },
--     { name = L["SSC"], textureKey = "coilfangreservoir", },
--     { name = L["TK"], textureKey = "tempestkeep", },
--     { name = L["Gruul"], textureKey = "gruulslair", },
--     { name = L["Hyjal"], textureKey = "cavernsoftime", },
--     { name = L["BT"], textureKey = "blacktemple", },
--     { name = L["SWP"], textureKey = "sunwellplateau", },
--     { name = L["Karazhan"], textureKey = "karazhan", },
--     { name = L["ZA"], textureKey = "zulaman", },
-- }

--days * hours * mins * secs
--these allows the numbers of days to be adjusted as needed for raid if anything ever changed (sod!)
local raidResetDurations = {
    moltencore = 7 * 24 * 60 * 60,
    blackwinglair = 7 * 24 * 60 * 60,
    onyxia = 5 * 24 * 60 * 60,
    templeofahnqiraj = 7 * 24 * 60 * 60,
    naxxramas = 7 * 24 * 60 * 60,
    zulgurub = 3 * 24 * 60 * 60,
    ruinsofahnqiraj = 3 * 24 * 60 * 60,
}

--need to consider eu/na servers and era/sod servers
local raidResetFixedDates = {
    era = {
        na = {
            --[[
                these are the weekly reset raids (dst=false)

                i used 09:30 for NA as its a large place and tbh its only really the days that matter?
            ]]
            moltencore = 1748943000, --june 3rd 09:30
            blackwinglair = 1748943000, --june 3rd 09:30
            --onyxia = 1748419200, --may 28th 2025 8am
            templeofahnqiraj = 1748943000, --june 3rd 09:30
            naxxramas = 1748943000, --june 3rd 09:30

            --5 days
            onyxia = 1748856600, --june 2rd 09:30

            --[[
                these are the 3 day reset raids
            ]]
            zulgurub = 1749029400, --june 4rd 09:30
            ruinsofahnqiraj = 1749029400, --june 4rd 09:30
        },
        eu = {
            --[[
                these are the weekly reset raids (dst=false)
            ]]
            moltencore = 1748419200, --may 28th 2025 8am
            blackwinglair = 1748419200, --may 28th 2025 8am
            --onyxia = 1748419200, --may 28th 2025 8am
            templeofahnqiraj = 1748419200, --may 28th 2025 8am
            naxxramas = 1748419200, --may 28th 2025 8am

            --5 days
            onyxia = 1748332800, --may 27th 2025 8am (5 day reset)

            --these are the 3 day reset raids
            zulgurub = 1748505600,
            ruinsofahnqiraj = 1748505600,
        },
    },
    sod = {
        na = {

        },

        eu = {

        },
    }
}


--i think this is the same on servers as it covers a long weekend rather than specific days/times
local battlegroundFixedDates = {
    EU = 1746144060 --may 2nd 2025 00:01:00 alterac valley
}

local C_Calendar = {
	holidayEvents = {},
    instanceResets = {},
    guildEvents = {},
}

--https://wago.tools/db2/Cfg_Regions?build=1.15.7.61186
local regionIDs = {
    [1] = "na",
    [3] = "eu",
}

addon.CalendarEventTypeEnums = {
    [1] = "Guild Events",
    [2] = "World Holidays",
    [3] = "Instance Resets",
    [4] = "Battleground Holidays",
}

local eventDayIDs = {
    battleground = 1,
    worldevent = 3,
    dmf = 2,
    fishing = 4,
    midsummer = 5,
}

local drawLayers = {
    battleground = 1,
    worldevent = 2,
    dmf = 7,
    fishing = 6,
    midsummer = 3,
    lunar = 3,
    winterveil = 3,
    brewfest = 3,
    hallowsend = 3,
}

local function GetActualRegion()
    local gameAccountInfo = C_BattleNet.GetGameAccountInfoByGUID(UnitGUID("player"))
    return gameAccountInfo and gameAccountInfo.regionID or GetCurrentRegion()
end

local function IsDaylightSaving(_time)
    local d = date("*t", _time or time())
    return d.isdst
end

local function CreateTimeForDate(year, month, day, hour, min, sec)
    return time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})
end


local zgMadnessSchedule = {
    "Hazza'rah",
    "Renataki",
    "Wushoolay",
    "Gri'lek",
}
local knownMaddnessStart = 1757462401; -- 1761091300; --october 22 2025 1am ish start of Gri'lek
local fortnight = (14 * 24 * 60 * 60)
function C_Calendar.GetMadnessBoss(year, month, day)

    local today = CreateTimeForDate(year, month, day, 1, 1, 1)

    local timeDiff = today - knownMaddnessStart;

    if timeDiff < fortnight then
        --print(string.format("Madness Boss: %s", zgMadnessSchedule[1]))

    else
        local bossPeriods = timeDiff / fortnight;

        local currentBossIndex = (math.floor(bossPeriods) % 4) + 1;

        -- DevTools_Dump({
        --     today = today,
        --     knownMaddnessStart = knownMaddnessStart,
        --     timeDiff = timeDiff,
        --     bossPeriods = bossPeriods,
        --     currentBossIndex = currentBossIndex,
        -- })

        return zgMadnessSchedule[currentBossIndex]
    end

end



--[[
=====================================
Calendar Events

Calendar events, some goals for this
1. provide guilds with an in game calendar
2. ensure the sync between guild members is as best as possible
3. make sure in game addon chat comms are kept minimal


2025-06-8:
The current strategy is to create the following,
-player logs in to game world
-> sends a request for event versions
-> when versions are received, check the following
--> event exists but version is newer > request data from sender
--> event exists but version is older > send data to sender
--> event does not exist > request data from sender

when an event is created it is sent to online guild members
when an event attending update occurs, it is sent to online guild members
when an event info is changed, it is sent to online guild members

-a short delay will be set upon which the logged in player will loop events and request attending data
-> this will involve a stagger effect so comms are not loaded
-> on receiving data, update events attending as per statusInfo versions


=======================================
]]

function C_Calendar.GetCalendarEventsBetween(startTime, duration)
    local t = {}
    local from = time(startTime)
    local to = from + (duration * 24 * 60 * 60) -1 --minus 1 sec so its only 23:59:59
    if addon.calendarEvents and (next(addon.calendarEvents) ~= nil) then
        for k, event in pairs(addon.calendarEvents) do
            if event.data.scheduledTime and (event.data.scheduledTime >= from) and (event.data.scheduledTime <= to) then
                table.insert(t, event)
            end
        end
    end
    return t;
end

function C_Calendar.DeleteCalendarEventID(eventID, transmit)

    addon.calendarEvents[eventID] = nil;

    --clear it from the saved variables as well - this also removes the version check
    Database:DeleteCalendarEventID(eventID);
    addon:TriggerEvent("Calendar_OnCalendarEventDeleted")

    if Comms and (transmit == true) then
        Comms:TransmitCalendarEvent_Deleted(eventID)
    end

end

--incoming comms, causes a loop in comms if passed to the above function
function C_Calendar.OnDeleteCalendarEventID(eventID)
    addon.calendarEvents[eventID] = nil;
    Database:DeleteCalendarEventID(eventID);
    addon:TriggerEvent("Calendar_OnCalendarEventDeleted")
end

--this is called when the owner of the event changes the info
--send the update to online guild members
function C_Calendar.SetCalendarEventChanged(event)
    if Comms then
        Comms:TransmitCalendarEvent_Changed(event:GetEventInfo())
    end
end

--this is incoming data of a event info update
function C_Calendar.OnCalendarEventChanged(data)
    --here we need to check if this data is newer or not
    --DevTools_Dump(data)
    if data.id and addon.calendarEvents then
        if addon.calendarEvents[data.id] then
            --event data needs to be checked for version control
            --SetInfoUpdate will check the obj version and update if the data is newer
            addon.calendarEvents[data.id]:SetInfoUpdate(data)
        else
            --we dont have thsi event so we need to ask for it ?
            return false
        end
    end
end

--this is called when a player changes their event attending status
function C_Calendar.SetCalendarEventAttendingChanged(eventID, nameRealm, statusInfo)
    if Comms then
        Comms:TransmitCalendarEvent_AttendingChanged(eventID, nameRealm, statusInfo)
    end
end

function C_Calendar.OnCalendarEventAttendingChanged(data)

    --DevTools_Dump(data)

    if data.id and addon.calendarEvents then
        if addon.calendarEvents[data.id] then
            addon.calendarEvents[data.id]:SetPlayerAttending(data.nameRealm, data.statusInfo)
        else
            --we dont have thsi event so we need to ask for it ?
            return false
        end
    end
end

--when a new guild event is created this will be called
function C_Calendar.CalendarEventCreate(event, transmit)
    --tell the db to store it
    Database:InsertCalendarEvent(event)

    --check we have an addon wide table for events (like we do characters)
    if not addon.calendarEvents then
        addon.calendarEvents = {}
    end

    --if this event isnt in the table then make a new obj for it
    if not addon.calendarEvents[event.id] then
        local newEvent = Database:GetCalendarEvent(event.id)
        addon.calendarEvents[newEvent.id] = CalendarEvent:CreateFromData(newEvent)


        --now that the new event has been created and saved 2 things need to happen
        -- 1. we need to inform the guild about it, this means sendign the event data across the GUILD comms
        -- 2. update this users UI, the data being sent will bounce back here and go through the logic of a new event being sent across the GUILD comms
        --but this might take time depending on the Comms queue size.

        --update this UI first, this user will get confirmation of the event being created successfully
        addon:TriggerEvent("Calendar_OnCalendarEventCreated", addon.calendarEvents[newEvent.id])
        if Comms and transmit then
            Comms:TransmitCalendarEvent_Created(addon.calendarEvents[newEvent.id]:GetData())
        end

    else
        --we might get data here for an event that exists but the incoming data is newer
    end
end

--this is when a full event data is received
function C_Calendar.OnCalendarEventDataReceived(sender, data)
    
    --if its a brand new event to us, create it
    if addon.calendarEvents and (addon.calendarEvents[data.id] == nil) then
        C_Calendar.CalendarEventCreate(data)
        return
    end

    --if we have the event then lets check version and update as required
    if addon.calendarEvents and addon.calendarEvents[data.id] then

        --check the event info, this checks for a lastUpdate
        addon.calendarEvents[data.id]:SetInfoUpdate(data)

        if type(data.attending) == "table" and (next(data.attending) ~= nil) then
            for nameRealm, statusInfo in pairs(data.attending) do

                --this will handle the version for each attendee
                addon.calendarEvents[data.id]:SetPlayerAttending(nameRealm, statusInfo)
            end
        end
    end
end


--this is the response we get after requesting version data
--it needs to be handled and either events requested or sent as per version control
--[[

    NOTE - using version requests was removed in favour of just sending full event data in a staggered manner

function C_Calendar.OnCalendarVersionsReceived(sender, data)

    local myCalendarEventVersion = C_Calendar:GetCalendarEventVersions()
    if next(myCalendarEventVersion) ~= nil then

        for eventID, version in pairs(data) do
            
            --possible options
            --1. we dont have the event > request it
            --2. we have an older version > request it
            --3. we have a newer version > send it


            --options 1 and 2 will result in a full event data payload being sent to us and falling into
            --function C_Calendar.OnCalendarEventDataReceived(sender, data)
            --that function will create the event as a new event


            --option 1:
            if addon.calendarEvents[eventID] == nil then
                
                --we need to request this event
                Comms:TransmitCalendarEvent_DataRequest(sender, eventID)
                return;
            end

            --option 2:
            if addon.calendarEvents[eventID] and (addon.calendarEvents[eventID].data.lastUpdate > version) then
                
                --request the newer data
                Comms:TransmitCalendarEvent_DataRequest(sender, eventID)
                return;
            end

            --option 3:
            if addon.calendarEvents[eventID] and (addon.calendarEvents[eventID].data.lastUpdate < version) then

                --we have newer data so lets tell the sender
                --its probably better to just send the whole event data as the message will be compressed and hopefully consume very little comms traffic
                --better than 40+ messages per attendee
                Comms:OnCalendarEventRequestData(sender, {payload = eventID})
                return;
            end
        end

    end
end
]]

function C_Calendar.GetCalendarEventVersions()
    local t = {}
    if addon.calendarEvents and next(addon.calendarEvents) ~= nil then
        for eventID, event in pairs(addon.calendarEvents) do
            t[eventID] = event.data.lastUpdate
        end
    end
    return t;
end

function C_Calendar.GetCalendarEvents()
    local today = date("*t", time())
    today.hour = 0
    today.min = 0
    today.sec = 0
    local events = C_Calendar.GetCalendarEventsBetween(today, 14) --restrict this to the next 14 days only
    return events;
end

function C_Calendar.InitializeCalendarEvents()

    local events = Database:GetCalendarEvents()

    if not addon.calendarEvents then
        addon.calendarEvents = {}
    end

    for eventID, eventData in pairs(events) do
        if not addon.calendarEvents[eventID] then
            addon.calendarEvents[eventID] = CalendarEvent:CreateFromData(eventData)
        end
    end

end



--[[

    Some thoughts on guild events

    You log in and request event version > GUILD channel
    Everyone replies with their event lastUpdate values
    You request per person in WHISPER if their lastUpdate is newer than yours
    You tell the event to update itself
    That covers the event info (title, desc, scheduledTime)

    If you dont have this event data then request and or create an event
    This should provide FULL event data including attending table

    For attending data...?


]]









function C_Calendar.CheckDateTableExists(year, month, day)
    local tbls = {
        "holidayEvents",
        "guildEvents",
        "instanceResets",
    }

    for _, tbl in ipairs(tbls) do
        if not C_Calendar[tbl][year] then
            C_Calendar[tbl][year] = {}
        end
        if not C_Calendar[tbl][year][month] then
            C_Calendar[tbl][year][month] = {}
        end
        if type(day) == "number" then
            if not C_Calendar[tbl][year][month][day] then
                C_Calendar[tbl][year][month][day] = {}
            end
        end
    end
end

function C_Calendar.IsEventRegistered(year, month, day, event, dbTable)
    if C_Calendar[dbTable] and C_Calendar[dbTable][year] and C_Calendar[dbTable][year][month] and C_Calendar[dbTable][year][month][day] then
        for _, _event in ipairs(C_Calendar[dbTable][year][month][day]) do
            -- local ret = true
            -- for k, v in pairs(_event) do
            --     if event[k] ~= v then
            --         ret = false
            --     end
            -- end
            -- return ret
            if _event.id == event.id then
                return true
            end
        end
    end
    return false
end

function C_Calendar.RegisterEvent(year, month, day, event, dbTable)
    if event.id == nil then
        return
    end
    if C_Calendar.IsEventRegistered(year, month, day, event, dbTable) == false then
        if not C_Calendar[dbTable][year] then
            C_Calendar[dbTable][year] = {}
        end
        if not C_Calendar[dbTable][year][month] then
            C_Calendar[dbTable][year][month] = {}
        end
        if not C_Calendar[dbTable][year][month][day] then
            C_Calendar[dbTable][year][month][day] = {}
        end
        table.insert(C_Calendar[dbTable][year][month][day], event)
    end
end

function C_Calendar.GetDaysInMonth(month, year)
    local daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local d = daysInMonth[month]
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

function C_Calendar.RegisterHolidayEvents(year, month)

    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    if worldHolidayEvents[year] and worldHolidayEvents[year][month] then
        for monthDay, holidays in pairs(worldHolidayEvents[year][month]) do
            for _, holidayInfo in ipairs(holidays) do
                if worldHolidayDurations[holidayInfo.id] > 1 then
                    local holidayStartTime = CreateTimeForDate(year, month, monthDay, 0, 0, 0)

                    C_Calendar.RegisterEvent(year, month, monthDay, {
                        name = holidayInfo.name,
                        id = holidayInfo.id,
                        drawLayer = drawLayers[holidayInfo.id],
                        eventType = 2,
                        texture = worldHolidayTextures[holidayInfo.id].start,
                    }, "holidayEvents")

                    for i = 1, worldHolidayDurations[holidayInfo.id] - 1 do
                        local dayDate = date("*t", holidayStartTime + (i * 24 * 60 * 60))
                        C_Calendar.RegisterEvent(dayDate.year, dayDate.month, dayDate.day, {
                            name = holidayInfo.name,
                            id = holidayInfo.id,
                            drawLayer = drawLayers[holidayInfo.id],
                            eventType = 2,
                            texture = worldHolidayTextures[holidayInfo.id].ongoing,
                        }, "holidayEvents")
                    end

                    local holidayEndsDate = date("*t", holidayStartTime + (worldHolidayDurations[holidayInfo.id] * 24 * 60 * 60))
                    C_Calendar.RegisterEvent(holidayEndsDate.year, holidayEndsDate.month, holidayEndsDate.day, {
                        name = holidayInfo.name,
                        id = holidayInfo.id,
                        drawLayer = drawLayers[holidayInfo.id],
                        eventType = 2,
                        texture = worldHolidayTextures[holidayInfo.id].ends,
                    }, "holidayEvents")
                end
            end
        end
    end
end

function C_Calendar.GetRaidResetsForMonth(year, month)

    --[[
        this func will need more data added for different regions and servers
    ]]

    --sod has diferent raids which need adding/handling
    local client = "era"
    if C_Seasons and (C_Seasons.GetActiveSeason() == 2) then
        client = "sod"
    end

    local resetData;
    local region = regionIDs[GetActualRegion()]
    
    if region and raidResetFixedDates[client] and raidResetFixedDates[client][region] then
        resetData = raidResetFixedDates[client][region]
    end

    if resetData == {} then
        return
    end

    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    local daysInMonth = C_Calendar.GetDaysInMonth(month, year)

    local timeForFirstDayOfMonth = CreateTimeForDate(year, month, 1, 0, 0, 1)




    --[[
    
        to attempt to address a bug found for a player outside of the uk where time is +2

        i took a different strategy, this will increment the hardcoded reset time until it falls within the selected month
        from there we add the reset time and add the events
    
    ]]

    for raidKey, fixedResetTime in pairs(resetData) do

        local raidResetTime = fixedResetTime - 3600;
        while raidResetTime < timeForFirstDayOfMonth do
            raidResetTime = raidResetTime + raidResetDurations[raidKey]
        end

        local firstRaidResetOfMonth = date("*t", raidResetTime)

        C_Calendar.RegisterEvent(year, month, firstRaidResetOfMonth.day, {
            name = raidKeyToName[raidKey].name,
            id = string.format("raidreset-%s", raidKey),
            eventType = 3,
            texture = string.format("interface/encounterjournal/ui-ej-dungeonbutton-%s", raidKey),
        }, "instanceResets")


        for i = 1, math.ceil(daysInMonth / (raidResetDurations[raidKey] / 60 / 60 / 24)) do --this should reduce the loop for the weekly resets and also cover the shorter 3 day resets
            
            local nextRaidDate = date("*t", raidResetTime + (i * raidResetDurations[raidKey]))

            if nextRaidDate.year == year and nextRaidDate.month == month then

                C_Calendar.RegisterEvent(year, month, nextRaidDate.day, {
                    name = raidKeyToName[raidKey].name,
                    id = string.format("raidreset-%s", raidKey),
                    eventType = 3,
                    texture = string.format("interface/encounterjournal/ui-ej-dungeonbutton-%s", raidKey),
                }, "instanceResets")
            end

        end


    end















    --[[
        using the known reset timestamps, loop the month days and check if the difference to the reset results in a whole number
        if it does that means its a reset day
    ]]
    --for raidKey, fixedResetTime in pairs(resetData) do


        --[[
            ok so found a bug with the hardcoded reset times being 9 not 8
        ]]
        --fixedResetTime = (fixedResetTime - 3600)
        
       -- for dayIndex = 1, daysInMonth do
            --local dayTime = time({ year = year, month = month, day = dayIndex, hour = 8, min = 0, sec = 0})
            --local dayTime = time({ year = year, month = month, day = dayIndex, hour = 9, min = 0, sec = 0})  --swapped to 9 to match the reset data 

           -- local differenceToKnownReset = dayTime - fixedResetTime;

            --add 1 hour for dst
            --if IsDaylightSaving(dayTime) then
                --differenceToKnownReset = differenceToKnownReset + 3600
            --end

            -- if (differenceToKnownReset / raidResetDurations[raidKey]) % 1 == 0 then
            --     C_Calendar.RegisterEvent(year, month, dayIndex, {
            --         name = raidKeyToName[raidKey].name,
            --         id = string.format("raidreset-%s", raidKey),
            --         eventType = 3,
            --         texture = string.format("interface/encounterjournal/ui-ej-dungeonbutton-%s", raidKey),
            --     }, "instanceResets")
            -- end
        --end
    --end
end

function C_Calendar.GetBattlegroundsForMonth(month, year)

    local one_week = 60 * 60 * 24 * 7;

    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    local monthStartsOnSaturday = false;

    local first_friday = nil;
    for day = 1, 7 do
        local t = time({year = year, month = month, day = day, hour = 0, min = 1, sec = 0})
        local d = date("*t", t)
        if d.wday == 6 then  -- Friday = 6
            first_friday = t
            if d.day == 7 then
                monthStartsOnSaturday = true
            end
        end
    end

    --make sure this friday is still with the current month
    local daysInMonth = C_Calendar.GetDaysInMonth(month, year)
    local lastDayInMonth = time({ year = year, month = month, day = daysInMonth, hour = 23, min = 59, sec = 0})

    for i = 0, 4 do
        local this_friday = first_friday + (i * one_week)

       -- print("weekend iter", date("*t", this_friday).day)

        if this_friday < lastDayInMonth then

            -- local battlegroundSchedule = {
            --     [1] = "Alterac Valley",
            --     [2] = "Warsong Gulch",
            --     [3] = "Arathi Basin",
            -- }

            local num_weeks_passed = (this_friday - battlegroundFixedDates.EU) / one_week
            local battlegroundScheduleIndex = math.ceil(num_weeks_passed % #battlegroundSchedule) + 1

            if monthStartsOnSaturday == true then
                --lets just fix the start of the month
                --get the previous index, if thats less than 1 that means it was already 1 and should now be the last entry
                local previousBgIndex = battlegroundScheduleIndex - 1;
                if previousBgIndex < 1 then
                    previousBgIndex = #battlegroundSchedule;
                end

                for dy = 1, 2 do
                    C_Calendar.RegisterEvent(year, month, dy, {
                        name = worldEventIDs[previousBgIndex],
                        id = eventDayIDs.battleground,
                        drawLayer = drawLayers.battleground,
                        eventType = 4,
                        texture = 1129670,
                    }, "holidayEvents")
                end

            end

            for offset = 0, 3 do
                local fri = this_friday + (offset * 86400)
                local day_date = date("*t", fri)

                --print(string.format("BG: Date=%d Month=%d CalendarMonth=%d BgIndex=%d", day_date.day, day_date.month, month, battlegroundScheduleIndex))

                if (day_date.month == month) and (day_date.wday ~= 5) and (day_date.wday ~= 3) and (day_date.wday ~= 4) then

                    --print("day date checks passed adding event")
                    
                    C_Calendar.CheckDateTableExists(year, month, day_date.day)

                    if offset == 0 then

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = eventDayIDs.battleground,
                            drawLayer = drawLayers.battleground,
                            eventType = 4,
                            texture = 1129671,
                        }, "holidayEvents")
                        
                    elseif offset == 3 then

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = eventDayIDs.battleground,
                            drawLayer = drawLayers.battleground,
                            eventType = 4,
                            texture = 1129669,
                        }, "holidayEvents")

                    else

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = eventDayIDs.battleground,
                            drawLayer = drawLayers.battleground,
                            eventType = 4,
                            texture = 1129670,
                        }, "holidayEvents")

                    end

                end

            end

        end
    end

end

function C_Calendar.GetDarkmoonDataForMonth(month, year)

    --local now = date("*t")

    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    -- Step 1: Find the first Friday of the month
    local first_friday
    for day = 1, 7 do
        local t = time({year = year, month = month, day = day})
            if date("*t", t).wday == 6 then  -- Friday = 6
                first_friday = t
            break
        end
    end
  
    -- Step 2: Find the first Sunday *after* that Friday
    local first_sunday_after_friday
    for offset = 1, 7 do
        local t = first_friday + offset * 86400  -- 86400 seconds in a day
            if date("*t", t).wday == 1 then  -- Sunday = 1
                first_sunday_after_friday = t
            break
        end
    end
  
    -- Step 3: Define the end of the range (next Sunday)
    local second_sunday = first_sunday_after_friday + 7 * 86400

    local start_date, end_date = date("*t", first_sunday_after_friday), date("*t", second_sunday)

    C_Calendar.RegisterEvent(year, month, start_date.day, {
        name = worldEventIDs[0],
        id = eventDayIDs.dmf,
        drawLayer = drawLayers.dmf,
        eventType = 2,
        texture = (month % 2 == 0) and 235451 or 235448; --NOTE THIS WILL BREAK IN TBC DUE TO 3 LOCATIONS
    }, "holidayEvents")

    C_Calendar.RegisterEvent(year, month, end_date.day, {
        name = worldEventIDs[0],
        id = eventDayIDs.dmf,
        drawLayer = drawLayers.dmf,
        eventType = 2,
        texture = (month % 2 == 0) and 235449 or 235446;
    }, "holidayEvents")

    for day = start_date.day + 1, end_date.day - 1, 1 do
        C_Calendar.RegisterEvent(year, month, day, {
            name = worldEventIDs[0],
            id = eventDayIDs.dmf,
            drawLayer = drawLayers.dmf,
            eventType = 2,
            texture = (month % 2 == 0) and 235450 or 235447,
        }, "holidayEvents")
    end

end

function C_Calendar.GetFishingEventForMonth(month, year)
    
    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    for day = 1, C_Calendar.GetDaysInMonth(month, year), 1 do
        if date("*t", time({year = year, month = month, day = day})).wday == 1 then
            local event = {
                name = worldEventIDs[5],
                id = eventDayIDs.fishing,
                drawLayer = drawLayers.fishing,
                eventType = 2,
                texture = 235458
            }
            C_Calendar.RegisterEvent(year, month, day, event, "holidayEvents")
        end
    end
end

function C_Calendar.GetInstanceResets(monthOffset, monthDay)
    if C_Calendar.instanceResets[C_Calendar.absDate.year] and C_Calendar.instanceResets[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset] and C_Calendar.instanceResets[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] then
        return C_Calendar.instanceResets[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] or {}
    end
    return {}
end

function C_Calendar.GetNumDayEvents(monthOffset, monthDay)
    if C_Calendar.holidayEvents[C_Calendar.absDate.year] and C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset] and C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] then
        return #C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay]
    end
    return 0
end

function C_Calendar.GetHolidayInfo(monthOffset, monthDay, eventIndex)
    if C_Calendar.holidayEvents[C_Calendar.absDate.year] and C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset] and C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] then
        return C_Calendar.holidayEvents[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay][eventIndex] or {}
    end
    return {}
end

function C_Calendar.SetAbsMonth(month, year)

    if not C_Calendar.absDate then
        C_Calendar.absDate = date("*t")
    end

	C_Calendar.absDate.month = month
	C_Calendar.absDate.year = year
	C_Calendar.absDate.hour = 0
	C_Calendar.absDate.min = 1

    C_Calendar.CheckDateTableExists(C_Calendar.absDate.year, C_Calendar.absDate.month)

end


--this will get called when the calendar month changes
--this function creates the various day event entries in the C_Calendar.eventsDb table
--the table is empty on load and is populated as the user navigates.
function C_Calendar.Calendar_OnMonthChanged()
    
    C_Calendar.GetDarkmoonDataForMonth()
    C_Calendar.GetBattlegroundsForMonth()
    C_Calendar.GetFishingEventForMonth()
    C_Calendar.GetRaidResetsForMonth()
    C_Calendar.RegisterHolidayEvents()

end

function C_Calendar:Init()
	local now = date("*t")
    self.absDate = now
    C_Calendar.SetAbsMonth(now.month, now.year)

    Comms = addon.Comms;

    C_Calendar.InitializeCalendarEvents()

    addon:RegisterCallback("Calendar_OnMonthChanged", self.Calendar_OnMonthChanged, self)

    if ViragDevTool_AddData then
        ViragDevTool_AddData(Database.db.calendar, "Database.db.calendar")
        ViragDevTool_AddData(addon.calendarEvents, "addon.calendarEvents")
    end

    addon:TriggerEvent("Calendar_OnInitialized")
end

--C_Calendar:Init()

addon.Calendar = C_Calendar;


-- Guildbook_CalendarWorldEvents = {
-- 	[L["DARKMOON_FAIRE"]] = {
-- 		['Elwynn'] = {
-- 			['Start'] = 235448,
-- 			['OnGoing'] = 235447,
-- 			['End'] = 235446,
-- 		},
-- 		['Mulgore'] = {
-- 			['Start'] = 235451,
-- 			['OnGoing'] = 235450,
-- 			['End'] = 235449,
-- 		},
-- 	},
-- 	[L["LOVE IS IN THE AIR"]] = {
-- 		['Start'] = { 
-- 			day = 7, 
-- 			month = 2,
-- 		},
-- 		['End'] = { 
-- 			day = 20, 
-- 			month = 2,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235468,
-- 			['OnGoing'] = 235467,
-- 			['End'] = 235466,
-- 		}
-- 	},
-- 	[L["CHILDRENS_WEEK"]] = {
-- 		['Start'] = { 
-- 			day = 1, 
-- 			month = 5,
-- 		},
-- 		['End'] = { 
-- 			day = 7, 
-- 			month = 5,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235445,
-- 			['OnGoing'] = 235444,
-- 			['End'] = 235443,
-- 		}
-- 	},
-- 	[L["MIDSUMMER_FIRE_FESTIVAL"]] = {
-- 		['Start'] = { 
-- 			day = 20, 
-- 			month = 7,
-- 		},
-- 		['End'] = { 
-- 			day = 3, 
-- 			month = 8,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235474,
-- 			['OnGoing'] = 235473,
-- 			['End'] = 235472,
-- 		}
-- 	},
-- 	[L["HARVEST_FESTIVAL"]] = {
-- 		['Start'] = { 
-- 			day = 27, 
-- 			month = 9,
-- 		},
-- 		['End'] = { 
-- 			day = 4, 
-- 			month = 10,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235465,
-- 			['OnGoing'] = 235464,
-- 			['End'] = 235463,
-- 		}
-- 	},
-- 	[L["HALLOWS_END"]] = {
-- 		['Start'] = { 
-- 			day = 18, 
-- 			month = 10,
-- 		},
-- 		['End'] = { 
-- 			day = 2, 
-- 			month = 11,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235462,
-- 			['OnGoing'] = 235461,
-- 			['End'] = 235460,
-- 		}
-- 	},
-- 	[L["FEAST_OF_WINTER_VEIL"]] = {
-- 		['Start'] = { 
-- 			day = 15, 
-- 			month = 12,
-- 		},
-- 		['End'] = { 
-- 			day = 2, 
-- 			month = 1,
-- 		},
-- 		['Texture'] = {
-- 			['Start'] = 235485,
-- 			['OnGoing'] = 235484,
-- 			['End'] = 235482,
-- 		}
-- 	},
-- }