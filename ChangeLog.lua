local name, addon = ...;


--[[
{
    version = "",
    notes = "",
},
]]


--[[

    todo:
        minimap button options
        home view
        lockout/events view
        tradeskill scan link
]]


addon.changeLog = {
    {
        version = "4.11",
        notes = "Minor fixes for patch 1.15.5",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.1",
        notes = "Minor fixes where some variables changed between current classic (Cata) and Classic Era/Fresh.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.0",
        notes = "Updated to use the Classic Cata version.\nUpdated and removed Cata data, this version should contain only era data (or fresh if you prefer).",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.4",
        notes = "Added SoD items - needs a filter for Era realms.\n\nFixed bug with selecting an alt in the settings panel.\n\nStarted work on addding calendar functions.\n\nStarted work on guild management systems.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.32",
        notes = "Started work on Calendar events.\n\nFixed bug with comms.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.31",
        notes = "Enchanting recipes should now show in tooltips when you mouse over a reagent.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.3",
        notes = "Tradeskill tooltip updates, now show recipe skill level changes (orange/yellow/green etc).\n\nAdded soem German translations.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.2",
        notes = "Quest log fix.\n\nFound bug with bag and bank scanning all going into bags not bags and bank.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.1",
        notes = "Fixed spacing issue with default blizz roster mod.\n\nChanged profession columns on default roster mod into clickable links.\n\nRemoved print call.\n\nStarted work on adding a 'list' feature, this will allow you to track items, for example posted in chat messages (I have poor memory for these things!).",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "3.0",
        notes = "Added Runes to character equipment list. The rune icon will show on the left and the name in the tooltip (currently fixed as english).\n\nStarted to added roster functionality, can now set public notes via a right click.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "2.32",
        notes = "Version error fix.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "2.31",
        notes = "Quick bug fix for the roster view.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "2.3",
        notes = "Working on alts being available when not in a guild (new characters etc).\n\nChanged the bank item header colour.\n\nFixed issue with database version checks.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "2.2",
        notes = "Guildbank fixes.\n\nAdded headers to guildbank listview of items.\n\nAdded guildbank rules sync button.\n\nStarted work on news feature.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "2.1",
        notes = "Updated toc number.\n\nClassic Era has been updated with the current Wrath version which has more fixes and features. This version was tested and minor changes made due to the differences with the game features and the Blizzard API.\n\nIf you experience issues try resetting the addon (Settings > Addon > Reset) if that doesn't help try the discord, link below reset button.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
}