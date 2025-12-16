

local GuildbookName, Guildbook = ...;

local Database = Guildbook.Database;

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    return;
end



--[[

    WIP: Any constants can be listed here for now, then moved as a whole into a Constants.lua file


]]
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


--[[

WIP: This is the start of an Api upgrade, the functions from Globals.lua will migrate here.

Guildbook.Api will become the new namespace, with a file per expansion

]]



Guildbook.Api = {}

--Attempt to extract the gem and enchant payload from an item link
function Guildbook.Api.GetItemGemAndEnchantInfo(link)
    local s = string.match(link, [[|H([^:]*):([^|]*)|h(.*)|h]])

    local itemID, enchantID, gem1, gem2, gem3 = strsplit(":", s)

    -- if itemID == "57268" then

    --     DevTools_Dump({strsplit(":", payload)})

    --     local stats = GetItemStats(link)
    --     for k, v in pairs(stats) do
    --         print(k, v)
    --     end

    --     local name, id = C_Item.GetItemSpell(link)
    --     print(name, id)

    --     local lines = ScanTooltip(link)
    --     DevTools_Dump(lines)
    -- end


    --if itemID and enchantID and gem1 and gem2 and gem3 then
        return {
            itemID = tonumber(itemID),
            enchantID = tonumber(enchantID),
            gem1 = tonumber(gem1),
            gem2 = tonumber(gem2),
            gem3 = tonumber(gem3),
        }
    --end
end

function Guildbook.Api.GetItemSocketInfo(link)
    
    local linkData = Guildbook.Api.GetItemGemAndEnchantInfo(link)

    local gems = { linkData.gem1, linkData.gem2, linkData.gem3, }

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

function Guildbook.Api.GetColourGradientFromPercent(percent, reverse)

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

function Guildbook.Api.GetTradeskillItemDataFromID(itemID)
    for k, v in ipairs(Guildbook.itemData) do
        if v.itemID == itemID then
            return v;
        end
    end
    return false;
end

function Guildbook.Api.GetTradeskillItemsUsingReagentItemID(itemID, prof1, prof2)
    local t = {}
    for k, v in ipairs(Guildbook.itemData) do
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
function Guildbook.Api.ExtractLink(text)
    -- linkType: |H([^:]*): matches everything that's not a colon, up to the first colon.
    -- linkOptions: ([^|]*)|h matches everything that's not a |, up to the first |h.
    -- displayText: (.*)|h matches everything up to the second |h.
    -- Ex: |cffffffff|Htype:a:b:c:d|htext|h|r becomes type, a:b:c:d, text
    return string.match(text, [[|H([^:]*):([^|]*)|h(.*)|h]]);
end

function Guildbook.Api.TrimNumber(num)
    if type(num) == 'number' then
        local trimmed = string.format("%.1f", num)
        return tonumber(trimmed)
    else
        return 1
    end
end

function Guildbook.Api.CharacterIsMine(name)
    if Database.db.myCharacters[name] ~= nil then
        return true;
    end
    return false;
end

function Guildbook.Api.GetGuildRanks()
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


function Guildbook.Api.ScanForTradeskillSpec()
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

function Guildbook.Api.GetLockouts()
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