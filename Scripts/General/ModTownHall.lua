--[[
Recreation of Town Hall's mechanics
Author: Henrik Chukhran, 2022 - 2024
]]

--[[
    ToDo:
        - Register Town Halls through data table at /Data/Tables
]]

local INHERIT_MARKER    = "$"

------------------------------------------------------------------------------
-- GLOBAL
------------------------------------------------------------------------------

TownHallDB = {}

-- Const
const.TownHall          = {
    BountyStatus        = {
        Vacant          = 0,
        Pending         = 1,
        Fail            = 2,
        Success         = 3,
    }
}

-- Structures
STownHall               = {
    ID                  = "default",
    NPC_ID              = 0,
    Map                 = "amber.odt",
    X                   = 0,
    Y                   = 0,
    Z                   = 0,

    BountyFlatBonus     = 100,
    BountyFlatBonusW    = INHERIT_MARKER,

    BountyScaleBonus    = 1.0,
    BountyScaleBonusW   = INHERIT_MARKER,

    BountyTimeRefill    = 2,    -- days
    BountyTimeRefillW   = INHERIT_MARKER,

    BountyCooldown      = 30,   -- days after completed bounty
    BountyCooldownW     = INHERIT_MARKER,

    MonsterList         = {},
    MonsterListW        = INHERIT_MARKER,
}

STownHallSchema         = {
    ID                  = { type = "string", required = true },
    NPC_ID              = { type = "number", required = true },

    Map                 = { type = "string" },
    X                   = { type = "number" },
    Y                   = { type = "number" },
    Z                   = { type = "number" },

    BountyFlatBonus     = { type = "number" },
    BountyFlatBonusW    = { type = "number_or_string" },

    BountyScaleBonus    = { type = "number" },
    BountyScaleBonusW   = { type = "number_or_string" },

    BountyTimeRefill    = { type = "number" },
    BountyTimeRefillW   = { type = "number_or_string" },

    BountyCooldown      = { type = "number" },
    BountyCooldownW     = { type = "number_or_string" },

    MonsterList         = { parse = TableLoader.CSVNumber },
    MonsterListW        = { parse = TableLoader.CSVNumberOrInherit },
}

-- Save file structure
STownHallState          = {
    ID                  = "default",
    TargetMonster_ID    = 0,
    TargetMonster_Name  = "<unknown>",
    Bounty              = 0,
    BountyStatus        = const.TownHall.BountyStatus.Vacant,
    BountyTimeStart     = 0,
    BountyTimeCompleted = 0
}

TownHallTxt             = LocalizeAll{

    TParticipateTopic   = "Bounty Hunt: Participate!",
    TStatusTopic        = "Bounty Hunt: Status",
    TBountyHuntNATopic  = "Bounty Hunt: n\\a",
    TCollectBountyTopic = "Collect Bounty \01265523(%dg)",
    TPayFineTopic       = "Pay Fine \01265523(%dg)",

    TBountyStart        = "This month's bounty is on a \01265523%s\01200000. \n\nKill it before the deadline and return to collect \01265523%d\01200000 gold reward.",
    TTimeLeft           = "You have \01265523%s\01200000 to complete the hunt.",
    TComeBackLater      = "No new bounty is available right now.\n\nCome back in \01265523%s\01200000 for another bounty.",
    TComeBackSoon       = "A new bounty will be available soon.",
    TComeBackDays       = "%d days",
    TComeBackHours      = "%d hours",
}

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local function TownHall_ResolveWarriorList(normalValue, warriorValue)

    if IsWarrior() then
        if warriorValue == INHERIT_MARKER then
            return normalValue
        end

        if warriorValue ~= nil then
            return warriorValue
        end
    end

    return normalValue
end

------------------------------------------------------------------------------
-- GLOBAL
------------------------------------------------------------------------------

-- @todo resolvers needs to be global and not struct related
function TownHall_ResolveWarriorValue(normalValue, warriorValue)

    if IsWarrior() then
        if warriorValue == INHERIT_MARKER then
            return normalValue
        end
        return warriorValue
    end

    return normalValue
end

--! @brief      Returns copy of STownHall
--! @param  t   Table modifications
function TownHall_NewTable(t)

    if t == nil then
        t = {}
    end

    local TownHall = table.copy(STownHall)
    for key, value in pairs(t) do
        TownHall[key] = value
    end
    return TownHall
end

--! @brief Generate bounty and enlists party for the hunt
function TownHall_GenerateBountyTarget(TownHall)

    local approvedMonList = {}

    if TownHall == nil or TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return
    end

    -- Validate monster list
    local targetMon
    local monsterList = TownHall_ResolveWarriorList(TownHall.MonsterList, TownHall.MonsterListW)

    if monsterList ~= nil and #monsterList > 0 then

        -- Retrieve monsters from datatable
        for j, monTxt in Game.MonstersTxt do
            if ContainsNumber(monsterList, monTxt.Id) then
                table.insert( approvedMonList, monTxt )
            end
        end

        if #approvedMonList == 0 then
            if Game.Debug then
                debug.Message("Invalid IDs in \'approvedMonList\'\n\napprovedMonList type: "..type(approvedMonList).."\n"..dump(approvedMonList))
            end
            return 
        end

        -- Choose monster
        if #approvedMonList > 1 then
            math.randomseed(os.time())
            targetMon = approvedMonList[math.random(#approvedMonList)]
        else
            targetMon = approvedMonList[1]
        end
    else
        -- Pick any monster
        local count = 0
        for _, value in Game.MonstersTxt do
            count = count + 1
        end
        targetMon = Game.MonstersTxt[math.random(1,count)]
    end

    -- Apply
    local state                 = TownHall_GetState(TownHall)
    state.TargetMonster_ID      = targetMon.Id
    state.TargetMonster_Name    = targetMon.Name
    state.BountyStatus          = const.TownHall.BountyStatus.Pending
    
    -- Generate bounty
    local function interpolateNumber(x, k)
        return x / (1 + k * x)
    end
    local filteredBounty        = math.floor(interpolateNumber(targetMon.Experience, 0.0001))
    local flatBonus             = TownHall_ResolveWarriorValue(TownHall.BountyFlatBonus,  TownHall.BountyFlatBonusW)
    local scaleBonus            = TownHall_ResolveWarriorValue(TownHall.BountyScaleBonus, TownHall.BountyScaleBonusW)
    state.Bounty                = flatBonus + filteredBounty + (targetMon.Level * 10)
    state.Bounty                = math.floor(state.Bounty * scaleBonus)

    -- Fixate current date
    state.BountyTimeStart       = Game.Time
end

--! @brief Registers Town Hall (Clerk NPC) into town hall database
function TownHall_Register(TownHall, NPC_ID)

    if TownHall == nil then
        if Game.Debug then
            debug.Message("Invalid 'TownHall'")
        end
        return
    end

    TownHall.NPC_ID = NPC_ID or TownHall.NPC_ID

    if TownHall.NPC_ID == nil or TownHall.NPC_ID == 0 then
        if Game.Debug then
            debug.Message("Invalid 'TownHall.NPC_ID'")
        end
        return
    end

    table.insert(TownHallDB, TownHall)
end

--! @brief  Resets current bounty, makes it available for participation once again
function TownHall_ResetBounty(TownHall)

    if TownHall == nil or TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return false
    end

    local state                 = TownHall_GetState(TownHall)
    state.TargetMonster_ID      = 0
    state.TargetMonster_Name    = "<unknown>"
    state.Bounty                = 0
    state.BountyStatus          = const.TownHall.BountyStatus.Vacant
end

--! @brief  Checks deadline status for current bounty
--! @return true if outdated
function TownHall_IsBountyOutdated(TownHall)

    if TownHall == nil or TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid 'TownHall'")
        end
        return false
    end

    local state             = TownHall_GetState(TownHall)
    local bountyTimeRefill  = TownHall_ResolveWarriorValue(TownHall.BountyTimeRefill, TownHall.BountyTimeRefillW)

    if state.BountyStatus == const.TownHall.BountyStatus.Pending and bountyTimeRefill > 0 then
        local timeDifference = Game.Time - state.BountyTimeStart
        return timeDifference > (bountyTimeRefill * const.Day)
    end

    return false
end

--! @brief  Pays off accumulated reward for the bounty(s)
function TownHall_Payout()

    if vars.TownHallAccumulatedBounty == 0 then return false end

    evt.Add("Gold", vars.TownHallAccumulatedBounty)
    vars.TownHallAccumulatedBounty = 0

    return true
end

--! @brief  Substitute for vanila Town Halls "Pay Fine"
function TownHall_PayFine()

    if Party.Fine == 0 then return end -- Prevents "gold pickup" sound

    if evt.Cmp("Gold", Party.Fine) then
        evt.Subtract("Gold", Party.Fine)
        Party.Fine = 0
    end
end

function TownHall_FindByID(id)

    for i = 1, #TownHallDB do
        if TownHallDB[i] ~= nil and TownHallDB[i].ID == id then
            return TownHallDB[i]
        end
    end

    return nil
end

function TownHall_FindByNPC(NPC_ID)

    for i = 1, #TownHallDB do
        local v = TownHallDB[i]
        if v ~= nil and v.NPC_ID == NPC_ID then
            return v
        end
    end

    return nil
end

function TownHall_GetState(townHall)

    local id
    local th = townHall

    if type(townHall) == "string" then
        th = TownHall_FindByID(townHall)
    end

    if th == nil then
        return nil
    end

    id = th.ID

    vars.TownHallStateList = vars.TownHallStateList or {}

    if vars.TownHallStateList[id] == nil then
        vars.TownHallStateList[id] = table.copy(STownHallState)
        vars.TownHallStateList[id].ID = id
    end

    return vars.TownHallStateList[id]
end

function TownHall_GetBountyCooldown(TownHall)

    return TownHall_ResolveWarriorValue(
        TownHall.BountyCooldown,
        TownHall.BountyCooldownW
    )
end

function TownHall_GetCooldownTimeLeft(TownHall)

    local state     = TownHall_GetState(TownHall)
    local cooldown  = TownHall_GetBountyCooldown(TownHall)

    if state == nil or cooldown == nil or cooldown <= 0 then
        return 0
    end

    return (state.BountyTimeCompleted + cooldown * const.Day) - Game.Time
end

function TownHall_GetContext(npc)
    local Town = TownHall_FindByNPC(npc)
    if Town == nil then
        if Game.Debug then
            debug.Message("nil Town for %s npc.", tostring(npc))
        end
    end
    return Town, TownHall_GetState(Town)
end

function TownHall_ParseTables(Table)
    return TableLoader.ParseFile{
        Path             = "Data/Tables/TownHalls.txt",
        Schema           = STownHallSchema,
        Defaults         = STownHall,
        Out              = Table,
        KeyField         = "ID",
        DetectDuplicates = true,
    }
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.GameInitialized2()
    TownHall_ParseTables(TownHallDB)
end

function events.BeforeLoadMap(WasInGame, WasLoaded)

    vars.TownHallStateList          = vars.TownHallStateList or {}
    vars.TownHallAccumulatedBounty  = vars.TownHallAccumulatedBounty or 0

    for i = 1, #TownHallDB do
        local th = TownHallDB[i]
        if th ~= nil and vars.TownHallStateList[th.ID] == nil then
            vars.TownHallStateList[th.ID] = table.copy(STownHallState)
            vars.TownHallStateList[th.ID].ID = th.ID
        end
    end
end

function events.PopulateNPCDialog(t, npc)

    -- Reset bounty if bounty is outdated
    for i = 1, #TownHallDB do
        local v = TownHallDB[i]
        if t.Kind == "NPC" and t.Index == v.NPC_ID then
            local state = TownHall_GetState(v)
            if TownHall_IsBountyOutdated(v) then
                TownHall_ResetBounty(v)
                Game.UpdateDialogTopics()
            elseif state.BountyStatus == const.TownHall.BountyStatus.Success and TownHall_GetCooldownTimeLeft(v) <= 0 then
                TownHall_ResetBounty(v)
                Game.UpdateDialogTopics()
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)
    
    if mon == nil then return end

    -- Confirm bounty kill
    for i = 1, #TownHallDB do
        local v     = TownHallDB[i]
        local state = TownHall_GetState(v)

        if state.BountyStatus == const.TownHall.BountyStatus.Pending and state.TargetMonster_ID == mon.Id then

            if TownHall_IsBountyOutdated(v) then
                state.BountyStatus              = const.TownHall.BountyStatus.Fail
            else
                vars.TownHallAccumulatedBounty  = vars.TownHallAccumulatedBounty + state.Bounty 

                state.BountyStatus              = const.TownHall.BountyStatus.Success
                state.BountyTimeCompleted       = Game.Time

                break
            end
        end
    end
end
