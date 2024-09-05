--[[
Recreation of Town Hall's mechanics
Author: Henrik Chukhran, 2022 - 2024
]]

--[[
    ToDo:
        - Register Town Halls through data table at /Data/Tables
]]

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
    NPC_ID              = 0,
    TargetMonster_ID    = 0,
    TargetMonster_Name  = "<unknown>",
    MonsterList         = {},
    Bounty              = 0,
    BountyFlatBonus     = 100,
    BountyScaleBonus    = 1.0,
    BountyStatus        = const.TownHall.BountyStatus.Vacant,
    BountyTimeStart     = 0,
    BountyTimeRefill    = 2     -- days
}

-- Events
function events.BeforeLoadMap(WasInGame, WasLoaded)

    if vars.TownHallList == nil then
        vars.TownHallList = {}

        -- Default Amber Island Town Hall
        --! @todo Put it into data table in future
        Town = TownHall_NewTable({
            BountyFlatBonus = 250,
            BountyScaleBonus = 1.1,
            MonsterList = {
            34,35,36,37,38,39,40,41,42,46,47,48,64,
            65,66,67,68,69,
            73,74,75,
            79,80,81,
            199,200,201,
            214,215,216,250,
            265,266,267,268,269,270,277,278,279,}})
        TownHall_Register(Town, 535)
    end

    if vars.TownHallAccumulatedBounty == nil then
        vars.TownHallAccumulatedBounty = 0
    end
end

function events.PopulateNPCDialog(t, npc)

    -- Reset bounty if bounty is outdated
    for k, v in pairs(vars.TownHallList) do
        if t.Kind == "NPC" and t.Index == v.NPC_ID then
            if TownHall_IsBountyOutdated(v) then 
                TownHall_ResetBounty(v)
                Game.UpdateDialogTopics()
            end
        end
    end
end

function events.MonsterKilled(mon, monIndex, defaultHandler)
    
    if mon == nil then return end

    -- Confirm bounty kill
    for k, v in pairs(vars.TownHallList) do
        if v.BountyStatus == const.TownHall.BountyStatus.Pending and v.TargetMonster_ID == mon.Id then

            if TownHall_IsBountyOutdated(v) then
                v.BountyStatus                  = const.TownHall.BountyStatus.Fail
            else
                vars.TownHallAccumulatedBounty  = vars.TownHallAccumulatedBounty + v.Bounty 
                v.BountyStatus                  = const.TownHall.BountyStatus.Success

                if v.BountyTimeRefill == 0 then
                    TownHall_Refill(v)
                end

                break
            end
        end
    end
end

-- Functions

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

--! @brief  Retrieve TownHall from database via NPC ID
function TownHall_GetByID(NPC_ID)

    for _, v in pairs(vars.TownHallList) do
        if v.NPC_ID == NPC_ID then
            return v
        end
    end

    return nil
end

--! @brief Generate bounty and enlists party for the hunt
function TownHall_GenerateBountyTarget(TownHall)

    local approvedMonList = {}

    if TownHall == nil and TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return
    end

    -- Validate monster list
    local targetMon

    if #TownHall.MonsterList > 0 then

        -- Retrieve monsters from datatable
        for j, monTxt in Game.MonstersTxt do
            if ContainsNumber(TownHall.MonsterList, monTxt.Id) then
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
    TownHall.TargetMonster_ID   = targetMon.Id
    TownHall.TargetMonster_Name = targetMon.Name
    TownHall.BountyStatus       = const.TownHall.BountyStatus.Pending
    
    -- Generate bounty
    local function interpolateNumber(x, k)
        return x / (1 + k * x)
    end
    local filteredBounty = math.floor(interpolateNumber(targetMon.Experience, 0.0001))
    TownHall.Bounty = TownHall.BountyFlatBonus + filteredBounty + (targetMon.Level * 10)
    TownHall.Bounty = TownHall.Bounty * TownHall.BountyScaleBonus

    -- Fixate current date
    TownHall.BountyTimeStart = Game.Time

end

--! @brief Registers Town Hall (Clerk NPC) into town hall database
function TownHall_Register(TownHall, NPC_ID)

    if TownHall == nil and TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return
    end

    TownHall.NPC_ID = NPC_ID
    if vars.TownHallList ~= nil then
        table.insert(vars.TownHallList, TownHall)
    end
end

--! @brief  Resets current bounty, makes it available for participation once again
function TownHall_ResetBounty(TownHall)

    if TownHall == nil and TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return false
    end

    TownHall.TargetMonster_ID   = 0
    TownHall.TargetMonster_Name = "<unknown>"
    TownHall.Bounty             = 0
    TownHall.BountyStatus       = const.TownHall.BountyStatus.Vacant
end

--! @brief  Checks deadline status for current bounty
--! @return true if outdated
function TownHall_IsBountyOutdated(TownHall)

    if TownHall == nil and TownHall.NPC_ID == nil then
        if Game.Debug then
            debug.Message("Invalid \'TownHall\'")
        end
        return false
    end

    if TownHall.BountyStatus ~= const.TownHall.BountyStatus.Vacant and TownHall.BountyTimeRefill > 0 then

        local timeDifference = Game.Time - TownHall.BountyTimeStart
        if timeDifference > (TownHall.BountyTimeRefill * const.Day) then
            return true
        end
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
