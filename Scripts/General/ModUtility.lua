--[[
Utility & Helpers
Author: Henrik Chukhran, 2022 - 2024
]]

function GetDifficulty()
    if vars.Difficulty == nil then
        debug.Message("Shouldn't be null")
    end

    return vars.Difficulty
end

function IsWarrior()
    return GetDifficulty() == 1
end

function DoGameAction(a, p1, p2, now)
    mem.u4[0x50CA50] = 1

    local function act(t)
        t.Action = a  or 0
        t.Param  = p1 or 0
        t.Param2 = p2 or 0
        events.Remove("Action", act)
    end
    events.Action = act

    if now then
        mem.call(0x4304D6)
    end
end

function RemoveMonster(mon)

    if mon then
        mon.NPC_ID = 0
        mon.AIState = const.AIState.Removed
    end
end

function GetDistanceBetweenPoints(a, b)

	local diff = {
        X = b[0] - a[0],
        Y = b[1] - a[1],
        Z = b[2] - a[2]
    }

    return math.sqrt(diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z)
end

function GetDistanceBetweenObjects(a, b)

	if a.Pos == nil then
        
        print("GetDistanceBetweenObjects Error: a isn't object\n")
        return 0
    end

    if b.Pos == nil then
        
        print("GetDistanceBetweenObjects Error: b isn't object\n")
        return 0
    end

    return GetDistanceBetweenPoints(a.Pos, b.Pos)
end

function MakeHostile(idStart, idEnd)

    idEnd = idEnd or idStart
    for _, mon in Map.Monsters do
        if mon.Id >= idStart and mon.Id <= idEnd then
            mon.Hostile = true
        end
    end
end

function ContainsNumber(myArray, myValue)

    if myArray == nil then
        return false
    end
    
    for _, v in ipairs(myArray) do
        if v == myValue then
            return true
        end
    end
    return false
end

function TableRemoveByValue(t, value)

    if t == nil then
        return false
    end

    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
            return true
        end
    end
    return false
end

function CheckInventoryForItem(id)

	for i = 0, Party.Count - 1 do
		if evt[i].Cmp("Inventory", id) then
			return true
		end
	end
	return false
end

function PlayerSetSkill(player, skillID, points, mastery)

    pl = Party[player]
    local mySkill, myMastery = SplitSkill(pl.Skills[skillID])
    pl.Skills[skillID]     = JoinSkill(math.max(mySkill, points), 
        math.max(myMastery, mastery))
end

function PlayerHasSkill(player, skillID)

    pl = Party[player]
    return pl.Skills[skillID] > 0
end

function PartySetSkill(skillID, points, mastery)
    
    for _, pl in Party do
        local mySkill, myMastery = SplitSkill(pl.Skills[skillID])
        pl.Skills[skillID]     = JoinSkill(math.max(mySkill, points), 
            math.max(myMastery, mastery))
    end
end
