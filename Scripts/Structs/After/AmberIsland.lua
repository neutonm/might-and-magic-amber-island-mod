--[[
Description:    Low level hacks and tweaks for Amber Island
Author:         Henrik Chukhran, 2022 - 2026
]]

------------------------------------------------------------------------------
-- START DATE
------------------------------------------------------------------------------

local BaseYear              = 992
local VanillaBaseYear       = 1168
local VanillaMaxBirthYear   = 1147

-- 9 June, 9:00 AM
local StartTime             = 5*const.Month + 8*const.Day + 9*const.Hour

Game.BaseYear       = BaseYear
-- Keep the character generator's birth years at the same age offset.
Game.MaxBirthYear   = BaseYear - (VanillaBaseYear - VanillaMaxBirthYear)

mem.IgnoreProtection(true)
mem.u4[0x491824] = StartTime -- new game initial Game.Time
mem.u4[0x4BF9ED] = StartTime -- victory screen elapsed-time subtraction
mem.IgnoreProtection(false)
