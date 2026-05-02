--[[
Map:    Secret Hideout
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count = 0

-- ***************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION


-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1      xx

-- MONSTERS
-- GROUP 1: ???
-- BOSS 1: ???

-- ***************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Hideout, Cab, SE Room
-- 01           02              Hideout, Cab, NE Room
-- 02           03              Hideout, Secret Room
-- 03           04              Hideout, Living Room
-- 04           05              Castle Harmondale
-- 05           06              Castle Gryphonheart, Fancy Room
-- 06           07              Castle Gryphonheart, Upside Room
-- 07           08              Castle Gryphonheart, Archibald's Chamber
-- 08           09              Wine Cellar, Entrance
-- 09           10              Wine Cellar, Crypt
-- 10           11              Markham's Residence

-- ***************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Bookcase     21              Hideout, SE Room
-- Bookcase     22              Hideout, Living Room
-- Bookcase     23              Castle Harmondale, Library, N
-- Bookcase     24              Castle Harmondale, Library, S
-- Bookcase     25              Castle Harmondale, Fancy Room
-- Fountain     26              Entrance
-- Fountain     27              Teleportation Pedestal
-- Fountain     28              Castle Harmondale, Main Hall
-- Door         29              Locked Doors
-- Teleport     30              Hideout
-- Teleport     31              Castle Harmondale
-- Teleport     32              Temple of the Moon
-- Exit         33              Exit

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterLoadMap(WasInGame)

    MakeHostile(64,66) -- Gargoyle
    MakeHostile(79,81) -- Golems
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------

for i = 0, 19, 1 do
    local hintStr   = ModTxt.CChest
    if Game.Debug then
        hintStr     = hintStr .. " #"..tostring(i)
    end
    evt.hint[1 + i]        = hintStr
    evt.map[1 + i]         = function() 
        evt.OpenChest(i)
    end
end 

------------------------------------------------------------------------------
-- BOOKCASES
------------------------------------------------------------------------------

-- Bookcase: Hideout, SE Room
evt.hint[21]        = ModTxt.CBookcase
evt.map[21]         = function()
    if not evt.Cmp("MapVar1", 1) then
        evt.Set("MapVar1", 1)
        --evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Bookcase: Hideout, Living Room
evt.hint[22]        = ModTxt.CBookcase
evt.map[22]         = function()
    if not evt.Cmp("MapVar2", 1) then
        evt.Set("MapVar2", 1)
        --evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Bookcase: Castle Harmondale, Library, N
evt.hint[23]        = ModTxt.CBookcase
evt.map[23]         = function()
    if not evt.Cmp("MapVar3", 1) then
        evt.Set("MapVar3", 1)
        --evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Bookcase: Castle Harmondale, Library, S
evt.hint[24]        = ModTxt.CBookcase
evt.map[24]         = function()
    if not evt.Cmp("MapVar4", 1) then
        evt.Set("MapVar4", 1)
        --evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Bookcase: Castle Harmondale, Library, Fancy Room
evt.hint[25]        = ModTxt.CBookcase
evt.map[25]         = function()
    if not evt.Cmp("MapVar5", 1) then
        evt.Set("MapVar5", 1)
        --evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

------------------------------------------------------------------------------
-- FOUNTAINS
------------------------------------------------------------------------------

-- Fountain: Entrance
Fountain(26, 100, "amberSecret1")

-- Fountain: Teleportation Pedestal
Fountain(27, 101, "amberSecret2")

-- Fountain: Castle Harmondale, Main Hall
Fountain(28, 102, "amberSecret3")

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Locked Doors
evt.hint[29]        = ModTxt.CDoor
evt.map[29]         = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    Game.ShowStatusText(ModTxt.CLockedDoor)
end

-- Teleport: From Hideout to Magical Realm
evt.hint[30]        = ModTxt.CNull
evt.map[30]         = function()
    evt.MoveToMap{
        X           = 7657,
        Y           = 7250,
        Z           = 1,
        Direction   = 9,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Teleport: From Magical Realm to Hideout
evt.hint[31]        = ModTxt.CNull
evt.map[31]         = function()

    evt.MoveToMap{
        X           = 3,
        Y           = 2590,
        Z           = 256,
        Direction   = 1536,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Teleport: From Temple of the Moon to Hideout
evt.hint[32]        = ModTxt.CNull
evt.map[32]         = function()

    if vars.MiscAmberIsland.ArchmageEscapedHideout == 0 then
        vars.MiscAmberIsland.ArchmageEscapedHideout = 1
    end

    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
    evt.MoveToMap{
        X           = -2290,
        Y           = 1694,
        Z           = 129,
        Direction   = 1531,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
    
end

-- EXIT DOOR
evt.hint[33]        = ModTxt.CLeaveDungeon
evt.map[33]         = function()
    evt.MoveToMap{
        X           = 16248,
        Y           = -16674,
        Z           = 1,
        Direction   = 1024,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber-east.odm"
    }
end

-- Double-Door: Hideout, Living Room
evt.hint[34]        = ModTxt.CDoor
evt.map[34]         = function()

    if vars.MiscAmberIsland.ArchmageEscapedHideout == 0 then
        vars.MiscAmberIsland.ArchmageEscapedHideout = 1
    end

    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Double-Door, Black Vortex
evt.hint[35]        = ModTxt.CDoor
evt.map[35]         = function()

    evt.EnterHouse(581)
end

-- Safe Room (Harmondael Throne Room)
evt.hint[36]        = ModTxt.CDoor
evt.map[36]         = function()

    evt.EnterHouse(581)
end
