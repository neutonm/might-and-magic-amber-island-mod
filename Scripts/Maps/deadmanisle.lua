--[[
Map:    Deadman's Island
Author: Henrik Chukhran, 2022 - 2026
--]]

local TXT = Localize{
	[0] =   " ",
    [1] =   "Tent",
    [2] =   "Chest",
    [3] =   "Boat",
    [4] =   "Broken Boat",
    [5] =   "+25 Max HP (Temporary)",
    [6] =   "Refreshing",
    [7] =   "As you return, you find your boat half-submerged in the shallows, \01265523sabotaged beyond repair.\01200000\n\n"..
            "You'll need to find another way off the island."
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

local FaceGroup_BaseBoat        = 1
local FaceGroup_RuinedBoat      = 2
local SpriteID_BaseBoatLantern  = 4

-- ****************************************************************************

-- FACE GROUPS / SPRITE ID
-- ID           DESCRIPTION
-- 1            Robert Stevenson's Boat
-- 2            Broken Robert Stevensons's Boat
-- 3            Camp Boat
-- 4            Boat Lantern sprite
-- 5            Camp Boat Lantern sprite

------------------------------------------------------------------------------

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1               Dirt cross-road
-- 01           2               South part of Island, near house ruin
-- 02           3               Inside cave (story quest)

-- ****************************************************************************

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local function PostPirateAmbush()

    -- Ruin boat
    evt.SetFacetBit(FaceGroup_BaseBoat,  const.FacetBits.Invisible, true)
    evt.SetFacetBit(FaceGroup_RuinedBoat,const.FacetBits.Invisible, false)
    evt.SetSprite(SpriteID_BaseBoatLantern, false)
end

local function PirateAmbush()

    if evt.Cmp("NPCs", 494) then

        vars.Quests.AmberQuest7W = "Done"
        evt.All.Add("Exp", 0)
        evt.SpeakNPC(494)
        evt.Subtract("NPCs", 494)
        evt.MoveNPC{NPC = 522, HouseId = 576}

        -- move party towards ambush
        XYZ(Party, -1320, -2568, 1)
        Party.Direction = 165
        Party.LookAngle = 0

        -- Spawn Pirates
        local MonsterArray =
        {
            -- front
            {X = 3130,      Y = 1028    },
            {X = 3350,      Y = 923     },
            {X = 3521,      Y = 784     },
            {X = 3748,      Y = 593     },
            {X = 3914,      Y = 454     },
            {X = 4117,      Y = 285     },
            {X = 4300,      Y = 166     },
            {X = 4457,      Y = -2      },

            -- back
            {X = 3708,      Y = 1546    },
            {X = 3959,      Y = 1350    },
            {X = 4683,      Y = 781     },
            {X = 4922,      Y = 594     },

            -- near south camp
            {X = -9483,      Y = -3171  },
            {X = -9546,      Y = -2804  },
            {X = -9936,      Y = -3143  },
            {X = -9847,      Y = -2819  },
            {X = -9889,      Y = -2949  },
            {X = -9712,      Y = -2398  },
            {X = -9998,      Y = -2250  },
        }

        for _, monster in ipairs(MonsterArray) do
            local mon   = SummonMonster(272, monster.X, monster.Y, 0, true)
            mon.Hostile = true
            mon.Group   = 34
        end

        -- Robert Stevenson himself
        local npcPirate         = SummonMonster(273, 4318, 1068, 0, true)
        npcPirate.Hostile       = true
        npcPirate.Group         = 34
        npcPirate.NPC_ID        = 494
        npcPirate.FullHitPoints = 250
        npcPirate.Item          = 792

        PostPirateAmbush()
    end
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterLoadMap(WasInGame)

    if vars.Quests.AmberQuest7W == "Done" then
        PostPirateAmbush()
    end
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------
for i = 0, 19, 1 do
	local hintStr = evt.str[2]
    if Game.Debug then
        hintStr = hintStr .. " #"..tostring(i)
    end
	evt.hint[1 + i] = hintStr
	evt.map[1 + i] = function()

        -- pirate chest
        if i == 2 then

            if vars.Quests.AmberQuest7W ~= "Done" then
                PirateAmbush()
                return
            end
        end
	    evt.OpenChest(i)
	end
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Tent (Safe Room)
evt.hint[22] = evt.str[1]
evt.map[22] = function()
    evt.EnterHouse(581)
end

-- Boat
evt.hint[23] = evt.str[3]
evt.map[23] = function()

    evt.MoveToMap{
        X           = -4110,
        Y           = -14336,
        Z           = 1,
        Direction   = 518,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 1,
        Name        = "amber-east.odm"
    }
end

-- Broken Boat
evt.hint[24] = evt.str[4]
evt.map[24] = function()
    Message(evt.str[7])
end

-- Well
evt.hint[25] = evt.str[4]
evt.map[25] = function()

    if evt.Cmp("PlayerBits", 6) then
		evt.StatusText(6)         -- "Refreshing!"
		return
	end

    evt.Add("FullHitPointsBonus", 25)
    evt.Set("PlayerBits", 6)
	evt.StatusText(5)         -- "+25 Max HP (Temporary)"
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 6)
end, const.Day)
