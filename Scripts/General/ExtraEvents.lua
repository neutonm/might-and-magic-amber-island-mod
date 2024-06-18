-- Taken from MMerge

local u1, u2, u4, mstr, mcopy, mptr = mem.u1, mem.u2, mem.u4, mem.string, mem.copy, mem.topointer
local NewCode

local function GetPlayer(p)
	local i = (p - Party.PlayersArray["?ptr"]) / Party.PlayersArray[0]["?size"]
	return Party.PlayersArray[i], i
end

local function GetMonster(p)
	if p < Map.Monsters["?ptr"] then
		return
	end
	local i = (p - Map.Monsters["?ptr"]) / Map.Monsters[0]["?size"]
	return Map.Monsters[i], i
end


---------------------------------------
-- Regen tick event
-- Standart regen ticks, - unlike timers, continues to tick during party rest.

-- edit: found similar pattern at 0x493bcd (mm7.exe)
-- mem.autohook2(0x493bcd, function(d) -- mm8: 0x491f58
-- 	events.cocall("RegenTick", GetPlayer(d.eax))
-- end)
