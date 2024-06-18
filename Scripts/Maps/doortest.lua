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
    [24] = "You need teleportation stone."
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0


-- MapVar0: Teleportation Pedestal
-- MapVar1: Bookcase -> Scroll

-- ****************************************************************************

-- Start loc house
evt.hint[1] = evt.str[4]
evt.map[1] = function()
    evt.SetDoorState{Id = 1, State = 2}
end

