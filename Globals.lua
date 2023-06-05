local name, addon = ...;

local Talents = addon.Talents;

--create these at addon level
addon.thisCharacter = "";
addon.guilds = {}
addon.characters = {}

addon.api = {}
function addon.api.trimNumber(num)
    if type(num) == 'number' then
        local trimmed = string.format("%.1f", num)
        return tonumber(trimmed)
    else
        return 1
    end
end

function addon.api.scanPlayerContainers(includeBanks)

    local copper = GetMoney()

    local playerBags = {}

    -- player bags
    for bag = 0, 4 do
        playerBags[bag] = {}
        for slot = 1, GetContainerNumSlots(bag) do
            playerBags[bag][slot] = {
                id = -1,
                count = -1,
            }
            local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bag, slot)
            if id and count then
                playerBags[bag][slot] = {
                    id = id,
                    count = count,
                }
            end
        end
    end

    if includeBanks then
        -- main bank
        local bankBagId = -1
        for slot = 1, 28 do
            playerBags[bankBagId] = {}
            for slot = 1, GetContainerNumSlots(bankBagId) do
                playerBags[bankBagId][slot] = {
                    id = -1,
                    count = -1,
                }
                local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bankBagId, slot)
                if id and count then
                    playerBags[bankBagId][slot] = {
                        id = id,
                        count = count,
                    }
                end
            end
        end

        -- bank bags
        for bag = 5, 11 do
            playerBags[bag] = {}
            for slot = 1, GetContainerNumSlots(bag) do
                playerBags[bag][slot] = {
                    id = -1,
                    count = -1,
                }
                local _, count, _, _, _, _, link, _, _, id = GetContainerItemInfo(bag, slot)
                if id and count then
                    playerBags[bag][slot] = {
                        id = id,
                        count = count,
                    }
                end
            end
        end
    end

    return playerBags, copper;
end

function addon.api.getPlayerTalents()
    local talents = {}
    local tabs = {}
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
    -- find the tab with most points and set spec if not already set, the user can always change this if wrong and this will probably cause them to actually update it.
    table.sort(tabs, function(a, b)
        return a.pointsSpent > b.pointsSpent;
    end)
    return {
        tabs = tabs,
        talents = talents,
    }
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

function addon.api.getPlayerResistances(level)
    local res = {}
    res.physical = addon.api.trimNumber(ResistancePercent(0,level))
    res.holy = addon.api.trimNumber(ResistancePercent(1,level))
    res.fire = addon.api.trimNumber(ResistancePercent(2,level))
    res.nature = addon.api.trimNumber(ResistancePercent(3,level))
    res.frost = addon.api.trimNumber(ResistancePercent(4,level))
    res.shadow = addon.api.trimNumber(ResistancePercent(5,level))
    res.arcane = addon.api.trimNumber(ResistancePercent(6,level))

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
function addon.api.getPaperDollStats()

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

function addon.api.getPlayerEquipment()
    local equipment = {}
    for k, v in ipairs(addon.data.inventorySlots) do
        local link = GetInventoryItemLink('player', GetInventorySlotInfo(v.slot)) or false
        equipment[v.slot] = link
    end
    return equipment;
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
        slot = "BACKSLOT",
        icon = 136512,
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
    -- {
    --     slot = "RELICSLOT",
    --     icon = 136522,
    -- },
}

--Guildbook = {}