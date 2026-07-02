--[[
Description:    Expands monster spells
Author:         Henrik Chukhran, 2022 - 2026

Spell lists:

    - Poison Spray
    - Deadly Swarm
]]

function events.MonsterCastSpell(t)

    if t.Spell == const.Spells.PoisonSpray then

	    local sk, mas = SplitSkill(t.Skill)

        -- use templates
        if mas >= const.Expert then
            t.CallDefault(const.Spells.Sparks, JoinSkill(sk, mas - 1))
        else
            t.CallDefault(const.Spells.FireBolt)
        end
    elseif t.Spell == const.Spells.DeadlySwarm then
        t.CallDefault(const.Spells.Blades)
    end
end

function events.ReadMonsterSpell(t)
    if t.Name == "poison spray" then
	    t.Result = const.Spells.PoisonSpray
    elseif t.Name == "deadly swarm" then
	    t.Result = const.Spells.DeadlySwarm
    end
end

