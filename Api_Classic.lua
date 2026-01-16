

local GuildbookName, Guildbook = ...;

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
    return;
end

if WOW_PROJECT_ID ~= WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
    return;
end

local Database = Guildbook.Database;


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

        for k, socketType in ipairs(Guildbook.Constants.SocketOrder) do
            if type(sockets[socketType]) == "number" and (sockets[socketType] > 0) then
                for i = 1, sockets[socketType] do
                    table.insert(itemSocketsOrderd, Guildbook.Constants.SocketFileIDs[socketType])
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

function Guildbook.Api.GetCurrentReputations()
    local reputations = {};

    --local numFactions = C_Reputation.GetNumFactions()
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

            local currentValue = (earnedValue-bottomValue)
            local barMaxValue = (topValue-bottomValue)

            local repData = string.format("%d:%d:%d:%d", factionID, standingId, currentValue, barMaxValue)

            table.insert(reputations[preHeader], repData)

        end
        factionIndex = factionIndex + 1
    end

    return reputations;
end

---Get player currencies
---@return table currencies a key/value paired table where [header] = {ipairs list of formatted strings ("%d:%d", itemID, count)}
function Guildbook.Api.GetCurrentCurrencies()
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

---Get resistances for unit (defaults to "player")
---@return table resistances a key/value paired table where [name] = { base, total, bonus, minus, } 
function Guildbook.Api.GetPlayerResistances(unit)
    unit = unit or "player"
    local resistances = {}
    for i = 0, 6 do
        local base, total, bonus, minus = UnitResistance(unit, i)
        resistances[Guildbook.Constants.ResistanceIDs[i]] = {
            base = base,
            total = total,
            bonus = bonus,
            minus = minus,
        }
    end

    return resistances;
end
