local addonName, addon = ...;

addon.Layouts = {
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

local libGlow = LibStub("LibCustomGlow-1.0")

local Database = addon.Database;
local Character = addon.Character;
local Talents = addon.Talents;
local Tradeskills = addon.Tradeskills;

addon.characterDefaults = {
    guid = "",
    name = "",
    class = 3,
    gender = 1,
    level = 1,
    race = false,
    rank = 1,
    onlineStatus = {
        isOnline = false,
        zone = "",
    },
    alts = {},
    mainCharacter = false,
    publicNote = "",
    mainSpec = false,
    offSpec = false,
    mainSpecIsPvP = false,
    offSpecIsPvP = false,
    profile = {},
    profession1 = "-",
    profession1Level = 0,
    profession1Spec = false,
    profession1Recipes = {},
    profession2 = "-",
    profession2Level = 0,
    profession2Spec = false,
    profession2Recipes = {},
    cookingLevel = 0,
    cookingRecipes = {},
    fishingLevel = 0,
    firstAidLevel = 0,
    firstAidRecipes = {},
    talents = {},
    glyphs = {},
    inventory = {
        current = {},
    },
    paperDollStats = {
        current = {},
    },
    resistances = {
        current = {},
    },
    auras = {
        current = {},
    },
    containers = {},
    lockouts = {},
}

addon.contextMenuSeparator = {
    hasArrow = false;
    dist = 0;
    text = "",
    isTitle = true;
    isUninteractable = true;
    notCheckable = true;
    iconOnly = true;
    icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
    tCoordLeft = 0;
    tCoordRight = 1;
    tCoordTop = 0;
    tCoordBottom = 1;
    tSizeX = 0;
    tSizeY = 8;
    tFitDropDownSizeX = true;
    iconInfo = {
        tCoordLeft = 0,
        tCoordRight = 1,
        tCoordTop = 0,
        tCoordBottom = 1,
        tSizeX = 0,
        tSizeY = 8,
        tFitDropDownSizeX = true
    }}

--create these at addon level
addon.thisCharacter = "";
addon.thisGuild = false;
addon.guilds = {}
addon.characters = {}
addon.contextMenu = CreateFrame("Frame", "GuildbookContextMenu", UIParent, "UIDropDownMenuTemplate")

addon.recruitment = {
    statusIDs = {
        [0] = "Imported",
        [1] = "Invite sent",
        [2] = "Invite responded",
        [3] = "",
        [4] = "",
    }
}

addon.api = {
    classic = {},
    wrath = {},
    cata = {},
}


function addon.api.easyMenu(parent, menu)
    if MenuUtil then
        MenuUtil.CreateContextMenu(parent, function(parent, rootDescription)

            for _, element in ipairs(menu) do

                local menuButton;

                if element.isTitle then
                    menuButton = rootDescription:CreateTitle(element.text)
    
                elseif element.isSeparater then
                    menuButton = rootDescription:CreateSpacer()
    
                elseif element.isDivider then
                    menuButton = rootDescription:CreateDivider()
    
                else
                    menuButton = rootDescription:CreateButton(element.text, function() if element.func then element.func() end end)
                end

                if element.menuList then
                    for _, subElement in ipairs(element.menuList) do
                        menuButton:CreateButton(subElement.text, function() if subElement.func then subElement.func() end end)
                    end
                end


            end
        end)
    end
end

--[[

EasyMenu was used in many places, for now  just hack it back into the global space and pass through to the new Menu stuff

old signature

EasyMenu(menu, addon.contextMenu, "cursor", 0, 0, "MENU", 0.6)
]]
function EasyMenu(menuTable, menuFrame)
    addon.api.easyMenu(menuFrame, menuTable)
end

local debugTypeIcons = {
    warning = "services-icon-warning",
    info = "glueannouncementpopup-icon-info",
    comms = "chatframe-button-icon-voicechat",
    comms_in = "voicechat-channellist-icon-headphone-on",
    comms_out = "voicechat-icon-textchat-silenced",
    bank = "ShipMissionIcon-Treasure-Mission",
    tradeskills = "Mobile-Alchemy",
}

local debugTypeIDs = {
    warning = 1,
    info = 2,
    comms = 3,
    comms_in = 4,
    comms_out = 5,
    bank = 6,
    tradeskills = 7,
    character = 8,
}

addon.paperDollSlotNames = {    
    ["CharacterHeadSlot"] = { allignment = "right", slotID = 1, },
    ["CharacterNeckSlot"] = { allignment = "right", slotID = 2, },
    ["CharacterShoulderSlot"] = { allignment = "right", slotID = 3, },
    ["CharacterBackSlot"] = { allignment = "right", slotID = 15, },
    ["CharacterChestSlot"] = { allignment = "right", slotID = 5, },
    --["CharacterShirtSlot"] = { allignment = "right", slotID = 4, },
    --["CharacterTabardSlot"] = { allignment = "right", slotID = 19, },
    ["CharacterWristSlot"] = { allignment = "right", slotID = 9, },

    ["CharacterHandsSlot"] = { allignment = "left", slotID = 10, },
    ["CharacterWaistSlot"] = { allignment = "left", slotID = 6, },
    ["CharacterLegsSlot"] = { allignment = "left", slotID = 7, },
    ["CharacterFeetSlot"] = { allignment = "left", slotID = 8, },
    ["CharacterFinger0Slot"] = { allignment = "left", slotID = 11, },
    ["CharacterFinger1Slot"] = { allignment = "left", slotID = 12, },
    ["CharacterTrinket0Slot"] = { allignment = "left", slotID = 13, },
    ["CharacterTrinket1Slot"] = { allignment = "left", slotID = 14, },

    ["CharacterMainHandSlot"] = { allignment = "top", slotID = 16, },
    ["CharacterSecondaryHandSlot"] = { allignment = "top", slotID = 17, },
    ["CharacterRangedSlot"] = { allignment = "top", slotID = 18, },
}

local ignoreEnchantSlotIDs = {
    [true] = {
        [2] = true,
        [6] = true,
        [13] = true,
        [14] = true,
    },
    [false] = {
        [2] = true,
        [6] = true,
        [11] = true,
        [12] = true,
        [13] = true,
        [14] = true,
    },
}

addon.itemQualityAtlas_Overlay = {
    [2] = "bags-glow-green",
    [3] = "bags-glow-blue",
    [4] = "bags-glow-purple",
    [5] = "bags-glow-orange",

    -- [2] = "loottab-set-itemborder-green",
    -- [3] = "loottab-set-itemborder-blue",
    -- [4] = "loottab-set-itemborder-purple",
    -- [5] = "loottab-set-itemborder-orange",
}

addon.itemQualityAtlas_Borders = {
    [2] = "loottab-set-itemborder-green",
    [3] = "loottab-set-itemborder-blue",
    [4] = "loottab-set-itemborder-purple",
    [5] = "loottab-set-itemborder-orange",

    ["ff1eff00"] = "loottoast-itemborder-green",
    ["ff0070dd"] = "loottoast-itemborder-blue",
    ["ffa335ee"] = "loottoast-itemborder-purple",
    ["ffff8000"] = "loottoast-itemborder-orange",
}

local breakLink = function(link)
    return string.match(link, [[|H([^:]*):([^|]*)|h(.*)|h]])
end

--local socketAtlas = "auctionhouse-icon-socket";
local socketFileIDs = {
    EMPTY_SOCKET_BLUE = 136256,
    EMPTY_SOCKET_META = 136257,
    EMPTY_SOCKET_RED = 136258,
    EMPTY_SOCKET_YELLOW = 136259,
    EMPTY_SOCKET_PRISMATIC = 458977,
}
local socketOrder = {
    [1] = "EMPTY_SOCKET_META",
    [2] = "EMPTY_SOCKET_RED",
    [3] = "EMPTY_SOCKET_YELLOW",
    [4] = "EMPTY_SOCKET_BLUE",
    [5] = "EMPTY_SOCKET_PRISMATIC",
}
local socketIconSize = 14;
local paperdollOverlays = {}

local function ScanTooltip(link, unit, slot)

    local t = {}

    GuildbookScanningTooltip:ClearLines()

    if link then
        GuildbookScanningTooltip:SetHyperlink(link)
        
    elseif unit and slot then
        GuildbookScanningTooltip:SetInventoryItem(unit, slot)
    end

    local regions = {GuildbookScanningTooltip:GetRegions()}
    for k, region in ipairs(regions) do
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText()
            if type(text) == "string" then
                table.insert(t, text)
                -- local number = tonumber(text:match("%-?%d+"))
                -- if number then
                --     table.insert(t, {
                --         attribute = text:gsub("%-?%d+", "%%d"),
                --         value = number,
                --         displayText = text,
                --     })
                -- else
                --     for k, socket in ipairs(sockets) do
                --         if text == _G[socket] then
                --             table.insert(t, {
                --                 attribute = text:gsub("%-?%d+", "%%d"),
                --                 value = number or 1,
                --                 displayText = text,
                --             })
                --         end
                --     end
                -- end
            end
        end
    end
    return t;
end

local function GetItemSocketInfo(link)
    
    local x, payload = breakLink(link)

    local itemID, enchantID, gem1, gem2, gem3 = strsplit(":", payload)

    if itemID == "57268" then

        -- DevTools_Dump({strsplit(":", payload)})

        -- local stats = GetItemStats(link)
        -- for k, v in pairs(stats) do
        --     print(k, v)
        -- end

        -- local name, id = C_Item.GetItemSpell(link)
        -- print(name, id)

        -- local lines = ScanTooltip(link)
        -- DevTools_Dump(lines)
    end

    enchantID = tonumber(enchantID)
    gem1 = tonumber(gem1)
    gem2 = tonumber(gem2)
    gem3 = tonumber(gem3)

    local gems = { gem1, gem2, gem3, }

    local ret = {
        numSockets = 0,
        numEmptySockets = 0,
        actualSocketString = "",
        missingSocketsString = "",
    }

    local sockets = {}
    local itemSocketsOrderd = {}

    local stats = GetItemStats(link) or {}
    --DevTools_Dump(stats)
    for k, v in pairs(stats) do
        if k:find("SOCKET", nil, true) then
            if not sockets[k] then
                sockets[k] = 1;
            else
                sockets[k] = sockets[k] + 1;
            end
            ret.numSockets = ret.numSockets + 1;
        end
    end

    if ret.numSockets > 0 then

        for k, socketType in ipairs(socketOrder) do
            if type(sockets[socketType]) == "number" and (sockets[socketType] > 0) then
                for i = 1, sockets[socketType] do
                    table.insert(itemSocketsOrderd, socketFileIDs[socketType])
                end
            end
        end

        -- print(link)
        -- DevTools_Dump(sockets)
        -- DevTools_Dump(itemSocketsOrderd)
        
        for i = 1, 3 do

            if type(gems[i]) == "number" then
                
                ret.actualSocketString = string.format("%s %s", ret.actualSocketString, CreateSimpleTextureMarkup(select(5, GetItemInfoInstant(gems[i])), socketIconSize, socketIconSize, 0, 0))
            
            elseif type(itemSocketsOrderd[i]) == "number" then
                
                ret.actualSocketString = string.format("%s %s", ret.actualSocketString, CreateSimpleTextureMarkup(itemSocketsOrderd[i], socketIconSize+2, socketIconSize+2, 0, 0))
                ret.missingSocketsString = string.format("%s %s", ret.missingSocketsString, CreateSimpleTextureMarkup(itemSocketsOrderd[i], socketIconSize+2, socketIconSize+2, 0, 0))
                
                ret.numEmptySockets = ret.numEmptySockets + 1;
            
            end
        end
    end

    return ret;
end


function addon.api.updatePaperdollOverlays()

    if Database:GetConfig("enhancedPaperDoll") == false then
        addon.api.hidePaperdollOverlays()
        return
    end

    local minItemLevel, maxItemLevel = 0, 0;
    local prof1Id, prof2Id;
    local prof1, prof2 = GetProfessions()
    if prof1 then
        prof1Id = select(7, GetProfessionInfo(prof1))
    end
    if prof2 then
        prof2Id = select(7, GetProfessionInfo(prof2))
    end

    local isEnchanter = (prof1Id == 333 or prof2Id == 333) and true or false;

    --print(isEnchanter)

    for frame, info in pairs(addon.paperDollSlotNames) do
        if not paperdollOverlays[frame] then

            local qualityOverlay = _G[frame]:CreateTexture(nil, "BORDER", nil, 6)
            qualityOverlay:SetAllPoints()
            qualityOverlay:SetAlpha(0.7)

            -- local enchantBorder = _G[frame]:CreateTexture(nil, "BORDER", nil, 7)
            -- enchantBorder:SetAtlas("Forge-ColorSwatchSelection")
            -- --enchantBorder:SetTexture(130744)
            -- enchantBorder:SetPoint("TOPLEFT", -2, 1)
            -- enchantBorder:SetPoint("BOTTOMRIGHT", 1, -2)
            -- enchantBorder:SetAlpha(0.9)
            -- _G[frame].enchantBorder = enchantBorder;

            -- local enchantedAnimation = _G[frame]:CreateAnimationGroup()
            -- enchantedAnimation:SetLooping("BOUNCE")
            -- local fadeIn = enchantedAnimation:CreateAnimation("Alpha")
            -- fadeIn:SetChildKey("enchantBorder")
            -- fadeIn:SetDuration(0.5)
            -- fadeIn:SetFromAlpha(0)
            -- fadeIn:SetToAlpha(1)

            local itemLevelLabel = _G[frame]:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            local empySocketLabel = _G[frame]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            if info.allignment == "right" then
                --itemLevelLabel:SetPoint("TOPLEFT", _G[frame], "TOPRIGHT", 10, -8)
                itemLevelLabel:SetPoint("BOTTOMRIGHT", -3, 3)
                empySocketLabel:SetPoint("BOTTOMLEFT", _G[frame], "BOTTOMRIGHT", 8, 2)
            elseif info.allignment == "left" then
                --itemLevelLabel:SetPoint("TOPRIGHT", _G[frame], "TOPLEFT", -10, -8)
                itemLevelLabel:SetPoint("BOTTOMLEFT", 3, 3)
                empySocketLabel:SetPoint("BOTTOMRIGHT", _G[frame], "BOTTOMLEFT", -12, 2)
            else
                --itemLevelLabel:SetPoint("BOTTOM", _G[frame], "TOP", 0, 22)
                itemLevelLabel:SetPoint("BOTTOM", 0, 3)
                empySocketLabel:SetPoint("BOTTOM", _G[frame], "TOP", 0, 6)
            end

            paperdollOverlays[frame] = {
                qualityOverlay = qualityOverlay,
                itemLevelLabel = itemLevelLabel,
                empySocketLabel = empySocketLabel,
                --enchantBorder = enchantBorder,
                --borderAnimation = enchantedAnimation,
            }

        end

        local link = GetInventoryItemLink("player", info.slotID)
        if link then

            local x, payload = breakLink(link)

            local itemID, enchantID, gem1, gem2, gem3 = strsplit(":", payload)

            local shouldHaveEnchant

            if ignoreEnchantSlotIDs[isEnchanter][info.slotID] then
                --print("ignore slot")
                shouldHaveEnchant = false
            else
                enchantID = tonumber(enchantID)
                shouldHaveEnchant = true
                --print("converted to number")
            end

            if info.slotID == 18 then
                local _, _, classID = UnitClass("player")
                if (classID == 2) or (classID == 5) or (classID == 7) or (classID == 8) or (classID == 9) or (classID == 11) then
                    shouldHaveEnchant = false;
                end
            end


            --print(info.slotID, type(enchantID))

            local socketInfo = GetItemSocketInfo(link)

            local _, _, quality, itemLevel = GetItemInfo(link)

            if type(itemLevel) == "number" then

                if minItemLevel == 0 then
                    minItemLevel = itemLevel
                else
                    if itemLevel < minItemLevel then
                        minItemLevel = itemLevel
                    end
                end
                if maxItemLevel == 0 then
                    maxItemLevel = itemLevel
                else
                    if itemLevel > maxItemLevel then
                        maxItemLevel = itemLevel
                    end
                end
            end

            paperdollOverlays[frame].itemLevel = itemLevel;
            paperdollOverlays[frame].itemQuality = quality;
            paperdollOverlays[frame].socketString = socketInfo and socketInfo.missingSocketsString or "";
            if type(enchantID) == "number" then
                paperdollOverlays[frame].enchanted = true
            else
                if shouldHaveEnchant then
                    paperdollOverlays[frame].enchanted = false
                end
            end

        else
            paperdollOverlays[frame].itemLevel = false;
            paperdollOverlays[frame].itemQuality = false;
            paperdollOverlays[frame].socketString = false;
            paperdollOverlays[frame].enchanted = false;
        end
    end

    local itemLevelGap = maxItemLevel - minItemLevel;

    for f, info in pairs(paperdollOverlays) do

        info.itemLevelLabel:Hide()
        info.qualityOverlay:Hide()
        info.empySocketLabel:Hide()
        -- info.enchantBorder:Hide()
        -- info.borderAnimation:Stop()
        libGlow.PixelGlow_Stop(_G[f])

        if (type(info.itemLevel) == "number") and (info.enchanted == false) then
        --     info.enchantBorder:Show()
        --     info.borderAnimation:Play()

        libGlow.PixelGlow_Start(_G[f])
        --libGlow.AutoCastGlow_Start(_G[f])
        --libGlow.ButtonGlow_Start(_G[f])
        end

        if type(info.socketString) == "string" then
            info.empySocketLabel:SetText(info.socketString)
            info.empySocketLabel:Show()
        end

        if type(info.itemLevel) == "number" then
            local r, g, b = addon.api.getcolourGradientFromPercent(((info.itemLevel - minItemLevel) / itemLevelGap) * 100)
            info.itemLevelLabel:SetText(info.itemLevel)
            info.itemLevelLabel:SetTextColor(r,g,b,1)
            info.itemLevelLabel:Show()
        end

        if type(info.itemQuality) == "number" and info.itemQuality > 1 then
            info.qualityOverlay:SetAtlas(addon.itemQualityAtlas_Overlay[info.itemQuality])
            info.qualityOverlay:Show()
        end
    end

end

function addon.api.hidePaperdollOverlays()
    for f, info in pairs(paperdollOverlays) do
        info.itemLevelLabel:Hide()
        info.qualityOverlay:Hide()
        info.empySocketLabel:Hide()
        -- info.enchantBorder:Hide()
        -- info.borderAnimation:Stop()

        libGlow.PixelGlow_Stop(_G[f])
        --libGlow.AutoCastGlow_Stop(_G[f])
        --libGlow.ButtonGlow_Stop(_G[f])
    end
end

function addon.api.getNineSliceTooltipBorder(borderOffset)
    return {
        ["TopRightCorner"] = { atlas = "Tooltip-NineSlice-CornerTopRight", x = borderOffset, y = borderOffset },
        ["TopLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerTopLeft", x = -borderOffset, y = borderOffset },
        ["BottomLeftCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomLeft", x = -borderOffset, y = -borderOffset },
        ["BottomRightCorner"] = { atlas = "Tooltip-NineSlice-CornerBottomRight", x = borderOffset, y = -borderOffset },
        ["TopEdge"] = { atlas = "_Tooltip-NineSlice-EdgeTop" },
        ["BottomEdge"] = { atlas = "_Tooltip-NineSlice-EdgeBottom" },
        ["LeftEdge"] = { atlas = "!Tooltip-NineSlice-EdgeLeft" },
        ["RightEdge"] = { atlas = "!Tooltip-NineSlice-EdgeRight" },
        ["Center"] = { layer = "BACKGROUND", atlas = "Tooltip-Glues-NineSlice-Center", x = -4, y = 4, x1 = 4, y1 = -4 },
    }
end

function addon.api.getcolourGradientFromPercent(percent, reverse)

    if reverse then
        local g = (percent > 50 and 1 - 2 * (percent - 50) / 100.0 or 1.0);
        local r = (percent > 50 and 1.0 or 2 * percent / 100.0);
        local b = 0.0;
    
        return r, g, b;
    else
        local r = (percent > 50 and 1 - 2 * (percent - 50) / 100.0 or 1.0);
        local g = (percent > 50 and 1.0 or 2 * percent / 100.0);
        local b = 0.0;
    
        return r, g, b;
    end
end

function addon.LogDebugMessage(debugType, debugMessage, debugTooltip)

    if not addon.debugMessages then
        addon.debugMessages = {}
    end

    if GuildbookUI and Database.db.debug then
        if debugTooltip then
            table.insert(addon.debugMessages, {
                debugTypeID = debugTypeIDs[debugType] or 1,
                label = string.format("[%s] %s", date("%T"), debugMessage),
                atlas = debugTypeIcons[debugType],
                onMouseEnter = function()
                    GameTooltip:SetOwner(GuildbookUI, "ANCHOR_TOPLEFT")
                    GameTooltip:AddDoubleLine("Version", debugTooltip.version)
                    -- for k, v in ipairs(debugTooltip.payload) do
                    --     GameTooltip:AddDoubleLine(k, v)
                    -- end
                    for k, v in pairs(debugTooltip.payload) do
                        GameTooltip:AddDoubleLine(k, v)
                    end
                    if type(debugTooltip.payload.data) == "table" then
                        -- for k, v in ipairs(debugTooltip.payload.data) do
                        --     GameTooltip:AddDoubleLine(k, v)
                        -- end
                        for k, v in pairs(debugTooltip.payload.data) do
                            GameTooltip:AddDoubleLine(k, v)
                        end
                    end
                    GameTooltip:Show()
                end,
                onMouseDown = function()
                    DevTools_Dump(debugTooltip)
                end,
            })
        else
            table.insert(addon.debugMessages, {
                debugTypeID = debugTypeIDs[debugType] or 1,
                label = string.format("[%s] %s", date("%T"), debugMessage),
                atlas = debugTypeIcons[debugType],
            })
        end

        addon:TriggerEvent("LogDebugMessage")
    end
end

function addon.api.getTradeskillItemDataFromID(itemID)
    for k, v in ipairs(addon.itemData) do
        if v.itemID == itemID then
            return v;
        end
    end
    return false;
end

function addon.api.getTradeskillItemsUsingReagentItemID(itemID, prof1, prof2)
    local t = {}
    for k, v in ipairs(addon.itemData) do
        for id, count in pairs(v.reagents) do
            if id == itemID then
                if prof1 == nil and prof2 == nil then
                    if not t[v.tradeskillID] then
                        t[v.tradeskillID] = {}
                    end
                    table.insert(t[v.tradeskillID], v)
                else
                    if prof1 and (v.tradeskillID == prof1) then
                        if not t[v.tradeskillID] then
                            t[v.tradeskillID] = {}
                        end
                        table.insert(t[v.tradeskillID], v)
                    end
                    if prof2 and (v.tradeskillID == prof2) then
                        if not t[v.tradeskillID] then
                            t[v.tradeskillID] = {}
                        end
                        table.insert(t[v.tradeskillID], v)
                    end
                end
            end
        end
    end
    return t;
end

--taken from blizz to use for classic
function addon.api.extractLink(text)
    -- linkType: |H([^:]*): matches everything that's not a colon, up to the first colon.
    -- linkOptions: ([^|]*)|h matches everything that's not a |, up to the first |h.
    -- displayText: (.*)|h matches everything up to the second |h.
    -- Ex: |cffffffff|Htype:a:b:c:d|htext|h|r becomes type, a:b:c:d, text
    return string.match(text, [[|H([^:]*):([^|]*)|h(.*)|h]]);
end

function addon.api.makeTableUnique(t)
    
    local temp, ret = {}, {}
    for k, v in ipairs(t) do
        temp[v] = true
    end
    for k, v in pairs(temp) do
        table.insert(ret, k)
    end
    return ret;
end

function addon.api.trimTable(tab, num, reverse)

    if type(tab) == "table" then
        
        local t = {}
        if reverse then
            for i = #tab, (#tab - num), -1 do
                table.insert(t, tab[i])
            end

        else
            for i = 1, num do
                table.insert(t, tab[i])
            end
        end

        tab = nil;
        return t;
    end
end

function addon.api.trimNumber(num)
    if type(num) == 'number' then
        local trimmed = string.format("%.1f", num)
        return tonumber(trimmed)
    else
        return 1
    end
end

function addon.api.characterIsMine(name)
    if Database.db.myCharacters[name] ~= nil then
        return true;
    end
    return false;
end

function addon.api.getGuildRanks()
    local ranks = {}
    for i = 1, GuildControlGetNumRanks() do
        local rankName = GuildControlGetRankName(i)
        table.insert(ranks, {
            rankName = rankName,
            rankIndex = i-1,
        })
    end
    return ranks
end


function addon.api.scanForTradeskillSpec()
    local t = {}
    for i = 1, GetNumSpellTabs() do
        local offset, numSlots = select(3, GetSpellTabInfo(i))
        for j = offset+1, offset+numSlots do
            --local start, duration, enabled, modRate = GetSpellCooldown(j, BOOKTYPE_SPELL)
            --local spellLink, _ = GetSpellLink(j, BOOKTYPE_SPELL)
            local _, spellID = GetSpellBookItemInfo(j, BOOKTYPE_SPELL)
           
            if Tradeskills.SpecializationSpellsIDs[spellID] then
                table.insert(t, {
                    tradeskillID = Tradeskills.SpecializationSpellsIDs[spellID],
                    spellID = spellID,
                })
            end

        end
    end
    return t;
end


function addon.api.wrath.getPlayerEquipment()
    local sets = C_EquipmentSet.GetEquipmentSetIDs();

    local equipment = {
        sets = {},
        current = {},
    };

    for k, v in ipairs(sets) do
        
        local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(v)

        local setItemIDs = C_EquipmentSet.GetItemIDs(setID)

        equipment.sets[name] = setItemIDs;
    end


    --lets grab the current gear
    local t = {}
    for k, v in ipairs(addon.data.inventorySlots) do
        local link = GetInventoryItemLink('player', GetInventorySlotInfo(v.slot)) or false
        if link ~= nil then
            t[v.slot] = link;
        end
    end
    equipment.current = t;

    return equipment;
end

function addon.api.getPlayerEquipmentCurrent()
    local t = {}
    for k, v in ipairs(addon.data.inventorySlots) do
        local link = GetInventoryItemLink('player', GetInventorySlotInfo(v.slot)) or false
        if link ~= nil then
            t[v.slot] = link;
        end
    end

    return t;
end

function addon.api.getPlayerItemLevel()
    local itemLevel, itemCount = 0, 0
	for k, v in ipairs(addon.data.inventorySlots) do
		local link = GetInventoryItemLink('player', GetInventorySlotInfo(v.slot)) or false
		if link then
			local _, _, _, ilvl = GetItemInfo(link)
            if not ilvl then ilvl = 0 end
			itemLevel = itemLevel + ilvl
			itemCount = itemCount + 1
		end
    end
    -- due to an error with LibSerialize which is now fixed we make sure we return a number
    if math.floor(itemLevel/itemCount) > 0 then
        return addon.api.trimNumber(itemLevel/itemCount)
    else
        return 0
    end
end

function addon.api.getPlayerSkillLevels()
    local skills = {}
    for s = 1, GetNumSkillLines() do
        local skill, _, _, level, _, _, _, _, _, _, _, _, _ = GetSkillLineInfo(s)
        if skill and (type(level) == "number") then
            local tradeskillId = Tradeskills:GetTradeskillIDFromLocale(skill)
            if tradeskillId then
                skills[tradeskillId] = level
            end
        end
    end
    return skills;
end

function addon.api.cata.getProfessions()
    local t = {}
    for k, prof in pairs({GetProfessions()}) do
        if type(prof) == "number" then
            local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine = GetProfessionInfo(prof)
            if Tradeskills:IsTradeskill(nil, skillLine) then
                t[skillLine] = skillLevel;
            end
        end
    end
    --addon.LogDebugMessage("tradeskills", "function [addon.api.cata.getProfessions]", {version = -1, payload = t})
    return t;
end

function addon.api.isInGuild()
    if IsInGuild() and GetGuildInfo("player") then
        return true
    end
    return false
end

function addon.api.getGuildRosterIndex(nameOrGUID)
    if IsInGuild() and GetGuildInfo("player") then
        GuildRoster()
        local totalMembers, onlineMember, _ = GetNumGuildMembers()
        for i = 1, totalMembers do
            local name, rankName, rankIndex, level, _, zone, publicNote, officerNote, isOnline, status, class, _, _, _, _, _, guid = GetGuildRosterInfo(i)
            if nameOrGUID == name or nameOrGUID == guid then
                return i
            end
        end
    end
end

function addon.api.getPlayerAlts(main)
    if type(main) == "string" and main ~= "" then
        local alts = {}
        if addon.characters and addon.characters then
            for name, character in pairs(addon.characters) do
                if character.data.mainCharacter == main then
                    table.insert(alts, name)
                end
            end
        end
        return alts;
    end
    return {}
end

function addon.api.scanPlayerContainers(includeBanks)

    local copper = GetMoney()

    local containers = {
        bags = {
            slotsUsed = 0,
            slotsFree = 0,
            items = {},
        },
        bank = {
            slotsUsed = 0,
            slotsFree = 0,
            items = {},
        },
        copper = copper,
    }

    -- player bags
    for bag = 0, 4 do
        local numSlots;
        if C_Container then
            numSlots = C_Container.GetContainerNumSlots(bag);
        else
            numSlots = GetContainerNumSlots(bag);
        end
        local slotsUsed = 0;
        for slot = 1, numSlots do
            local itemID, stackCount;

            --make this work for both version although 1.14.4 is only maybe a few weeks away
            if C_Container then
                local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
                if containerInfo then
                    itemID = containerInfo.itemID;
                    stackCount = containerInfo.stackCount;
                end
            else
                local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bag, slot)
                itemID = id;
                stackCount = count;
            end

            if (type(itemID) == "number") and (type(stackCount) == "number") then
                table.insert(containers.bags.items, {
                    id = itemID,
                    count = stackCount,
                })
                slotsUsed = slotsUsed + 1;
            end
        end

        containers.bags.slotsUsed = containers.bags.slotsUsed + slotsUsed;
        containers.bags.slotsFree = containers.bags.slotsFree + (numSlots - slotsUsed);
    end

    if includeBanks then
        -- main bank
        local bankBagId = -1
        local numSlots;
        if C_Container then
            numSlots = C_Container.GetContainerNumSlots(bankBagId);
        else
            numSlots = GetContainerNumSlots(bankBagId);
        end
        local slotsUsed = 0;
        for slot = 1, numSlots do
            local itemID, stackCount;
            if C_Container then
                local containerInfo = C_Container.GetContainerItemInfo(bankBagId, slot)
                if containerInfo then
                    itemID = containerInfo.itemID;
                    stackCount = containerInfo.stackCount;
                end
            else
                local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bankBagId, slot)
                itemID = id;
                stackCount = count;
            end

            if (type(itemID) == "number") and (type(stackCount) == "number") then
                table.insert(containers.bags.items, {
                    id = itemID,
                    count = stackCount,
                })
                slotsUsed = slotsUsed + 1;
            end
        end
        containers.bank.slotsUsed = containers.bank.slotsUsed + slotsUsed;
        containers.bank.slotsFree = containers.bank.slotsFree + (numSlots - slotsUsed);

        -- bank bags
        for bag = 5, 11 do
            local numSlots;
            if C_Container then
                numSlots = C_Container.GetContainerNumSlots(bag);
            else
                numSlots = GetContainerNumSlots(bag);
            end
            local slotsUsed = 0;
            for slot = 1, numSlots do
                local itemID, stackCount;
                if C_Container then
                    local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
                    if containerInfo then
                        itemID = containerInfo.itemID;
                        stackCount = containerInfo.stackCount;
                    end
                else
                    local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bag, slot)
                    itemID = id;
                    stackCount = count;
                end
    
                if (type(itemID) == "number") and (type(stackCount) == "number") then
                    table.insert(containers.bags.items, {
                        id = itemID,
                        count = stackCount,
                    })
                    slotsUsed = slotsUsed + 1;
                end
            end

            containers.bank.slotsUsed = containers.bank.slotsUsed + slotsUsed;
            containers.bank.slotsFree = containers.bank.slotsFree + (numSlots - slotsUsed);
        end
    end

    return containers;
end

function addon.api.classic.getPlayerTalents()
    local talents = {}
    local tabs = {}
    for tabIndex = 1, GetNumTalentTabs() do
        --local spec, texture, pointsSpent, fileName = GetTalentTabInfo(tabIndex)
        local id, name, description, icon, pointsSpent, fileName, previewPointsSpent, isUnlocked  = GetTalentTabInfo(tabIndex)
        local engSpec = Talents.TalentBackgroundToSpec[fileName]
        table.insert(tabs, {
            fileName = fileName,
            pointsSpent = pointsSpent,
        })
        for talentIndex = 1, GetNumTalents(tabIndex) do
            local name, iconTexture, row, column, rank, maxRank, isExceptional, available = GetTalentInfo(tabIndex, talentIndex)
            local spellId = Talents:GetTalentSpellId(fileName, row, column, rank)
            table.insert(talents, {
                tabID = tabIndex,
                row = row,
                col = column,
                rank = rank,
                maxRank = maxRank,
                spellId = spellId,
            })
        end
    end
    -- find the tab with most points and set spec if not already set, the user can always change this if wrong and this will probably cause them to actually update it.
    table.sort(tabs, function(a, b)
        return a.pointsSpent > b.pointsSpent;
    end)
    -- return {
    --     tabs = tabs,
    --     talents = talents,
    -- }
    return 1, tabs, talents, {};
end

local glyphsPopped = {}
function addon.api.wrath.getPlayerTalents(...)
    local newSpec, previousSpec = ...;

	if type(newSpec) ~= "number" then
		newSpec = GetActiveTalentGroup()
	end
	if type(newSpec) ~= "number" then
		newSpec = 1
	end

    local tabs, talents = {}, {}
    for tabIndex = 1, GetNumTalentTabs() do
        local spec, texture, pointsSpent, fileName = GetTalentTabInfo(tabIndex)
        local engSpec = Talents.TalentBackgroundToSpec[fileName]
        table.insert(tabs, {
            fileName = fileName,
            pointsSpent = pointsSpent,
        })
        for talentIndex = 1, GetNumTalents(tabIndex) do
            local name, iconTexture, row, column, rank, maxRank, isExceptional, available = GetTalentInfo(tabIndex, talentIndex)
            local spellId = Talents:GetTalentSpellId(fileName, row, column, rank)
            table.insert(talents, {
                tabID = tabIndex,
                row = row,
                col = column,
                rank = rank,
                maxRank = maxRank,
                spellId = spellId,
            })
        end
    end

    local inGroup = IsInGroup()
    local inInstance, instanceType = IsInInstance()

    local glyphs = {}
    for i = 1, 6 do
        local enabled, glyphType, glyphSpellID, icon = GetGlyphSocketInfo(i);
        if enabled and glyphSpellID then
            local name = GetSpellInfo(glyphSpellID) --check its a valid spell ID

            if name then
                if addon.glyphData.spellIdToItemId[glyphSpellID] then
                    local itemID = addon.glyphData.spellIdToItemId[glyphSpellID].itemID
                    local found = false
                    for k, glyph in ipairs(addon.glyphData.wrath) do
                        if glyph.itemID == itemID then
                            table.insert(glyphs, {
                                socket = i,
                                itemID = itemID,
                                classID = glyph.classID,
                                glyphType = glyph.glyphType,
                                name = name,
                            })
                            found = true
                        end
                    end
                    if not found then
                        if not inGroup and not inInstance then
                            if not glyphsPopped[glyphSpellID] then
                                local s = string.format("[%s] unable to find glyph itemID for %s with GlyphSpellID of %d", addonName, name, glyphSpellID)
                                StaticPopup_Show("GuildbookReport", s)
                                glyphsPopped[glyphSpellID] = true
                            end
                        end
                    end
                else
                    if not inGroup and not inInstance then
                        if not glyphsPopped[glyphSpellID] then
                            local s = string.format("[%s] glyph data for %s with GlyphSpellID of %d missing from lookup table", addonName, name, glyphSpellID)
                            StaticPopup_Show("GuildbookReport", s)
                            glyphsPopped[glyphSpellID] = true
                        end
                    end
                end
            end
        end
    end

    return newSpec, tabs, talents, glyphs;

    -- if newSpec == 1 then
    --     self:TriggerEvent("OnPlayerTalentSpecChanged", "primary", talents, glyphs)
    -- elseif newSpec == 2 then
    --     self:TriggerEvent("OnPlayerTalentSpecChanged", "secondary", talents, glyphs)
    -- end

    --DevTools_Dump({glyphs})
    --DisplayTableInspectorWindow({glyphs = glyphs});

end


--[[
    ---Create a talent data string using the wowhead hyphen format
function ModernTalentsMixin:SaveTalentPreviewLoadout()

    local trees = {
        [1] = "",
        [2] = "",
        [3] = "",
    }
    local treeIndex = 0
    self:IterTalentTreesOrdered(function(f)
        if f.rowId == 1 and f.colId == 1 then
            treeIndex = treeIndex + 1
        end
        if f.talentIndex then
            trees[treeIndex] = string.format("%s%s", trees[treeIndex], f.previewRank or 0)
        end
    end)
    local s = string.format("%s-%s-%s", trees[1], trees[2], trees[3])

    StaticPopup_Show("ModernTalentsSaveLoadoutDialog", "Name", nil, {
        callback = function(name)
            local _, _, class = UnitClass("player")
            table.insert(self.db.account.talentLoadouts, {
                name = name,
                class = class,
                loadout = s,
            })
            self:InitializeTalentTabDropdown()
        end
    })

end
]]


--https://www.wowhead.com/classic/talent-calc/paladin/550001-053051331301051-05202

function addon.api.classic.getAnniversaryTalents(...)
    local newSpec, previousSpec = ...;

	if type(newSpec) ~= "number" then
		newSpec = GetActiveTalentGroup()
	end
	if type(newSpec) ~= "number" then
		newSpec = 1
	end

    local tabs, talents = {}, {}
    for tabIndex = 1, GetNumTalentTabs() do
        local id, name, description, icon, pointsSpent, fileName, previewPointsSpent, isUnlocked = GetTalentTabInfo(tabIndex)
        local role1, role2 = GetTalentTreeRoles(tabIndex, false, false); --inspect, pet

        --print(id, name, fileName)
        local engSpec = Talents.TalentBackgroundToSpec[fileName]
        table.insert(tabs, {
            fileName = fileName,
            pointsSpent = pointsSpent,
        })
        for talentIndex = 1, GetNumTalents(tabIndex) do
            local _name, iconTexture, row, column, rank, maxRank, isExceptional, available, unKnown, isActive, y, talentID = GetTalentInfo(tabIndex, talentIndex)
            local spellId = Talents:GetTalentSpellId(fileName, row, column, rank, id)
            table.insert(talents, {
                tabID = tabIndex,
                row = row,
                col = column,
                rank = rank,
                maxRank = maxRank,
                spellId = spellId,
            })
        end
    end
    
    return newSpec, tabs, talents, {};
end

function addon.api.cata.getPlayerTalents(...)
    local newSpec, previousSpec = ...;

	if type(newSpec) ~= "number" then
		newSpec = GetActiveTalentGroup()
	end
	if type(newSpec) ~= "number" then
		newSpec = 1
	end

    local tabs, talents = {}, {}
    for tabIndex = 1, GetNumTalentTabs() do
        local id, name, description, icon, pointsSpent, fileName, previewPointsSpent, isUnlocked = GetTalentTabInfo(tabIndex)
        local role1, role2 = GetTalentTreeRoles(tabIndex, false, false); --inspect, pet

        --print(id, name, fileName)
        local engSpec = Talents.TalentBackgroundToSpec[fileName]
        table.insert(tabs, {
            fileName = fileName,
            pointsSpent = pointsSpent,
        })
        for talentIndex = 1, GetNumTalents(tabIndex) do
            local _name, iconTexture, row, column, rank, maxRank, isExceptional, available, unKnown, isActive, y, talentID = GetTalentInfo(tabIndex, talentIndex)
            local spellId = Talents:GetTalentSpellId(fileName, row, column, rank, id)
            table.insert(talents, {
                tabID = tabIndex,
                row = row,
                col = column,
                rank = rank,
                maxRank = maxRank,
                spellId = spellId,
            })
        end
    end

    -- local inGroup = IsInGroup()
    -- local inInstance, instanceType = IsInInstance()

    local glyphs = {}
    for i = 1, 9 do
        local enabled, glyphType, glyphIndex, glyphSpellID, icon = GetGlyphSocketInfo(i);
        if enabled and glyphSpellID then
            
            table.insert(glyphs, {
                spellID = glyphSpellID,
                glyphType = glyphType,
                glyphIndex = glyphIndex,
            })
        end
    end

    return newSpec, tabs, talents, glyphs;

end

function addon.api.getPlayerAuras()
    local buffs = {}
    for i = 1, 40 do
        local name, icon, count, dispellType, duration, expirationTime, source, isStealable, _, spellId = UnitAura("player", i)
        if name then
            table.insert(buffs, {
                spellId = spellId,
                expirationTime = expirationTime,
                count = count,
            })
        end
    end
    return buffs;
end

local resistanceIDs = {
    [0] = "physical",
    [1] = "holy",
    [2] = "fire",
    [3] = "nature",
    [4] = "frost",
    [5] = "shadow",
    [6] = "arcane",
}
function addon.api.getPlayerResistances(level)
    local res = {}
    -- res.physical = addon.api.trimNumber(ResistancePercent(0,level))
    -- res.holy = addon.api.trimNumber(ResistancePercent(1,level))
    -- res.fire = addon.api.trimNumber(ResistancePercent(2,level))
    -- res.nature = addon.api.trimNumber(ResistancePercent(3,level))
    -- res.frost = addon.api.trimNumber(ResistancePercent(4,level))
    -- res.shadow = addon.api.trimNumber(ResistancePercent(5,level))
    -- res.arcane = addon.api.trimNumber(ResistancePercent(6,level))

    for i = 0, 6 do
        local base, total, bonus, minus = UnitResistance("player", i)
        res[resistanceIDs[i]] = {
            base = base,
            total = total,
            bonus = bonus,
            minus = minus,
        }
    end

    return res;
end

local spellSchools = {
    [2] = 'Holy',
    [3] = 'Fire',
    [4] = 'Nature',
    [5] = 'Frost',
    [6] = 'Shadow',
    [7] = 'Arcane',
}
local statIDs = {
    [1] = 'Strength',
    [2] = 'Agility',
    [3] = 'Stamina',
    [4] = 'Intellect',
    [5] = 'Spirit',
}
function addon.api.classic.getPaperDollStats()

    local stats = {
        attributes = {},
        defence = {},
        melee = {},
        ranged = {},
        spell = {},
    }

    local numSkills = GetNumSkillLines();
    local skillIndex = 0;
    local currentHeader = nil;

    for i = 1, numSkills do
        local skillName = select(1, GetSkillLineInfo(i));
        local isHeader = select(2, GetSkillLineInfo(i));

        if isHeader ~= nil and isHeader then
            currentHeader = skillName;
        else
            if (currentHeader == "Weapon Skills" and skillName == 'Defense') then
                skillIndex = i;
                break;
            end
        end
    end

    local baseDef, modDef;
    if (skillIndex > 0) then
        baseDef = select(4, GetSkillLineInfo(skillIndex));
        modDef = select(6, GetSkillLineInfo(skillIndex));
    else
        baseDef, modDef = UnitDefense('player')
    end

    local posBuff = 0;
    local negBuff = 0;
    if ( modDef > 0 ) then
        posBuff = modDef;
    elseif ( modDef < 0 ) then
        negBuff = modDef;
    end
    stats.defence.Defence = {
        Base = addon.api.trimNumber(baseDef),
        Mod = addon.api.trimNumber(modDef),
    }

    local baseArmor, effectiveArmor, armr, posBuff, negBuff = UnitArmor('player');
    stats.defence.Armor = addon.api.trimNumber(baseArmor)
    stats.defence.Block = addon.api.trimNumber(GetBlockChance());
    stats.defence.Parry = addon.api.trimNumber(GetParryChance());
    stats.defence.ShieldBlock = addon.api.trimNumber(GetShieldBlock());
    stats.defence.Dodge = addon.api.trimNumber(GetDodgeChance());

    --local expertise, offhandExpertise, rangedExpertise = GetExpertise();
    --local base, casting = GetManaRegen();
    stats.spell.SpellHit = 0 -- addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_SPELL) + GetSpellHitModifier());
    stats.melee.MeleeHit = 0 --addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_MELEE) + GetHitModifier());
    stats.ranged.RangedHit = 0 -- addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_RANGED));


    stats.ranged.RangedCrit = addon.api.trimNumber(GetRangedCritChance());
    stats.melee.MeleeCrit = addon.api.trimNumber(GetCritChance());

    stats.spell.Haste = addon.api.trimNumber(GetHaste());
    stats.melee.Haste = addon.api.trimNumber(GetMeleeHaste());
    stats.ranged.Haste = addon.api.trimNumber(GetRangedHaste());

    local base, casting = GetManaRegen()
    stats.spell.ManaRegen = base and addon.api.trimNumber(base) or 0;
    stats.spell.ManaRegenCasting = casting and addon.api.trimNumber(casting) or 0;

    local minCrit = 100
    for id, school in pairs(spellSchools) do
        if GetSpellCritChance(id) < minCrit then
            minCrit = GetSpellCritChance(id)
        end
        stats.spell['SpellDmg'..school] = addon.api.trimNumber(GetSpellBonusDamage(id));
        stats.spell['SpellCrit'..school] = addon.api.trimNumber(GetSpellCritChance(id));
    end
    stats.spell.SpellCrit = addon.api.trimNumber(minCrit)

    stats.spell.HealingBonus = addon.api.trimNumber(GetSpellBonusHealing());

    local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player");
    local mainSpeed, offSpeed = UnitAttackSpeed("player");
    local mlow = (lowDmg + posBuff + negBuff) * percentmod
    local mhigh = (hiDmg + posBuff + negBuff) * percentmod
    local olow = (offlowDmg + posBuff + negBuff) * percentmod
    local ohigh = (offhiDmg + posBuff + negBuff) * percentmod
    if mainSpeed < 1 then mainSpeed = 1 end
    if mlow < 1 then mlow = 1 end
    if mhigh < 1 then mhigh = 1 end
    if olow < 1 then olow = 1 end
    if ohigh < 1 then ohigh = 1 end

    if offSpeed then
        if offSpeed < 1 then 
            offSpeed = 1
        end
        stats.melee.MeleeDmgOH = addon.api.trimNumber((olow + ohigh) / 2.0)
        stats.melee.MeleeDpsOH = addon.api.trimNumber(((olow + ohigh) / 2.0) / offSpeed)
    else
        --offSpeed = 1
        stats.melee.MeleeDmgOH = addon.api.trimNumber(0)
        stats.melee.MeleeDpsOH = addon.api.trimNumber(0)
    end
    stats.melee.MeleeDmgMH = addon.api.trimNumber((mlow + mhigh) / 2.0)
    stats.melee.MeleeDpsMH = addon.api.trimNumber(((mlow + mhigh) / 2.0) / mainSpeed)

    local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player");
    local low = (lowDmg + posBuff + negBuff) * percent
    local high = (hiDmg + posBuff + negBuff) * percent
    if speed < 1 then speed = 1 end
    if low < 1 then low = 1 end
    if high < 1 then high = 1 end
    local dmg = (low + high) / 2.0
    stats.ranged.RangedDmg = addon.api.trimNumber(dmg)
    stats.ranged.RangedDps = addon.api.trimNumber(dmg/speed)

    local base, posBuff, negBuff = UnitAttackPower('player')
    stats.melee.AttackPower = addon.api.trimNumber(base + posBuff + negBuff)

    for k, stat in pairs(statIDs) do
        local a, b, c, d = UnitStat("player", k);
        stats.attributes[stat] = addon.api.trimNumber(b)
    end

    return stats;
end
function addon.api.wrath.getPaperDollStats()

    local stats = {
        attributes = {},
        defence = {},
        melee = {},
        ranged = {},
        spell = {},
    }

    ---go through getting each stat value
    local numSkills = GetNumSkillLines();
    local skillIndex = 0;
    local currentHeader = nil;

    for i = 1, numSkills do
        local skillName = select(1, GetSkillLineInfo(i));
        local isHeader = select(2, GetSkillLineInfo(i));

        if isHeader ~= nil and isHeader then
            currentHeader = skillName;
        else
            if (currentHeader == "Weapon Skills" and skillName == 'Defense') then
                skillIndex = i;
                break;
            end
        end
    end

    local baseDef, modDef;
    if (skillIndex > 0) then
        baseDef = select(4, GetSkillLineInfo(skillIndex));
        modDef = select(6, GetSkillLineInfo(skillIndex));
    else
        baseDef, modDef = UnitDefense('player')
    end

    local posBuff = 0;
    local negBuff = 0;
    if ( modDef > 0 ) then
        posBuff = modDef;
    elseif ( modDef < 0 ) then
        negBuff = modDef;
    end
    stats.defence.Defence = {
        Base = addon.api.trimNumber(baseDef),
        Mod = addon.api.trimNumber(modDef),
    }

    local baseArmor, effectiveArmor, armr, posBuff, negBuff = UnitArmor('player');
    stats.defence.Armor = addon.api.trimNumber(baseArmor)
    stats.defence.Block = addon.api.trimNumber(GetBlockChance());
    stats.defence.Parry = addon.api.trimNumber(GetParryChance());
    stats.defence.ShieldBlock = addon.api.trimNumber(GetShieldBlock());
    stats.defence.Dodge = addon.api.trimNumber(GetDodgeChance());

    --local expertise, offhandExpertise, rangedExpertise = GetExpertise();
    --stats.Expertise = addon.api.trimNumber(GetExpertise()); --will display mainhand expertise but it stores offhand expertise as well, need to find a way to access it
    --local base, casting = GetManaRegen();

    stats.spell.SpellHit = addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_SPELL) + GetSpellHitModifier());
    stats.melee.MeleeHit = addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_MELEE) + GetHitModifier());
    stats.ranged.RangedHit = addon.api.trimNumber(GetCombatRatingBonus(CR_HIT_RANGED));

    stats.ranged.RangedCrit = addon.api.trimNumber(GetRangedCritChance());
    stats.melee.MeleeCrit = addon.api.trimNumber(GetCritChance());

    stats.spell.Haste = addon.api.trimNumber(GetCombatRatingBonus(20));
    local base, casting = GetManaRegen()
    base = base*5;
    casting = casting*5;
    stats.spell.ManaRegen = base and addon.api.trimNumber(base) or 0;
    stats.spell.ManaRegenCasting = casting and addon.api.trimNumber(casting) or 0;

    local minCrit = 100
    for id, school in pairs(spellSchools) do
        if GetSpellCritChance(id) < minCrit then
            minCrit = GetSpellCritChance(id)
        end
        stats.spell['SpellDmg'..school] = addon.api.trimNumber(GetSpellBonusDamage(id));
        stats.spell['SpellCrit'..school] = addon.api.trimNumber(GetSpellCritChance(id));
    end
    stats.spell.SpellCrit = addon.api.trimNumber(minCrit)

    stats.spell.HealingBonus = addon.api.trimNumber(GetSpellBonusHealing());

    local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player");
    local mainSpeed, offSpeed = UnitAttackSpeed("player");
    local mlow = (lowDmg + posBuff + negBuff) * percentmod
    local mhigh = (hiDmg + posBuff + negBuff) * percentmod
    local olow = (offlowDmg + posBuff + negBuff) * percentmod
    local ohigh = (offhiDmg + posBuff + negBuff) * percentmod
    if mainSpeed < 1 then mainSpeed = 1 end
    if mlow < 1 then mlow = 1 end
    if mhigh < 1 then mhigh = 1 end
    if olow < 1 then olow = 1 end
    if ohigh < 1 then ohigh = 1 end

    if offSpeed then
        if offSpeed < 1 then 
            offSpeed = 1
        end
        stats.melee.MeleeDmgOH = addon.api.trimNumber((olow + ohigh) / 2.0)
        stats.melee.MeleeDpsOH = addon.api.trimNumber(((olow + ohigh) / 2.0) / offSpeed)
    else
        --offSpeed = 1
        stats.melee.MeleeDmgOH = addon.api.trimNumber(0)
        stats.melee.MeleeDpsOH = addon.api.trimNumber(0)
    end
    stats.melee.MeleeDmgMH = addon.api.trimNumber((mlow + mhigh) / 2.0)
    stats.melee.MeleeDpsMH = addon.api.trimNumber(((mlow + mhigh) / 2.0) / mainSpeed)

    local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player");
    local low = (lowDmg + posBuff + negBuff) * percent
    local high = (hiDmg + posBuff + negBuff) * percent
    if speed < 1 then speed = 1 end
    if low < 1 then low = 1 end
    if high < 1 then high = 1 end
    local dmg = (low + high) / 2.0
    stats.ranged.RangedDmg = addon.api.trimNumber(dmg)
    stats.ranged.RangedDps = addon.api.trimNumber(dmg/speed)

    local base, posBuff, negBuff = UnitAttackPower('player')
    stats.melee.AttackPower = addon.api.trimNumber(base + posBuff + negBuff)

    for k, stat in pairs(statIDs) do
        local a, b, c, d = UnitStat("player", k);
        stats.attributes[stat] = addon.api.trimNumber(b)
    end

	--ViragDevTool:AddData(stats, "Guildbook_CharStats_"..equipmentSetName)

	--addon:TriggerEvent("OnPlayerStatsChanged", equipmentSetName, stats)

    return stats;
end

function addon.api.classic.getPlayerEquipment()
    local equipment = {}
    for k, v in ipairs(addon.data.inventorySlots) do
        local link = GetInventoryItemLink('player', GetInventorySlotInfo(v.slot)) or false
        equipment[v.slot] = link
    end
    return equipment;
end

function addon.api.getDaysInMonth(month, year)
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local d = days_in_month[month]
    -- check for leap year
    if (month == 2) then
        if year % 4 == 0 then
            if year % 100 == 0 then
                if year % 400 == 0 then
                    d = 29
                end
            else
                d = 29
            end
        end
    end
    return d
end


function addon.api.getLockouts()
    local t = {}
    local numSavedInstances = GetNumSavedInstances()
    if numSavedInstances > 0 then
        for i = 1, numSavedInstances do
            --t[i] = {GetSavedInstanceInfo(i)}
            local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)

            reset = (GetServerTime() + reset);

            table.insert(t, {
                name = name,
                id = id,
                reset = reset,
                difficulty = difficulty,
                locked = locked,
                extended = extended,
                instanceIDMostSig = instanceIDMostSig,
                isRaid = isRaid,
                maxPlayers = maxPlayers,
                difficultyName = difficultyName,
                numEncounters = numEncounters,
                encounterProgress = encounterProgress,
            })
            --local msg = string.format("name=%s, id=%s, reset=%s, difficulty=%s, locked=%s, numEncounters=%s", tostring(name), tostring(id), tostring(reset), tostring(difficulty), tostring(locked), tostring(numEncounters))
            --print(msg)
        end
    end
    return t
end


function addon.api.generateExportMenu(character)

    local menu = {
        {
            text = character:GetName(true),
            isTitle = true,
            notCheckable = true,
        }
    }
    table.insert(menu, addon.contextMenuSeparator)
    table.insert(menu, {
        text = "Export",
        isTitle = true,
        notCheckable = true,
    })

    local specInfo = character:GetSpecInfo()

    if specInfo then

        --local primarySpec, secondarySpec = specInfo.primary[1].id, specInfo.secondary[1].id
        local primarySpec, secondarySpec = character.data.mainSpec, character.data.offSpec

        local exportEquipMenu1 = {{
            text = "Select Gear",
            isTitle = true,
            notCheckable = true,
        },}
        local exportEquipMenu2 = {{
            text = "Select Gear",
            isTitle = true,
            notCheckable = true,
        },}
        for setname, info in pairs(character.data.inventory) do
            table.insert(exportEquipMenu1, {
                text = setname,
                notCheckable = true,
                func = function()
                    addon:TriggerEvent("Character_ExportEquipment", character, setname, "primary")
                end,
            })
            table.insert(exportEquipMenu2, {
                text = setname,
                notCheckable = true,
                func = function()
                    addon:TriggerEvent("Character_ExportEquipment", character, setname, "secondary")
                end,
            })
        end
    
        if primarySpec then
            local atlas, spec = character:GetClassSpecAtlasName(primarySpec)
            table.insert(menu, {
                text = string.format("%s %s", CreateAtlasMarkup(atlas, 16, 16), spec),
                notCheckable = true,
                hasArrow = true,
                menuList = exportEquipMenu1,
    
            })
        end
        if secondarySpec then
            local atlas, spec = character:GetClassSpecAtlasName(secondarySpec)
            table.insert(menu, {
                text = string.format("%s %s", CreateAtlasMarkup(atlas, 16, 16), spec),
                notCheckable = true,
                hasArrow = true,
                menuList = exportEquipMenu2,
    
            })
        end

    end
    return menu;
end





addon.data = {}
addon.data.inventorySlots = {
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
}







-- Guildbook = {
--     enabled = false,
-- }

-- addon:RegisterCallback("Database_OnInitialised", Guildbook.SetEnabled, Guildbook)

function addon.api.getCurrentCurrencies()
    local currencies = {};
    local preHeader;
    for i = 1, GetCurrencyListSize() do
        local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown, itemID = GetCurrencyListInfo(i)
        --local link = C_CurrencyInfo.GetCurrencyListLink(i)
        --local currencyID = C_CurrencyInfo.GetCurrencyIDFromLink(link)

        if isHeader then
            preHeader = name;
        end

        if not currencies[preHeader] then
            currencies[preHeader] = {}
        end

        local currencyStrinig = string.format("%d:%d", itemID, count)

        table.insert(currencies[preHeader], currencyStrinig)
    end

    return currencies;
end

function addon.api.getCurrentReputations()
    local reputations = {};

    local numFactions = GetNumFactions()
    local factionIndex = 1
    local preHeader;
    while (factionIndex <= numFactions) do
        local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
        
        if isHeader then

            if name and (not reputations[name]) then
                reputations[name] = {}
            end

            preHeader = name
            if isCollapsed then
                ExpandFactionHeader(factionIndex)
                numFactions = GetNumFactions()
            end
        end
        if name and (hasRep or not isHeader) then

            -- if preHeader == GUILD then
            --     name = GUILD
            -- end

            --print(name, bottomValue, topValue, earnedValue, (earnedValue - bottomValue), earnedValue - topValue)

            local currentValue = (earnedValue-bottomValue)
            local barMaxValue = (topValue-bottomValue)

            local repData = string.format("%d:%d:%d:%d", factionID, standingId, currentValue, barMaxValue)

            table.insert(reputations[preHeader], repData)

        end
        factionIndex = factionIndex + 1
    end

    return reputations;
end

