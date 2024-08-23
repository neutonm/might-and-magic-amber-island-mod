--[[
Mercenary Topics Template,
Author: Henrik Chukhran, 2022 - 2024
]]

local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
local Q = vars.Quests

-- Functionality
local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

local function IsQuestNPCActive()
    return evt.Cmp("NPCs", QuestNPC)
end

local function Merc_NPCTopicGetUpgrade(Merc, t)

    local Level     = 0
    local Price     = tostring(t.QuestGold).."g"
    local Upgrade   = Merc_GetUpgrade(Merc, t.UpgradeType)

    if Upgrade then
        Level = Upgrade.Level
        if Upgrade.Level >= const.Mercenary.UpgradeLimit then
            Price = "Maxed"
        else
            Price = tostring(Upgrade.Price[Upgrade.Level] + t.QuestGold).."g"
        end
        
    end

    return string.format("%s (%d/3) (%s)", t.UpgradeName, Level, Price) 
end

local function Merc_NPCTopicUpgradeDone(Merc, t)

    local Upgrade       = Merc_GetUpgrade(Merc, t.UpgradeType)
    local Level         = Upgrade and Upgrade.Level or 1
    local MercSaveData  = Merc_GetSaveDataByID(Merc.NPC_ID)

    -- Pay more gold
    if Upgrade then
        local Sum = Upgrade.Price[Upgrade.Level]
        evt.Subtract("Gold", Sum)
    end
    
    -- Upgrade
    Upgrade = Merc_Upgrade(Merc, t.UpgradeType)
    Level   = Upgrade.Level

    -- Call User Function
    if (t.UpgradeFunction) then
        t.UpgradeFunction(t)
    end
    
    -- Status effects
    ShowQuestEffect(false,"Add")
    evt.Add("Exp", 0)
end

local function Merc_NPCTopicUpgradeCheckDone(Merc, t)

    local Upgrade   = Merc_GetUpgrade(Merc, t.UpgradeType)
    local Level     = Upgrade and Upgrade.Level or 1

    -- Check for money
    if Upgrade then
        local Price = Upgrade.Price[Level] + t.QuestGold
        if not evt.Cmp("Gold", Price) then
            return false
        end
    end
    
    -- Level Cap
    if Level < const.Mercenary.UpgradeLimit then
        return true
    end

    return false
end

local function NPCMercDeclare(Merc)

    QuestNPC            =   Merc.NPC_ID

    Greeting{
        GetGreeting     =   function(t)
                                local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                                return MercSaveData.Dead and "" or Merc.Credentials.TextGreeting
                            end 
    }

    -- Template
    local NPCTopicUpgradeConfirmBase = {
        Slot 			= 	A,
        Branch          =   "Upgrade",
        GetTopic 	    = 	function(t) return Merc_NPCTopicGetUpgrade(Merc, t) end,
        Texts           =   {
            Done        =   "Upgrade successful!",
            Undone      =   "Not enough gold or you've reached maximum level of allowed upgrades.",
        },
        CanShow         =   (|| IsQuestNPCActive() ),
        NeverDone       =   true,
        NeverGiven      =   true,
        Done			= 	function(t) Merc_NPCTopicUpgradeDone(Merc, t) end,
        CheckDone       =   function(t) return Merc_NPCTopicUpgradeCheckDone(Merc, t) end,
        QuestGold       =   1000,
        UpgradeType     =   EMercUpgradeType.Null,
        UpgradeName     =   "Untitled",
        UpgradeFunction =   function(t) end
    }

    local NPCTopicUpgradeBackBase = {
        Slot            =   F,
        Branch          =   "Upgrade",
        NewBranch       =   "UpgradeSelect",
        CanShow         =   (|| IsQuestNPCActive() ),
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
        
    -- Actual Topics
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return string.format("Fight (%d)", MercSaveData.FightsLeft) 
                        end,
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.FightsLeft > 0 and MercSaveData.Dead == false
                        end,
        Ungive      =   function(t) 
                            Merc_Fight(Merc, t) 
                        end
    } 

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        Topic       =   "Dismiss!",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return not IsQuestNPCActive() and MercSaveData.Dead == false 
                        end,
        Ungive      =   function(t) 
                            Merc_Dismiss(Merc, t) 
                        end
    }

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.FightsLeft == 0 and MercSaveData.Dead == false
                        end,
        "Fight?",
        Merc.Credentials.TextFightTired,
    }

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.Dead == true
                        end,
        "Dead",
        "Apparently, this mercenary is dead. Seek help from Guildmaster. ",
    }

    NPCTopic{
        Slot        =   B,
        Branch      =   "",
        NewBranch   =   "MercInfo",
        Topic       =   "Information",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.Dead == false
                        end,
        Ungive      =   SetBranch
    }

    NPCTopic{
        Slot        =   D,
        Branch      =   "",
        NewBranch   =   "UpgradeSelect",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.Dead == false
                        end,
        Topic       =   "Upgrade",
        Ungive      =   SetBranch
    }

    NPCTopic{
        Slot        =   E,
        Branch      =   "",
        NewBranch   =   "ConfirmFire",
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.Dead == false 
                        end,
        Ungive      =   SetBranch,
        Texts 		= 
        {		
            Topic 	= 	"Fire",
            Ungive 	= 	Merc.Credentials.TextFireAttempt,
        },
    }
    -------------------------------------------------------------------------------
    -- INFORMATION

    NPCTopic{
        Slot        =   A,
        Branch      =   "MercInfo",
        Topic       =   "About",
        Ungive      =   function(t)
                            Merc_ShowInfo(Merc, t) 
                        end 
    }

    NPCTopic{
        Slot        =   B,
        Branch      =   "MercInfo",
        CanShow     =   function(t)
                            return IsQuestNPCActive() and Merc_IsSpecial(Merc, t)
                        end,
        Topic       =   "Special Ability",
        Ungive      =   function(t) 
                            Merc_ShowMessageAboutAbility(Merc, t) 
                        end 
    }

    NPCTopic{
        Slot        =   D,
        Branch      =   "MercInfo",
        NewBranch   =   "",
        Texts 		= 
        {		
            Topic 	= 	"Back",
        },
        Ungive      =   SetBranch
    }

    -------------------------------------------------------------------------------
    -- CONFIRM FIRE
    NPCTopic{
        Slot        =   A,
        Branch      =   "ConfirmFire",
        NewBranch   =   "void",
        CanShow     =   (|| IsQuestNPCActive() ),
        Texts 		= 
        {		
            Topic 	= 	"Good bye!",
        },
        Ungive      =   function(t) 
                            SetBranch(t)
                            evt.Subtract("NPCs", QuestNPC)
                            Merc_Fire(Merc)
                            ExitScreen()
                        end
    }

    NPCTopic{
        Slot        =   B,
        Branch      =   "ConfirmFire",
        NewBranch   =   "",
        CanShow     =   (|| IsQuestNPCActive() ),
        Texts 		= 
        {		
            Topic 	= 	"On second thought...",
            Ungive  =   Merc.Credentials.TextFireCancel,
        },
        Ungive      =   SetBranch
    }

    -------------------------------------------------------------------------------
    -- UPGRADE
    
    NPCTopic{
        Slot        =   A,
        Branch      =   "UpgradeSelect",
        NewBranch   =   "UpgradeCommon",
        CanShow     =   (|| IsQuestNPCActive() ),
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
        CanShow     =   (|| IsQuestNPCActive() ),
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
        CanShow     =   (|| IsQuestNPCActive() ),
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
        Texts 		= 
        {		
            Topic 	= 	"Back",
        },
        Ungive      =   SetBranch
    }

    -- Actual Upgrades
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.HP, UpgradeName = "Hit Points", Slot = A }
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.Level, UpgradeName = "Level" }
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = EMercUpgradeType.Charges, UpgradeName = "Summons" }
    NPCTopicUpgradeBack{Branch = "UpgradeCommon" }

    NPCTopicUpgradeConfirm{Branch = "UpgradeOffense", UpgradeType = EMercUpgradeType.MeleeDamage, UpgradeName = "Damage", Slot = A }
    NPCTopicUpgradeBack{Branch = "UpgradeOffense" }

    NPCTopicUpgradeConfirm{Branch = "UpgradeDefense", UpgradeType = EMercUpgradeType.AC, UpgradeName = "Armor", Slot = A }
    NPCTopicUpgradeBack{Branch = "UpgradeDefense" }
end

-- Main merc declarations
for _, Merc in ipairs(MercsDB) do
    NPCMercDeclare(Merc)
end
