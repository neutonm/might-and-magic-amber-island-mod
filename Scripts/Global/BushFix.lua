local SpriteEvents = 20000
local TXT = Localize{
	BushHint = "Bush",
}

local function Bush(EvtId)
	
end

local function InitBush(i, a)
	a.Event = SpriteEvents + i
	evt.map[SpriteEvents + i] = Bush
	evt.hint[SpriteEvents + i] = TXT.BushHint
end

function events.LoadMap()
	for i, a in Map.Sprites do
		if a.DecName == "bush07" then
			InitBush(i, a)
		end
	end
end 
