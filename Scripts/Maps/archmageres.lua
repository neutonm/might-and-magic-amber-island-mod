--[[
Map: Archmage Residence
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
    [21] = "+10 Hit and Spell points restored",
    [22] = "+5 AC (Temporary)",
    [23] = "Refreshing",
    [24] = "You need teleportation stone.",
    [25] = "Leave Dungeon",
    [26] = "Flower",
    [27] = "Somebody already pressed the button!",
    [28] = "+1 Elemental Resistances permanenty"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

local TeleportActivatorItem = 781
local WorkshopKeyItemID = 786
function OpenWorkshopDoor()
    if evt.Cmp("MapVar1", 1) and evt.Cmp("MapVar2", 1) then
        evt.Set("MapVar3", 1)
        evt.SetDoorState{Id = 9, State = 2}
        evt.SetDoorState{Id = 10, State = 2}
    end
end

function events.LoadMap()

    -- Workshop door keyhole lighs reset
    if evt.Cmp("MapVar1", 1) then
        evt.SetTexture(1, "solid03")
    end
    if evt.Cmp("MapVar2", 1) then
        evt.SetTexture(2, "solid03")
    end
    
end

-- ISSUES
-- Going from Amber Island to this dungeon crashes the game
----- Suggestion: make a transition mini-dungeon. Amber island and Archmage Residence both exceed polygon limit - it needs to unload itself before entering the dungeon.

-- TODO:
-- Monsters
-- Teleportation Gem for Swamp port + Letter

-- ****************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION
-- 1            Western Keyhole, Workshop, Red Light
-- 2            Eastern Keyhole, Workshop, Red Light
-- 3            Western Teleport Room, Pedestal, Gem
-- 4            Eastern Teleport Room, Pedestal, Gem
-- 5            Western Teleportator Room & Realm port texture
-- 6            Eastern Teleportator Room & Realm port texture

-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1      Western Keyhole, Workshop Door
-- MapVar2      Eastern Keyhole, Workshop Door
-- MapVar3      Workshop Door Opened
-- MapVar4      Western Teleport Room Pedestal
-- MapVar5      Eastern Teleport Room Pedestal

-- MONSTERS
-- GROUP 1: Fire Elemental
-- GROUP 2: Air Elemental
-- GROUP 3: Earth Elemental
-- UNGROUPED: Water Elemental
-- BOSS 1: Western Realm, Minotaur
-- BOSS 2: Eastern Realm, Minotaur

-- ****************************************************************************

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 01/02        21              Dungeon Entrance
-- 03/04        22              Entrance to Fountain Chamber
-- 05/06        23              Fountain Chamber Door to West
-- 07/08        24              Fountain Chamber Door to East
-- 09/10        25              Fountain Chamber Door to Workshop
-- 11/12        26              Guest Room 
-- 13/14        27              Rec Room 
-- 15/16        28              Diner Room 
-- 17/18        29              Wine Cellar 
-- 19/20        30              Bedroom 
-- 21/22        31              WC
-- 23/24        32              Garden Storage Room: West
-- 25/26        33              Garden Storage Room: North
-- 27/28        34              Garden Storage Room: East
-- 29/30        35              Alchemy  Room
-- 31/--        36              Summoning Chamber
-- 33/34        37              Office
-- 35/36        38              Library
-- 37/38        39              Shortcut to Garden: South
-- 39/40        40              Shortcut to Garden: North
-- 41/42        41              Eastern Teleportation Chamber
-- 43           42              Secret: Fountain Chamber
-- 44           43              Secret: Diner Room
-- 45           44              Secret: Garden Storage Room
-- 46           45              Secret: Wall Opposite to Alchemy Room Door
-- 47           46              Secret: Western Key Realm (Waterfall Chamber)
-- 48           47              Quest: Garden Wall (Flower)

-- ****************************************************************************

-- BUTTONS
-- 49           48              Button: Eastern Teleportation Chamber (Sun Symbol)

-- ****************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Guest Room, 2nd Floor
-- 01           02              Rec Room
-- 02           03              Wine Cellar
-- 03           04              Bedroom
-- 04           05              Garden Storage Room
-- 05           06              Alchemy Room
-- 06           07              Summoning Chamber (QUEST: Gemstone)
-- 07           08              Office
-- 08           09              Workshop
-- 09           10              Western Realm (QUEST: Key)
-- 10           11              Eastern Realm (QUEST: Key)
-- 11           12              Secret: Eastern Realm
-- 12           13              Secret: Fountain Chamber
-- 13           14              Secret: Diner Room
-- 14           15              Secret: Garden Storage Room
-- 15           16              Water Tunnels, West 
-- 16           17              Water Tunnels, East 
-- 17           18              Water Tunnels, End Cave

-- ****************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Key Hole     49              Western Keyhole, Workshop Door
-- Key Hole     50              Eastern Keyhole, Workshop Door
-- Teleport     51              Western Teleport Room, Platform
-- Teleport     52              Western Realm, Platform
-- Teleport     53              Eastern Teleport Room, Platform
-- Teleport     54              Eastern Realm, Platform
-- Pedestal     55              Western Teleport Room
-- Pedestal     56              Eastern Teleport Room
-- Bookcase     60              Rec Room, Entrance              
-- Bookcase     61              Rec Room, Pool Table          
-- Bookcase     62              Bedroom       
-- Bookcase     63              WC       
-- Bookcase     64              Summoning Chamber       
-- Bookcase     65              Office, North     
-- Bookcase     66              Office, East     
-- Bookcase     67              Office, Window 
-- Bookcase     68              Library, SW 
-- Bookcase     69              Library, W 
-- Bookcase     70              Library, NW 
-- Bookcase     71              Library, NE 
-- Bookcase     72              Library, SE 
-- Bookcase     73              Library, Block, SW, S 
-- Bookcase     74              Library, Block, SW, N 
-- Bookcase     75              Library, Block, NW, S 
-- Bookcase     76              Library, Block, NW, N 
-- Bookcase     77              Library, Block, NE, S 
-- Bookcase     78              Library, Block, NE, N 
-- Bookcase     79              Library, Block, SE, S 
-- Bookcase     80              Library, Block, SE, N 
-- Bookcase     81              Workshop
-- Winerack     82              Rec Room
-- Winerack     83              Diner Room
-- Fountain     84              Fountain Chamber
-- Fountain     85              Eastern Hall
-- Fountain     86              Western Teleport Room
-- Fountain     87              Eastern Teleport Room
-- Trigger      88              Bath
-- Trigger      89              Library, Water Ball
-- Fountain     90              Guest Room, Secret
-- Button       91              Guest Room, Secret
-- EXIT         92              Start Room

-- TODO:

-- Compilation issue: too many polygons + bad intersection of branches between portals from western realm 
-- UPDATE: not quite a polygon problem, i think the branches are either going outside internal polygons or interesct with portal face

----- Fix major issues
-------- failed compilation (it's not)
-------- rogue vertices
-------- tunnel issue below bridge
-------- summoning chamber door
-------- garden wall not actually opening
-------- bad teleportation from west tp room to west realm
-------- Add Door opening sound: take it from thief 1 (picklock successful)
----- Fix minor issues (as stated below) + textures/face attributes
----- Western Realm: clouds must teleport back to tp pos
----- Test
----- Monsters
----- Test

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
-- Double-Door: Well Cave, Entrance to Throne Room 
evt.hint[21] = evt.str[4]
evt.map[21] = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Double-Door: Entrance to Fountain Chamber
evt.hint[22] = evt.str[4]
evt.map[22] = function()
    evt.SetDoorState{Id = 3, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Double-Door: Fountain Chamber Door to West
evt.hint[23] = evt.str[4]
evt.map[23] = function()
    evt.SetDoorState{Id = 5, State = 2}
    evt.SetDoorState{Id = 6, State = 2}
end

-- Double-Door: Fountain Chamber Door to East
evt.hint[24] = evt.str[4]
evt.map[24] = function()
    evt.SetDoorState{Id = 7, State = 2}
    evt.SetDoorState{Id = 8, State = 2}
end

-- Double-Door: Fountain Chamber Door to Workshop
evt.hint[25] = evt.str[4]
evt.map[25] = function()

    if not evt.Cmp("MapVar3", 1) then
        evt.FaceAnimation{Player = "Current", Animation = 18}
        evt.StatusText(16)         				-- "The Door is Locked"
    else
        OpenWorkshopDoor() -- just in case
    end

    -- Door
    --evt.SetDoorState{Id = 9, State = 2}
    --evt.SetDoorState{Id = 10, State = 2}
end

-- Double-Door: Guest Room 
evt.hint[26] = evt.str[4]
evt.map[26] = function()
    evt.SetDoorState{Id = 11, State = 2}
    evt.SetDoorState{Id = 12, State = 2}
end

-- Double-Door: Rec Room 
evt.hint[27] = evt.str[4]
evt.map[27] = function()
    evt.SetDoorState{Id = 13, State = 2}
    evt.SetDoorState{Id = 14, State = 2}
end

-- Double-Door: Diner Room 
evt.hint[28] = evt.str[4]
evt.map[28] = function()
    --evt.SetDoorState{Id = 15, State = 2}
    evt.SetDoorState{Id = 16, State = 0}
end

-- Double-Door: Wine Cellar 
evt.hint[29] = evt.str[4]
evt.map[29] = function()
    evt.SetDoorState{Id = 17, State = 2}
    evt.SetDoorState{Id = 18, State = 2}
end

-- Double-Door: Bedroom 
evt.hint[30] = evt.str[4]
evt.map[30] = function()
    evt.SetDoorState{Id = 19, State = 2}
    evt.SetDoorState{Id = 20, State = 2}
end

-- Double-Door: WC 
evt.hint[31] = evt.str[4]
evt.map[31] = function()
    evt.SetDoorState{Id = 21, State = 2}
    evt.SetDoorState{Id = 22, State = 2}
end

-- Double-Door: Garden Storage Room: West 
evt.hint[32] = evt.str[4]
evt.map[32] = function()
    evt.SetDoorState{Id = 23, State = 2}
    evt.SetDoorState{Id = 24, State = 2}
end

-- Double-Door: Garden Storage Room: North 
evt.hint[33] = evt.str[4]
evt.map[33] = function()
    evt.SetDoorState{Id = 25, State = 2}
    evt.SetDoorState{Id = 26, State = 2}
end

-- Double-Door: Garden Storage Room: East 
evt.hint[34] = evt.str[4]
evt.map[34] = function()
    evt.SetDoorState{Id = 27, State = 2}
    evt.SetDoorState{Id = 28, State = 2}
end

-- Double-Door: Alchemy Room
evt.hint[35] = evt.str[4]
evt.map[35] = function()
    evt.SetDoorState{Id = 29, State = 2}
    evt.SetDoorState{Id = 30, State = 2}
end

-- Double-Door: Summoning Chamber
evt.hint[36] = evt.str[4]
evt.map[36] = function()
    evt.SetDoorState{Id = 31, State = 2}
    --evt.SetDoorState{Id = 32, State = 2}
end

-- Double-Door: Office
evt.hint[37] = evt.str[4]
evt.map[37] = function()
    evt.SetDoorState{Id = 33, State = 2}
    evt.SetDoorState{Id = 34, State = 2}
end

-- Double-Door: Library
evt.hint[38] = evt.str[4]
evt.map[38] = function()
    evt.SetDoorState{Id = 35, State = 2}
    evt.SetDoorState{Id = 36, State = 2}
end

-- Double-Door: Shortcut to Garden: South
evt.hint[39] = evt.str[4]
evt.map[39] = function()
    evt.SetDoorState{Id = 37, State = 2}
    evt.SetDoorState{Id = 38, State = 2}
end

-- Double-Door: Shortcut to Garden: North
evt.hint[40] = evt.str[4]
evt.map[40] = function()
    evt.SetDoorState{Id = 39, State = 2}
    evt.SetDoorState{Id = 40, State = 2}
end

-- Double-Door: Eastern Teleportation Chamber
evt.hint[41] = evt.str[4]
evt.map[41] = function()
    --evt.SetDoorState{Id = 41, State = 2}
    --evt.SetDoorState{Id = 42, State = 2}
    evt.FaceAnimation{Player = "Current", Animation = 18}
	evt.StatusText(16)         				-- "The Door is Locked"
end

-- Secret: Fountain Chamber
evt.hint[42] = evt.str[4]
evt.map[42] = function()
    evt.SetDoorState{Id = 43, State = 2}
end

-- Secret: Diner Room
evt.hint[43] = evt.str[4]
evt.map[43] = function()
    evt.SetDoorState{Id = 44, State = 2}
end

-- Secret: Garden Storage Room
evt.hint[44] = evt.str[4]
evt.map[44] = function()
    evt.SetDoorState{Id = 45, State = 2}
end

-- Secret: Garden Storage Room
evt.hint[45] = evt.str[4]
evt.map[45] = function()
    evt.SetDoorState{Id = 46, State = 2}
end

-- Secret: Western Key Realm (Waterfall Chamber)
evt.hint[46] = evt.str[4]
evt.map[46] = function()
    evt.SetDoorState{Id = 47, State = 2}
end

-- Quest: Garden Wall (Flower)
evt.hint[47] = evt.str[26]
evt.map[47] = function()
    evt.SetDoorState{Id = 48, State = 2}
end

-- ****************************************************************************
-- BUTTONS:

-- Button: Eastern Teleportation Chamber (Sun Symbol)
evt.hint[48] = evt.str[6]
evt.map[48] = function()
    evt.SetDoorState{Id = 49, State = 2}
    -- Door
    evt.SetDoorState{Id = 41, State = 2}
    evt.SetDoorState{Id = 42, State = 2}
end

-- ****************************************************************************
-- MISC:

-- Quest: Western Keyhole, Workshop Door
evt.hint[49] = evt.str[15]
evt.map[49] = function()
    if not evt.Cmp("MapVar1", 1) then
        if evt.All.Cmp("Inventory", WorkshopKeyItemID) then         	-- "Newname Key"
            evt.Set("MapVar1", 1)
            evt.SetTexture(1, "solid03")
            evt.Sub("Inventory",WorkshopKeyItemID)
            evt.FaceAnimation{Player = "All", Animation = 43}
            evt.PlaySound(303,Party.X,Party.Y)
            OpenWorkshopDoor()
            
        else
            evt.FaceAnimation{Player = "Current", Animation = 18}
            evt.StatusText(16)         				-- "The Door is Locked"
        end
    end
end

-- Quest: Eastern Keyhole, Workshop Door
evt.hint[50] = evt.str[15]
evt.map[50] = function()
    if not evt.Cmp("MapVar2", 1) then
        if evt.All.Cmp("Inventory", WorkshopKeyItemID) then         	-- "Newname Key"
            evt.Set("MapVar2", 1)
            evt.SetTexture(2, "solid03")
            evt.Sub("Inventory",WorkshopKeyItemID)
            evt.FaceAnimation{Player = "All", Animation = 43}
            evt.PlaySound(303,Party.X,Party.Y)
            OpenWorkshopDoor()
        else
            evt.FaceAnimation{Player = "Current", Animation = 18}
            evt.StatusText(16)         				-- "The Door is Locked"
        end
    end
end

-- Teleport: From Western Teleport Room to Western Realm
evt.hint[51] = evt.str[0]
evt.map[51] = function()
	if evt.Cmp("MapVar4", 1) then
		evt.MoveToMap{
			X = -11607, Y = 2335, Z = 706, 
			Direction = 516, LookAngle = 0, SpeedZ = 0, 
			HouseId = 0, Icon = 0, Name = "archmagekey.blv"}
	end
end

-- Teleport: From Western Realm to Western Teleport Room [DEPRECATED]
evt.hint[52] = evt.str[0]
evt.map[52] = function()
    evt.MoveToMap{
        X = -5269, Y = 2803, Z = 190, 
        Direction = 0, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "0"}
end

-- Teleport: From Eastern Teleport Room to Eastern Realm
evt.hint[53] = evt.str[0]
evt.map[53] = function()
	if evt.Cmp("MapVar5", 1) then
		evt.MoveToMap{
			X = 20796, Y = 988, Z = 65, 
			Direction = 510, LookAngle = 0, SpeedZ = 0, 
			HouseId = 0, Icon = 0, Name = "archmagekey.blv"}
	end
end

-- Teleport: From Eastern Realm to Eastern Teleport Room [DEPRECATED]
evt.hint[54] = evt.str[0]
evt.map[54] = function()
    evt.MoveToMap{
        X = 10364, Y = 2937, Z = 65, 
        Direction = 1024, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "0"}
end

-- Pedestal: Western Teleport Room
evt.hint[55] = evt.str[14]
evt.map[55] = function()

    if not evt.Cmp("MapVar4", 1) then

    	if not evt.All.Cmp("Inventory", TeleportActivatorItem) then         	-- "Teleportation Gem"
    		evt.FaceAnimation{Player = "All", Animation = 43}
    		Game.ShowStatusText(evt.str[24])
	    	return
	    end
	    evt.Sub("Inventory", TeleportActivatorItem)
    	evt.Set("MapVar4", 1)
	    evt.SetFacetBit(3,const.FacetBits.Invisible,false)
	    evt.PlaySound(14050,Party.X,Party.Y)
	    evt.SetLight(1,true)
	    evt.FaceAnimation{Player = "All", Animation = 93}
		evt.StatusText(17)         				-- "Portal Is Activated"
	end
end

-- Pedestal: Western Teleport Room
evt.hint[56] = evt.str[14]
evt.map[56] = function()

    if not evt.Cmp("MapVar5", 1) then

    	if not evt.All.Cmp("Inventory", TeleportActivatorItem) then         	-- "Teleportation Gem"
    		evt.FaceAnimation{Player = "All", Animation = 43}
    		Game.ShowStatusText(evt.str[24])
	    	return
	    end
	    evt.Sub("Inventory", TeleportActivatorItem)
    	evt.Set("MapVar5", 1)
	    evt.SetFacetBit(4,const.FacetBits.Invisible,false)
	    evt.PlaySound(14050,Party.X,Party.Y)
	    evt.SetLight(2,true)
	    evt.FaceAnimation{Player = "All", Animation = 93}
		evt.StatusText(17)         				-- "Portal Is Activated"
	end
end

-- ****************************************************************************
-- BOOKCASES

-- Bookcase: Rec Room, Entrance  
evt.hint[60] = evt.str[9]
evt.map[60] = function()
    if not evt.Cmp("MapVar10", 1) then
		evt.Set("MapVar10", 1)
		evt.Add("Inventory", 381)	-- "Summon Elementalr" scroll
	end
end

-- Bookcase: Rec Room, Pool Table   
evt.hint[61] = evt.str[9]
evt.map[61] = function()
    if not evt.Cmp("MapVar11", 1) then
		evt.Set("MapVar11", 1)
		evt.Add("Inventory", 389)	-- "Toxic Cloud" scroll
	end
end

-- Bookcase: Redroom
evt.hint[62] = evt.str[9]
evt.map[62] = function()
    if not evt.Cmp("MapVar12", 1) then
		evt.Set("MapVar12", 1)
		evt.Add("Inventory", 385)	-- "Hour of Power" scroll
	end
end

-- Bookcase: WC
evt.hint[63] = evt.str[9]
evt.map[63] = function()
    if not evt.Cmp("MapVar13", 1) then
		evt.Set("MapVar13", 1)
		evt.Add("Inventory", 407)	-- "Immolation" book
	end
end

-- Bookcase: Summoning Chamber
evt.hint[64] = evt.str[9]
evt.map[64] = function()
    if not evt.Cmp("MapVar14", 1) then
		evt.Set("MapVar14", 1)
		evt.Add("Inventory", 376)	-- "Power Cure" scroll
	end
end

-- Bookcase: Office, West
evt.hint[65] = evt.str[9]
evt.map[65] = function()
    if not evt.Cmp("MapVar15", 1) then
		evt.Set("MapVar15", 1)
		evt.Add("Inventory", 340)	-- "Rock Blast" scroll
	end
end

-- Bookcase: Office, North
evt.hint[66] = evt.str[9]
evt.map[66] = function()
    if not evt.Cmp("MapVar16", 1) then
		evt.Set("MapVar16", 1)
		evt.Add("Inventory", 385)	-- "Hour of Power" scroll
	end
end

-- Bookcase: Office, Window
evt.hint[67] = evt.str[9]
evt.map[67] = function()
    if not evt.Cmp("MapVar17", 1) then
		evt.Set("MapVar17", 1)
		evt.Add("Inventory", 337)	-- "Stoneskin" scroll
	end
end

-- Bookcase: Library. SW
evt.hint[68] = evt.str[9]
evt.map[68] = function()
    if not evt.Cmp("MapVar18", 1) then
		evt.Set("MapVar18", 1)
		evt.Add("Inventory", 332)	-- "Lloyd's Beacon" scroll
	end
end

-- Bookcase: Library. W
evt.hint[69] = evt.str[9]
evt.map[69] = function()
    if not evt.Cmp("MapVar19", 1) then
		evt.Set("MapVar19", 1)
		evt.Add("Inventory", 332)	-- "Lloyd's Beacon" scroll
	end
end

-- Bookcase: Library. NW
evt.hint[70] = evt.str[9]
evt.map[70] = function()
    if not evt.Cmp("MapVar20", 1) then
		evt.Set("MapVar20", 1)
		evt.Add("Inventory", 332)	-- "Lloyd's Beacon" scroll
	end
end

-- Bookcase: Library. NE
evt.hint[71] = evt.str[9]
evt.map[71] = function()
    if not evt.Cmp("MapVar21", 1) then
		evt.Set("MapVar21", 1)
		evt.Add("Inventory", 332)	-- "Lloyd's Beacon" scroll
	end
end

-- Bookcase: Library. SE
evt.hint[72] = evt.str[9]
evt.map[72] = function()
    if not evt.Cmp("MapVar22", 1) then
		evt.Set("MapVar22", 1)
		evt.Add("Inventory", 302)	-- "Fire Resistance" scroll
	end
end

-- Bookcase: Library, Block, SW, S
evt.hint[73] = evt.str[9]
evt.map[73] = function()
    if not evt.Cmp("MapVar23", 1) then
        evt.Set("MapVar23", 1)
        evt.Add("Inventory", 313)	-- "Air Resistance" scroll
    end
end

-- Bookcase: Library, Block, SW, N
evt.hint[74] = evt.str[9]
evt.map[74] = function()
    if not evt.Cmp("MapVar24", 1) then
        evt.Set("MapVar24", 1)
        evt.Add("Inventory", 324)    -- "Water Resistance" scroll
    end
end

-- Bookcase: Library, Block, NW, S
evt.hint[75] = evt.str[9]
evt.map[75] = function()
    if not evt.Cmp("MapVar25", 1) then
        evt.Set("MapVar25", 1)
        evt.Add("Inventory", 335)    -- "Earth Resistance" scroll
    end
end

-- Bookcase: Library, Block, NW, N
evt.hint[76] = evt.str[9]
evt.map[76] = function()
    if not evt.Cmp("MapVar26", 1) then
        evt.Set("MapVar26", 1)
        evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Bookcase: Library, Block, NE, S
evt.hint[77] = evt.str[9]
evt.map[77] = function()
    if not evt.Cmp("MapVar27", 1) then
        evt.Set("MapVar27", 1)
        evt.Add("Inventory", 439)    -- "Preservation" scroll
    end
end

-- Bookcase: Library, Block, NE, N
evt.hint[78] = evt.str[9]
evt.map[78] = function()
    if not evt.Cmp("MapVar28", 1) then
        evt.Set("MapVar28", 1)
        evt.Add("Inventory", 374)    -- "Protection from Magic" scroll
    end
end

-- Bookcase: Library, Block, SE, S
evt.hint[79] = evt.str[9]
evt.map[79] = function()
    if not evt.Cmp("MapVar29", 1) then
        evt.Set("MapVar29", 1)
        evt.Add("Inventory", 374)    -- "Protection from Magic" scroll
    end
end

-- Bookcase: Library, Block, SE, N
evt.hint[80] = evt.str[9]
evt.map[80] = function()
    if not evt.Cmp("MapVar30", 1) then
        evt.Set("MapVar30", 1)
        evt.Add("Inventory", 304)    -- "Haste" scroll
    end
end

-- Bookcase: Workshop
evt.hint[81] = evt.str[9]
evt.map[81] = function()
    if not evt.Cmp("MapVar31", 1) then
        evt.Set("MapVar31", 1)
        evt.Add("Inventory", 387)    -- "Divine Intervention" scroll
    end
end

-- ****************************************************************************
-- WINERACKS

-- Winerack: Rec Room
evt.hint[82] = evt.str[19]
evt.map[82] = function()
    if not evt.Cmp("MapVar32", 1) then
		evt.Set("MapVar32", 1)
		evt.Add("Inventory", 247)	-- "Freezing" potion
	end
end

-- Winerack: Diner Room
evt.hint[83] = evt.str[19]
evt.map[83] = function()
    if not evt.Cmp("MapVar33", 1) then
		evt.Set("MapVar33", 1)
		evt.Add("Inventory", 223)	-- "Magic" potion
	end
end

-- ****************************************************************************
-- FOUNTAINS

-- Fountain: Fountain Chamber
evt.hint[84] = evt.str[20]
evt.map[84] = function()
    if evt.Cmp("MapVar40", 20) == false then
        evt.Add("MapVar40", 1)
        evt.Add("HP", 10)
        evt.Add("SP", 10)
        evt.StatusText(21)         -- "+10 Hit & Spell points restored"
    else
        evt.StatusText(23)         -- "Refreshing!"
    end

    AddAutonote'amberDungeonFountain4'
end

-- Fountain: Eastern Hall
evt.hint[85] = evt.str[20]
evt.map[85] = function()

    if evt.Cmp("MapVar41", 6) == false then
        evt.Add("MapVar41", 1)
        evt.Add("FireResistance", 1)
        evt.Add("AirResistance", 1)
        evt.Add("WaterResistance", 1)
        evt.Add("EarthResistance", 1)
        evt.StatusText(28)         -- "+1 Elemental Resistance permanent"
        return
    else
        evt.StatusText(23)         -- "Refreshing!"
    end
end

-- Fountain: Western Teleport Room
evt.hint[86] = evt.str[20]
evt.map[86] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Eastern Teleport Room
evt.hint[87] = evt.str[20]
evt.map[87] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- ****************************************************************************
-- Potential Triggers

-- Trigger: Bath
evt.hint[88] = evt.str[20]
evt.map[88] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Trigger: Library, Water Ball
evt.hint[89] = evt.str[20]
evt.map[89] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Fountain: Guest Room, Secret (Button)
evt.hint[90] = evt.str[20]
evt.map[90] = function()
    evt.StatusText(23)         -- "Refreshing!"
end

-- Button: Guest Room, Secret
evt.hint[91] = evt.str[6]
evt.map[91] = function()
    evt.StatusText(27)         -- "Somebody already pressed the button!"
end

-- EXIT DOOR
evt.hint[92] = evt.str[25]
evt.map[92] = function()
    evt.MoveToMap{X = 1, Y = 2196, Z = 128, Direction = 1536, LookAngle = 0, SpeedZ = 0, HouseId = 198, Icon = 1, Name = "archmageEX.blv"}
end
