
Game.MapEvtLines.Count = 0

-- MapVar0: Teleportation Pedestal
-- MapVar1: Bookcase -> Scroll

-- ****************************************************************************

-- Start loc house
evt.hint[1]        = ModTxt.CDoor
evt.map[1]         = function()
    evt.SetDoorState{Id = 1, State = 2}
end

