local name, addon = ...;

local json = LibStub('JsonLua-1.0');

local Database = {}

function Database:Init()

    --GUILDBOOK_GLOBAL = nil

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

    addon:TriggerEvent("StatusText_OnChanged", "[Database_OnInitialised]")
    addon:TriggerEvent("Database_OnInitialised")
end

function Database:Reset()

    GUILDBOOK_GLOBAL = {
        config = {},
        minimapButton = {},
        calendarButton = {},
        guilds = {},
        worldEvents = {},
        myCharacters = {},
        characterDirectory = {},
    }

    self.db = GUILDBOOK_GLOBAL;

    addon.guilds = {}
    addon.characters = {}

    addon:TriggerEvent("StatusText_OnChanged", "[Database:Reset]")
    addon:TriggerEvent("Database_OnInitialised")
end

function Database:ImportData(data)
    local import = json.decode(data)
    if import then
        if import.name and import.data and import.version then
            DevTools_Dump(import)
        end
    end
end

function Database:InsertCharacter(character)
    if self.db then
        self.db.characterDirectory[character.name] = character;
        addon:TriggerEvent("StatusText_OnChanged", string.format("[InsertCharacter] %s", character.name))
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