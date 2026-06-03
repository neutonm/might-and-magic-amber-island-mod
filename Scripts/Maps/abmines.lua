--[[
Map:    Abandoned Mines
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count  = 0

------------------------------------------------------------------------------

-- FACE GROUPS
-- ID           DESCRIPTION
-- 10           (Warrior) Traps (floors)
-- 21-24        Gold Veins

-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1      Behemoth Chest is unlocked
-- MapVar25-28  Gold veins

-- MONSTERS
-- GROUP 1      Skeleton Warrior
-- BOSS 1       Behemoth

-- ***************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Main Hall (Entrance)
-- 01           02              House
-- 02           03              Behemoth Cave

-- ***************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Gold         21-23           Gold veins

-- TRAPS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Sparks       50              Entrance
-- PoisonSpray  51              Between tavern and rails

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local BehemothKeyItemID = 665

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.LoadMap()

    -- Set gold vein textures to depleted ones after save/load
    for i = 0, 3, 1 do
        local mapVarStr = "MapVar"..tostring(25 + i)
        if evt.Cmp(mapVarStr, 1) then
            evt.SetTexture(21 + i, "Cwb1")
        end
    end
end

------------------------------------------------------------------------------
-- CHESTS & GOLD VEINS
------------------------------------------------------------------------------

for i = 0, 19, 1 do
    local hintStr   = ModTxt.CChest
    if Game.Debug then
        hintStr     = hintStr .. " #"..tostring(i)
    end
    evt.hint[1 + i] = hintStr
    evt.map[1 + i]  = function()
        
        -- Behemoth Chest exception
        if IsWarrior() then
            if i == 2 then
                if not evt.Cmp("MapVar1", 1) then
                    if evt.All.Cmp("Inventory", BehemothKeyItemID) then
                        evt.Set("MapVar1", 1)
                        evt.Sub("Inventory", BehemothKeyItemID)
                    else
                        evt.FaceAnimation{Player = "Current", Animation = 18}
                        Game.ShowStatusText(ModTxt.CLockedChest)
                        return
                    end
                end
            end
        end

        evt.OpenChest(i)
    end
end 

-- Gold Vein
for i = 0, 3, 1 do
    evt.hint[21 + i]    = ModTxt.CGoldVein
    evt.map[21 + i]     = function()
        local gold
        local mapVarStr = "MapVar"..tostring(25 + i)
        if evt.Cmp(mapVarStr, 1) then
            return
        end
        gold = math.random(69,420)
        AddGoldExp(gold,0)
        evt.Set(mapVarStr, 1)
        evt.SetTexture(21 + i, "Cwb1")
    end
end

------------------------------------------------------------------------------
-- DOORS
------------------------------------------------------------------------------

-- Safe Room
evt.hint[25]        = ModTxt.CSafeRoom
evt.map[25]         = function()
    evt.EnterHouse(581)
end

-- Exit
evt.hint[100]       = ModTxt.CLeaveDungeon
evt.map[100]        = function()
    evt.MoveToMap{
        X           = 19510,
        Y           = 19396,
        Z           = 192,
        Direction   = 1794,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber.odm"}
end

------------------------------------------------------------------------------
-- TRAPS
------------------------------------------------------------------------------

-- Entrance
evt.map[50]         = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.Sparks,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = -823,
        FromY   = 891,
        FromZ   = 120,
        ToX     = -694,
        ToY     = 615,
        ToZ     = 65
    }
end

-- Between tavern and rails
evt.map[51]         = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.PoisonSpray,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = 7600,
        FromY   = 3063,
        FromZ   = 719,
        ToX     = 7649,
        ToY     = 4198,
        ToZ     = 710
    }
end
