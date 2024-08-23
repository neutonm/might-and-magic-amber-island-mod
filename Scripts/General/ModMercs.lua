--[[

Mercenary Mechanics,
Author: Henrik Chukhran, 2022 - 2024

ToDo:
    - New Upgrade: Special
    - New Upgrade: Magical Resistances
    - Make sure that attacking them won't make other allies attack you
    - Summoned monsters must be immediately hostile against your hostiles
    - Finish/rework Merc_GetInfoString
    
]]

-- Enums
EMercUpgradeType    = {
    Null            = 0,
    HP              = 1,
    Level           = 2,
    Charges         = 3,
    AC              = 4,
    MageRes         = 5,
    MeleeDamage     = 6,
    RangeDamage     = 7,
    Spell           = 8
}

-- Structs
SMercUpgrade        = {
    Level           = 0,
    Price           = { 1000,2500,4000 },
    EMercUpgradeType= EMercUpgradeType.Null
}

-- Holds mutable data shared across save files
SMercSaveData       = {
    NPC_ID          = 0,
    FightsLeft      = 1,     
    Upgrades        = { SMercUpgrade },
    Released        = false,
    ReleaseMap      = "",
    Dead            = false,
    HiredOnce       = false
}

-- Required by guildmaster
SMercCredentials    = {
    PriceHire       = 2000,
    PriceReHire     = 500,
    PriceResurrect  = 500,
    TextAbout       = "I'm tough and rough.",
    TextHired       = "Hired!",
    TextGreeting    = "Greetings!",
    TextFightTired  = "Too tired.",
    TextSpecial     = "",
    TextFireAttempt = "Are you sure?",
    TextFireCancel  = "Phew, that was close!"
}

-- Holds non-mutable data for mercs
SMerc               = {
    StringID        = "none",
    Name            = "Unnamed",
    NPC_ID          = 525,
    MonsterID       = 0,
    Ability         = "",
    FullHP          = { [1] = 100, [2] = 125, [3] = 150, [4] = 180 },
    AC              = { [1] = 3, [2] = 8, [3] = 15, [4] = 20 },
    Level           = { [1] = 5, [2] = 10, [3] = 15, [4] = 20 },
    Attack1         = { [1] = "1D2", [2] = "2D3+1", [3] = "3D4+2", [4] = "4D4+3" },
    Attack2         = nil,
    FightsMax       = { [1] = 1, [2] = 2, [3] = 3, [4] = 4 },
    Credentials     = table.copy(SMercCredentials),
}

-- Tables
MercsDB             = {}
MercNPCList         = {}

-- Const 
const.Mercenary     = {
    UpgradeLimit    = 3,
    Special         = {
        Null        = "",
        Undying     = "undying"
    }
}

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
        if upgrade.EMercUpgradeType == MercUpgradeType then
            return upgrade
        end
    end

    return nil
end

function Merc_GetUpgradeLevel(Merc, MercUpgradeType)

    local Level = 0
    local MercUpgrades = Merc_GetSaveDataByID(Merc.NPC_ID)
    
    for _, upgrade in ipairs(MercUpgrades) do
        if upgrade.EMercUpgradeType == MercUpgradeType then
            Level = upgrade.Level or 1
            break
        end
    end

    return Level
end

function Merc_Upgrade(Merc, MercUpgradeType)
    
    local MercSaveData  = Merc_GetSaveDataByID(Merc.NPC_ID)
    local Upgrade       = Merc_GetUpgrade(Merc, MercUpgradeType)

    if Upgrade == nil then
        local NewUpgrade = {
            Level            = 1,
            Price            = { 1000,2000,3000 },
            EMercUpgradeType = MercUpgradeType
        }
        
        table.insert(MercSaveData, NewUpgrade)

        Upgrade = table.copy(NewUpgrade)
    else
        if Upgrade.Level < const.Mercenary.UpgradeLimit then
            Upgrade.Level = Upgrade.Level + 1
        end
    end

    -- Exception for Summmons: Reset on upgrade
    if MercUpgradeType == EMercUpgradeType.Charges then
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
    
    local UpgradeMonLevel       = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.Level) + 1
    local UpgradeHPLevel        = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.HP) + 1
    local UpgradeACLevel        = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.AC) + 1
    local UpgradeDmg1Level      = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.MeleeDamage) + 1
    --local UpgradeDmg1Level      = GetUpgradeLevel(Merc, EMercUpgradeType.MageRes)

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

    ExitScreen()
end

function Merc_Dismiss(Merc, t)

    evt.Add("NPCs", QuestNPC)

    local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
    MercSaveData.Released   = false
    MercSaveData.ReleaseMap = ""
    
    for _, mon in Map.Monsters do
        if mon.NPC_ID == QuestNPC then
            RemoveMonster(mon)
        end
    end

    -- Reset
    Timer(
        function()
            local UpgradeUseLevel   = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.Charges) or 1
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
    local UpgradeHPLevel    = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.HP)
    local UpgradeACLevel    = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.AC)
    local UpgradeMonLevel   = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.Level)
    local UpgradeDmg1Level  = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.MeleeDamage)
    local UpgradeDmg2Level  = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.RangeDamage)
    local UpgradeSumLevel   = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.Charges)

    local hp                = Merc.FullHP[UpgradeHPLevel+1]       or Merc.FullHP[1]
    local ac                = Merc.AC[UpgradeACLevel+1]           or Merc.AC[1]
    local level             = Merc.Level[UpgradeMonLevel+1]       or Merc.Level[1]
    local attack1           = Merc.Attack1[UpgradeDmg1Level+1]    or Merc.Attack1[1]
    local attack2           = Merc.Attack2[UpgradeDmg2Level+1]    or Merc.Attack2[1]
    local fightsLeft        = Merc.FightsMax[UpgradeSumLevel+1]   or Merc.FightsMax[1]

    local meleeStr          = ""
    local meleeUpdStr       = ""
    if (attack1 and string.len(attack1) > 0) then
        meleeStr            = string.format("With my trusty weapons, I deliver a formidable melee assault, capable of inflicting %s damage.\n\n", attack1)
        meleeUpdStr         = string.format("Melee: %d/3\n", UpgradeDmg1Level)
    end

    local rangedStr         = ""
    local rangedUpdStr      = ""
    if (attack2 and string.len(attack2) > 0) then
        rangedStr           = string.format("I can perform a ranged attack, dealing %s damage to your target.\n\n", attack2)
        rangedUpdStr        = string.format("Ranged: %d/3\n", UpgradeDmg2Level)
    end

    local Output = string.format("Greetings!\n\nI am known as %s, a mercenary combatant of Level %d.\n\n"..
                            "My have a robust health pool of %d and an armor class of %d.\n\n"..
                            "%s"..
                            "%s"..
                            "You have my allegiance for %d summons each day, ready to stand by your side!\n\n"..
                            "Upgrades: \nHit Points: %d/3\nArmor Class: %d/3\nLevel: %d/3\n%s%sSummons: %d/3",
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
        local UpgradeUseLevel   = Merc_GetUpgradeLevel(Merc, EMercUpgradeType.Charges) or 1
        local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)

        MercSaveData.FightsLeft = Merc.FightsMax[UpgradeUseLevel+1] or 1
    end
end

-- Game Events
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

        -- Default avaiable mercs
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

-- Data Table
function ParseMercTables(Table)

    -- Core data
    local FilePath = "Data/Tables/Mercs.txt"
	local File	= io.open(FilePath)
	if not File then
		return
	end

	local LineIt = File:lines()
	LineIt()

    local Counter = 1
	for line in LineIt do
		local Words = string.split(line, "\9")
		if string.len(Words[1]) == 0 then
			break
		end

		Table[Counter] = table.copy(SMerc)

		if string.len(Words[2]) > 0 then
			Table[Counter].StringID     = tostring(Words[2])
		end

		if string.len(Words[3]) > 0 then
			Table[Counter].Name 	    = tostring(Words[3])
		end

        if string.len(Words[4]) > 0 then
			Table[Counter].NPC_ID 	    = tonumber(Words[4])
		end

        if string.len(Words[5]) > 0 then
			Table[Counter].MonsterID    = tonumber(Words[5])
		end
        
        if string.len(Words[6]) > 0 then
			Table[Counter].Ability      = tostring(Words[6])
		end
        
        Table[Counter].FullHP = {}
        for i = 0, 3 do
            if string.len(Words[i+7]) > 0 then
                Table[Counter].FullHP[i+1] = tonumber(Words[i+7])
            end
        end

        Table[Counter].AC = {}
        for i = 0, 3 do
            if string.len(Words[i+11]) > 0 then
                Table[Counter].AC[i+1] = tonumber(Words[i+11])
            end
        end
        
        Table[Counter].Level = {}
        for i = 0, 3 do
            if string.len(Words[i+15]) > 0 then
                Table[Counter].Level[i+1] = tonumber(Words[i+15])
            end
        end

        Table[Counter].Attack1 = {}
        for i = 0, 3 do
            if string.len(Words[i+19]) > 0 then
                Table[Counter].Attack1[i+1] = tostring(Words[i+19])
            end
        end

        Table[Counter].Attack2 = {}
        for i = 0, 3 do
            if string.len(Words[i+23]) > 0 then
                Table[Counter].Attack2[i+1] = tostring(Words[i+23])
            end
        end

        Table[Counter].FightsMax = {}
        for i = 0, 3 do
            if string.len(Words[i+27]) > 0 then
                Table[Counter].FightsMax[i+1] = tonumber(Words[i+27])
            end
        end

        Counter = Counter + 1
	end

	io.close(File)

    -- Credentials
    FilePath    = "Data/Tables/MercCredentials.txt"
	File	    = io.open(FilePath)
	if not File then
		return
	end

	LineIt = File:lines()
	LineIt()

    Counter = 1

    -- Process escape sequences
    local function procEsc(str)
        str = str:gsub("\\n", "\n")    -- Convert \n to newline
        return str
    end

	for line in LineIt do
        
        local Words = string.split(line, "\9")
		if string.len(Words[1]) == 0 then
			break
		end

		Table[Counter].Credentials = table.copy(SMercCredentials)

		if string.len(Words[3]) > 0 then
			Table[Counter].Credentials.PriceHire = tonumber(Words[3])
		end
        if string.len(Words[4]) > 0 then
			Table[Counter].Credentials.PriceReHire = tonumber(Words[4])
		end
        if string.len(Words[5]) > 0 then
			Table[Counter].Credentials.PriceResurrect = tonumber(Words[5])
		end
        if string.len(Words[6]) > 0 then
			Table[Counter].Credentials.TextAbout = procEsc(tostring(Words[6]))
		end
        if string.len(Words[7]) > 0 then
			Table[Counter].Credentials.TextHired = procEsc(tostring(Words[7]))
		end
        if string.len(Words[8]) > 0 then
			Table[Counter].Credentials.TextGreeting = procEsc(tostring(Words[8]))
		end
        if string.len(Words[9]) > 0 then
			Table[Counter].Credentials.TextFightTired = procEsc(tostring(Words[9]))
		end
        if string.len(Words[10]) > 0 then
			Table[Counter].Credentials.TextSpecial = procEsc(tostring(Words[10]))
		end
        if string.len(Words[11]) > 0 then
			Table[Counter].Credentials.TextFireAttempt = procEsc(tostring(Words[11]))
		end
        if string.len(Words[12]) > 0 then
			Table[Counter].Credentials.TextFireCancel = procEsc(tostring(Words[12]))
		end

        Counter = Counter + 1
    end

    io.close(File)
end

-- Mercenaries
ParseMercTables(MercsDB) -- load from Datatable at "Data/Tables/<>.txt"
for i, Merc in ipairs(MercsDB) do
    MercNPCList[i] = Merc.NPC_ID
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
