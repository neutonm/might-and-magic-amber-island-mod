--[[
"Rest" Room Mechanics
Author: Henrik Chukhran, 2022 - 2024
]]
 
local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
local Q = vars.Quests

Greeting{
	"The safe room is an abandoned, old, and dusty space with a sturdy door that can be securely locked to keep monsters at bay. Despite its condition, it offers a brief respite for heroes to rest and heal.",
}

local function GetSafeRoomHealFoodPrice()

    local activePlayerNumber = 0
    local foodRequirementMultiplier = 1 -- @todo must depend on difficulty

    for _, pl in Party do
        if pl.Dead == 0 then
            activePlayerNumber = activePlayerNumber + 1
        end
    end

    return activePlayerNumber * foodRequirementMultiplier
end

local function SafeRoomHealParty()

    local foodRequirement = GetSafeRoomHealFoodPrice()

    if Party.Food >= foodRequirement then

        Party.Food = Party.Food - foodRequirement
        for p = 0, Party.Count - 1 do
            if Party[p].Dead == 0 then
                evt.FaceAnimation(p, const.FaceAnimation.SmileHuge)
                Party[p].Unconscious = 0
                evt[p].Add("HP",9999)
                evt[p].Add("SP",9999)
            end
        end
        
        return
    end

    evt.FaceAnimation(Game.CurrentPlayer, const.FaceAnimation.NotEnoughFood)
end

QuestNPC        =   534

NPCTopic{
    Slot        =   A,
    Branch      =   "",
	GetTopic    =   function(t) return string.format("Heal party (%d food)", GetSafeRoomHealFoodPrice()) end,
	Ungive      =   function(t) SafeRoomHealParty() end
}
