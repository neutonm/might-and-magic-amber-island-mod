--[[
Map:     Archmage Realm (Workshop Key location)
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count = 0

------------------------------------------------------------------------------

-- FACE GROUPS
-- ID           DESCRIPTION
-- 5            Western Teleportator Room & Realm port texture
-- 6            Eastern Teleportator Room & Realm port texture

-- BOSS 1: Western Realm, Minotaur
-- BOSS 2: Eastern Realm, Minotaur

-- ***************************************************************************

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 47           46              Secret: Western Key Realm (Waterfall Chamber)

-- ***************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1              Western Realm (QUEST: Key)
-- 01           2              Eastern Realm (QUEST: Key)
-- 92           3              Secret: Eastern Realm

-- ***************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Teleport     52              Western Realm, Platform
-- Teleport     54              Eastern Realm, Platform

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

-- Doors
-- Secret: Western Key Realm (Waterfall Chamber)
evt.hint[46]        = ModTxt.CDoor
evt.map[46]         = function()
    evt.SetDoorState{Id = 47, State = 2}
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Teleport: From Western Teleport Room to Western Realm [DEPRECATED]
evt.hint[51]        = ModTxt.CNull
evt.map[51]         = function()
    evt.MoveToMap{
        X           = -11607,
        Y           = 2335,
        Z           = 706,
        Direction   = 516,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Teleport: From Western Realm to Western Teleport Room
evt.hint[52]        = ModTxt.CNull
evt.map[52]         = function()
    evt.MoveToMap{
        X           = -5269,
        Y           = 2803,
        Z           = 190,
        Direction   = 0,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "archmageres.blv"
    }
end

-- Teleport: From Eastern Teleport Room to Eastern Realm [DEPRECATED]
evt.hint[53]        = ModTxt.CNull
evt.map[53]         = function()
    evt.MoveToMap{
        X           = 20796,
        Y           = 988,
        Z           = 65,
        Direction   = 510,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Teleport: From Eastern Realm to Eastern Teleport Room 
evt.hint[54]        = ModTxt.CNull
evt.map[54]         = function()
    evt.MoveToMap{
        X           = 10364,
        Y           = 2937,
        Z           = 65,
        Direction   = 1024,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "archmageres.blv"
    }
end
