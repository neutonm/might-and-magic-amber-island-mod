--[[
Description:    Various tweaks for monsters
Author:         Henrik Chukhran, 2022 - 2026
]]

function events.AfterLoadMap()

    for _, mon in Map.Monsters do

        -- Undead won't flee from combat
        if Game.IsMonsterOfKind(mon.Id, const.MonsterKind.Undead) ~= 0 then
            mon.NoFlee = true
        end
    end

end
