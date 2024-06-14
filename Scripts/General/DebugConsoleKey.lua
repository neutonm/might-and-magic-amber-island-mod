-- Activate debug console by Ctrl+F1

function events.KeyDown(t)
	
	if t.Key == const.Keys.F7 then
		if Game and Game.Debug then
			evt.GiveItem{Id = 315} -- Jump Scroll
			-- @todo better cast jump spell
		end
	elseif t.Key == const.Keys.F6 and not DisableDebugConsole then
		t.Key = 0
		debug.debug()
	end 
end
