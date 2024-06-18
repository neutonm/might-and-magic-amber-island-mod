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

