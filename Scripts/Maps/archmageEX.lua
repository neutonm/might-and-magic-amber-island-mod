local TXT = Localize{
	[0]     = " ",
    [1]     = "Enter Archmage Residence",
    [2]     = "Door",
    [3]     = "Chest",
    [4]     = "Bookcase",
    [5]     = "Fountain",
    [6]     = "Refreshing",
    [7]     = "Keyhole",
    [8]     = "The Door Is Locked",
    [9]     = "Apple Tree",
    [10]    = "Still the same sour apple tree...",
    [11]    = "Rest Room",
    [12]    = "Magical Sphere",
    [13]    = "Leave Dungeon",
    [14]    = "+2 Fire Resistance (Permanent)",
    [15]    = "+2 Air Resistance (Permanent)",
    [16]    = "+2 Water Resistance (Permanent)",
    [17]    = "+2 Earth Resistance (Permanent)",
    [18]    = "Through the telescope, you observe a distant celestial body in the sky."
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

CatKeyItemID = 666 -- infernal cat key :)

-- ****************************************************************************

-- TODO:
-- cat room - throne platform missing a face

-- FACE GROUPS
-- ID           DESCRIPTION
-- 1            Grated Door

-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1-5    Bookcases
-- MapVar6      Cat Bed (Key)
-- MapVar8-11   Elemental Spheres in Summoning Chamber

------------------------------------------------------------------------------

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 1-2          21              Entrance Doors (Warrior)
-- 3-4          22              Main Hall: Observatory
-- 5            23              Observatory
-- 6            24              Main Hall: Servants' Room
-- 7            25              Main Hall: Cat Room
-- 8            26              Main Hall: Summoning Chamber
-- 9            27              Summoning Chamber
-- 10           0               Main Hall: Grated Door
-- 11-12        28              Main Hall: Lab
-- 13-14        29              Lab

------------------------------------------------------------------------------

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1               Servants' Room
-- 01           2               Cat Room
-- 02           3               Labolatory (Portal)

------------------------------------------------------------------------------

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Teleport     40              Lab: From South to West
-- Teleport     41              Lab: From West to South
-- Fountain     42              All fountains in the level
-- Trigger      43              Cat Bed (key)
-- Trigger      44              Main Hall: Keyhole near Grated Door
-- Decoration   45              Apple Tree
-- Door         46              Entrance to actual Archmage Residence
-- Door         47              Rest Room (Entrance)
-- Door         48              Locked Door (Entrance)
-- Door         49              Exit
-- Fire (Sprite)50              Ignore Picking Fires (rings and sheit)

-- ****************************************************************************

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------
function events.AfterLoadMap(WasInGame)

    MakeHostile(79,81) -- Golems
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------

for i = 0, 19, 1 do
	local hintStr = evt.str[3]
    if Game.Debug then
        hintStr = hintStr .. " #"..tostring(i)
    end
	evt.hint[1 + i] = hintStr
	evt.map[1 + i] = function() 
	    evt.OpenChest(i)
	end
end

------------------------------------------------------------------------------
-- DOORS
------------------------------------------------------------------------------

-- Double-Door: Entrance Doors (Warrior)
evt.hint[21]    = evt.str[2]
evt.map[21]     = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Double Door: Main Hall: Observatory
evt.hint[22]    = evt.str[2]
evt.map[22]     = function()
    evt.SetDoorState{Id = 3, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Observatory
evt.hint[23]    = evt.str[2]
evt.map[23]     = function()
    evt.SetDoorState{Id = 5, State = 2}
end

-- Main Hall: Servants' Room
evt.hint[24]    = evt.str[2]
evt.map[24]     = function()
    evt.SetDoorState{Id = 6, State = 2}
end

-- Main Hall: Cat Room
evt.hint[25]    = evt.str[2]
evt.map[25]     = function()
    evt.SetDoorState{Id = 7, State = 2}
end

-- Main Hall: Summoning Chamber
evt.hint[26]    = evt.str[2]
evt.map[26]     = function()
    evt.SetDoorState{Id = 8, State = 2}
end

-- Summoning Chamber
evt.hint[27]    = evt.str[2]
evt.map[27]     = function()
    evt.SetDoorState{Id = 9, State = 2}
end

-- Main Hall: Lab
evt.hint[28]    = evt.str[0]
evt.map[28]     = function()
    evt.SetDoorState{Id = 11, State = 2}
    evt.SetDoorState{Id = 12, State = 2}
end

-- Lab
evt.hint[29]    = evt.str[0]
evt.map[29]     = function()
    evt.SetDoorState{Id = 13, State = 2}
    evt.SetDoorState{Id = 14, State = 2}
end

------------------------------------------------------------------------------
-- BOOKCASES
------------------------------------------------------------------------------

-- Observatory: South
evt.hint[31]    = evt.str[4]
evt.map[31]     = function()
    if not evt.Cmp("MapVar1", 1) then
		evt.Set("MapVar1", 1)
		evt.Add("Inventory", 300)	-- "Torch Light" scroll
	end
end

-- Observatory: North
evt.hint[32]    = evt.str[4]
evt.map[32]     = function()
    if not evt.Cmp("MapVar2", 1) then
		evt.Set("MapVar2", 1)
		evt.Add("Inventory", 335)	-- "Earth Resistance" scroll
	end
end

-- Lab: Portal
evt.hint[33]    = evt.str[4]
evt.map[33]     = function()
    if not evt.Cmp("MapVar3", 1) then
		evt.Set("MapVar3", 1)
		evt.Add("Inventory", 381)	-- "Summon Elementalr" scroll
	end
end

-- Lab: Gravity Pad, North
evt.hint[34]    = evt.str[4]
evt.map[34]     = function()
    if not evt.Cmp("MapVar4", 1) then
		evt.Set("MapVar4", 1)
		evt.Add("Inventory", 324)	-- "Water Resistance" scroll
	end
end

-- Lab: Gravity Pad, South
evt.hint[35]    = evt.str[4]
evt.map[35]     = function()
    if not evt.Cmp("MapVar5", 1) then
		evt.Set("MapVar5", 1)
		evt.Add("Inventory", 302)	-- "Fire Resistance" scroll
	end
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Summoning Chamber: Fire Sphere
evt.hint[36]    = evt.str[12]
evt.map[36]     = function()
    if not evt.Cmp("MapVar8", 1) then
		evt.Set("MapVar8", 1)
		evt.All.Add("FireResistance", 2)
        evt.StatusText(14) -- "+2 Fire Resistance (Permanent)"
	end
end

-- Summoning Chamber: Air Sphere
evt.hint[37]    = evt.str[12]
evt.map[37]     = function()
    if not evt.Cmp("MapVar9", 1) then
		evt.Set("MapVar9", 1)
		evt.All.Add("AirResistance", 2)
        evt.StatusText(15) -- "+2 Air Resistance (Permanent)"
	end
end

-- Summoning Chamber: Water Sphere
evt.hint[38]    = evt.str[12]
evt.map[38]     = function()
    if not evt.Cmp("MapVar10", 1) then
		evt.Set("MapVar10", 1)
		evt.All.Add("WaterResistance", 2)
        evt.StatusText(16) -- "+2 Water Resistance (Permanent)"
	end
end

-- Summoning Chamber: Earth Sphere
evt.hint[39]    = evt.str[12]
evt.map[39]     = function()
    if not evt.Cmp("MapVar11", 1) then
		evt.Set("MapVar11", 1)
		evt.All.Add("EarthResistance", 2)
        evt.StatusText(17) -- "+2 Earth Resistance (Permanent)"
	end
end

-- Teleporter: From South to West
evt.hint[40]    = evt.str[0]
evt.map[40]     = function()

    evt.MoveToMap{
        X = -4616, Y = 2509, Z = -96, 
        Direction = 2048, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "0"}
end

-- Teleporter: From West to South
evt.hint[41]    = evt.str[0]
evt.map[41]     = function()

    evt.MoveToMap{
        X = -3446, Y = 1600, Z = -96, 
        Direction = 512, LookAngle = 0, SpeedZ = 0, 
        HouseId = 0, Icon = 0, Name = "0"}
end

-- Fountains
evt.hint[42]    = evt.str[5]
evt.map[42]     = function()
    evt.StatusText(6)         -- "Refreshing!"
end

-- Cat Bed
evt.hint[43]    = evt.str[0]
evt.map[43]     = function()
    if not evt.Cmp("MapVar6", 1) then
		evt.Set("MapVar6", 1)
		evt.Add("Inventory", CatKeyItemID)
	end
end

-- Main Hall: Keyhole near Grated Door
evt.hint[44]    = evt.str[7]
evt.map[44]     = function()
    if not evt.Cmp("MapVar7", 1) then
        if evt.All.Cmp("Inventory", CatKeyItemID) then -- "Cat Key"

            evt.Set("MapVar7", 1)
            evt.Sub("Inventory", CatKeyItemID)

            evt.FaceAnimation{Player = "All", Animation = 43}
            evt.PlaySound(303,Party.X,Party.Y)

            evt.SetDoorState{Id = 10, State = 2}
            evt.SetFacetBit(1, const.FacetBits.Untouchable, true)
        else
            evt.FaceAnimation{Player = "Current", Animation = 18}
            evt.StatusText(8)         				-- "The Door is Locked"
        end
    end
end

-- Apple Tree
evt.hint[45]    = evt.str[9]
evt.map[45]     = function()
    evt.StatusText(10)         -- "Still the same sour apple tree..."
end

-- Dungeon Door (Grated Door corridor)
evt.hint[46]    = evt.str[1]
evt.map[46]     = function()
    evt.MoveToMap{
        X = -4, Y = -2, Z = 1,
        Direction = 2046, LookAngle = 0,
        SpeedZ = 0, HouseId = 195,
        Icon = 1, Name = "archmageres.blv"}
end

-- Rest Room
evt.hint[47]    = evt.str[11]
evt.map[47]     = function()
    evt.EnterHouse(581)
end

-- Locked Door (Entrance)
evt.hint[48]    = evt.str[2]
evt.map[48]     = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    evt.StatusText(8)   -- "The Door is Locked"
end

-- Exit Door (Entrance)
evt.hint[49]    = evt.str[13]
evt.map[49]     = function()
    evt.MoveToMap{
        X = -4973, Y = -17139, Z = 598,
        Direction = 2038, LookAngle = 0,
        SpeedZ = 0, HouseId = 0,
        Icon = 4, Name = "amber.odm"}
end

-- Fires
evt.hint[50]    = evt.str[0]
evt.map[50]     = function() end

-- Telescope small lense (blacK)
evt.hint[51]    = evt.str[0]
evt.map[51]     = function()
    -- "Through the telescope, you observe a distant celestial body in the sky."
    evt.StatusText(18)
end
