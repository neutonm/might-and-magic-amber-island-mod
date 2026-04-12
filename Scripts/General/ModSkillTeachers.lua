--[[
Description:    Expert teachers logic: mastery + teaching + 'Teachers' database 
Author:         Henrik Chukhran, 2022 - 2026

Overview:
    This module implements custom skill teachers for Amber Island (MM7).
    Data is loaded from Data/Tables/Teachers.txt into TeachersDB.
    Each teacher can:
        - teach a new skill
        - teach a target mastery
        - recommend another teacher

    Main entry points:
        NPCTeacher(id|npcId|table)  - builds NPC topics for one teacher
        Teacher_FindByID(id)        - returns teacher table by string ID
        Teacher_FindByNPC(npcId)    - returns teacher table by NPC id

    Notes:
        - Skill/mastery description text can be raw text or NPCText numeric ids
        - Recommendation text can also be raw text or NPCText numeric ids

TODO:
    - bug:  When mastery topic is clicked, it displays null branch topics.
            Requires all other topics to be set t.Branch = "" manually that
            come after (or before) NPCTeacher(<>). Needs automated solution.
--]]

local A, B, C, D, E, F      = 0, 1, 2, 3, 4, 5
local matchEmptyOrSpaceFmt  = "^%s*(.-)%s*$"

------------------------------------------------------------------------------
-- FORWARD DECLARE
------------------------------------------------------------------------------

local ResolveSkill
local ResolveMastery
local ResolveNPCText
local ProcessEscapes

------------------------------------------------------------------------------
-- GLOBALS
------------------------------------------------------------------------------

TeachersDB          = {}

-- Teacher Structure
STeacher            = {
    ID              = "default",
    Name            = "Unknown",
    NPC_ID          = 0,
    Map             = "amber.odt",
    X               = 0,
    Y               = 0,
    Z               = 0,
    Skill           = const.Skills.Staff,
    Mastery         = const.Expert,
    Gold            = 500,
    GoldW           = 100,
    GoldBuySkill    = 400,
    SkillPoints     = 4,
    SkillPointsW    = 5,
    AllowSkillBuy   = 1,
    RecommendNPC    = 0,
    TxtMasterDes    = 0,
    TxtRecommendDes = 0,
    Autonote        = "",
    TxtSkillLearned = "",
    TxtSkillKnown   = "",
    TxtNoGold       = "",
    TxtWrongClass   = "",
}

function Teacher_FindByNPC(npcId)

    if npcId == nil or npcId == 0 then
        return nil
    end

    for i = 1, #TeachersDB do
        if TeachersDB[i] ~= nil and TeachersDB[i].NPC_ID == npcId then
            return TeachersDB[i]
        end
    end

    return nil
end

function Teacher_FindByID(id)

    if id == nil or id == "" then
        return nil
    end

    for i = 1, #TeachersDB do
        if TeachersDB[i] ~= nil and TeachersDB[i].ID == id then
            return TeachersDB[i]
        end
    end

    return nil
end

function Teacher_Register(t)

    --[[
    Example:
        Teacher_Register({
        ID              = "teacher_fire_master",
        NPC_ID          = 1234,
        Name            = "Fire Master",
        Skill           = "Fire",
        Mastery         = "Master",
        Gold            = 2000,
        SkillPoints     = 8,
        AllowSkillBuy   = 0,
        TxtMasterDes    = 128,
    })
    --]]

    local newt = nil

    if type(t) ~= "table" then
        return nil
    end

    if t.ID ~= nil and t.ID ~= "" and Teacher_FindByID(t.ID) ~= nil then
        return nil
    end

    if t.NPC_ID ~= nil and t.NPC_ID ~= 0 and Teacher_FindByNPC(t.NPC_ID) ~= nil then
        return nil
    end

    newt = table.copy(STeacher)

    for k, v in pairs(t) do
        newt[k] = v
    end

    newt.Skill   = ResolveSkill(newt.Skill)     or STeacher.Skill
    newt.Mastery = ResolveMastery(newt.Mastery) or STeacher.Mastery

    table.insert(TeachersDB, newt)
    return newt
end

-- Data Table
function Teacher_ParseTables(Table)

    -- Core data
    local FilePath = "Data/Tables/Teachers.txt"
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

		Table[Counter] = table.copy(STeacher)

		if string.len(Words[2]) > 0 then
			Table[Counter].ID               = tostring(Words[2])
		end

        if string.len(Words[3]) > 0 then
			Table[Counter].NPC_ID           = tonumber(Words[3])
		end

		if string.len(Words[4]) > 0 then
			Table[Counter].Name 	        = tostring(Words[4])
		end

        if string.len(Words[5]) > 0 then
			Table[Counter].Map 	            = tostring(Words[5])
		end

        if string.len(Words[6]) > 0 then
			Table[Counter].X                = tonumber(Words[6])
		end
        
        if string.len(Words[7]) > 0 then
			Table[Counter].Y                = tonumber(Words[7])
		end

        if string.len(Words[8]) > 0 then
			Table[Counter].Z                = tonumber(Words[8])
		end

        if string.len(Words[9]) > 0 then
			Table[Counter].Skill            = ResolveSkill(Words[9])
		end

        if string.len(Words[10]) > 0 then
			Table[Counter].Mastery          = ResolveMastery(Words[10])
		end

        if string.len(Words[11]) > 0 then
			Table[Counter].Gold             = tonumber(Words[11])
		end

        if string.len(Words[12]) > 0 then
			Table[Counter].GoldW            = tonumber(Words[12])
		end

        if string.len(Words[13]) > 0 then
			Table[Counter].GoldBuySkill     = tonumber(Words[13])
		end

        if string.len(Words[14]) > 0 then
			Table[Counter].SkillPoints      = tonumber(Words[14])
		end

        if string.len(Words[15]) > 0 then
			Table[Counter].SkillPointsW     = tonumber(Words[15])
		end

        if string.len(Words[16]) > 0 then
			Table[Counter].AllowSkillBuy    = tonumber(Words[16])
		end

        if string.len(Words[17]) > 0 then
			Table[Counter].RecommendNPC     = tonumber(Words[17])
		end

        if string.len(Words[18]) > 0 then
			Table[Counter].TxtMasterDes     = tostring(Words[18])
		end

        if string.len(Words[19]) > 0 then
			Table[Counter].TxtRecommendDes  = tostring(Words[19])
		end

        if string.len(Words[20]) > 0 then
			Table[Counter].Autonote         = tostring(ProcessEscapes(Words[20]))
		end

        if string.len(Words[21]) > 0 then
			Table[Counter].TxtSkillLearned  = tostring(Words[21])
		end

        if string.len(Words[22]) > 0 then
			Table[Counter].TxtSkillKnown    = tostring(Words[22])
		end

        if string.len(Words[23]) > 0 then
			Table[Counter].TxtNoGold        = tostring(Words[23])
		end

        if string.len(Words[24]) > 0 then
			Table[Counter].TxtWrongClass    = tostring(Words[24])
		end

        Counter = Counter + 1
	end

	io.close(File)
end

function NPCTeacher(teacherID)

    local dbt               = nil
    local stdDes            = nil
    local learnTexts        = {}
    local recommendTeacher  = nil
    local recommendDes      = nil

    -- find teacher
    if type(teacherID) == "table" then
        dbt = teacherID
    elseif type(teacherID) == "number" then
        dbt = Teacher_FindByNPC(teacherID)
    elseif type(teacherID) == "string" then
        dbt = Teacher_FindByID(teacherID)
    end

    if dbt == nil then
        return nil
    end

    -- QuestNPC = dbt.NPC_ID

    -- default description text from NPCText, if any
    stdDes = ResolveNPCText(dbt.TxtMasterDes)

    --  Mastery Topic
    NPCTopicMasterSkill({
        Slot                = A,
        QuestGold           = IsWarrior() and dbt.GoldW        or dbt.Gold,
        SkillRequire        = IsWarrior() and dbt.SkillPointsW or dbt.SkillPoints,
        SkillType           = dbt.Skill,
        SkillMastery        = dbt.Mastery,
        SkillDes            = stdDes or "",
    })

    -- Buy Skill Topic
    if dbt.AllowSkillBuy ~= 0 then

        
        learnTexts = {
            SkillDone       = dbt.TxtSkillLearned:match(matchEmptyOrSpaceFmt)   ~= "" and dbt.TxtSkillLearned   or NPCTopicTeachSkillBase.Texts.SkillDone,
            SkillHasIt      = dbt.TxtSkillKnown:match(matchEmptyOrSpaceFmt)     ~= "" and dbt.TxtSkillKnown     or NPCTopicTeachSkillBase.Texts.SkillHasIt,
            SkillDoesnt     = dbt.TxtNoGold:match(matchEmptyOrSpaceFmt)         ~= "" and dbt.TxtNoGold         or NPCTopicTeachSkillBase.Texts.SkillDoesnt,
            SkillBadClass   = dbt.TxtWrongClass:match(matchEmptyOrSpaceFmt)     ~= "" and dbt.TxtWrongClass     or NPCTopicTeachSkillBase.Texts.SkillBadClass,
        }

        NPCTopicTeachSkill({
            Slot            = B,
            QuestGold       = dbt.GoldBuySkill,
            SkillType       = dbt.Skill,
            Texts           = learnTexts,
        })
    end

    -- Recommend teacher topic
    recommendTeacher = Teacher_FindByNPC(dbt.RecommendNPC)
    if recommendTeacher ~= nil then

        recommendDes = ResolveNPCText(dbt.TxtRecommendDes)

        NPCTopicRecommendTeacher({
            Slot            = C,
            RecommendNPC    = dbt.RecommendNPC,
            RecommendDes    = recommendDes or "",
        })
    end

    return dbt
end

------------------------------------------------------------------------------
-- LOCALS VARS
------------------------------------------------------------------------------

local EnumMasteryNames = {}

local PromoLines = {
    [const.Class.Knight]    = {const.Class.Knight,    const.Class.Cavalier,    const.Class.Champion,     const.Class.BlackKnight},
    [const.Class.Thief]     = {const.Class.Thief,     const.Class.Rogue,       const.Class.Spy,          const.Class.Assassin},
    [const.Class.Monk]      = {const.Class.Monk,      const.Class.Initiate,    const.Class.Master,       const.Class.Ninja},
    [const.Class.Paladin]   = {const.Class.Paladin,   const.Class.Crusader,    const.Class.Hero,         const.Class.Villain},
    [const.Class.Archer]    = {const.Class.Archer,    const.Class.WarriorMage, const.Class.MasterArcher, const.Class.Sniper},
    [const.Class.Ranger]    = {const.Class.Ranger,    const.Class.Hunter,      const.Class.RangerLord,   const.Class.BountyHunter},
    [const.Class.Cleric]    = {const.Class.Cleric,    const.Class.Priest,      const.Class.PriestLight,  const.Class.PriestDark},
    [const.Class.Druid]     = {const.Class.Druid,     const.Class.GreatDruid,  const.Class.ArchDruid,    const.Class.Warlock},
    [const.Class.Sorcerer]  = {const.Class.Sorcerer,  const.Class.Wizard,      const.Class.ArchMage,     const.Class.Lich},
}

local MasteryMap = {
    ["1"]                   = const.Novice,
    ["2"]                   = const.Expert,
    ["3"]                   = const.Master,
    ["4"]                   = const.GM,
    novice                  = const.Novice,
    n                       = const.Novice,
    expert                  = const.Expert,
    e                       = const.Expert,
    master                  = const.Master,
    m                       = const.Master,
    gm                      = const.GM,
    grandmaster             = const.GM,
    grand                   = const.GM,
}

local SkillNameMap = {
    staff                   = const.Skills.Staff,
    sword                   = const.Skills.Sword,
    dagger                  = const.Skills.Dagger,
    axe                     = const.Skills.Axe,
    spear                   = const.Skills.Spear,
    bow                     = const.Skills.Bow,
    mace                    = const.Skills.Mace,
    blaster                 = const.Skills.Blaster,
    shield                  = const.Skills.Shield,
    leather                 = const.Skills.Leather,
    chain                   = const.Skills.Chain,
    plate                   = const.Skills.Plate,

    fire                    = const.Skills.Fire,
    firemagic               = const.Skills.Fire,
    air                     = const.Skills.Air,
    airmagic                = const.Skills.Air,
    water                   = const.Skills.Water,
    watermagic              = const.Skills.Water,
    earth                   = const.Skills.Earth,
    earthmagic              = const.Skills.Earth,
    spirit                  = const.Skills.Spirit,
    spiritmagic             = const.Skills.Spirit,
    mind                    = const.Skills.Mind,
    mindmagic               = const.Skills.Mind,
    body                    = const.Skills.Body,
    bodymagic               = const.Skills.Body,
    light                   = const.Skills.Light,
    lightmagic              = const.Skills.Light,
    dark                    = const.Skills.Dark,
    darkmagic               = const.Skills.Dark,

    identifyitem            = const.Skills.IdentifyItem,
    merchant                = const.Skills.Merchant,
    repair                  = const.Skills.Repair,
    bodybuilding            = const.Skills.Bodybuilding,
    meditation              = const.Skills.Meditation,
    perception              = const.Skills.Perception,
    diplomacy               = const.Skills.Diplomacy,
    thievery                = const.Skills.Thievery,
    disarmtraps             = const.Skills.DisarmTraps,
    dodging                 = const.Skills.Dodging,
    unarmed                 = const.Skills.Unarmed,
    identifymonster         = const.Skills.IdentifyMonster,
    armsmaster              = const.Skills.Armsmaster,
    stealing                = const.Skills.Stealing,
    alchemy                 = const.Skills.Alchemy,
    learning                = const.Skills.Learning,
}

local BaseClass = {}
for _, line in pairs(PromoLines) do
    for _, classId in ipairs(line) do
        BaseClass[classId] = line[1]
    end
end

------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
------------------------------------------------------------------------------

local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

ProcessEscapes = function(str)
    -- Convert \n to newline
    str = str:gsub("\\n", "\n")    
    -- Convert color symbol
    str = str:gsub("\\012", "\012")

    return str
end

-- Formats teacher description text.
-- Supports explicit placeholders %40 = gold, %41 = required skill level.
-- If no placeholders are present, tries to replace two raw numbers in text.
local function FormatTeacherString(str, t)

    if str == nil or str == "" or t == nil then
        return str
    end

    local skillMax  = 32
    local n1        = 0
    local n2        = 0
    local arg1      = nil
    local arg2      = nil
    local out       = {}
    local last      = 1
    local fmt       = nil
    local nums      = {}

    -- Extra special codes:
    -- [%40] QuestGold
    -- [%41] SkillRequire
    if str:find("%%40") or str:find("%%41") then

        local args  = {}
        fmt         = str:gsub("%%(%d%d)", function(code)
            if code == "40" then
                table.insert(args, t.QuestGold)
                return "\01265523%d\01200000"
            elseif code == "41" then
                table.insert(args, t.SkillRequire)
                return "\01265523%d\01200000"
            else
                return "%" .. code
            end
        end)

        return string.format(fmt, unpack(args))
    end

    -- no codes? detect 2 raw numbers in text
    for s, num, e in str:gmatch("()(%d+)()") do
        table.insert(nums, {
            startPos    = s,
            endPos      = e - 1,
            value       = tonumber(num)
        })
    end

    -- enforce only 2 numbers (gold and skill points)
    if #nums ~= 2 then
        return str
    end

    n1 = nums[1].value
    n2 = nums[2].value

    -- guess what is what: gold and skill level
    if n1 <= skillMax and n2 > skillMax then
        arg1, arg2 = t.SkillRequire, t.QuestGold
    elseif n2 <= skillMax and n1 > skillMax then
        arg1, arg2 = t.QuestGold, t.SkillRequire
    else
        if n1 >= n2 then
            arg1, arg2 = t.QuestGold, t.SkillRequire
        else
            arg1, arg2 = t.SkillRequire, t.QuestGold
        end
    end

    -- replace two found numbers
    for i = 1, 2 do
        local n = nums[i]
        table.insert(out, str:sub(last, n.startPos - 1))
        table.insert(out, "\01265523%d\01200000")
        last = n.endPos + 1
    end

    table.insert(out, str:sub(last))
    fmt = table.concat(out)

    return string.format(fmt, arg1, arg2)
end

ResolveSkill = function(value)

    local n
    local s
    local key

    if value == nil then
        return nil
    end

    -- number?
    n = tonumber(value)
    if n ~= nil then
        return n
    end

    s = tostring(value)

    -- trim
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")

    if s == "" then
        return nil
    end

    if const.Skills[s] ~= nil then
        return const.Skills[s]
    end

    -- normalize
    key = s:lower()
    key = key:gsub("[%s_%-]+", "")

    return SkillNameMap[key]
end

ResolveMastery = function(value)

    local n
    local s
    local key

    if value == nil then
        return nil
    end

    -- number?
    n = tonumber(value)
    if n ~= nil then
        return n
    end

    s = tostring(value)

    -- trim
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")

    if s == "" then
        return nil
    end

    key = s:lower()
    key = key:gsub("[%s_%-]+", "")

    return MasteryMap[key]
end

ResolveNPCText = function(value)
    local n = tonumber(value)
    if value ~= nil and n then
        return Game.NPCText[n]
    end
    return value
end

local function GetClassMaxMastery(classId, skillId)
    for sk, maxMastery in EnumAvailableSkills(classId) do
        if sk == skillId then
            return maxMastery
        end
    end
    return 0
end

local function GetPlayerClassSkillInfo(player, skillId)
    for sk, maxMastery in EnumAvailableSkills(player.Class) do
        if sk == skillId then
            local level, mastery = SplitSkill(player.Skills[skillId])
            return true, level, mastery, maxMastery
        end
    end
    return false, 1, const.Novice, 0
end

-- Promotion requirements are inferred from class skill caps.
-- If wanted mastery is not available to current class, this returns
-- the same promotion requirement text used by the original game.
local function GetPromotionRequirementText(playerClass, skillId, wantedMastery)

    local line      = 0
    local curMax    = 0

    line = PromoLines[BaseClass[playerClass]]
    if not line then
        return nil
    end

    curMax = GetClassMaxMastery(playerClass, skillId)
    if curMax >= wantedMastery then
        return nil
    end

    if GetClassMaxMastery(line[2], skillId) >= wantedMastery then
        return string.format(Game.GlobalTxt[633], Game.ClassNames[line[2]])
    end

    local a = GetClassMaxMastery(line[3], skillId) >= wantedMastery
    local b = GetClassMaxMastery(line[4], skillId) >= wantedMastery

    if a and b then
        return string.format(Game.GlobalTxt[634], Game.ClassNames[line[3]], Game.ClassNames[line[4]])
    elseif a then
        return string.format(Game.GlobalTxt[633], Game.ClassNames[line[3]])
    elseif b then
        return string.format(Game.GlobalTxt[633], Game.ClassNames[line[4]])
    end

    return nil
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.GameInitialized2()
    Teacher_ParseTables(TeachersDB)
end

function events.EnterNPC(npc)

    for i = 1, #TeachersDB do
        if TeachersDB[i] ~= nil and TeachersDB[i].NPC_ID == npc then
            if TeachersDB[i].Autonote ~= nil and TeachersDB[i].Autonote:match(matchEmptyOrSpaceFmt) ~= "" then
                local autonoteStr = ":"..TeachersDB[i].ID
                if not CheckAutonote(autonoteStr) then
                    AddAutonote(autonoteStr)
                end
            end
        end
    end
end

function events.BeforeLoadMap(WasInGame, WasLoaded)

    -- GlobalTxt:
    -- [431] Normal
    -- [433] Expert
    -- [432] Master
    -- [225] Grandmaster
    if next(EnumMasteryNames) == nil then
        EnumMasteryNames = {
            [1] = Game.GlobalTxt[431], -- null
            [2] = Game.GlobalTxt[433],
            [3] = Game.GlobalTxt[432],
            [4] = Game.GlobalTxt[225]
        }
    end

end

-- function events.CanTeachSkillMastery(t)
--     Message(string.format(
--         "CanTeachSkillMastery fired | skill=%d mastery=%d oldcost=%d",
--         t.Skill, t.Mastery, t.Cost
--     ))

--     t.Cost = 1
--     t.Text = string.format("TEST PRICE: %d gold", t.Cost)
-- end

------------------------------------------------------------------------------
-- TEACH SKILL
------------------------------------------------------------------------------

function NPCTopicTeachSkillBase_GetTopic(t)

    -- GlobalTxt:
    -- [394] Unknown
    -- [535] Learn

    local SkillName = ""
    SkillName       = Game.SkillNames[t.SkillType] or Game.GlobalTxt[394]

    return string.format("%s: %s (%sg)", Game.GlobalTxt[535], SkillName, t.QuestGold) 
end

function NPCTopicTeachSkillBase_Done(t)

    Message(ProcessEscapes(t.Texts.SkillDone))
    PlayerSetSkill(Game.CurrentPlayer, t.SkillType, 1, const.Novice)

    evt.Add("Exp",0)
    evt.FaceAnimation(Game.CurrentPlayer, const.FaceAnimation.SmileHuge)
end

function NPCTopicTeachSkillBase_CheckDone(t)

    local IsProperClass = false
    local hasIt         = PlayerHasSkill(Game.CurrentPlayer, t.SkillType)
    local player        = Party[Game.CurrentPlayer]

    -- Is skill available for the class?
    IsProperClass       = GetPlayerClassSkillInfo(player, t.SkillType)
    if IsProperClass == false then
        Message(ProcessEscapes(t.Texts.SkillBadClass))
        return false
    end

    -- Is skill already learned?
    if hasIt == true then
        Message(ProcessEscapes(t.Texts.SkillHasIt))
    elseif not evt.Cmp("Gold", t.QuestGold) then -- no gold?
        Message(ProcessEscapes(t.Texts.SkillDoesnt))
    end

    return hasIt == false
end

NPCTopicTeachSkillBase = {
    Slot 			    = 	B,
    Branch              =   "",
    GetTopic 	        = 	function(t) return NPCTopicTeachSkillBase_GetTopic(t) end,
	Done			    =	function(t) NPCTopicTeachSkillBase_Done(t) end,
    CheckDone		    =	function(t) return NPCTopicTeachSkillBase_CheckDone(t) end,
    NeverGiven		    =	true,
    NeverDone		    =	true,
    QuestGold		    =	400,
    SkillType           =   const.Skills.Staff,
    Texts               =   {
        SkillDone       =   "Well done! You've taken the first step towards mastering the skill. Keep honing your abilities, and you'll soon become a true expert!",
        SkillHasIt      =   "Ah, I see you're \01265523already proficient\01200000 in the skill! Your prowess is evident. If there's anything else you need to refine your skills, let me know.",
        SkillDoesnt     =   "It appears you \01265523don't have enough gold\01200000 to learn the skill at the moment. Return when you have the required amount, and I'll be happy to share my knowledge with you.",
        SkillBadClass   =   "Unfortunately, \01265523your current class prevents you from learning this skill\01200000. Each class has its own strengths and limitations. Seek skills that align with your chosen profession."
    },
}

function NPCTopicTeachSkill(t)
	table.copy(NPCTopicTeachSkillBase, t)
	NPCTopicTeachSkillBase.Slot = NPCTopicTeachSkillBase.Slot and NPCTopicTeachSkillBase.Slot + 1
	return Quest(t)
end

------------------------------------------------------------------------------
-- MASTER SKILL
------------------------------------------------------------------------------

function NPCTopicMasterSkillBase_GetTopic(t)

    -- GlobalTxt:
    -- [394] Unknown

    local SkillMasteryName  = ""
    local SkillName         = ""
    SkillMasteryName        = EnumMasteryNames[t.SkillMastery]
    SkillName               = Game.SkillNames[t.SkillType] or Game.GlobalTxt[394]

    return string.format("%s: %s", SkillMasteryName, SkillName)
end

function NPCTopicMasterSkillTeach_GetTopic(t)

    -- GlobalTxt:
    -- [394] Unknown
    -- [534] Become %s in %s for %lu gold

    local SkillMasteryName  = ""
    local SkillName         = ""
    local SkillCheckRetStr  = ""
    local GlobalTxtFmt      = Game.GlobalTxt[534]

    SkillMasteryName        = EnumMasteryNames[t.SkillMastery]
    SkillName               = Game.SkillNames[t.SkillType] or Game.GlobalTxt[394]
    _, SkillCheckRetStr     = NPCTopicMasterSkillTeach_CheckDone(t)
    GlobalTxtFmt            = GlobalTxtFmt:gsub("%%lu", "%%d") -- lua can't format internal game str with "%lu", but %d can

    if SkillCheckRetStr == "" then
        SkillCheckRetStr    = string.format(GlobalTxtFmt, SkillMasteryName, SkillName, t.QuestGold)
    end

    return SkillCheckRetStr
end

function NPCTopicMasterSkillTeach_Done(t)

    Message(t.Greet)
    PlayerSetSkill(
        Game.CurrentPlayer,
        t.SkillType,
        Party[Game.CurrentPlayer].Skills[t.SkillType],
        t.SkillMastery)

    evt.Add("Exp",0)
    evt.FaceAnimation(Game.CurrentPlayer, const.FaceAnimation.SmileHuge)
end

function NPCTopicMasterSkillTeach_CheckDone(t)

    -- GlobalTxt:
    -- [632] This skill level can not be learned by the %s class.
    -- [633] You have to be promoted to %s to learn this skill level.
    -- [634] You have to be promoted to %s or %s to learn this skill level.
    -- [155] You don't have enough gold

    -- NPCText:
    -- [128] You don't meet the requirements, and cannot be taught until you do.
    -- [129] You are already an expert in this skill.
    -- [130] You are already a master in this skill.
    -- [131] You are already a grandmaster in this skill.

    local hasIt                 = PlayerHasSkill(Game.CurrentPlayer, t.SkillType)
    local Player                = Party[Game.CurrentPlayer]
    local retStr                = ""
    local promoStr              = nil

    -- fetch skill data
    local IsProperClass, skillLevel, skillMastery = GetPlayerClassSkillInfo(Player, t.SkillType)

    -- Is skill available for the class?
    if IsProperClass == false then
        retStr = string.format(Game.GlobalTxt[632], Game.ClassNames[Player.Class])
        return false, retStr
    end

    -- Is skill already learned?
    if hasIt == true then
        if skillMastery >= t.SkillMastery then -- Are you already expert/master/gm?
            retStr = Game.NPCText[129 + (skillMastery - 2)]
            return false, retStr
        elseif not evt.Cmp("Gold", t.QuestGold) then -- no gold?
            retStr = Game.GlobalTxt[155]
        end
    end

    -- Do we need promotion?
    promoStr = GetPromotionRequirementText(Player.Class, t.SkillType, t.SkillMastery)
    if promoStr then
        return false, promoStr
    end

    -- Must learn masteries in order: Novice -> Expert -> Master -> GM
    if t.SkillMastery > const.Expert and skillMastery ~= t.SkillMastery - 1 then
        retStr = Game.NPCText[128]
        return false, retStr
    end

    -- Enough points?
    if skillLevel < t.SkillRequire then
        retStr = string.format(Game.NPCText[128], Game.ClassNames[Player.Class])
        return false, retStr
    end

    return true, retStr
end

NPCTopicMasterSkillBase =   {
    Slot                =   A,
    Branch              =   "",
    NewBranch           =   "TeachSkill",
    SkillDes            =   "",
    GetTopic            =   function(t) return NPCTopicMasterSkillBase_GetTopic(t) end,
    Ungive              =   function(t)
                                Message(ProcessEscapes(t.SkillDes))
                                SetBranch(t)
                            end
}

NPCTopicMasterSkillTeach =  {
    Slot                =   A,
    Branch              =   "TeachSkill",
    NewBranch           =   "",
    SkillDes            =   "",
    GetTopic            =   function(t) return NPCTopicMasterSkillTeach_GetTopic(t) end,
    Done                =   function(t)
                                NPCTopicMasterSkillTeach_Done(t)
                                SetBranch(t)
                            end,
    Undone              =   function(t)
                                Message(ProcessEscapes(t.SkillDes))
                            end,
    CheckDone           =   function(t) return NPCTopicMasterSkillTeach_CheckDone(t) end,
    NeverGiven          =   true,
    NeverDone           =   true,
    QuestGold           =   400,
    SkillRequire        =   4,
    SkillType           =   const.Skills.Staff,
    SkillMastery        =   const.Expert,
}

NPCTopicMasterSkillBack = {
    Slot                =   B,
    Branch              =   "TeachSkill",
    NewBranch           =   "",
    Texts 		        = 
    {		
        Topic 	        = 	"Back",
    },
    Ungive              =   SetBranch
}

function NPCTopicMasterSkill(t)

    local npct      = { Branch = "" }
    local npcbackt  = { }

    table.copy(NPCTopicMasterSkillTeach,    t)
    table.copy(NPCTopicMasterSkillBase,     npct)
    table.copy(NPCTopicMasterSkillBack,     npcbackt)

    t.SkillDes = FormatTeacherString(t.SkillDes, t)

    npct.SkillMastery = t.SkillMastery
    npct.SkillType    = t.SkillType
    npct.SkillDes     = t.SkillDes

    NPCTopic(npct)
    NPCTopic(npcbackt)
    return Quest(t)
end

------------------------------------------------------------------------------
-- RECOMMEND TEACHER
------------------------------------------------------------------------------

function NPCTopicRecommendTeacherBase_GetTopic(t)

    -- GlobalTxt:
    -- [394] Unknown

    local teacherElement = Teacher_FindByNPC(t.RecommendNPC)

    return string.format("Recommend: %s", teacherElement and teacherElement.Name or Game.GlobalTxt[394]) 
end

NPCTopicRecommendTeacherBase = {
    Slot                =   C,
    Branch              =   "",
    RecommendDes        =   "",
    RecommendNPC        =   0,
    GetTopic            =   function(t) return NPCTopicRecommendTeacherBase_GetTopic(t) end,
    Ungive              =   function(t)

                                local teacherElement    = Teacher_FindByNPC(t.RecommendNPC)
                                local autonoteStr       = nil
                                
                                if teacherElement == nil then
                                    return
                                end

                                Message(ProcessEscapes(t.RecommendDes))

                                autonoteStr = ":" .. teacherElement.ID

                                if not CheckAutonote(autonoteStr) then
                                    AddAutonote(autonoteStr)
                                end
                            end,
    CanShow             =   function(t)

                                local teacherElement = Teacher_FindByNPC(t.RecommendNPC)
                                return teacherElement ~= nil
                            end
}

function NPCTopicRecommendTeacher(t)
    table.copy(NPCTopicRecommendTeacherBase, t)
    return Quest(t)
end
