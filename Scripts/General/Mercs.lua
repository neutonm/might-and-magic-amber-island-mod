--[[
Mercenary Mechanics,
Author: Henrik Chukhran, 2022 - 2024
]]

-- @todo Refactor (Warning for others: don't refactor without testing!!!)
---- + proper naming
-- @todo load stats from txt

-- Enums
EMercUpgradeType = {
    Null        = 0,
    HP          = 1,
    Level       = 2,
    Uses        = 3,
    AC          = 4,
    MageRes     = 5,
    MeleeDamage = 6,
    RangeDamage = 7,
    Spell       = 8
}

-- Structs
SMercUpgrade = {
    Level               = 0,
    Price               = { 1000,2500,4000 },
    EMercUpgradeType    = EMercUpgradeType.Null
}

SMerc = {
    Name        = "Unnamed",
    NPC_ID      = 525,
    MonsterID   = 0,
    FightsLeft  = 1,
    FightsMax   = { [1] = 1, [2] = 2, [3] = 3, [4] = 4 },
    FullHP      = { [1] = 100, [2] = 125, [3] = 150, [4] = 180 },
    AC          = { [1] = 3, [2] = 8, [3] = 15, [4] = 20 },
    Level       = { [1] = 5, [2] = 10, [3] = 15, [4] = 20 },
    Attack1     = { [1] = "1D2", [2] = "2D3+1", [3] = "3D4+2", [4] = "4D4+3" },
    Attack2     = nil,
    Upgrades    = { SMercUpgrade },
    Ability     = nil,
    Hired       = true,
    Released    = false,
    ReleaseMap  = "",
    Dead        = false,
}

MercNPCList = {
    525,526
}

ConstMercUpgradeLimit = 3

-- Functions
function NewMerc(name, npcID, monsterID, hired, ability, fightsMax, fullHP, AC, Level, attack1, attack2)
    return {
        Name        = name or SMerc.Name,
        NPC_ID      = npcID or SMerc.NPC_ID,
        MonsterID   = monsterID or SMerc.MonsterID,
        FightsLeft  = fightsMax and fightsMax[1] or SMerc.FightsLeft,
        FightsMax   = fightsMax or SMerc.FightsMax,
        FullHP      = fullHP or SMerc.FullHP,
        AC          = AC or SMerc.AC,
        Level       = Level or SMerc.Level,
        Attack1     = attack1 or SMerc.Attack1,
        Attack2     = attack2 or SMerc.Attack2,
        Upgrades    = {},
        Ability     = ability or SMerc.Ability,
        Hired       = hired or SMerc.Hired,
        Released    = false,
        ReleaseMap  = "",
        Dead        = false
    }
end

function IsMercUnlocked(Merc)

    if Merc == nil or Merc.NPC_ID == nil then
        return false
    end

    for _, v in ipairs(vars.MercNPCUnlockedList) do
        if v == Merc.NPC_ID then
            return true
        end
    end

    return false
end

function UnlockMerc(Merc)

    if Merc == nil or Merc.NPC_ID == nil then
        return false
    end

    if IsMercUnlocked(Merc) then return end
    table.insert(vars.MercNPCUnlockedList, Merc.NPC_ID) 
end

function GetUpgradeLevel(Merc, MercUpgradeType)

    Level = 0

    for _, upgrade in ipairs(Merc.Upgrades) do
        if upgrade.EMercUpgradeType == MercUpgradeType then
            Level = upgrade.Level or 1
            break
        end
    end

    return Level
end

function GetUpgrade(Merc, MercUpgradeType)

    for _, upgrade in ipairs(Merc.Upgrades) do
        if upgrade.EMercUpgradeType == MercUpgradeType then
            return upgrade
        end
    end

    return nil
end

function UpgradeMerc(Merc, MercUpgradeType)

    local Upgrade   = GetUpgrade(Merc, MercUpgradeType)

    if Upgrade == nil then
        local NewUpgrade = {
            Level            = 1,
            Price            = { 1000,2000,3000 },
            EMercUpgradeType = MercUpgradeType
        }
        
        table.insert(Merc.Upgrades, NewUpgrade)

        return NewUpgrade
    else
        if Upgrade.Level < ConstMercUpgradeLimit then
            Upgrade.Level = Upgrade.Level + 1
        end
    end

    return Upgrade
end

function ParseDamageString(damageString)

    local count, sides, add = damageString:match("(%d+)D(%d+)%+?(%d*)")
    count = tonumber(count)
    sides = tonumber(sides)
    add = (add ~= "" and tonumber(add)) or 0

    local Attack1 = {
        DamageAdd = add,
        DamageDiceCount = count,
        DamageDiceSides = sides,
    }

    return Attack1
end

function MercDecCharge(Merc)
    Merc.FightsLeft = math.max(0, Merc.FightsLeft - 1)
end

-- @todo won't work, figure out how to update NPCTopic/Quests texts
--- Suggestion: make this a a form of "Greeting", use Quest.GetGreeting = GetMercInfoString
-- @todo rework, this version uses one level for all upgrades
function GetMercInfoString(Merc, upgradeLevel)

    local upgradeLevel  = upgradeLevel or 1  -- Default to level 1 if not provided
    local hp            = Merc.FullHP[upgradeLevel]     or Merc.FullHP[1]
    local ac            = Merc.AC[upgradeLevel]         or Merc.AC[1]
    local level         = Merc.Level[upgradeLevel]      or Merc.Level[1]
    local attack1       = Merc.Attack1[upgradeLevel]    or Merc.Attack1[1]
    local fightsLeft    = Merc.FightsMax[upgradeLevel]  or Merc.FightsMax[1]

    return string.format("Greetings! I am known as %s, a mercenary combatant of Level %d."..
                         "My have a robust health pool of %d and an armor class of %d."..
                         "With my trusty weapons, I deliver a formidable melee assault, capable of inflicting %s damage."..
                         "You have my allegiance for %d summons each day, ready to stand by your side!\n\n"..
                         "Upgrades:\nLevel: %d\\%d\nHit Points: %d\\%d\nArmour: %d\\%d\nDamage: %d\\%d\nSummons: %d\\%d",
                         Merc.Name, level, hp, ac, attack1, fightsLeft, 1,1,1,1,1,1,1,1,1,1)
end
