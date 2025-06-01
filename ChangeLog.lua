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
        version = "4.61",
        notes = "Calendar!\n\nAdded raid reset data to the calendar.\nThis is currently only for EU non-sod servers but I will be adding the remaining data soon.\n\nSome minor bug fixes.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.6",
        notes = "Talent changes! Guildbook now converts talent data into a string (similar to wowhead) this is instead of a large table. The purpose of this was to reduce demand on the comms messages and reduce the size of the saved variables file.",
        icon = "adventureguide-icon-whatsnew",
    },
    {
        version = "4.52",
        notes = "Fixed several minor bugs.\n\nDruid now shown in class list for roster.\nEnchant recipe names shown instead of broken link.\nRecipe URL updated to classic version of wowhead.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.51",
        notes = "Some minor fixes.\n\nAdded the date joined to the roster view. You can also set a members join date from the 'Guild Management' section, the red button at the bottom will open a popout date picker.\nYou can also now filter for character names in the member list.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.5",
        notes = "Working on the Calendar.\n\nAdded rank filter to the guild roster.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.42",
        notes = "Minor update to the guild bank view, item class categories are now collapsible and items show a tooltip properly.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.41",
        notes = "Due to the copy/pasta from cata code the guild bank feature had been disabled.\n\nThis is now enabled and should be working, please report any issues with it (its been a while)",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.3",
        notes = "Updated for Anniversary servers.\n\nAdded dual spec system.\n\nAdded ability to remove old guild data (in settings).\n\nFixed bug with context menus.",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.21",
        notes = "Removed print statements",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
    {
        version = "4.2",
        notes = "Fixed issue with enchanter spells for tradeskills.\n\nBug fix for chat history\n\nFixed issue with Attune tooltip not showing on roster view",
        icon = "ClassHall-QuestIcon-Desaturated",
    },
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