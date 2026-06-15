--[[
Map:    Castle Amber
Author: Henrik Chukhran, 2022 - 2026
]]

Game.MapEvtLines.Count = 0

------------------------------------------------------------------------------

-- FACE GROUPS
-- ID           DESCRIPTION
-- 1            Teleporation pedestal Gem
-- 2            Invisible teleporter cube (on teleportation platform)
-- 10           (Warrior) Traps (floors)

-- VARIABLES
-- ID           DESCRIPTION
-- MapVar0      Teleportation Pedestal
-- MapVar1      Secret loot (wc)
-- MapVar30     Trapped chest golem ambush

-- MONSTERS
-- GROUP 37:    Prisoned peasants
-- BOSS 1:      Troll Chief, Throne Room (has Troll key: #664 )
-- BOSS 2:      Archmage Magnus

-- ***************************************************************************

-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           10              Level start, wide lever chamber
-- 01           11              Level start, secret ambush room
-- 02           12              Level start, small bedroom
-- 03           13              Level start, small bedroom, Cabinet
-- 04           14              Throne Room, eastern chest
-- 05           15              Throne Room, western chest
-- 06           16              Tower Bedroom
-- 07           17              Tower Bedroom secret room
-- 08           18              Wine storage room (Where wall crack is)
-- 09           19              Wine storage room (Where wall crack is), Cabinet
-- 10           20              Burried corridor (where Skeletons are)
-- 11           21              Barracks: Western chest
-- 12           22              Barracks: Eastern chest
-- 13           23              Barracks: Western cabient
-- 14           24              Barracks: Eastern cabinet
-- 15           25              Kitchen: Sink cabinet
-- 16           26              Kitchen: cabinet
-- 17           27              Dungeon
-- 18           28              Trapped tunnel chamber
-- 19           29              Archmage room, Cabinet

-- ***************************************************************************

-- DOORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 02           00              Start loc: secret ambush room
-- 07           00              Start loc: grated door
-- 10-11        55              Start loc: top basement double-door
-- 12-13        08              Start loc: bottom basement double-door
-- 15-16        31              Start loc: bedroom double-door
-- 17-18        32              Start loc: small mess hall double-door
-- 19-20        33              Wine storage room: double-door
-- 21-22        34              Barracks: double-door
-- 23-24        35              Kitchen: double-door
-- 25-26        36              Dungeon: double-door
-- 27-28        37              Library: doubled-door
-- 30           39              Wine storage room: secret wall
-- 31           00              Dungeon: grated door
-- 33           00              Basement: grated door
-- 42           49              Apple tree chamber: secret door
-- 44           00              Trapped chest room: grated door

-- ELEVATORS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 01           00              Start loc: elevator
-- 38           00              Tower bedroom
-- 41           00              Basement to tunnels

-- LEVERS / SWITCHES
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 06           06              Start loc: Wide lever chamber
-- 32           40              Dungeon
-- 34           41              Basement wide lever
-- 36           43              Tower bedroom: bottom elevator shaft
-- 37           44              Tower bedroom: top elevator shaft
-- 43           50              Trapped chest area: wide lever
-- 46           52              Archmage room: mist machine (!)

-- BUTTONS
-- DOOR ID      TRIGGER ID      DESCRIPTION
-- 04           03              Start loc: elevator top lever
-- 05           04              Start loc: elevator bottom lever
-- 09           07              Start loc: bedroom, table secret button
-- 29           38              Wine storage room tunnel: broken elevator

-- ***************************************************************************

-- MISC TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Safe Room    02              Start location
-- Pedestal     42              Lab
-- Keyhole      51              Start loc: basement double-door
-- Hole         56              WC hole (loot)
-- Bookcase     57              Lounge Room Bookcase
-- Bookcase     58              Royal Chambers Bookcase
-- Bookcase     59              Library Bookcases
-- Bookcase     60              Library Bookcases
-- Bookcase     61              Library Bookcases
-- Bookcase     62              Library Bookcases
-- Bookcase     63              Library Bookcases
-- Bookcase     64              Library Bookcases
-- Bookcase     65              Library Bookcases
-- Bookcase     66              Library Bookcases
-- Bookcase     67              Library Bookcases
-- Bookcase     68              Mage Lab Bookcase
-- Bookcase     69              Mage Chamber Bookcases
-- Bookcase     70              Mage Chamber Bookcases
-- Wine Rack    71              Storage Room Wine Racks
-- Wine Rack    72              Storage Room Wine Racks
-- Wine Rack    73              Basement Wineracks
-- Wine Rack    74              Basement Wineracks
-- Gold Vein    75 - 83         Tunnels
-- Fountain     84              Upper Corridor, Entrance
-- Fountain     85              Upper Corridor
-- Bookcase     86              Mage Chamber Bookcases
-- Bookcase     87              Mage Chamber Bookcases
-- Exit         88              Start location doors
-- Fountain     103             Pedestal Chamber
-- Fountain     105             Stairs to basement
-- Fountain     107             Teleport Room
-- Fountain     109             Archmage Room
-- Fountain     111             Basement tunnels entrace
-- Fountain     113             Apple Tree Chamber
-- Fountain     115             Basement Tunnels
-- Fountain     117             Basement Tunnels, South Passage

-- TRAPS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Sparks       130             Entrance, stairs
-- Sparks       131             Elevator to master bedroom
-- FireBolt     132             Entrance to throne room
-- AcidBurst    133             Entrance to mess hall
-- Fireball     134             Entrance to mess hall
-- IceBlast     135             Teleportation room
-- Sparks       136             Entrance to the lower tunnels ("crossroads")

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local TrollKeyItemID        = 664
local TeleportGemItemID     = 781
local ArchmageNPCID         = 448

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterLoadMap(WasInGame)

    MakeHostile(79,81) -- Golems
    evt.SetNPCGroupNews(37, 41)

    if not IsWarrior() then
        -- Remove traps in "Adventurer"
        evt.SetFacetBit(10,const.FacetBits.IsSecret, false)
    end
end

function events.LoadMap()

    -- Set gold vein textures to depleted ones after save/load
    for i = 0, 8, 1 do
        local mapVarStr = "MapVar"..tostring(21 + i)
        if evt.Cmp(mapVarStr, 1) then
            evt.SetTexture(75 + i, "Cwb1")
        end
    end

    -- Restore teleportation pedetal
    if evt.Cmp("MapVar0", 1) then

        evt.SetFacetBit(1,const.FacetBits.Invisible,false)
        evt.SetFacetBit(2,const.FacetBits.Untouchable,false)
        evt.SetLight(1,true)
    end
end

function events.CanExitNPC(t)

    if t.NPC == ArchmageNPCID then

        if vars.QuestsCore.ArchmageState == 1 then
            t.Allow = false
        end
        return
    end

    t.Allow = true
end

function events.AfterMonsterAttacked(t, attacker)

    if t == nil then return end
    if attacker == nil then return end

    if vars.QuestsCore.ArchmageState ~= 0 then
        return
    end

    if t.Attacker.Player ~= nil then
        if t.Monster.NPC_ID == ArchmageNPCID then

            if t.Monster.HP < (t.Monster.FullHP * 0.1) then
                vars.QuestsCore.ArchmageState = 1 -- archmage defeated
                t.Monster.HP = t.Monster.FullHP
                evt.SpeakNPC(ArchmageNPCID)
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)

    if mon.NPC_ID == ArchmageNPCID then
        vars.QuestsCore.ArchmageState = 3
    end
end

-- ***************************************************************************

-- Starting location door: Safe Room
evt.hint[2]        = ModTxt.CSafeRoom
evt.map[2]         = function()

    evt.EnterHouse(581)
end

------------------------------------------------------------------------------
-- BUTTONS
------------------------------------------------------------------------------

-- Start loc elevator top lever
evt.hint[3]        = ModTxt.CLever
evt.map[3]         = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 4, State = 2}
end

-- Start loc elevator bottom lever
evt.hint[4]        = ModTxt.CLever
evt.map[4]         = function()
    evt.SetDoorState{Id = 1, State = 2}
    evt.SetDoorState{Id = 5, State = 2}
end

-- Start loc elevator
evt.hint[5]        = ModTxt.CLift
evt.map[5]         = function()
    evt.SetDoorState{Id = 1, State = 0}
end

-- Start loc wall switch (opens start loc grate + secret ambush room)
evt.hint[6]        = ModTxt.CLever
evt.map[6]         = function()
    evt.SetDoorState{Id = 2, State = 0}
    evt.SetDoorState{Id = 6, State = 1}
    evt.SetDoorState{Id = 7, State = 0}
end

-- Table button
evt.hint[7]        = ModTxt.CButton
evt.map[7]         = function()
    evt.SetDoorState{Id = 9, State = 0}
    evt.SetDoorState{Id = 45, State = 1}
end

-- Basement Bottom Door 
evt.hint[8]        = ModTxt.CDoubleDoor
evt.map[8]         = function()
    evt.SetDoorState{Id = 12, State = 0}
    evt.SetDoorState{Id = 13, State = 0}
end

-- Basement Top Door
evt.hint[9]        = ModTxt.CDoor
evt.map[9]         = function()
    Game.ShowStatusText(ModTxt.CNothing)
end


-- Chests
for i = 0, 19, 1 do
    local hintStr   = ModTxt.CChest
    if Game.Debug then
        hintStr     = hintStr .. " #"..tostring(i)
    end
    evt.hint[10 + i]        = hintStr
    evt.map[10 + i]         = function() 
        evt.OpenChest(i)

        -- Exception
        if i == 18 then

            if not evt.Cmp("MapVar30", 1) then
                evt.Set("MapVar30", 1)
                SummonMonster(80, 4939, -5364, -1675, true)
                SummonMonster(80, 4929, -5364, -1675, true)
                SummonMonster(80, 4919, -5364, -1675, true)
                SummonMonster(80, 4939, -5354, -1675, true)

                SummonMonster(80, 5831, -3066, -1410, true)
                SummonMonster(80, 5821, -3066, -1410, true)
                SummonMonster(80, 5811, -3066, -1410, true)

                SummonMonster(81, 4614, -1046, -1216, true)
                
                SummonMonster(80, 3668, -498, -640, true)
                SummonMonster(80, 3658, -498, -640, true)

                SummonMonster(81, 5482, 1451, -162, true)

                SummonMonster(80, 5753, 2957, 174, true)
                SummonMonster(80, 5743, 2957, 174, true)
                SummonMonster(80, 5733, 2957, 174, true)

                for _, mon in Map.Monsters do
                    if mon.Id >= 79 and mon.Id <= 81 then
                        mon.Hostile = true
                    end
                end
            end
        end
    end
end

-- Bedroom Door
evt.hint[31]        = ModTxt.CDoor
evt.map[31]         = function()
    evt.SetDoorState{Id = 15, State = 2}
    evt.SetDoorState{Id = 16, State = 2}
end

-- Lounge Room
evt.hint[32]        = ModTxt.CDoor
evt.map[32]         = function()
    evt.SetDoorState{Id = 17, State = 2}
    evt.SetDoorState{Id = 18, State = 2}
end

-- Storage Room Door
evt.hint[33]        = ModTxt.CDoor
evt.map[33]         = function()
    evt.SetDoorState{Id = 19, State = 2}
    evt.SetDoorState{Id = 20, State = 2}
end

-- Barracks door
evt.hint[34]        = ModTxt.CDoor
evt.map[34]         = function()
    evt.SetDoorState{Id = 21, State = 2}
    evt.SetDoorState{Id = 22, State = 2}
end

-- Kitchen door
evt.hint[35]        = ModTxt.CDoor
evt.map[35]         = function()
    evt.SetDoorState{Id = 23, State = 2}
    evt.SetDoorState{Id = 24, State = 2}
end

-- Dungeon door
evt.hint[36]        = ModTxt.CDoor
evt.map[36]         = function()
    evt.SetDoorState{Id = 25, State = 2}
    evt.SetDoorState{Id = 26, State = 2}
end

-- Library door
evt.hint[37]        = ModTxt.CDoor
evt.map[37]         = function()
    evt.SetDoorState{Id = 27, State = 2}
    evt.SetDoorState{Id = 28, State = 2}
end

-- Cave: Broken Elevator Button
evt.hint[38]        = ModTxt.CButton
evt.map[38]         = function()
    evt.SetDoorState{Id = 29, State = 2}
end

-- Storage room: secret wall
evt.hint[39]        = ModTxt.CNull
evt.map[39]         = function()
    evt.SetDoorState{Id = 30, State = 1}
end

-- Dungeon: Jail switch
evt.hint[40]        = ModTxt.CLever
evt.map[40]         = function()
    evt.SetDoorState{Id = 31, State = 2}
    evt.SetDoorState{Id = 32, State = 2}
end

-- Basement: Wall Switch
evt.hint[41]        = ModTxt.CLever
evt.map[41]         = function()

    evt.SetDoorState{Id = 33, State = 2}
    evt.SetDoorState{Id = 34, State = 2}
end

-- Mage Lab: Pedestal
evt.hint[42]        = ModTxt.CTeleport
evt.map[42]         = function()

    if not evt.Cmp("MapVar0", 1) then

        if not evt.All.Cmp("Inventory", TeleportGemItemID) then
            evt.FaceAnimation{Player = "All", Animation = 43}
            Game.ShowStatusText(ModTxt.CNeedTeleportItem)
            return
        end
        evt.Sub("Inventory", TeleportGemItemID)
        evt.Set("MapVar0", 1)
        evt.SetFacetBit(1,const.FacetBits.Invisible,false)
        evt.SetFacetBit(2,const.FacetBits.Untouchable,false)
        evt.PlaySound(14050,Party.X,Party.Y)
        evt.SetLight(1,true)
        evt.FaceAnimation{Player = "All", Animation = 93}
        Game.ShowStatusText(ModTxt.CPortalActivated)
    end
end

-- Royal chambers: elevator bottom switch
evt.hint[43]        = ModTxt.CLever
evt.map[43]         = function()
    evt.SetDoorState{Id = 36, State = 2}
    evt.SetDoorState{Id = 38, State = 1} -- elevator
end

-- Royal chambers: elevator top switch
evt.hint[44]        = ModTxt.CLever
evt.map[44]         = function()
    evt.SetDoorState{Id = 37, State = 2}
    evt.SetDoorState{Id = 38, State = 0} -- elevator
end

-- Royal chambers: elevator
evt.hint[45]        = ModTxt.CLift
evt.map[45]         = function()
    evt.SetDoorState{Id = 38, State = 0}
end

-- Basement: elevator bottom switch
evt.hint[46]        = ModTxt.CLever
evt.map[46]         = function()
    evt.SetDoorState{Id = 39, State = 2}
    evt.SetDoorState{Id = 41, State = 1} -- elevator
end

-- Basement: elevator top switch
evt.hint[47]        = ModTxt.CLever
evt.map[47]         = function()
    evt.SetDoorState{Id = 40, State = 2}
    evt.SetDoorState{Id = 41, State = 0} -- elevator
end

-- Basement: elevator
evt.hint[48]        = ModTxt.CLift
evt.map[48]         = function()
    evt.SetDoorState{Id = 41, State = 0}
end

-- Tree Chamber: secret door
evt.hint[49]        = ModTxt.CNull
evt.map[49]         = function()
    evt.SetDoorState{Id = 42, State = 1}
end

-- Tunnels: wall switch
evt.hint[50]        = ModTxt.CLever
evt.map[50]         = function()
    evt.SetDoorState{Id = 43, State = 2}
    evt.SetDoorState{Id = 44, State = 2}
end

-- Start loc: keyhole
evt.hint[51]        = ModTxt.CKeyhole
evt.map[51]         = function()

    if not evt.Cmp("MapVar21", 1) then
        if evt.Cmp("Inventory", TrollKeyItemID) then
            evt.SetDoorState{Id = 10, State = 0}
            evt.SetDoorState{Id = 11, State = 0}
            evt.Sub("Inventory", TrollKeyItemID)
            evt.Set("MapVar21", 1)
        else
            evt.FaceAnimation{Player = "Current", Animation = 18}
            Game.ShowStatusText(ModTxt.CLockedDoor)
        end
    end
end

-- Mage Chambers: Device Switch
evt.hint[52]        = ModTxt.CLever
evt.map[52]         = function()
    --if not evt.Cmp("QBits",7) then
    if not vars.QuestsAmberIsland.QVar1 then
        --evt.Set("QBits",7)
        vars.QuestsAmberIsland.QVar1 = true
        evt.SetDoorState{Id = 46, State = 1}
        evt.ForPlayer("All")
        ShowQuestEffect(false,"Add")
        --evt.Add("QBits", 245)         -- "Congratulations"
        --evt.Subtract("QBits", 245)    -- "Congratulations"

        SummonMonster(80, 6266, 2279, -32, true)
        SummonMonster(80, 6266, 2259, -32, true)
        SummonMonster(80, 6266, 2249, -32, true)

        SummonMonster(81, 5482, 1451, -162, true)

        SummonMonster(81, 3668, -498, -640, true)
        SummonMonster(81, 3658, -498, -640, true)
        SummonMonster(81, 3648, -498, -640, true)
        --evt.FaceAnimation{Player = "Current", Animation = 47}

        for _, mon in Map.Monsters do
            if mon.Id >= 79 and mon.Id <= 81 then
                mon.Hostile = true
            end
        end
    end
end

-- Mage Lab: Teleport to Mage Chambers
evt.hint[53]        = ModTxt.CNull
evt.map[53]         = function()
    
        if evt.Cmp("MapVar0", 1) then
            evt.MoveToMap{
                X           = -2693,
                Y           = 1179,
                Z           = 1,
                Direction   = 1530,
                LookAngle   = 0,
                SpeedZ      = 0,
                HouseId     = 0,
                Icon        = 0,
                Name        = "0"
            }
        end
end

-- Mage Chamber: Teleport to Mage Lab
evt.hint[54]        = ModTxt.CNull
evt.map[54]         = function()
        
        evt.MoveToMap{
            X           = 5756,
            Y           = 3018,
            Z           = 97,
            Direction   = 1530,
            LookAngle   = 0,
            SpeedZ      = 0,
            HouseId     = 0,
            Icon        = 0,
            Name        = "0"
        }
end

-- Locked door hint at start loc
evt.hint[55]        = ModTxt.CDoor
evt.map[55]         = function()
    if Map.Doors[10].State == 2 then
        evt.FaceAnimation{Player = "Current", Animation = 18}
        Game.ShowStatusText(ModTxt.CLockedDoor)
    end
end

------------------------------------------------------------------------------
-- BOOKCASES
------------------------------------------------------------------------------

-- Lounge Room Bookcase
evt.hint[57]        = ModTxt.CBookcase
evt.map[57]         = function()
    if not evt.Cmp("MapVar2", 1) then
        evt.Set("MapVar2", 1)
        evt.Add("Inventory", 385)    -- "Hour of Power" scroll
    end
end

-- Royal Chambers Bookcase
evt.hint[58]        = ModTxt.CBookcase
evt.map[58]         = function()
    if not evt.Cmp("MapVar3", 1) then
        evt.Set("MapVar3", 1)
        evt.Add("Inventory", 387)    -- "Divine Intervention" scroll
    end
end

-- Library Bookcases
evt.hint[59]        = ModTxt.CBookcase
evt.map[59]         = function()
    if not evt.Cmp("MapVar4", 1) then
        evt.Set("MapVar4", 1)
        evt.Add("Inventory", 315)    -- "Jump" scroll
    end
end

evt.hint[60]        = ModTxt.CBookcase
evt.map[60]         = function()
    if not evt.Cmp("MapVar6", 1) then
        evt.Set("MapVar6", 1)
        evt.Add("Inventory", 315)    -- "Jump" scroll
    end
end

evt.hint[61]        = ModTxt.CBookcase
evt.map[61]         = function()
    if not evt.Cmp("MapVar7", 1) then
        evt.Set("MapVar7", 1)
        evt.Add("Inventory", 315)    -- "Jump scroll
    end
end

evt.hint[62]        = ModTxt.CBookcase
evt.map[62]         = function()
    if not evt.Cmp("MapVar8", 1) then
        evt.Set("MapVar8", 1)
        evt.Add("Inventory", 375)    -- "Power Cure" scroll
    end
end

evt.hint[63]        = ModTxt.CBookcase
evt.map[63]         = function()
    if not evt.Cmp("MapVar9", 1) then
        evt.Set("MapVar9", 1)
        evt.Add("Inventory", 384)    -- "Day Of Protection" scroll
    end
end

evt.hint[64]        = ModTxt.CBookcase
evt.map[64]         = function()
    if not evt.Cmp("MapVar10", 1) then
        evt.Set("MapVar10", 1)
        evt.Add("Inventory", 398)    -- "Soul Drinker" scroll
    end
end

evt.hint[65]        = ModTxt.CBookcase
evt.map[65]         = function()
    if not evt.Cmp("MapVar11", 1) then
        evt.Set("MapVar11", 1)
        evt.Add("Inventory", 307)    -- "Immolation" scroll
    end
end

evt.hint[66]        = ModTxt.CBookcase
evt.map[66]         = function()
    if not evt.Cmp("MapVar12", 1) then
        evt.Set("MapVar12", 1)
        evt.Add("Inventory", 316)    -- "Shield" scroll
    end
end

evt.hint[67]        = ModTxt.CBookcase
evt.map[67]         = function()
    if not evt.Cmp("MapVar13", 1) then
        evt.Set("MapVar13", 1)
        evt.Add("Inventory", 329)    -- "Enchant Item" scroll
    end
end

-- Mage Lab Bookcase
evt.hint[68]        = ModTxt.CBookcase
evt.map[68]         = function()
    if not evt.Cmp("MapVar14", 1) then
        evt.Set("MapVar14", 1)
        evt.Add("Inventory", 387)    -- "Divine Intervention" scroll
    end
end

-- Mage Chamber Bookcases
evt.hint[69]        = ModTxt.CBookcase
evt.map[69]         = function()
    if not evt.Cmp("MapVar15", 1) then
        evt.Set("MapVar15", 1)
        evt.Add("Inventory", 387)    -- "Divine Intervention" scroll
    end
end

evt.hint[70]        = ModTxt.CBookcase
evt.map[70]         = function()
    if not evt.Cmp("MapVar16", 1) then
        evt.Set("MapVar16", 1)
        evt.Add("Inventory", 352)    -- "Raise Dead" scroll
    end
end

evt.hint[86]        = ModTxt.CBookcase
evt.map[86]         = function()
    if not evt.Cmp("MapVar31", 1) then
        evt.Set("MapVar31", 1)
        evt.Add("Inventory", 352)    -- "Raise Dead" scroll
    end
end

evt.hint[87]        = ModTxt.CBookcase
evt.map[87]         = function()
    if not evt.Cmp("MapVar32", 1) then
        evt.Set("MapVar32", 1)
        evt.Add("Inventory", 352)    -- "Raise Dead" scroll
    end
end

-- Storage Room Wine Racks
evt.hint[71]        = ModTxt.CWineRack
evt.map[71]         = function()
    if not evt.Cmp("MapVar17", 1) then
        evt.Set("MapVar17", 1)
        evt.Add("Inventory", 267)    -- "Pure Endurance" potion
    end
end

evt.hint[72]        = ModTxt.CWineRack
evt.map[72]         = function()
    if not evt.Cmp("MapVar18", 1) then
        evt.Set("MapVar18", 1)
        evt.Add("Inventory", 267)    -- "Pure Endurance" potion
    end
end

-- Basement Wineracks
evt.hint[73]        = ModTxt.CWineRack
evt.map[73]         = function()
    if not evt.Cmp("MapVar19", 1) then
        evt.Set("MapVar19", 1)
        evt.Add("Inventory", 264)    -- "Pure Luck" potion
    end
end

evt.hint[74]        = ModTxt.CWineRack
evt.map[74]         = function()
    if not evt.Cmp("MapVar20", 1) then
        evt.Set("MapVar20", 1)
        evt.Add("Inventory", 264)    -- "Pure Luck" potion
    end
end

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Secret loot (wc)
evt.hint[56]        = ModTxt.CHole
evt.map[56]         = function()
    if not evt.Cmp("MapVar1", 1) then
        evt.Set("MapVar1", 1)
        evt.Add("Gold", 4000)
    end
end

-- Gold Vein
for i = 0, 8, 1 do
    evt.hint[75 + i]        = ModTxt.CGoldVein
    evt.map[75 + i]         = function()
        local gold
        local mapVarStr = "MapVar"..tostring(21 + i)
        if evt.Cmp(mapVarStr, 1) then
            return
        end
        gold = math.random(69,420)
        AddGoldExp(gold,0)
        evt.Set(mapVarStr, 1)
        evt.SetTexture(75 + i, "Cwb1")
    end
end

-- Fountains

-- Upper Corridor, Entrance
Fountain(84, 100,     "amberCastle1")

-- Upper Corridor
Fountain(85, 101,     "amberCastle2")

-- Pedestal Chamber
Fountain(103, 102,     "amberCastle3")

-- Stairs to basement
Fountain(105, 104,     "amberCastle4")

-- Teleport Room
Fountain(107, 106,     "amberCastle5")

-- Archmage Room
Fountain(109, 108,     "amberCastle6")

-- Basement tunnels entrance
Fountain(111, 108,     "amberCastle7")

-- Apple Tree Chamber
Fountain(113, 110,     "amberCastle8")

-- Basement Tunnels
Fountain(115, 112,     "amberCastle9")

-- Basement Tunnels, South Passage
Fountain(117, 114,     "amberCastle10")

-- Basement Entrance, Wall Fountain
Fountain(119, 118,     "amberCastle11")

-- Basement Narrow Tunnels
Fountain(121, 120,     "amberCastle12")

-- Basement Tunnels, Western Passage
Fountain(123, 122,     "amberCastle13")

-- EXIT DOOR
-- @todo trigger not set
evt.hint[88]        = ModTxt.CLeaveDungeon
evt.map[88]         = function()
    evt.MoveToMap{
        X           = 19042,
        Y           = 21122,
        Z           = 113,
        Direction   = 232,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 0,
        Icon        = 4,
        Name        = "amber-east.odm"
    }
end

------------------------------------------------------------------------------
-- TRAPS
------------------------------------------------------------------------------

-- Entrance, stairs
evt.map[130]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.Sparks,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = 1535,
        FromY   = 600,
        FromZ   = 330,
        ToX     = 1535,
        ToY     = -243,
        ToZ     = 330
    }
end

-- Elevator to master bedroom
evt.map[131]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.Sparks,
        Mastery = const.Grandmaster,
        Skill   = 7,
        FromX   = -2555,
        FromY   = -2119,
        FromZ   = 2161,
        ToX     = -2555,
        ToY     = -2422,
        ToZ     = 2161
    }
end

-- Entrance to throne room
evt.map[132]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.FireBolt,
        Mastery = const.Master,
        Skill   = 15,
        FromX   = 552,
        FromY   = -3058,
        FromZ   = 700,
        ToX     = 1357,
        ToY     = -3058,
        ToZ     = 700
    }
end

-- Entrance to mess hall
evt.map[133]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.AcidBurst,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = -814,
        FromY   = -6392,
        FromZ   = 440,
        ToX     = 863,
        ToY     = -6392,
        ToZ     = 440
    }
end

-- Entrance to mess hall
evt.map[134]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.Fireball,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = 4146,
        FromY   = -511,
        FromZ   = -574,
        ToX     = 3656,
        ToY     = -511,
        ToZ     = -574
    }
end

-- Teleportation room
evt.map[135]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.IceBlast,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = 5762,
        FromY   = 4103,
        FromZ   = 160,
        ToX     = 5762,
        ToY     = 3731,
        ToZ     = 150
    }
end

-- Entrance to the lower tunnels ("crossroads")
evt.map[136]        = function()

    if not IsWarrior() then return end

    evt.CastSpell{
        Spell   = const.Spells.Sparks,
        Mastery = const.Master,
        Skill   = 7,
        FromX   = 5395,
        FromY   = -1796,
        FromZ   = -1100,
        ToX     = 5097,
        ToY     = -1510,
        ToZ     = -1151
    }
end
