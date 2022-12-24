-- Game.NewGameMap = "testlevel.blv"
-- function events.NewGameMap()
-- 	XYZ(Party, 395, 343, 192)
-- 	Party.Direction    = 1262
-- 	Party.LookAngle    = 14
-- 	Party.Gold         = 0
-- 	Party.Food         = 2
-- end 

Game.NewGameMap = "amber.odm"
function events.NewGameMap()
    XYZ(Party, -15484, -21868, 256)
    Party.Direction    = 649
    Party.LookAngle    = 1
    Party.Gold         = 0
    Party.Food         = 2
end 

function events.DeathMap(t)
    t.Name = "testlevel.blv"
    XYZ(Party, 395, 343, 192)
    Party.Direction     = 1262
    Party.LookAngle     = 14
end

function events.BeforeLoadMap(WasInGame, WasLoaded)
    if not WasInGame and not WasLoaded then
        -- Quest Variables
        vars.MyQuests = 
        {
            QVar1       = false,            -- Quest: The Fog
            QVarEndGame = false             -- Game End
        }
    end
    if path.ext(Game.Map.Name):lower() == ".odm" then 
        LocalFile(Game.DecListBin)
        Game.DecListBin[34].SoundId = 0
    end
end

-- Temporary: Make golems hostile
function events.AfterLoadMap(WasInGame)
    for _, mon in Map.Monsters do
        if mon.Id >= 79 and mon.Id <= 81 then
            mon.Hostile = true
        end
    end
end

function PartySetSkill(skillID, points, mastery)
    for _, pl in Party do
        local mySkill, myMastery = SplitSkill(pl.Skills[skillID])
        pl.Skills[skillID]     = JoinSkill(math.max(mySkill, points), 
            math.max(myMastery, mastery))
    end
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
    PartySetSkill(const.Skills.Bow, 1, const.Novice)
    PartySetSkill(const.Skills.Repair, 10, const.GM)


    -- DEBUG: ID Monster / Item for everyone
    PartySetSkill(const.Skills.IdentifyItem, 10, const.GM)
    PartySetSkill(const.Skills.IdentifyMonster, 10, const.GM)

    -- Dump starting NPC
    evt.Sub("NPCs", 3)

    -- Move NPCs
    evt.MoveNPC(447,74)
    evt.MoveNPC(449,74)

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
