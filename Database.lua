local name, addon = ...;

local Database = {}

function Database:Init()

    GUILDBOOK_GLOBAL = nil

    if not GUILDBOOK_GLOBAL then
        GUILDBOOK_GLOBAL = {
            config = {},
            minimapButton = {},
            calendarButton = {},
            guilds = {},
            worldEvents = {},
            myCharacters = {},
            characterDirectory = {},
        }
    end

    self.db = GUILDBOOK_GLOBAL;

    addon:TriggerEvent("Database_OnInitialised")
end

function Database:InsertCharacter(character)
    if self.db then
        self.db.characterDirectory[character.name] = character;
    end
end

function Database:GetCharacter(nameRealm)
    if self.db and self.db.characterDirectory[nameRealm] then
        return self.db.characterDirectory[nameRealm];
    end
end

function Database:SetConfig(conf, val)
    if self.db and self.db.config then
        self.db.config[conf] = val
    end
end

function Database:GetConfig(conf)
    if self.db and self.db.config then
        return self.db.config[conf];
    end
    return false;
end

addon.Database = Database;