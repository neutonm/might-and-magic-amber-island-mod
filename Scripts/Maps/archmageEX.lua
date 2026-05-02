--[[
Map:    Archmage Residence Entrance
Author: Henrik Chukhran, 2022 - 2026
]]

local TXT = Localize{
    [1]     =   "Still the same sour apple tree...",
    [2]     =   "Use the telescope",
    [3]     =   "You observe a distant celestial body in the sky."
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count  = 0

------------------------------------------------------------------------------

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

-- ****************************************************************************

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

-- ****************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1               Servants' Room
-- 01           2               Cat Room
-- 02           3               Labolatory (Portal)

-- ****************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Teleport     40              Lab: From South to West
-- Teleport     41              Lab: From West to South
-- -            42              
-- Trigger      43              Cat Bed (key)
-- Trigger      44              Main Hall: Keyhole near Grated Door
-- Decoration   45              Apple Tree
-- Door         46              Entrance to actual Archmage Residence
-- Door         47              Rest Room (Entrance)
-- Door         48              Locked Door (Entrance)
-- Door         49              Exit
-- Fire (Sprite)50              Ignore Picking Fires (rings and sheit)
-- Fountain     51              Surrounding the statue
-- Fountain     53              Apple Tree
-- Fountain     55              Behind the Apple Tree
-- Sphere       36              Summoning Chamber: Fire Resistance +2 sphere
-- Sphere       37              Summoning Chamber: Air Resistance +2 sphere
-- Sphere       38              Summoning Chamber: Water Resistance +2 sphere
-- Sphere       39              Summoning Chamber: Earth Resistance +2 sphere
-- Trigger      58              Floor: opens grated door if returned from archmageres.blv

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local CatKeyItemID      = 666 -- infernal cat key :)

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterLoadMap(WasInGame)

    MakeHostile(79,81) -- Golems
end

function events.LoadMap()

    if evt.Cmp("MapVar7", 1) then
        evt.SetFacetBit(1, const.FacetBits.Untouchable, true)
    end
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
-- DOORS
------------------------------------------------------------------------------

-- Double-Door: Entrance Doors (Warrior)
evt.hint[21]        = ModTxt.CDoor
evt.map[21]         = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 2, State = 2}
end

-- Double Door: Main Hall: Observatory
evt.hint[22]        = ModTxt.CDoor
evt.map[22]         = function()
    evt.SetDoorState{Id = 3, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Observatory
evt.hint[23]        = ModTxt.CDoor
evt.map[23]         = function()
    evt.SetDoorState{Id = 5, State = 2}
end

-- Main Hall: Servants' Room
evt.hint[24]        = ModTxt.CDoor
evt.map[24]         = function()
    evt.SetDoorState{Id = 6, State = 2}
end

-- Main Hall: Cat Room
evt.hint[25]        = ModTxt.CDoor
evt.map[25]         = function()
    evt.SetDoorState{Id = 7, State = 2}
end

-- Main Hall: Summoning Chamber
evt.hint[26]        = ModTxt.CDoor
evt.map[26]         = function()
    evt.SetDoorState{Id = 8, State = 2}
end

-- Summoning Chamber
evt.hint[27]        = ModTxt.CDoor
evt.map[27]         = function()
    evt.SetDoorState{Id = 9, State = 2}
end

-- Main Hall: Lab
evt.hint[28]        = ModTxt.CNull
evt.map[28]         = function()
    evt.SetDoorState{Id = 11, State = 2}
    evt.SetDoorState{Id = 12, State = 2}
end

-- Lab
evt.hint[29]        = ModTxt.CNull
evt.map[29]         = function()
    evt.SetDoorState{Id = 13, State = 2}
    evt.SetDoorState{Id = 14, State = 2}
end

------------------------------------------------------------------------------
-- BOOKCASES
------------------------------------------------------------------------------

-- Observatory: South
evt.hint[31]        = ModTxt.CBookcase
evt.map[31]         = function()
    if not evt.Cmp("MapVar1", 1) then
        evt.Set("MapVar1", 1)
        evt.Add("Inventory", 300)    -- "Torch Light" scroll
    end
end

-- Observatory: North
evt.hint[32]        = ModTxt.CBookcase
evt.map[32]         = function()
    if not evt.Cmp("MapVar2", 1) then
        evt.Set("MapVar2", 1)
        evt.Add("Inventory", 335)    -- "Earth Resistance" scroll
    end
end

-- Lab: Portal
evt.hint[33]        = ModTxt.CBookcase
evt.map[33]         = function()
    if not evt.Cmp("MapVar3", 1) then
        evt.Set("MapVar3", 1)
        evt.Add("Inventory", 381)    -- "Summon Elementalr" scroll
    end
end

-- Lab: Gravity Pad, North
evt.hint[34]        = ModTxt.CBookcase
evt.map[34]         = function()
    if not evt.Cmp("MapVar4", 1) then
        evt.Set("MapVar4", 1)
        evt.Add("Inventory", 324)    -- "Water Resistance" scroll
    end
end

-- Lab: Gravity Pad, South
evt.hint[35]        = ModTxt.CBookcase
evt.map[35]         = function()
    if not evt.Cmp("MapVar5", 1) then
        evt.Set("MapVar5", 1)
        evt.Add("Inventory", 302)    -- "Fire Resistance" scroll
    end
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Teleporter: From South to West
evt.hint[40]        = ModTxt.CNull
evt.map[40]         = function()

    evt.MoveToMap{
        X           = -4616,
        Y           = 2509,
        Z           = -96,
        Direction   = 2048,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Teleporter: From West to South
evt.hint[41]        = ModTxt.CNull
evt.map[41]         = function()

    evt.MoveToMap{
        X           = -3446,
        Y           = 1600,
        Z           = -96,
        Direction   = 512,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Fountains
-- evt.hint[42]    = ModTxt.CFountain
-- evt.map[42]     = function()
--     Game.ShowStatusText(ModTxt.CRefreshing)
-- end

-- Cat Bed
evt.hint[43]        = ModTxt.CNull
evt.map[43]         = function()
    if not evt.Cmp("MapVar6", 1) then
        evt.Set("MapVar6", 1)
        evt.Add("Inventory", CatKeyItemID)
    end
end

-- Main Hall: Keyhole near Grated Door
evt.hint[44]        = ModTxt.CKeyhole
evt.map[44]         = function()
    if not evt.Cmp("MapVar7", 1) then
        if evt.All.Cmp("Inventory", CatKeyItemID) then

            evt.Set("MapVar7", 1)
            evt.Sub("Inventory", CatKeyItemID)

            evt.FaceAnimation{Player = "All", Animation = 43}
            evt.PlaySound(303,Party.X,Party.Y)

            evt.SetDoorState{Id = 10, State = 2}
            evt.SetFacetBit(1, const.FacetBits.Untouchable, true)
        else
            evt.FaceAnimation{Player = "Current", Animation = 18}
            Game.ShowStatusText(ModTxt.CLockedDoor)
        end
    end
end

-- Apple Tree
evt.hint[45]        = ModTxt.CTree
evt.map[45]         = function()
    Game.ShowStatusText(evt.str[1])
end

-- Dungeon Door (Grated Door corridor)
evt.hint[46]        = ModTxt.CResidence
evt.map[46]         = function()
    evt.MoveToMap{
        X           = -4,
        Y           = -2,
        Z           = 1,
        Direction   = 2046,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 195,
        Icon        = 1,
        Name        = "archmageres.blv"
    }
end

-- Rest Room
evt.hint[47]        = ModTxt.CSafeRoom
evt.map[47]         = function()
    evt.EnterHouse(581)
end

-- Locked Door (Entrance)
evt.hint[48]        = ModTxt.CDoor
evt.map[48]         = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    Game.ShowStatusText(ModTxt.CLockedDoor)
end

-- Exit Door (Entrance)
evt.hint[49]        = ModTxt.CLeaveDungeon
evt.map[49]         = function()
    evt.MoveToMap{
        X           = -4973,
        Y           = -17139,
        Z           = 598,
        Direction   = 2038,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber.odm"
    }
end

-- Fires
evt.hint[50]        = ModTxt.CNull
evt.map[50]         = function() end

-- Telescope small lense (blacK)
evt.hint[51]        = evt.str[2]
evt.map[51]         = function()
    -- "You observe a distant celestial body in the sky."
    Game.ShowStatusText(evt.str[3])
end

-- Floor outside entrance to the "Archmage Residence"
-- Open door in case player managed to get to archmageres first
evt.hint[58]        = ModTxt.СNull
evt.map[58]         = function()
    evt.SetDoorState{Id = 10, State = 2}
    evt.SetFacetBit(1, const.FacetBits.Untouchable, true)
end

------------------------------------------------------------------------------
-- FOUNTAINS
------------------------------------------------------------------------------

-- Fountain: Statue
Fountain(57, 50, "amberArchmageresFountain1")

-- Fountain: Apple Tree
Fountain(53, 52, "amberArchmageresFountain2")

-- Fountain: Behind the tree
Fountain(55, 54, "amberArchmageresFountain3")

-- Magical Sphere: Summoning Chamber, Fire Resistance
Fountain(36, 0, "amberArchmageresSphereFire")

-- Magical Sphere: Summoning Chamber, Air Resistance
Fountain(37, 0, "amberArchmageresSphereAir")

-- Magical Sphere: Summoning Chamber, Water Resistance
Fountain(38, 0, "amberArchmageresSphereWater")

-- Magical Sphere: Summoning Chamber, Earth Resistance
Fountain(39, 0, "amberArchmageresSphereEarth")

