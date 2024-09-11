--[[
Custom Menu Difficulty Selection
Author: Henrik Chukhran, 2022 - 2024
]]

local ClickedOnNewGame  = 0
local ClickedOnExit     = 0

-- Functions
function CallDifficultySelector()

    Game.SelectedDifficulty = 0
    ClickedOnExit           = 2

    local dlg = CustomDialog{
            Pause2      =   true, 
            MimicScreen =   7 and nil, 
            CloseSound  =   true, 
            Localize    =   {Text_Back = "Background"},
            OnActivate  =   |t| t.NoDraw = false,
    }
    dlg:Add{
        {
            BoxBorder   =   false, 
            Left        =   0, 
            Top         =   0, 
            Right       =   0, 
            Bottom      =   0, 
            Icons       =   {Normal="bgdiff.pcx" }, 
            DrawStyle   =   true
        },
        {
            Left        =   640/2-80,
            Top         =   16, 
            Text        =   "Choose Difficulty", 
            TextMode    =   "center", 
            Font        =   Game.FontCchar, 
            Button      =   true, 
            Colors      =   {Hover = RGB(255, 255, 150)}
        },
        {
            Left        =   32,
            Top         =   60, 
            Name        =   "Adventurer", 
            Icons       =   {Normal = "bgdiffadv.pcx", Hover = "bgdiffadvh.pcx"}, 
            BoxBorder   =   true, DrawStyle = true, 
            Text        =   "Adventurer", 
            TextMode    =   "center", 
            Font        =   Game.FontCchar, 
            TextMargin  =   {Top = 4, Left = 16}, 
            Colors      =   {Hover = RGB(255, 255, 150)},
            Sound       =   66, 
            OnClick     =   function(o) 
                                o.State = not o.State and "Oops" or nil
                                ClickedOnExit = 0
                                Game.SelectedDifficulty = 0
                            end, 
            Action      =   const.Actions.Exit,
            Key         =   const.Keys.LEFT
        },
        {
            Left        =   353, 
            Top         =   60, 
            Name        =   "Warrior", 
            Icons       =   {Normal = "bgdiffwar.pcx", Hover = "bgdiffwarh.pcx"}, 
            DrawStyle   =   true, 
            Text        =   "Warrior", 
            TextMode    =   "center", 
            Font        =   Game.FontCchar, 
            TextMargin  =   {Top = 4, Left = 16},
            Colors      =   {Hover = RGB(255, 255, 150)},
            Sound       =   66, 
            OnClick     =   function(o) 
                                o.State = not o.State and "Oops" or nil
                                ClickedOnExit = 0 
                                Game.SelectedDifficulty = 1
                            end,
            Action      =   const.Actions.Exit,
            Key         =   const.Keys.RIGHT
        },
        {
            Left        =   32+8, 
            Top         =   380 + 8, 
            Width       =   256 - 8, 
            Text        =   "For casual players who have experienced at least one or two of the original adventures.", 
            TextMode    =   "box", 
            Button      =   true, 
            Colors      =   {Hover = RGB(255, 255, 150)}
        },
        {
            Left        =   353+8, 
            Top         =   380 + 8, 
            Width       =   256 - 8, 
            Text        =   "For true veterans of the series who no longer find the original adventures challenging.", 
            TextMode    =   "box", 
            Button      =   true, 
            Colors      =   {Hover = RGB(255, 255, 150)}
        },
    }
end

-- Events
function events.GameInitialized2()
    Game.SelectedDifficulty = 0
end

function events.MenuAction(t)

    -- Dialog needs extra (delayed) call
    if t.Action == 0 then 
        if ClickedOnNewGame == 1 then
            CallDifficultySelector()
            Game.NeedRedraw = true
            ClickedOnNewGame = 2
        end
        return 
    else
        --local str = "Menu Action: \n"..dump(t)
        --debug.Message(str)
    end
    if t.Action == 54 and not t.Handled then
        Game.PlaySound(12100)
        ClickedOnNewGame = 1
    end

    -- Difficulty selection screen reaction for 'ESC'
    if t.Action == 113 then
        if ClickedOnExit > 0 then
            DoGameAction(const.Actions.Exit,0,0,false)
            ClickedOnExit = ClickedOnExit - 1
            ClickedOnNewGame = 0
        end
    end
end

function events.Action(t)

    -- In-Game Main Menu
    -- 0x6bdfb8: Previous action
    if t.Action == 124 and not t.Handled and mem.u4[0x6bdfb8] == 124 and Game.CurrentScreen == 1 then
		t.Handled = false
		Game.PlaySound(12100)
        ClickedOnNewGame = 1
	end

    -- if t.Action == 0 then return end
    -- local str = "Action: \n"..dump(t)
    -- debug.Message(str)
end
