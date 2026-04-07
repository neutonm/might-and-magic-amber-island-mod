--[[
Map:    Eastern Amber Island
Author: Henrik Chukhran, 2022 - 2026
]]

local TXT = Localize{
	[0] =   " ",
    [1] =   "House",
    [2] =   "Chest",
    [3] =   "Teleportation Platform",
    [4] =   "The Door is Locked",
    [5] =   "Robert Stevenson's Boat",
    [6] =   "Enter the Secret Hideout",
    [7] =   "Enter the Castle Amber",
    [8] =   "Weird Tree",
    [9] =   "",
    [10]=   "As you leave the secret hideout, a cool wind touches your face, hinting at urgency. "..
            "You notice the \01265523boat\01200000 that was once nearby is now \01265523missing.\01200000 "..
            "Far off, you see it near Castle Amber's Island, revealing the Archmage's escape route.\n\n"..
            "The chase isn't over yet, but now that you've pinpointed the Archmage's location, "..
            "it's time to \01265523head back to town and report to the mayor.\01200000\n\n"..
            "The \01265523letter\01200000 he left behind could serve as \01265523evidence\01200000 of your encounter with the Archmage.",
    [11]=   "Robert narrows his eyes, then points into the thick foliage behind the tree.\n\n'There... do you see it? That's the boat.'"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

local FaceGroup_HideoutBoat         = 1338
local FaceGroup_EntranceToCastle    = 1337
local FaceGroup_EntranceToCastleW   = 1339
local FaceGroup_PirateBoatW         = 1340

local SecretHideoutKeyItemID        = 667

-- ****************************************************************************

-- FACE GROUPS
-- ID           DESCRIPTION
-- 1337         Back Entrance to Castle Amber (near back port)
-- 1338         Archmage's Boat near Secret Hideout
-- 1339         Back Entrance to Castle Amber (below, east from castle, Warrior)
-- 1340         Robert Stevenson's Boat near weird tree (SW swamp area, Warrior)

------------------------------------------------------------------------------

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           1               Swamp Island, near weird tree
-- 01           2               Secret Hideout (roof)
-- 02           3               Castle Island, western (2nd) south ruin
-- 03           4               Behind Castle Amber
-- 04           5               Under the rock bridge (secret)

-- ****************************************************************************

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------
function events.AfterLoadMap(WasInGame)

    evt.SetNPCGroupNews(38, 42)

    if vars.MiscAmberIsland.ArchmageEscapedHideout == 1 then
        vars.MiscAmberIsland.ArchmageEscapedHideout = 2
        evt.SetFacetBit(FaceGroup_HideoutBoat,const.FacetBits.Invisible,    true)
        evt.SetFacetBit(FaceGroup_HideoutBoat,const.FacetBits.Untouchable,  true)
        Message(evt.str[10])
    end

    -- Robert Stevenson's Boat (Warrior)
    evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Invisible,   true)
    evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Untouchable, true)
    if vars.QuestsAmberIsland.QVarPirateWarrior > 0 then
        evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Invisible,   false)
        evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Untouchable, false)
    end

    -- Make back entrance to castle amber visible
    evt.SetFacetBit(FaceGroup_EntranceToCastle, const.FacetBits.Invisible,true)
    evt.SetFacetBit(FaceGroup_EntranceToCastleW,const.FacetBits.Invisible,true)
    if vars.MiscAmberIsland.AttackOnCastleAmber > 0 then
        local targetFaceGroup = IsWarrior() and FaceGroup_EntranceToCastleW or FaceGroup_EntranceToCastle
        evt.SetFacetBit(targetFaceGroup,const.FacetBits.Invisible,false)
    end

    -- Launch attack
    if vars.MiscAmberIsland.AttackOnCastleAmber == 1 then

        vars.MiscAmberIsland.AttackOnCastleAmber = 2
        GuardArray = {
            {X = -15953, Y = 9799,  Z = 155 },
            {X = -14107, Y = 8989,  Z = 128 },
            {X = 21002,  Y = 21545, Z = 59  },
            {X = 19590,  Y = 21634, Z = 78  },
            {X = 19727,  Y = 21769, Z = 62  },
            {X = -15366, Y = 8330,  Z = 183 },
            {X = -15908, Y = 9105,  Z = 160 },
            {X = -14458, Y = 10169, Z = 128 },
            {X = -15310, Y = 11232, Z = 198 },
            {X = 20636,  Y = 14904, Z = 1529},
            {X = 20279,  Y = 14213, Z = 1676},
            {X = 17567,  Y = 14430, Z = 1818},
            {X = 17417,  Y = 10712, Z = 1855},
            {X = 17115,  Y = 10075, Z = 1847},
            {X = 14769,  Y = 9061,  Z = 1946},
            {X = 14661,  Y = 8659,  Z = 1931},
            {X = 17224,  Y = 6578,  Z = 1824},
            {X = 19283,  Y = 7179,  Z = 1824},
            {X = 13134,  Y = 10866, Z = 2112},
            {X = 11594,  Y = 10737, Z = 2016},
            {X = 11089,  Y = 10278, Z = 2016},
            {X = 6270,   Y = 10156, Z = 2048},
            {X = 5569,   Y = 10386, Z = 2048},
            {X = 5482,   Y = 10882, Z = 2048},
            {X = 6075,   Y = 11284, Z = 2048},
            {X = 9727,   Y = 13896, Z = 1888},
            {X = 9903,   Y = 14164, Z = 1888},
            {X = 13942,  Y = 13668, Z = 1824},
            {X = 16660,  Y = 15011, Z = 1845},
            {X = 15245,  Y = 21249, Z = 767 },
            {X = 13915,  Y = 21480, Z = 712 },
            {X = 13626,  Y = 19743, Z = 814 },
            {X = 11491,  Y = 19058, Z = 878 },
            {X = 11864,  Y = 17922, Z = 864 },
            {X = 9707,   Y = 19366, Z = 916 },
            {X = 8159,   Y = 20732, Z = 832 },
            {X = 9923,   Y = 21615, Z = 787 },
            {X = 11843,  Y = 3246,  Z = 1408},
            {X = 5759,   Y = 2991,  Z = 768 },
            {X = 5167,   Y = 6789,  Z = 768 },
            {X = 4513,   Y = 7202,  Z = 768 },
            {X = 1282,   Y = 11611, Z = 768 },
            {X = 1024,   Y = 12162, Z = 768 },
            {X = 499,    Y = 12187, Z = 768 },
        }

        for i, guard in ipairs(GuardArray) do
            local mon = SummonMonster(206, guard.X , guard.Y, guard.Z, true)
            mon.Group = 39
        end
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
	    evt.OpenChest(i)
	end
end

------------------------------------------------------------------------------
-- DUNGEONS
------------------------------------------------------------------------------

-- Dungeon: Secret Hideout
--evt.house[29] = evt.str[11]
evt.hint[25] = evt.str[6]
evt.map[25] = function()

    if vars.MiscAmberIsland.SecretHideoutClosed == true then
        
        if not evt.All.Cmp("Inventory", SecretHideoutKeyItemID) then
            evt.FaceAnimation{Player = "Current", Animation = 18}
            evt.StatusText(4) -- "The Door is Locked"
            return
        end

        evt.Sub("Inventory", SecretHideoutKeyItemID)
        vars.MiscAmberIsland.SecretHideoutClosed = false
    end
    
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

-- Dungeon: Castle Amber
--evt.hint[31] = evt.str[12]
evt.hint[24] = evt.str[7]
evt.map[24] = function()
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

------------------------------------------------------------------------------
-- RESIDENCES
------------------------------------------------------------------------------

-- Sir Hoppington
evt.HouseDoor(21, 605)

-- Boatman's House
evt.HouseDoor(23, 607)

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Castle Amber Gates
evt.hint[22] = evt.str[7]
evt.map[22] = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    evt.StatusText(4)  -- "The Door is Locked"
end

-- Teleporter (Secret Hideout)
--evt.hint[39] = evt.str[8] -- Teleportation Platform
evt.hint[26] = evt.str[3]
evt.map[26] = function()
    evt.MoveToMap{
        X           = 18402,
        Y           = -19783,
        Z           = 1,
        Direction   = 607,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 1,
        Name        = "amber.odm"
    }
end

-- Pirate Treasure Tree
evt.hint[27] = evt.str[8]
evt.map[27] = function()

    if IsWarrior() then

        if vars.QuestsAmberIsland.QVarPirateWarrior > 0 then
            return
        end

        vars.QuestsAmberIsland.QVarPirateWarrior = 1

        evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Invisible,   false)
        evt.SetFacetBit(FaceGroup_PirateBoatW, const.FacetBits.Untouchable, false)

        Message(evt.str[11])

        return
    end

    if evt.Cmp("NPCs", 494) then

        vars.Quests.AmberQuest7 = "Done"
        evt.All.Add("Exp", 0)
        evt.SpeakNPC(494)
        evt.Subtract("NPCs", 494)
        evt.MoveNPC{NPC = 522, HouseId = 576}

        local MonsterArray =
        {
            {X = -1575,  Y = -8595,  Z = 66},
            {X = -1456,  Y = -9595,  Z = 59},
            {X = -1834,  Y = -11063, Z = 44},
            {X = -3387,  Y = -11675, Z = 44},
            {X = -4723,  Y = -10908, Z = 100}
        }

        for _, monster in ipairs(MonsterArray) do
            local mon   = SummonMonster(272, monster.X, monster.Y, monster.Z, true)
            mon.Hostile = true
            mon.Group   = 34
        end

        local npcPirate         = SummonMonster(273, -2612, -11033, 81, true)
        npcPirate.Hostile       = true
        npcPirate.Group         = 34
        npcPirate.NPC_ID        = 494
        npcPirate.FullHitPoints = 75
        npcPirate.Item          = 792
    end
end

-- Map Exit
evt.hint[28] = evt.str[0]
evt.map[28] = function()
    evt.MoveToMap{
        X           = 22064,
        Y           = 9465,
        Z           = 1,
        Direction   = 1024,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 1,
        Name        = "amber.odm"
    }
end

-- Robert Stevenson's Boat
evt.hint[29] = evt.str[5]
evt.map[29] = function()

    local mX = -4606
    local mY = 10731
    local mD = 1576

    -- Returning back after quest is done? (Broken boat on deadman's island)
    if vars.Quests.AmberQuest7W == "Done" then
        mX = -10371
        mY = -3226
        mD = 202
    end

    evt.MoveToMap{
        X           = mX,
        Y           = mY,
        Z           = 1,
        Direction   = mD,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 1,
        Name        = "deadmanisle.odm"
    }
end

