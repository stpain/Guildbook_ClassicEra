

local name, addon = ...;

local AceComm = LibStub:GetLibrary("AceComm-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerialize = LibStub:GetLibrary("LibSerialize")

local Comms = {};
Comms.prefix = "GuildbookEra";
Comms.version = 0;

function Comms:Init()
    
    AceComm:Embed(self);
    self:RegisterComm(self.prefix);

    self.version = tonumber(GetAddOnMetadata(name, "Version"));

    addon:TriggerEvent("StatusText_OnChanged", "[Comms:Init]")
end


function Comms:TransmitToTarget(data, target)

    -- add the version number
    data.version = self.version;

    local serialized = LibSerialize:Serialize(data);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    if encoded and target then
        self:SendCommMessage(self.prefix, encoded, "WHISPER", target, "NORMAL")
    end
    
end

function Comms:TransmitToGuild(data)

    -- add the version number
    data.version = self.version;

    local serialized = LibSerialize:Serialize(data);
    local compressed = LibDeflate:CompressDeflate(serialized);
    local encoded    = LibDeflate:EncodeForWoWAddonChannel(compressed);

    if encoded then
        self:SendCommMessage(self.prefix, encoded, "GUILD", nil, "NORMAL")
    end
    
end

function Comms:OnCommReceived(prefix, message, distribution, sender)

    if prefix ~= self.prefix then 
        return 
    end
    local decoded = LibDeflate:DecodeForWoWAddonChannel(message);
    if not decoded then
        return;
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded);
    if not decompressed then
        return;
    end
    local success, data = LibSerialize:Deserialize(decompressed);
    if not success or type(data) ~= "table" then
        return;
    end

    addon:TriggerEvent("Comms_OnMessageReceived", sender, data)

end

addon:RegisterCallback("Database_OnInitialised", Comms.Init, Comms)

addon.Comms = Comms;