--[[
Description:    Mercenary Topics Template,
Author:         Henrik Chukhran, 2022 - 2026
]]

local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5

-- Functionality
local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

local function Merc_FindMonster(Merc)

    for _, mon in Map.Monsters do
        if mon.NPC_ID == Merc.NPC_ID then
            return mon
        end
    end

    return nil
end

local function IsQuestNPCActive()
    return evt.Cmp("NPCs", QuestNPC)
end

local function Merc_NPCTopicGetUpgrade(Merc, t)

    local Upgrade   = Merc_GetUpgrade(Merc, t.UpgradeType)
    local Level     = Upgrade and Upgrade.Level or 0
    local Price     = Merc_GetUpgradePrice(Merc, t.UpgradeType)

    if Level >= const.Mercenary.UpgradeLimit then
        Price = "Maxed"
    else
        Price = tostring(Price).."g"
    end

    return string.format("%s (%d/3) \01265523(%s)", t.UpgradeName, Level, Price) 
end

local function Merc_NPCTopicUpgradeDone(Merc, t)

    local Price = Merc_GetUpgradePrice(Merc, t.UpgradeType)

    -- Pay for the current level transition before incrementing the level.
    evt.Subtract("Gold", Price)
    
    -- Upgrade
    Merc_Upgrade(Merc, t.UpgradeType)

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
    local Level     = Upgrade and Upgrade.Level or 0

    -- Level Cap
    if Level >= const.Mercenary.UpgradeLimit then
        return false
    end

    -- Check for money
    local Price = Merc_GetUpgradePrice(Merc, t.UpgradeType)
    if not evt.Cmp("Gold", Price) then
        return false
    end

    return true
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
        CanShow         =   function(t) return IsQuestNPCActive() end,
        NeverDone       =   true,
        NeverGiven      =   true,
        Done			= 	function(t) Merc_NPCTopicUpgradeDone(Merc, t) end,
        CheckDone       =   function(t) return Merc_NPCTopicUpgradeCheckDone(Merc, t) end,
        QuestGold       =   0,
        UpgradeType     =   const.Mercenary.UpgradeType.Null,
        UpgradeName     =   "Untitled",
        UpgradeFunction =   function(t) end
    }

    local NPCTopicUpgradeBackBase = {
        Slot            =   F,
        Branch          =   "Upgrade",
        NewBranch       =   "UpgradeSelect",
        CanShow         =   function(t) return IsQuestNPCActive() end,
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
                            return string.format("%s \01265523(%d)", MercTxt.MMercFight, MercSaveData.FightsLeft) 
                        end,
        CanShow     =   function(t)
                            local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
                            return IsQuestNPCActive() and MercSaveData.FightsLeft > 0 and MercSaveData.Dead == false
                        end,
        Ungive      =   function(t) 
                            Merc_Fight(Merc, t) 
                        end
    }

    -- Merc is released: dismissing + Tactics

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        Topic       =   "Tactics: Follow",
        CanShow     =   function(t)
                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
                            local MercMonster       = nil
                            local MercModAIEntry    = nil

                            if IsQuestNPCActive() and MercSaveData.Dead == true then
                                return false
                            end
                            
                            MercMonster     = Merc_FindMonster(Merc)
                            MercModAIEntry  = ModAI_Get(MercMonster)
                            
                            return MercModAIEntry and MercModAIEntry.Mode ~= const.FollowerMode.Hold or false
        end,
        Ungive      =   function(t)
                            ModAI_Hold(Merc_FindMonster(Merc))
                            Message(MercTxt.MMercTacticsHoldMsg)
                        end
    }

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        Topic       =   "Tactics: Hold",
        CanShow     =   function(t)
                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
                            local MercMonster       = nil
                            local MercModAIEntry    = nil

                            if IsQuestNPCActive() and MercSaveData.Dead == true then
                                return false
                            end
                            
                            MercMonster     = Merc_FindMonster(Merc)
                            MercModAIEntry  = ModAI_Get(MercMonster)
                            
                            return MercModAIEntry and MercModAIEntry.Mode == const.FollowerMode.Hold or false
        end,
        Ungive      =   function(t)
                            ModAI_FollowParty(Merc_FindMonster(Merc))
                            Message(MercTxt.MMercTacticsFollowMsg)
                        end
    }

    NPCTopic{
        Slot        =   B,
        Branch      =   "",
        Topic       =   "Style: Aggressive",
        CanShow     =   function(t)

                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)

                            if IsQuestNPCActive() and MercSaveData.Dead == true then
                                return false
                            end
                            
                            return MercSaveData.AIBehavior == const.FollowerMode.OffensiveFollow
                        end,
        Ungive      =   function(t)
                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
                            MercSaveData.AIBehavior = const.FollowerMode.DefensiveFollow
                            ModAI_SetMode(Merc_FindMonster(Merc), const.FollowerMode.DefensiveFollow)
                            Message(MercTxt.MMercStyleDefensiveMsg)
                        end
    }

    NPCTopic{
        Slot        =   B,
        Branch      =   "",
        Topic       =   "Style: Defensive",
        CanShow     =   function(t)
                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)

                            if IsQuestNPCActive() and MercSaveData.Dead == true then
                                return false
                            end
                            
                            return MercSaveData.AIBehavior == const.FollowerMode.DefensiveFollow
                        end,
        Ungive      =   function(t)
                            local MercSaveData      = Merc_GetSaveDataByID(Merc.NPC_ID)
                            MercSaveData.AIBehavior = const.FollowerMode.OffensiveFollow
                            ModAI_SetMode(Merc_FindMonster(Merc), const.FollowerMode.OffensiveFollow)
                            Message(MercTxt.MMercStyleAggressiveMsg)
                        end
    }

    NPCTopic{
        Slot        =   C,
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

    --

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
        "Apparently, this mercenary is \01264105dead\01200000. Seek help from Guildmaster.",
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
        CanShow     =   function(t) return IsQuestNPCActive() end,
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
        CanShow     =   function(t) return IsQuestNPCActive() end,
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
        CanShow     =   function(t) return IsQuestNPCActive() end,
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
        CanShow     =   function(t) return IsQuestNPCActive() end,
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
        CanShow     =   function(t) return IsQuestNPCActive() end,
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
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = const.Mercenary.UpgradeType.HP, UpgradeName = "Hit Points", Slot = A }
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = const.Mercenary.UpgradeType.Level, UpgradeName = "Level" }
    NPCTopicUpgradeConfirm{Branch = "UpgradeCommon", UpgradeType = const.Mercenary.UpgradeType.Charges, UpgradeName = "Summons" }
    NPCTopicUpgradeBack{Branch = "UpgradeCommon" }

    NPCTopicUpgradeConfirm{Branch = "UpgradeOffense", UpgradeType = const.Mercenary.UpgradeType.MeleeDamage, UpgradeName = "Damage", Slot = A }
    NPCTopicUpgradeBack{Branch = "UpgradeOffense" }

    NPCTopicUpgradeConfirm{Branch = "UpgradeDefense", UpgradeType = const.Mercenary.UpgradeType.AC, UpgradeName = "Armor", Slot = A }
    NPCTopicUpgradeBack{Branch = "UpgradeDefense" }
end

-- Main merc declarations
for _, Merc in ipairs(MercsDB) do
    NPCMercDeclare(Merc)
end
