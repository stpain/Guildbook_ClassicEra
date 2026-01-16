

local _, Guildbook = ...;

Guildbook.Constants = {
    SpellSchools = {
        [2] = 'Holy',
        [3] = 'Fire',
        [4] = 'Nature',
        [5] = 'Frost',
        [6] = 'Shadow',
        [7] = 'Arcane',
    },
    StatIDs = {
        [1] = 'Strength',
        [2] = 'Agility',
        [3] = 'Stamina',
        [4] = 'Intellect',
        [5] = 'Spirit',
    },
    ResistanceIDs = {
        [0] = "physical",
        [1] = "holy",
        [2] = "fire",
        [3] = "nature",
        [4] = "frost",
        [5] = "shadow",
        [6] = "arcane",
    },
    SocketFileIDs = {
        EMPTY_SOCKET_BLUE = 136256,
        EMPTY_SOCKET_META = 136257,
        EMPTY_SOCKET_RED = 136258,
        EMPTY_SOCKET_YELLOW = 136259,
        EMPTY_SOCKET_PRISMATIC = 458977,
    },
    SocketOrder = {
        [1] = "EMPTY_SOCKET_META",
        [2] = "EMPTY_SOCKET_RED",
        [3] = "EMPTY_SOCKET_YELLOW",
        [4] = "EMPTY_SOCKET_BLUE",
        [5] = "EMPTY_SOCKET_PRISMATIC",
    },
    InventorySlots = {
        {
            slot = "HEADSLOT",
            icon = 136516,
        },
        {
            slot = "NECKSLOT",
            icon = 136519,
        },
        {
            slot = "SHOULDERSLOT",
            icon = 136526,
        },
        {
            slot = "BACKSLOT",
            icon = 136521,
        },
        {
            slot = "SHIRTSLOT",
            icon = 136525,
        },
        {
            slot = "CHESTSLOT",
            icon = 136512,
        },
        {
            slot = "WAISTSLOT",
            icon = 136529,
        },
        {
            slot = "LEGSSLOT",
            icon = 136517,
        },
        {
            slot = "FEETSLOT",
            icon = 136513,
        },
        {
            slot = "WRISTSLOT",
            icon = 136530,
        },
        {
            slot = "HANDSSLOT",
            icon = 136515,
        },
        {
            slot = "FINGER0SLOT",
            icon = 136514,
        },
        {
            slot = "FINGER1SLOT",
            icon = 136523,
        },
        {
            slot = "TRINKET0SLOT",
            icon = 136528,
        },
        {
            slot = "TRINKET1SLOT",
            icon = 136528,
        },
        {
            slot = "MAINHANDSLOT",
            icon = 136518,
        },
        {
            slot = "SECONDARYHANDSLOT",
            icon = 136524,
        },
        {
            slot = "RANGEDSLOT",
            icon = 136520,
        },
        {
            slot = "TABARDSLOT",
            icon = 136527,
        },
        -- {
        --     slot = "RELICSLOT",
        --     icon = 136522,
        -- },
    },
}


Guildbook.Layouts = {
    GenericMetal = {
		TopLeftCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = -6, y = 6, mirrorLayout = true, },
		TopRightCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = 6, y = 6, mirrorLayout = true, },
		BottomLeftCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = -6, y = -6, mirrorLayout = true, },
		BottomRightCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = 6, y = -6, mirrorLayout = true, },
		TopEdge = { atlas = "_UI-Frame-GenericMetal-EdgeTop", },
		BottomEdge = { atlas = "_UI-Frame-GenericMetal-EdgeBottom", },
		LeftEdge = { atlas = "!UI-Frame-GenericMetal-EdgeLeft", },
		RightEdge = { atlas = "!UI-Frame-GenericMetal-EdgeRight", },
	},
    DarkTooltip = {
        TopLeftCorner =	{ atlas = "ChatBubble-NineSlice-CornerTopLeft", x = -2, y = 2, },
        TopRightCorner =	{ atlas = "ChatBubble-NineSlice-CornerTopRight", x = 2, y = 2, },
        BottomLeftCorner =	{ atlas = "ChatBubble-NineSlice-CornerBottomLeft", x = -2, y = -2, },
        BottomRightCorner =	{ atlas = "ChatBubble-NineSlice-CornerBottomRight", x = 2, y = -2, },
        TopEdge = { atlas = "_ChatBubble-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_ChatBubble-NineSlice-EdgeBottom"},
        LeftEdge = { atlas = "!ChatBubble-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!ChatBubble-NineSlice-EdgeRight", },
        Center = { atlas = "ChatBubble-NineSlice-Center", },
	},
    ParentBorder = {
        TopLeftCorner =	{ atlas = "Tooltip-NineSlice-CornerTopLeft", x=-3, y=3 },
        TopRightCorner =	{ atlas = "Tooltip-NineSlice-CornerTopRight", x=3, y=3 },
        BottomLeftCorner =	{ atlas = "Tooltip-NineSlice-CornerBottomLeft", x=-3, y=-3 },
        BottomRightCorner =	{ atlas = "Tooltip-NineSlice-CornerBottomRight", x=3, y=-3 },
        TopEdge = { atlas = "_Tooltip-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_Tooltip-NineSlice-EdgeBottom", },
        LeftEdge = { atlas = "!Tooltip-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!Tooltip-NineSlice-EdgeRight", },
    },
    ListviewMetal = {
        TopLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopLeft", x=-15, y=15 },
        TopRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopRight", x=15, y=15 },
        BottomLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomLeft", x=-15, y=-15 },
        BottomRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomRight", x=15, y=-15 },
        TopEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeBottom", },
        LeftEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeRight", },
        Center = { layer = "BACKGROUND", atlas = "ClassHall_InfoBoxMission-BackgroundTile", x = -20, y = 20, x1 = 20, y1 = -20 },
    },
	Flyout = {
		TopLeftCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerTopLeft", x = -36, y = 20, },
		TopRightCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerTopRight", x = 36, y = 20, },
		BottomLeftCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerBottomLeft", x = -36, y = -40, },
		BottomRightCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerBottomRight", x = 36, y = -40, },
		TopEdge = { atlas = "_CharacterCreateDropdown-NineSlice-EdgeTop", },
		BottomEdge = { atlas = "_CharacterCreateDropdown-NineSlice-EdgeBottom", },
		LeftEdge = { atlas = "!CharacterCreateDropdown-NineSlice-EdgeLeft", },
		RightEdge = { atlas = "!CharacterCreateDropdown-NineSlice-EdgeRight", },
		Center = { atlas = "CharacterCreateDropdown-NineSlice-Center", },
	},
}

