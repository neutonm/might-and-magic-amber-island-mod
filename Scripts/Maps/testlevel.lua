--[[
Map: Castle Amber
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
    [22] = "+15 AC (Temporary)",
    [23] = "Refreshing",
	[24] = "You need teleportation stone.",
	[25] = "Leave Dungeon"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

function events.LoadMap()

    -- Set gold vein textures to depleted ones after save/load
    for i = 0, 8, 1 do
        local mapVarStr = "MapVar"..tostring(21 + i)
        if evt.Cmp(mapVarStr, 1) then
            evt.SetTexture(75 + i, "Cwb1")
        end
    end    
end

-- MapVar0: Teleportation Pedestal
-- MapVar1: Bookcase -> Scroll

-- ****************************************************************************

-- Start loc house
evt.hint[2] = evt.str[1]
evt.map[2] = function()
    
    evt.EnterHouse(581)
end

-- Start loc elevator top lever
evt.hint[3] = evt.str[2]
evt.map[3] = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Start loc elevator bottom lever
evt.hint[4] = evt.str[2]
evt.map[4] = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 5, State = 2}
end

-- Start loc elevator
evt.hint[5] = evt.str[3]
evt.map[5] = function()
    evt.SetDoorState{Id = 1, State = 0}
end

-- Start loc wall switch (opens start loc grate + secret ambush room)
evt.hint[6] = evt.str[2]
evt.map[6] = function()
    evt.SetDoorState{Id = 2, State = 0}
    evt.SetDoorState{Id = 6, State = 1}
    evt.SetDoorState{Id = 7, State = 0}
end

-- Table button
evt.hint[7] = evt.str[6]
evt.map[7] = function()
    evt.SetDoorState{Id = 9, State = 0}
    evt.SetDoorState{Id = 45, State = 1}
end

-- Basement Bottom Door 
evt.hint[8] = evt.str[5]
evt.map[8] = function()
    evt.SetDoorState{Id = 12, State = 0}
    evt.SetDoorState{Id = 13, State = 0}
end

-- Basement Top Door
evt.hint[9] = evt.str[4]
evt.map[9] = function()
    Game.ShowStatusText(evt.str[11])
end


-- Chests
for i = 0, 19, 1 do
	local hintStr = evt.str[7]
    if Game.Debug then
        hintStr = hintStr .. " #"..tostring(i)
    end
	evt.hint[10 + i] = hintStr
	evt.map[10 + i] = function() 
	    evt.OpenChest(i)

	    -- Exception
		if i == 18 then

			if not evt.Cmp("MapVar30", 1) then
	    		evt.Set("MapVar30", 1)
	    		SummonMonster(80, 4939, -5364, -1675, true)
	    		SummonMonster(80, 4929, -5364, -1675, true)
	    		SummonMonster(80, 4919, -5364, -1675, true)
	    		SummonMonster(80, 4939, -5354, -1675, true)

	    		SummonMonster(80, 5831, -3066, -1410, true)
	    		SummonMonster(80, 5821, -3066, -1410, true)
	    		SummonMonster(80, 5811, -3066, -1410, true)

	    		SummonMonster(81, 4614, -1046, -1216, true)
	    		
	    		SummonMonster(80, 3668, -498, -640, true)
	    		SummonMonster(80, 3658, -498, -640, true)

	    		SummonMonster(81, 5482, 1451, -162, true)

	    		SummonMonster(80, 5753, 2957, 174, true)
	    		SummonMonster(80, 5743, 2957, 174, true)
	    		SummonMonster(80, 5733, 2957, 174, true)

	    		for _, mon in Map.Monsters do
			        if mon.Id >= 79 and mon.Id <= 81 then
			            mon.Hostile = true
			        end
			    end
	    	end
		end
	end
end

-- Bedroom Door
evt.hint[31] = evt.str[4]
evt.map[31] = function()
    evt.SetDoorState{Id = 15, State = 2}
    evt.SetDoorState{Id = 16, State = 2}
end

-- Lounge Room
evt.hint[32] = evt.str[4]
evt.map[32] = function()
    evt.SetDoorState{Id = 17, State = 2}
    evt.SetDoorState{Id = 18, State = 2}
end

-- Storage Room Door
evt.hint[33] = evt.str[4]
evt.map[33] = function()
    evt.SetDoorState{Id = 19, State = 2}
    evt.SetDoorState{Id = 20, State = 2}
end

-- Barracks door
evt.hint[34] = evt.str[4]
evt.map[34] = function()
    evt.SetDoorState{Id = 21, State = 2}
    evt.SetDoorState{Id = 22, State = 2}
end

-- Kitchen door
evt.hint[35] = evt.str[4]
evt.map[35] = function()
    evt.SetDoorState{Id = 23, State = 2}
    evt.SetDoorState{Id = 24, State = 2}
end

-- Dungeon door
evt.hint[36] = evt.str[4]
evt.map[36] = function()
    evt.SetDoorState{Id = 25, State = 2}
    evt.SetDoorState{Id = 26, State = 2}
end

-- Library door
evt.hint[37] = evt.str[4]
evt.map[37] = function()
    evt.SetDoorState{Id = 27, State = 2}
    evt.SetDoorState{Id = 28, State = 2}
end

-- Cave: Broken Elevator Button
evt.hint[38] = evt.str[6]
evt.map[38] = function()
    evt.SetDoorState{Id = 29, State = 2}
end

-- Storage room: secret wall
evt.hint[39] = evt.str[0]
evt.map[39] = function()
    evt.SetDoorState{Id = 30, State = 1}
end

-- Dungeon: Jail switch
evt.hint[40] = evt.str[2]
evt.map[40] = function()
    evt.SetDoorState{Id = 31, State = 2}
    evt.SetDoorState{Id = 32, State = 2}
end

-- Basement: Wall Switch
evt.hint[41] = evt.str[2]
evt.map[41] = function()

    evt.SetDoorState{Id = 33, State = 2}
    evt.SetDoorState{Id = 34, State = 2}
end

-- Mage Lab: Pedestal
evt.hint[42] = evt.str[14]
evt.map[42] = function()

    if not evt.Cmp("MapVar0", 1) then

    	if not evt.All.Cmp("Inventory", 781) then         	-- "Teleportation Gem"
    		evt.FaceAnimation{Player = "All", Animation = 43}
    		Game.ShowStatusText(evt.str[24])
	    	return
	    end
	    evt.Sub("Inventory", 781)
    	evt.Set("MapVar0", 1)
	    evt.SetFacetBit(1,const.FacetBits.Invisible,false)
	    evt.SetFacetBit(2,const.FacetBits.Untouchable,false)
	    evt.PlaySound(14050,Party.X,Party.Y)
	    evt.SetLight(1,true)
	    evt.FaceAnimation{Player = "All", Animation = 93}
		evt.StatusText(17)         				-- "Portal Is Activated"
	end
end

-- Royal chambers: elevator bottom switch
evt.hint[43] = evt.str[2]
evt.map[43] = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 38, State = 1} -- elevator
end

-- Royal chambers: elevator top switch
evt.hint[44] = evt.str[2]
evt.map[44] = function()
    evt.SetDoorState{Id = 37, State = 2}
    evt.SetDoorState{Id = 38, State = 0} -- elevator
end

-- Royal chambers: elevator
evt.hint[45] = evt.str[3]
evt.map[45] = function()
    evt.SetDoorState{Id = 38, State = 0}
end

-- Basement: elevator bottom switch
evt.hint[46] = evt.str[2]
evt.map[46] = function()
    evt.SetDoorState{Id = 39, State = 2}
    evt.SetDoorState{Id = 41, State = 1} -- elevator
end

-- Basement: elevator top switch
evt.hint[47] = evt.str[2]
evt.map[47] = function()
    evt.SetDoorState{Id = 40, State = 2}
    evt.SetDoorState{Id = 41, State = 0} -- elevator
end

-- Basement: elevator
evt.hint[48] = evt.str[3]
evt.map[48] = function()
    evt.SetDoorState{Id = 41, State = 0}
end

-- Tree Chamber: secret door
evt.hint[49] = evt.str[0]
evt.map[49] = function()
    evt.SetDoorState{Id = 42, State = 1}
end

-- Tunnels: wall switch
evt.hint[50] = evt.str[2]
evt.map[50] = function()
    evt.SetDoorState{Id = 43, State = 2}
    evt.SetDoorState{Id = 44, State = 2}
end

-- Start loc: keyhole
evt.hint[51] = evt.str[15]
evt.map[51] = function()
	if evt.Cmp("Inventory", 664) then         	-- "Newname Key"
		evt.SetDoorState{Id = 10, State = 0}
    	evt.SetDoorState{Id = 11, State = 0}
    	evt.Sub("Inventory",664)
	else
		evt.FaceAnimation{Player = "Current", Animation = 18}
		evt.StatusText(16)         				-- "The Door is Locked"
	end
end

-- Mage Chambers: Device Switch
evt.hint[52] = evt.str[2]
evt.map[52] = function()
	--if not evt.Cmp("QBits",7) then
	if not vars.MyQuests.QVar1 then
		--evt.Set("QBits",7)
		vars.MyQuests.QVar1 = true
	    evt.SetDoorState{Id = 46, State = 1}
	    evt.ForPlayer("All")
	    ShowQuestEffect(false,"Add")
		--evt.Add("QBits", 245)         -- "Congratulations"
		--evt.Subtract("QBits", 245)    -- "Congratulations"

		SummonMonster(80, 6266, 2279, -32, true)
		SummonMonster(80, 6266, 2259, -32, true)
		SummonMonster(80, 6266, 2249, -32, true)

		SummonMonster(81, 5482, 1451, -162, true)

		SummonMonster(81, 3668, -498, -640, true)
		SummonMonster(81, 3658, -498, -640, true)
		SummonMonster(81, 3648, -498, -640, true)
	    --evt.FaceAnimation{Player = "Current", Animation = 47}

	    for _, mon in Map.Monsters do
	        if mon.Id >= 79 and mon.Id <= 81 then
	            mon.Hostile = true
	        end
	    end
	end
end

-- Mage Lab: Teleport to Mage Chambers
evt.hint[53] = evt.str[0]
evt.map[53] = function()
	
	if evt.Cmp("MapVar0", 1) then
		evt.MoveToMap{
			X = -2693, Y = 1179, Z = 1, 
			Direction = 1530, LookAngle = 0, SpeedZ = 0, 
			HouseId = 0, Icon = 0, Name = "0"}
	end
end

-- Mage Chamber: Teleport to Mage Lab
evt.hint[54] = evt.str[0]
evt.map[54] = function()
	
	evt.MoveToMap{
		X = 5756, Y = 3018, Z = 97, 
		Direction = 1530, LookAngle = 0, SpeedZ = 0, 
		HouseId = 0, Icon = 0, Name = "0"}
end

-- Locked door hint at start loc
evt.hint[55] = evt.str[4]
evt.map[55] = function()
	if Map.Doors[10].State == 2 then
		evt.FaceAnimation{Player = "Current", Animation = 18}
		evt.StatusText(16)         				-- "The Door is Locked"
	end
end

-- ****************************************************************************
-- Secret loot
evt.hint[56] = evt.str[10]
evt.map[56] = function()
    if not evt.Cmp("MapVar1", 1) then
		evt.Set("MapVar1", 1)
		evt.Add("Gold", 4000)
	end
end
-- ****************************************************************************
-- Lounge Room Bookcase
evt.hint[57] = evt.str[9]
evt.map[57] = function()
    if not evt.Cmp("MapVar2", 1) then
		evt.Set("MapVar2", 1)
		evt.Add("Inventory", 385)	-- "Hour of Power" scroll
	end
end

-- Royal Chambers Bookcase
evt.hint[58] = evt.str[9]
evt.map[58] = function()
    if not evt.Cmp("MapVar3", 1) then
		evt.Set("MapVar3", 1)
		evt.Add("Inventory", 387)	-- "Divine Intervention" scroll
	end
end

-- Library Bookcases
evt.hint[59] = evt.str[9]
evt.map[59] = function()
    if not evt.Cmp("MapVar4", 1) then
		evt.Set("MapVar4", 1)
		evt.Add("Inventory", 315)	-- "Jump" scroll
	end
end

evt.hint[60] = evt.str[9]
evt.map[60] = function()
    if not evt.Cmp("MapVar6", 1) then
		evt.Set("MapVar6", 1)
		evt.Add("Inventory", 315)	-- "Jump" scroll
	end
end

evt.hint[61] = evt.str[9]
evt.map[61] = function()
    if not evt.Cmp("MapVar7", 1) then
		evt.Set("MapVar7", 1)
		evt.Add("Inventory", 315)	-- "Jump scroll
	end
end

evt.hint[62] = evt.str[9]
evt.map[62] = function()
    if not evt.Cmp("MapVar8", 1) then
		evt.Set("MapVar8", 1)
		evt.Add("Inventory", 375)	-- "Power Cure" scroll
	end
end

evt.hint[63] = evt.str[9]
evt.map[63] = function()
    if not evt.Cmp("MapVar9", 1) then
		evt.Set("MapVar9", 1)
		evt.Add("Inventory", 384)	-- "Day Of Protection" scroll
	end
end

evt.hint[64] = evt.str[9]
evt.map[64] = function()
    if not evt.Cmp("MapVar10", 1) then
		evt.Set("MapVar10", 1)
		evt.Add("Inventory", 398)	-- "Soul Drinker" scroll
	end
end

evt.hint[65] = evt.str[9]
evt.map[65] = function()
    if not evt.Cmp("MapVar11", 1) then
		evt.Set("MapVar11", 1)
		evt.Add("Inventory", 307)	-- "Immolation" scroll
	end
end

evt.hint[66] = evt.str[9]
evt.map[66] = function()
    if not evt.Cmp("MapVar12", 1) then
		evt.Set("MapVar12", 1)
		evt.Add("Inventory", 316)	-- "Shield" scroll
	end
end

evt.hint[67] = evt.str[9]
evt.map[67] = function()
    if not evt.Cmp("MapVar13", 1) then
		evt.Set("MapVar13", 1)
		evt.Add("Inventory", 329)	-- "Enchant Item" scroll
	end
end

-- Mage Lab Bookcase
evt.hint[68] = evt.str[9]
evt.map[68] = function()
    if not evt.Cmp("MapVar14", 1) then
		evt.Set("MapVar14", 1)
		evt.Add("Inventory", 387)	-- "Divine Intervention" scroll
	end
end

-- Mage Chamber Bookcases
evt.hint[69] = evt.str[9]
evt.map[69] = function()
    if not evt.Cmp("MapVar15", 1) then
		evt.Set("MapVar15", 1)
		evt.Add("Inventory", 387)	-- "Divine Intervention" scroll
	end
end

evt.hint[70] = evt.str[9]
evt.map[70] = function()
    if not evt.Cmp("MapVar16", 1) then
		evt.Set("MapVar16", 1)
		evt.Add("Inventory", 352)	-- "Raise Dead" scroll
	end
end

evt.hint[86] = evt.str[9]
evt.map[86] = function()
    if not evt.Cmp("MapVar31", 1) then
		evt.Set("MapVar31", 1)
		evt.Add("Inventory", 352)	-- "Raise Dead" scroll
	end
end

evt.hint[87] = evt.str[9]
evt.map[87] = function()
    if not evt.Cmp("MapVar32", 1) then
		evt.Set("MapVar32", 1)
		evt.Add("Inventory", 352)	-- "Raise Dead" scroll
	end
end

-- Storage Room Wine Racks
evt.hint[71] = evt.str[9]
evt.map[71] = function()
    if not evt.Cmp("MapVar17", 1) then
		evt.Set("MapVar17", 1)
		evt.Add("Inventory", 267)	-- "Pure Endurance" potion
	end
end

evt.hint[72] = evt.str[19]
evt.map[72] = function()
    if not evt.Cmp("MapVar18", 1) then
		evt.Set("MapVar18", 1)
		evt.Add("Inventory", 267)	-- "Pure Endurance" potion
	end
end

-- Basement Wineracks
evt.hint[73] = evt.str[19]
evt.map[73] = function()
    if not evt.Cmp("MapVar19", 1) then
		evt.Set("MapVar19", 1)
		evt.Add("Inventory", 264)	-- "Pure Luck" potion
	end
end

evt.hint[74] = evt.str[19]
evt.map[74] = function()
    if not evt.Cmp("MapVar20", 1) then
		evt.Set("MapVar20", 1)
		evt.Add("Inventory", 264)	-- "Pure Luck" potion
	end
end

-- Gold Vein
for i = 0, 8, 1 do
	evt.hint[75 + i] = evt.str[18]  -- "Ore Vein"
	evt.map[75 + i] = function()
		local gold
		local mapVarStr = "MapVar"..tostring(21 + i)
		if evt.Cmp(mapVarStr, 1) then
			return
		end
		gold = math.random(69,420)
		AddGoldExp(gold,0)
		evt.Set(mapVarStr, 1)
		evt.SetTexture(75 + i, "Cwb1")
	end
end

-- Fountain
evt.hint[84] = evt.str[20]
evt.map[84] = function()
    evt.Add("SP", 10)
	evt.StatusText(21)         -- "+10 Spell points restored"
	AddAutonote'amberDungeonFountain6'
end

evt.hint[85] = evt.str[20]
evt.map[85] = function()

	if evt.Cmp("PlayerBits", 1) then
		evt.StatusText(23)         -- "Refreshing!"
		return
	end

    evt.Add("ArmorClassBonus", 15)
    evt.Add("PlayerBits", 1)
	evt.StatusText(22)         -- "+15 AC (Temporary)"
	AddAutonote'amberDungeonFountain7'
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 1)
end, const.Day)

-- EXIT DOOR
-- @todo trigger not set
evt.hint[88] = evt.str[25]
evt.map[88] = function()
    evt.MoveToMap{X = 19042, Y = 21122, Z = 113, Direction = 232, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 4, Name = "amber-east.odm"}
end

