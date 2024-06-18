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

-- EXIT DOOR
evt.hint[1] = evt.str[25]
evt.map[1] = function()
    evt.MoveToMap{X = -4973, Y = -17139, Z = 598, Direction = 2038, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 4, Name = "amber.odm"}
end

-- DUNGEON DOOR
evt.hint[2] = evt.str[25]
evt.map[2] = function()
    evt.MoveToMap{X = -4, Y = -2, Z = 1, Direction = 2046, LookAngle = 0, SpeedZ = 0, HouseId = 195, Icon = 1, Name = "archmageres.blv"}
end

-- Rest Room
evt.hint[3] = evt.str[4]
evt.map[3] = function()
    evt.EnterHouse(581)
end

-- LOCKED DOOR
evt.hint[4] = evt.str[4]
evt.map[4] = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    evt.StatusText(16)         				-- "The Door is Locked"
end
