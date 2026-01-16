-- Activate debug console by Ctrl+F1

function events.KeyDown(t)
	if t.Key == const.Keys.F6 and not DisableDebugConsole then
		t.Key = 0
		debug.debug()
	end
end
