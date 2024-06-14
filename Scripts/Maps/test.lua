Game.MapEvtLines:RemoveEvent(1)  -- remove original event
evt.hint[1] = "Fucking Dungeon"
evt.map[1] = function()
    
    evt.MoveToMap(293,286,14,1312,1,1,1,1,"testlevel.blv")
end
