--[[
Map:    Amber Island
Author: Henrik Chukhran, 2022 - 2026
]]

local TXT   = Localize{
    [1]     = "Oak Hill Cottage",
    [2]     = "Archmage's Residence",
    [3]     = "Apple Cave",
    [4]     = "Abandoned Mines",
    [5]     = "Enter the Oak Hill Cottage",
    [6]     = "Enter the Archmage's Residence",
    [7]     = "Enter the Cave",
    [8]     = "Enter the Abandoned Mines",
    [9]     = "Horse Statue",
    [10]    = "Pray at Altar",
    [11]    = "Black Betty",        -- Ship
    [12]    = "Saint Barthelemy",   -- Ship
    [13]    = "Tower",
    [14]    = "Apple Tree",
    [15]    = "Yuck! Apples are too sour to be consumed...",
    [16]    = "Skull",
    [17]    = "Fists up! The brawl begins!",
    [18]    = "Running away? Cowards...",
    [19]    = "Hey! That's cheating. You forfeit!",
    [20]    =   "As you step outside, a hooded girl brushes past you.\n\n"..
                "Before anyone can react, her hand flashes toward the nobleman's ring.\n\n"..
                "\01265523The ring is gone.\01200000\n\n"..
                "\"Thief!\" Michael shouts. \"After her!\"\n\n"..
                "She bolts east, toward \01265523East Amber Island\01200000.",
}
table.copy(TXT, evt.str, true)
Game.MapEvtLines.Count = 0

------------------------------------------------------------------------------

-- FACE GROUPS
-- ID           DESCRIPTION
-- 42           (Warrior) Watchtower Cellarin Ruined tower
-- 123          (Warrior) Board bridge between port island and town
-- 200          (Warrior) Invisible wall surrounding arena behind Chapman res

-- NPC GROUP
-- IDs          DESCRIPTION
-- 36           Peasants
-- 38           Guards

-- GOODS
-- PLACE        TYPE            PRICE       ITEM
-- Chapman      Buy             1500        Amber Apple Cider
-- Chapman      Sell            3000        Coffee Beans
-- Ferrum       Sell            300         Amber

-- SPRITE IDs
-- ID       NAME         TYPE        DESCRIPTION
-- 190      "dec02"      Campfire    Western campfire (fire guild)
-- 191      "dec02"      Campfire    Eastern campfire (fire guild)

-- ***************************************************************************

-- CHESTS
-- CHEST ID     TRIGGER ID      DESCRIPTION
-- 00           01              Port Island, near Oak Hill Cottage entrance
-- 01           02              Port Island, behind the Bolton residence
-- 02           03              Top of ruined tower
-- 03           04              Apple Island, near Apple Cave dungeon
-- 04           05              North-East part of swamp, near the ramp
-- 05           06              Swamp island, Knight Camp, near the teleportation platform
-- 06           07              Near the Archmage Residence
-- 07           08              Eastern barrens, near Abandoned Mines
-- 08           09              Rich District, Hawk Residence, balcony
-- 09           10              Shore, behind Earth Guild, near the bridge
-- 10           11              Beck Residence balcony, western town entrance
-- 11           12              Western town shore, behind Armstrong residence
-- 12           13              Island close to town, between port island and town
-- 13           14              Northern Island, map border

-- ***************************************************************************

-- FOUNTAINS
-- TYPE         TRIGGER ID      ID              DESCRIPTION
-- Well         22              amberWell1      Port Island, near Oak HIll Cottage entrance
-- Well         23              amberWell2      Before Amber Town Bridge
-- Well         24              amberWell3      Western District, near prison tower
-- Well         25              amberWell4      Swamp Island, near Knight Camp
-- Fountain     27              amberFountain1  Port Island
-- Fountain     28              amberFountain2  Town center
-- Basin        165             amberFountain3  Rich district

-- ***************************************************************************

-- DUNGEONS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Dungeon      30              Oak HIll Cottage
-- Dungeon      32              Archmage Residence
-- Dungeon      34              Apple Cave
-- Dungeon      36              Abandoned Mines
-- Dungeon      168             Watchtower Cellar (Warrior)

-- ***************************************************************************

-- SHOPS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Tavern       65              Powder Keg Inn, Port Island
-- Training     67              Amber Training Grounds, Western town shore
-- Temple       69              Saint Nourville Cathedral, Town Center
-- Temple       71              Amber Bank, Town Center
-- Tavern       73              Crusty Eagle Inn, Town Center
-- Shop         75              Armorer: Steel Bucket, Eastern Market District
-- Shop         77              Smith: Razorsharp, Eastern Market District
-- Shop         79              Alchemist: Potions of Payne, Eastern Market District
-- Shop         81              Magician: Odds and Ends, Eastern Market District
-- Guild        83              Spirit, Southern Mage District
-- Guild        85              Body,   Southern Mage District
-- Guild        87              Mind,   Southern Mage District
-- Guild        89              Fire,   Southern Mage District
-- Guild        91              Air,    Southern Mage District
-- Guild        93              Water,  Southern Mage District
-- Guild        95              Earth,  Southern Mage District
-- Town Hall    97              Town Center
-- Merc Guild   138             Tent,   Mage District

-- ***************************************************************************

-- RESIDENCES
-- TITLE        TRIGGER  AREA                   SPECIAL                     DETAILS
-- Graywood     101      Port Island                                        W from fountain
-- Nightkeep    102      Port Island                                        NW from fountain
-- Colby        103      Port Island            Expert: Thief               E from fountain
-- Bolton       104      Port Sub-island        Make: Black Potion          E after bridge
-- Greene       105      Port Sub-island        Q: Worrying Mother          N after bridge
-- Gladwyn      106      Port Sub-island                                    W after bridge
-- Wright's     107      Port Sub-island        Expert: Disarm              Tent
-- Halloran     108      Western Town Island    Q: Conrad Hawk              Small 2-store house
-- Beck         109      Western Town Island    Q: Family Sword             Big house
-- Amber Tower  110      West-south Hill        Q: Conrad Hawk              
-- Timar        111      Western District       Expert: Leather             Entrance, rocky house
-- Hoggard      112      Western District       Expert: Chain               Entrance, small house
-- Shadoweaver  113      Western District       Future: Dark guild          Castle like house with tower
-- Smith        114      Western District                                   Gray waffle-and-daub house
-- Yap          115      Western District       Q: Lucky Coin               Small elven house
-- Quick        116      Western District       Expert: Dodge               Barn-like house
-- Borg         117      Western District       Buy: Empty Flask            Small round house
-- Armstrong    118      Western District       Expert: Plate               L-shaped stone house
-- Flavius      119      Western District                                   2-store yellow house
-- Constantine  120      Western District       Q: Ritual                   Hexagon-shaped yellow house
-- Witts        121      Western District       Guild memberships           Wooden 2-store house
-- Sage         122      Western District       Expert: Perception          Elven yellow house
-- Wells        123      Western District       Expert: Water               Bridge house (south)
-- Aarden       124      Western District       Expert: Earth               Bridge house (north)
-- Marley       125      Western District       Expert: Axe                 Big-stone gray house
-- Goodwin      126      Western District       Buy: 8 hp/sp potions        Small tower house
-- Brand        127      Western District       Expert: Fire                Duplex house (north)
-- Lightfeather 128      Western District       Expert: Air | Buy: Jump     Duplex house (south)
-- Blaine       129      Western District       Q: Ransom                   Rich stone house with stairs
-- Stringer     130      Western District       Expert: Bow                 Rich elven 2-store house, near Inn
-- Oswald       131      Western District       Expert: Mace                Large stone house with shed
-- Ferrum       132      Western District       Sell: Amber                 L-shaped waffle-and-daub house
-- Carter       133      Western District       Q: Swamp Creatures          Wooden 2-store house with door at corner
-- Messer       134      Western District       Expert: Dagger              Small yellow house with wooden corners
-- Leary        135      Western District       Expert: Mind                Blue 2-store house
-- Vesalius     136      Mage District          Expert: Body                Big ston house with purple second floor
-- Barnes       137      Mage District          Expert: Meditation          Wooden 2-store house with dirty 2nd floor
-- Lund         138      Mage District          Expert: Spirit              Purple house
-- n/a
-- Craig        140      Center                 Expert: Repair              Poor house
-- Hawk         141      Rich District                                      Arc house with 2 apartments
-- Chapman      142      Rich District          Expert: Merchant | Goods    Huge building with tower
-- Mayor        143      Rich District                                      Central 3-Store house
-- Shirley      144      Rich District          Expert: Learning            White stone house
-- Robeson      145      Rich District          Q: Revenge (reward)         Black stone house
-- Winter       146      Rich District          E: ID Item/Monster          3-app duplex (east)
-- McBane       147      Rich District          Buy: +1500 exp              3-app duplex (center)
-- Ryder        148      Rich District          E: Shield / Spear           3-app duplex (west)
-- Boyce        149      North-Western Shore    E: Staff | T: Arena, Castle Boatman's House
-- Greene       150      Knight Camp            Q: Legate                   North Tent
-- Kemp         151      Knight Camp            Expert: Armsmaster          East Tent
-- Mitchell     152      Knight Camp            Expert: Sword               South Tent
-- Stevenson    153      Eastern Desert Island  Q: Old Sea Dog              Lighthouse
-- Cassio       154      Eastern Desert Island  Q: Revenge (complete)       Big 2-store waffle-and-daub house
-- Payne        155      Swamp                  Make: Black Potion          Witch Hut
-- Bunny Burrow 161      North Town Shore       Q: Missing Pet (complete)   Small cave / burrow

-- ***************************************************************************

-- TRIGGERS
-- TYPE         TRIGGER ID      DESCRIPTION
-- Statue       37              Horse Statue in Mage District
-- Statue       38              Shrine in Swamp, Dwarf
-- Teleport     40              Swamp, teleport platform near Knight Camp
-- Altar        42              Stonehenge at Swamp Island, Forest area
-- Ship         61              South Ship: Black Betty
-- Ship         63              West Ship:  Saint Barthelemy

-- Exit         160             Eastern Bridge
-- Sprite       162             Skull (North-East map corner)
-- Texture      163             Guild of Body, North Window (gives scroll)
-- NPC          164             Sir Henry (Port Island Bridge trigger)
-- Ambush       166             Swamp Island between Port Island and Amber Town
-- Sprite       169             Swamp Tree Stump (south-eastern part of archmage residence island, near small pool)
-- Invisible    170             Invisible wall surrounding arena behind Chapman res
-- SpriteId     200-255         Sour apple trees

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local HouseID_WatchtowerCellar  = 582
local HouseID_AppleCave         = 583
local HouseID_AbandonedMines    = 584

local AppleCaveKeyItemID        = 668

local function ShopDoor(evtId, houseId)
    evt.house[evtId]    = houseId
    evt.map[evtId]      = function()

        if IsWarrior() and vars.MiscAmberIsland.ClosedShops == true then
            evt.FaceAnimation{Player = "Current", Animation = 18}
            Game.ShowStatusText(ModTxt.CLockedDoor)

            -- Notify about wtf is happening in 5sec
            if evt.Cmp("MapVar41", 1) == false then
                evt.Set("MapVar41", 1)
                Timer(function()
                    evt.SpeakNPC(541)
                    RemoveTimer()
                end, 5*const.Minute, false)
                return
            end

            return
        end
        evt.EnterHouse(houseId)
    end
end

local function ConradKilledParty()

    -- Conrad Hawk managed to kick your ass?
    if vars.QuestsAmberIsland.QVarConradBrawl == 4 then
        evt.SetFacetBit(200,const.FacetBits.Untouchable, true)
        evt.MoveNPC(547,117) -- Conrad goes back to Inn
        for _, mon in Map.Monsters do
            if mon.NPC_ID  == 547 then
                RemoveMonster(mon)
                break
            end
        end

        vars.QuestsAmberIsland.QVarConradBrawl = 5 -- Post Death
    end
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.AfterMonsterAttacked(t, attacker)

    if t == nil then return end
    if attacker == nil then return end

    -- Conrad Hawk's fair fight (Warrior)
    if not IsWarrior() then return end

    -- Make sure we're fighting Conrad
    if vars.QuestsAmberIsland.QVarConradBrawl ~= 1 then
        return
    end

    if t.Attacker.Player ~= nil then
        if t.Monster.NPC_ID == 547 then
            
            local notFair = false

            if t.Attacker.Object ~= nil then
                notFair = true
            end

            if t.Attacker.Spell ~= nil then
                notFair = true
            end

            if t.Attacker.Player:GetActiveItem(const.ItemSlot.MainHand) then
                notFair = true
            end

            if notFair then

                -- Warning...
                if not vars.QuestsAmberIsland.QVarConradWarning then
                    evt.SpeakNPC(548)
                    vars.QuestsAmberIsland.QVarConradWarning = true
                    return
                end

                evt.MoveNPC(547,117) -- Conrad goes back to Inn
                RemoveMonster(t.Monster)
                vars.QuestsAmberIsland.QVarConradBrawl      = 3 -- Failure
                vars.QuestsAmberIsland.QVarConradWarning    = false

                -- Remove arena bounds
                evt.SetFacetBit(200,const.FacetBits.Untouchable, true)

                Message(evt.str[19])
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)

    if mon.NPC_ID == 498 then
        vars.QuestsAmberIsland.QVarRevenge = 3 -- Michael Cassio is Killed
    elseif mon.NPC_ID == 539 then
        vars.QuestsAmberIsland.QVarButlerEscaped = 3 -- Butler is killed
        vars.Quests.StoryQuest4 = "Done"
    elseif mon.NPC_ID == 547 then -- Conrad Brawl (Warrior)
    
        vars.QuestsAmberIsland.QVarConradBrawl = 2  -- Victory

        -- Conrad goes to prison
        evt.MoveNPC(547,0)
        evt.MoveNPC(491,533)

        -- Remove arena bounds
        evt.SetFacetBit(200,const.FacetBits.Untouchable, true)

        -- Guard encounter
        evt.Add("Exp", 0)
        evt.SpeakNPC(549)

        Sleep(1)
        RemoveMonster(mon)
    end
end

function events.DeathMap(t)

    -- Conrad killed the party?
    if Game.Map.Name == "amber.odm" then
        if vars.QuestsAmberIsland.QVarConradBrawl == 1 then
            vars.QuestsAmberIsland.QVarConradBrawl = 4 -- Death
            ConradKilledParty()
        end
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

    -- Managed to town portal from Conrad during fight?
    if vars.QuestsAmberIsland.QVarConradBrawl == 1 then
        vars.QuestsAmberIsland.QVarConradBrawl = 4
    end

    ConradKilledParty()

    -- Difficulty differences
    if IsWarrior() then
        --
    else

        -- hide watchtower cellar
        evt.SetFacetBit(42,const.FacetBits.Invisible,true)
    end
end

------------------------------------------------------------------------------
-- CHESTS
------------------------------------------------------------------------------

for i = 0, 19, 1 do
    local hintStr   = ModTxt.CChest
    if Game.Debug then
        hintStr     = hintStr .. " #"..tostring(i)
    end
    evt.hint[1 + i]        = hintStr
    evt.map[1 + i]         = function()
        evt.OpenChest(i)
    end
end

------------------------------------------------------------------------------
-- APPLE TREES
------------------------------------------------------------------------------

for i = 200, 255, 1 do
    evt.hint[i]        = evt.str[14]
    evt.map[i]         = function()
        evt.StatusText(15)
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

------------------------------------------------------------------------------
-- WELLS
------------------------------------------------------------------------------

evt.hint[23]        = ModTxt.CDrinkWell
evt.hint[24]        = ModTxt.CDrinkWell
evt.hint[25]        = ModTxt.CDrinkWell

-- Port Island
Fountain(22, 200,   "amberWell1")

-- Before Amber Town Bridge
Fountain(23, 201,   "amberWell2")

-- Western District, near prison tower
Fountain(24, 202,   "amberWell3")

-- Swamp Island, near Knight Camp
Fountain(25, 203,   "amberWell4")

------------------------------------------------------------------------------
-- FOUNTAINS
------------------------------------------------------------------------------

-- Port Island
Fountain(27, 26,    "amberFountain1")

-- Town Center
Fountain(28, 204,   "amberFountain2")

-- Basin, Rich district
Fountain(165, 205,  "amberFountain3")

------------------------------------------------------------------------------
-- DUNGEONS
------------------------------------------------------------------------------

-- Dungeon: Oak Hill Cottage
evt.hint[29]        = evt.str[1]
evt.hint[30]        = evt.str[5]
evt.map[30]         = function()
    evt.MoveToMap{
        X           = -41,
        Y           = 369,
        Z           = 0,
        Direction   = 2,
        LookAngle   = 1,
        SpeedZ      = 1,
        HouseId     = 193,
        Icon        = 1,
        Name        = "oakhome.blv"
    }
end

-- Dungeon: Archmage's Residence
evt.hint[31]        = evt.str[2]
evt.hint[32]        = evt.str[6]
evt.map[32]         = function()
    evt.MoveToMap{
        X           = -4,
        Y           = -2,
        Z           = 1,
        Direction   = 512,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 195,
        Icon        = 1,
        Name        = "archmageEX.blv"
    }
end

-- Dungeon: Apple Cave
evt.hint[34]        = evt.str[7] -- Enter the Cave
evt.hint[33]        = evt.str[3] -- Apple Cave
evt.map[34]         = function()

    -- Barnaby found new home! #2
    if evt.Cmp("NPCs", 539) then
        evt.Subtract("NPCs", 539)
        evt.MoveNPC{NPC = 539, HouseId = HouseID_AppleCave}
        evt.SpeakNPC(543)
        vars.QuestsAmberIsland.QVarButlerEscaped        = 4 -- hidden
        vars.QuestsAmberIsland.QVarButlerHideHouseID    = HouseID_AppleCave
        return
    end

    for _, mon in Map.Monsters do
        if mon.NPC_ID  == 517 then
            if mon.Hostile == false and mon.HP > 0 then
                evt.SpeakNPC(521)
                return
            end
        end
    end

    if IsWarrior() then
        if vars.MiscAmberIsland.AppleCaveClosed == true then
            
            if not evt.All.Cmp("Inventory", AppleCaveKeyItemID) then
                evt.FaceAnimation{Player = "Current", Animation = 18}
                Game.ShowStatusText(ModTxt.CLockedDoor)
                return
            end

            evt.Sub("Inventory", AppleCaveKeyItemID)
            vars.MiscAmberIsland.AppleCaveClosed = false
        end
    end

    if vars.QuestsAmberIsland.QVarButlerHideHouseID == HouseID_AppleCave then
        evt.EnterHouse(HouseID_AppleCave)
        return
    end

    evt.MoveToMap{
        X           = -148,
        Y           = 3,
        Z           = 0,
        Direction   = 2048,
        LookAngle   = 1,
        SpeedZ      = 1,
        HouseId     = 194,
        Icon        = 1,
        Name        = "applecave.blv"
    }
end

-- Dungeon: Abandoned Mines
evt.hint[35]        = evt.str[4] -- Abandoned Mines
evt.hint[36]        = evt.str[8] -- Enter the Abandoned Mines
evt.map[36]         = function()

    -- Barnaby found new home! #3
    if evt.Cmp("NPCs", 539) then
        evt.Subtract("NPCs", 539)
        evt.MoveNPC{NPC = 539, HouseId = HouseID_AbandonedMines}
        evt.SpeakNPC(543)
        vars.QuestsAmberIsland.QVarButlerEscaped        = 4 -- hidden
        vars.QuestsAmberIsland.QVarButlerHideHouseID    = HouseID_AbandonedMines
        return true
    end

    if vars.QuestsAmberIsland.QVarButlerHideHouseID == HouseID_AbandonedMines then
        
        evt.EnterHouse(HouseID_AbandonedMines)
        return true
    end

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

------------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------------

-- Statue: Horse
evt.hint[37]        = evt.str[9] -- Horse Statue
evt.map[37]         = function()
    --
end

-- Statue: Swamp Island
evt.hint[38]        = ModTxt.CStatue
evt.map[38]         = function()
    --
end

-- Teleporter: Swamp Island
evt.hint[39]        = ModTxt.CTeleportPlatform
evt.hint[40]        = ModTxt.CTeleportPlatform
evt.map[40]         = function()
    if evt.All.Cmp("Inventory",796) then
        evt.MoveToMap{
            X           = 17708 ,
            Y           = -20470,
            Z           = 1 ,
            Direction   = 715,
            LookAngle   = 0,
            SpeedZ      = 0,
            HouseId     = 192,
            Icon        = 1,
            Name        = "amber-east.odm"
        }
    end
end

-- Altar: Stonehenge Swamp Island
evt.hint[41]        = ModTxt.CAltar
evt.hint[42]        = evt.str[10]
evt.map[42]         = function()
    if evt.All.Cmp("Inventory", 785) and vars.QuestsAmberIsland.QVarRitual == false then

        vars.QuestsAmberIsland.QVarRitual = true
        evt.Subtract("Inventory", 785)
        evt.PlaySound(14050,Party.X,Party.Y)
        evt.All.Add("Exp",0)

        local monster = SummonMonster(IsWarrior() and 23 or 22, 19427, -1525, 897, true)
        monster.NameId              = 14 -- Arnona'el
        monster.Level               = IsWarrior() and 15 or 5
        monster.FullHitPoints       = IsWarrior() and 640 or 360
        monster.HP                  = IsWarrior() and 640 or 360
        monster.ArmorClass          = IsWarrior() and 20 or 10
        monster.Attack1.DamageAdd   = IsWarrior() and 12 or 4
        monster.Attack1.Missile     = IsWarrior() and 0 or 3
        monster.Special             = 0

        if IsWarrior() then
            for _, pl in Party do
                if pl:GetIndex() == Game.CurrentPlayer then
                    pl:AddCondition(const.Condition.Cursed)
                else
                    pl:AddCondition(const.Condition.Weak)
                end
            end

            -- Spawn gogs
            local x0, y0, z0    = 19951, -2709, 928
            local dist          = 768

            for i = 0, 5 do
                local a     = i * math.pi / 3  -- 60 degrees
                local X     = math.floor(x0 + math.cos(a) * dist + 0.5)
                local Y     = math.floor(y0 + math.sin(a) * dist + 0.5)
                local gog   = SummonMonster(77, X, Y, z0, true)
                gog.AIType  = 3
            end
        else
            monster.Spell = 0
        end
    end
end
------------------------------------------------------------------------------
-- SHIPS
------------------------------------------------------------------------------

evt.hint[60]        = evt.str[11]
evt.hint[61]        = evt.str[11] -- Black Betty
evt.map[61]         = function()
    evt.EnterHouse(579)
end

evt.hint[62]        = evt.str[12]
evt.hint[63]        = evt.str[12] --
evt.map[63]         = function()
    evt.EnterHouse(580)
end

------------------------------------------------------------------------------
-- SHOPS
------------------------------------------------------------------------------

-- Tavern: Powder Keg Inn
evt.HouseDoor(65, 120)

-- Training: Amber Training Grounds
evt.HouseDoor(67, 91)

-- Temple: Saint Nourville Cathedral
evt.map[69]         = function()

    if vars.MiscGlobal.OnDeathLocation == 0 then
        vars.MiscGlobal.OnDeathLocation = 1
    end

    evt.EnterHouse(246)
end

-- Bank: Amber Bank
evt.HouseDoor(71, 251)

-- Tavern: Crusty Eagle Inn
evt.HouseDoor(73, 117)

-- Armorer: Steel Bucket
ShopDoor(75, 17)

-- Smith: Razorsharp
ShopDoor(77, 3)

-- Alchemist: Potions of Payne
ShopDoor(79, 53)

-- Magician: Odds and Ends
ShopDoor(81, 41)

-- Guild: Spirit
evt.HouseDoor(83, 156)

-- Guild: Body
evt.HouseDoor(85, 164)

-- Guild: Mind
evt.HouseDoor(87, 160)

-- Guild: Fire
evt.HouseDoor(89, 140)

-- Guild: Air
evt.HouseDoor(91, 144)

-- Guild: Water
evt.HouseDoor(93, 148)

-- Guild: Earth
evt.HouseDoor(95, 152)

-- Town Hall: Amber Town
evt.HouseDoor(97, 248)

------------------------------------------------------------------------------
-- RESIDENCES
------------------------------------------------------------------------------

evt.hint[98]        = ModTxt.CHouse
evt.hint[99]        = ModTxt.CTent
evt.hint[100]        = evt.str[13] -- Tower

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

-- Amber Tower (Prison)
evt.house[110]  = 533
evt.map[110]         = function()

    -- StoryQuest3: Butler escapes prison (warrior)
    if IsWarrior() then
        
        -- Message
    end

    evt.EnterHouse(533)
end

-- Residental Houses of Amber Town (Entrance Area)
evt.HouseDoor(111, 534) -- Timar        First town rocky house
evt.HouseDoor(112, 535) -- Hoggard      Small house
evt.HouseDoor(113, 536) -- Shadoweaver  Castle-like house
evt.HouseDoor(114, 537) -- Smith        Gray waffle-and-daub house
evt.HouseDoor(115, 538) -- Yap          Elf house
evt.HouseDoor(116, 539) -- Quick        Barn-like house
evt.HouseDoor(117, 540) -- Borg         Small round house
evt.HouseDoor(118, 541) -- Armstrong    L-shaped house
evt.HouseDoor(119, 542) -- Flavius      2 store yellow house
evt.HouseDoor(120, 543) -- Constantine  Hexagon-shaped yellow house
evt.HouseDoor(121, 544) -- Witts        Wooden 2-store house
evt.HouseDoor(122, 545) -- Sage         Elven yellow house
evt.HouseDoor(123, 546) -- Wells        Bridge-like house (south)
evt.HouseDoor(124, 547) -- Aarden       Bridge-like house north
evt.HouseDoor(125, 548) -- Marley       Big-stone house
evt.HouseDoor(126, 549) -- Goodwin      Small tower house
evt.HouseDoor(127, 550) -- Brand        Duplex-north 549
evt.HouseDoor(128, 551) -- Lightfeather Duplex-south
evt.HouseDoor(129, 552) -- Blaine       Rich stone house with stairs
evt.HouseDoor(130, 553) -- Stringer     Rich elven 2-store house, near Inn
evt.HouseDoor(131, 554) -- Oswald       Large stone house with shed
evt.HouseDoor(132, 555) -- Ferrum       L-shaped waffle-and-daub house
evt.HouseDoor(133, 556) -- Carter       Wooden 2-store house with door at corner
evt.HouseDoor(134, 557) -- Messer       Small yellow house with wooden corners
evt.HouseDoor(135, 558) -- Leary        Blue 2-store house
evt.HouseDoor(136, 559) -- Vesalius     Big ston house with purple second floor
evt.HouseDoor(137, 560) -- Barnes       Wooden 2-store house with dirty 2nd floor
evt.HouseDoor(138, 561) -- Merc Guild   Tent near south bridge
evt.HouseDoor(139, 562) -- Lund         Purple house near Spirit Guild
evt.HouseDoor(140, 563) -- Craig        Poor house near Town Hall
evt.HouseDoor(141, 564) -- Hawk         Arc house with 2 apartments
evt.HouseDoor(142, 565) -- Chapman      Huge building with tower
evt.HouseDoor(143, 566) -- Mayor        Central 3-Store house
evt.HouseDoor(144, 567) -- Shirley      White stone house
evt.HouseDoor(145, 568) -- Robeson      Black stone house
evt.HouseDoor(146, 569) -- Winter       3-app duplex: east
evt.HouseDoor(147, 570) -- McBane       3-app duplex: mid
evt.HouseDoor(148, 571) -- Ryder        3-app duplex: west
evt.HouseDoor(149, 572) -- Boyce        Boatman's House

-- Swamp Island
evt.house[150]  = 573   -- Greene       Knight Camp: North Tent
evt.map[150]         = function()
    if evt.Cmp("NPCs", 538) then
        evt.Subtract("NPCs", 538)
        vars.QuestsAmberIsland.QVarGreeneRescued = true
        evt.MoveNPC(515,573)  -- Old Robert Greene
        evt.Add("Exp",500)
    end
    evt.EnterHouse(573)
end
evt.HouseDoor(151, 574) -- Kemp         Knight Camp: East Tent
evt.HouseDoor(152, 575) -- Mitchell     Knight Camp: West Tent
evt.HouseDoor(153, 576) -- Stevenson    Lighthouse
evt.HouseDoor(154, 577) -- Cassio       Big 2-store waffle-and-daub house
evt.HouseDoor(155, 578) -- Payne        Swamp, Witch Hut

-- Exit: Amber Island to East Amber Island
evt.map[160]         = function()
    evt.MoveToMap{
        X           = -22255,
        Y           = 9476,
        Z           = 79,
        Direction   = 2048,
        LookAngle   = 0,
        SpeedZ      = 0,
        HouseId     = 192,
        Icon        = 1,
        Name        = "amber-east.odm"
    }
end

-- Bunny Burrow
evt.HouseDoor(161, 606)

-- Skull NE corner
evt.hint[162]        = evt.str[16]
evt.map[162]         = function()
    if evt.Cmp("MapVar39", 1) == false then
        evt.Set("MapVar39", 1)
        evt.Add("Inventory", 397)
    end
end

-- Body Guild Window
evt.map[163]         = function()
    if evt.Cmp("MapVar38", 1) == false then
        evt.Set("MapVar38", 1)
        evt.Add("Inventory", 385)
    end
end

-- Sir Henry
evt.map[164]         = function()
    if Game and Game.Debug == false and vars.MiscGlobal.FirstTimePlaying == 0 then
        vars.MiscGlobal.FirstTimePlaying = 1
        evt.SpeakNPC(449)
    end
end

-- Goblin Ambush
evt.map[166]         = function()

    if not IsWarrior() or evt.Cmp("MapVar40", 1) == true then
        return
    end

    evt.Set("MapVar40", 1)
    local GoblinArray = {
        
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

-- Warrior: Watchtower dungeon
evt.hint[167]        = evt.str[1]
evt.hint[168]        = evt.str[5]
evt.map[168]         = function()

    -- Barnaby found new home! #1
    if evt.Cmp("NPCs", 539) then
        evt.Subtract("NPCs", 539)
        evt.MoveNPC{NPC = 539, HouseId = HouseID_WatchtowerCellar}
        evt.SpeakNPC(543)
        vars.QuestsAmberIsland.QVarButlerEscaped        = 4 -- hidden
        vars.QuestsAmberIsland.QVarButlerHideHouseID    = HouseID_WatchtowerCellar
        return true
    end

    if vars.QuestsAmberIsland.QVarButlerHideHouseID == HouseID_WatchtowerCellar then
        
        evt.EnterHouse(HouseID_WatchtowerCellar)
        return true
    end

    evt.MoveToMap{
        X           = -23,
        Y           = 127,
        Z           = 1,
        Direction   = 1024,
        LookAngle   = 1,
        SpeedZ      = 1,
        HouseId     = 199,
        Icon        = 1,
        Name        = "watchtower.blv"
    }
end

-- Swamp Tree Stump (south-eastern part of archmage residence island, near small pool)
evt.map[169]         = function()

    if not IsWarrior() then return end

    if evt.Cmp("MapVar42", 1) == false then
        evt.Set("MapVar42", 1)
        evt.Add("Inventory", 781)
        evt.FaceAnimation{Player = "Current", Animation = 14}
        evt.Add("Experience", 0)
    end
end

-- (Warrior) Arena bounds behind Chapman residence
evt.map[170]         = function()

    -- Remove bounds if not fighting
    if vars.QuestsAmberIsland.QVarConradBrawl == 1 then

        -- Forfeit?
        if not vars.QuestsAmberIsland.QVarConradWarning then
            evt.SpeakNPC(548)
            vars.QuestsAmberIsland.QVarConradWarning = true
            return
        end

        vars.QuestsAmberIsland.QVarConradBrawl = 3 -- Failure

        evt.MoveNPC(547,117) -- Conrad goes back to Inn
        for _, mon in Map.Monsters do
            if mon.NPC_ID  == 547 then
                RemoveMonster(mon)
                break
            end
        end

        Message(evt.str[18])
    end

    evt.SetFacetBit(200,const.FacetBits.Untouchable, true)
end

-- Fire guild campfires
evt.map[190]         = function()
    -- n/a
end

------------------------------------------------------------------------------
