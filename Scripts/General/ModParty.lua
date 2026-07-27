--[[
Description:    Party helpers
Author:         Henrik Chukhran, 2022 - 2026

Features:

    - 'Last Standing' -> deny death
]]


------------------------------------------------------------------------------
-- LOCAL VARS
------------------------------------------------------------------------------

local lastStandingTrackingEnabled   = false
local lastStandingSlot              = nil

local incapacitatingConditions      = {
    const.Condition.Asleep,
    const.Condition.Paralyzed,
    const.Condition.Unconscious,
    const.Condition.Dead,
    const.Condition.Stoned,
    const.Condition.Eradicated,
}


------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
------------------------------------------------------------------------------

local function TrackLastStanding()
    local found = nil

    for slot, pl in Party.Players do
        if pl:IsConscious() then
            if found ~= nil then
                lastStandingSlot = nil
                return
            end

            found = slot
        end
    end

    if found ~= nil then
        lastStandingSlot = found
    end
end

------------------------------------------------------------------------------
-- PUBLIC API
------------------------------------------------------------------------------

function ModParty_SetLastStandingTracking(enabled)
    enabled = enabled == true

    if enabled == lastStandingTrackingEnabled then
        return
    end

    lastStandingTrackingEnabled = enabled
    lastStandingSlot            = nil

    if enabled then
        events.Add("Tick", TrackLastStanding)
        events.Add("PlayerAttacked", TrackLastStanding)
        TrackLastStanding()
    else
        events.Remove("Tick", TrackLastStanding)
        events.Remove("PlayerAttacked", TrackLastStanding)
    end
end

function ModParty_IsLastStandingTrackingEnabled()
    return lastStandingTrackingEnabled
end

function ModParty_GetLastStanding()
    if not lastStandingTrackingEnabled or lastStandingSlot == nil then
        return nil
    end

    return Party[lastStandingSlot], lastStandingSlot
end

function ModParty_DenyDeath(t, hp)

    if not lastStandingTrackingEnabled or
       t == nil or
       t.Action ~= const.ExitMapAction.Death then
        return false
    end

    local slot = lastStandingSlot or 0
    local pl   = Party[slot]

    for _, condition in ipairs(incapacitatingConditions) do
        pl.Conditions[condition] = 0
    end

    pl.HP = math.max(pl.HP, hp or 1)

    Game.CurrentPlayer  = slot
    Game.NeedRedraw     = true

    t.Action     = const.ExitMapAction.None
    t.NextAction = const.ExitMapAction.None

    pl:ShowFaceAnimation(const.FaceAnimation.CheatedDeath)

    return true, pl, slot
end

--[[ EXAMPLE USAGE

ModParty_SetLastStandingTracking(true)

function events.ExitMapAction(t)
    if ModParty_DenyDeath(t, 1) then
        debug.Message("death denied")
    end
end

function events.LeaveMap()
    ModParty_SetLastStandingTracking(false)
end

]]