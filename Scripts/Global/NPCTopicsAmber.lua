--[[
NPC Topics & Quests for Amber Island,
Author: Henrik Chukhran, 2022 - 2024
]]

local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
local Q = vars.Quests

local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

local QVarRevengeState = 
{
    GIVEN 		= 1,
    DUEL 		= 2,
	KILLED 		= 3,
	REPORTING	= 4,
	REPORTED	= 5,
	RELEASED	= 6,
	TRANSFERED	= 7,
	REWARDED	= 8
}

-- Maximus (Mayor)
QuestNPC = 447

Greeting{
	"Greetings adventurers! I wasn't sure you would show up, but here you are.",
	"Ah, adventurers, you're back. Any good news?",
}

Quest{
	Slot 			= 	A,
	BaseName 		= 	"StoryQuest1",
	Texts 			= 
	{		
		Topic 		= 	"Story Quest: Legate",
		Give		=	"Many have stood where you stand, seeking to prove themselves. I need more than just willingness; I need proof of capability. I'll give you a chance to prove you're different."..
						"\n\nYour first task will be a simple yet vital one. Travel to the knight's camp located in the southeastern swamp of Amber Island. There, you will find Sir Greene. Deliver this letter to him and return with his response."..
						"Consider this a test of your reliability. Succeed, and perhaps you'll prove yourselves worthy of more substantial undertakings.",
		Done 		= 	"*Maximus takes the letter and reads it carefully.*\n\nWell done. Delivering a message to Sir Greene may be a small task, but you've proven your worthiness for more significant challenges.\n\nFor now, your payment is my trust.",
		Undone 		= 	"Well? Sir Greene awaits your arrival in the southeastern swamp. I expect you to bring me his response. Off you go!",
		Quest 		= 	"\"Story: Legate\"\nMayor Maximus, Amber Island, Town Hall\n\nDeliver a letter to Sir Robert Greene at the knight's camp located in the southeastern swamp of Amber Island.",
	},
	Exp				=	500,
	QuestItem		=	795,
	CanShow			= 	(|| vars.Quests.StoryQuest1 ~= "Done"),
	Give			=	function(t) evt.Add("Inventory", 794) end
}

Quest{
	Slot 			= 	A,
	BaseName 		= 	"StoryQuest2",
	Texts 			= 
	{		
		Topic 		= 	"Story Quest: Investigation",
		Give		=	"With your capabilities confirmed, it's time to address a pressing matter: locating Archmage Magnus. His mist machine prevents ships from safely docking at Amber Island, and his goblins have been forcing us to comply with his demands for gold. While it's not as critical as the mist machine situation, his capture is imperative to prevent further harm. His residence is guarded. Start there. Maybe once we have him in our custody, he will finally listen to reason."..
						"\n\nMany have attempted to capture Magnus and failed. The last group of adventurers who tried were massacred. The sole survivor frequents the Crusty Eagle Inn. He might have valuable insights. You should consult with him to aid your search for the archmage.",
		Done 		= 	"Magnus wasn't in his residence? Disappointing, yet it does help narrow our search. This letter to his butler is our only lead. Luckily, the butler is in our custody. It's time we had a chat with him to see what more we can uncover.",
		Undone 		= 	"Why are you here? Have you located the Archmage? You aren't taking this as seriously as you should. If Magnus is not brought to justice, we will all suffer.\n\nDon't forget to consult with that adventurer at the Crusty Eagle Inn.",
		Quest 		= 	"\"Story: Investigation\"\nMayor Maximus, Amber Island, Town Hall\n\nSearch for Archmage Magnus on the island by investigating his residence for clues to his whereabouts.",
	},
	CanShow			= 	(|| vars.Quests.StoryQuest1 == "Done" and vars.Quests.StoryQuest2 ~= "Done"),
	Exp				=	1000,
	Gold			=	1000,
	QuestItem		=	798,
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}

Quest{
	Slot 			= 	A,
	BaseName 		= 	"StoryQuest3",
	Texts 			= 
	{		
		Topic 		= 	"Story Quest: Secret Hideout",
		Give		=	"Excellent work uncovering this letter and confirming the Archmage's absence from his residence. This is significant progress. We must press our advantage. The butler, already in our custody, could hold the key to Magnus's hideout. Interrogate him. He may reveal the information we need to advance our pursuit. You can find him in the town jail.",
		Done 		= 	"You were so close to capturing him. It's unfortunate he escaped at the last moment."..
						"\n\nNevertheless, you've outdone all others in this pursuit, and now we have a definitive lead. He's taken refuge in Castle Amber!"..
						"\n\nThe pieces are falling into place. We weren't sure why the goblins were so concentrated around Castle Amber, but now it just seems obvious. We must prepare for the next move.",
		Undone 		= 	"Time is of the essence. With the information we have on Magnus's location, we must act swiftly and capture him before he slips away again.",
		Quest 		= 	"\"Story: Secret Hideout\"\nMayor Maximus, Amber Island, Town Hall\n\nHunt down Magnus in his secret hideout. Use the teleportation platform near the knight's camp in the swamp to get there.",
	},
	CanShow			= 	(|| vars.Quests.StoryQuest2 == "Done" and vars.Quests.StoryQuest3 ~= "Done"),
	Exp				=	2000,
	Gold			=	2000,
	QuestItem		=	797,
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}

KillMonstersQuest{
	Name 			= 	"CoreQuest",
	Slot 			= 	A,
	{Map 			= 	"testlevel.blv", MonsterIndex = 4},
	CheckDone 		= 	function()
							--return evt.Cmp("QBits",7)
							return vars.QuestsAmberIsland.QVar1
						end,
	CanShow			= 	(|| vars.Quests.StoryQuest3 == "Done"),
	Exp 			= 	5000,
	Gold 			= 	5000,
	Done			=	function(t) 
							evt.MoveNPC(529,102)

						end
}
.SetTexts{	
	Topic 			= 	"Story Quest: The Mist",
	Give 			= 	"You've proven yourselves trustworthy, and frankly, you're the only one who can stand up to Magnus's monsters. We need your help to defeat him. I'm ordering an attack on Castle Amber. Magnus's goblins will easily repel our attack, but our attack will only be a diversion."..
						"\n\nWhile our forces engage the goblin army, you will enter the castle through the back, find Magnus, and destroy his mist machine. I know I asked you to capture him before, but I doubt he will listen to reason. You know what has to be done. This operation is risky, but it's our best chance to end this crisis. Once you're prepared, you can head to the boathouse and find the boatmaster, Cedrick Boyce."..
						"\n\nAs soon as Cedrick takes you to the island, our army will strike the goblins, allowing you an opportunity to get into Castle Amber.",
	Done 			= 	"*As the heroes approach, Maximus rushes forward with a laugh, throwing his arms around them in an exuberant hug.*"..
						"\n\nYou did it, you actually did it! The Archmage and his cursed machine are destroyed. On behalf of the entire island, I thank you, heroes! Your deeds will be remembered, and you'll always find a warm welcome here on Amber Island."..
						"\n\nAs a token of our gratitude, we've decided to give you Castle Amber. The people here would feel better with you watching over them. I know I will. Granted, the castle is a wrecked pile of stones, but I'm sure you'll find some potential there, and maybe even gain a bit of clout with those pompous nobles from the mainland. Actually, now that the mist machine's destroyed, the first ships from the mainland have arrived. They sent an ambassador to speak to you specifically. Looks like your exploits are already attracting attention.\n\n *Please re-enter town hall*",
	Undone 			= 	"I understand you may need some time to prepare, but every day we spend under Magnus's thumb brings us closer to ruin. As soon as you can, infiltrate the castle and bring this ordeal to a close. Find boatmaster Cedrick Boyce, take a boat to the island, and we will send our forces to divert their defenders while you enter Castle Amber.",
	TopicDone 		= 	"Thanks: The Mist",
	After			=	"Thank you once again, my heroes. Amber island will never forget your heroic deeds.",
	Quest 			= 	"Story: The Mist\nMayor Maximus, Amber Island, Town Hall\n\nContact boatmaster Cedrick Boyce to secure passage to Castle Amber's back entrance. Infiltrate the castle, eliminate Archmage Magnus, and destroy his mist machine.",
	Done			=	function(t) 
							evt.Add("Awards", 105) -- "Saved Amber Island from Magnus the Archmage"
							evt.Subtract("Reputation", 10) 
						end
}

NPCTopic{
	Slot 			= 	B,
	"Archmage Crisis",
	"We've been ensnared in an extortion racket by one of our own, Magnus the Archmage. He's created a remarkable weather machine that produces thick fog around Amber Island, complicating navigation for ships at sea.\n\nMagnus only shuts it off when we pay him a hefty sum of gold. As the fog grows more widespread by the day, so does the price for his \"services.\" If we don't put an end to his actions, our island faces disaster. It's not just financial trouble if the ships stop coming. We can only grow so much of our own food.",
	CanShow			=	(|| vars.Quests.CoreQuest ~= "Done")
}

NPCTopic{
	Slot 			= 	C,
	"Invaders",
	"A horde of goblins has taken over Castle Amber, and it's astonishing to see them following a swamp troll as their leader. Trolls are known cannibals. Have the goblins considered that once the troll runs out of human prey, they will be the next on the menu?",
	CanShow			=	(|| vars.Quests.CoreQuest ~= "Done")
}

Quest{
	Slot 			= 	D,
	BaseName 		= 	"AmberQuest6",
	Texts 			= 
	{		
		Topic 		= 	"Quest: Revenge",
		Done 		= 	"You've done a good deed by bringing this to light. Planning an assassination is a grave matter, and it shall not be taken lightly. Rest assured, appropriate actions will be taken against Otho for such a heinous plot. Thank you.",
		Undone 		= 	"Otho Robeson hired you to assassinate Michael Cassio? Do you have any proof?",
	},
	Gold 			= 	500,
	Exp				=	1000,
	CanShow 		= 	(|| (vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.REPORTING and evt.Cmp("NPCs", 498))),
	Done			= 	function(t)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.REPORTED
							evt.Subtract("NPCs", 498)
							evt.Subtract("Reputation", 10)
							evt.MoveNPC{NPC = 498, HouseId = 577}
						end
}

-- Eleric Graywood
QuestNPC 			= 	450

Greeting{
	"Greetings! The spark in your eyes suggests you've come to our island seeking adventure, am I right? You should visit the mayor of Amber Town, Maximus. Word has it he's looking for adventurers willing to risk everything. There's a substantial reward, of course.",
}


NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"The Island",
	Text 			= 	"Amber Island is a trading hub for many merchants worldwide. Gold flows through the island's veins, drawing fortune seekers of all kinds. Yourselves included, I presume."..
						"\n\nRegrettably, this wealth also draws troublemakers. Normally, we'd hire guards, but Archmage Magnus has taken over that role without asking us. Hopefully, the mayor will sort this out before we're bled dry."
}


NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Amber?",
	Text 			= 	"Before it became a commercial hub, this place was the most abundant source of amber in the world for many decades. The name stuck, though nowadays, you'd be lucky to find a piece of amber. The miners extracted the last remnants a few years back."
}
------------------------------------------------------------------------------
-- William Nightkeep
QuestNPC 			= 	451

Greeting{
	"Adventurers! I don't know how you got here, but it seems you're stuck with us now.",
}


NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Difficult Times",
	Text 			= 	"Sometimes, the mist manages to seep into the island area. Even though the Powder Keg Inn is just a few steps from my house, finding my way home after lingering there too long is a challenge. It gets so thick that I can barely see my own hands. Damn that archmage."
}
------------------------------------------------------------------------------
-- Aria Nightkeep
QuestNPC 			= 	452

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Husband",
	Text 			= 	"William earns his living as a mercenary, safeguarding trade ships. Unfortunately, Archmage Magnus's mist has significantly disrupted the trade routes, so there's not a lot of mercenary work. As a result, William spends most of his days at the Inn, often drinking until he's three sheets to the wind. I do wish he'd find some temporary work or at least lend a hand around the house."
}


NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Mercenaries",
	Text 			= 	"Amber Island is a city state, so we hire our own mercenaries to keep us safe. If we let the monarchs on the mainland send their soldiers here, we'd have to start following their laws and paying them taxes."
}

------------------------------------------------------------------------------
-- Harley Payne (Alchemy Expert)
QuestNPC 			= 	453

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Alchemy,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	--SkillTxtBadClass= "Wrong class!"
})

Quest{  
	Name 			= 	"AmberMisc2",
	Slot 			= 	C,
	QuestItem 		= 
	{
		{200,201,202,203,204, Count = 3}, -- Red 
		{205,206,207,208,209, Count = 3}, -- Blue
		{210,211,212,213,214, Count = 3}, -- Yellow
	},
	Texts 			= 
	{		
		Topic 		= 	"Make: Black Potion (Personality)",
		Done 		= 	"Perfect, this looks like everything. Give me a moment to mix them together...\n\n*After a short wait, she returns with a shimmering, black potion of profound Personality.*",
		TopicDone 	= 	false,
		Give 		= 	"As an expert alchemist, I specialize in crafting the finest potions, including the renowned Potion of Profound Personality. Provide me with the necessary ingredients, and I'll prepare one for you.\n\nI require three ingredients from each of these categories: red, blue, and yellow.",
		Undone 		= 	"Don't forget, I need three ingredients from each of these categories: red, blue, and yellow.",
	},
	Exp 			= 	500,
	RewardItem 		= 	268, -- Pure Personality
}

------------------------------------------------------------------------------
-- Bellona Kemp  (Armsmaster Expert)
QuestNPC 			= 	454

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Armsmaster,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Woodrow Marley  (Axe Expert)
QuestNPC 			= 	455

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Sour Apples",
	Text 			= 	"You'll find the apples on this island to be almost punishingly sour. Even biting into one is like a test of endurance! However, they do have one saving grace: these apples make for an excellent cider. In fact, the apple cider brewed here is hailed as some of the best in the world. It seems even the sourest fruits can produce remarkable results."
}

NPCTopicTeachSkill(
{
	Slot 			= 	C,
	QuestGold		= 400,
	SkillType       = const.Skills.Axe,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Trevor Gully  (Body Building Expert)
QuestNPC 			= 	456

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Bodybuilding,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Robin Stringer (Bow Expert)
QuestNPC 			= 	457

Greeting{
	"Welcome, traveler! I'm Robin Stringer, a bowyer and a master archer. Are you here to learn the fine art of shooting a bow?",
}

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	SkillTxtDone	= "Excellent! You've got a keen eye and steady hand now. Keep practicing, and soon you'll be as swift as the wind!",
	SkillType       = const.Skills.Bow,
	SkillTxtHasIt 	= "Ah, I see you're already an archer! Your stance and the way you carry your quiver told me as much. It's always a pleasure to meet a fellow enthusiast. How can I help you hone your skills further?",
	SkillTxtDoesnt 	= "Ah, it seems you're a bit short on gold. Return when you've gathered enough, and I'll teach you the secrets of the bow."
})

------------------------------------------------------------------------------
-- Raymond Hoggard  (Chain Expert)
QuestNPC 			= 	458

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Chain,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Hector Messer (Dagger Expert)
QuestNPC 			= 	459

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Dagger,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Wright (Disarm Expert)
QuestNPC 			= 	460

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.DisarmTraps,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Hazel Quick (Dodging Expert)
QuestNPC 			= 	461

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Dodging,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Rana Winter (ID Item Expert)
QuestNPC 			= 	462

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.IdentifyItem,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Sullivan Winter (ID Monster Expert)
QuestNPC 			= 	463

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.IdentifyMonster,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Sophia Shirley (Learning Expert)
QuestNPC 			= 	464

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Learning,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Valeria Timar (Leather Expert)
QuestNPC 			= 	465

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Robert Stevenson",
	Text 			= 	"Have you heard whispers about Robert Stevenson? Some say that old sea dog might've been a pirate in his past, and let's be honest, there's no such thing as an ex-pirate. Keep your wits about you around him."
}

NPCTopicTeachSkill(
{
	Slot 			= 	C,
	QuestGold		= 400,
	SkillType       = const.Skills.Leather,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Oswald of Umbria (Mace Expert)
QuestNPC 			= 	466

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Apple Cave",
	Text 			= 	"Apple Cave on the northwest side of Apple Island is as notorious as it is infamous. Despite the charming name, thanks to the abundant apple trees that grow there, it has been a haven for bandits and pirates for decades. Locals have tried several times to cleanse the area of its lawless residents, but like a bad weed, they keep coming back. It's a place best avoided unless you're looking for trouble, or perhaps an adventure."
}

NPCTopicTeachSkill(
{
	Slot 			= 	C,
	QuestGold		= 400,
	SkillType       = const.Skills.Mace,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Hugo Barnes (Meditation Expert)
QuestNPC 			= 	467

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Meditation,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Edith Chapman (Merchant Expert)
QuestNPC 			= 	468

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Merchant,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Ophelia Sage (Perception Expert)
QuestNPC 			= 	469

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Perception,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Ethan Armstrong (Plate Expert)
QuestNPC 			= 	470

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Plate,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})


------------------------------------------------------------------------------
-- Craig 
QuestNPC 			= 	471

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Craig's Story",
	Text 			= 	"I'm Craig, just a goblin trying to make ends meet in this bustling town. Found work at the smithy, fixing up whatever comes my way. Can't complain. Keeps the coin flowing, and it's better than working for Magnus."
}

NPCTopicTeachSkill({
	Slot 			= 	C,
	QuestGold		= 	400,
	SkillType       = 	const.Skills.Repair,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Aldren Ryder (Shield Expert)
QuestNPC 			= 	472

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Shield,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Brigid Ryder (Spear Expert)
QuestNPC 			= 	473

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Spear,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Audrey Boyce (Staff Expert)
QuestNPC 			= 	474

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Staff,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Bradan Colby (Stealing Expert)
QuestNPC 			= 	475

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Stealing,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Elmar Mitchell  (Sword Expert)
QuestNPC 			= 	476

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 400,
	SkillType       = const.Skills.Sword,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Conrad Hawk (inn; Unarmed Expert)
QuestNPC 			= 	477

Greeting{
	"Ah, my favourite people! What can I do for you today?"
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Brawling!",
	Text 			= 	"Ah, brawling, there's nothing quite like it. You see, there's a certain art to landing the perfect punch, especially when it's someone's nose at the tavern on a lively evening. The thrill, the adrenaline rush... it's just how I like to unwind."
}


-- @todo	for future mm8-like experience, give bonus exlusively to available party heroes. Allow re-usage. Adjust price per person.
Quest{
	Slot 			= 	C,
	Texts 			= 
	{
		Topic 		= 	"Reward: Might/Speed +5",
		Done 		= 	"Since you've helped me out, let me share a bit of my brawling expertise with you. It's all about speed and strength. Watch closely, train hard, and you'll find yourself hitting harder and moving faster before you know it.",
		After 		= 	"I've taught you everything I know, there's really nothing more I can show you. You've got all the techniques. Now it's all about perfecting them on your own."
	},
	NeverGiven 		= 	true,
	Done			=	function(t)
							evt.Subtract("Reputation", 5)
							evt.All.Add("BaseMight", 5)
							evt.All.Add("BaseSpeed", 5)					
						end,
	CanShow			=	(|| vars.Quests.AmberQuest11 == "Done")
}

NPCTopicTeachSkill(
{
	Slot 			= 	D,
	QuestGold		= 400,
	SkillType       = const.Skills.Unarmed,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Alfred Brand  (Fire Magic Expert)
QuestNPC 			= 	478

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Fire,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Avira Lightfeather (Air Magic Expert)
QuestNPC 			= 	479

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Air,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Magee Wells (Water Magic Expert)
QuestNPC 			= 	480

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Water,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- John Aarden (Earth Magic Expert)
QuestNPC 			= 	481

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Earth,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Asgerd Lund (Earth Magic Expert)
QuestNPC 			= 	482

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Spirit,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Timothy Leary (Mind Magic Expert)
QuestNPC 			= 	483

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"The Doors of Perception",
	Text 			= 	"Welcome, seeker of the arcane! Interested in expanding your mind with some mind magic? It's like navigating a labyrinth where each turn reveals not walls, but windows into new dimensions. Imagine, if you will, tickling the very fabric of reality until it giggles back at you. That's mind magic! It's not just about bending thoughts, but about stretching them until they yawn and show you their secrets. Oh, and it can all be done in a fun way, too. I know a magical spell that'll make you perceive walls breathing and colors changing. So are you ready to open some doors in your mind, or perhaps slip through a few windows?"
}

NPCTopicTeachSkill(
{
	Slot 			= 	C,
	QuestGold		= 800,
	SkillType       = const.Skills.Mind,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Andreas Vesalius (Body Magic Expert)
QuestNPC 			= 	484

-- Greeting{
-- 	"Greeting message",
-- }

NPCTopicTeachSkill(
{
	Slot 			= 	B,
	QuestGold		= 800,
	SkillType       = const.Skills.Body,
	-- SkillTxtDone		= "Skill learned!",
	-- SkillTxtHasIt 	= "Skill already learned!",
	-- SkillTxtDoesnt 	= "Not enough gold",
	-- SkillTxtBadClass= "Wrong class!"
})

------------------------------------------------------------------------------
-- Conrad Hawk (prison)
QuestNPC 			= 	491

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Brawling",
	Text 			= 	"Ah, brawling, there's nothing quite like it. You see, there's a certain art to landing the perfect punch, especially when it's someone's nose at the tavern on a lively evening. The thrill, the adrenaline rush... it's just how I like to unwind."
}

Quest{
	Name 			= 	"AmberQuest11",
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Bail out!",
		TopicDone 	= 	false,
		Give 		= 	"Name's Conrad Hawk. You might've heard about my little scuffles at the inn. Look, I've got a situation that needs handling, and I can't do it from in here. How about you help me out?"..
						"\n\nFind Guardmaster James Halloran. He's the one who can get me out of this mess. Lives near the bridge on the western part of town. Pay him the bail, and I'll owe you.",
		Undone 		= 	"Are we done yet? I'm not one for sitting around, and this place isn't exactly lively. Hurry it up, will ya? I've got places to be and scores to settle.",

		Quest 		= 	"\"Bail out\"\nConrad Hawk, Amber Island, Jail\n\nPay Guardmaster James Halloran, who resides near the bridge on the island's western part, to release Conrad Hawk.",
	},
	CheckDone 		= 	false,  -- the quest can't be completed here
}

------------------------------------------------------------------------------
-- James Gladwyn
QuestNPC 			= 	485

Greeting{
	"James Gladwyn at your service!\n\nOh, you're those \"new people\" everyone keeps talking about, right? Good. New people means more trade and more trade means more gold.",
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Wealth",
	Text 			= 	"You've probably  already heard, but this island bleeds gold. It's true! Once the top supplier of amber, it's now one of the most successful trade hubs in the world. But if you ask me, the real secret to its prosperity is the low taxation. It's practically non-existent."
}
------------------------------------------------------------------------------
-- Mark Bolton
QuestNPC = 486

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Goblins",
	Text 			= 	"I'm sure that even a powerful sorcerer like Magnus the Archmage realized he can't keep extorting us alone. That's why he brought several ships' worth of goblin mercenaries to back his cause. While most headed to the castle, others roam about, stirring up trouble. Be careful when traveling beyond the town."
}
------------------------------------------------------------------------------
-- Sheila Bolton
QuestNPC 			= 	487

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"The Payne Family",
	Text 			= 	"Ashley, my older sister, lives in a small hut to the southeast of Amber Island, nestled in the swampy area. If you're looking for an expert alchemist, she's the person you should seek out."
}

Quest{  
	Name 			= 	"AmberMisc1",
	Slot 			= 	C,
	QuestItem 		= 
	{
		{200,201,202,203,204, Count = 3}, -- Red 
		{205,206,207,208,209, Count = 3}, -- Blue
		{210,211,212,213,214, Count = 3}, -- Yellow
	},
	Texts 			= 
	{		
		Topic 		= 	"Make: Black Potion (Intelligence)",
		Done 		= 	"You've already gathered all the ingredients? Excellent. Allow me a moment to prepare the potion...\n\n*After a brief period, she returns and presents you with a dark, swirling Potion of Pure Intelligence.*",
		TopicDone 	= 	false,
		Give 		= 	"I'm not exactly a master alchemist, but I do know how to concoct the \"specialty of the house\": the Potion of Pure Intelligence. If you provide the necessary ingredients, I'll be able to brew one for you.\n\nI require three ingredients from each of the following types: red, blue, and yellow.",
		Undone 		= 	"Remember, I need three ingredients from each of the following types: red, blue, and yellow.",
	},
	Exp 			= 	500,
	RewardItem 		= 	266, -- Pure Intellect
}

------------------------------------------------------------------------------
-- Julia Greene
QuestNPC 			= 	488

Greeting{
	"Come in, come in! You're just the adventurers I've been searching for. Perhaps you could do a little favor for an old lady? Oh, I'll put on some tea.",
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Robert",
	Text 			= 	"My son was stationed at that dreadful camp in the swamp.  Maximus only sends someone to check on them once in a blue moon. Now, with the whole town in turmoil, they must've forgotten about him. Poor Robi!"
}

Quest{
	Name 			= 	"AmberQuest3",
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Worrying Mother",
		TopicDone 	= 	false,
		Give 		= 	"Robert must be sitting in that wretched camp all alone, cold, wet, and hungry, with no one to look after him. Would you be kind enough to deliver this crate to him? Don't worry, I'll pay you in advance for your trouble.",
		Undone 		= 	"The food will cool down and spoil if you don't hurry up. My son is waiting for you!",

		Quest 		= 	"\"Worrying Mother\"\nJulia Greene, Amber Island, Port Island\n\nDeliver a stash of goods to Julia's son, Robert, who is stationed at the swamp camp.",
	},
	Give			= 	function(t)
							evt.Add("Gold",500)
						end,
	GivenItem 		= 	783,
	CheckDone 		= 	false,  -- the quest can't be completed here
}

------------------------------------------------------------------------------
-- James Halloran (bridge house)
QuestNPC 			= 	489

Greeting{
	"Greetings. I'm the guardmaster here, in charge of town security and overseeing the jail. What can I do for you today?"
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Crime",
	Text 			= 	"With the level of crime in this town so low, I'm practically bored to death. It's so peaceful here that dealing with Conrad's antics is the highlight of my week. A guardmaster could use a bit more excitement, you know?"
}

Quest{
	BaseName 		= 	"AmberQuest11",
	Slot 			= 	B,
	Texts 			= 
	{		
		TopicGiven 	= 	"Pay: Conrad Hawk (500g)",
		Done 		= 	"*Guardmaster Halloran smirks as he accepts the payment.*\n\nAh, another contribution to my \"Conrad Fund\". At this rate, I'll be retiring early.\n\nThanks for the business.",
		Undone 		= 	"*The guardmaster examines the offered amount with a raised eyebrow.*\n\nYou think this is enough? For this amount, Conrad might as well take up permanent residence in my cell. Come back when you've got the full amount. I'm not running a charity here.",
	},
	Exp 			= 	500,
	QuestGold 		= 	500,
	Done			=	function(t)
							evt.MoveNPC{NPC = 491, HouseId = 0}
							evt.MoveNPC{NPC = 477, HouseId = 250}
						end,
	CanShow			=	(|| vars.Quests.AmberQuest11 ~= "Done")
}
------------------------------------------------------------------------------
-- Thomas Beck
QuestNPC 			= 	490

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Ex-Miner",
	Text 			= 	"I'm the last of the old dwarven miners from the amber extraction days, decades ago. Those were hard times, but they paid off. I've accumulated enough wealth over the years, and now, I'm relishing my retirement."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Abandoned Mines",
	Text 			= 	"I spent my younger years in the abandoned mines in the northeast part of the island, mining amber. Everything changed when a huge monster showed up and tore through the place. I tried to stand up to it, but it knocked my family sword from my hand and I had to run for it. I'm still embarrassed about losing that sword.\n\nNobody's been brave enough to go near those mines since then."
}

-- Hidden quest
Quest{
	Name 			= 	"AmberQuest4",
	Slot 			= 	C,
	CanShow			= 	(|| evt.All.Cmp("Inventory", 784) or Q.AmberQuest4 == "Done"),
	Texts 			= 
	{		
		Topic 		= 	"Quest: Family Sword",
		Done 		= 	"*His eyes widen in amazement as he beholds the sword you present to him. A smile breaks across his weathered face, and he begins quietly sobbing.*"..
						"\n\nThis is the sword of my family, the very one I lost years ago in those forsaken mines. I never thought I'd see it again. Thank you, truly, from the bottom of my heart. I must insist on giving you a proper reward. The sword's worth more to me than money.",
		Undone 		= 	"false",
		GreetDone 	= 	"Greetings, friends! You are always welcome here.",
		TopicDone 	= 	"Thanks: Family Sword",
		After 		= 	"I can't thank you enough for returning this precious heirloom to me.",
	},
	NeverGiven 		= 	true,
	QuestItem 		= 	784,
	Gold 			= 	2000,
	Exp 			= 	1000,
	Done			=	function(t) 
							evt.Add("Awards", 107) -- "Found and returned Family Sword to Thomas Beck"
							evt.Subtract("Reputation", 5) 
						end
}
------------------------------------------------------------------------------
-- Urist Alesworth
QuestNPC 			= 	492

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Oak Home",
	Text 			= 	"We're descendants of the Alesworth clan, had our hands in the second expedition and all that. Our great-granddad, he built our home right under a sprouting oak on this very hill. Then, the oak got chopped and this tavern was built right where it stood. So, here we are, running the place. "
}

KillMonstersQuest{
	Name 			= 	"AmberQuest1",
	{Map 			= 	"oakhome.blv", Monster = {268, 269, 270}},
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Rat Problem",
		Give 		= 	"Me and my brother are considering fixing up our old family home. It's been ages since we've stepped foot in there, and it seems the local fauna have turned it into their own little stinkin' den!\n\n"..
						"So, I need you to head over and clear out those rats. For seasoned adventurers like yourselves, it should be a walk in the park, right? Consider it quick money in your pocket.", 
		Done 		= 	"You got them! Don't give me that look. I didn't say these were common rats. If it was just common rats, I'd hardly need adventurers! Here's compensation for your efforts.",
		Undone 		= 	"I'm still hearing squeaking from down below, which means those pests are still around. The job's not done yet!",
		TopicDone 	= 	"Thanks: Rat Problem",
		After 		= 	"I owe you a big one, adventurers. Thanks to you, my family and I can finally take back our old home. We're truly grateful for your help.",

		Quest 		= 	"\"Rat Problem\"\nUrist Alesworth, Amber Island, Powder Keg Inn\n\nGet rid of the rats from Oak Hill Cottage, situtated under the Powder Keg Inn at Port Island.",
	},
	Gold 			= 	2500,
	Exp 			= 	2500, 
	Done			=	function(t) evt.Subtract("Reputation", 5) end,
}
------------------------------------------------------------------------------
-- Harvey Yap

QuestNPC 			= 	493

Greeting{
	"New people! Welcome to the Amber Island.",
	"Good to see you again. Care for a cup of tea?",
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Amber Bank",
	Text 			= 	"Have you had a chance to check out the Amber Bank? It's massive: practically a fortress. My dad's one of the folks who keeps it running. Now, everyone talks about trade and low taxes being the lifeblood of the island's prosperity, but according to my dad, the true secret is the bank. It's where all the kings and top merchants stash their riches. Naturally, nobody wants to mess with a place that guards so much wealth."
}

Quest{
	Name 			= 	"AmberQuest2",
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Lucky Coin",
		Give 		= 	"I possess a special coin, a family heirloom passed down from my father. It has a long and storied history within our family."..
						"\n\nYou see, um, I've developed a habit of flipping it in the air while strolling through the streets. Unfortunately, disaster struck recently. A black crow snatched the coin mid-air and flew off with it, leaving me... coinless. *sobs*"..
						"\n\nIf you're willing to find it for me, I'm prepared to offer a substantial reward.",
		Done 		= 	"What? You've found it? You can't imagine how relieved and happy I am! I'll be sure to be more careful with it from now on. Here's your reward, adventurers, as promised.",
		Undone 		= 	"Still no luck finding that coin? What I'm am even saying, of course there's no luck. I lost it! *sobs*",
		GreetDone 	= 	"Ah, my favourite adventurers. I'm so happy to see you again. Come in, make yourself comfortable.",
		TopicDone 	= 	"Thanks: Lucky Coin",
		After 		= 	"I'm overjoyed to see my coin again! It's clear I need to break my tossing habit if I want to keep it safe. Thank you for your help. I won't forget this.",

		Quest 		= 	"\"Lucky Coin\"\nHarvey Yap, Amber Island, Town\n\nFind the ancient golden coin and bring it to his owner.",
	},
	QuestItem 		= 	782,
	Gold 			= 	1000,
	Exp 			= 	1500,
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}

------------------------------------------------------------------------------
-- Robert Stevenson

QuestNPC 			= 	494


Quest{
	Name 			= 	"AmberQuest7",
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Quest: Old Sea Dog",
		TopicDone 	= 	"Thanks: Old Sea Dog",
		GreetDone 	= 	"Surprise, landlubbers! Ye thought ye'd be finding treasure, but instead, ye found us!",
		-- From Editor DM Staley: I'm under the impression the above line never displays, since Stevenson is killed and disappears. Maybe the 
		Give 		= 	"Hail to you! If you don't mind, I really could use some muscle here. You see, some time ago I was attacked by a sea monster. My ship crashed into the island and I fled."..
						"\n\nCan you help me retrieve some of the goods? They should be on the east side of Amber Island, at an unusual looking tree. I could do it by myself if it wasn't for dangers that inhabit the island.",
		Undone 		= 	"Set your course straight for the treasure on the east side of Amber Island, at that unusual tree. No beast or man shall keep us from our prize.",
		Quest 		= 	"\"Old Sea Dog\"\nRobert Stevenson, Follower\n\nFind the old sailor's lost loot near a unique tree on Amber Island's east side.",
		After		=	"Cheers for delivering yourselves right into our ambush! Couldn't have made it easier if you tried!"
	},
	Give			= 	function(t)
							evt.MoveNPC{NPC = 494, HouseId = 0}
							evt.Add("NPCs", 494)
							ShowQuestEffect(true, t.TakeQuestOperation)
						end,
	CheckDone 		= 	false,  -- the quest can't be completed here
	--CanShow			=	(|| vars.Quests.AmberQuest7 ~= "Done")
}

NPCTopic{
	Slot 			= 	B,
	Texts 			= 
	{
		Topic 		= 	"What the...",
		Ungive 		= 	"Ye've walked the plank right into me trap, landlubbers! There be no sea monster here, only the consequences of crossing paths with a pirate. Now, let's see if ye can fight men as well as beasts."
	},
	CanShow			= 	(|| vars.Quests.AmberQuest7 == "Done")
}
------------------------------------------------------------------------------
-- Martha Blaine

QuestNPC 	= 	495

Quest{
	Name 			= 	"AmberQuest5",
	Slot 			= 	A,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Ransom",
		TopicDone 	= 	"Thanks: Ransom",
		Give 		= 	"Please, I am begging you, help me! My daughter Laurie has been taken by cruel ratmen. They are demanding a ransom of 1000 gold pieces, to be delivered to the north-west island."..
						"Could you possibly deliver the ransom and personally escort her back home safely?",
		Done		= 	"I cannot tell you how much it means to see Laurie safe and sound! Your bravery and kindness have brought our family back together. Here is your well-deserved reward. Thank you from the bottom of my heart.",
		Undone 		= 	"Why are you still here? Please, my daughter's safety is at stake. Deliver the ransom and bring her back to me as soon as possible, please.",
		After 		= 	"Thank you so much for bringing Laurie home. Our family will forever be grateful for what you've done.",
		Quest 		= 	"\"Ransom\"\nMartha Blaine, Amber Island, Town\n\nLaurie Blaine has been kidnapped by vicious ratmen. The ransomer is awaiting the ransom at Apple Island, located in the north-west part of the islands. Deliver the ransom or rescue her, then safely escort her back home to her mother.",
	},
	Give			= 	function(t)
							evt.Add("Gold",1000)
						end,
	Done			= 	function(t) 
							if evt.Cmp("NPCs", 516) then
								evt.Subtract("NPCs", 516)
								evt.Subtract("Reputation", 5)
								evt.MoveNPC{NPC = 516, HouseId = 552}
								ShowQuestEffect(true, t.TakeQuestOperation)
								vars.QuestsAmberIsland.QVarRansom = 5
							end
						end,
	CheckDone 		= 	(|| evt.Cmp("NPCs", 516) == true),
	RewardItem 		= 	196,
	Exp				=	2500,
}

Quest{
	Slot 			= 	B,
	Texts 			= 
	{
		Topic 		= 	"There's a problem...",
		Done 		= 	"*Upon hearing the kidnappers' new demands, Martha's face crumples in despair. Clutching a bag of gold tightly in her trembling hands, she thrusts it towards you.*\n\n This is all I have, every last coin. Please, take it. Maybe it is enough to hire some help? I beg you, Laurier is all I've got. You must bring her back to me!\n\n*Her eyes brim with tears.*",
	},
	CanShow			=	(|| vars.QuestsAmberIsland.QVarRansom == 1 and not evt.Cmp("NPCs", 516)),
	Done			= 	function(t)
							vars.QuestsAmberIsland.QVarRansom = 2
						end,
	Gold			= 	1678,
	NeverGiven 		= 	true,
}

NPCTopic{
	Slot 			= 	C,
	Topic 			= 	"Financial Issues",
	Text 			= 	"You heard? It has been one misfortune after another. First, the Archmage's mist only clouded our skies, but now he forces us to pay his exorbitant fees for our own protection. Then, my husband finds himself unable to return from his travels, trapped abroad by the same cursed mist. And as if to add insult to injury, our dear daughter Laurie was kidnapped. Each event on its own is a strain, but together, they have nearly drained our coffers dry. These are indeed dire times for the Blaine household."
}
------------------------------------------------------------------------------
-- Otho Robeson

QuestNPC 			= 	496

local function MoveOthoBackToHome()
	evt.MoveNPC{NPC = 496, HouseId = 568}
	vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.TRANSFERED
end

Quest{
	Name 			= 	"AmberQuest6",
	Slot 			= 	A,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Revenge",
		TopicDone 	= 	"Thanks: Revenge",
		Give 		= 	"Ah, so you are the newly-arrived fortune seekers? You're precisely the sort of individuals I require at this moment."..
						"\n\nMy need is one of a discreet and delicate nature, calling for a particular set of skills I believe you possess."..
						"\n\nHis name is Michael Cassio. He resides not far from here, between our town and Castle Amber. My request is simple: you must kill Cassio for me. This man has inflicted a grievous betrayal upon my house by dishonoring my wife."..
						"\n\nI offer this ring as advance payment. You may, of course, sell it and run away: a risk I am prepared to take. However, should you fulfill your commitment and then return the ring to me, I assure you, your reward will be most generous indeed.",
		Done		= 	"You actually did it? You cannot imagine my relief. I'll be stuck here for a few more hours, but once I'm out, visit my house and we will discuss your reward. Don't forget to bring the ring.",
		Undone 		= 	"The clock is ticking. Do what you have to do. End Michael Cassio.",
		After 		= 	"Let's discuss your reward at my home after I'm released from this disgusting hole. Don't forget to bring the ring.",
		Quest 		= 	"\"Revenge\"\nOtho Robeson, Amber Island, Jail\n\nLocate and eliminate Michael Cassio. He resides to the east of Amber Town, situated between the town and Castle Amber.",
	},
	GivenItem 		= 	791,
	Exp				=	2500,
	Give			= 	function(t)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.GIVEN
						end,
	Done			= 	function(t)
							evt.Add("Reputation", 10)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.RELEASED
							evt.ForPlayer("All")
							ShowQuestEffect(false,"Add")
							Timer(
								MoveOthoBackToHome, const.Hour, const.Hour + const.Minute, true)
						end,
	CanShow			=	(|| vars.QuestsAmberIsland.QVarRevenge and vars.QuestsAmberIsland.QVarRevenge < QVarRevengeState.TRANSFERED and vars.QuestsAmberIsland.QVarRevenge ~= QVarRevengeState.REPORTED),
	CheckDone		= 	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.KILLED)
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Failed: Revenge",
	Text 			= 	"You think you're clever, siding with Michael against me? You will regret this. Mark my words, you have not seen the last of me!",
	CanShow			= 	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.REPORTED)
}

NPCTopic{
	Slot 			= 	C,
	Topic 			= 	"Thanks: Revenge",
	Text 			= 	"Thank you for dealing with Cassio. I appreciate your discretion and effectiveness. I look forward to collaborating with you again in the future.",

	CanShow			= 	(|| vars.QuestsAmberIsland.QVarRevenge >= QVarRevengeState.TRANSFERED)
}

Quest{
	Slot 			= 	D,
	Texts 			= 
	{
		Topic 		= 	"Reward?",
		Give 		= 	"Here is your well-deserved reward. Do you have the ring? I'll gladly add a bonus if you do.",
	},
	Exp				=	500,
	Give			= 	function(t)
							local rewardGold = 1500
							
							if evt.All.Cmp("Inventory", 791) then
								evt.Subtract("Inventory", 791)
								rewardGold = rewardGold + 2500
							end
							evt.Add("Gold", rewardGold)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.REWARDED
						end,
	CanShow			=	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.TRANSFERED)
}
------------------------------------------------------------------------------
-- Desdemona Robeson

QuestNPC 			= 	497

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Jealous Husband",
	Text 			= 	"My husband, he's driven by such fierce jealousy, especially concerning me. It's like a madness that clouds his judgment. Just recently, he brutally attacked Michael Cassio, convinced he was involved in an affair with me. There's no reasoning with him when he gets these notions in his head. It's all so baseless, yet he believes it with every fiber of his being. It's tearing us apart."
}
------------------------------------------------------------------------------
-- Michael Cassio

QuestNPC 			= 	498

NPCTopic{
	Slot 			= 	A,
	Branch			=	"",
	Topic 			= 	"Otho Robeson",
	Text 			= 	"That Otho Robeson is a complete lunatic! He beat me to a pulp, all because of some delusional idea that I was involved with his wife. I swear, the man's lost his mind! I've done nothing to deserve that kind of treatment. He's a menace, driven by irrational jealousy, and frankly, he's dangerous. Everyone needs to watch out for him. He's completely out of control."
}

Quest{
	Slot 			= 	B,
	Branch 			= 	"",
	NewBranch		=	"Confrontation",
	Texts 			= 
	{		
		Topic 		= 	"Quest: Revenge",
		Ungive 		= 	"What is the meaning of this?",
	},
	Ungive			=	SetBranch,
	CanShow			= 	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.GIVEN)
}

Quest{
	Slot 			= 	C,
	Branch			=	"",
	Texts 			= 
	{		
		Topic 		= 	"Well?",
		Give 		= 	"We shouldn't loose any time, let's go see the mayor and tell him everything.",
	},
	CanShow			= 	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.REPORTING)
}

NPCTopic{
	Slot 			= 	D,
	Branch			=	"",
	Topic 			= 	"Thanks: Revenge",
	Text 			= 	"I'm glad that you've chosen the path of honor. You will always be a welcome guest at my home.",
	CanShow			= 	(|| vars.QuestsAmberIsland.QVarRevenge == QVarRevengeState.REPORTED)
}

-- BRANCH
Quest{
	Slot 			= 	A,
	Branch 			= 	"Confrontation",
	NewBranch		=	"void",
	Texts 			= 
	{
		Topic 		= 	"Kill Michael",
		Give 		= 	"What? Otho sent you? Well, he's picked the wrong person to intimidate. I won't go down without a fight, you lowlifes. You've underestimated me. I'm ready for whatever you've planned. Bring it on."
	},
	Give			= 	function(t)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.DUEL
							evt.MoveNPC{NPC = 498, HouseId = 0}
							local mon = SummonMonster(207, 16809, 9292, 96, true)
							mon.NPC_ID = 498
							mon.Hostile = true
							SetBranch(t)
						end
}
Quest{
	Slot 			= 	B,
	Branch 			= 	"Confrontation",
	NewBranch		=	"void",
	Texts 			= 
	{
		Topic 		= 	"Take his side",
		Give 		= 	"Thank you for choosing the path of honor. With the ring as evidence of Otho's dark intentions, we have a chance to bring the truth to light. Let's get to the mayor as quickly as possible.",
		Ungive		=	"You can't approach Michael with this option without a proof - you need that ring Otho gave you.",
	},
	CheckGive		=	(|| evt.All.Cmp("Inventory", 791)),
	Give			= 	function(t)
							vars.QuestsAmberIsland.QVarRevenge = QVarRevengeState.REPORTING
							evt.MoveNPC{NPC = 498, HouseId = 0}
							evt.Add("NPCs", 498)
							evt.Subtract("Inventory", 791)
							ShowQuestEffect(true, t.TakeQuestOperation)
							SetBranch(t)
						end	
}

------------------------------------------------------------------------------
-- Howard Carter

QuestNPC 			= 	499

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Saint Nourville",
	Text 			= 	"Many years ago, during the earliest days of amber mining on this island, a tragic accident occurred. The First Expedition was buried deep underground due to an unexpected avalanche. Only one dwarf, later known as Saint Nourville, was spared from this calamity."..
						"\n\nDriven by a profound sense of duty, he dedicated every ounce of his energy to sustain the lives of the trapped miners. He tirelessly dropped food for them, worked to clear the passage, and wove ropes for their rescue, all without a wink of sleep or a bite of food for several days. His effort paid off, and he successfully orchestrated their rescue."..
						"\n\nIn gratitude, the miners established a temple in his honor and erected a statue in the swamp to honor his heroic deed."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"First Expedition",
	Text 			= 	"It's believed that amber on this island was first discovered quite by chance by a marooned sailor who managed to survive here alone for four years. After his eventual rescue, he assembled a group of fortune seekers who would become the initial mining team, initiating what is now known as \"The First Expedition.\" "..
						"\n\nThis marked the dawn of civilization on Amber Island. The name of this resourceful founder, however, remains lost to history."
}


KillMonstersQuest{
	Name 			= 	"AmberQuest8",
	{Map 			= 	"amber.odm", Monster = {265, 266, 267}},
	Slot 			= 	C,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Swamp Creatures",
		Give 		= 	"I've got some archaeological work to do in the swampy area on the southern island, but it's crawling with nasty lizards. Could you clear them out for me? I need that area safe to dig.",
		Done 		= 	"Awesome job, folks. You've really helped me out. If you ever find yourselves near the swamp, drop by and see what we're uncovering.",
		Undone 		= 	"Those creatures are still causing trouble on the southern island. I can't start my work with them around.",
		TopicDone 	= 	"Thanks: Swamp Creatures",
		After 		= 	"There's some fascinating stuff here in the swamp, but digging through this muck is a challenge. Your help has been invaluable in making it possible.",

		Quest 		= 	"\"Swamp Creatures\"\nHoward Carter, Amber Island, Town\n\nClear out the hostile lizards in the swampy area on the southern island so Howard Carter can proceed with his archaeological work.",
	},
	Gold 			= 	2000,  -- reward: gold
	Exp 			= 	1500,  -- reward: experience
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}
------------------------------------------------------------------------------
-- John Constantine

QuestNPC 			= 	500

Greeting{

	"Ah, welcome! I'm John Constantine, a warlock specializing in demonic studies. I see many adventurers pass through in search of fortune. What adventures bring you to our enchanted shores today?"
}

KillMonstersQuest{
	Name 			= 	"AmberQuest9",
	{Map 			= 	"amber.odm", Monster = {22}},
	Slot 			= 	A,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Ritual",
		Give 		= 	"Before he started using goblins, Archmage Magnus placed several demonic altars across the island, which summoned demons he used to keep the village in line. Thanks to my magic and adventurers like you, there's only one altar left. It's in the woods on the southern island. Head there, and use this scroll to cast a spell that will cleanse the area of the Archmage's corrupting magic. Be warned: unlike the other altars, the demon protecting this altar is powerful. It will likely appear when you begin the cleansing.",
		Done 		= 	"Excellent work! I can sense even the air is a bit fresher now. You've successfully cleansed the area of the Archmage's foul magic. Here's the gold you deserve for your work.",
		Undone 		= 	"Don't forget, to complete the ritual. You must summon and defeat the demon at the altar on the southern island using this magical scroll.",
		TopicDone 	= 	"Thanks: Ritual",
		After 		= 	"Thanks to you our island is now free from demonic influence. On behalf of the entire town, I extend our deepest gratitude. You've done a great service for us all.",

		Quest 		= 	"\"Ritual\"\nJohn Constantine, Amber Island, Swamp Island Forest\n\nSummon and defeat the demon at the altar in the forested area of the southern island.",
	},
	GivenItem 		= 	785,
	CheckDone 		= 	function(t)
							
							-- extra check for monster
							for _, mon in Map.Monsters do
								if mon.Id == 22 and mon.HP > 0 then
									return false
								end
							end

							return vars.QuestsAmberIsland.QVarRitual == true
						end,
	Gold 			= 	2500,
	Exp 			= 	1500,
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Demons",
	Text 			= 	"Demons are vile abominations, the embodiment of evil. They never bring anything good into our world. Their origins are shrouded in mystery, but their presence is always a blight."
}
------------------------------------------------------------------------------
-- Samanatha Ferrum
QuestNPC 			= 	501

Greeting{
	"You seem like a capable band of adventurers. If you ever come across a piece of amber, consider bringing it to me. I'm willing to offer you double its usual price.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Sell: Amber for 300g",
		Done 		= 	"Wonderful piece! Please come again and bring more amber.",
		Undone 		= 	"It appears you don't possess any suitable amber. Should you come across any, please return.",
	},
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	Gold 			= 	300,
	QuestItem		=	788
}
------------------------------------------------------------------------------
-- Amelia Lightfeather
QuestNPC 			= 	502

Greeting{
	"Greetings, fellow traveler! If you're in need of an extra boost on your journeys, I have a collection of \"Jump\" spell scrolls, gathered during my own adventures.\n\nSince I no longer have a need for these scrolls, I'm looking to sell them to someone who can put them to good use.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Buy: Jump Scroll, 250g",
		Done 		= 	"I'm happy to see the scrolls go to someone who can use them. Thank you for buying, and may your adventures be both exciting and profitable.",
		Undone 		= 	"I get that they're not flying off the shelves, and I have plenty, but they still cost me quite a bit of effort to acquire. I can't part with them unless you have the full amount."
	},
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	QuestGold 		= 	250,
	RewardItem 		= 	315,
}

------------------------------------------------------------------------------
-- Julia McBane
QuestNPC 			= 	504

Greeting{
	"Greetings, travelers! I am the principal teacher of this island, guardian of its exclusive knowledge. Today, I offer you an invaluable opportunity to delve into a lecture steeped in the unique wisdom of our land. This session is available for 1500g, an investment that promises to enrich your journey with profound insights and expertise found nowhere else.",
}

-- @todo	for future mm8-like experience, give exp exlusively to available party heroes. Allow re-usage. Adjust price per person.
Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Buy: Lecture (+1000xp) for 1500g",
		Done 		= 	"An investment in knowledge is the best kind of investment. You won't regret your decision; it's worth every coin. Now, follow me...",
		Undone 		= 	"While I firmly believe that knowledge is power, it also comes with its cost. Unfortunately, without the necessary gold, I cannot share this powerful wisdom with you.",
		After 		= 	"You've already attended all the classes available for the season. I can't let you pay for what you already know. You already know everything I can teach you."
	},
	NeverGiven 		= 	true,
	QuestGold 		= 	1500,
	Exp				=	1000
}

------------------------------------------------------------------------------
-- Ella Borg
QuestNPC 			= 	506

Greeting{
	"I'm an amateur glassworker. I can sell you empty flasks for your alchemical needs for 25g.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Buy: Empty Flask for 25g",
		Done 		= 	"Though I'm still mastering my craft, this flask is made to withstand the rigors of alchemy. Thank you for your purchase.",
		Undone 		= 	"I'm sorry, but even though it's quite affordable, I must ask for the full price. Crafting, even at this level, demands time and materials."
	},
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	QuestGold 		= 	25,
	RewardItem 		= 	220,
}
------------------------------------------------------------------------------
-- Jane Goodwin
QuestNPC 			= 	507

Greeting{
	"Greetings!\n\nI make red and blue potions for my brother at Saint Nourville Cathedral. I've got a few extra potions on hand that I could offer you.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Buy: Crate of Red Potions (x8) for 500g",
		Done 		= 	"Thank you for your purchase! I'm sure my potions will serve you well.",
		Undone 		= 	"I'd love to help you out with a better price, but the potions are already priced lower when bought in bulk like this. I can't go any lower."
	},
	CanShow			= 	(|| vars.MiscAmberIsland.BulkCurePotionSale == true),
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	QuestGold 		= 	500,
	Done 			= 	function(t)
							vars.MiscAmberIsland.BulkCurePotionSale = false
							for i = 0, 8, 1 do
								evt.GiveItem(1, const.ItemType.Potion_, 222)
							end
							Timer(
								function()
									vars.MiscAmberIsland.BulkCurePotionSale = true
								end, const.Week, const.Hour, true)
						end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Buy more! (Cure Potion)",
	CanShow			= 	(|| vars.MiscAmberIsland.BulkCurePotionSale == false),
	Text 			= 	"I'm glad you're interested in more potions, but I've just sold out my current stock. Give me a week to prepare a fresh batch, and I'll have them ready for you."
}

Quest{
	Slot 			= 	C,
	Texts 			= 
	{
		Topic 		= 	"Buy: Crate of Blue Potions (x8) for 500g",
		Done 		= 	"Thank you for your purchase! I'm sure my potions will serve you well.",
		Undone 		= 	"I'd love to help you out with a better price, but the potions are already priced lower when bought in bulk like this. I can't go any lower."
	},
	CanShow			= 	(|| vars.MiscAmberIsland.BulkManaPotionSale == true),
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	QuestGold 		= 	500,
	Done 			= 	function(t)
							vars.MiscAmberIsland.BulkManaPotionSale = false
							for i = 0, 8, 1 do
								evt.GiveItem(2, const.ItemType.Potion_, 223)
							end
							Timer(
								function()
									vars.MiscAmberIsland.BulkManaPotionSale = true
								end, const.Week, const.Hour, true)
						end
}

NPCTopic{
	Slot 			= 	D,
	Topic 			= 	"Buy more! (Mana Potion)",
	CanShow			= 	(|| vars.MiscAmberIsland.BulkManaPotionSale == false),
	Text 			= 	"I'm glad you're interested in more potions, but I've just sold out my current stock. Give me a week to prepare a fresh batch, and I'll have them ready for you."
}
------------------------------------------------------------------------------
-- Aldous Chapman
QuestNPC 			= 	508

Greeting{
	"Welcome to Chapman residence. I am a well-known merchant here, ready to offer you an array of exquisite goods. Our island's treasures are renowned far and wide, and I'm here to provide you with the best trading experience.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Buy: Amber Apple Cider for 1500g",
		Done 		= 	"Thank you for your purchase. These bottles can only be bought here and can fetch a high price in mainland cities.",
		Undone 		= 	"If you don't have enough gold, you'll have to come back when you do."
	},
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	QuestGold 		= 	1500,
	RewardItem 		= 	789,
}

Quest{
	Slot 			= 	B,
	Texts 			= 
	{
		Topic 		= 	"Sell: Coffee Beans for 3000g",
		Done 		= 	"Here on Amber Island, we have a great love for coffee. Your sale is much appreciated!",
		Undone 		= 	"It appears you don't have any coffee beans with you.",
	},
	NeverGiven 		= 	true,
	NeverDone 		= 	true,
	Gold 			= 	3000,
	QuestItem		=	790
}

------------------------------------------------------------------------------
-- Grimwald Hawk
QuestNPC 			= 	509

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Conrad",
	Text 			= 	"I'm at my wit's end with my son, Conrad. He's always stirring up trouble, provoking others, and seeking out fights. It's a constant source of embarrassment. I wish he'd settle down, start a family, build a home, and lead a respectable life instead of wandering around like a aimless loafer. "
}
------------------------------------------------------------------------------
-- Alaric Shadoweaver
QuestNPC 			= 	510

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Liberal Attitudes",
	Text 			= 	"This island is a sanctuary for those with an open-minded stance on magic. Here, it doesn't matter if you practice light or dark magic as long as you don't harm others. That's why my wife and I chose to settle here, seeking refuge from those who couldn't see beyond their prejudices."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Necromancy",
	Text 			= 	"Being a necromancer is just a profession, like any other, and doesn't inherently make one evil. I do understand where the distrust comes from. Many necromancers choose isolation, and their practices can be unsettling. But remember, not all of us wish to summon legions of human skeletons. Sometimes, a little chicken skeleton minion is all you need for company."
}
------------------------------------------------------------------------------
-- Mirabel Shadoweaver
QuestNPC 			= 	511

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"The Future",
	Text 			= 	"*Her speech is slow and stuttering.*"..
						"\n\nOnce we resolve the situation with Archmage Magnus, I plan to establish a guild of dark magic, providing a sanctuary for practitioners of all kinds of marginalized magical practices."
}
------------------------------------------------------------------------------
-- Bertram Smith
QuestNPC 			= 	512

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Diversity",
	Text 			= 	"Ever wondered why this place is so full of individuals of different races? Our island's diversity stems all the way from its origin story. It was uninhabited before The First Expedition, which meant the first settlers were dwarves, but the island quickly became a bustling trading hub, attracting individuals of all races seeking wealth and opportunity. Despite our differences, the pursuit of prosperity brings us together."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Castle Amber",
	Text 			= 	"Saint Nourville and the rest of the First Expedition were good folk, but it's been generations since they were around. When Nourville's grandson Dargrin built Castle Amber, he was trying to make it look like one of the mainland castles. They say Dargrin and his descendants used to act like ambassadors for visitors from the mainland. Since then, various people have lived in the castle, but none of them have been dangerous. On this island the mayor is the only one with actual political power. I guess it was only a matter of time before someone like Archmage Magnus claimed the place."
}
------------------------------------------------------------------------------
-- Florian Flavius
QuestNPC 			= 	513

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Ratmen Pirates",
	Text 			= 	"Sometimes, these ratmen pirates sneak onto the island under the cover of night. I think they want to carry out their deeds unnoticed. However, there are occasions when their presence brings chaos and disruption to the island, so I wouldn't say they're subtle either. Did you hear about how they grabbed Martha's daughter?"
}
------------------------------------------------------------------------------
-- Elisabeth 
QuestNPC 			= 	514

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Horse Statue",
	Text 			= 	"The story goes back to Maximus's youthful days. In a fierce battle, he was gravely injured. His faithful horse, Stormhoof, raced tirelessly for half a day, bringing him back home to safety. Later, when he became mayor, he ordered the creation of a magnificent statue to honor the gallant creature. That's my husband. He's always been fond of grand symbolic gestures."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Failed Adventurers",
	Text 			= 	"There have been a lot of adventurers who tried to do something about Archmage Magnus. Maximus has been desperate to hire help, but the adventurers all inevitably end up dead. I know it's been keeping him up at night. He's doing what he can to make sure that the adventurers he sends after Magnus are competent, but the last group were veterans and they were still slaughtered."
}
------------------------------------------------------------------------------
-- Robert Greene
QuestNPC 			= 	515

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Lizards",
	Text 			= 	"These swamp lizards are the real deal when it comes to local predators. Surprisingly, they're missing the petrifying ability of their mainland cousins.",
}


Quest{
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Legate",
		TopicDone 	= 	false,
		Done 		= 	"Upon receiving the letter, Sir Greene's expression is focused and serious. Without uttering a single word, he begins to pen a response, the quill scratching quickly across the parchment. Moments later, he finishes, folds the letter, and seals it before handing it back to the heroes.\n\nThen, breaking his silence, he says, \"Hurry, bring this back to the mayor as soon as possible.\"",
		Undone 		= 	"If the Mayor tasked you to deliver a letter to me, where is the letter?",
	},
	NeverGiven		=	true,
	RewardItem		=	795,
	QuestItem 		= 	794,
	Exp				=	250,
	CanShow			=	(|| vars.Quests.StoryQuest1 == "Given"),
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}

Quest{
	BaseName 		= 	"AmberQuest3",
	Slot 			= 	C,
	Texts 			= 
	{		
		TopicGiven 	= 	"Quest: Worrying Mother",
		TopicDone	= 	"Thanks: Worrying Mother",
		Done 		= 	"Delivery from whom? My Mother? Again? *Sigh*\n\nI'm an annointed knight and a respected leader of our community, and she still treats me like a child. Oh well, let's at least see what she's sent... junk, lots of food and, of course, socks. And a note. *Sir Green quickly reads the note.*\n\n I'm told to give you this purse of gold. The path through this swamp is dangerous, so I guess you deserve it.",
		Undone 		= 	"Hmm?",
		After 		= 	"One of the most pieces of advice I've received as a soldier is to keep your socks dry. Being in the swamp makes this especially true and my momma knows it.\n\nCherish you mothers, adventurers. Sometimes they can look out for you in ways no one else will.",
	},
	Exp 			= 	1000,
	Gold 			= 	500,
	QuestItem 		= 	783,
	Done			=	function(t) evt.Subtract("Reputation", 5) end
}
------------------------------------------------------------------------------
-- Laurie Blaine
QuestNPC 			= 	516

Quest{
	Slot 			= 	A,
	Texts 			= 
	{
		Topic 		= 	"Rescue!",
		Done 		= 	"You do not look like those dreadful ratmen pirates. Are you here to rescue me?",
	},
	CanShow			=	(|| evt.Cmp("NPCs", 516) == false and vars.QuestsAmberIsland.QVarRansom ~= 5 ),
	NeverGiven 		= 	true,
	Done			= 	function(t) 
							for _, mon in Map.Monsters do
								if mon.NPC_ID == 516 then
									RemoveMonster(mon)
								end
							end
							evt.Add("NPCs", 516)
							evt.Subtract("Reputation", 5)
							evt.Add("Awards", 106) -- "Rescued Laurie Blaine"
							ShowQuestEffect(true, t.TakeQuestOperation)
							vars.QuestsAmberIsland.QVarRansom = 3
							vars.QuestsAmberIsland.QVarRansomTaken = true
							Game.NeedRedraw = true
						end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Hostage",
	Text 			= 	"Surprisingly, despite their fearsome reputation, the ratmen pirates treated me quite well. They provided me with food and even respected my privacy. It is strange to think such menacing figures could show a hint of kindness. "
}
------------------------------------------------------------------------------
-- Julius Cheeser
QuestNPC 			= 	517

Greeting{
	"Are you feeling a bit disoriented, pal? In search of a thrilling adventure and the promise of treasure, perhaps? It seems you've stumbled upon the perfect opportunity.",
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Favor",
	Text 			= 	"Do me a favor, will you? Locate the Blaine residence in Amber Town and deliver a message for me. Tell them to think faster if they wish to see their daughter again. \n\nMaybe we'll share the loot together, friend.",
	CanShow			= 	(|| Q.AmberQuest5 == nil)
}

NPCTopic{
    Slot            =   A,  
    Topic           =   "Laurie Blaine",
    Text            =   "The lass is safe and sound, snug as a bug in a rug! But she's itching to see home. Just make sure you bring the gold, all of it. We wouldn't want to prolong her stay, now would we?",
    CanShow         =   (|| Q.AmberQuest5 and vars.QuestsAmberIsland.QVarRansom ~= 3)
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Pirate Life",
	Text 			= 	"With everyone on Amber Island losing their heads over the mist crisis, they ain't watching their bloody valuables. Perfect time for a quick snatch, if you ask me."
}

Quest{
	Slot 			= 	C,
	CanShow			= 	(|| Q.AmberQuest5 ~= nil and vars.QuestsAmberIsland.QVarRansom == 0),
	Texts 			=
	{
		Topic 		= 	"Pay: Ransom (1000g)",
		Done 		= 	"Ah, bless your hearts, you've brought the gold! But, oh dear, what's this? Just 1000 gold pieces? My, my, they must've misheard me. I distinctly recall saying 5000 gold, not a coin less. Run along now, fetch the proper amount. \n\nNo hard feelings, eh? Just a little misunderstanding! *bursts into snorting laughter*",
		Undone 		= 	"Are you messsing with me, friend? You don't have enough gold.",
	},
	Done			= 	function(t)
							vars.QuestsAmberIsland.QVarRansom = 1
						end,
	NeverGiven 		= 	true,
	QuestGold		= 	1000
}

Quest{
	Slot 			= 	D,
	Texts 			= 
	{
		Topic 		= 	"Pay: Ransom (5000g)",
		Done 		= 	"Nice doing business with you, friend. Here's the gal, now get lost.",
		Undone 		= 	"Are you messsing with me, friend? You don't have enough gold.",
	},
	CanShow			=	(|| vars.QuestsAmberIsland.QVarRansom == 1 or vars.QuestsAmberIsland.QVarRansom == 2),
	NeverGiven 		= 	true,
	QuestGold 		= 	5000,
	Done			= 	function(t) 
							evt.Add("NPCs", 516)
							ShowQuestEffect(true, t.TakeQuestOperation)
							vars.QuestsAmberIsland.QVarRansom = 3
							vars.QuestsAmberIsland.QVarRansomTaken = true
						end
}

-- Julius Cheeser #2 (Apple Cave Entrance)
QuestNPC			=	521

Greeting{
	"Where do you think you're going without an invitation, friend? Take one more step and we won't be so friendly anymore.",
}

Quest{
	Slot 			= 	E,
	Texts 			=
	{
		Topic 		= 	"Ignore warning",
	},
	NeverGiven		=	true,
	Done			=	function(t)

							if vars.QuestsAmberIsland.QVarRansom ~= 3 then
								vars.QuestsAmberIsland.QVarRansom = 4
							end

							for _, mon in Map.Monsters do
								if mon.Group == 33 then
									mon.Hostile = true
									ExitScreen()
								end
							end
						end
}

Quest{
	Slot 			= 	F,
	Texts 			=
	{
		Topic 		= 	"Back off",
	},
	Done 			= 	function(t)
							ExitScreen()
						end,
	NeverGiven		=	true,
	NeverDone 		= 	true,
}

------------------------------------------------------------------------------
-- Buster Squaky (Prisoner)
QuestNPC 			= 	518

Greeting{
	"Ah, my dear saviors...\n\nTo think, my own kin turned against me, but here you are, bold and brave, setting me free. How delightfully unpredictable.\n\nPut my skills to use, friends. At your side, I'll guide you through the shadows and get the dirty jobs done.",
}

Quest{
	Slot 			= 	A,
	Texts 			= 	{
		Topic 		= 	"Hire: Ratman (0g)",
		Done		=	"Excellent choice. Just remember, while I may play in the shadows, my loyalty to you is as sharp and unwavering as my claws. Together, we'll be rich enough to do whatever we want.",
		Undone		=	GuildMasterNotEnoughGoldStr,
	},
	NeverGiven		=	true,
	CanShow			=	function(t) 
							local Merc = Merc_GetByID(526)
							return Merc_IsHired(Merc) == false end,
	Done			=	function(t)
							local Merc = Merc_GetByID(526)
							Merc_Hire(Merc)
							Merc_MakeAvailableForHire(Merc.NPC_ID)
							evt.Add("NPCs", Merc.NPC_ID)
							
							for _, mon in Map.Monsters do
								if mon.NPC_ID == 518 then
									RemoveMonster(mon)
								end
							end
						end
}

------------------------------------------------------------------------------
-- Samuel Krell
QuestNPC 			= 	519

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Welcome!",
	Text 			= 	"Welcome to the Spirit Guild. If you'd like, you can donate to the restoration of the Day of the Gods pedestal. Your contributions help and could bring you blessings that assist in your adventures. It's a way to gain favor and protection for your journeys."
}

PedestalDOTGThankYouStr = "Thank you for your donation. May the blessings from the Day of the Gods pedestal help and protect you on your adventures."

Quest{
	Slot 			= 	B,
	Texts 			= 
	{
		Topic 		= 	"Fix: Day of the Gods Pedestal (8000g)",
		Done 		= 	PedestalDOTGThankYouStr,
		Undone 		= 	"Come back when you have enough gold.",
		TopicDone 	= 	"Thanks: Day of the Gods Pedestal",
		After 		= 	PedestalDOTGThankYouStr,
	},
	NeverGiven 		= 	true,
	QuestGold 		= 	8000,
	Done			= 	function(t) 
							for i, a in Map.Sprites do
								if a.Id == 1337 then
									a.Invisible = false
								end
							end
						end
}

------------------------------------------------------------------------------
-- Pirate Stash (Lighthouse)

QuestNPC 			= 	522

Quest{
	Slot 			= 	D,
	Texts 			= 
	{
		Topic 		= 	"Quest: Open Chest",
		Done 		= 	"With a creaking sound, the chest's lid swings open to reveal its contents: a gleaming hoard of 1208 gold pieces, piled neatly inside, waiting to be claimed.",
		Undone 		= 	"The chest is securely locked, its heavy lid refusing to budge. A distinct pirate insignia marks the lock, indicating a specific key is needed to open it.",
	},
	CanShow			=	(|| vars.Quests.AmberQuest7 == "Done"),
	NeverGiven 		= 	true,
	Gold 			= 	1208,
	QuestItem		=	792,
	Exp				=	500,
	Done			= 	function(t) 
							ShowQuestEffect(true, t.TakeQuestOperation)
							evt.MoveNPC{NPC = 522, HouseId = 0}
						end
}

------------------------------------------------------------------------------
-- Sir Hoppington the Brave

QuestNPC 			= 	523

Greeting{
	"Ah, greetings, noble adventurers! I am Sir Hoppington the Brave, at your service. I find myself in a bit of a pickle, and I require assistance of the highest order.",
	"Welcome back, adventurers? Any news about my missing pet?"
}

Quest{
	Slot 			= 	A,
	Name			=	"AmberQuest10",
	Texts 			= 
	{
		Topic 		= 	"Quest: Missing Pet",
		TopicDone 	= 	"Thanks: Missing Pet",
		After 		= 	"Thank you, brave souls, for returning my precious bunny. Your kindness won't be forgotten.",
		Give		=	"I've got a unique problem. My magical talking bunny has gone missing, and I miss it terribly. I need your help to find it quietly and bring it back. Will you help me?",
		Done 		= 	"Joyous day! My heart swells with gratitude at the sight of my dear friend returned to me. You have my deepest thanks and the eternal gratitude of Sir Hoppington the Brave!",
		Undone 		= 	"Alas, my heart is heavy with worry, and my armor feels unusually burdensome without my little companion by my side. Have you perchance found any trace of my lost friend?",
		GreetDone	=	"Ah, my valiant rescuers! Welcome back. Seeing my little companion frolicking once again fills me with immeasurable happiness. How may Sir Hoppington the Brave assist you today?",
		Quest 		= 	"Missing Pet\nSir Hoppington the Brave, Amber Island, East Area\n\nFind and return Sir Hoppington's missing talking bunny.",
	},
	Gold 			= 	1000,
	Exp				=	1000,
	CheckDone		=	(|| evt.Cmp("NPCs", 524) == true),
	Done			= 	function(t) 
							evt.Subtract("Reputation", 5)
							evt.Subtract("NPCs", 524)
							evt.MoveNPC{NPC = 524, HouseId = 605}
						end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Castle Amber",
	Text 			= 	"Here in the shadow of Castle Amber, we knights stand vigilant, guarding against any threats that might emerge from its darkened halls. Recently, it's become a stronghold for goblins, and our main task is to ensure they don't spill into the town and jeopardize our people's safety. It's a constant battle, holding the line here, but it's crucial to keep the peace and protect the locals from harm."
}

------------------------------------------------------------------------------
-- Bunny

QuestNPC 			= 	524

Greeting{
	"Hello! Who are you? I wasn't expecting visitors.",
	"What's up?"
}

Quest{
	Slot 			= 	A,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Missing Pet",
		Give 		= 	"Sir Hoppington sent you? I do miss my warm bed... But why should I trust you?",
		Done 		= 	"Back to Sir Hoppington, huh? Alright, lead the way, but keep the carrots coming!",
		Undone 		= 	"Hey, what's the big idea? I'm not just some toy to be picked up. Where's the trust, huh?",
		GreetDone 	= 	"What's up, folks? Do you have more carrots? I really could use a bite you know.",
		TopicDone 	= 	false,
	},
	CanShow 		= 	|| Q.AmberQuest10 == "Given",
	QuestItem 		= 	793,
	Done			=	function(t)
							evt.MoveNPC{NPC = 524, HouseId = 0}
							evt.Add("NPCs", 524)
						end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Other Bunnies",
	Text 			= 	"I met another bunny in the field today and excitedly started a conversation. I talked and talked, but he just stared at me, munching on his carrot. I finally concluded he must be a little slow, or maybe he's just really good at keeping secrets!"
}

NPCTopic{
	Slot 			= 	C,
	Topic 			= 	"Home",
	Text 			= 	"I ventured out one day in search of the world's crunchiest carrots, and what an adventure it's been! I've hopped through fields, nibbled in gardens, and danced under moonlit skies...\n\nBut now, I seem to have hopped a bit too far. I can't quite remember the way back to my original home."
}

------------------------------------------------------------------------------
-- Aedan Kelly
QuestNPC 			= 	527

Greeting{
	"Hmm? Fancy a drink, stranger?"
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Regrets",
	Text 			= 	"Yeah, I was part of a group that came here seeking adventure a fortune in gold. We fought our way through the west wing of Archmage Magnus's Residence, even reached a teleportation pedestal. One of our own tried it and never came back. Then we were ambushed. I'm the sole survivor. \n\nEnough adventuring for me. I'm heading home!"
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Magnus's Residence",
	Text 			= 	"The Archmage's Residence is a grand house in the southwestern part of Swamp Island. Inside, it's quite lavish, but don't let that fool you: it's teeming with elemental guards. Tough ones, and oddly, they seem at odds with each other. We tried to locate the Archmage but couldn't find him, only this blasted teleport stone. Our best guess was he's holed up in the central workshop."
}

Quest{
	Slot 			= 	C,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Investigation",
		Done 		= 	"So, you're treading the path we did? You'll need all the luck you can get. Here, take this teleportation stone. We used it in the residence's western chamber. One of our team went through and vanished. Perhaps you'll have more success, maybe even find our lost companion.",
		TopicDone 	= 	false,
	},
	NeverGiven		=	true,
	RewardItem 		= 	781,
	Exp				=	100,
	CanShow			=	(|| vars.Quests.StoryQuest2 ~= nil)
}

NPCTopic{
	Slot 			= 	D,
	Topic 			= 	"Teleportation Stone",
	Text 			= 	"We found this magical stone in a very weird place. It was an eerie location where furniture floated in space, defying all logic. Keep your eyes open for places that feel out of the ordinary; you never know what you might find.",
	CanShow			=	(|| vars.Quests.StoryQuest2 ~= nil)
}

------------------------------------------------------------------------------
-- Barnaby Whitfield
QuestNPC 			= 	528

Greeting{
	"Ah, leave me alone! I've already spilled everything I know to the guards... There's nothing more to say."
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Butler",
	Text 			= 	"Yes, I was Archmage Magnus's butler. Then he lost his mind, and just because I worked for him, I'm treated like a criminal! I'm innocent, yet here I am, suffering for his madness."
}

Quest{
	Slot 			= 	B,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Investigation",
		Done 		= 	"Fine, fine. Magnus does have a secret hideout. It's less a home and more a magical lab, where he dabbles in teleportation and other things that involve bending reality. He could be in his bedroom or lost in one of those twisted realities he's so fond of. He's been spending more and more time outside our world."..
						"\n\nHere, take this medallion. It may look insignificant, but it's imbued with magic. With it, you can use the teleportation platform near the knights' camp in the swamp's southeastern region to reach his hideout.",
		TopicDone 	= 	false,
	},
	NeverGiven		=	true,
	RewardItem 		= 	796,
	Exp				=	100,
	CanShow			=	(|| vars.Quests.StoryQuest3 ~= nil)
}

------------------------------------------------------------------------------
-- Cedrick Boyce (Town)
QuestNPC 			= 	530

Greeting{
	"Ahoy there! Looking for a boat? I can't go very far because of the mist nowadays, so I'm just waiting for a chance to use my skills again."
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"The Mist",
	Text 			= 	"That unnatural mist circling the island is a real menace, messing with ship navigation. Thankfully, it usually doesn't envelop the island itself, making boat travel in shallow waters a safer bet. Just point the way, and I'll steer us clear of the thick fog."
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Travel: Arena",
	NeverGiven		= 	true,
	NeverDone		=	true,
	CanShow			=	function(t) return vars.MiscAmberIsland.ArenaCounterStarted == false or evt.Cmp("Counter1", 24 * 5) == true end,
	Done			=	function(t) 
							vars.MiscAmberIsland.ArenaCounterStarted = true
							evt.Set("Counter1", 0)
							evt.MoveToMap{
								X = 3840, Y = 2880, Z = 192, 
								Direction = 1536, LookAngle = 0, SpeedZ = 0, 
								HouseId = 0, Icon = 0, Name = "D05.blv"}					
						end
}

NPCTopic{
	Slot 			= 	B,
	Topic 			= 	"Travel: Arena",
	Text 			= 	"Sorry, but the arena is currently closed and will reopen in 24 hours. Please come back later.",
	CanShow			=	function(t) return vars.MiscAmberIsland.ArenaCounterStarted == true and evt.Cmp("Counter1", 24 * 5) == false end,
}

NPCTopic{
	Slot 			= 	C,
	Topic 			= 	"Travel: Castle Amber",
	NeverGiven		= 	true,
	NeverDone		=	true,
	CanShow			=	(|| vars.Quests.CoreQuest ~= nil),
	Done			=	function(t) 

							-- Launch attack
							if vars.MiscAmberIsland.AttackOnCastleAmber == 0 then

								vars.MiscAmberIsland.AttackOnCastleAmber = 1
							
							end

							evt.MoveToMap{
								X = 19868, Y = 22474, Z = 10, 
								Direction = 1378, LookAngle = 0, SpeedZ = 0, 
								HouseId = 175, Icon = 1, Name = "amber-east.odm"}
						end
}

------------------------------------------------------------------------------
-- Isabella Morland (Ambassador)
QuestNPC 			= 	529

Greeting{
	"Greetings, distinguished heroes, I come as an envoy of King Richard Ironheart, bearing a message of great import."
}

Quest{
	Name 			= 	"AmberEndQuest",
	Slot 			= 	A,
	Texts 			= 
	{		
		Topic 		= 	"Quest: Royal Audience",
		TopicDone 	= 	false,
		Give 		= 	"Heroes of Amber Island, your valor has caught the eye of King Richard Ironheart himself. He extends an invitation to join him at the palace, where your courage can play a pivotal role in an event of great significance to the realm."..
						"\n\nThe king's fleet awaits to escort you across the seas to the mainland, where your next great adventure beckons. Consider this voyage a token of the realm's gratitude. Your passage is free, courtesy of King Richard Ironheart.",
		Undone 		= 	"Time is of the essence, noble heroes. While your deeds are many, the realm urgently requires your prowess. I urge you to hasten your preparations and set sail with us to the mainland.",

		Quest 		= 	"\"Royal Audience\"\nIsabella Morland, Amber Island, Town Hall\n\nEmbark on a voyage by ship to the mainland to attend an audience with King Richard Ironheart.",
	},
	CheckDone 		= 	false,  -- the quest can't be completed here
}


NPCTopic{
	Slot 	= 	B,
	Topic 	= 	"The End (Victory!)",
	Text 	= 	"Good job!",
	CanShow = 	function(t) return vars.QuestsAmberIsland.QVarEndGame == false end,
	Ungive 	= 	function(t)
					if vars.QuestsAmberIsland.QVarEndGame == false then
						vars.QuestsAmberIsland.QVarEndGame = 1   
						--evt.ShowMovie{DoubleSize = 1, ExitCurrentScreen = true, Name = "\"Endgame 1 Good\" "}
						Party.QBits[99] = true
						SuppressSound(true)
						while Game.CurrentScreen ~= 0 do
							Game.Actions.Add(113, 1)
							Game.Actions.Process()
						end
						SuppressSound(false)
						evt.EnterHouse(600)
					end
				end
}

------------------------------------------------------------------------------
-- Cedrick Boyce (Castle Amber)
QuestNPC 			= 	531

Greeting{
	"Ahoy there! Ready to set sail?"
}

NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Travel: Island Town",
	NeverGiven		=	true,
	NeverDone		=	true,
	Done			=	function(t) 
							evt.MoveToMap{
								X = -3385, Y = 13553, Z = 101, 
								Direction = 0, LookAngle = 0, SpeedZ = 0, 
								HouseId = 191, Icon = 1, Name = "amber.odm"}
						end
}

------------------------------------------------------------------------------
-- Tobias Saltybeard (Start ship)
QuestNPC 			= 	532

Greeting
{
	"Ahoy! I'm Tobias Saltybeard, captain of this vessel",
	"Good to see you again. Maybe we'll be off on another voyage soon enough."
}


NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Arrival",
	Text 			= 	"Here we are, at port on Amber Island. We were lucky enough to get here before the magical mist appeared again. Mind you, there's no way out of it until the mist clears, so it seems we'll be extending our stay a bit longer than expected. Best make the most of it, eh?"
}

------------------------------------------------------------------------------
-- Tobias Saltybeard (Second ship)
QuestNPC 			= 	533

Greeting
{
	"Ahoy, matey! May I introduce myself, Captain Benjamin Barnacle of the Black Betty. Welcome aboard. Looking to book passage?",
	"Welcome back. The Black Betty welcomes you."
}


NPCTopic{
	Slot 			= 	A,
	Topic 			= 	"Trade and Mist",
	Text 			= 	"This island, smack in the center of the vast ocean, serves as a pivotal point between the two continents. Most ships on intercontinental voyages make a stop here to resupply. However, the recent mist crisis has made it quite a challenge to reach. Navigating these waters has become a task only the bravest dare tackle. Lucky for me, the crew of the Black Betty don't lack for courage."
}
