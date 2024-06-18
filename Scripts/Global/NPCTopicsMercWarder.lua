--[[
Mercenary Topics for Warder,
Author: Henrik Chukhran, 2022 - 2024
]]

local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
local Q = vars.Quests

-- @todo Refactor (Warning for others: don't refactor without testing!!!)
----- join two merc lua files into one
-- @todo Magical Resistance Upgrade: now gives +N to all resistances. Make a separate list
-- @todo Unique prices per Upgrade Type

-- evt.Add("NPCs",525) ; evt.Add("Gold", 50000)

-- Functionality
local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

local function NPCGetTopicUpgrade(t)

    local Merc      = vars.Mercs.Warder
    local Level     = 0
    local Price     = tostring(t.QuestGold).."g"
    local Upgrade   = GetUpgrade(Merc, t.UpgradeType)

    if Upgrade then
        Level = Upgrade.Level
        if Upgrade.Level >= ConstMercUpgradeLimit then
            Price = "Maxed"
        else
            Price = tostring(Upgrade.Price[Upgrade.Level] + t.QuestGold).."g"
        end
        
    end

    return string.format("%s (%d/3) (%s)", t.UpgradeName, Level, Price) 
end

local function NPCUpgradeDone(t)

    local Merc      = vars.Mercs.Warder
    local Upgrade   = GetUpgrade(Merc, t.UpgradeType)
    local Level     = Upgrade and Upgrade.Level or 1

    -- Pay more gold
    if Upgrade then
        local Sum = Upgrade.Price[Upgrade.Level]
        evt.Subtract("Gold", Sum)
    end
    
    -- Upgrade
    Upgrade = UpgradeMerc(Merc, t.UpgradeType)
    Level = Upgrade.Level

    -- Exception: Summmons
    if t.UpgradeType == EMercUpgradeType.Uses then
        Merc.FightsLeft = Merc.FightsMax[Level+1]
    end

    -- Call User Function
    if (t.UpgradeFunction) then
        t.UpgradeFunction(t)
    end
    
    -- Status effects
    ShowQuestEffect(false,"Add")
    evt.Add("Exp", 0)
end

local function NPCUpgradeCheckDone(t)

    local Merc      = vars.Mercs.Warder
    local Upgrade   = GetUpgrade(Merc, t.UpgradeType)
    local Level     = Upgrade and Upgrade.Level or 1

    -- Check for money
    if Upgrade then
        local Price = Upgrade.Price[Level] + t.QuestGold
        if not evt.Cmp("Gold", Price) then
            return false
        end
    end
    
    -- Level Cap
    if Level < ConstMercUpgradeLimit then
        return true
    end

    return false
end

-- Template
local NPCTopicUpgradeConfirmBase = {
    Slot 			= 	A,
    Branch          =   "Upgrade",
    GetTopic 	    = 	function(t) return NPCGetTopicUpgrade(t) end,
    Texts           =   {
        Done        =   "Upgrade successful!",
        Undone      =   "Not enough gold or you've reached maximum level of allowed upgrades.",
    },
    CanShow         =   (|| evt.Cmp("NPCs", QuestNPC) ),
    NeverDone       =   true,
    NeverGiven      =   true,
	Done			= 	function(t) NPCUpgradeDone(t) end,
    CheckDone       =   function(t) return NPCUpgradeCheckDone(t) end,
    QuestGold       =   1000,
    UpgradeType     =   EMercUpgradeType.Null,
    UpgradeName     =   "Untitled",
    UpgradeFunction =   function(t) end
}

local NPCTopicUpgradeBackBase = {
    Slot            =   F,
    Branch          =   "Upgrade",
    NewBranch       =   "UpgradeSelect",
    CanShow         =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		    = 
	{		
        Topic 	    = 	"Back"
    },
    Ungive          =   SetBranch
}

local function NPCTopicUpgradeConfirm(t)
	table.copy(NPCTopicUpgradeConfirmBase, t)
	NPCTopicUpgradeConfirmBase.Slot = NPCTopicUpgradeConfirmBase.Slot and NPCTopicUpgradeConfirmBase.Slot + 1
	return Quest(t)
end

local function NPCTopicUpgradeBack(t)
    table.copy(NPCTopicUpgradeBackBase, t)
	return Quest(t)
end

-- Warder
QuestNPC        =   525

Greeting{
	"Just so you know, I might not hit hard, but I can take a beating while you lot do the damage from behind me.",
}

local function NPCMercFight(t)

    local Merc = vars.Mercs.Warder

    evt.Subtract("NPCs", QuestNPC)
    MercDecCharge(Merc)
    Merc.Released = true
    Merc.ReleaseMap = Game.Map.Name

    local UpgradeMonLevel       = GetUpgradeLevel(Merc, EMercUpgradeType.Level)
    local UpgradeHPLevel        = GetUpgradeLevel(Merc, EMercUpgradeType.HP)
    local UpgradeACLevel        = GetUpgradeLevel(Merc, EMercUpgradeType.AC)
    local UpgradeDmg1Level      = GetUpgradeLevel(Merc, EMercUpgradeType.MeleeDamage)
    --local UpgradeDmg1Level      = GetUpgradeLevel(Merc, EMercUpgradeType.MageRes)

    -- Monster
    local mon                   = SummonMonster(Merc.MonsterID, Party.X, Party.Y, Party.Z, false)

    -- User values
    mon.FullHitPoints           = Merc.FullHP[UpgradeHPLevel+1]
    mon.ArmorClass              = Merc.AC[UpgradeACLevel+1]
    mon.Level                   = Merc.Level[UpgradeMonLevel+1]

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

    -- Damage
    local meleeDmg              = ParseDamageString(Merc.Attack1[UpgradeDmg1Level+1])
    mon.Attack1.DamageAdd       = meleeDmg.DamageAdd
    mon.Attack1.DamageDiceCount = meleeDmg.DamageDiceCount
    mon.Attack1.DamageDiceSides = meleeDmg.DamageDiceSides

    ExitScreen()
end

local function NPCMercDismiss(t)

    local Merc = vars.Mercs.Warder

    evt.Add("NPCs", QuestNPC)
    Merc.Released = false
    Merc.ReleaseMap = ""
    
    for _, mon in Map.Monsters do
        if mon.NPC_ID == QuestNPC then
            RemoveMonster(mon)
        end
    end

    -- Reset
    Timer(
        function()
            local UpgradeUseLevel   = GetUpgradeLevel(Merc, EMercUpgradeType.Uses) or 1
            Merc.FightsLeft = Merc.FightsMax[UpgradeUseLevel+1] or 1
        end, 
        const.Day, const.Hour, true)

    ExitScreen()
end

local function IsNPCMercSpecial(t)

    local Merc = vars.Mercs.Warder
    
    return Merc.Ability
end

local function NPCMercSpecial(t) 

    local Merc = vars.Mercs.Warder

    if IsNPCMercSpecial(t) then
        Message(Merc.Special)
    end
end


NPCTopic{
    Slot        =   A,
    Branch      =   "",
	GetTopic    =   function(t) return string.format("Fight (%d)", vars.Mercs.Warder.FightsLeft) end,
	CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.FightsLeft > 0 and vars.Mercs.Warder.Dead == false),
	Ungive      =   function(t) NPCMercFight(t) end
} 

NPCTopic{
    Slot        =   A,
    Branch      =   "",
	Topic       =   "Dismiss!",
	CanShow     =   (|| not evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.Dead == false),
	Ungive      =   function(t) NPCMercDismiss(t) end
}

NPCTopic{
    Slot        =   A,
    Branch      =   "",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.FightsLeft == 0 and vars.Mercs.Warder.Dead == false),
	"Fight?",
	"I'm too tired, boss.",
}

NPCTopic{
    Slot        =   A,
    Branch      =   "",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.Dead == true),
	"Dead",
	"Apparently, this mercenary is dead. Seek help from Guildmaster. ",
}

-- NPCTopic{
--     Slot        =   B,
--     Branch      =   "",
--     --CanShow   =   (|| evt.Cmp("NPCs", QuestNPC) ),
-- 	Texts 		= 
-- 	{		
--         Topic 	= 	"Info",
--     }
-- }

NPCTopic{
    Slot        =   B,
    Branch      =   "",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and IsNPCMercSpecial(t)),
    Topic       =   "Special Ability",
    Ungive      =   function(t) NPCMercSpecial(t) end 
}

NPCTopic{
    Slot        =   C,
    Branch      =   "",
    NewBranch   =   "UpgradeSelect",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.Dead == false ),
    Topic       =   "Upgrade",
    Ungive      =   SetBranch
}

NPCTopic{
    Slot        =   E,
    Branch      =   "",
    NewBranch   =   "ConfirmFire",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) and vars.Mercs.Warder.Dead == false ),
    Ungive      =   SetBranch,
	Texts 			= 
	{		
		Topic 		= 	"Fire",
		Ungive 		= 	"Off I go then. If you need me, I'll be at the merc guild, probably just standing around.",
	},
}

-------------------------------------------------------------------------------
-- CONFIRM FIRE

NPCTopic{
    Slot        =   A,
    Branch      =   "ConfirmFire",
    NewBranch   =   "void",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"Good bye!",
        Ungive  =   "Alrighty then...",
    },
    Ungive      =   function(t) 
                        SetBranch(t)
                        evt.Subtract("NPCs", QuestNPC)
                        ExitScreen()
                    end
}

NPCTopic{
    Slot        =   B,
    Branch      =   "ConfirmFire",
    NewBranch   =   "",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"On second thought...",
        Ungive  =   "I was worried for a bit.",
    },
    Ungive      =   SetBranch
}

-------------------------------------------------------------------------------
-- UPGRADE
NPCTopic{
    Slot        =   A,
    Branch      =   "UpgradeSelect",
    NewBranch   =   "UpgradeCommon",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"Category: Common",
    },
    Ungive      =   SetBranch
}

NPCTopic{
    Slot        =   B,
    Branch      =   "UpgradeSelect",
    NewBranch   =   "UpgradeOffense",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"Category: Offense",
    },
    Ungive      =   SetBranch
}

NPCTopic{
    Slot        =   C,
    Branch      =   "UpgradeSelect",
    NewBranch   =   "UpgradeDefense",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"Category: Defense",
    },
    Ungive      =   SetBranch
}

NPCTopic{
    Slot        =   F,
    Branch      =   "UpgradeSelect",
    NewBranch   =   "",
    CanShow     =   (|| evt.Cmp("NPCs", QuestNPC) ),
    Texts 		= 
	{		
        Topic 	= 	"Back",
    },
    Ungive      =   SetBranch
}

-- Actual Upgrades
NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.HP, UpgradeName = "Hit Points", Slot = A }
NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.Level, UpgradeName = "Level" }
NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.Uses, UpgradeName = "Summons" }
NPCTopicUpgradeBack{Branch = "UpgradeCommon" }

NPCTopicUpgradeConfirm{Branch = "UpgradeOffense", UpgradeType = EMercUpgradeType.MeleeDamage, UpgradeName = "Damage", Slot = A }
NPCTopicUpgradeBack{Branch = "UpgradeOffense" }

NPCTopicUpgradeConfirm{Branch = "UpgradeDefense", UpgradeType = EMercUpgradeType.AC, UpgradeName = "Armor", Slot = A }
NPCTopicUpgradeBack{Branch = "UpgradeDefense" }
