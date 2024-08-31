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

    local function GetBountyMessage(Town, ShowTimeLeft)
        local timeDifference = (Town.BountyTimeStart + (Town.BountyTimeRefill * const.Day)) - Game.Time
        local timeStr = ""

        if ShowTimeLeft then
            local timeStrLeft = timeDifference > const.Day and string.format("%d days", timeDifference / const.Day) or string.format("%d hours", timeDifference / const.Hour)
            timeStr = string.format("\n\nYou have \01265523%s\01200000 to complete the hunt.", timeStrLeft)
        end
        
        return string.format(   "This month's bounty is on a \01265523%s\01200000."..
                                "Kill it before the deadline and return to collect \01265523%d\01200000 gold reward."..
                                "%s",Town.TargetMonster_Name, Town.Bounty, timeStr)
    end
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return "Bounty Hunt: Participate!"
                        end,
        CanShow     =   function(t)
                            local Town = TownHall_GetByID(QuestNPC)
                            return Town.BountyStatus == const.TownHall.BountyStatus.Vacant
                        end,
        Ungive      =   function(t)
                            local Town = TownHall_GetByID(QuestNPC)
                            TownHall_GenerateBountyTarget(Town)
                            Message(GetBountyMessage(Town, false))
                            evt.ForPlayer("All")
	                        ShowQuestEffect(false,"Add")
                        end
    }
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return "Bounty Hunt: Status"
                        end,
        CanShow     =   function(t)
                            local Town = TownHall_GetByID(QuestNPC)
                            return Town.BountyStatus == const.TownHall.BountyStatus.Pending
                        end,
        Ungive      =   function(t)
                            local Town = TownHall_GetByID(QuestNPC)
                            Message(GetBountyMessage(Town, true))
                        end
    }
    NPCTopic{
        Slot        =   A,
        Branch      =   "",
        GetTopic    =   function(t)
                            return "Bounty Hunt: n\\a"
                        end,
        CanShow     =   function(t)
                            local Town = TownHall_GetByID(QuestNPC)
                            return Town.BountyStatus == const.TownHall.BountyStatus.Success
                        end,
        Ungive      =   function(t)
                            Message("No bounty for this month")
                        end
    } 
    NPCTopic{
        Slot        =   B,
        Branch      =   "",
        GetTopic    =   function(t)
                            return string.format("Collect Bounty \01265523(%dg)", vars.TownHallAccumulatedBounty)
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
                            return string.format("Pay Fine \01265523(%dg)", Party.Fine)
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

