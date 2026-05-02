--[[
Map:    Developer Dungeon
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count = 0

-- Double Door
evt.hint[1]         = ModTxt.CDoor
evt.map[1]          = function()
    evt.MoveToMap{
        X           = -15484,
        Y           = -21868,
        Z           = 256,
        Direction   = 649,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 191,
        Icon        = 1,
        Name        = "amber.odm"
    }
end

-- Training Hall Icon
evt.hint[2]         = ModTxt.CDoor
evt.map[2]          = function()
    evt.MoveToMap{
        X           = -148,
        Y           = 3,
        Z           = 0,
        Direction   = 2044,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 194,
        Icon        = 1,
        Name        = "applecave.blv"
    }
end

-- Stables Icon
evt.hint[3]         = ModTxt.CDoor
evt.map[3]          = function()
    evt.MoveToMap{
        X           = -41,
        Y           = 369,
        Z           = 0,
        Direction   = 2,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 193,
        Icon        = 1,
        Name        = "oakhome.blv"
    }
end

-- Water Guild Icon
evt.hint[4]         = ModTxt.CDoor
evt.map[4]          = function()
    evt.MoveToMap{
        X           = 293,
        Y           = 286,
        Z           = 14,
        Direction   = 1312,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 198,
        Icon        = 1,
        Name        = "testlevel.blv"
    }
end

-- War Dwarf
evt.hint[5]         = ModTxt.CTrigger
evt.map[5]          = function()
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

-- Peasant Dwarf
evt.hint[6]         = ModTxt.CTrigger
evt.map[6]          = function()
    evt.MoveToMap{
        X           = 190,
        Y           = 140,
        Z           = 33,
        Direction   = 512,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 196,
        Icon        = 1,
        Name        = "abmines.blv"
    }
end

-- Pedestal
evt.hint[7]         = ModTxt.CTrigger
evt.map[7]          = function()
    evt.MoveToMap{
        X           = -3,
        Y           = -90,
        Z           = 1,
        Direction   = 512,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 197,
        Icon        = 1,
        Name        = "secret.blv"
    }
end

-- Contest Pyre
evt.hint[8]         = ModTxt.CTrigger
evt.map[8]          = function()
    evt.MoveToMap{
        X           = 16248,
        Y           = 16674,
        Z           = 1,
        Direction   = 1024,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 192,
        Icon        = 1,
        Name        = "amber-east.odm"
    }
end
