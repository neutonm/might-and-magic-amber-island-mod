--[[
Map:    Watchtower Cellar
Author: Henrik Chukhran, 2022 - 2026
]]

local TXT = Localize{
	[0]     = " ",
    [1]     = "Safe Room",
    [2]     = "Door",
    [3]     = "Button",
    [4]     = "Chest",
    [5]     = "Bookcase",
    [6]     = "Wine Rack",
    [7]     = "Leave Dungeon",
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

local SIRGREENE_NPC_ID = 538

-- ****************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION
-- 1            8th step button (Sets as secret in NPCTopicsAmber.lua)

-- VARIABLES
-- ID           DESCRIPTION
-- MapVar1      Robert Greene dialogue (in book room; near rubble) trigger cd
-- MapVar2      First time speaking with Robert Greene

------------------------------------------------------------------------------

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 1            0               Tower area: grated door to dwarven hideout
-- 2            0               Fancy room
-- 3            0               Broken rocky bridge (sewer)
-- 4            0               Secret: Tower area
-- 5            0               Secret: Dwarven hideout
-- 6            0               Secret: Waterfall, Cave with broken bridge
-- 7            0               Secret: Spider Cave
-- 8            0               Secret: Chest under the rocky bridge
-- 9            0               Tower area: floor button (8th step)

------------------------------------------------------------------------------

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1               Dwarven Hideout
-- 01           2               Dwarven Hideout (secret)
-- 02           3               Avalanched Room (enter from cave)
-- 03           4               Fancy Room
-- 04           5               Under the rock bridge (secret)
-- 05           6               Book Room

------------------------------------------------------------------------------

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Teleport     0               null

-- ****************************************************************************

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------
function events.AfterLoadMap(WasInGame)

    evt.Set("MapVar1", 0)
    
    -- Remove blaine
    for _, mon in Map.Monsters do
        if mon.NPC_ID  == SIRGREENE_NPC_ID and vars.Quests.StoryQuest1 == "Done" then
            RemoveMonster(mon)
        end
    end
end

function events.AfterMonsterAttacked(t, attacker)

    if t == nil then return end
    if attacker == nil then return end

    -- Prevent Robert Greene turning hostile if party attacks him
    if t.Attacker.Player ~= nil then
        if t.Monster.NPC_ID == SIRGREENE_NPC_ID then
            t.Monster.Ally      = 9000 + t.Monster.NPC_ID
            t.Monster.Hostile   = false
        end
    end
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------

for i = 0, 19, 1 do
	local hintStr = evt.str[4]
    if Game.Debug then
        hintStr = hintStr .. " #"..tostring(i)
    end
	evt.hint[1 + i] = hintStr
	evt.map[1 + i] = function() 
	    evt.OpenChest(i)
	end
end

------------------------------------------------------------------------------
-- DOORS
------------------------------------------------------------------------------

-- Fancy Room
evt.hint[21]    = evt.str[2]
evt.map[21]     = function()
    evt.SetDoorState{Id = 2, State = 2}
end

-- Broken Rocky Bridge
evt.hint[22]    = evt.str[2]
evt.map[22]     = function()
    evt.SetDoorState{Id = 3, State = 2}
end

-- Secret: Tower Area
evt.hint[23]    = evt.str[2]
evt.map[23]     = function()
    evt.SetDoorState{Id = 4, State = 2}
end

-- Secret: Dwarven Hideout
evt.hint[24]    = evt.str[2]
evt.map[24]     = function()
    evt.SetDoorState{Id = 5, State = 2}
end

-- Secret: Waterfall Cave
evt.hint[25]    = evt.str[2]
evt.map[25]     = function()
    evt.SetDoorState{Id = 6, State = 2}
end

-- Secret: Spider Cave
evt.hint[26]    = evt.str[2]
evt.map[26]     = function()
    evt.SetDoorState{Id = 7, State = 2}
end

-- Secret: Chest under the rocky bridge
evt.hint[27]    = evt.str[2]
evt.map[27]     = function()
    evt.SetDoorState{Id = 8, State = 2}
end

-- Tower area: floor button (8th step)
evt.hint[28]    = evt.str[3]
evt.map[28]     = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 9, State = 2}
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Water polygon in book room area: Sir Greene contact
evt.hint[31]    = evt.str[0]
evt.map[31]     = function()

    local isGreenePresent = false

    for _, mon in Map.Monsters do
        if mon.NPC_ID == SIRGREENE_NPC_ID then
            isGreenePresent = true
        end
    end

    if isGreenePresent then

        if not evt.Cmp("MapVar1", 1) then
            evt.Set("MapVar1", 1)

            if not evt.Cmp("MapVar2", 1) then

                XYZ(Party, -4681, 537, -639)
                Party.Direction = 1530
	            Party.LookAngle = -32
                evt.Set("MapVar2", 1)
            end
            evt.SpeakNPC(SIRGREENE_NPC_ID)
        end
	end
end

-- Rest Rooms
evt.hint[32]    = evt.str[1]
evt.map[32]     = function()
    evt.EnterHouse(581)
end

-- Wine Racks
evt.hint[33]    = evt.str[6]
evt.map[33]     = function()

end

evt.hint[34]    = evt.str[6]
evt.map[34]     = function()

end

evt.hint[35]    = evt.str[6]
evt.map[35]     = function()

end

evt.hint[36]    = evt.str[6]
evt.map[36]     = function()

end

evt.hint[37]    = evt.str[6]
evt.map[37]     = function()

end

evt.hint[38]    = evt.str[6]
evt.map[38]     = function()

end

-- Secret: Dwarven Hideout > Bookcase
evt.hint[39]    = evt.str[5]
evt.map[39]     = function()

end

-- Spider Cave Secret place: pit
evt.hint[40]    = evt.str[0]
evt.map[40]     = function()
    evt.MoveToMap{
        X           = -8817,
        Y           = 3444,
        Z           = -603,
        Direction   = 1079,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 0,
        Name        = "0"
    }
end

-- Exit
evt.hint[41]    = evt.str[7]
evt.map[41]     = function()
    evt.MoveToMap{
        X           = 15375,
        Y           = -11428,
        Z           = 865,
        Direction   = 1054,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber.odm"
    }
end

-- Water polygon in book room area: Sir Greene contact
-- Reset dialogue cd
evt.hint[42]    = evt.str[0]
evt.map[42]     = function()

    if evt.Cmp("MapVar1", 1) then
        evt.Set("MapVar1", 0)
    end
end

