--[[
Expert teachers also teach skill!,
Author: Henrik Chukhran, 2022 - 2024
]] 

function NPCTopicTeachSkillBase_GetTopic(t)

    local SkillName = ""
    
    if t.SkillType == const.Skills.Staff then
        SkillName = "Staff"
    elseif t.SkillType == const.Skills.Sword then
        SkillName = "Sword"
    elseif t.SkillType == const.Skills.Dagger then
        SkillName = "Dagger"
    elseif t.SkillType == const.Skills.Axe then
        SkillName = "Axe"
    elseif t.SkillType == const.Skills.Spear then
        SkillName = "Spear"
    elseif t.SkillType == const.Skills.Bow then
        SkillName = "Bow"
    elseif t.SkillType == const.Skills.Mace then
        SkillName = "Mace"
    elseif t.SkillType == const.Skills.Blaster then
        SkillName = "Blaster"
    elseif t.SkillType == const.Skills.Shield then
        SkillName = "Shield"
    elseif t.SkillType == const.Skills.Leather then
        SkillName = "Leather"
    elseif t.SkillType == const.Skills.Chain then
        SkillName = "Chain"
    elseif t.SkillType == const.Skills.Plate then
        SkillName = "Plate"
    elseif t.SkillType == const.Skills.Fire then
        SkillName = "Fire Magic"
    elseif t.SkillType == const.Skills.Air then
        SkillName = "Air Magic"
    elseif t.SkillType == const.Skills.Water then
        SkillName = "Water Magic"
    elseif t.SkillType == const.Skills.Earth then
        SkillName = "Earth Magic"
    elseif t.SkillType == const.Skills.Spirit then
        SkillName = "Spirit Magic"
    elseif t.SkillType == const.Skills.Mind then
        SkillName = "Mind Magic"
    elseif t.SkillType == const.Skills.Body then
        SkillName = "Body Magic"
    elseif t.SkillType == const.Skills.Light then
        SkillName = "Light Magic"
    elseif t.SkillType == const.Skills.Dark then
        SkillName = "Dark Magic"
    -- elseif t.SkillType == const.Skills.DarkElfAbility then
    --     SkillName = "Dark Elf Ability"
    -- elseif t.SkillType == const.Skills.VampireAbility then
    --     SkillName = "Vampire Ability"
    -- elseif t.SkillType == const.Skills.DragonAbility then
    --     SkillName = "Dragon Ability"
    elseif t.SkillType == const.Skills.IdentifyItem then
        SkillName = "Identify Item"
    elseif t.SkillType == const.Skills.Merchant then
        SkillName = "Merchant"
    elseif t.SkillType == const.Skills.Repair then
        SkillName = "Repair"
    elseif t.SkillType == const.Skills.Bodybuilding then
        SkillName = "Bodybuilding"
    elseif t.SkillType == const.Skills.Meditation then
        SkillName = "Meditation"
    elseif t.SkillType == const.Skills.Perception then
        SkillName = "Perception"
    -- elseif t.SkillType == const.Skills.Regeneration then
    --     SkillName = "Regeneration"
    elseif t.SkillType == const.Skills.Diplomacy then
        SkillName = "Diplomacy"
    elseif t.SkillType == const.Skills.Thievery then
        SkillName = "Thievery"
    elseif t.SkillType == const.Skills.DisarmTraps then
        SkillName = "Disarm Traps"
    elseif t.SkillType == const.Skills.Dodging then
        SkillName = "Dodging"
    elseif t.SkillType == const.Skills.Unarmed then
        SkillName = "Unarmed"
    elseif t.SkillType == const.Skills.IdentifyMonster then
        SkillName = "Identify Monster"
    elseif t.SkillType == const.Skills.Armsmaster then
        SkillName = "Armsmaster"
    elseif t.SkillType == const.Skills.Stealing then
        SkillName = "Stealing"
    elseif t.SkillType == const.Skills.Alchemy then
        SkillName = "Alchemy"
    elseif t.SkillType == const.Skills.Learning then
        SkillName = "Learning"
    end
    
    return string.format("Learn: %s (%sg)", SkillName, t.QuestGold) 
end

function NPCTopicTeachSkillBase_Done(t)

    Message(t.SkillTxtDone)
    PlayerSetSkill(evt.CurrentPlayer, t.SkillType, 1, const.Novice)
end

function NPCTopicTeachSkillBase_CheckDone(t)

    local IsProperClass = false
    local hasIt         = PlayerHasSkill(evt.CurrentPlayer, t.SkillType)
    local Player        = Party[evt.CurrentPlayer]

    -- Is skill available for the class?
    for i, availableSkill in EnumAvailableSkills(Player.Class) do
        if i == t.SkillType then
            IsProperClass = true
            break
        end
    end
    if IsProperClass == false then
        Message(t.SkillTxtBadClass)
        return false
    end

    -- Is skill already learned?
    if hasIt == true then
        Message(t.SkillTxtHasIt)
    elseif not evt.Cmp("Gold", t.QuestGold) then -- no gold?
        Message(t.SkillTxtDoesnt)
    end

    return hasIt == false
end

NPCTopicTeachSkillBase = {
    Slot 			= 	B,
    GetTopic 	    = 	function(t) return NPCTopicTeachSkillBase_GetTopic(t) end,
	Done			=	function(t) NPCTopicTeachSkillBase_Done(t) end,
    CheckDone		=	function(t) return NPCTopicTeachSkillBase_CheckDone(t) end,
    NeverGiven		=	true,
    NeverDone		=	true,
    QuestGold		=	400,
    SkillType       =   const.Skills.Staff,
    SkillTxtDone    =   "Well done! You've taken the first step towards mastering the skill. Keep honing your abilities, and you'll soon become a true expert!",
    SkillTxtHasIt   =   "Ah, I see you're \01265523already proficient\01200000 in the skill! Your prowess is evident. If there's anything else you need to refine your skills, let me know.",
    SkillTxtDoesnt  =   "It appears you \01265523don't have enough gold\01200000 to learn the skill at the moment. Return when you have the required amount, and I'll be happy to share my knowledge with you.",
    SkillTxtBadClass=   "Unfortunately, \01265523your current class prevents you from learning this skill\01200000. Each class has its own strengths and limitations. Seek skills that align with your chosen profession."
}

function NPCTopicTeachSkill(t)
	table.copy(NPCTopicTeachSkillBase, t)
	NPCTopicTeachSkillBase.Slot = NPCTopicTeachSkillBase.Slot and NPCTopicTeachSkillBase.Slot + 1
	return Quest(t)
end
