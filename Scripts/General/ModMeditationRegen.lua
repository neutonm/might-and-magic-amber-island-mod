-- Taken from MMerge

-- @tod Currently not working! Check ExtraEvents.lua
-- Add a bit of sp regeneration by meditation skill
function events.RegenTick(Player)
    local Cond = Player:GetMainCondition()
    if Cond == 18 or Cond == 17 or Cond < 14 then
        local RegS, RegM = SplitSkill(Player:GetSkill(const.Skills.Meditation))
        if RegM > 0 then
            local FSP	= Player:GetFullSP()
            --local RegP	= 0.25*(2^(RegM-1))/100
            --Player.SP	= math.min(FSP, Player.SP + math.ceil(FSP*RegP))
            local Add = RegM + math.floor(RegS/10)
            Player.SP = math.min(FSP, Player.SP + Add)
        end
    end
end
