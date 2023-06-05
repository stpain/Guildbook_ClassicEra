local name, addon = ...;


Mixin(addon, CallbackRegistryMixin)
addon:GenerateCallbackEvents({
    "Database_OnInitialised",
    "Database_OnCharacterAdded",

    "Character_OnProfileSelected",
    "Character_OnDataChanged",
    "Character_OnTradeskillSelected",
    
    "Blizzard_OnTradeskillUpdate",
    "Blizzard_OnGuildRosterUpdate",

    "UI_OnSizeChanged",

    "StatusText_OnChanged",
})
CallbackRegistryMixin.OnLoad(addon);