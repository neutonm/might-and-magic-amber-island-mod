--[[
Custom "Town Hall" topics Template,
Author: Henrik Chukhran, 2022 - 2024
]]

local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5

-- Functionality
local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

--! @brief  Declares Topics for customized Town Hall NPCs.
--! @note   Requires QuestNPC to be set
function TownHall_NPCTopicDeclare()

    local function GetBountyMessage(Town, state, ShowTimeLeft)

        local refill            = TownHall_ResolveWarriorValue(Town.BountyTimeRefill, Town.BountyTimeRefillW)
        local timeDifference    = (state.BountyTimeStart + (refill * const.Day)) - Game.Time
    
        local timeStr = ""
    
        if ShowTimeLeft then
            local timeStrLeft =
                timeDifference > const.Day and
                string.format(TownHallTxt.TComeBackDays, timeDifference / const.Day) or
                string.format(TownHallTxt.TComeBackHours, timeDifference / const.Hour)
    
            timeStr = string.format(TownHallTxt.TTimeLeft, timeStrLeft)
        end
    
        return string.format(
            (TownHallTxt.TBountyStart.."\n%s"),
            state.TargetMonster_Name,
            state.Bounty,
            timeStr
        )
    end

    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return TownHallTxt.TParticipateTopic
                        end,
        CanShow     =   function(t)
                            local Town, state = TownHall_GetContext(QuestNPC)
                            return state.BountyStatus == const.TownHall.BountyStatus.Vacant
                        end,
        Ungive      =   function(t)
                            local Town, state = TownHall_GetContext(QuestNPC)
                            TownHall_GenerateBountyTarget(Town)
                            Message(GetBountyMessage(Town, state, true))
                            evt.ForPlayer("All")
	                        ShowQuestEffect(false,"Add")
                        end
    }
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return TownHallTxt.TStatusTopic
                        end,
        CanShow     =   function(t)
                            local Town, state = TownHall_GetContext(QuestNPC)
                            return state.BountyStatus == const.TownHall.BountyStatus.Pending
                        end,
        Ungive      =   function(t)
                            local Town, state = TownHall_GetContext(QuestNPC)
                            Message(GetBountyMessage(Town, state, true))
                        end
    }
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return TownHallTxt.TBountyHuntNATopic
                        end,
        CanShow     =   function(t)
                            local Town, state = TownHall_GetContext(QuestNPC)
                            return state.BountyStatus == const.TownHall.BountyStatus.Success
                        end,
        Ungive      =   function(t)

                            local Town      = TownHall_FindByNPC(QuestNPC)
                            local timeLeft  = TownHall_GetCooldownTimeLeft(Town)
                            local msg

                            if timeLeft <= const.Hour then
                                Message(TownHallTxt.TComeBackSoon)
                                return
                            elseif timeLeft > const.Day then
                                msg = string.format(TownHallTxt.TComeBackDays, math.floor(timeLeft / const.Day))
                            else
                                msg = string.format(TownHallTxt.TComeBackHours, math.floor(timeLeft / const.Hour))
                            end

                            Message(string.format(TownHallTxt.TComeBackLater, msg))
                        end
    } 
    NPCTopic{
        Slot        =   B,
        Branch      =   "",
        GetTopic    =   function(t)
                            return string.format(TownHallTxt.TCollectBountyTopic, vars.TownHallAccumulatedBounty)
                        end,
        CanShow     =   function(t)
                            return vars.TownHallAccumulatedBounty > 0
                        end,
        Ungive      =   function(t)
                            TownHall_Payout()
                        end
    }
    NPCTopic{
        Slot        =   C,
        Branch      =   "",
        GetTopic    =   function(t)
                            return string.format(TownHallTxt.TPayFineTopic, Party.Fine)
                        end,
        CanShow     =   function(t)
                            return Party.Fine > 0
                        end,
        Ungive      =   function(t)
                            TownHall_PayFine()
                        end
    }
end

QuestNPC = 535
TownHall_NPCTopicDeclare()

