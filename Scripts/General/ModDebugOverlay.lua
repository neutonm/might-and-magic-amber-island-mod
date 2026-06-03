--[[
Description:    Debugging Overlay
Author:         Henrik Chukhran, 2022 - 2026
]]

-- Todo: refactor / find a better way to draw text in realtime

local dlg
local items = {}

local CFG = {
	left        = 10,
	top         = 10,
	lineHeight  = 16,
	width       = 96,
	height      = 20,

	color       = RGB(255, 255, 255),
	shadow      = RGB(0, 0, 0),
}

local axes = {"X", "Y", "Z"}

local function GetCoords()
	local x, y, z = XYZ(Party)
	return x, y, z
end

local function UpdateText()
	if not items[1] then
		return
	end

	local values = {GetCoords()}

	for i, axis in ipairs(axes) do
		--items[i].Text = string.format("%s: %d", axis, values[i])
		items[i].Text = string.format("%d", values[i])
	end
end

local function AddCoordItems()
	for i, axis in ipairs(axes) do
		items[i] = dlg:Add{
			Left        = CFG.left,
			Top         = CFG.top + (i - 1) * CFG.lineHeight,
			Width       = CFG.width,
			Height      = CFG.height,

			Text        = axis..": 0",
			Color       = CFG.color,
			ShadowColor = CFG.shadow,
		}
	end
end

function ShowDebugOverlay()
	if dlg and dlg.Dlg then
		return
	end

	dlg = CustomDialog{
		Left        = 0,
		Top         = 0,
		Width       = 128,
		Height      = 200,

		Screen      = false,
		Pause       = false,
		Pause2      = false,
		TmpIcons    = false,

		PassThrough = true,
		HandleEsc   = false,
		NoFoodGold  = false,

		OnBeforeDraw = UpdateText,
	}

	AddCoordItems()
end

local function DestroyOverlay()
	if dlg and dlg.Dlg then
		dlg:Unbind()
	end

	dlg     = nil
	items   = {}
end

function events.AfterLoadMap()
    if Game and Game.Debug then
	    ShowDebugOverlay()
    end
end

function events.Tick()
    if Game and Game.Debug then
        if dlg and dlg.Dlg then
            Game.NeedRedraw = true
        end
    end
end

function events.LeaveGame()
    if Game and Game.Debug then
        DestroyOverlay()
    end
end
