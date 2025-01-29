local name, addon = ...;

local L = {}

local dmf = {
	{
		starts = 8,
		finishes = 14, --ellwyn
	},
	{
		starts = 5,
		finishes = 11, --mulgore
	},
	{
		starts = 4,
		finishes = 10,
	},
	{
		starts = 8,
		finishes = 14,
	},
	{
		starts = 6,
		finishes = 12,
	},
	{
		starts = 10,
		finishes = 16,
	},
	{
		starts = 8,
		finishes = 14,
	},
	{
		starts = 5,
		finishes = 11,
	},
	{
		starts = 9,
		finishes = 15,
	},
	{
		starts = 7,
		finishes = 13,
	},
	{
		starts = 4,
		finishes = 10,
	},
	{
		starts = 9,
		finishes = 15,
	},
}

local darkmoonFaireLocations = {
	"Mulgore",
	"Elwynn",
	"TerokkarForest",
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
}

local darkmoonFaireSchedule = {
	[2025] = {
		{

		}
	}
}

local C_Calendar = {
	eventsDb = {},
}

function C_Calendar.GetNumDayEvents(monthOffset, monthDay)
	local ret = 0;
	local now = date("*t")
	for k, v in ipairs(C_Calendar.eventsDb) do
		if (v.month == (C_Calendar.absDate.month + monthOffset)) and (v.monthDay == monthDay) then
			ret = ret + 1;
		end
	end
	return ret;
end
function C_Calendar.GetHolidayInfo(monthOffset, monthDay, eventIndex)
	local eventsToday = {}
	for k, v in ipairs(C_Calendar.eventsDb) do
		if (v.month == (C_Calendar.absDate.month + monthOffset)) and (v.monthDay == monthDay) then
			table.insert(eventsToday, v)
		end
	end
	if eventsToday[eventIndex] then
		return eventsToday[eventIndex];
	end
end
function C_Calendar.SetAbsMonth(month, year)
	C_Calendar.absDate.month = month
	C_Calendar.absDate.year = year
end
function C_Calendar:Init()

	self.absDate = date("*t")
	
	--load dmf
	for monthIndex, info in ipairs(dmf) do

		local textureMiddle = (monthIndex % 2 == 0) and 235447 or 235450;
		local textureStart = (monthIndex % 2 == 0) and 235448 or 235451;
		local textureFinish = (monthIndex % 2 == 0) and 235448 or 235449;

		for i = info.starts, info.finishes do
			local texture;
			if i == info.starts then
				texture = textureStart
			elseif i == info.finishes then
				texture = textureFinish
			else
				texture = textureMiddle
			end
			table.insert(self.eventsDb, {
				name = CALENDAR_FILTER_DARKMOON,
				monthDay = i,
				month = monthIndex,
				texture = texture,
			})
		end
	end
end

C_Calendar:Init()

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