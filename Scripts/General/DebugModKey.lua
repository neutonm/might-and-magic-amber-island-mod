--[[
Mod related debuging functionality
Author: Henrik Chukhran, 2022 - 2024
]]

function events.KeyDown(t)

	if DisableDebugConsole then
		return
	end

    -- In-game keys
    if Game and Game.Debug then
        
        if t.Key == const.Keys.F9 then
            evt.Add("Inventory", 315) -- Jump Scroll
        elseif t.Key == const.Keys.F10 then
            evt.Add("Inventory", 341) -- Telekinesis Scroll
        elseif t.Key == const.Keys.F11 then
            evt.Add("Inventory", 320) -- Fly Scroll
        else
            return
        end

        t.Key = 0
    end
end
