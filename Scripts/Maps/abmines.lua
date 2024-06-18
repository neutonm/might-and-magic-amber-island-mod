--[[
Map: Abandoned Mines
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


-- ****************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION


-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1      xx


-- MONSTERS
-- GROUP 1: Skeleton Warrior
-- BOSS 1: Behemoth

-- ****************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Main Hall (Entrance)
-- 01           02              House
-- 02           03              Behemoth Cave

-- ****************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Gold         0              xxx

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

-- Gold Vein
for i = 0, 3, 1 do
	evt.hint[21 + i] = evt.str[18]  -- "Ore Vein"
	evt.map[21 + i] = function()
		local gold
		local mapVarStr = "MapVar"..tostring(25 + i)
		if evt.Cmp(mapVarStr, 1) then
			return
		end
		gold = math.random(69,420)
		AddGoldExp(gold,0)
		evt.Set(mapVarStr, 1)
		evt.SetTexture(21 + i, "Cwb1")
	end
end

-- EXIT DOOR
evt.hint[100] = evt.str[25]
evt.map[100] = function()
    evt.MoveToMap{X = 19510, Y = 19396, Z = 192, Direction = 1794, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 4, Name = "amber.odm"}
end
