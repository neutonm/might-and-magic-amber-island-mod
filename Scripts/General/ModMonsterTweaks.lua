--[[
Description:    Various tweaks for monsters
Author:         Henrik Chukhran, 2022 - 2026
]]

function events.AfterLoadMap()

    for _, mon in Map.Monsters do

        -- In warrior difficulty, no one flee
        -- Otherwise, undead won't flee
        if IsWarrior() or Game.IsMonsterOfKind(mon.Id, const.MonsterKind.Undead) ~= 0 then
            mon.NoFlee = true
        end
    end

end
