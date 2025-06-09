

local addonName, Guildbook = ...;

local CalendarEvent = {}

-- function CalendarEvent:SetTitle(title)
--     self.data.title = title
-- end

-- function CalendarEvent:SetDescription(desc)
--     self.data.desc = desc
-- end


--when a player changes their status for an event, the addon will transmit this across the GUILD channel
--when the data is received C_Calendar will pass it to the event obj where the obj will check if the data is newer
--if its newer, update
function CalendarEvent:SetPlayerAttending(nameRealm, statusInfo)
    if self.data and self.data.attending then
        local statusID, incomingVersion = strsplit("-", statusInfo);
        if tonumber(statusID) and tonumber(incomingVersion) then
            if self.data.attending[nameRealm] == nil then
                self.data.attending[nameRealm] = statusInfo;
                Guildbook:TriggerEvent("Calendar_OnCalendarEventChanged", self);
            else

                local _, currentVersion = strsplit("-", self.data.attending[nameRealm]);
                if tonumber(incomingVersion) > tonumber(currentVersion) then
                    self.data.attending[nameRealm] = statusInfo;
                    Guildbook:TriggerEvent("Calendar_OnCalendarEventChanged", self);
                end
            end
        end
    end
end

function CalendarEvent:SetInfoUpdate(info)
    --print(tonumber(self.data.lastUpdate), tonumber(info.lastUpdate))
    if self.data and (tonumber(self.data.lastUpdate) < tonumber(info.lastUpdate)) then
        self.data.title = info.title
        self.data.desc = info.desc
        self.data.scheduledTime = info.scheduledTime
        self.data.lastUpdate = tonumber(info.lastUpdate)
        Guildbook:TriggerEvent("Calendar_OnCalendarEventChanged", self);
    end
end

function CalendarEvent:GetData()
    return self.data;
end

function CalendarEvent:GetEventInfo()
    if self.data then
        return {
            id = self.data.id,
            title = self.data.title,
            desc = self.data.desc,
            scheduledTime = self.data.scheduledTime,
            lastUpdate = self.data.lastUpdate,
        }
    end
end

function CalendarEvent:CreateEventData(title, desc, scheduledTime)
    
    local now = GetServerTime();
    --an eventID will be a unique value using the player and the current time
    local eventID = string.format("%s-%d", Guildbook.thisCharacter, now)

    local event = {
        id = eventID,
        title = title or "-",
        desc = desc or "-",
        scheduledTime = scheduledTime or now,
        attending = {},
        lastUpdate = now,
    }

    return event;

end


function CalendarEvent:CreateFromData(data)
    --DevTools_Dump(data)
    return Mixin({data = data}, self)
end



Guildbook.CalendarEvent = CalendarEvent;