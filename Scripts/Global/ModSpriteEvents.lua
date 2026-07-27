--[[
Description:    Custom events for sprites
Author:         Henrik Chukhran, 2022 - 2026
]]

local SpriteEvents      = 20000
local TrashHeapHint     = Game.DecListBin[Game.LoadDecSprite("dec10")]
local TrashHeapSprites  = {
    dec01 = true,
    dec10 = true,
    dec11 = true
}
local ChallengePedestal  = {
    dec60 = true,
    dec61 = true,
    dec62 = true,
    dec63 = true,
}

local FruitPlate        = "dec08"

TrashHeapHint = TrashHeapHint.GameName:gsub("^%l", string.upper)

local function NullEvent(EvtId)
    -- No bonuses or disease checks in Amber Island
    -- No challenge contest feature
end

local function InitSprite(i, a, funcEvent, hintStr)
    a.Event                     = SpriteEvents + i
    evt.map[SpriteEvents + i]   = funcEvent and funcEvent   or NullEvent
    evt.hint[SpriteEvents + i]  = hintStr   and hintStr     or ModTxt.CNull
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.LoadMap()
    for i, a in Map.Sprites do

        if not a.IsUniqueEvent then
            if TrashHeapSprites[a.DecName] then
                InitSprite(i, a, NullEvent, TrashHeapHint)
            elseif ChallengePedestal[a.DecName] then
                InitSprite(i, a)
            elseif a.DecName == FruitPlate then
                if IsWarrior() then
                    InitSprite(i, a)
                end
            end
        end
    end
end
