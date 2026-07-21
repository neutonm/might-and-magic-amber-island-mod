--[[
Description:    Add Body resistance to monster disease resistance checks
Author:         Henrik Chukhran, 2022 - 2026
]]

if Game.Version ~= 7 then
    return
end

-- DoBadThing normally sends Disease1-3 through the Endurance branch.
-- Keep the vanilla formula, but add half of the
-- player's final raw Body resistance before resuming the shared Luck roll.

--[[
Body 0: resisted 0/500 (0.0%), expected 0.0%
Body 8: resisted 17/500 (3.4%), expected 3.2%
Body 20: resisted 108/500 (21.6%), expected 18.9%
Body 40: resisted 190/500 (38.0%), expected 36.2%
]]
local diseaseResistanceAsm = mem.asmproc([[
    mov ecx, esi
    call absolute 0x48CAA2
    push eax
    mov ecx, esi
    call absolute 0x48EA13
    mov ebx, eax

    push 15
    mov ecx, esi
    call absolute 0x48E7C8
    sar eax, 1
    add ebx, eax

    jmp absolute 0x48DEE8
]])

-- Jump-table entries for const.MonsterBonus.Disease1, Disease2, Disease3.
mem.IgnoreProtection(true)
for address = 0x48E0F1, 0x48E0F9, 4 do
    mem.u4[address] = diseaseResistanceAsm
end
mem.IgnoreProtection(false)
