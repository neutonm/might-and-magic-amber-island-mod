--[[
Map: Eastern Amber Island
Author: Henrik Chukhran, 2022 - 2024
]]


local TXT = Localize{
	[0] = " ",
    [1] = "House",
    [2] = "Chest",
    [3] = "Fountain",
    [4] = "Refreshing",
    [5] = "Drink from the Fountain",
    [6] = "Well",
    [7] = "Drink from the Well",
    [8] = "Teleportation Platform",
    [9] = "Statue",
    [10] = "Altar",
    [11] = "Oak Hill Cottage",
    [12] = "Archmage's Residence",
    [13] = "Apple Cave",
    [14] = "Abandoned Mines",
    [15] = "Enter the Secret Hideout",
    [16] = "Enter the Castle Amber",
    [17] = "Enter the Cave",
    [18] = "Enter the Abandoned Mines",
    [19] = "Horse Statue",
    [20] = "Tent",
    [21] = "Pray at Altar",
    [22] = "Black Betty", -- Ship
    [23] = "Saint Barthelemy", -- Ship
    [24] = "Powder Keg Inn",
    [25] = "Amber Training Grounds",
    [26] = "Nourville's Cathedrall",
    [27] = "Amber Bank",
    [28] = "Crusty Eagle Inn",
    [29] = "Steel Bucket",
    [30] = "Razorsharp",
    [31] = "Magic in the Potion",
    [32] = "Odds and Ends",
    [33] = "Guild of Spirit Magic",
    [34] = "Guild of Body Magic",
    [35] = "Guild of Mind Magic",
    [36] = "Guild of Fire Magic",
    [37] = "Guild of Air Magic",
    [38] = "Guild of Water Magic",
    [39] = "Guild of Earth Magic",
    [40] = "Amber Townhall",
    [41] = "Tower",
    [42] = "Residence",
    [43] = "Tree"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

-- EVENTS
------------------------------------------------------------------------------
function events.AfterLoadMap(WasInGame)

    --MakeHostile(265,267) -- Lizards
    evt.SetNPCGroupNews(38, 42)

    if vars.MiscAmberIsland.ArchmageEscapedHideout == 1 then
        vars.MiscAmberIsland.ArchmageEscapedHideout = 2
        evt.SetFacetBit(1338,const.FacetBits.Invisible,true)
        evt.SetFacetBit(1338,const.FacetBits.Untouchable,true)
        Message("As you leave the secret hideout, a cool wind touches your face, hinting at urgency. You notice the boat that was once nearby is now missing. Far off, you see it near Castle Amber's Island, revealing the Archmage's escape route."..
                "The chase isn't over yet, but now that you've pinpointed the Archmage's location, it's time to head back to town and report to the mayor."..
                "The letter he left behind could serve as evidence of your encounter with the Archmage.")
    end

    -- Make back entrance to castle amber visible
    if vars.MiscAmberIsland.AttackOnCastleAmber == 0 then
        evt.SetFacetBit(1337,const.FacetBits.Invisible,true)
    else
        evt.SetFacetBit(1337,const.FacetBits.Invisible,false)
    end

    -- Launch attack
    if vars.MiscAmberIsland.AttackOnCastleAmber == 1 then

        vars.MiscAmberIsland.AttackOnCastleAmber = 2
        GuardArray = {
            {X = -15953, Y = 9799, Z = 155},
            {X = -14107, Y = 8989, Z = 128},
            {X = 21002, Y = 21545, Z = 59},
            {X = 19590, Y = 21634, Z = 78},
            {X = 19727, Y = 21769, Z = 62},
            {X = -15366, Y = 8330, Z = 183},
            {X = -15908, Y = 9105, Z = 160},
            {X = -14458, Y = 10169, Z = 128},
            {X = -15310, Y = 11232, Z = 198},
            {X = 20636, Y = 14904, Z = 1529},
            {X = 20279, Y = 14213, Z = 1676},
            {X = 17567, Y = 14430, Z = 1818},
            {X = 17417, Y = 10712, Z = 1855},
            {X = 17115, Y = 10075, Z = 1847},
            {X = 14769, Y = 9061, Z = 1946},
            {X = 14661, Y = 8659, Z = 1931},
            {X = 17224, Y = 6578, Z = 1824},
            {X = 19283, Y = 7179, Z = 1824},
            {X = 13134, Y = 10866, Z = 2112},
            {X = 11594, Y = 10737, Z = 2016},
            {X = 11089, Y = 10278, Z = 2016},
            {X = 6270, Y = 10156, Z = 2048},
            {X = 5569, Y = 10386, Z = 2048},
            {X = 5482, Y = 10882, Z = 2048},
            {X = 6075, Y = 11284, Z = 2048},
            {X = 9727, Y = 13896, Z = 1888},
            {X = 9903, Y = 14164, Z = 1888},
            {X = 13942, Y = 13668, Z = 1824},
            {X = 16660, Y = 15011, Z = 1845},
            {X = 15245, Y = 21249, Z = 767},
            {X = 13915, Y = 21480, Z = 712},
            {X = 13626, Y = 19743, Z = 814},
            {X = 11491, Y = 19058, Z = 878},
            {X = 11864, Y = 17922, Z = 864},
            {X = 9707, Y = 19366, Z = 916},
            {X = 8159, Y = 20732, Z = 832},
            {X = 9923, Y = 21615, Z = 787},
            {X = 11843, Y = 3246, Z = 1408},
            {X = 5759, Y = 2991, Z = 768},
            {X = 5167, Y = 6789, Z = 768},
            {X = 4513, Y = 7202, Z = 768},
            {X = 1282, Y = 11611, Z = 768},
            {X = 1024, Y = 12162, Z = 768},
            {X = 499, Y = 12187, Z = 768},
        }

        for i, guard in ipairs(GuardArray) do
            local mon = SummonMonster(206, guard.X , guard.Y, guard.Z, true)
            mon.Group = 39
        end
    end
end

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

-- DUNGEONS
------------------------------------------------------------------------------
-- Dungeon: Secret Hideout
--evt.house[29] = evt.str[11]
evt.hint[25] = evt.str[15]
evt.map[25] = function()
    evt.MoveToMap{X = -3, Y = -90, Z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 197, Icon = 1, Name = "secret.blv"}
end

-- Dungeon: Castle Amber
--evt.hint[31] = evt.str[12]
evt.hint[24] = evt.str[16]
evt.map[24] = function()
    evt.MoveToMap{X = 293, Y = 286, Z = 14, Direction = 1312, LookAngle = 0, SpeedZ = 0, HouseId = 198, Icon = 1, Name = "testlevel.blv"}
end

-- RESIDENCES
------------------------------------------------------------------------------
-- Sir Hoppington
evt.HouseDoor(21, 605)

-- Boatman's House
evt.HouseDoor(23, 607)

-- MISC
------------------------------------------------------------------------------

-- Castle Amber Gates
evt.hint[22] = evt.str[16]
evt.map[22] = function()
    evt.FaceAnimation{Player = "Current", Animation = 18}
    evt.StatusText(16)         				-- "The Door is Locked"
end

-- Teleporter (Secret Hideout)
--evt.hint[39] = evt.str[8] -- Teleportation Platform
evt.hint[26] = evt.str[8]
evt.map[26] = function()
    evt.MoveToMap{X = 18402, Y = -19783, Z = 1, Direction = 607, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "amber.odm"}
end

-- Pirate Treasure Tree
evt.hint[27] = evt.str[43]
evt.map[27] = function()
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
            local mon = SummonMonster(272, monster.X, monster.Y, monster.Z, true)
            mon.Hostile = true
            mon.Group = 34
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
evt.hint[28] = evt.str[43]
evt.map[28] = function()
    evt.MoveToMap{X = 22064, Y = 9465, Z = 1, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "amber.odm"}
end

