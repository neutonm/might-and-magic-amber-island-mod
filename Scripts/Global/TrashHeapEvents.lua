--[[
Description:    Events for Trash Heap sprites
Author:         Henrik Chukhran, 2022 - 2026
]]

local SpriteEvents      = 20000
local TrashHeapHint     = Game.DecListBin[Game.LoadDecSprite("dec10")]
local TrashHeapSprites  = {
    dec01 = true,
    dec10 = true,
    dec11 = true
}

TrashHeapHint = TrashHeapHint.GameName:gsub("^%l", string.upper)

local function TrashEvent(EvtId)
    -- No bonuses or disease checks in Amber Island
end

local function InitTrashHeap(i, a)
    a.Event                     = SpriteEvents + i
    evt.map[SpriteEvents + i]   = TrashEvent
    evt.hint[SpriteEvents + i]  = TrashHeapHint
end

function events.LoadMap()
    for i, a in Map.Sprites do
        if TrashHeapSprites[a.DecName] then
            InitTrashHeap(i, a)
        end
    end
end
