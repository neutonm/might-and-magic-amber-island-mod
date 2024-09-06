--[[
Global Mod Script
Author: Henrik Chukhran, 2022 - 2024
]]

-- @todo make a list of travel points and use them instead of MoveTo with magic number arguments

-- DEBUG MODE (MOD)
Game.Debug      = false

-- New Game
Game.NewGameMap = Game.Debug and "hub.blv" or "amber.odm"
Game.TitleTrack = 22

function events.NewGameMap()
    
    XYZ(Party,-17116,-21798,449)
end 

function events.DeathMap(t)

    local loc = vars.MiscGlobal.OnDeathLocation

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

    ArcomageRequireDeck(false)

    -- Debug mode essentials
    if Game.Debug == true then
        evt.Add("Gold",99999)
        Party.Food = 100
        god()
    end

    if path.ext(Game.Map.Name):lower() == ".odm" then 
        LocalFile(Game.DecListBin)
        Game.DecListBin[34].SoundId = 0
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)
    
end

function events.AfterLoadMap(WasInGame)

    -- Temporary: Hostiles
    if Game.Map.Name == "out02.odm" then

        if vars.QuestsAmberIsland.QVarEndGame == 1 then
            -- @todo change endgame start location and clear this workaround
            vars.QuestsAmberIsland.QVarEndGame = 2
            Timer(function()
                evt.MoveToMap{
                    X = 3684, Y = 8941, Z = 120, 
                    Direction = 1024, LookAngle = 0, SpeedZ = 0, 
                    HouseId = 0, Icon = 0, Name = "amber.odm"}
            end, const.Second, Game.Time + const.Second, false)
            
        end
    end
end

function events.BeforeNewGameAutosave()

    -- Difficulty
    if vars.Difficulty == nil then
        vars.Difficulty = Game.SelectedDifficulty
    end

    -- Amber Island Variables
    if vars.QuestsAmberIsland == nil then
        vars.QuestsAmberIsland = {
            QVar1                   = false,    -- Quest: The Fog
            QVarEndGame             = false,    -- Game End
            QVarRitual              = false,    -- Quest: Ritual, summon bool
            QVarRansom              = 0,        -- Quest: Ransom, state
            QVarRansomTaken         = false,    -- Quest: Ransom, NPC taken 
            QVarRevenge             = 0,        -- Quest: Revenge, state: given (1), duel (2), killed (3), 
                                                -- reporting (4), reported (5), released (6), rewarded (7)
        }
    end
    if vars.MiscAmberIsland == nil then
        vars.MiscAmberIsland = {
            BulkCurePotionSale      = true,     -- Jane Goodwin, 8x cure potion for 500g
            BulkManaPotionSale      = true,     -- Jane Goodwin, 8x mana potion for 500g
            ArenaCounterStarted     = false,    -- Arena cooldown (Cedrick Boyce) (0 = ready)
            LuckyCoinSpawn          = false,    -- Workaround fix for spawned coin falling through roof
            ArchmageEscapedHideout  = 0,        -- Story Quest: Secret Hideout. Plot phase.
            AttackOnCastleAmber     = 0,        -- Story Quest: The Mist. Launch knight attack upon goblins.
        }
    end

    -- Global variables
    if vars.QuestsGlobal == nil then
        vars.QuestsGlobal = {}
    end
    if vars.MiscGlobal == nil then
        vars.MiscGlobal = {
            FirstTimePlaying        = 0,        -- for "Sir Henry" message at startup
            OnDeathLocation         = 0,        -- Variable for resurrection locations
        }
    end

    -- Warrior mode startup adjustments
    if IsWarrior() then

        -- No stuff
        Party.Gold         = 0
        Party.Food         = 2
        
        -- Clear inventory
        for id = 0, 1024 do
            for p = 0, Party.Count - 1 do
                if evt[p].Cmp("Inventory", id) then
                evt[p].Sub("Inventory", id)
                end
            end
        end
    end

    -- Debug mode essentials
    if Game.Debug == true then
        Party.Gold = 99999
        Party.Food = 100
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
