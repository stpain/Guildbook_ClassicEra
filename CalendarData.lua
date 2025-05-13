local name, addon = ...;

local L = {}

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
}

local darkmoonFaireSchedule = {
    [1] = "Elwynn Forest",
    [2] = "Thunder Bluff",
    [3] = "Terokkar Forest",
}

local worldEventStartDates = {
    MidSummerFireFestival = {21,6},
    HallowsEnd = {25, 10}
}

local battlegroundSchedule = {
    [1] = "Alterac Valley",
    [2] = "Warsong Gulch",
    [3] = "Arathi Basin",
}
local worldEventIDs = {
    [0] = "Darkmoon Faire",
    [1] = "Alterac Valley",
    [2] = "Warsong Gulch",
    [3] = "Arathi Basin",
    [5] = "Fishing Extravaganza"
}

local battlegroundFixedDates = {
    EU = 1746144060 --may 2nd 2025 00:01:00 alterac valley
}

local C_Calendar = {
	eventsDb = {},
}


function C_Calendar.IsEventRegistered(year, month, day, event)
    if C_Calendar.eventsDb and C_Calendar.eventsDb[year] and C_Calendar.eventsDb[year][month] and C_Calendar.eventsDb[year][month][day] then
        for _, _event in ipairs(C_Calendar.eventsDb[year][month][day]) do
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

function C_Calendar.RegisterEvent(year, month, day, event)
    if event.id == nil then
        return
    end
    if C_Calendar.IsEventRegistered(year, month, day, event) == false then
        if not C_Calendar.eventsDb[year] then
            C_Calendar.eventsDb[year] = {}
        end
        if not C_Calendar.eventsDb[year][month] then
            C_Calendar.eventsDb[year][month] = {}
        end
        if not C_Calendar.eventsDb[year][month][day] then
            C_Calendar.eventsDb[year][month][day] = {}
        end
        table.insert(C_Calendar.eventsDb[year][month][day], event)
    end
end

function C_Calendar.GetDaysInMonth(month, year)
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

function C_Calendar.GetBattlegroundsForMonth(month, year)

    local one_week = 60 * 60 * 24 * 7;

    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    local first_friday
    for day = 1, 7 do
        local t = time({year = year, month = month, day = day})
            if date("*t", t).wday == 6 then  -- Friday = 6
                first_friday = t

                --print("got first friday", date("*t", t).day)
            break
        end
    end

    --make sure this friday is still with the current month
    local days_in_month = C_Calendar.GetDaysInMonth(month, year)
    local last_month_day = time({ year = year, month = month, day = days_in_month, hour = 0, min = 1, sec = 0})

    for i = 0, 4 do
        local this_friday = first_friday + (i * one_week)

        --print("weekend iter", date("*t", this_friday).day)

        if this_friday < last_month_day then

            local num_weeks_passed = (this_friday - battlegroundFixedDates.EU) / one_week
            local battlegroundScheduleIndex = math.ceil(num_weeks_passed % #battlegroundSchedule)

            for offset = 0, 3 do
                local fri = this_friday + (offset * 86400)
                local day_date = date("*t", fri)

                --print("day iter", day_date.day, day_date.month, month, battlegroundSchedule[battlegroundScheduleIndex])

                if day_date.month == month and day_date.wday ~= 5 and day_date.wday ~= 3 and day_date.wday ~= 4 then
                    
                    if not C_Calendar.eventsDb[year][month][day_date.day] then
                        C_Calendar.eventsDb[year][month][day_date.day] = {}
                    end

                    if offset == 0 then

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = battlegroundScheduleIndex,
                            texture = 1129671,
                        })
                        
                    elseif offset == 3 then

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = battlegroundScheduleIndex,
                            texture = 1129669,
                        })

                    else

                        C_Calendar.RegisterEvent(year, month, day_date.day, {
                            name = worldEventIDs[battlegroundScheduleIndex],
                            id = battlegroundScheduleIndex,
                            texture = 1129670,
                        })

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
        id = 0,
        texture = (month % 2 == 0) and 235448 or 235451; --NOTE THIS WILL BREAK IN TBC DUE TO 3 LOCATIONS
    })

    C_Calendar.RegisterEvent(year, month, end_date.day, {
        name = worldEventIDs[0],
        id = 0,
        texture = (month % 2 == 0) and 235446 or 235449;
    })

    for day = start_date.day + 1, end_date.day - 1, 1 do
        C_Calendar.RegisterEvent(year, month, day, {
            name = worldEventIDs[0],
            id = 0,
            texture = (month % 2 == 0) and 235447 or 235450,
        })
    end

end

function C_Calendar.GetFishingEventForMonth(month, year)
    
    month = month or C_Calendar.absDate.month
    year = year or C_Calendar.absDate.year

    for day = 1, C_Calendar.GetDaysInMonth(month, year), 1 do
        if date("*t", time({year = year, month = month, day = day})).wday == 1 then
            local event = {
                name = worldEventIDs[5],
                id = 5,
                texture = 235458
            }
            C_Calendar.RegisterEvent(year, month, day, event)
        end
    end
end

function C_Calendar.GetNumDayEvents(monthOffset, monthDay)
    if C_Calendar.eventsDb[C_Calendar.absDate.year] and C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset] and C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] then
        return #C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay]
    end
    return 0
end

function C_Calendar.GetHolidayInfo(monthOffset, monthDay, eventIndex)
    if C_Calendar.eventsDb[C_Calendar.absDate.year] and C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset] and C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay] then
        return C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month + monthOffset][monthDay][eventIndex] or {}
    end
end

function C_Calendar.SetAbsMonth(month, year)

    if not C_Calendar.absDate then
        C_Calendar.absDate = date("*t")
    end

	C_Calendar.absDate.month = month
	C_Calendar.absDate.year = year
	C_Calendar.absDate.hour = 0
	C_Calendar.absDate.min = 1

    if not C_Calendar.eventsDb[C_Calendar.absDate.year] then
        C_Calendar.eventsDb[C_Calendar.absDate.year] = {}
    end
    if not C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month] then
        C_Calendar.eventsDb[C_Calendar.absDate.year][C_Calendar.absDate.month] = {}
    end

end

function C_Calendar.Calendar_OnMonthChanged()
    
    C_Calendar.GetDarkmoonDataForMonth()
    C_Calendar.GetBattlegroundsForMonth()
    C_Calendar.GetFishingEventForMonth()

end

function C_Calendar:Init()
	local now = date("*t")
    self.absDate = now
    C_Calendar.SetAbsMonth(now.month, now.year)

    addon:RegisterCallback("Calendar_OnMonthChanged", self.Calendar_OnMonthChanged, self)
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