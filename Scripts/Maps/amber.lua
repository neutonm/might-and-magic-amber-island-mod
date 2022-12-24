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
    [11] = "Wine Cellar",
    [12] = "Archmage's Residence",
    [13] = "Cave",
    [14] = "Abandoned Mines",
    [15] = "Enter the Wine Cellar",
    [16] = "Enter the Archmage's Residence",
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
    [42] = "Residence"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

-- CHESTS
------------------------------------------------------------------------------
for i = 0, 19, 1 do
	evt.hint[1 + i] = evt.str[2] .." #"..tostring(i)
	evt.map[1 + i] = function()
	    evt.OpenChest(i)
	end
end

-- WELLS
------------------------------------------------------------------------------
evt.hint[21] = evt.str[6] -- Well (title)
evt.hint[22] = evt.str[7] -- Drink From The Well
evt.hint[23] = evt.str[7]
evt.hint[24] = evt.str[7]
evt.hint[25] = evt.str[7]

-- Well: Port Island
evt.map[22] = function()
    evt.StatusText(4)
end

-- Well: Before Amber Town Bridge
evt.map[23] = function()
    evt.StatusText(4)
end

-- Well: Inside Amber Town
evt.map[24] = function()
    evt.StatusText(4)
end

-- Well: Swamp Island
evt.map[25] = function()
    evt.StatusText(4)
end

-- FOUNTAINS
------------------------------------------------------------------------------
evt.hint[26] = evt.str[3] -- Fountain
evt.hint[27] = evt.str[5] -- Drink from the Fountain
evt.hint[28] = evt.str[5]

-- Fountain: Port Island
evt.map[27] = function()
    evt.StatusText(4)
end

-- Fountain: Amber Town
evt.map[28] = function()
    evt.StatusText(4)
end

-- DUNGEONS
------------------------------------------------------------------------------
-- Dungeon: Wine Cellar
evt.house[29] = evt.str[11]
evt.hint[30] = evt.str[15]
evt.map[30] = function()
    evt.MoveToMap(293,286,14,1312,1,1,191,1,"testlevel.blv")
end

-- Dungeon: ArchMage's Residence
evt.hint[31] = evt.str[12]
evt.hint[32] = evt.str[16]
evt.map[32] = function()
    evt.MoveToMap(293,286,14,1312,1,1,191,1,"testlevel.blv")
end

-- Dungeon: Cave
evt.hint[34] = evt.str[17] -- Abandoned Cave
evt.hint[33] = evt.str[13] -- Enter the Cave
evt.map[34] = function()
    evt.MoveToMap(293,286,14,1312,1,1,191,1,"testlevel.blv")
end

-- Dungeon: Abandoned Mines
evt.hint[35] = evt.str[14] -- Abandoned Mines
evt.hint[36] = evt.str[18] -- Enter the Abandoned Mines
evt.map[36] = function()
    evt.MoveToMap(293,286,14,1312,1,1,191,1,"testlevel.blv")
end

-- MISC
------------------------------------------------------------------------------
-- Statue: Horse
evt.hint[37] = evt.str[19] -- Horse Statue
evt.map[37] = function()
    --
end

-- Statue: Swamp Island
evt.hint[38] = evt.str[9] -- Statue
evt.map[38] = function()
    --
end

-- Teleporter: Swamp Island
evt.hint[39] = evt.str[8] -- Teleportation Platform
evt.hint[40] = evt.str[8]
evt.map[40] = function()
    --
end

-- Altar: Swamp Island
evt.hint[41] = evt.str[10] -- Altar
evt.hint[42] = evt.str[21]
evt.map[42] = function()
    --
end
------------------------------------------------------------------------------
-- SHIPS
evt.hint[60] = evt.str[22]
evt.hint[61] = evt.str[22]
evt.map[61] = function()
    
    evt.EnterHouse(238)
end

evt.hint[62] = evt.str[23]
evt.hint[63] = evt.str[23]
evt.map[63] = function()
    
    evt.EnterHouse(64)
end


-- SHOPS
------------------------------------------------------------------------------
-- Inn
evt.hint[64] = evt.str[24] -- Powder Keg Inn
evt.hint[65] = evt.str[24]
evt.map[65] = function()
    evt.EnterHouse(117)
end

-- Training Hall
evt.hint[66] = evt.str[25] -- Amber Training Grounds
evt.hint[67] = evt.str[25]
evt.map[67] = function()
    evt.EnterHouse(116)
end

-- Temple
evt.hint[68] = evt.str[26] -- Nourville's Cathedrall
evt.hint[69] = evt.str[26]
evt.map[69] = function()
    evt.EnterHouse(116)
end

-- Bank
evt.hint[70] = evt.str[27] -- Amber Bank
evt.hint[71] = evt.str[27]
evt.map[71] = function()
    evt.EnterHouse(116)
end

-- Tavern
evt.hint[72] = evt.str[28] -- Crusty Eagle Inn
evt.hint[73] = evt.str[28]
evt.map[73] = function()
    evt.EnterHouse(116)
end

-- Armorer
evt.hint[74] = evt.str[29] -- Steel Bucket
evt.hint[75] = evt.str[29]
evt.map[75] = function()
    evt.EnterHouse(116)
end

-- Smith
evt.hint[76] = evt.str[30] -- Razorsharp
evt.hint[77] = evt.str[30]
evt.map[77] = function()
    evt.EnterHouse(116)
end

-- Alchemist
evt.hint[78] = evt.str[31] -- Magic in the Potion
evt.hint[79] = evt.str[31]
evt.map[79] = function()
    evt.EnterHouse(116)
end

-- Magician
evt.hint[80] = evt.str[32] -- Odds and Ends
evt.hint[81] = evt.str[32]
evt.map[81] = function()
    evt.EnterHouse(116)
end

-- Guild: Spirit
evt.hint[82] = evt.str[33] -- Guild of Spirit Magic
evt.hint[83] = evt.str[33]
evt.map[83] = function()
    evt.EnterHouse(116)
end

-- Guild: Body
evt.hint[84] = evt.str[34] -- Guild of Body Magic
evt.hint[85] = evt.str[34]
evt.map[85] = function()
    evt.EnterHouse(116)
end

-- Guild: Mind
evt.hint[86] = evt.str[35] -- Guild of Mind Magic
evt.hint[87] = evt.str[35]
evt.map[87] = function()
    evt.EnterHouse(116)
end

-- Guild: Fire
evt.hint[88] = evt.str[36] -- Guild of Fire Magic
evt.hint[89] = evt.str[36]
evt.map[89] = function()
    evt.EnterHouse(116)
end

-- Guild: Air
evt.hint[90] = evt.str[37] -- Guild of Air Magic
evt.hint[91] = evt.str[37]
evt.map[91] = function()
    evt.EnterHouse(116)
end

-- Guild: Water
evt.hint[92] = evt.str[38] -- Guild of Water Magic
evt.hint[93] = evt.str[38]
evt.map[93] = function()
    evt.EnterHouse(116)
end

-- Guild: Earth
evt.hint[94] = evt.str[39] -- Guild of Water Magic
evt.hint[95] = evt.str[39]
evt.map[95] = function()
    evt.EnterHouse(116)
end

-- Townhall
evt.hint[96] = evt.str[40] -- Amber Townhall
evt.hint[97] = evt.str[40]
evt.map[97] = function()
    evt.EnterHouse(116)
end

-- RESIDENCES
------------------------------------------------------------------------------
evt.hint[98] = evt.str[1]   -- House
evt.hint[99] = evt.str[20]  -- Tent
evt.hint[100] = evt.str[41] -- Tower

-- LOCATION: PORT ISLAND
-- Graywood Residence
evt.HouseDoor(101, 524)

-- Nightkeep Residence
evt.HouseDoor(102, 525)

-- Colby Residence (Expert Thief)
evt.HouseDoor(103, 526)

-- Small Island after Port Island
-- Bolton Residence
evt.HouseDoor(104, 528)

-- Greene Residence (Quest: WORRYING MOM)
evt.HouseDoor(105, 529)

-- Gladwyn Residence
evt.HouseDoor(106, 527)

-- Wright's Tent (Expert Disarm)
evt.HouseDoor(107, 530)

-- Houses before Amber Town
-- Halloran Residence
evt.HouseDoor(108, 531)

-- Beck Residence
evt.HouseDoor(109, 532)

-- Amber Tower
-- Tower
evt.HouseDoor(110, 533)

-- Residental Houses of Amber Town (Entrance Area)
evt.HouseDoor(111, 534) -- first town rocky house
evt.HouseDoor(112, 535) -- small house
evt.HouseDoor(113, 536) -- castle-like house
evt.HouseDoor(114, 537) -- next house
evt.HouseDoor(115, 538) -- elf house
evt.HouseDoor(116, 539) -- barn house
evt.HouseDoor(117, 540) -- tiny house
evt.HouseDoor(118, 541) -- Г-shaped house
evt.HouseDoor(119, 542) -- 2f house
evt.HouseDoor(120, 543) -- hexagon house
evt.HouseDoor(121, 544) -- 2f evil house
evt.HouseDoor(122, 545) -- yellow house
evt.HouseDoor(123, 546) -- bridge-like house south
evt.HouseDoor(124, 547) -- bridge-like house north
evt.HouseDoor(125, 548) -- stone house
evt.HouseDoor(126, 549) -- rocky small-tower house
evt.HouseDoor(127, 550) -- duplex-north 549
evt.HouseDoor(128, 551) -- duplex-south
evt.HouseDoor(129, 552) -- rocky 2th f rich house
evt.HouseDoor(130, 553) -- elf rich house
evt.HouseDoor(131, 554) -- rocky barn-like house
evt.HouseDoor(132, 555) -- L-shaped house with doors at corner
evt.HouseDoor(133, 556) -- evil house with doors at corner
evt.HouseDoor(134, 557) -- small hexagonal house
evt.HouseDoor(135, 558) -- blue house
evt.HouseDoor(136, 559) -- 2f rocky-red house near guilds
evt.HouseDoor(137, 560) -- 2f evil house between tent and body guild
evt.HouseDoor(138, 561) -- tent in guilds area
evt.HouseDoor(139, 562) -- red house near spirit guild
evt.HouseDoor(140, 563) -- poor house near city hall
evt.HouseDoor(141, 564) -- arc-house, appartment
evt.HouseDoor(142, 565) -- rich house: tower
evt.HouseDoor(143, 566) -- rich house: 2f villa
evt.HouseDoor(144, 567) -- rich house: white castle
evt.HouseDoor(145, 568) -- rich house: black castle
evt.HouseDoor(146, 569) -- rich house: duplex east
evt.HouseDoor(147, 570) -- rich house: duplex mid
evt.HouseDoor(148, 571) -- rich house: duplex west
evt.HouseDoor(149, 572) -- Boatman's House

-- Swamp Island
evt.HouseDoor(150, 573) -- Knight Camp: North Tent
evt.HouseDoor(151, 574) -- Knight Camp: East Tent
evt.HouseDoor(152, 575) -- Knight Camp: West Tent
evt.HouseDoor(153, 576) -- Lighthouse
evt.HouseDoor(154, 577) -- Big House at East
evt.HouseDoor(155, 578) -- Witch Hut
------------------------------------------------------------------------------
