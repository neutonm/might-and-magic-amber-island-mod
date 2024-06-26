--[[
Global Mod Script
Author: Henrik Chukhran, 2022 - 2024
]]

-- Game.NewGameMap = "testlevel.blv"
-- function events.NewGameMap()
-- 	XYZ(Party, 395, 343, 192)
-- 	Party.Direction    = 1262
-- 	Party.LookAngle    = 14
-- 	Party.Gold         = 0
-- 	Party.Food         = 2
-- end 

-- @todo make a list of travel points and use them instead of MoveTo with magic number arguments

-- DEBUG MODE (MOD)
Game.Debug = false

-- Helpers
-- @todo this sucks, figure out the way to properly delete monsters
function RemoveMonster(mon)
    if mon then
        mon.HP = 0
        mon.NPC_ID = 0
        mon.Invisible = true
        mon.X = -9999
        mon.Y = -9999
        mon.Z = -9999
    end
end

function ContainsNumber(myArray, myValue)

    if myArray == nil then
        return false
    end
    
    for _, v in ipairs(myArray) do
        if v == myValue then
            return true
        end
    end
    return false
end

function TableRemoveByValue(t, value)

    if t == nil then
        return false
    end

    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
            return true
        end
    end
    return false
end

Game.NewGameMap = Game.Debug and "hub.blv" or "amber.odm"
Game.TitleTrack = 22

function events.NewGameMap()
    
    XYZ(Party,-17116,-21798,449)

    --XYZ(Party, -148,3,0)
    --XYZ(Party, -15484, -21868, 256)
    Party.Direction    = 354 --2044 --649
    Party.LookAngle    = 1
    Party.Gold         = 0
    Party.Food         = 2
end 

function events.DeathMap(t)

    local loc = vars.MyMisc.OnDeathLocation

    if loc == 0 then -- New Game Start Location
        t.Name = "amber.odm"
        XYZ(Party,-17116,-21798,449)
        --XYZ(Party, -17116, -21798, 449)
        Party.Direction     = 354 --649
        Party.LookAngle     = 0
    elseif loc == 1 then -- Amber Town Temple entrance

        t.Name = "amber.odm"
        XYZ(Party, 3684, 8941, 120)
        Party.Direction     = 1024
        Party.LookAngle     = 0
    else
        -- @todo depecrated
        t.Name = "testlevel.blv"
        XYZ(Party, 395, 343, 192)
        Party.Direction     = 1262
        Party.LookAngle     = 0
    end
    
end

function events.BeforeLoadMap(WasInGame, WasLoaded)

    -- @todo temp fix, figure out why HostileType isn't set
    -- LocalMonstersTxt()
    -- for i = 265, 278, 1 do
    --     Game.MonstersTxt[i].HostileType = 2 
    -- end

    if not WasInGame and not WasLoaded then

        -- Quest Variables
        vars.MyQuests = {
            QVar1       = false,            -- Quest: The Fog
            QVarEndGame = false,            -- Game End
            QVarRitual  = false,            -- Quest: Ritual, summon bool
            QVarRansom  = 0,                -- Quest: Ransom, state
            QVarRevenge = 0,                -- Quest: Revenge, state: given (1), duel (2), killed (3), 
                                            -- reporting (4), repotred (5), released (6), rewarded (7)
        }
        vars.MyMisc = {
            FirstTimePlaying        = 0,    -- for "Sir Henry" message at startup
            OnDeathLocation         = 0,    -- Variable for resurrection locations
            AmberBulkCurePotionSale = true, -- Jane Goodwin, 8x cure potion for 500g
            AmberBulkManaPotionSale = true, -- Jane Goodwin, 8x mana potion for 500g
            AmberArenaCounterStarted= false,-- Arena cooldown (Cedrik Boyce) (0 = ready)
        }
        vars.MyTriggers = {
            LuckyCoinSpawn          = false,
            ArchmageEscapedHideout  = 0,
            AttackOnCastleAmber     = 0,
        }
        vars.MercNPCUnlockedList = {}
        vars.MercNPCLostList = {}
        -- vars.ModMapArray = {
        --     {Map = "amber.odm", HostileFlag = false},
        --     {Map = "amber-east.odm", HostileFlag = false},
        -- }
        if (vars.Mercs) then
            table.clear(vars.Mercs)
        end
        vars.Mercs = {
            Warder = NewMerc("Warder", 525, 207),
            Ratman = NewMerc("Ratman", 526, 270, false, 
                            "Passive Ability:\n\nRatman's special ability prevents him from dying. Instead, when he would normally die, one summoner charge is consumed. \n\nHe will return to the party upon death.", 
                            {2,4,6,8}, {60, 82, 104, 135}, {0,5,10,15}, {3,7,12,18}, 
                            {"2D2", "2D3+1", "2D4+2", "2D5+2"} )
        }

        ArcomageRequireDeck(false)
    end
    if path.ext(Game.Map.Name):lower() == ".odm" then 
        LocalFile(Game.DecListBin)
        Game.DecListBin[34].SoundId = 0
    end
end

function events.AfterMonsterAttacked(t, attacker)

    if t == nil then return end
    if attacker == nil then return end

    if t.Attacker.Player ~= nil then -- Player
        if t.Monster.NPC_ID > 0 then
            if ContainsNumber(MercNPCList, t.Monster.NPC_ID) then
                t.Monster.Ally = 9999
                t.Monster.Hostile = false
                MercDecCharge(vars.Mercs.Ratman)
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)
    if mon.NPC_ID == 498 then
        vars.MyQuests.QVarRevenge = 3 -- Michael Cassion is Killed
    -- @todo refactor 
    elseif mon.NPC_ID == 525 then -- Merc: Warder
        evt.Add("NPCs",525)
        vars.Mercs.Warder.Release = false
        vars.Mercs.Warder.Dead = true
        vars.Mercs.Warder.FightsLeft = 0
        mon.NPC_ID = 0
    elseif mon.NPC_ID == 526 then -- Merc: Ratman; Exception: Ratman Merc won't die
        evt.Add("NPCs",526)
        vars.Mercs.Ratman.Release = false
        mon.NPC_ID = 0
    end
end

function events.AfterLoadMap(WasInGame)

    if vars then
        if #vars.MercNPCLostList > 0 then
            for _, mon in Map.Monsters do
                if mon.NPC_ID > 0 and mon.Group == 35 then
                    if ContainsNumber(vars.MercNPCLostList, mon.NPC_ID) then
                        TableRemoveByValue(vars.MercNPCLostList, mon.NPC_ID)
                        RemoveMonster(mon)
                    end
                end
            end
        end
    end

    -- Temporary: Hostiles
    local MakeHostile = function(idStart, idEnd)
        for _, mon in Map.Monsters do
            if mon.Id >= idStart and mon.Id <= idEnd then
                mon.Hostile = true
            end
        end
    end

    if Game.Map.Name == "out02.odm" then

        if vars.MyQuests.QVarEndGame == 1 then
            -- @todo change endgame start location and clear this workaround
            vars.MyQuests.QVarEndGame = 2
            Timer(function()
                evt.MoveToMap{
                    X = 3684, Y = 8941, Z = 120, 
                    Direction = 1024, LookAngle = 0, SpeedZ = 0, 
                    HouseId = 0, Icon = 0, Name = "amber.odm"}
            end, const.Second, Game.Time + const.Second, false)
            
        end
    elseif Game.Map.Name == "testlevel.blv" then 
        MakeHostile(79,81) -- Golems
        evt.SetNPCGroupNews(37, 41)
    elseif Game.Map.Name == "amber.odm" then 

        --MakeHostile(265,267) -- Lizards
        evt.SetNPCGroupNews(36, 40)
        evt.SetNPCGroupNews(38, 42)
    elseif Game.Map.Name == "amber-east.odm" then 
        --MakeHostile(265,267) -- Lizards
        evt.SetNPCGroupNews(38, 42)
    elseif Game.Map.Name == "oakhome.blv" then 
        --MakeHostile(268,270) -- Ratmen
        MakeHostile(79,81) -- Golems
    elseif Game.Map.Name == "applecave.blv" then 
        MakeHostile(277,279) -- Animalists
        --MakeHostile(268,270) -- Ratmen
        --MakeHostile(271,273) -- Pirates
        MakeHostile(19,21) -- Priest of the sun
        -- Remove blaine
        for _, mon in Map.Monsters do
            if mon.NPC_ID  == 516 then
                if vars.MyQuests.QVarRansom == 3 then
                    RemoveMonster(mon)
                end
            elseif mon.NPC_ID  == 518 then
                mon.Hostile = false -- Buster Squeaky
                mon.Ally = 1
            end
        end
    elseif Game.Map.Name == "archmageres.blv" then

        -- Missing minotaurs, find and kill
        -- @todo find through editor and remove
        for _, mon in Map.Monsters do
            if mon.Id == 103 then
                RemoveMonster(mon)
            end
        end
    elseif Game.Map.Name == "secret.blv" then
        MakeHostile(64,66) -- Gargoyle
        MakeHostile(79,81) -- Golems
    end

    -- Amber Map: Anti-fall through-roof bug workaround
    if Game.Map.Name == "amber.odm" then 
        if vars.MyTriggers.LuckyCoinSpawn == true then
            for _, obj in Map.Objects do
                if obj.Item.Number == 782 then
                    XYZ(obj, -3676, 6053, 456, 0)
                end
            end
        else
            vars.MyTriggers.LuckyCoinSpawn = true
            SummonItem(782,-3676, 6053, 456, 0)
        end
    end

    -- Comment about missing boat after completing Secret Hideout
    if Game.Map.Name == "amber-east.odm" then
        if vars.MyTriggers.ArchmageEscapedHideout == 1 then
            vars.MyTriggers.ArchmageEscapedHideout = 2
            evt.SetFacetBit(1338,const.FacetBits.Invisible,true)
	        evt.SetFacetBit(1338,const.FacetBits.Untouchable,true)
            Message("As you leave the secret hideout, a cool wind touches your face, hinting at urgency. You notice the boat that was once nearby is now missing. Far off, you see it near Castle Amber's Island, revealing the Archmage's escape route."..
                    "The chase isn't over yet, but now that you've pinpointed the Archmage's location, it's time to head back to town and report to the mayor."..
                    "The letter he left behind could serve as evidence of your encounter with the Archmage.")
        end

        -- Make back entrance to castle amber visible
        if vars.MyTriggers.AttackOnCastleAmber == 0 then
            evt.SetFacetBit(1337,const.FacetBits.Invisible,true)
        else
            evt.SetFacetBit(1337,const.FacetBits.Invisible,false)
        end

        -- Launch attack
        if vars.MyTriggers.AttackOnCastleAmber == 1 then

            vars.MyTriggers.AttackOnCastleAmber = 2
            
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

    -- Bushes

end

function events.BeforeNewGameAutosave()

    -- Clear inventory
    for id = 0, 1024 do
        for p = 0, Party.Count - 1 do
            if evt[p].Cmp("Inventory", id) then
               evt[p].Sub("Inventory", id)
            end
        end
    end

    -- Bow and repair for everyone
    -- PartySetSkill(const.Skills.Bow, 1, const.Novice)
    -- PartySetSkill(const.Skills.Repair, 10, const.GM)


    -- DEBUG: ID Monster / Item for everyone
    -- PartySetSkill(const.Skills.IdentifyItem, 10, const.GM)
    -- PartySetSkill(const.Skills.IdentifyMonster, 10, const.GM)

    -- Dump starting NPC
    evt.Sub("NPCs", 3)

    -- Move NPCs
    evt.MoveNPC(447,248)
    evt.MoveNPC(449,248)

    -- Clear emerald island quests
    for i = 1, 6 do
        Party.QBits[i] = false 
    end
end

--Game.NewGameMap = "test.odm"
--function events.NewGameMap()
--	XYZ(Party, 13131, 2869, 192)
--	Party.Direction = 1174
--	Party.LookAngle = -51
--end 

-- Helper Functions
function CheckInventoryForItem(id)
	for i = 0, Party.Count - 1 do
		if evt[i].Cmp("Inventory", id) then
			return true
		end
	end
	return false
end

function PlayerSetSkill(player, skillID, points, mastery)
    pl = Party[player]
    local mySkill, myMastery = SplitSkill(pl.Skills[skillID])
    pl.Skills[skillID]     = JoinSkill(math.max(mySkill, points), 
        math.max(myMastery, mastery))
end

function PlayerHasSkill(player, skillID)
    pl = Party[player]
    return pl.Skills[skillID] > 0
end

function PartySetSkill(skillID, points, mastery)
    for _, pl in Party do
        local mySkill, myMastery = SplitSkill(pl.Skills[skillID])
        pl.Skills[skillID]     = JoinSkill(math.max(mySkill, points), 
            math.max(myMastery, mastery))
    end
end
