local name, addon = ...;


Mixin(addon, CallbackRegistryMixin)
addon:GenerateCallbackEvents({
    "Database_OnInitialised",
    "Database_OnCharacterAdded",

    "Character_OnProfileSelected",
    "Character_OnDataChanged",
    "Character_OnTradeskillSelected",
    "Character_BroadcastChange",

    "Guildbank_TimeStampRequest",
    "Guildbank_OnTimestampsReceived",
    "Guildbank_DataRequest",
    "Guildbank_OnDataReceived",
    "Guildbank_StatusInfo",
    
    "Blizzard_OnTradeskillUpdate",
    "Blizzard_OnGuildRosterUpdate",

    "UI_OnSizeChanged",

    "Chat_OnMessageReceived",

    "StatusText_OnChanged",
    "LogDebugMessage",
    
    "Comms_OnMessageReceived",

    "Guildbook_OnSearch",
})
CallbackRegistryMixin.OnLoad(addon);