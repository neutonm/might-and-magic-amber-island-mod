--[[
Map: Apple Cave
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
    [26] = "+20 Luck (Temporary)",
    [27] = "+2 Luck permanent"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

function events.LoadMap()

    for _, mon in Map.Monsters do
        if mon.NPC_ID  == 516 then
            if vars.MyQuests.QVarRansom == 3 then
                RemoveMonster(mon)
            end
        elseif mon.NPC_ID  == 518 then
            mon.Hostile = false -- Buster Squeaky
            mon.Ally = 1
        end
    end
end

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 01           00              Grate Door at start
-- 02           00              Grate Door near elevator at start
-- 03           00              Grate Door in guard room near prison
-- 04           00              Grate Door in Prison: South-West
-- 05           00              Grate Door in Prison: North-West
-- 06           00              Grate Door in Prison: North-East
-- 07           00              Grate Door in Prison: South-East
-- 08           00              Grate Door in empty bottle storage room (where water flows into grated floor)
-- 09           00              Grate Door in Cave before Elevator: near checkers board table
-- 10           21              Double-Door: Western at Well Cave, Entrance to Throne Room 
-- 11           21              Double-Door: Eastern at Well Cave, Entrance to Throne Room
-- 12           22              Double-Door: Southern at Throne Room (Western)
-- 13           22              Double-Door: Northern at Throne Room (Western)
-- 14           23              Double-Door: Southern at Throne Room (Eastern)
-- 15           23              Double-Door: Northern at Throne Room (Eastern)
-- 16           24              Double-Door: Western in Map Room
-- 17           24              Double-Door: Eastern in Map Room
-- 18           25              Double-Door: Western, Bridge near Mess Hall
-- 19           25              Double-Door: Eastern, Bridge near Mess Hall
-- 20           26              Double-Door: Western, Mess Hall Entrance
-- 21           26              Double-Door: Eastern, Mess Hall Entrance
-- 22           27              Door: Kitchen Entrance
-- 23           28              Double-Door: Southern, Barracks Entrance
-- 24           28              Double-Door: Northern, Barracks Entrance
-- 25           29              Door: Barracks Balcony
-- 26           30              Double-Door: Southern, Entrance to lower floor of general temple entrance
-- 27           30              Double-Door: Northern, Entrance to lower floor of general temple entrance
-- 28           31              Door: Lower Temple Floor Elevetor
-- 29           00              EMPTY
-- 30           32              Double-Door: Southern, Higher Temple Floor Elevetor Exit
-- 31           32              Double-Door: Northern, Higher Temple Floor Elevetor Exit
-- 32           33              Double-Door: Western, Temple Entrance
-- 33           33              Double-Door: Eastern, Temple Entrance
-- 34           34              Double-Door: Western, Cave, Small Storage Room
-- 35           34              Double-Door: Eastern, Cave, Small Storage Room
-- 36           35              Double-Door: Western, Prison Sector Entrance
-- 37           35              Double-Door: Eastern, Prison Sector Entrance
-- 38           36              Double-Door: Western, Prison Entrance
-- 39           36              Double-Door: Eastern, Prison Entrance
-- 40           37              Double-Door: Southern, Guard Room
-- 41           37              Double-Door: Northern, Guard Room
-- 42           38              Secret Door: Mess Hall
-- 43           39              Secret Door: Water Tunnel
-- 44           40              Secret Door: Cave Bottom
-- 45           41              Secret Door: Temple
-- 46           42              Secret Door: Prison Elevator
-- 47           43              Double-Door: Southern, Water Flowing Storage (Western)
-- 48           43              Double-Door: Southern, Water Flowing Storage (Western)
-- 49           44              Double-Door: Western, Water Flowing Storage (Eastern)
-- 50           44              Double-Door: Eastern, Water Flowing Storage (Eastern)

-- ELEVATORS
-- 51           45              Starting Location
-- 52           46              Large Cave, Platform
-- 53           47              Temple, Lower Floor
-- 54           48              Water Tunnel
-- 55           49              Prison, Guard's Room

-- LEVERS / SWITCHES
-- 56           50              Elevator Switch: Starting Location, Top (Door #51)
-- 57           51              Elevator Switch: Starting Location, Bottom (Door #51)
-- 58           52              Elevator Switch: Large Cave, Platform, Top (Door #52)
-- 59           53              Elevator Switch: Large Cave, Platform, Bottom (Door #52)
-- 60           54              Elevator Switch: Temple, Lower Floor, Top (Door #53)
-- 61           55              Elevator Switch: Temple, Lower Floor, Bottom (Door #53)
-- 62           56              Elevator Switch: Water Tunnel, Top (Door #54)
-- 63           57              Elevator Switch: Water Tunnel, Bottom (Door #54)
-- 64           58              Elevator Switch: Prison, Guard's Room, Top (Door #55)
-- 65           59              Elevator Switch: Prison, Guard's Room, Bottom (Door #55)
-- 66           60              Grate Door Switch: Start Location (Door #1)
-- 67           61              Closed Door Switch: Well Cave, Flooded Room (Door #10/#11)
-- 68           62              Pull Lever: Fisherman's Room (Door #9)

-- BUTTONS
-- 69           63              Secret Room, Grate Door (#08)
-- 70           64              Guard's Room, Grate Doors (#02/#03)
-- 71           65              Prison, Bottom-Left Button, Grate Door SW (#04)
-- 72           66              Prison, Top-Left Button, Grate Door SW (#05)
-- 73           67              Prison, Bottom-Right Button, Grate Door SW (#07)
-- 74           68              Secret Prison Cell Button (SE Cell) (#06)

-- ****************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Start Location, Near the mine cart
-- 01           02              Start Location, Secret chest on a wall
-- 02           03              Well cave, Flooded Room
-- 03           04              Throne Room, Western Chest
-- 04           05              Throne Room, Eastern Chest
-- 05           06              Secret Room, Eastern Chest
-- 06           07              Secret Room, Western Chest
-- 07           08              Flowing Water Storage Room, Cab
-- 08           09              Kitchen, Cab
-- 09           10              Secret, Mess Hall
-- 10           11              Barracks, Furniture
-- 11           12              Barracks, Balcony
-- 12           13              Mess Hall Entrance, Side Cave
-- 13           14              Fisherman's Room
-- 14           15              Cave Storage Room, Cab
-- 15           16              Guard's Room, Cab
-- 16           17              Start Location, Trashed Room Below

-- ****************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Bookcase     69              Map Room, Western
-- Bookcase     70              Map Room, Eastern
-- Bookcase     71              Library, Western, W Side
-- Bookcase     72              Library, Western, E Side
-- Bookcase     73              Library, Central, W Side
-- Bookcase     74              Library, Central, E Side
-- Bookcase     75              Library, Eastern, W Side
-- Bookcase     76              Temple, Lower Floor, Western
-- Bookcase     77              Temple, Lower Floor, Northern
-- Bookcase     78              Temple, Lower Floor, Broke Entrance Room, Northern
-- Reserve Triggers: +12
-- Winerack     91              Kitchen
-- Winerack     92              Cave, Small Storage Room
-- Fountain     93              Mine Cart Room
-- Fountain     94              Well
-- Fountain     95              Throne Room, NE
-- Fountain     96              Throne Room, SE
-- Fountain     97              Throne Room, SW
-- Fountain     98              Throne Room, NW
-- Fountain     99              Temple, Higher Floor
-- Gold         100-108             

-- MONSTERS
-- GROUP 1: Animalists as Bootlegers
-- GROUP 2: MM6 Mages as Pirate Wizards
-- GROUP 3: Raiders
-- UNGROUPED: Ratmen (Smaller amount)
-- BOSS 1: Regnan Pirate at Throne Room (gold)
-- BOSS 2: Sun Priest at Temple (item)

-- TODO:
-- Monster Spawns
-- Add level to Datatables
-- Add monster table entry into datatable
----- Import New Monster
-- Compile & Test
-- Add chest loot / Approximate Balance
----- Add Scroll explaining about the button in Guard's Room
----- Add Scroll lore (Deal with Archmage: extortion plans for X families)
-- Set up proper bonuses from Bookcases, Wineracks and Fountains

-- Issue:   Standing between elevation and a flat surface in Mine Cart Room 
--          by the switch will cause player to fall down through textures
--          Fixing this shit means remaking doors/switches and triggers...

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
-- Double-Door: Well Cave, Entrance to Throne Room 
evt.hint[21] = evt.str[4]
evt.map[21] = function()
    
    if evt.Cmp("MapVar42", 1) == false then
        evt.FaceAnimation{Player = "Current", Animation = 18}
	    evt.StatusText(16)         				-- "The Door is Locked"
    end
end

-- Double-Door: Throne Room (Western)
evt.hint[22] = evt.str[4]
evt.map[22] = function()
    evt.SetDoorState{Id = 12, State = 2}
    evt.SetDoorState{Id = 13, State = 2}
end

-- Double-Door: Throne Room (Eastern)
evt.hint[23] = evt.str[4]
evt.map[23] = function()
    evt.SetDoorState{Id = 14, State = 2}
    evt.SetDoorState{Id = 15, State = 2}
end

-- Double-Door: Map Room
evt.hint[24] = evt.str[4]
evt.map[24] = function()
    evt.SetDoorState{Id = 16, State = 2}
    evt.SetDoorState{Id = 17, State = 2}
end

-- Double-Door: Bridge near Mess Hall
evt.hint[25] = evt.str[4]
evt.map[25] = function()
    evt.SetDoorState{Id = 18, State = 2}
    evt.SetDoorState{Id = 19, State = 2}
end

-- Double-Door: Mess Hall Entrance
evt.hint[26] = evt.str[4]
evt.map[26] = function()
    evt.SetDoorState{Id = 20, State = 2}
    evt.SetDoorState{Id = 21, State = 2}
end

-- Door: Kitchen Entrance
evt.hint[27] = evt.str[4]
evt.map[27] = function()
    evt.SetDoorState{Id = 22, State = 2}
end

-- Double-Door: Barracks Entrance
evt.hint[28] = evt.str[4]
evt.map[28] = function()
    evt.SetDoorState{Id = 23, State = 2}
    evt.SetDoorState{Id = 24, State = 2}
end

-- Door: Barracks Balcony
evt.hint[29] = evt.str[4]
evt.map[29] = function()
    evt.SetDoorState{Id = 25, State = 2}
end

-- Double-Door: Entrance to lower floor of general temple entrance
evt.hint[30] = evt.str[4]
evt.map[30] = function()
    evt.SetDoorState{Id = 26, State = 2}
    evt.SetDoorState{Id = 27, State = 2}
end

-- Door: Lower Temple Floor Elevetor
evt.hint[31] = evt.str[4]
evt.map[31] = function()
    evt.SetDoorState{Id = 28, State = 2}
end

-- DOOR #29: EMPTY

-- Double-Door: Higher Temple Floor Elevetor Exit
evt.hint[32] = evt.str[4]
evt.map[32] = function()
    evt.SetDoorState{Id = 30, State = 2}
    evt.SetDoorState{Id = 31, State = 2}
end

-- Double-Door: Temple Entrance
evt.hint[33] = evt.str[4]
evt.map[33] = function()
    evt.SetDoorState{Id = 32, State = 2}
    evt.SetDoorState{Id = 33, State = 2}
end

-- Double-Door: Cave, Small Storage Room
evt.hint[34] = evt.str[4]
evt.map[34] = function()
    evt.SetDoorState{Id = 34, State = 2}
    evt.SetDoorState{Id = 35, State = 2}
end

-- Double-Door: Prison Sector Entrance
evt.hint[35] = evt.str[4]
evt.map[35] = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 37, State = 2}
end

-- Double-Door: Prison Entrance
evt.hint[36] = evt.str[4]
evt.map[36] = function()
    evt.SetDoorState{Id = 38, State = 2}
    evt.SetDoorState{Id = 39, State = 2}
end

-- Double-Door: Guard's Room
evt.hint[37] = evt.str[4]
evt.map[37] = function()
    evt.SetDoorState{Id = 40, State = 2}
    evt.SetDoorState{Id = 41, State = 2}
end

-- Secret Door: Mess Hall
evt.hint[38] = evt.str[4]
evt.map[38] = function()
    evt.SetDoorState{Id = 42, State = 2}
end

-- Secret Door: Water Tunnel
evt.hint[39] = evt.str[4]
evt.map[39] = function()
    evt.SetDoorState{Id = 43, State = 2}
end

-- Secret Door: Cave Bottom
evt.hint[40] = evt.str[4]
evt.map[40] = function()
    evt.SetDoorState{Id = 44, State = 2}
end

-- Secret Door: Temple
evt.hint[41] = evt.str[4]
evt.map[41] = function()
    evt.SetDoorState{Id = 45, State = 2}
end

-- Secret Door: Prison Elevator
evt.hint[42] = evt.str[4]
evt.map[42] = function()
    evt.SetDoorState{Id = 46, State = 2}
end

-- Double-Door: Water Flowing Storage (Western)
evt.hint[43] = evt.str[4]
evt.map[43] = function()
    evt.SetDoorState{Id = 47, State = 2}
    evt.SetDoorState{Id = 48, State = 2}
end

-- Double-Door: Water Flowing Storage (Southern)
evt.hint[44] = evt.str[4]
evt.map[44] = function()
    evt.SetDoorState{Id = 49, State = 2}
    evt.SetDoorState{Id = 50, State = 2}
end

-- ****************************************************************************
-- ELEVATORS

-- Elevator: Starting Location
evt.hint[45] = evt.str[3]
evt.map[45] = function()
    evt.SetDoorState{Id = 51, State = 2}
end

-- Elevator: Large Cave, Platform
evt.hint[46] = evt.str[3]
evt.map[46] = function()
    evt.SetDoorState{Id = 52, State = 2}
end

-- Elevator: Temple, Lower Floor
evt.hint[47] = evt.str[3]
evt.map[47] = function()
    evt.SetDoorState{Id = 53, State = 2}
end

-- Elevator: Water Tunnel
evt.hint[48] = evt.str[3]
evt.map[48] = function()
    evt.SetDoorState{Id = 54, State = 2}
end

-- Elevator: Prison, Guard Room
evt.hint[49] = evt.str[3]
evt.map[49] = function()
    evt.SetDoorState{Id = 55, State = 2}
end

-- ****************************************************************************
-- LEVERS / SWITCHES:

-- Elevator Switch: Starting Location, Top
evt.hint[50] = evt.str[5]
evt.map[50] = function()
    evt.SetDoorState{Id = 51, State = 2}
    evt.SetDoorState{Id = 56, State = 2}
end

-- Elevator Switch: Starting Location, Bottom
evt.hint[51] = evt.str[5]
evt.map[51] = function()
    evt.SetDoorState{Id = 51, State = 2}
    evt.SetDoorState{Id = 57, State = 2}
end

-- Elevator Switch: Large Cave, Platform, Top
evt.hint[52] = evt.str[5]
evt.map[52] = function()
    evt.SetDoorState{Id = 52, State = 2}
    evt.SetDoorState{Id = 58, State = 2}
end

-- Elevator Switch: Large Cave, Platform, Bottom
evt.hint[53] = evt.str[5]
evt.map[53] = function()
    evt.SetDoorState{Id = 52, State = 2}
    evt.SetDoorState{Id = 59, State = 2}
end

-- Elevator Switch: Temple, Lower Floor, Top
evt.hint[54] = evt.str[5]
evt.map[54] = function()
    evt.SetDoorState{Id = 53, State = 2}
    evt.SetDoorState{Id = 60, State = 2}
end

-- Elevator Switch: Temple, Lower Floor, Bottom
evt.hint[55] = evt.str[5]
evt.map[55] = function()
    evt.SetDoorState{Id = 53, State = 2}
    evt.SetDoorState{Id = 61, State = 2}
end

-- Elevator Switch: Water Tunnel, Top
evt.hint[56] = evt.str[5]
evt.map[56] = function()
    evt.SetDoorState{Id = 54, State = 2}
    evt.SetDoorState{Id = 62, State = 2}
end

-- Elevator Switch: Water Tunnel, Bottom
evt.hint[57] = evt.str[5]
evt.map[57] = function()
    evt.SetDoorState{Id = 54, State = 2}
    evt.SetDoorState{Id = 63, State = 2}
end

-- Elevator Switch: Prison, Guard's Room, Top
evt.hint[58] = evt.str[5]
evt.map[58] = function()
    evt.SetDoorState{Id = 55, State = 2}
    evt.SetDoorState{Id = 64, State = 2}
end

-- Elevator Switch: Prison, Guard's Room, Bottom
evt.hint[59] = evt.str[5]
evt.map[59] = function()
    evt.SetDoorState{Id = 55, State = 2}
    evt.SetDoorState{Id = 65, State = 2}
end

-- Grate Door Switch: Start Location
evt.hint[60] = evt.str[5]
evt.map[60] = function()
    evt.SetDoorState{Id = 66, State = 2}
    evt.SetDoorState{Id = 1, State = 2}
end

-- Closed Door Switch: Well Cave, Flooded Room
evt.hint[61] = evt.str[5]
evt.map[61] = function()
    evt.Set("MapVar42",1)
    evt.SetDoorState{Id = 67, State = 1}
    evt.SetDoorState{Id = 10, State = 0}
    evt.SetDoorState{Id = 11, State = 0}
end

-- Pull Lever: Fisherman's Room
evt.hint[62] = evt.str[2]
evt.map[62] = function()
    evt.SetDoorState{Id = 68, State = 2}
    evt.SetDoorState{Id = 9, State = 2}
end
-- ****************************************************************************
-- BUTTONS:

-- Button: Secret Room, Bottle Storage Room
evt.hint[63] = evt.str[6]
evt.map[63] = function()
    evt.SetDoorState{Id = 69, State = 2}
    evt.SetDoorState{Id = 8, State = 2}
end

-- Button: Guard's Room, Grate Doors
evt.hint[64] = evt.str[6]
evt.map[64] = function()
    evt.SetDoorState{Id = 70, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
    evt.SetDoorState{Id = 3, State = 2}
end

-- Button: Prison, Bottom-Left Button, Grate Door SW
evt.hint[65] = evt.str[6]
evt.map[65] = function()
    evt.SetDoorState{Id = 71, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Button: Prison, Top-Left Button, Grate Door NW
evt.hint[66] = evt.str[6]
evt.map[66] = function()
    evt.SetDoorState{Id = 72, State = 2}
    evt.SetDoorState{Id = 5, State = 2}
end

-- Button: Prison, Bottom-Right Button, Grate Door SE
evt.hint[67] = evt.str[6]
evt.map[67] = function()
    evt.SetDoorState{Id = 73, State = 2}
    evt.SetDoorState{Id = 7, State = 2}
end

-- Button: Prison, SE Cell, Grate Door NE
evt.hint[68] = evt.str[6]
evt.map[68] = function()
    evt.SetDoorState{Id = 74, State = 2}
    evt.SetDoorState{Id = 6, State = 2}
end

-- ****************************************************************************
-- BOOKCASES

-- Bookcase: Map Room, Western
evt.hint[69] = evt.str[9]
evt.map[69] = function()
    if not evt.Cmp("MapVar1", 1) then
		evt.Set("MapVar1", 1)
		evt.Add("Inventory", 371)	-- "Cure Poison" scroll
	end
end

-- Bookcase: Map Room, Eastern
evt.hint[70] = evt.str[9]
evt.map[70] = function()
    if not evt.Cmp("MapVar2", 1) then
		evt.Set("MapVar2", 1)
		evt.Add("Inventory", 373)	-- "Cure Disease" scroll
	end
end

-- Bookcase: Library, Western, W Side
evt.hint[71] = evt.str[9]
evt.map[71] = function()
    if not evt.Cmp("MapVar3", 1) then
		evt.Set("MapVar3", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

-- Bookcase: Library, Western, E Side
evt.hint[72] = evt.str[9]
evt.map[72] = function()
    if not evt.Cmp("MapVar4", 1) then
		evt.Set("MapVar4", 1)
		evt.Add("Inventory", 311)	-- "Wizard Eye" scroll
	end
end

-- Bookcase: Library, Central, W Side
evt.hint[73] = evt.str[9]
evt.map[73] = function()
    if not evt.Cmp("MapVar5", 1) then
		evt.Set("MapVar5", 1)
		evt.Add("Inventory", 303)	-- "Fire Aura" scroll
	end
end

-- Bookcase: Library, Central, E Side
evt.hint[74] = evt.str[9]
evt.map[74] = function()
    if not evt.Cmp("MapVar6", 1) then
		evt.Set("MapVar6", 1)
		evt.Add("Inventory", 305)	-- "Fireball" scroll
	end
end

-- Bookcase: Library, Eastern, W Side
evt.hint[75] = evt.str[9]
evt.map[75] = function()
    if not evt.Cmp("MapVar7", 1) then
		evt.Set("MapVar7", 1)
		evt.Add("Inventory", 316)	-- "Shield" scroll
	end
end

-- Bookcase: Temple, Lower Floor, Western
evt.hint[76] = evt.str[9]
evt.map[76] = function()
    if not evt.Cmp("MapVar8", 1) then
		evt.Set("MapVar8", 1)
		evt.Add("Inventory", 385)	-- "Hour of Power" scroll
	end
end

-- Bookcase: Temple, Lower Floor, Northern
evt.hint[77] = evt.str[9]
evt.map[77] = function()
    if not evt.Cmp("MapVar9", 1) then
		evt.Set("MapVar9", 1)
		evt.Add("Inventory", 337)	-- "Stone Skin" scroll
	end
end

-- Bookcase: Temple, Lower Floor, Broke Entrance Room, Northern
evt.hint[78] = evt.str[9]
evt.map[78] = function()
    if not evt.Cmp("MapVar10", 1) then
		evt.Set("MapVar10", 1)
		evt.Add("Inventory", 345)	-- "Bless" scroll
	end
end

-- ****************************************************************************
-- WINERACKS

-- Winerack: Kitchen
evt.hint[91] = evt.str[19]
evt.map[91] = function()
    if not evt.Cmp("MapVar23", 1) then
		evt.Set("MapVar23", 1)
		evt.Add("Inventory", 240)	-- "Might Boost" potion
	end
end

-- Winerack: Cave, Small Storage Room
evt.hint[92] = evt.str[19]
evt.map[92] = function()
    if not evt.Cmp("MapVar24", 1) then
		evt.Set("MapVar24", 1)
		evt.Add("Inventory", 233)	-- "Recharge Item" potion
	end
end

-- ****************************************************************************
-- FOUNTAINS

-- Fountain: Main Hall Fountain
evt.hint[93] = evt.str[20]
evt.map[93] = function()
    if evt.Cmp("PlayerBits", 10) then
		evt.StatusText(23)         -- "Refreshing!"
	else
		evt.Add("LuckBonus", 20)
		evt.Set("PlayerBits", 10)
		evt.StatusText(26)         -- "+ 20 Luck (Temporary)"
	end
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 10)
end, const.Day)

-- Fountain: Well
evt.hint[94] = evt.str[20]
evt.map[94] = function()
    
    if evt.Cmp("MapVar40", 8) == false then
        evt.Add("MapVar40", 1)
        evt.Add("BaseLuck", 2)
        evt.StatusText(27)         -- "+2 Luck permanent"
        return
    else
        evt.StatusText(23)         -- "Refreshing!"
    end
end

-- Fountain: Throne Room, NE
evt.hint[95] = evt.str[20]
evt.map[95] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Throne Room, SE
evt.hint[96] = evt.str[20]
evt.map[96] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Throne Room, SW
evt.hint[97] = evt.str[20]
evt.map[97] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Throne Room, NW
evt.hint[98] = evt.str[20]
evt.map[98] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Temple, Higher Floor
evt.hint[99] = evt.str[20]
evt.map[99] = function()
    if evt.Cmp("MapVar41", 10) == false then
        evt.Add("MapVar41", 1)
        evt.Add("SP", 10)
        evt.StatusText(21)         -- "+10 Spell points restored"
    else
        evt.StatusText(23)         -- "Refreshing!"
    end
end
-- ****************************************************************************
-- Gold Vein
for i = 0, 9, 1 do
	evt.hint[100 + i] = evt.str[18]  -- "Ore Vein"
	evt.map[100 + i] = function()
		local gold
		local mapVarStr = "MapVar"..tostring(25 + i)
		if evt.Cmp(mapVarStr, 1) then
			return
		end
		gold = math.random(69,420)
		AddGoldExp(gold,0)
		evt.Set(mapVarStr, 1)
		evt.SetTexture(100 + i, "Cwb1")
	end
end


-- Main Door Entrance
evt.hint[110] = evt.str[25]
evt.map[110] = function()
    evt.MoveToMap{X = -20165, Y = 21150, Z = 1, Direction = 264, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 4, Name = "amber.odm"}
end

-- Temple Secret Door
evt.hint[111] = evt.str[4]
evt.map[111] = function()
    evt.EnterHouse(581)
end
