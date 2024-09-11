--[[
Load assets based on difficulty (assuming "Warrior")
Author: Henrik Chukhran, 2022 - 2024
]]

-- Utility functions
CurLods = {}

local function LoadLods(kind)
    local LoadCustomLod = mem.dll["mm7patch"].LoadCustomLod
    local p             = Game[kind..'Lod']['?ptr']
    local pathStr       = AppPath..'Data\\Warrior\\new.'..kind..'.hard.lod'

    for s in path.find(pathStr) do
        if path.ext(s):lower():match'l[ow]d' then
            CurLods[LoadCustomLod(p, 'Data\\Warrior\\'..path.name(s))] = true
        end
    end
end

local function SwitchLods()
    for _, kind in ipairs{'Games', 'Events', 'Icons', 'Bitmaps', 'Sprites'} do
        LoadLods(kind)
    end
end

local function StructsArray(arr, offs, tabl)
    tabl = tabl or {}
    return function(str)
        return DataTables.StructsArray(arr, offs, table.copy(tabl, {Resisable = true, IgnoreFields = {SFTIndex = true, Bits = true}, IgnoreRead = {['#'] = true}}, true), str)
    end
end

local function NameHeader(hdr, arr)
    for i, a in arr do
        hdr[i] = ("%s  %s"):format(i, a.Name)
    end
    return hdr
end

local function ReadWriteDataTable(filePath, f)
    local file          = io.open(filePath, "r")
    if file then
        f(io.load(filePath))
        io.close(file)
    else
        io.save(filePath, f())
    end
end

-- The actual function
local function LoadHardcoreStuff()

    -- unload lods
    for p in pairs(CurLods) do
        Game.Dll.FreeCustomLod(p)
        CurLods[p] = nil
    end

    -- load lods
    SwitchLods()
    if Game.PatchOptions.Present'ResetPalettes' then
        Game.PatchOptions.ResetPalettes = true
    end

    --! @note commented calls will crash the game
    mem.call(0x452C75, 0)  -- Global
    --mem.call(0x456DBE, 1, 0x5D2860)  -- monsters, items, 2DEvents, ...
    --mem.call(0x477033, 0)  -- quests, autonote, awards, ...

    --mem.fill(Game.MonstersTxt)
    --mem.call(0x45504A, 1, Game.MonstersTxt['?ptr'])  -- monsters

    mem.fill(Game.HostileTxt)
    mem.call(0x454810, 1, Game.HostileTxt['?ptr'])  -- Hostile

    -- mem.fill(Game.Houses)
    -- mem.call(0x456DBE, 1, 0x5D2860)  -- monsters, items, 2devents, ...

    mem.fill(Game.QuestsTxt)
    mem.call(0x4768AD, 0)  -- quests

    mem.fill(Game.AutonoteTxt)
    mem.call(0x476754, 0)  -- autonote

    mem.fill(Game.AwardsTxt)
    mem.call(0x4763E4, 0)  -- awards

    -- Custom MONSTERS.txt
    local hdr           = NameHeader({[-1] = 'Monster'}, Game.MonstersTxt)
    local f             = StructsArray(Game.MonstersTxt, nil, 
    {
        Resisable       = true,
        RowHeaders      = hdr, 
        IgnoreFields    = {Name = true, Picture = true}
    })
    ReadWriteDataTable(AppPath..[[Data\Tables\MonstersHard.txt]], f)

    -- Custom MAPSTATS.txt
    local hdr           = NameHeader({[-1] = 'Map'}, Game.MapStats)
    local f             = StructsArray(Game.MapStats, nil, 
    {
        Resisable       = false,
        RowHeaders      = hdr, 
    })
    ReadWriteDataTable(AppPath..[[Data\Tables\MapstatsHard.txt]], f)

    -- WIP:
    -- table.copy({
    --     ['Chest']                    = 'Chest.txt',
    --     ['Class HP SP']              = 'ClsHPSP.txt',
    --     ['Class Skills']             = 'ClsSkill.txt',
    --     ['Class Starting Skills']    = 'ClsSkilB.txt',
    --     ['Class Starting Stats']     = 'ClsStats.txt',
    --     ['House Movies']             = 'HouseMov.txt',
    --     ['Monster Kinds']            = 'MonKind.txt',
    --     ['Spells2']                  = 'Spells2.txt',
    --     ['Town Portal']              = 'TownPort.txt',
    --     ['Transport Index']          = 'TripIdx.txt',
    --     ['Transport Locations']      = 'TripLoc.txt',
    --     ['Shops']                    = 'Shops.txt',
    --     ['Faces']                    = 'Faces.txt',
    --     ['Face Animations']          = 'FaceAnim.txt',
    -- }, DataTables.Files, true)
    -- ReloadDataTables()
end

-- Events
function events.BeforeLoadMap(WasInGame, WasLoaded)
    if not WasInGame then
        if IsWarrior() then
            LoadHardcoreStuff()
        end
    end
end
