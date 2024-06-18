--[[
Map: Developer Dungeon
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
    [24] = "Trigger",
    [25] = "Leave Dungeon"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

-- Double Door
evt.hint[1] = evt.str[4]
evt.map[1] = function()
    evt.MoveToMap{X = -15484, Y = -21868, Z = 256, Direction = 649, LookAngle = 0, SpeedZ = 0, HouseId = 191, Icon = 1, Name = "amber.odm"}
end

-- Training Hall Icon
evt.hint[2] = evt.str[4]
evt.map[2] = function()
    evt.MoveToMap{X = -148, Y = 3, Z = 0, Direction = 2044, LookAngle = 0, SpeedZ = 0, HouseId = 194, Icon = 1, Name = "applecave.blv"}
end

-- Stables Icon
evt.hint[3] = evt.str[4]
evt.map[3] = function()
    evt.MoveToMap{X = -41, Y = 369, Z = 0, Direction = 2, LookAngle = 0, SpeedZ = 0, HouseId = 193, Icon = 1, Name = "oakhome.blv"}
end

-- Water Guild Icon
evt.hint[4] = evt.str[4]
evt.map[4] = function()
    evt.MoveToMap{X = 293, Y = 286, Z = 14, Direction = 1312, LookAngle = 0, SpeedZ = 0, HouseId = 198, Icon = 1, Name = "testlevel.blv"}
end

-- War Dwarf
evt.hint[5] = evt.str[24]
evt.map[5] = function()
    evt.MoveToMap{X = -4, Y = -2, Z = 1, Direction = 2046, LookAngle = 0, SpeedZ = 0, HouseId = 195, Icon = 1, Name = "archmageres.blv"}
end

-- Peasant Dwarf
evt.hint[6] = evt.str[24]
evt.map[6] = function()
    evt.MoveToMap{X = 190, Y = 140, Z = 33, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 196, Icon = 1, Name = "abmines.blv"}
end

-- Pedestal
evt.hint[7] = evt.str[24]
evt.map[7] = function()
    evt.MoveToMap{X = -3, Y = -90, Z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 197, Icon = 1, Name = "secret.blv"}
end

-- Contest Pyre
evt.hint[8] = evt.str[24]
evt.map[8] = function()
    evt.MoveToMap{X = 16248, Y = 16674, Z = 1, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 192, Icon = 1, Name = "amber-east.odm"}
end

