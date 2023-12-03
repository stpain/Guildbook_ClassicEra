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