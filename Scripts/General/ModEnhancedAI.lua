--[[
Description:    Enhanced AI
Author:         Henrik Chukhran, 2022 - 2026

Adds script-controlled movement and follower behavior for map monsters.
Used for mercenary-style NPCs, patrol routes, move orders, and simple 
combat-aware following.

Notes:
    -   Runtime state is stored in mapvars because controlled monsters belong to 
        the current map.
    -   it's best to focus on global function when utilizing delegates/predicates.
        These functions won't be saved in mapvars
    -   Indoor level are often too narrow so the distance

Todo:

    -   when set in follow mod, allow monsters to transfer between maps/dungeons
    -   needs refactor, there arre useless vars/functions out there...
    -   Sometimes AI can't walk through small gaps such elevator platform at
        applecave (first one behind the grated door, when on first floor)
    -   could use better pathfinding algorithm, check the pathfinder dll from
        mmerge
    -   -   sometimes gets stuck between sprite and some narrow passage 
            (box + lantern)
    -   make NPC untouchable when in close distance to prevent narrow passage
        blockage
    -   yelling causes (assumingly) unwanted effects
]]

------------------------------------------------------------------------------
-- GLOBALS
------------------------------------------------------------------------------

const.FollowerMode = const.FollowerMode or {
    Hold                        = 0,
    OffensiveFollow             = 1,
    DefensiveFollow             = 2,
    PassiveFollow               = 3,
}

const.FollowerState = const.FollowerState or {
    NativeIdle                  = 0,
    Following                   = 1,
    CombatLocked                = 2,
}

const.FollowerTarget = const.FollowerTarget or {
    Party                       = 0,
    Monster                     = 1,
    Point                       = 2,
    PredicateMonster            = 3,
    ModID                       = 4,
    Waypoints                   = 5,
}

const.WaypointMode = const.WaypointMode or {
    Once                        = 0,
    Return                      = 1,
    PingPong                    = 2,
}

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local ModAIConfig = {
    SchemaVersion               = 2,
    DungeonFollowScale          = 2.5,
    MaxGroundSnapDown           = 96,
    WaterBridgeClearance        = 64,
    Defaults                    = {
        MoveSpeed               = 350,
        StepSpeed               = 7,
        FollowDistance          = 384,
        ResumeDistance          = 768,
        CombatRadius            = 1536,
        MoveMoveType            = 0,
        IdleMoveType            = 3,
        PassiveIdleMoveType     = 5,
        WaypointDistance        = 64,
        WaypointTicksPerSecond  = 30,
        Mode                    = const.FollowerMode.DefensiveFollow,
    },
}

local RuntimePredicates         = {}
local RuntimeFinishCallbacks    = {}
local RuntimeCombatScans        = {}
local RuntimeBlockedUntil       = {}
local RuntimeAvoidanceSide      = {}
local RuntimeTick               = 0

-------------------------------------------------------------------------------

local function getDB()

    mapvars.ModAIDB             = mapvars.ModAIDB or {}
    mapvars.ModAIDB.Actors      = mapvars.ModAIDB.Actors or {}

    return mapvars.ModAIDB
end

local function findMonsterArrayIndex(monster)

    if not monster then
        return nil
    end

    local monsterPtr = monster["?ptr"]
    for i = 0, Map.Monsters.Count - 1 do
        local mon = Map.Monsters[i]
        if mon == monster or mon["?ptr"] == monsterPtr then
            return i
        end
    end

    return nil
end

local function getMonsterByArrayIndex(index)

    index = tonumber(index)

    if not index or index < 0 or index >= Map.Monsters.Count then
        return nil
    end

    return Map.Monsters[index]
end

local function isDeadOrUnavailable(mon)
    return not mon
        or mon.HP <= 0
        or mon.AIState == const.AIState.Dying
        or mon.AIState == const.AIState.Dead
        or mon.AIState == const.AIState.Removed
end

local function isValidTargetMonster(mon)
    return not isDeadOrUnavailable(mon)
end

local function getEntry(mon)

    local index     = findMonsterArrayIndex(mon)
    local actors    = nil
    local entry     = nil

    if not index then
        return nil
    end

    actors          = getDB().Actors
    entry           = actors[index] or actors[tostring(index)]

    return entry, index
end

local function removeEntry(index)

    local actors = nil

    if index == nil then
        return
    end

    actors       = getDB().Actors

    actors[index]             = nil
    actors[tostring(index)]   = nil
end

local function enableTracking(entry)

    if entry.Mode == const.FollowerMode.Hold then
        entry.Mode = ModAIConfig.Defaults.Mode
    end

    entry.Tracking      = true
    entry.TargetIndex   = nil
end

local function applyDefaults(entry, mon, options)

    local dungeonFollowDistance = nil

    for key, value in pairs(ModAIConfig.Defaults) do
        if entry[key] == nil then
            entry[key] = value
        end
    end

    if Map.IsIndoor() then

        dungeonFollowDistance = math.max(1, math.floor(ModAIConfig.Defaults.FollowDistance / ModAIConfig.DungeonFollowScale))

        if entry.FollowDistance == ModAIConfig.Defaults.FollowDistance and not (options and options.FollowDistance) then
            entry.FollowDistance   = dungeonFollowDistance
        end

        if entry.ResumeDistance == ModAIConfig.Defaults.ResumeDistance and not (options and options.ResumeDistance) then
            entry.ResumeDistance   = math.max(dungeonFollowDistance + 1, math.floor(ModAIConfig.Defaults.ResumeDistance / ModAIConfig.DungeonFollowScale))
        end
    end

    entry.OriginalMoveType  = entry.OriginalMoveType or mon.MoveType
    entry.State             = entry.State or const.FollowerState.NativeIdle
    entry.TargetType        = entry.TargetType or const.FollowerTarget.Party
    entry.WaypointDirection = entry.WaypointDirection or 1
    entry.WaypointMode      = entry.WaypointMode or const.WaypointMode.Once

    if options then
        for key, value in pairs(options) do
            entry[key] = value
        end
    end

    entry.SchemaVersion     = ModAIConfig.SchemaVersion
end

local function setEntryTarget(entry, x, y, z)

    local target = entry.Target

    if target then
        target.X    = x
        target.Y    = y
        target.Z    = z
    else
        target          = {X = x, Y = y, Z = z}
        entry.Target    = target
    end

    return target
end

local function makeFriendly(mon)

    mon.Hostile         = false
    mon.NoFlee          = true
    mon.ShowOnMap       = true
    mon.ShowAsHostile   = false
    mon.OnAlertMap      = false
    mon.Ally            = 9999
    mon.HostileType     = 0
    mon.LastAttacker    = 0
    mon.Group           = 35
end

local function setAnchor(mon, target)

    mon.GuardX          = target.X
    mon.GuardY          = target.Y
    mon.GuardZ          = target.Z
    mon.GuardRadius     = 32000
    mon.StartX          = target.X
    mon.StartY          = target.Y
    mon.StartZ          = target.Z
end

local function distanceSquaredBetween(a, b)

    local dx = b.X - a.X
    local dy = b.Y - a.Y
    local dz = b.Z - a.Z

    return dx * dx + dy * dy + dz * dz
end

local function isWaterTileAt(x, y)

    local tileBin   = nil
    local tile      = nil
    local tileDef   = nil
    local tileX     = nil
    local tileY     = nil

    if Map.IsIndoor() then
        return false
    end

    tileX = math.floor(64 + x / 0x200)
    tileY = math.floor(64 - y / 0x200)

    if tileX < 0 or tileX > 127 or tileY < 0 or tileY > 127 then
        return false
    end

    tile    = Map.TileMap[tileY][tileX]
    tileBin = Game.CurrentTileBin or Game.TileBin
    tileDef = tileBin and tileBin[tile]

    return tileDef and tileDef.Water
end

local function getFloorAt(x, y, z)

    local floorZ    = nil
    local room      = Map.RoomFromPoint(x, y, z)

    floorZ          = Map.GetFloorLevel(x, y, z, room)

    if (not floorZ or floorZ <= -30000) and not Map.IsIndoor() then
        floorZ      = Map.GetGroundLevel(x, y)
        room        = 0
    end

    return floorZ, room
end

local function isWaterBlockedAt(x, y, floorZ)

    local groundZ = nil

    if not isWaterTileAt(x, y) then
        return false
    end

    floorZ = floorZ or -30000
    groundZ = Map.GetGroundLevel(x, y)

    return floorZ <= -30000 or floorZ - groundZ < ModAIConfig.WaterBridgeClearance
end

local function applyFloorZ(mon, floorZ, z)

    if not floorZ or floorZ <= -30000 then
        mon.Z       = z
        return
    end

    if floorZ >= z or z - floorZ <= ModAIConfig.MaxGroundSnapDown then
        mon.Z       = floorZ
    else
        mon.Z       = z
    end
end

local function placeOnGround(mon, x, y, z)

    local floorZ    = nil
    local room      = nil

    floorZ, room    = getFloorAt(x, y, z)

    if isWaterBlockedAt(x, y, floorZ) then
        return false
    end

    mon.X           = x
    mon.Y           = y
    mon.Room        = room

    applyFloorZ(mon, floorZ, z)

    return true
end

local function tryMoveBy(mon, stepX, stepY)

    if stepX == 0 and stepY == 0 then
        return false
    end

    return placeOnGround(mon, mon.X + stepX, mon.Y + stepY, mon.Z)
end

local function fixRoomAndFloor(mon)

    local floorZ    = nil
    local room      = nil

    floorZ, room    = getFloorAt(mon.X, mon.Y, mon.Z)

    mon.Room        = room

    applyFloorZ(mon, floorZ, mon.Z)
end

local function faceVector(mon, dx, dy)

    local angle     = nil

    if dx == 0 and dy == 0 then
        return
    end

    angle           = math.atan2 and math.atan2(dy, dx) or math.atan(dy, dx)
    mon.Direction   = math.floor(angle * 2048 / (2 * math.pi)) % 2048
end

local function isInterruptible(mon)
    return mon.AIState == const.AIState.Stand
        or mon.AIState == const.AIState.Active
        or mon.AIState == const.AIState.Fidget
        or mon.AIState == const.AIState.Interact
end

local function isRecoverableFinishedAction(mon)
    return mon.AIState == const.AIState.Stunned
end

local function isCombatAction(mon)
    return mon.AIState == const.AIState.MeleeAttack
        or mon.AIState == const.AIState.RangedAttack
        or mon.AIState == const.AIState.RangedAttack2
        or mon.AIState == const.AIState.CastSpell
        or mon.AIState == const.AIState.RangedAttack4
end

local function isHostileToFollower(follower, other)

    local ok        = nil
    local attitude  = nil

    if isDeadOrUnavailable(other) or other == follower then
        return false
    end

    ok, attitude = pcall(function()
        return follower:IsAgainst(other)
    end)

    return ok and attitude and attitude > 0
end

local function hasNearbyHostiles(follower, radius, entry)

    local index     = entry and entry.MonsterIndex or nil
    local cache     = index and RuntimeCombatScans[index] or nil
    local radiusSq  = radius * radius

    if cache and cache.Tick > RuntimeTick then
        return cache.Result, cache.TargetIndex
    end

    for i = 0, Map.Monsters.Count - 1 do
        local other = Map.Monsters[i]

        if not isDeadOrUnavailable(other)
            and other ~= follower
            and distanceSquaredBetween(follower, other) <= radiusSq
            and isHostileToFollower(follower, other)
        then
            if index then
                RuntimeCombatScans[index] = {Tick = RuntimeTick + 5, Result = true, TargetIndex = i}
            end

            return true, i
        end
    end

    if index then
        RuntimeCombatScans[index] = {Tick = RuntimeTick + 5, Result = false, TargetIndex = nil}
    end

    return false
end

local function releaseToNativeIdle(entry, mon, moveType)

    if not mon then
        return
    end

    makeFriendly(mon)

    mon.MoveType            = moveType or entry.IdleMoveType
    mon.VelocityX           = 0
    mon.VelocityY           = 0
    mon.VelocityZ           = 0
    mon.Velocity            = mon.MoveSpeed
    mon.AIState             = const.AIState.Stand
    mon.CurrentActionLength = 0
    mon.CurrentActionStep   = 0

    mon:UpdateGraphicState()
end

local function releaseToHoldIdle(entry, mon)
    releaseToNativeIdle(entry, mon, entry.OriginalMoveType or entry.MoveMoveType)
end

local function releaseToFollowIdle(entry, mon)
    local moveType = entry.Mode == const.FollowerMode.PassiveFollow
        and entry.PassiveIdleMoveType
        or entry.IdleMoveType
    releaseToNativeIdle(entry, mon, moveType)
end

local function prepareForMove(entry, mon, target)

    makeFriendly(mon)
    setAnchor(mon, target)

    mon.MoveType            = entry.MoveMoveType
    mon.MoveSpeed           = entry.MoveSpeed
    mon.Velocity            = entry.MoveSpeed
    mon.AIState             = const.AIState.Active
    mon.CurrentActionLength = 256
    mon.CurrentActionStep   = 0
    mon.GraphicState        = 1
end

local function driveDirect(entry, mon, dx, dy, dz, dist)

    local side      = nil

    if entry.Mode == const.FollowerMode.Hold or entry.State ~= const.FollowerState.Following then
        return
    end

    local step      = math.min(entry.StepSpeed, dist)
    local stepX     = math.floor(dx * step / dist)
    local stepY     = math.floor(dy * step / dist)

    mon.VelocityX   = 0
    mon.VelocityY   = 0

    if tryMoveBy(mon, stepX, stepY) then
        return
    end

    side = -(RuntimeAvoidanceSide[entry.MonsterIndex] or 1)
    RuntimeAvoidanceSide[entry.MonsterIndex] = side

    if side > 0 then
        if tryMoveBy(mon, -stepY, stepX) then
            return
        end

        if tryMoveBy(mon, stepY, -stepX) then
            return
        end
    else
        if tryMoveBy(mon, stepY, -stepX) then
            return
        end

        if tryMoveBy(mon, -stepY, stepX) then
            return
        end
    end

    if tryMoveBy(mon, stepX, 0) then
        return
    end

    if tryMoveBy(mon, 0, stepY) then
        return
    end

    RuntimeBlockedUntil[entry.MonsterIndex]     = RuntimeTick + 2

    releaseToFollowIdle(entry, mon)
    fixRoomAndFloor(mon)
end

local function startFollowing(entry, mon, target)

    if not target then
        return false
    end

    entry.State = const.FollowerState.Following
    prepareForMove(entry, mon, target)

    return true
end

local function stopFollowing(entry, mon, target)

    entry.State = const.FollowerState.NativeIdle
    setAnchor(mon, target)
    releaseToFollowIdle(entry, mon)
end

local function clearRuntimePredicate(entry)

    RuntimePredicates[entry.MonsterIndex] = nil
    entry.TargetPredicate                  = nil
end

local function clearRuntimeCaches(entry)

    RuntimeCombatScans[entry.MonsterIndex]     = nil
    RuntimeBlockedUntil[entry.MonsterIndex]    = nil
    RuntimeAvoidanceSide[entry.MonsterIndex]   = nil
end

local function clearFinishAction(entry)

    RuntimeFinishCallbacks[entry.MonsterIndex] = nil
    entry.FinishResumeNative                   = nil
end

local function setFinishAction(entry, finishAction)

    clearFinishAction(entry)

    if type(finishAction) == "function" then
        RuntimeFinishCallbacks[entry.MonsterIndex] = finishAction
    elseif finishAction then
        entry.FinishResumeNative                   = true
    end
end

local function clearWaypoints(entry)

    entry.WaypointPoints    = nil
    entry.WaypointIndex     = nil
    entry.WaypointDirection = 1
    entry.WaypointWaitUntil = nil
    entry.WaypointWaitTicks = nil
end

local function normalizeWaypoint(point)

    local x = nil
    local y = nil
    local z = nil

    if not point then
        return nil
    end

    x = point.X or point.x or point[1]
    y = point.Y or point.y or point[2]
    z = point.Z or point.z or point[3]

    if x == nil or y == nil or z == nil then
        return nil
    end

    return {
        X       = x,
        Y       = y,
        Z       = z,
        Wait    = point.Wait or point.wait or point.W or point.w or point[4] or 0,
    }
end

local function normalizeWaypoints(points)

    local route = {}

    if type(points) ~= "table" then
        return route
    end

    for i = 1, #points do
        local point = normalizeWaypoint(points[i])
        if point then
            route[#route + 1] = point
        end
    end

    return route
end

local function getCurrentWaypoint(entry)

    local points    = entry.WaypointPoints
    local index     = entry.WaypointIndex

    return points and index and points[index] or nil
end

local function advanceWaypoint(entry)

    local points    = entry.WaypointPoints
    local index     = nil
    local mode      = nil

    if not points or #points == 0 then
        return false
    end

    index           = entry.WaypointIndex or 1
    mode            = entry.WaypointMode

    if mode == const.WaypointMode.PingPong then

        local direction = entry.WaypointDirection or 1

        if #points == 1 then
            return true
        end

        if index >= #points then
            direction = -1
        elseif index <= 1 then
            direction = 1
        end

        entry.WaypointDirection = direction
        entry.WaypointIndex = index + direction

        return true
    end

    if index >= #points then
        return false
    end

    entry.WaypointIndex = index + 1

    return true
end

local function findMonsterByModID(id)

    if not id then
        return nil
    end

    for _, mon in Map.Monsters do
        if mon.ModID == id and isValidTargetMonster(mon) then
            return mon
        end
    end

    return nil
end

local function findPredicateTarget(entry, follower)

    local predicate = RuntimePredicates[entry.MonsterIndex]

    if not predicate then
        return nil
    end

    for i = 0, Map.Monsters.Count - 1 do
        local mon = Map.Monsters[i]
        if mon ~= follower and isValidTargetMonster(mon) and predicate(mon, i, follower) then
            return i
        end
    end

    return nil
end

local function resolveTarget(entry, follower)

    if entry.TargetType == const.FollowerTarget.Party then
        return setEntryTarget(entry, Party.X, Party.Y, Party.Z)
    end

    if entry.TargetType == const.FollowerTarget.Point then
        entry.Target = entry.TargetPoint
        return entry.Target
    end

    if entry.TargetType == const.FollowerTarget.Waypoints then
        local point = getCurrentWaypoint(entry)
        if not point then
            entry.Target = nil
            return nil
        end

        return setEntryTarget(entry, point.X, point.Y, point.Z)
    end

    if entry.TargetType == const.FollowerTarget.Monster then
        local target = getMonsterByArrayIndex(entry.TargetMonsterIndex)
        if not isValidTargetMonster(target) then
            entry.Target = nil
            return nil
        end

        return setEntryTarget(entry, target.X, target.Y, target.Z)
    end

    if entry.TargetType == const.FollowerTarget.PredicateMonster then
        local current = getMonsterByArrayIndex(entry.TargetMonsterIndex)
        if not isValidTargetMonster(current) then
            entry.TargetMonsterIndex = findPredicateTarget(entry, follower)
        end

        local target = getMonsterByArrayIndex(entry.TargetMonsterIndex)
        if not isValidTargetMonster(target) then
            entry.Target = nil
            return nil
        end

        return setEntryTarget(entry, target.X, target.Y, target.Z)
    end

    if entry.TargetType == const.FollowerTarget.ModID then
        local target = findMonsterByModID(entry.TargetModID)
        if not isValidTargetMonster(target) then
            entry.Target = nil
            return nil
        end

        return setEntryTarget(entry, target.X, target.Y, target.Z)
    end

    return nil
end

local function canWaitForMissingTarget(entry)
    return entry.TargetType == const.FollowerTarget.PredicateMonster
        or entry.TargetType == const.FollowerTarget.ModID
end

local function waitForMissingTarget(entry, mon)

    entry.Target        = nil
    entry.TargetIndex   = nil
    entry.State         = const.FollowerState.NativeIdle

    local moveType = entry.Mode == const.FollowerMode.PassiveFollow
        and entry.PassiveIdleMoveType
        or entry.IdleMoveType
    if mon and mon.MoveType ~= moveType then
        releaseToFollowIdle(entry, mon)
    end
end

local function finishMovement(entry, mon)

    entry.Tracking      = false
    entry.TargetIndex   = nil
    entry.State         = const.FollowerState.NativeIdle

    local callback      = RuntimeFinishCallbacks[entry.MonsterIndex]
    local resumeNative  = entry.FinishResumeNative

    clearFinishAction(entry)

    if callback then
        callback(mon)
        return
    end

    if resumeNative then
        releaseToHoldIdle(entry, mon)
    else
        releaseToFollowIdle(entry, mon)
    end
end

local function handleWaypointWait(entry, mon)

    local target = nil

    if entry.TargetType ~= const.FollowerTarget.Waypoints then
        return false
    end

    if not entry.WaypointWaitTicks and not entry.WaypointWaitUntil then
        return false
    end

    if entry.WaypointWaitTicks then
        entry.WaypointWaitTicks = entry.WaypointWaitTicks - 1
        if entry.WaypointWaitTicks > 0 then
            return true
        end
    elseif Game.Time < entry.WaypointWaitUntil then
        return true
    end

    entry.WaypointWaitUntil = nil
    entry.WaypointWaitTicks = nil

    if not advanceWaypoint(entry) then
        finishMovement(entry, mon)
        return true
    end

    target = resolveTarget(entry, mon)

    if target then
        startFollowing(entry, mon, target)
    end

    return true
end

local function handleWaypointArrival(entry, mon, target)

    local nextTarget = nil
    local point      = nil
    local wait       = nil

    if entry.TargetType ~= const.FollowerTarget.Waypoints then
        return false
    end

    stopFollowing(entry, mon, target)

    point = getCurrentWaypoint(entry)
    wait  = point and point.Wait or 0

    if wait and wait > 0 then
        entry.WaypointWaitUntil = nil
        entry.WaypointWaitTicks = math.max(1, math.floor(wait * entry.WaypointTicksPerSecond))
        return true
    end

    if not advanceWaypoint(entry) then
        finishMovement(entry, mon)
        return true
    end

    nextTarget = resolveTarget(entry, mon)
    if nextTarget then
        startFollowing(entry, mon, nextTarget)
    end

    return true
end

local function repairStaleAction(entry, mon)

    if not isInterruptible(mon) and not isRecoverableFinishedAction(mon) then
        return
    end

    if mon.GraphicState ~= 0
        and mon.CurrentActionLength > 0
        and mon.CurrentActionStep >= mon.CurrentActionLength
    then
        releaseToFollowIdle(entry, mon)
    end
end

local function canResumeFollow(entry, mon)

    if entry.Mode == const.FollowerMode.Hold then
        return false
    end

    if isDeadOrUnavailable(mon) or not isInterruptible(mon) then
        return false
    end

    if entry.Mode == const.FollowerMode.OffensiveFollow then
        local hostileNearby = hasNearbyHostiles(mon, entry.CombatRadius, entry)
        return not hostileNearby
    end

    return true
end

local function updatePassiveMode(entry, mon)

    if entry.Mode ~= const.FollowerMode.PassiveFollow then
        return
    end

    if isCombatAction(mon) or mon.AIState == const.AIState.Pursue then
        entry.TargetIndex   = nil
        entry.State         = const.FollowerState.NativeIdle
        releaseToFollowIdle(entry, mon)
    end
end

local function updateCombatLock(entry, mon)

    local hostileNearby = nil

    if entry.Mode ~= const.FollowerMode.OffensiveFollow then
        return
    end

    if entry.State ~= const.FollowerState.CombatLocked then
        return
    end

    if isCombatAction(mon) then
        return
    end

    hostileNearby = hasNearbyHostiles(mon, entry.CombatRadius, entry)
    if not hostileNearby then
        entry.State         = const.FollowerState.NativeIdle
        entry.TargetIndex   = nil
    end
end

local function recoverAfterKill(entry, follower)

    if not follower or isDeadOrUnavailable(follower) then
        return
    end

    if entry.Mode == const.FollowerMode.OffensiveFollow then
        local hostileNearby = hasNearbyHostiles(follower, entry.CombatRadius, entry)
        if hostileNearby then
            return
        end
    end

    if isCombatAction(follower)
        or isRecoverableFinishedAction(follower)
        or follower.GraphicState ~= 0
    then
        entry.State = const.FollowerState.NativeIdle
        releaseToFollowIdle(entry, follower)
    end
end

local function updateEntry(entry, mon)

    local target = nil
    local dist   = nil
    local distSq = nil
    local dx     = nil
    local dy     = nil
    local dz     = nil

    if not entry.Tracking then
        return
    end

    updateCombatLock(entry, mon)
    updatePassiveMode(entry, mon)

    if handleWaypointWait(entry, mon) then
        return
    end

    target = resolveTarget(entry, mon)
    if not target then
        if canWaitForMissingTarget(entry) then
            waitForMissingTarget(entry, mon)
            return
        end

        entry.Tracking      = false
        entry.TargetIndex   = nil
        entry.State         = const.FollowerState.NativeIdle
        releaseToFollowIdle(entry, mon)
        return
    end

    dx      = target.X - mon.X
    dy      = target.Y - mon.Y
    dz      = target.Z - mon.Z
    distSq  = dx * dx + dy * dy + dz * dz

    if entry.State == const.FollowerState.Following then

        local arriveDistance = entry.TargetType == const.FollowerTarget.Waypoints
            and entry.WaypointDistance
            or entry.FollowDistance

        if distSq <= arriveDistance * arriveDistance then

            if handleWaypointArrival(entry, mon, target) then
                return
            end

            stopFollowing(entry, mon, target)

            if entry.TargetType == const.FollowerTarget.Point then
                finishMovement(entry, mon)
            end

            return
        end

        if not canResumeFollow(entry, mon) then
            return
        end

        if RuntimeBlockedUntil[entry.MonsterIndex] and RuntimeBlockedUntil[entry.MonsterIndex] > RuntimeTick then
            return
        end

        prepareForMove(entry, mon, target)
        faceVector(mon, dx, dy)

        dist = math.sqrt(distSq)
        driveDirect(entry, mon, dx, dy, dz, dist)

        return
    end

    if entry.State == const.FollowerState.NativeIdle then

        repairStaleAction(entry, mon)

        if entry.TargetType == const.FollowerTarget.Waypoints then
            startFollowing(entry, mon, target)
            return
        end

        if distSq > entry.ResumeDistance * entry.ResumeDistance and canResumeFollow(entry, mon) then
            startFollowing(entry, mon, target)
        end
    end
end

------------------------------------------------------------------------------
-- PUBLIC API
------------------------------------------------------------------------------

function ModAI_Add(mon, options)

    local index     = findMonsterArrayIndex(mon)
    local actors    = nil
    local entry     = nil

    if not index then
        return nil
    end

    actors              = getDB().Actors
    entry               = actors[index] or actors[tostring(index)] or {}
    entry.MonsterIndex  = index

    mon.ModID           = index

    applyDefaults(entry, mon, options)

    actors[tostring(index)]   = nil
    actors[index]             = entry

    return entry
end

function ModAI_Remove(mon)

    local entry, index = getEntry(mon)

    if not entry then
        return
    end

    clearRuntimePredicate(entry)
    clearRuntimeCaches(entry)
    clearFinishAction(entry)
    releaseToHoldIdle(entry, mon)
    removeEntry(index)
end

function ModAI_Get(mon)
    return getEntry(mon)
end

function ModAI_SetMode(mon, mode)

    local entry     = ModAI_Get(mon) or ModAI_Add(mon)
    local target    = nil

    if not entry then
        return
    end

    entry.Mode = mode

    if mode == const.FollowerMode.Hold then
        entry.Tracking      = false
        entry.TargetIndex   = nil
        clearWaypoints(entry)
        clearFinishAction(entry)
        entry.State         = const.FollowerState.NativeIdle
        releaseToHoldIdle(entry, mon)
        return
    end

    enableTracking(entry)

    target = resolveTarget(entry, mon)
    if target then
        startFollowing(entry, mon, target)
    elseif canWaitForMissingTarget(entry) then
        waitForMissingTarget(entry, mon)
    else
        entry.Tracking      = false
        entry.State         = const.FollowerState.NativeIdle
        releaseToHoldIdle(entry, mon)
    end
end

function ModAI_Hold(mon)
    ModAI_SetMode(mon, const.FollowerMode.Hold)
end

function ModAI_Stop(mon)

    local entry = ModAI_Get(mon)

    if not entry then
        return
    end

    entry.Tracking      = false
    entry.TargetIndex   = nil

    clearWaypoints(entry)
    clearFinishAction(entry)

    entry.State         = const.FollowerState.NativeIdle
    releaseToHoldIdle(entry, mon)
end

function ModAI_FollowParty(mon)

    local entry = ModAI_Get(mon) or ModAI_Add(mon)

    if not entry then
        return
    end

    entry.TargetType            = const.FollowerTarget.Party
    entry.TargetMonsterIndex    = nil
    entry.TargetModID           = nil
    entry.TargetPoint           = nil

    clearRuntimePredicate(entry)
    clearFinishAction(entry)
    clearWaypoints(entry)
    enableTracking(entry)

    startFollowing(entry, mon, resolveTarget(entry, mon))
end

function ModAI_FollowMonster(mon, target)

    local entry         = ModAI_Get(mon) or ModAI_Add(mon)
    local targetIndex   = findMonsterArrayIndex(target)

    if not entry or not targetIndex or target == mon or not isValidTargetMonster(target) then
        return
    end

    entry.TargetType            = const.FollowerTarget.Monster
    entry.TargetMonsterIndex    = targetIndex
    entry.TargetModID           = nil
    entry.TargetPoint           = nil

    clearRuntimePredicate(entry)
    clearFinishAction(entry)
    clearWaypoints(entry)
    enableTracking(entry)

    startFollowing(entry, mon, resolveTarget(entry, mon))
end

function ModAI_FollowModID(mon, id)

    local entry     = ModAI_Get(mon) or ModAI_Add(mon)
    local target    = nil

    if not entry or id == nil then
        return
    end

    entry.TargetType            = const.FollowerTarget.ModID
    entry.TargetMonsterIndex    = nil
    entry.TargetModID           = id
    entry.TargetPoint           = nil

    clearRuntimePredicate(entry)
    clearFinishAction(entry)
    clearWaypoints(entry)
    enableTracking(entry)

    target = resolveTarget(entry, mon)
    if target then
        startFollowing(entry, mon, target)
    else
        waitForMissingTarget(entry, mon)
    end
end

function ModAI_FollowMonsterWhere(mon, predicate)

    local entry     = ModAI_Get(mon) or ModAI_Add(mon)
    local target    = nil

    if not entry or type(predicate) ~= "function" then
        return
    end

    entry.TargetType            = const.FollowerTarget.PredicateMonster
    entry.TargetMonsterIndex    = nil
    entry.TargetModID           = nil
    entry.TargetPoint           = nil
    entry.TargetPredicate       = nil

    RuntimePredicates[entry.MonsterIndex] = predicate

    clearFinishAction(entry)
    clearWaypoints(entry)
    enableTracking(entry)

    target = resolveTarget(entry, mon)
    if target then
        startFollowing(entry, mon, target)
    else
        waitForMissingTarget(entry, mon)
    end
end

function ModAI_MoveTo(mon, x, y, z, finishAction)

    local entry = ModAI_Get(mon) or ModAI_Add(mon)

    if not entry then
        return
    end

    entry.TargetType            = const.FollowerTarget.Point
    entry.TargetMonsterIndex    = nil
    entry.TargetModID           = nil

    clearRuntimePredicate(entry)
    clearWaypoints(entry)
    setFinishAction(entry, finishAction)

    entry.TargetPoint           = {X = x, Y = y, Z = z}
    entry.Target                = {X = x, Y = y, Z = z}

    enableTracking(entry)
    startFollowing(entry, mon, entry.Target)
end

function ModAI_Waypoints(mon, points, mode, finishAction)

    local entry = ModAI_Get(mon) or ModAI_Add(mon)
    local route = nil

    if not entry then
        return
    end

    route = normalizeWaypoints(points)

    if #route == 0 then
        return
    end

    mode = mode or const.WaypointMode.Once

    if mode == const.WaypointMode.Return then
        route[#route + 1] = {X = mon.X, Y = mon.Y, Z = mon.Z, Wait = 0}
    end

    entry.TargetType            = const.FollowerTarget.Waypoints
    entry.TargetMonsterIndex    = nil
    entry.TargetModID           = nil
    entry.TargetPoint           = nil

    clearRuntimePredicate(entry)
    setFinishAction(entry, finishAction)

    entry.WaypointPoints        = route
    entry.WaypointIndex         = 1
    entry.WaypointDirection     = 1
    entry.WaypointMode          = mode
    entry.WaypointWaitUntil     = nil
    entry.WaypointWaitTicks     = nil

    enableTracking(entry)
    startFollowing(entry, mon, resolveTarget(entry, mon))
end

function ModAI_MoveRoute(mon, points, finishAction)
    ModAI_Waypoints(mon, points, const.WaypointMode.Once, finishAction)
end

function ModAI_MoveRouteAndReturn(mon, points, finishAction)
    ModAI_Waypoints(mon, points, const.WaypointMode.Return, finishAction)
end

function ModAI_PatrolWaypoints(mon, points)
    ModAI_Waypoints(mon, points, const.WaypointMode.PingPong)
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.Tick()

    if Game.TurnBased and Game.TurnBasedPhase ~= 1 then
        return
    end

    local db     = getDB()
    local actors = db.Actors
    local remove = nil

    if next(actors) == nil then
        return
    end

    RuntimeTick = RuntimeTick + 1

    if not db.Normalized then
        for key, entry in pairs(actors) do
            local index = tonumber(key)

            if index and key ~= index then
                actors[key]     = nil
                actors[index]   = entry
            end
        end

        db.Normalized = true
    end

    for key, entry in pairs(actors) do
        local index = tonumber(key)

        entry.MonsterIndex = tonumber(entry.MonsterIndex) or index

        local mon = getMonsterByArrayIndex(entry.MonsterIndex)

        if isDeadOrUnavailable(mon) then
            remove              = remove or {}
            remove[#remove + 1] = index
        else
            if entry.SchemaVersion ~= ModAIConfig.SchemaVersion then
                applyDefaults(entry, mon)
            end

            updateEntry(entry, mon)
        end
    end

    if remove then
        for i = 1, #remove do
            local entry = actors[remove[i]]

            if entry then
                clearRuntimeCaches(entry)
                clearRuntimePredicate(entry)
                clearFinishAction(entry)
            end

            removeEntry(remove[i])
        end
    end
end

function events.AfterMonsterAttacked(t, attacker)

    if not t or not attacker then
        return
    end

    local actors        = getDB().Actors
    local followerEntry = nil
    local hitEntry      = nil

    if next(actors) == nil then
        return
    end

    followerEntry       = actors[attacker.MonsterIndex]
    hitEntry            = actors[t.MonsterIndex]

    if followerEntry then

        followerEntry.TargetIndex = t.MonsterIndex

        if followerEntry.Mode == const.FollowerMode.PassiveFollow then

            followerEntry.TargetIndex   = nil
            followerEntry.State         = const.FollowerState.NativeIdle
            releaseToFollowIdle(followerEntry, getMonsterByArrayIndex(followerEntry.MonsterIndex))
        elseif followerEntry.Mode == const.FollowerMode.OffensiveFollow then

            followerEntry.State         = const.FollowerState.CombatLocked
        end
    end

    if hitEntry and attacker.MonsterIndex then

        hitEntry.TargetIndex = attacker.MonsterIndex

        if hitEntry.Mode == const.FollowerMode.PassiveFollow then

            hitEntry.TargetIndex    = nil
            hitEntry.State          = const.FollowerState.NativeIdle
            releaseToFollowIdle(hitEntry, getMonsterByArrayIndex(hitEntry.MonsterIndex))
        elseif hitEntry.Mode == const.FollowerMode.OffensiveFollow then

            hitEntry.State          = const.FollowerState.CombatLocked
        end
    end
end

function events.MonsterKilled(mon, monIndex)

    local actors = getDB().Actors

    if next(actors) == nil then
        return
    end

    if actors[monIndex] then

        local entry = actors[monIndex]

        clearRuntimePredicate(entry)
        clearRuntimeCaches(entry)
        clearFinishAction(entry)
        actors[monIndex]  = nil
    end

    for _, entry in pairs(actors) do

        local follower = nil

        if monIndex == entry.TargetIndex then

            entry.TargetIndex   = nil
            if entry.State == const.FollowerState.CombatLocked then

                entry.State = const.FollowerState.NativeIdle
            end
        end

        if monIndex == entry.TargetMonsterIndex then

            if entry.TargetType == const.FollowerTarget.Monster then
                entry.Tracking  = false
                entry.State     = const.FollowerState.NativeIdle
            else
                entry.TargetMonsterIndex = nil
            end
        end

        follower = getMonsterByArrayIndex(entry.MonsterIndex)
        recoverAfterKill(entry, follower)
    end
end
