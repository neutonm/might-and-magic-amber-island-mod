--[[
Map: Oak Hill Cottage
Author: Henrik Chukhran, 2022 - 2024
]]

local TXT = Localize{
	[0] = " ",
    [1] = "Doctor's Residence",
    [2] = "Lever",
    [3] = "Lift",
    [4] = "Door",
    [5] = "Double Door",
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
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0


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

-- Bookcases
-- Bookcase: Dining Hall
evt.hint[21] = evt.str[9]
evt.map[21] = function()
    if not evt.Cmp("MapVar1", 1) then
		evt.Set("MapVar1", 1)
		evt.Add("Inventory", 401)	-- "Fire Bolt" book
	end
end

evt.hint[22] = evt.str[9]
evt.map[22] = function()
    if not evt.Cmp("MapVar2", 1) then
		evt.Set("MapVar2", 1)
		evt.Add("Inventory", 401)	-- "Fire Bolt" book
	end
end

evt.hint[23] = evt.str[9]
evt.map[23] = function()
    if not evt.Cmp("MapVar3", 1) then
		evt.Set("MapVar3", 1)
		evt.Add("Inventory", 373)	-- "Cure Disease" scroll
	end
end

-- Bookcase: Office

evt.hint[24] = evt.str[9]
evt.map[24] = function()
    if not evt.Cmp("MapVar4", 1) then
		evt.Set("MapVar4", 1)
		evt.Add("Inventory", 425)	-- "Ice Bolt" book
	end
end

evt.hint[25] = evt.str[9]
evt.map[25] = function()
    if not evt.Cmp("MapVar5", 1) then
		evt.Set("MapVar5", 1)
		evt.Add("Inventory", 425)	-- "Ice Bolt" book
	end
end

evt.hint[26] = evt.str[9]
evt.map[26] = function()
    if not evt.Cmp("MapVar6", 1) then
		evt.Set("MapVar6", 1)
		evt.Add("Inventory", 373)	-- "Cure Disease" scroll
	end
end

evt.hint[27] = evt.str[9]
evt.map[27] = function()
    if not evt.Cmp("MapVar7", 1) then
		evt.Set("MapVar7", 1)
		evt.Add("Inventory", 305)	-- "Fireball" scroll
	end
end

-- Bookcase: Office Bedroom
evt.hint[28] = evt.str[9]
evt.map[28] = function()
    if not evt.Cmp("MapVar8", 1) then
		evt.Set("MapVar8", 1)
		evt.Add("Inventory", 337)	-- "Stone Skin" scroll
	end
end

-- Bookcase: Temple Bedroom
evt.hint[29] = evt.str[9]
evt.map[29] = function()
    if not evt.Cmp("MapVar9", 1) then
		evt.Set("MapVar9", 1)
		evt.Add("Inventory", 323)	-- "Poison Spray" scroll
	end
end

-- Bookcase: Library
evt.hint[30] = evt.str[9]
evt.map[30] = function()
    if not evt.Cmp("MapVar10", 1) then
		evt.Set("MapVar10", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

evt.hint[31] = evt.str[9]
evt.map[31] = function()
    if not evt.Cmp("MapVar11", 1) then
		evt.Set("MapVar11", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

evt.hint[32] = evt.str[9]
evt.map[32] = function()
    if not evt.Cmp("MapVar12", 1) then
		evt.Set("MapVar12", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

evt.hint[33] = evt.str[9]
evt.map[33] = function()
    if not evt.Cmp("MapVar13", 1) then
		evt.Set("MapVar13", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

evt.hint[34] = evt.str[9]
evt.map[34] = function()
    if not evt.Cmp("MapVar14", 1) then
		evt.Set("MapVar14", 1)
		evt.Add("Inventory", 300)	-- "Torch Light" scroll
	end
end

evt.hint[35] = evt.str[9]
evt.map[35] = function()
    if not evt.Cmp("MapVar15", 1) then
		evt.Set("MapVar15", 1)
		evt.Add("Inventory", 300)	-- "Torch Light" scroll
	end
end

evt.hint[36] = evt.str[9]
evt.map[36] = function()
    if not evt.Cmp("MapVar16", 1) then
		evt.Set("MapVar16", 1)
		evt.Add("Inventory", 300)	-- "Torch Light" scroll
	end
end

-- Bookcase: Master Bedroom
evt.hint[37] = evt.str[9]
evt.map[37] = function()
    if not evt.Cmp("MapVar17", 1) then
		evt.Set("MapVar17", 1)
		evt.Add("Inventory", 373)	-- "Cure Disease" scroll
	end
end

-- 38 -> 40 spare

-- Wineracks
-- Winerack: East
evt.hint[41] = evt.str[19]
evt.map[41] = function()
    if not evt.Cmp("MapVar18", 1) then
		evt.Set("MapVar18", 1)
		evt.Add("Inventory", 225)	-- "Cure" disease
	end
end

-- Winerack: West
evt.hint[42] = evt.str[19]
evt.map[42] = function()
    if not evt.Cmp("MapVar19", 1) then
		evt.Set("MapVar19", 1)
		evt.Add("Inventory", 225)	-- "Cure" disease
	end
end

-- 43 - 45 spare

-- Doors
-- Door: Dining Hall 
evt.hint[46] = evt.str[4]
evt.map[46] = function()
    evt.SetDoorState{Id = 7, State = 2}
    evt.SetDoorState{Id = 8, State = 2}
end

-- Door: Dining Hall -> Kitchen
evt.hint[47] = evt.str[4]
evt.map[47] = function()
    evt.SetDoorState{Id = 11, State = 2}
end

-- Door: Kitchen -> Basement
evt.hint[48] = evt.str[4]
evt.map[48] = function()
    evt.SetDoorState{Id = 12, State = 2}
end

-- Door: Gallery
evt.hint[49] = evt.str[4]
evt.map[49] = function()
    evt.SetDoorState{Id = 9, State = 2}
    evt.SetDoorState{Id = 10, State = 2}
end

-- Door: Gallery -> Workshop Corridor
evt.hint[50] = evt.str[4]
evt.map[50] = function()
    evt.SetDoorState{Id = 13, State = 2}
    evt.SetDoorState{Id = 14, State = 2}
end

-- Door: Workshop Corridor -> WC Stairs
evt.hint[51] = evt.str[4]
evt.map[51] = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Door: WC
evt.hint[52] = evt.str[4]
evt.map[52] = function()
    evt.SetDoorState{Id = 28, State = 2}
    evt.SetDoorState{Id = 28, State = 2}
end

-- Door: Workshop Storage
evt.hint[53] = evt.str[4]
evt.map[53] = function()
    evt.SetDoorState{Id = 15, State = 2}
    evt.SetDoorState{Id = 16, State = 2}
end

-- Door: Workshop
evt.hint[54] = evt.str[4]
evt.map[54] = function()
    evt.SetDoorState{Id = 17, State = 2}
    evt.SetDoorState{Id = 18, State = 2}
end

-- Door: Smithy
evt.hint[55] = evt.str[4]
evt.map[55] = function()
    evt.SetDoorState{Id = 19, State = 2}
    evt.SetDoorState{Id = 20, State = 2}
end

-- Door: Workshop Corridor -> Main Hall
evt.hint[56] = evt.str[4]
evt.map[56] = function()
    evt.SetDoorState{Id = 5, State = 2}
    evt.SetDoorState{Id = 6, State = 2}
end

-- Door: Main Hall -> Cellar
evt.hint[57] = evt.str[4]
evt.map[57] = function()
    evt.SetDoorState{Id = 26, State = 2}
    evt.SetDoorState{Id = 27, State = 2}
end

-- Door: Office
evt.hint[58] = evt.str[4]
evt.map[58] = function()
    evt.SetDoorState{Id = 22, State = 2}
end

-- Door: Office Bedroom
evt.hint[59] = evt.str[4]
evt.map[59] = function()
    evt.SetDoorState{Id = 23, State = 2}
end

-- Door: Temple North Bedroom
evt.hint[60] = evt.str[4]
evt.map[60] = function()
    evt.SetDoorState{Id = 24, State = 2}
end

-- Door: Temple South Bedroom
evt.hint[61] = evt.str[4]
evt.map[61] = function()
    evt.SetDoorState{Id = 25, State = 2}
end

-- Door: Master Bedroom
evt.hint[62] = evt.str[4]
evt.map[62] = function()
	evt.SetDoorState{Id = 3, State = 2}
	evt.SetDoorState{Id = 4, State = 2}
end

-- Door: Secret 1
evt.hint[63] = evt.str[4]
evt.map[63] = function()
	evt.SetDoorState{Id = 30, State = 2}
end

-- Door: Secret 2
evt.hint[64] = evt.str[4]
evt.map[64] = function()
	evt.SetDoorState{Id = 31, State = 2}
end

-- Door: Secret 3
evt.hint[65] = evt.str[4]
evt.map[65] = function()
	evt.SetDoorState{Id = 33, State = 2}
end

-- Door: Secret 4
evt.hint[66] = evt.str[4]
evt.map[66] = function()
	evt.SetDoorState{Id = 34, State = 2}
end

-- Door: Secret 5
evt.hint[67] = evt.str[4]
evt.map[67] = function()
	evt.SetDoorState{Id = 35, State = 2}
end

-- Elevators
-- Elevator: Library
evt.hint[70] = evt.str[3]
evt.map[70] = function()
	evt.SetDoorState{Id = 36, State = 2}
end

-- Elevator: Library Top lever
evt.hint[71] = evt.str[2]
evt.map[71] = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 38, State = 2}
end

-- Elevator: Library Bottom lever
evt.hint[72] = evt.str[2]
evt.map[72] = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 37, State = 2}
end

-- Misc
-- Main Hall Fountain
evt.hint[75] = evt.str[12]
evt.map[75] = function()
    if evt.Cmp("PlayerBits", 2) then
		evt.StatusText(23)         -- "Refreshing!"
		return
	end

    evt.Add("ArmorClassBonus", 5)
    evt.Add("PlayerBits", 2)
	evt.StatusText(22)         -- "+5 AC (Temporary)"
    AddAutonote'amberDungeonFountain1'
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 2)
end, const.Day)

-- Main Door Entrance
evt.hint[76] = evt.str[25]
evt.map[76] = function()
    evt.MoveToMap{X = -20248, Y = -13457, Z = 48, Direction = 1312, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 4, Name = "amber.odm"}
end

-- Tavern Entrance
evt.HouseDoor(77, 249)
