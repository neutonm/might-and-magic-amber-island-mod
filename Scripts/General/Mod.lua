--[[
Description:    Global Mod Script
Author:         Henrik Chukhran, 2022 - 2026
]]

-- @todo make a list of travel points and use them instead of MoveTo with magic number arguments

-- DEBUG MODE (MOD)
Game.Debug                  = Game.Debug or false
local NEW_GAME_MAP          = "amber.odm"
local DEBUG_NEW_GAME_MAP    = "hub.blv"

-- New Game
Game.TitleTrack             = 22
Game.WinMapName             = "amber.odm"

-- MMerge Improved Pathfinding module
Game.ImprovedPathfinding    = true

function events.MenuAction(t)

    if t.Action == 54 then
        Game.NewGameMap = Game.Debug and DEBUG_NEW_GAME_MAP or NEW_GAME_MAP
    end
end

function events.Action(t)

    if t.Action == 124 and not t.Handled and mem.u4[0x6bdfb8] == 124 and Game.CurrentScreen == 1 then
		Game.NewGameMap = Game.Debug and DEBUG_NEW_GAME_MAP or NEW_GAME_MAP
	end
end

function events.NewGameMap(t)

    -- Start location
    if Game.NewGameMap == NEW_GAME_MAP then
        XYZ(Party,-17116,-21798,449)
    end
end

function events.GameInitialized2()

    -- End Game level fix
    Game.WinMapIndex = tostring(Game.MapStats.Find(Game.WinMapName))
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

    if path.ext(Game.Map.Name):lower() == ".odm" then
        LocalFile(Game.DecListBin)
        Game.DecListBin[34].SoundId = 0
    end
end

-- Disable intro movie
function events.ShowMovie(t)
    if t.Name:lower() == "intro post" or t.Name:lower() == "intro" then
        t.Allow = false
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)

end

function events.AfterLoadMap(WasInGame)

    local mapName = Game.Map.Name

    -- Enable god mode in dev dungeon
    if mapName == "hub.blv" then

        if vars.MiscGlobal and vars.MiscGlobal.DebugGodPending then
            vars.MiscGlobal.DebugGodPending = false
            if Game.Debug == true then
                god()
            end
        end
    end

    -- History book entries
    if vars.MiscGlobal and vars.MiscGlobal.FirstHistoryBookEntries == 0 then
        
        vars.MiscGlobal.FirstHistoryBookEntries = 1
        evt.Add("History30", 0)
        evt.Add("History31", 0)
        evt.Add("History32", 0)
    end
end

function events.BeforeNewGameAutosave()

    -- Difficulty
    vars.Difficulty = Game.SelectedDifficulty

    -- Amber Island Variables
    if vars.QuestsCore == nil then
        vars.QuestsCore = {
            ArchmageState           = 0,        -- (0) - n/a, (1) defeated, (2) offer accepted, (3) offer refused/killed, (4) contract shown
            ArchmageDialogueEnd     = 0,
        }
    end
    if vars.QuestsAmberIsland == nil then
        vars.QuestsAmberIsland = {
            QVar1                   = false,    -- Quest: The Fog
            QVarEndGame             = false,    -- Game End
            QVarRitual              = false,    -- Quest: Ritual, summon bool
            QVarRansom              = 0,        -- Quest: Ransom, state
            QVarRansomTaken         = false,    -- Quest: Ransom, NPC taken 
            QVarRevenge             = 0,        -- Quest: Revenge, state: given (1), duel (2), killed (3), 
                                                -- reporting (4), reported (5), released (6), rewarded (7)
            QVarGreeneRescued       = false,    -- Quest (Warrior): Legate
            QVarButlerEscaped       = 0,        -- Quest (Warrior): Investigation, state:
                                                -- escaped (1), taken (2), killed (3), hidden (4), imprisoned (5)
            QVarButlerHideHouseID   = 0,        -- House ID where butler was hidden by heroes
            QVarPirateWarrior       = 0,        -- Robert Stevenson Quest - Tree reached (warrior)
            QVarConradBrawl         = 0,        -- Quest (Warrior): Brawl, state:
                                                -- fight! (1), victory (2), failure (3), death (4), post failure (5)
            QVarConradWarning       = false,    -- Conrad one time warning for breaking brawl rules
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
            ClosedShops             = false,    -- Warrior Mode: Shops are closed until merchant guild fee is payed
            SecretHideoutClosed     = true,     -- Secret Hideout dungeon - closed without key (ID: 667)
            AppleCaveClosed         = true,     -- Warrior Mode: Apple Cave dungeon - closed without key (ID: 668)
            KnightCampTeleporter    = false,    -- Knight Camp Teleporter platform: activated with butler's medallion (true)
        }
    end

    -- Global variables
    if vars.QuestsGlobal == nil then
        vars.QuestsGlobal = {}
    end
    if vars.MiscGlobal == nil then
        vars.MiscGlobal = {
            FirstHistoryBookEntries = 0,        -- Show History book entries on game start
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

        -- Whoops, shop owners are discriminating against adventurers
        vars.MiscAmberIsland.ClosedShops = true

        evt.MoveNPC(540,251)    -- Thomas Guilden   (Bank)
        evt.MoveNPC(515,0)      -- Robert Greene    (Out of swamp camp)
        evt.MoveNPC(491,0)      -- Conrad Hawk      (Prison)
        evt.MoveNPC(547,250)    -- Conrad Hawk      (Inn)
    end

    -- Debug mode essentials
    if Game.Debug == true then
        Party.Gold = 99999
        Party.Food = 100
        vars.MiscGlobal.DebugGodPending = true
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
