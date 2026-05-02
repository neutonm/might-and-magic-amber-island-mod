--[[
Map:     Oak Hill Cottage
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count = 0

------------------------------------------------------------------------------

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 01-02        51              Double-Door: Workshop Corridor -> WC Stairs
-- 03-04        62              Double-Door: Master Bedroom
-- 05-06        56              Double-Door: Workshop Corridor -> Main Hall
-- 07-08        46              Double-Door: Dining Hall
-- 09-10        49              Double-Door: Gallery
-- 11           47              Door: Dining Hall -> Kitchen
-- 12           48              Door: Kitchen -> Basement
-- 13-14        50              Double-Door: Gallery -> Workshop Corridor
-- 15-16        53              Double-Door: Workshop Storage
-- 17-18        54              Double-Door: Workshop
-- 19-20        55              Double-Door: Smithy
-- 21           00              --
-- 22           58              Door: Office
-- 23           59              Door: Office Bedroom
-- 24           60              Door: Temple North Bedroom
-- 25           61              Door: Temple South Bedroom
-- 26-27        57              Double-Door: Main Hall -> Cellar
-- 28           52              Door: WC
-- 29           00              --
-- 30           63              Secret Door 1
-- 31           64              Secret Door 2
-- 32           00              --
-- 33           65              Secret Door 3
-- 34           66              Secret Door 4
-- 35           67              Secret Door 5
-- 36           70/71/72        Elevator: Library Platform
-- 37           72              Elevator: Library Bottom Lever State
-- 38           71              Elevator: Library Top Lever State

-- ELEVATORS
-- 36           70              Elevator: Library Platform

-- LEVERS / SWITCHES
-- 71           71              Elevator Lever: Library Top
-- 72           72              Elevator Lever: Library Bottom

-- ***************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Outside window of mess hall
-- 01           02              Storage room
-- 02           03              Gallery storage room on 2 floor
-- 03           04              Secret passage near wc
-- 04           05              Small workshop storage room: west
-- 05           06              Small workshop storage room: east
-- 06           07              Workshop
-- 07           08              Workshop connector
-- 08           09              Workshop connector secret room
-- 09           10              Barracks: Large Cabinet
-- 10           11              Barracks: Cabinet
-- 11           12              North-east guest bedroom, cabinet
-- 12           13              East guest bedroom
-- 13           14              Main bedroom: east
-- 14           15              Main bedroom: west
-- 15           16              Basement secret area
-- 16           17              Cave with the boat
-- 17           18              North guest bedroom

-- ***************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Bookcase     21              Dining Hall Bookcase 1
-- Bookcase     22              Dining Hall Bookcase 2
-- Bookcase     23              Dining Hall Bookcase 3
-- Bookcase     24              Office Bookcase 1
-- Bookcase     25              Office Bookcase 2
-- Bookcase     26              Office Bookcase 3
-- Bookcase     27              Office Bookcase 4
-- Bookcase     28              Office Bedroom Bookcase
-- Bookcase     29              Temple Bedroom Bookcase
-- Bookcase     30              Library Bookcase 1
-- Bookcase     31              Library Bookcase 2
-- Bookcase     32              Library Bookcase 3
-- Bookcase     33              Library Bookcase 4
-- Bookcase     34              Library Bookcase 5
-- Bookcase     35              Library Bookcase 6
-- Bookcase     36              Library Bookcase 7
-- Bookcase     37              Master Bedroom Bookcase
-- Winerack     41              East Winerack
-- Winerack     42              West Winerack
-- Fountain     75              Main Hall Fountain
-- Exit         76              Leave to Amber Island
-- House        77              Tavern Entrance

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterLoadMap(WasInGame)

    --MakeHostile(268,270) -- Ratmen
    MakeHostile(79,81) -- Golems
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------

-- Chests
for i = 0, 19, 1 do
    local hintStr 	= ModTxt.CChest
    if Game.Debug then
        hintStr 	= hintStr .. " #"..tostring(i)
    end
    evt.hint[1 + i]        = hintStr
    evt.map[1 + i]         = function()
        evt.OpenChest(i)
    end
end

------------------------------------------------------------------------------
-- BOOKCASES
------------------------------------------------------------------------------

-- Bookcase: Dining Hall
evt.hint[21]        = ModTxt.CBookcase
evt.map[21]         = function()
    if not evt.Cmp("MapVar1", 1) then
        evt.Set("MapVar1", 1)
        evt.Add("Inventory", 401)    -- "Fire Bolt" book
    end
end

evt.hint[22]        = ModTxt.CBookcase
evt.map[22]         = function()
    if not evt.Cmp("MapVar2", 1) then
        evt.Set("MapVar2", 1)
        evt.Add("Inventory", 401)    -- "Fire Bolt" book
    end
end

evt.hint[23]        = ModTxt.CBookcase
evt.map[23]         = function()
    if not evt.Cmp("MapVar3", 1) then
        evt.Set("MapVar3", 1)
        evt.Add("Inventory", 373)    -- "Cure Disease" scroll
    end
end

-- Bookcase: Office

evt.hint[24]        = ModTxt.CBookcase
evt.map[24]         = function()
    if not evt.Cmp("MapVar4", 1) then
        evt.Set("MapVar4", 1)
        evt.Add("Inventory", 425)    -- "Ice Bolt" book
    end
end

evt.hint[25]        = ModTxt.CBookcase
evt.map[25]         = function()
    if not evt.Cmp("MapVar5", 1) then
        evt.Set("MapVar5", 1)
        evt.Add("Inventory", 425)    -- "Ice Bolt" book
    end
end

evt.hint[26]        = ModTxt.CBookcase
evt.map[26]         = function()
    if not evt.Cmp("MapVar6", 1) then
        evt.Set("MapVar6", 1)
        evt.Add("Inventory", 373)    -- "Cure Disease" scroll
    end
end

evt.hint[27]        = ModTxt.CBookcase
evt.map[27]         = function()
    if not evt.Cmp("MapVar7", 1) then
        evt.Set("MapVar7", 1)
        evt.Add("Inventory", 305)    -- "Fireball" scroll
    end
end

-- Bookcase: Office Bedroom
evt.hint[28]        = ModTxt.CBookcase
evt.map[28]         = function()
    if not evt.Cmp("MapVar8", 1) then
        evt.Set("MapVar8", 1)
        evt.Add("Inventory", 337)    -- "Stone Skin" scroll
    end
end

-- Bookcase: Temple Bedroom
evt.hint[29]        = ModTxt.CBookcase
evt.map[29]         = function()
    if not evt.Cmp("MapVar9", 1) then
        evt.Set("MapVar9", 1)
        evt.Add("Inventory", 323)    -- "Poison Spray" scroll
    end
end

-- Bookcase: Library
evt.hint[30]        = ModTxt.CBookcase
evt.map[30]         = function()
    if not evt.Cmp("MapVar10", 1) then
        evt.Set("MapVar10", 1)
        evt.Add("Inventory", 311)    -- "Wizard Eye" scroll
    end
end

evt.hint[31]        = ModTxt.CBookcase
evt.map[31]         = function()
    if not evt.Cmp("MapVar11", 1) then
        evt.Set("MapVar11", 1)
        evt.Add("Inventory", 311)    -- "Wizard Eye" scroll
    end
end

evt.hint[32]        = ModTxt.CBookcase
evt.map[32]         = function()
    if not evt.Cmp("MapVar12", 1) then
        evt.Set("MapVar12", 1)
        evt.Add("Inventory", 311)    -- "Wizard Eye" scroll
    end
end

evt.hint[33]        = ModTxt.CBookcase
evt.map[33]         = function()
    if not evt.Cmp("MapVar13", 1) then
        evt.Set("MapVar13", 1)
        evt.Add("Inventory", 311)    -- "Wizard Eye" scroll
    end
end

evt.hint[34]        = ModTxt.CBookcase
evt.map[34]         = function()
    if not evt.Cmp("MapVar14", 1) then
        evt.Set("MapVar14", 1)
        evt.Add("Inventory", 300)    -- "Torch Light" scroll
    end
end

evt.hint[35]        = ModTxt.CBookcase
evt.map[35]         = function()
    if not evt.Cmp("MapVar15", 1) then
        evt.Set("MapVar15", 1)
        evt.Add("Inventory", 300)    -- "Torch Light" scroll
    end
end

evt.hint[36]        = ModTxt.CBookcase
evt.map[36]         = function()
    if not evt.Cmp("MapVar16", 1) then
        evt.Set("MapVar16", 1)
        evt.Add("Inventory", 300)    -- "Torch Light" scroll
    end
end

-- Bookcase: Master Bedroom
evt.hint[37]        = ModTxt.CBookcase
evt.map[37]         = function()
    if not evt.Cmp("MapVar17", 1) then
        evt.Set("MapVar17", 1)
        evt.Add("Inventory", 373)    -- "Cure Disease" scroll
    end
end

-- 38 -> 40 spare

------------------------------------------------------------------------------
-- WINERACKS
------------------------------------------------------------------------------

-- Winerack: East
evt.hint[41]        = ModTxt.CWineRack
evt.map[41]         = function()
    if not evt.Cmp("MapVar18", 1) then
        evt.Set("MapVar18", 1)
        evt.Add("Inventory", 225)    -- "Cure" disease
    end
end

-- Winerack: West
evt.hint[42]        = ModTxt.CWineRack
evt.map[42]         = function()
    if not evt.Cmp("MapVar19", 1) then
        evt.Set("MapVar19", 1)
        evt.Add("Inventory", 225)    -- "Cure" disease
    end
end

-- 43 - 45 spare

------------------------------------------------------------------------------
-- DOORS
------------------------------------------------------------------------------

-- Door: Dining Hall 
evt.hint[46]        = ModTxt.CDoor
evt.map[46]         = function()
    evt.SetDoorState{Id = 7, State = 2}
    evt.SetDoorState{Id = 8, State = 2}
end

-- Door: Dining Hall -> Kitchen
evt.hint[47]        = ModTxt.CDoor
evt.map[47]         = function()
    evt.SetDoorState{Id = 11, State = 2}
end

-- Door: Kitchen -> Basement
evt.hint[48]        = ModTxt.CDoor
evt.map[48]         = function()
    evt.SetDoorState{Id = 12, State = 2}
end

-- Door: Gallery
evt.hint[49]        = ModTxt.CDoor
evt.map[49]         = function()
    evt.SetDoorState{Id = 9, State = 2}
    evt.SetDoorState{Id = 10, State = 2}
end

-- Door: Gallery -> Workshop Corridor
evt.hint[50]        = ModTxt.CDoor
evt.map[50]         = function()
    evt.SetDoorState{Id = 13, State = 2}
    evt.SetDoorState{Id = 14, State = 2}
end

-- Door: Workshop Corridor -> WC Stairs
evt.hint[51]        = ModTxt.CDoor
evt.map[51]         = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Door: WC
evt.hint[52]        = ModTxt.CDoor
evt.map[52]         = function()
    evt.SetDoorState{Id = 28, State = 2}
end

-- Door: Workshop Storage
evt.hint[53]        = ModTxt.CDoor
evt.map[53]         = function()
    evt.SetDoorState{Id = 15, State = 2}
    evt.SetDoorState{Id = 16, State = 2}
end

-- Door: Workshop
evt.hint[54]        = ModTxt.CDoor
evt.map[54]         = function()
    evt.SetDoorState{Id = 17, State = 2}
    evt.SetDoorState{Id = 18, State = 2}
end

-- Door: Smithy
evt.hint[55]        = ModTxt.CDoor
evt.map[55]         = function()
    evt.SetDoorState{Id = 19, State = 2}
    evt.SetDoorState{Id = 20, State = 2}
end

-- Door: Workshop Corridor -> Main Hall
evt.hint[56]        = ModTxt.CDoor
evt.map[56]         = function()
    evt.SetDoorState{Id = 5, State = 2}
    evt.SetDoorState{Id = 6, State = 2}
end

-- Door: Main Hall -> Cellar
evt.hint[57]        = ModTxt.CDoor
evt.map[57]         = function()
    evt.SetDoorState{Id = 26, State = 2}
    evt.SetDoorState{Id = 27, State = 2}
end

-- Door: Office
evt.hint[58]        = ModTxt.CDoor
evt.map[58]         = function()
    evt.SetDoorState{Id = 22, State = 2}
end

-- Door: Office Bedroom
evt.hint[59]        = ModTxt.CDoor
evt.map[59]         = function()
    evt.SetDoorState{Id = 23, State = 2}
end

-- Door: Temple North Bedroom
evt.hint[60]        = ModTxt.CDoor
evt.map[60]         = function()
    evt.SetDoorState{Id = 24, State = 2}
end

-- Door: Temple South Bedroom
evt.hint[61]        = ModTxt.CDoor
evt.map[61]         = function()
    evt.SetDoorState{Id = 25, State = 2}
end

-- Door: Master Bedroom
evt.hint[62]        = ModTxt.CDoor
evt.map[62]         = function()
    evt.SetDoorState{Id = 3, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Door: Secret 1
evt.hint[63]        = ModTxt.CDoor
evt.map[63]         = function()
    evt.SetDoorState{Id = 30, State = 2}
end

-- Door: Secret 2
evt.hint[64]        = ModTxt.CDoor
evt.map[64]         = function()
    evt.SetDoorState{Id = 31, State = 2}
end

-- Door: Secret 3
evt.hint[65]        = ModTxt.CDoor
evt.map[65]         = function()
    evt.SetDoorState{Id = 33, State = 2}
end

-- Door: Secret 4
evt.hint[66]        = ModTxt.CDoor
evt.map[66]         = function()
    evt.SetDoorState{Id = 34, State = 2}
end

-- Door: Secret 5
evt.hint[67]        = ModTxt.CDoor
evt.map[67]         = function()
    evt.SetDoorState{Id = 35, State = 2}
end

------------------------------------------------------------------------------
-- ELEVATORS
------------------------------------------------------------------------------

-- Elevator: Library
evt.hint[70]        = ModTxt.CLift
evt.map[70]         = function()
    evt.SetDoorState{Id = 36, State = 2}
end

-- Elevator: Library Top lever
evt.hint[71]        = ModTxt.CLever
evt.map[71]         = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 38, State = 2}
end

-- Elevator: Library Bottom lever
evt.hint[72]        = ModTxt.CLever
evt.map[72]         = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 37, State = 2}
end

------------------------------------------------------------------------------
-- FOUNTAINS
------------------------------------------------------------------------------

-- Main Hall Fountain
Fountain(75, 78, "amberOakhomeFountain1")

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Main Door Entrance
evt.hint[76]        = ModTxt.CLeaveDungeon
evt.map[76]         = function()
    evt.MoveToMap{
        X           = -20248,
        Y           = -13457,
        Z           = 48,
        Direction   = 1312,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber.odm"
    }
end

-- Tavern Entrance
evt.HouseDoor(77, 249)
