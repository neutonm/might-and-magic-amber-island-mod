--[[
Description:    Difficulty-gated editor sprites, monsters, items and spawn points
Author:         Henrik Chukhran, 2022 - 2026
]]

local Difficulty        = const.MapEntityDifficulty
local SpawnBits         = const.MapEntityDifficultyBits.Spawn
local min               = math.min
local PlacedMonsterCount
local PlacedObjectCount

local function IsEditorMapLoad()
    return Editor and (Editor.WorkMode or Editor.LoadBlvTime)
end

local function CurrentDifficulty()
    local value = internal.PendingNewGameDifficulty
    if value == nil then
        value = vars and vars.Difficulty
    end
    if value == nil then
        value = Game.SelectedDifficulty
    end
    return value == 1 and Difficulty.Warrior or Difficulty.Adventurer
end

local function IsAvailable(value)
    return value == Difficulty.Both or value == CurrentDifficulty()
end

local function DisableSprite(sprite)

    sprite.Invisible        = true

    -- Invisible trigger sprites are still processed by the executable.
    sprite.TriggerByTouch   = false
    sprite.TriggerByMonster = false
    sprite.TriggerByObject  = false
    sprite.Event            = 0
end

local function FilterPlacedEntities()
    if IsEditorMapLoad() then
        return
    end

    for _, sprite in Map.Sprites do
        if not IsAvailable(sprite.Difficulty) then
            DisableSprite(sprite)
        end
    end

    local monsterCount = min(PlacedMonsterCount or Map.Monsters.Count, Map.Monsters.Count)
    for i = 0, monsterCount - 1 do
        local monster = Map.Monsters[i]
        if not IsAvailable(monster.Difficulty) then
            -- Keep the array slot: map scripts can refer to monster indexes.
            monster.AIState = const.AIState.Removed
        end
    end

    local objectCount = min(PlacedObjectCount or Map.Objects.Count, Map.Objects.Count)
    for i = 0, objectCount - 1 do
        local object = Map.Objects[i]
        if not IsAvailable(object.Difficulty) then
            -- MM7 render/pickup code ignores the exposed Removed bit. The
            -- native removal routine marks the slot empty via TypeIndex = 0.
            Map.RemoveObject(i)
        end
    end
end

function events.BeforeLoadMap()
    PlacedMonsterCount  = nil
    PlacedObjectCount   = nil
end

function events.BeforeLoadMapScripts()
    FilterPlacedEntities()
end

local function FinalizePlacedEntities()
    events.Remove("AfterLoadMap", FinalizePlacedEntities)
    FilterPlacedEntities()
end

function events.LoadMap()
    events.Remove("AfterLoadMap", FinalizePlacedEntities)
    events.Add("AfterLoadMap", FinalizePlacedEntities)
end

-- Spawn descriptors are consumed before the normal Lua map-load events.
-- Intercept only the four indoor/outdoor loader calls, leaving other engine
-- uses of the monster and item generation functions untouched.
local SpawnCalls = {
    {Address = 0x460CC4, Target = 0x44F5A8, Registers = 2, Stack = 3}, -- indoor monster
    {Address = 0x460CCB, Target = 0x450004, Registers = 2, Stack = 0}, -- indoor item
    {Address = 0x47A4A8, Target = 0x44F5A8, Registers = 2, Stack = 3}, -- outdoor monster
    {Address = 0x47A4AF, Target = 0x450004, Registers = 2, Stack = 0}, -- outdoor item
}

local function SpawnCallHook(_, default, context, spawn, ...)

    if PlacedMonsterCount == nil then
        PlacedMonsterCount = Map.Monsters.Count
        PlacedObjectCount = Map.Objects.Count
    end

    if not IsEditorMapLoad() and spawn ~= 0 then

        local value = mem.u2[spawn + 0x12]:And(SpawnBits.Mask)/SpawnBits.Step

        if value > Difficulty.Adventurer then
            value = Difficulty.Both
        end

        if value ~= Difficulty.Both and value ~= CurrentDifficulty() then
            return 0
        end
    end

    return default(context, spawn, ...)
end

local function InstallSpawnHooks()

    if internal.MapEntityDifficultySpawnHooksInstalled then
        return
    end

    -- Fail before changing any call if this isn't the executable build that
    -- was audited for these addresses.
    for _, call in ipairs(SpawnCalls) do
        assert(mem.u1[call.Address] == 0xE8,
            ("Difficulty spawn hook: expected CALL at 0x%X"):format(call.Address))
        local target = mem.i4[call.Address + 1] + call.Address + 5
        assert(target == call.Target,
            ("Difficulty spawn hook: unexpected target 0x%X at 0x%X"):format(target, call.Address))
    end

    for _, call in ipairs(SpawnCalls) do
        mem.hookcall(call.Address, call.Registers, call.Stack, SpawnCallHook)
    end
    internal.MapEntityDifficultySpawnHooksInstalled = true
end

if Game.Version == 7 then
    InstallSpawnHooks()
end
