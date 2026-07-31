--[[
Description:    Difficulty-specific editor chest loot
Author:         Henrik Chukhran, 2022 - 2026
]]

local Bits = const.ChestWarriorItemsBits
local TrappedBits = const.ChestWarriorTrappedBits
local ItemCount = 140
local GenerateChestsCall = 0x461147
local GenerateChests = 0x450244

local function SelectDifficultyChestItems(chest, warrior)

    local hasWarriorItems = chest.Bits:And(Bits.Flag) ~= 0
    local hasWarriorTrapped = chest.Bits:And(TrappedBits.Flag) ~= 0
    if not hasWarriorItems and not hasWarriorTrapped then
        return false
    end

    if hasWarriorItems then
        local count = chest.Bits:And(Bits.CountMask)/Bits.CountStep
        assert(count <= ItemCount, "Invalid packed Warrior chest item count")

        local itemSize = chest.Items[1]["?size"]
        local itemsPtr = chest.Items["?ptr"]

        if warrior then
            if count > 0 then
                local size = count*itemSize
                local source = itemsPtr + (ItemCount - count)*itemSize
                local temp = mem.malloc(size)
                mem.copy(temp, source, size)
                mem.fill(itemsPtr, chest.Items["?size"])
                mem.copy(itemsPtr, temp, size)
                mem.free(temp)
            else
                mem.fill(itemsPtr, chest.Items["?size"])
            end
        elseif count > 0 then
            local source = itemsPtr + (ItemCount - count)*itemSize
            mem.fill(source, count*itemSize)
        end
    end

    if warrior and hasWarriorTrapped then
        chest.Trapped = chest.Bits:And(TrappedBits.Value) ~= 0
    end

    -- The alternate-table metadata is only an on-disk transport.  Clear it
    -- before native chest processing and force inventory-grid reconstruction.
    chest.Bits = chest.Bits:AndNot(Bits.Flag + Bits.CountMask +
        TrappedBits.Flag + TrappedBits.Value + const.ChestBits.ItemsPlaced)
    mem.fill(chest.Inventory["?ptr"], chest.Inventory["?size"])
    return true
end

internal.SelectDifficultyChestItems = SelectDifficultyChestItems

local function SelectMapChestItems()
    local warrior = IsWarrior()
    for _, chest in Map.Chests do
        SelectDifficultyChestItems(chest, warrior)
    end
end

local function GenerateChestsHook(_, default)
    -- Preserve authored placeholders and both packed tables while the editor
    -- imports a map.  TestChest invokes the generator directly after selecting
    -- the requested difficulty, so it doesn't pass through this call hook.
    if Editor and (Editor.WorkMode or Editor.LoadBlvTime) then
        return 0
    end

    SelectMapChestItems()
    return default()
end

local function InstallHook()
    if internal.DifficultyChestLootHookInstalled then
        return
    end

    assert(mem.u1[GenerateChestsCall] == 0xE8,
        ("Difficulty chest hook: expected CALL at 0x%X"):format(GenerateChestsCall))
    local target = mem.i4[GenerateChestsCall + 1] + GenerateChestsCall + 5
    assert(target == GenerateChests,
        ("Difficulty chest hook: unexpected target 0x%X at 0x%X")
        :format(target, GenerateChestsCall))

    mem.hookcall(GenerateChestsCall, 0, 0, GenerateChestsHook)
    internal.DifficultyChestLootHookInstalled = true
end

if Game.Version == 7 then
    InstallHook()
end
