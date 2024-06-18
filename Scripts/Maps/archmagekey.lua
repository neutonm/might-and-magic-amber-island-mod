--[[
Map: Archmage Realm (Key)
Author: Henrik Chukhran, 2022 - 2024
]]

local TXT = Localize{
	[0] = " ",
    [1] = "Doctor's Residence",
    [2] = "Lever",
    [3] = "Lift",
    [4] = "Door",
    [5] = "Switch",
    [6] = "Button",
    [7] = "Chest",
    [8] = "Furniture",
    [9] = "Bookcase",
    [10] = "Hole",
    [11] = "Nothing Happens",
    [12] = "Fountain",
    [13] = "Refreshing",
    [14] = "Teleportation Pedestal",
    [15] = "Keyhole",
    [16] = "The Door Is Locked",
    [17] = "Portal Is Activated",
    [18] = "Gold Vein",
    [19] = "Wine Rack",
    [20] = "Drink from the Fountain",
    [21] = "+10 Spell points restored",
    [22] = "+5 AC (Temporary)",
    [23] = "Refreshing",
    [24] = "You need teleportation stone.",
    [25] = "Leave Dungeon",
    [26] = "Flower",
    [27] = "Somebody already pressed the button!"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0


-- TODO:
-- Monsters
-- Teleportation Gem for Swamp port + Letter

-- ****************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION
-- 5            Western Teleportator Room & Realm port texture
-- 6            Eastern Teleportator Room & Realm port texture

-- BOSS 1: Western Realm, Minotaur
-- BOSS 2: Eastern Realm, Minotaur

-- ****************************************************************************

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 47           46              Secret: Western Key Realm (Waterfall Chamber)

-- ****************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1              Western Realm (QUEST: Key)
-- 01           2              Eastern Realm (QUEST: Key)
-- 92           3              Secret: Eastern Realm

-- ****************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Teleport     52              Western Realm, Platform
-- Teleport     54              Eastern Realm, Platform

-- ****************************************************************************
-- Chests
for i = 0, 19, 1 do
	local hintStr = evt.str[7]
    if Game.Debug then
        hintStr = hintStr .. " #"..tostring(i)
    end
	evt.hint[1 + i] = hintStr
	evt.map[1 + i] = function() 
	    evt.OpenChest(i)
	end
end 

-- Doors
-- Secret: Western Key Realm (Waterfall Chamber)
evt.hint[46] = evt.str[4]
evt.map[46] = function()
    evt.SetDoorState{Id = 47, State = 2}
end

-- ****************************************************************************
-- MISC:

-- Teleport: From Western Teleport Room to Western Realm [DEPRECATED]
evt.hint[51] = evt.str[0]
evt.map[51] = function()
	--if evt.Cmp("MapVar4", 1) then
		evt.MoveToMap{
			X = -11607, Y = 2335, Z = 706, 
			Direction = 516, LookAngle = 0, SpeedZ = 0, 
			HouseId = 0, Icon = 0, Name = "0"}
	--end
end

-- Teleport: From Western Realm to Western Teleport Room
evt.hint[52] = evt.str[0]
evt.map[52] = function()
    evt.MoveToMap{
        X = -5269, Y = 2803, Z = 190, 
        Direction = 0, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "archmageres.blv"}
end

-- Teleport: From Eastern Teleport Room to Eastern Realm [DEPRECATED]
evt.hint[53] = evt.str[0]
evt.map[53] = function()
	--if evt.Cmp("MapVar5", 1) then
		evt.MoveToMap{
			X = 20796, Y = 988, Z = 65, 
			Direction = 510, LookAngle = 0, SpeedZ = 0, 
			HouseId = 0, Icon = 0, Name = "0"}
	--end
end

-- Teleport: From Eastern Realm to Eastern Teleport Room 
evt.hint[54] = evt.str[0]
evt.map[54] = function()
    evt.MoveToMap{
        X = 10364, Y = 2937, Z = 65, 
        Direction = 1024, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "archmageres.blv"}
end
