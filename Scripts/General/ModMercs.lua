--[[
Description:    Mercenary Mechanics,
Author:         Henrik Chukhran, 2022 - 2026

ToDo:
    - New Upgrade: Special
    - New Upgrade: Magical Resistances
    - Make sure that attacking them won't make other allies attack you
    - Summoned monsters must be immediately hostile against your hostiles
    - Finish/rework Merc_GetInfoString
    
]]

-- Const 
MercTxt             = LocalizeAll{
    MMercFight              = "Fight",
    MMercDefaultAbout       = "I'm tough and rough.",
    MMercDefaultHired       = "Hired!",
    MMercDefaultGreeting    = "Greetings!",
    MMercDefaultFightTired  = "Too tired.",
    MMercDefaultFireAttempt = "Are you sure?",
    MMercDefaultFireCancel  = "Phew, that was close!",

    MMercTacticsHoldMsg     = "I will \01265523hold this position\01200000 and wait here until you call me back.",
    MMercTacticsFollowMsg   = "I will \01265523follow your lead\01200000 and stay close to the party.",
    MMercStyleDefensiveMsg  = "I will use a \01265523defensive style\01200000, fighting nearby threats without straying too far.",
    MMercStyleAggressiveMsg = "I will use an \01265523aggressive style\01200000 and press the fight until enemies are dealt with.",

    MMercInfoMelee          = "With my trusty weapons, I deliver a formidable melee assault, capable of inflicting \01265523%s\01200000 damage.\n\n",
    MMercInfoMeleeUpgrade   = "	008* Melee:	160%d/3\n",
    MMercInfoRanged         = "I can perform a ranged attack, dealing \01265523%s\01200000 damage to your target.\n\n",
    MMercInfoRangedUpgrade  = "	008* Ranged:	160%d/3\n",
    MMercInfo               = "Greetings!\n\nI am known as \01265523%s\01200000, a mercenary combatant of Level \01265523%d\01200000.\n\n"..
                              "My have a robust health pool of \01265523%d\01200000 and an armor class of \01265523%d\01200000.\n\n"..
                              "%s"..
                              "%s"..
                              "You have my allegiance for \01265523%s\01200000 summons each day, ready to stand by your side!\n\n"..
                              "Upgrades: \n	008* Hit Points:	160%d/3\n	008* Armor Class:	160%d/3\n	008* Level:	160%d/3\n%s%s	008* Summons:	160%d/3"
}

const.Mercenary     = {
    UpgradeType     = {
        Null        = 0,
        HP          = 1,
        Level       = 2,
        Charges     = 3,
        AC          = 4,
        MageRes     = 5,
        MeleeDamage = 6,
        RangeDamage = 7,
        Spell       = 8
    },
    UpgradeLimit    = 3,
    Special         = {
        Null        = "",
        Undying     = "undying"
    }
}

-- Structs
SMercUpgrade        = {
    Level           = 0,
    Price           = { 500,1000,1500 },
    UpgradeType     = const.Mercenary.UpgradeType.Null
}

-- Holds mutable data shared across save files
SMercSaveData       = {
    NPC_ID          = 0,
    FightsLeft      = 1,
    Upgrades        = { SMercUpgrade },
    Released        = false,
    ReleaseMap      = "",
    Dead            = false,
    HiredOnce       = false,
    AIBehavior      = const.FollowerMode.DefensiveFollow
}

-- Required by guildmaster
SMercCredentials    = {
    PriceHire       = 2000,
    PriceReHire     = 500,
    PriceResurrect  = 500,

    TextAbout       = MercTxt.MMercDefaultAbout,
    TextHired       = MercTxt.MMercDefaultHired,
    TextGreeting    = MercTxt.MMercDefaultGreeting,
    TextFightTired  = MercTxt.MMercDefaultFightTired,
    TextSpecial     = "",
    TextFireAttempt = MercTxt.MMercDefaultFireAttempt,
    TextFireCancel  = MercTxt.MMercDefaultFireCancel
}

SMercCredentialsSchema = {
    Name            = { type = "string", required = true },
    PriceHire       = { type = "number" },
    PriceReHire     = { type = "number" },
    PriceResurrect  = { type = "number" },

    TextAbout       = { type = "string", escaped = true },
    TextHired       = { type = "string", escaped = true },
    TextGreeting    = { type = "string", escaped = true },
    TextFightTired  = { type = "string", escaped = true },
    TextSpecial     = { type = "string", escaped = true },
    TextFireAttempt = { type = "string", escaped = true },
    TextFireCancel  = { type = "string", escaped = true },
}

-- Holds non-mutable data for mercs
SMerc               = {
    StringID        = "none",
    Name            = "Unnamed",
    NPC_ID          = 525,
    MonsterID       = 0,
    Ability         = "",

    FullHP          = { [1] = 100, [2] = 125, [3] = 150, [4] = 180  },
    AC              = { [1] = 3, [2] = 8, [3] = 15, [4] = 20        },
    Level           = { [1] = 5, [2] = 10, [3] = 15, [4] = 20       },
    Attack1         = { [1] = "1D2", [2] = "2D3+1", [3] = "3D4+2", [4] = "4D4+3" },
    Attack2         = nil,
    FightsMax       = { [1] = 1, [2] = 2, [3] = 3, [4] = 4          },
    Credentials     = table.copy(SMercCredentials),
}

SMercSchema = {
    StringID        = { column = "ID",      type = "string", required = true    },
    Name            = { type = "string"                                         },
    NPC_ID          = { type = "number"                                         },
    MonsterID       = { column = "MON_ID",  type = "number"                     },
    Ability         = { type = "string"                                         },

    FullHP          = { parse = TableLoader.ParseIndexedColumns("FullHP",    "number", 0, 3) },
    AC              = { parse = TableLoader.ParseIndexedColumns("AC",        "number", 0, 3) },
    Level           = { parse = TableLoader.ParseIndexedColumns("Level",     "number", 0, 3) },
    Attack1         = { parse = TableLoader.ParseIndexedColumns("Attack1",   "string", 0, 3) },
    Attack2         = { parse = TableLoader.ParseIndexedColumns("Attack2",   "string", 0, 3) },
    FightsMax       = { parse = TableLoader.ParseIndexedColumns("FightsMax", "number", 0, 3) },
}

-- Tables
MercsDB             = {}
MercNPCList         = {}

-- Functions
function Merc_NewGenericTable(t)

    local Merc = table.copy(SMerc)
    for key, value in pairs(t) do
        Merc[key] = value
    end
    return Merc
end

function Merc_IsHired(Merc)

    for _, v in ipairs(vars.MercNPCHiredList) do
        if v == Merc.NPC_ID then
            return true
        end
    end

    return false
end

function Merc_Hire(Merc)

    if Merc_IsHired(Merc) then return end

    local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
    MercSaveData.HiredOnce = true

    table.insert(vars.MercNPCHiredList, Merc.NPC_ID)
end

function Merc_Fire(Merc)

    if Merc_IsHired(Merc) == false then return end

    for i, v in ipairs(vars.MercNPCHiredList) do
        if v == Merc.NPC_ID then
            table.remove(vars.MercNPCHiredList, i)
            break  -- Exit the loop after removing the element
        end
    end
end

function Merc_IsAvailableForHire(MercID)

    for _, v in ipairs(vars.MercNPCAvailableList) do
        if v == MercID then
            return true
        end
    end

    return false
end

function Merc_MakeAvailableForHire(MercID)

    if Merc_IsAvailableForHire(MercID) then return end

    table.insert(vars.MercNPCAvailableList, MercID)
end

function Merc_GetUpgrade(Merc, MercUpgradeType)

    local MercUpgrades = Merc_GetSaveDataByID(Merc.NPC_ID)
    for _, upgrade in ipairs(MercUpgrades) do
        if upgrade.UpgradeType == MercUpgradeType then
            return upgrade
        end
    end

    return nil
end

function Merc_GetUpgradeLevel(Merc, MercUpgradeType)

    local Level = 0
    local MercUpgrades = Merc_GetSaveDataByID(Merc.NPC_ID)

    for _, upgrade in ipairs(MercUpgrades) do
        if upgrade.UpgradeType == MercUpgradeType then
            Level = upgrade.Level or 1
            break
        end
    end

    return Level
end

function Merc_GetUpgradePrice(Merc, MercUpgradeType)

    local Upgrade = Merc_GetUpgrade(Merc, MercUpgradeType)
    local Level   = Upgrade and Upgrade.Level or 0
    local Prices  = Upgrade and Upgrade.Price or SMercUpgrade.Price

    return Prices[Level + 1]
end

function Merc_Upgrade(Merc, MercUpgradeType)

    local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
    local Upgrade           = Merc_GetUpgrade(Merc, MercUpgradeType)

    if Upgrade == nil then
        local NewUpgrade    = {
            Level           = 0,
            Price           = table.copy(SMercUpgrade.Price),
            UpgradeType     = MercUpgradeType
        }

        table.insert(MercSaveData, NewUpgrade)

        Upgrade = NewUpgrade
    end

    if Upgrade.Level < const.Mercenary.UpgradeLimit then
        Upgrade.Level = Upgrade.Level + 1
    end

    -- Exception for Summmons: Reset on upgrade
    if MercUpgradeType == const.Mercenary.UpgradeType.Charges then
        MercSaveData.FightsLeft = Merc.FightsMax[Upgrade.Level + 1]
    end

    return Upgrade
end

function Merc_Fight(Merc, t)

    evt.Subtract("NPCs", QuestNPC)
    Merc_ConsumeCharge(Merc)

    local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)

    MercSaveData.Released       = true
    MercSaveData.ReleaseMap     = Game.Map.Name

    local UpgradeMonLevel       = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.Level) + 1
    local UpgradeHPLevel        = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.HP) + 1
    local UpgradeACLevel        = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.AC) + 1
    local UpgradeDmg1Level      = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.MeleeDamage) + 1
    --local UpgradeDmg1Level      = GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.MageRes)

    -- Monster
    local mon                   = SummonMonster(Merc.MonsterID, Party.X, Party.Y, Party.Z, false)

    -- User values
    mon.FullHitPoints           = Merc.FullHP[UpgradeHPLevel]
    mon.ArmorClass              = Merc.AC[UpgradeHPLevel]
    mon.Level                   = Merc.Level[UpgradeHPLevel]

    -- Default Variables
    mon.NPC_ID                  = QuestNPC
    mon.Group                   = 35
    mon.Hostile                 = false
    mon.Ally                    = 9999
    mon.Summoner                = 28
    mon.HostileType             = 0
    mon.Experience              = 0
    mon.ShowOnMap               = true
    mon.HP                      = mon.FullHitPoints
    mon.NoFlee                  = true

    -- Damage
    local meleeDmg              = Merc_ParseDamageString(Merc.Attack1[UpgradeDmg1Level])
    mon.Attack1.DamageAdd       = meleeDmg.DamageAdd
    mon.Attack1.DamageDiceCount = meleeDmg.DamageDiceCount
    mon.Attack1.DamageDiceSides = meleeDmg.DamageDiceSides

    -- Add Enhanced AI to the merc
    ModAI_Add(mon)
    ModAI_SetMode(mon, MercSaveData.AIBehavior)
    ModAI_FollowParty(mon)

    ExitScreen()
end

function Merc_Dismiss(Merc, t)

    evt.Add("NPCs", QuestNPC)

    local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
    MercSaveData.Released   = false
    MercSaveData.ReleaseMap = ""

    -- Remove Enhanced AI from database
    ModAI_Remove(mon)

    for _, mon in Map.Monsters do
        if mon.NPC_ID == QuestNPC then
            RemoveMonster(mon)
        end
    end

    -- Reset
    Timer(
        function()
            local UpgradeUseLevel   = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.Charges) or 1
            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
            MercSaveData.FightsLeft = Merc.FightsMax[UpgradeUseLevel+1] or 1
        end,
        const.Day, const.Hour, true)

    ExitScreen()
end

function Merc_IsSpecial(Merc, t)

    if Merc.Ability == nil              then return false end
    if type(Merc.Ability) ~= "string"   then return false end
    if string.len(Merc.Ability) == 0    then return false end
    return true
end

function Merc_IsSpecialTag(Merc, tag)

    if not Merc_IsSpecial(Merc, nil) then return false end

    for word in string.gmatch(tag, "([^,]+)") do
        if word == tag then
            return true
        end
    end

    return false
end

function Merc_ShowMessageAboutAbility(Merc, t)

    if Merc_IsSpecial(Merc, t) then
        Message(Merc.Credentials.TextSpecial)
    end
end

function Merc_ConsumeCharge(Merc)

    local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
    MercSaveData.FightsLeft = math.max(0, MercSaveData.FightsLeft - 1)
end

function Merc_ParseDamageString(damageString)

    local count, sides, add = damageString:match("(%d+)D(%d+)%+?(%d*)")

    count   = tonumber(count)
    sides   = tonumber(sides)
    add     = (add ~= "" and tonumber(add)) or 0

    local Attack1 = {
        DamageAdd       = add,
        DamageDiceCount = count,
        DamageDiceSides = sides,
    }

    return Attack1
end

-- @todo Rework/Finish
function Merc_ShowInfo(Merc)

    local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)

    local UpgMax            = const.Mercenary.UpgradeLimit
    local UpgradeHPLevel    = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.HP)
    local UpgradeACLevel    = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.AC)
    local UpgradeMonLevel   = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.Level)
    local UpgradeDmg1Level  = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.MeleeDamage)
    local UpgradeDmg2Level  = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.RangeDamage)
    local UpgradeSumLevel   = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.Charges)

    local hp                = Merc.FullHP[UpgradeHPLevel+1]       or Merc.FullHP[1]
    local ac                = Merc.AC[UpgradeACLevel+1]           or Merc.AC[1]
    local level             = Merc.Level[UpgradeMonLevel+1]       or Merc.Level[1]
    local attack1           = Merc.Attack1[UpgradeDmg1Level+1]    or Merc.Attack1[1]
    local attack2           = Merc.Attack2 and (Merc.Attack2[UpgradeDmg2Level+1]    or Merc.Attack2[1]) or nil
    local fightsLeft        = Merc.FightsMax[UpgradeSumLevel+1]   or Merc.FightsMax[1]

    local meleeStr          = ""
    local meleeUpdStr       = ""
    if (attack1 and string.len(attack1) > 0) then
        meleeStr            = string.format(MercTxt.MMercInfoMelee, attack1)
        meleeUpdStr         = string.format(MercTxt.MMercInfoMeleeUpgrade, UpgradeDmg1Level)
    end

    local rangedStr         = ""
    local rangedUpdStr      = ""
    if (attack2 and string.len(attack2) > 0) then
        rangedStr           = string.format(MercTxt.MMercInfoRanged, attack2)
        rangedUpdStr        = string.format(MercTxt.MMercInfoRangedUpgrade, UpgradeDmg2Level)
    end

    local Output = string.format(MercTxt.MMercInfo,
                            Merc.Name, level, hp, ac, meleeStr, rangedStr, fightsLeft,
                            UpgradeHPLevel, UpgradeACLevel, UpgradeMonLevel, meleeUpdStr, rangedUpdStr, UpgradeSumLevel)

    Message(Output)
end

function Merc_GetByID(mercID)

    for _, v in pairs(MercsDB) do
        if v.NPC_ID == mercID then
            return v
        end
    end

    return nil
end

function Merc_GetCredentialsByID(mercID)

    local Merc = Merc_GetByID(mercID)
    return Merc.Credentials
end

function Merc_GetSaveDataByID(mercID)

    for _, v in pairs(vars.MercSaveDataList) do
        if v.NPC_ID == mercID then
            return v
        end
    end

    return nil
end

-- For timer callback
function Merc_ResetChargesForAllMercs()

    for _, Merc in ipairs(MercsDB) do
        local UpgradeUseLevel   = Merc_GetUpgradeLevel(Merc, const.Mercenary.UpgradeType.Charges) or 1
        local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)

        MercSaveData.FightsLeft = Merc.FightsMax[UpgradeUseLevel+1] or 1
    end
end

-- Data Table
function Merc_ParseTables(Table)

    return TableLoader.ParseFile{
        Path             = "Data/Tables/Mercs.txt",
        Schema           = SMercSchema,
        Defaults         = SMerc,
        Out              = Table,
        KeyField         = "StringID",
        DetectDuplicates = true,
    }
end

function Merc_ParseCredentials(Table)

    local CredentialsTable = {}

    local ok = TableLoader.ParseFile{
        Path             = "Data/Tables/MercCredentials.txt",
        Schema           = SMercCredentialsSchema,
        Defaults         = SMercCredentials,
        Out              = CredentialsTable,
        KeyField         = "Name",
        DetectDuplicates = true,
    }

    if not ok then
        return
    end

    for i = 1, #CredentialsTable do
        local cred = CredentialsTable[i]

        for j = 1, #Table do
            if Table[j] ~= nil and Table[j].Name == cred.Name then
                Table[j].Credentials = table.copy(SMercCredentials)

                Table[j].Credentials.PriceHire       = cred.PriceHire       or SMercCredentials.PriceHire
                Table[j].Credentials.PriceReHire     = cred.PriceReHire     or SMercCredentials.PriceReHire
                Table[j].Credentials.PriceResurrect  = cred.PriceResurrect  or SMercCredentials.PriceResurrect

                Table[j].Credentials.TextAbout       = cred.TextAbout       or SMercCredentials.TextAbout
                Table[j].Credentials.TextHired       = cred.TextHired       or SMercCredentials.TextHired
                Table[j].Credentials.TextGreeting    = cred.TextGreeting    or SMercCredentials.TextGreeting
                Table[j].Credentials.TextFightTired  = cred.TextFightTired  or SMercCredentials.TextFightTired
                Table[j].Credentials.TextSpecial     = cred.TextSpecial     or SMercCredentials.TextSpecial
                Table[j].Credentials.TextFireAttempt = cred.TextFireAttempt or SMercCredentials.TextFireAttempt
                Table[j].Credentials.TextFireCancel  = cred.TextFireCancel  or SMercCredentials.TextFireCancel

                break
            end
        end
    end
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.BeforeLoadMap(WasInGame, WasLoaded)

    -- Note: Such way of declaring stuff fixes newgame/autosave bug
    -- Mercs: Available for Hire (Discovered mercs)
    if vars.MercNPCAvailableList == nil then
        vars.MercNPCAvailableList = {}
    end

    -- Mercs: Hired mercs
    if vars.MercNPCHiredList == nil then
        vars.MercNPCHiredList = {}
    end

    -- Mercs: Those who weren't picked up after fight
    if vars.MercNPCLostList == nil then
        vars.MercNPCLostList = {}
    end

    -- Mercs: stuff that needs to be carried with save files
    if vars.MercSaveDataList == nil then
        vars.MercSaveDataList = {}
    end

    if not WasInGame and not WasLoaded then

        -- Fill Savedata list
        for _, Merc in pairs(MercsDB) do
            local SaveData = table.copy(SMercSaveData)
            SaveData.NPC_ID = Merc.NPC_ID
            table.insert(vars.MercSaveDataList, SaveData)
        end

        -- Default available mercs
        if Game.Debug == true then
            for _, v in pairs(MercsDB) do
                Merc_MakeAvailableForHire(v.NPC_ID) -- all of them
            end
        else
            Merc_MakeAvailableForHire(525) -- Warder
        end
    end
end

function events.AfterMonsterAttacked(t, attacker)

    if t == nil then return end
    if attacker == nil then return end

    -- Prevent mercs turning hostile if party attacks them
    if t.Attacker.Player ~= nil then
        if t.Monster.NPC_ID > 0 then
            if ContainsNumber(MercNPCList, t.Monster.NPC_ID) then
                t.Monster.Ally      = 9000 + t.Monster.NPC_ID
                t.Monster.Hostile   = false
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)

    if mon == nil then return end
    if mon.NPC_ID == 0 then
        return
    end
    if not ContainsNumber(MercNPCList, mon.NPC_ID) then
        return
    end

    evt.Add("NPCs",mon.NPC_ID)

    local Merc                  = Merc_GetByID(mon.NPC_ID)
    local MercSaveData          = Merc_GetSaveDataByID(mon.NPC_ID)
    MercSaveData.Release        = false

    if (Merc_IsSpecialTag(Merc, const.Mercenary.Special.Undying)) then
        Merc_ConsumeCharge(Merc)
    else
        MercSaveData.Dead       = true
        MercSaveData.FightsLeft = 0
    end

    mon.NPC_ID = 0
end

function events.AfterLoadMap(WasInGame)

    -- Clear lost mercs
    if vars then
        if #vars.MercNPCLostList > 0 then
            for _, mon in Map.Monsters do
                if mon.NPC_ID > 0 and mon.Group == 35 then
                    if ContainsNumber(vars.MercNPCLostList, mon.NPC_ID) then
                        TableRemoveByValue(vars.MercNPCLostList, mon.NPC_ID)
                        RemoveMonster(mon)
                    end
                end
            end
        end
    end

    -- Reset charges
    local timeDifference = Game.Time - Game.Map.LastVisitTime
    if timeDifference > const.Day then
        Merc_ResetChargesForAllMercs()
    end

    Timer(
        function()
            Merc_ResetChargesForAllMercs()
        end,
        const.Day, const.Hour, false)
end

function events.GameInitialized2()

    Merc_ParseTables(MercsDB)
    Merc_ParseCredentials(MercsDB)

    for i = 1, #MercsDB do
        if MercsDB[i].Ability == nil then
            MercsDB[i].Ability = ""
        end

        if MercsDB[i].Credentials == nil then
            MercsDB[i].Credentials = table.copy(SMercCredentials)
        end
    end

    for i, Merc in ipairs(MercsDB) do
        MercNPCList[i] = Merc.NPC_ID
    end
end

-- EXAMPLE DECLARATION
-- MercsDB = {
--     Merc_NewGenericTable{
--         StringID            =   "warder",
--         Name                =   "Warder", 
--         NPC_ID              =   525, 
--         MonsterID           =   207,
--         Credentials         =   Merc_NewGenericTable{
--             PriceHire       =   2000,
--             PriceReHire     =   500,
--             PriceResurrect  =   500,
--             TextAbout       =   "The Warder can cover you in combat, great at taking hits but not so strong in offense. He's there to protect you while you destroy your enemies.",
--             TextHired       =   "The Warder is now at your beck and call. He'll stand as a bulwark between you and your foes. Use him wisely.",
--             TextGreeting    =   "Just so you know, I might not hit hard, but I can take a beating while you lot do the damage from behind me.",
--             TextFightTired  =   "I'm too tired, boss.",
--             TextSpecial     =   "",
--             TextFireAttempt =   "Off I go then. If you need me, I'll be at the merc guild, probably just standing around.",
--             TextFireCancel  =   "I was worried for a bit, boss."
--         }
--     },
--     Merc_NewGenericTable{
--         StringID            =   "ratman",
--         Name                =   "Ratman",
--         NPC_ID              =   526, 
--         MonsterID           =   270, 
--         Hired               =   false, 
--         Ability             =   "undying", 
--         FullHP              =   {60, 82, 104, 135}, 
--         AC                  =   {0,5,10,15}, 
--         Level               =   {3,7,12,18}, 
--         Attack1             =   {"2D2", "2D3+1", "2D4+2", "2D5+2"},
--         FightsMax           =   {2,4,6,8}, 
--         Credentials         =   Merc_NewGenericTable{
--             PriceHire       =   0,
--             PriceReHire     =   0,
--             PriceResurrect  =   0,
--             TextAbout       =   "Our newest recruit. Not the strongest fighter you'll find, but he's got a knack for slipping out of the tightest spots. He's sneaky, quick, and has an uncanny ability to dodge death.",
--             TextHired       =   "Consider it done. The Ratman is yours. He's eager to prove himself - just keep an eye on him in battle. He'll surprise you.",
--             TextGreeting    =   "Hey there, friends! Ratman at your service. Sneaky, sneaky - that's me. But don't worry, I've got your back... in my own special way.",
--             TextFightTired  =   "Phew, I'm all tuckered out. Using my tricks really takes it out of me. Mind if I take a little breather before the next round of mischief?",
--             TextSpecial     =   "Passive Ability:\n\nRatman's special ability prevents him from dying. Instead, when he would normally die, one summoner charge is consumed. \n\nHe will return to the party upon death.",
--             TextFireAttempt =   "Getting the boot, am I? Fair enough, fair enough. Can't say it's been boring! If you ever need a bit of sneaky again, you know where to find me.",
--             TextFireCancel  =   "Ah, changing our minds, are we? Can't say I blame you..."
--         }
--     }
-- }
