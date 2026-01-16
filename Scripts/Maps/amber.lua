--[[
Map: Amber Island
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
    [15] = "Enter the Oak Hill Cottage",
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
    [42] = "Residence",
    [43] = "Apple Tree",
    [44] = "Yuck! Apples are too sour to be consumed...",
    [45] = "+5 AC (Temporary)",
    [46] = "+2 Accuracy (Permanent)",
    [47] = "+ 10 Might (Temporary)",
    [48] = "Maybe that wasn't such a good idea.",
    [49] = "You probably shouldn't do that.",
    [50] = "+ 10 hit and spell points",
    [51] = "+5 Elemental Resistance (Temporary)",
    [52] = "Skull",
    [53] = "The Door is Locked"
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

function evt.ShopDoor(evtId, houseId)
	evt.house[evtId] = houseId
	evt.map[evtId] = function()

        if IsWarrior() and vars.MiscAmberIsland.ClosedShops == true then
            evt.FaceAnimation{Player = "Current", Animation = 18}
            evt.StatusText(53) -- "The Door is Locked"

            -- Notify about wtf is happening in 10sec
            if evt.Cmp("MapVar41", 1) == false then
                evt.Add("MapVar41", 1)
                Timer(function()
                    evt.SpeakNPC(541)
                end, 10*const.Minute, false)
                return
            end

            return
        end
		evt.EnterHouse(houseId)
	end
end

-- EVENTS
------------------------------------------------------------------------------
function events.MonsterKilled(mon, monIndex, defaultHandler)
    
    if mon.NPC_ID == 498 then
        vars.QuestsAmberIsland.QVarRevenge = 3 -- Michael Cassio is Killed
    end
end

function events.AfterLoadMap(WasInGame)

    --MakeHostile(265,267) -- Lizards
    evt.SetNPCGroupNews(36, 40)
    evt.SetNPCGroupNews(38, 42)

    local X = IsWarrior() and -3935 or -3676
    local Y = IsWarrior() and 4758  or 6053
    local Z = IsWarrior() and 704   or 456

    -- Amber Map: Anti-fall through-roof bug workaround
    if vars.MiscAmberIsland.LuckyCoinSpawn == true then
        for _, obj in Map.Objects do
            if obj.Item.Number == 782 then
                XYZ(obj, X, Y, Z, 0)
            end
        end
    else
        vars.MiscAmberIsland.LuckyCoinSpawn = true
        SummonItem(782, X, Y, Z, 0)
    end

    -- Just-in-case fix for Otho Robeson (transfering from prison)
    if vars.QuestsAmberIsland.QVarRevenge == 6 then
        evt.MoveNPC{NPC = 496, HouseId = 568}
        vars.QuestsAmberIsland.QVarRevenge = 7
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

-- APPLES
------------------------------------------------------------------------------
for i = 200, 255, 1 do
	evt.hint[i] = evt.str[43] 
    evt.map[i] = function()
        evt.StatusText(44)
        --if not evt.CheckSeason(3) then
            --if not evt.CheckSeason(2) then
                -- local checkStr = "MapVar50"..tostring(50+(i-200))
                -- if not evt.Cmp(checkStr, 1) then
                --     evt.Add("Inventory", 630)         -- "Red Apple"
                --     evt.Set(checkStr, 1)
                --     evt.StatusText(61)         -- "You received an apple"
                --     evt.SetSprite{SpriteId = 200+i, Visible = 1, Name = "tree37"}
                -- end
            --end
        --end
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

    if evt.Cmp("PlayerBits", 3) then
		evt.StatusText(4)         -- "Refreshing!"
		return
	end

    evt.Add("ArmorClassBonus", 5)
    evt.Set("PlayerBits", 3)
	evt.StatusText(45)         -- "+5 AC (Temporary)"
    AddAutonote'amberWell1'
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 3)
end, const.Day)

-- Well: Before Amber Town Bridge
evt.map[23] = function()

    if evt.Cmp("MapVar2", 5) then
		evt.StatusText(4)         -- "Refreshing!"
		return
	end

    evt.Add("MapVar2", 1)
    evt.Add("BaseAccuracy", 2)
	evt.StatusText(46)         -- "+2 Accuracy (Permanent)"
end

-- Well: Inside Amber Town
evt.map[24] = function()

    if evt.Cmp("PlayerBits", 4) then
		evt.StatusText(4)         -- "Refreshing!"
		return
	end

    evt.Add("MightBonus", 10)
    evt.Set("PlayerBits", 4)
	evt.StatusText(47)         -- "+ 10 Might (Temporary)"
    AddAutonote'amberWell2'
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 4)
end, const.Day)

-- Well: Swamp Island
evt.map[25] = function()

    if evt.Cmp("PlayerBits", 5) then
		evt.StatusText(4)         -- "Refreshing!"
		return
	end

    evt.Add("FireResBonus", 5)
    evt.Add("AirResBonus", 5)
    evt.Add("WaterResBonus", 5)
    evt.Add("EarthResBonus", 5)
    evt.Set("PlayerBits", 5)
	evt.StatusText(51)         -- "+5 Elemental Resistance (Temporary)"
    AddAutonote'amberWell3'
end

RefillTimer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 5)
end, const.Day)

-- FOUNTAINS
------------------------------------------------------------------------------
evt.hint[26] = evt.str[3] -- Fountain
evt.hint[27] = evt.str[5] -- Drink from the Fountain
evt.hint[28] = evt.str[5]

-- Fountain: Port Island
evt.map[27] = function()
    evt.Add("HP", 10)
    evt.Add("SP", 10)
    evt.StatusText(50) -- "+ 10 Hit and Spell points"
    AddAutonote'amberFountain1'
end

-- Fountain: Amber Town
evt.map[28] = function()
    
    if evt.Cmp("MapVar1", 1) == false and not IsWarrior() then
        evt.Add("Gold", 500)
        evt.Set("MapVar1", 1)
    else
        evt.StatusText(4)
    end
end

-- DUNGEONS
------------------------------------------------------------------------------
-- Dungeon: Oak Hill Cottage
evt.hint[29] = evt.str[11]
evt.hint[30] = evt.str[15]
evt.map[30] = function()
    evt.MoveToMap(-41,369,0,2,1,1,193,1,"oakhome.blv")
end

-- Dungeon: Archmage's Residence
evt.hint[31] = evt.str[12]
evt.hint[32] = evt.str[16]
evt.map[32] = function()
    evt.MoveToMap{X = -4, Y = -2, Z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 195, Icon = 1, Name = "archmageEX.blv"}
end

-- Dungeon: Apple Cave
evt.hint[34] = evt.str[17] -- Apple Cave
evt.hint[33] = evt.str[13] -- Enter the Cave
evt.map[34] = function()
    for _, mon in Map.Monsters do
        if mon.NPC_ID  == 517 then
            if mon.Hostile == false and mon.HP > 0 then
                evt.SpeakNPC(521)  
                return
            end
        end
    end
    
    evt.MoveToMap(-148,3,0,2044,1,1,194,1,"applecave.blv")
end

-- Dungeon: Abandoned Mines
evt.hint[35] = evt.str[14] -- Abandoned Mines
evt.hint[36] = evt.str[18] -- Enter the Abandoned Mines
evt.map[36] = function()
    evt.MoveToMap{X = 190, Y = 140, Z = 33, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 196, Icon = 1, Name = "abmines.blv"}
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
    if evt.All.Cmp("Inventory",796) then
	evt.MoveToMap{X = 17708 ,Y = -20470, Z = 1 , Direction = 715, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "amber-east.odm"}
	end
end

-- Altar: Swamp Island
evt.hint[41] = evt.str[10] -- Altar
evt.hint[42] = evt.str[21]
evt.map[42] = function()
    if evt.All.Cmp("Inventory", 785) and vars.QuestsAmberIsland.QVarRitual == false then
        vars.QuestsAmberIsland.QVarRitual = true
        evt.Subtract("Inventory", 785)
        evt.PlaySound(14050,Party.X,Party.Y)
        evt.All.Add("Exp",0)
        local monster = SummonMonster(22, 19427, -1525, 897, true)
        monster.Level               = 5
        monster.FullHitPoints       = 360
        monster.HP                  = 360
        monster.ArmorClass          = 10
        monster.Attack1.DamageAdd   = 4
        monster.Attack1.Missile     = 0
        monster.Special             = 0
        monster.Spell               = 0
    end
end
------------------------------------------------------------------------------
-- SHIPS
evt.hint[60] = evt.str[22]
evt.hint[61] = evt.str[22] -- Black Betty
evt.map[61] = function()
    
    evt.EnterHouse(579)
end

evt.hint[62] = evt.str[23]
evt.hint[63] = evt.str[23] -- 
evt.map[63] = function()
    
    evt.EnterHouse(580)
end


-- SHOPS
------------------------------------------------------------------------------
-- Tavern: Powder Keg Inn
evt.HouseDoor(65, 120)

-- Training: Amber Training Grounds
evt.HouseDoor(67, 91)

-- Temple: Saint Nourville Cathedral
evt.map[69] = function()

    if vars.MiscGlobal.OnDeathLocation == 0 then
        vars.MiscGlobal.OnDeathLocation = 1
    end
    evt.EnterHouse(246)
end

-- Bank: Amber Bank
evt.HouseDoor(71, 251)

-- Tavern: Crusty Eagle Inn
evt.HouseDoor(73, 117)

-- Smith: Razorsharp
evt.ShopDoor(77, 3)

-- Armorer: Steel Bucket
evt.ShopDoor(75, 17)

-- Magician: Odds and Ends
evt.ShopDoor(81, 41)

-- Alchemist: Potions of Payne
evt.ShopDoor(79, 53)

-- Guild: Fire
evt.HouseDoor(89, 140)

-- Guild: Air
evt.HouseDoor(91, 144)

-- Guild: Water
evt.HouseDoor(93, 148)

-- Guild: Earth
evt.HouseDoor(95, 152)

-- Guild: Spirit
evt.HouseDoor(83, 156)   

-- Guild: Mind
evt.HouseDoor(87, 160)

-- Guild: Body
evt.HouseDoor(85, 164)

-- Town Hall: Amber Town
evt.HouseDoor(97, 248)

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

-- Exit: Amber Island to East Amber Island
evt.map[160] = function()
    evt.MoveToMap{X = -22255, Y = 9476, Z = 79, Direction = 2048, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "amber-east.odm"}
end

-- Bunny Burrow
evt.HouseDoor(161, 606)

-- Skull NE corner
evt.hint[162] = evt.str[52]
evt.map[162] = function()
    if evt.Cmp("MapVar39", 1) == false then
        evt.Set("MapVar39", 1)
        evt.Add("Inventory", 397)
    end
end

-- Body Guild Window
evt.map[163] = function()
    if evt.Cmp("MapVar38", 1) == false then
        evt.Set("MapVar38", 1)
        evt.Add("Inventory", 385)
    end
end

-- Sir Henry
evt.map[164] = function()
    if Game and Game.Debug == false and vars.MiscGlobal.FirstTimePlaying == 0 then
        vars.MiscGlobal.FirstTimePlaying = 1
        evt.SpeakNPC(449)
    end
end

-- North town basin
evt.map[165] = function()
    evt.StatusText(4) -- Refreshing
end

-- Goblin Ambush
evt.map[166] = function()

    if not IsWarrior() or evt.Cmp("MapVar40", 1) == true then
        return
    end

    evt.Set("MapVar40", 1)
    GoblinArray = {
        
        {X = -17828,  Y = -39,  Z = 0},
        {X = -17571,  Y = -44,  Z = 0},
        {X = -17294,  Y = -87, Z = 0},
        {X = -16890,  Y = -304, Z = 0},
        {X = -17198,  Y = -3289, Z = 0},
        {X = -17416,  Y = -3737, Z = 0},
        {X = -17887,  Y = -3952, Z = 0},
        {X = -18353,  Y = -3591, Z = 0},
    }

    for i, goblin in ipairs(GoblinArray) do
        local mon = SummonMonster(73, goblin.X , goblin.Y, goblin.Z, true)
    end

    evt.SetFacetBit(123,const.FacetBits.Untouchable,true)

    evt.SpeakNPC(536) -- Goblin Raider
end

-- Tower Cellar mini-dungeon
evt.hint[167] = evt.str[11]
evt.hint[168] = evt.str[15]
evt.map[168] = function()
    
    evt.MoveToMap(-41,369,0,2,1,1,193,1,"towercellar.blv")
end

-- Swamp Tree Stump (south-eastern part of archmage residence island, near small pool)
evt.map[169] = function()

    if not IsWarrior() then return end

    if evt.Cmp("MapVar42", 1) == false then
        evt.Set("MapVar42", 1)
        evt.Add("Inventory", 781)
        evt.FaceAnimation{Player = "Current", Animation = 14}
        evt.Add("Experience", 0)
    end
end

------------------------------------------------------------------------------
