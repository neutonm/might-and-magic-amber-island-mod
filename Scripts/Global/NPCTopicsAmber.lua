local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
--evt.MoveNPC(452,525)

-- Eleric Graywood
QuestNPC 	= 450

Greeting{
	"Greetings! So, the spark in your eyes tell me you came to our island to seek adventure? You better visit the mayor of Amber Town. The word is he seeks adventurers who are willing to risk it all... for a high reward of course",
}


NPCTopic{
	Slot 	= A,
	Topic 	= "The Island",
	Text 	= "Amber Island is the home to many merchants from all over the world. The gold flows through the veins of the island back and forth, attracting all sorts of fortune seekers... like yourselves I assume, eh? Unfortunately for us, it also attracts all kinds of troublemakers. Now, that wouldn't be a problem as we all can afford tossing a coin for army of guards, but that function is taken by the Archmage Magnus, who occupied that duty without our consent. I hope mayor will figure something out, before our pockets are emptied..."
}


NPCTopic{
	Slot 	= B,
	Topic 	= "Amber?",
	Text 	= "Why is it called? Before this island turned into commercial hub, it was a rich source of amber for many decades. The name stuck. Although today, you'd be lucky to find a piece of amber here - miners squeezed last bits few years ago. "
}
------------------------------------------------------------------------------
-- William Nightkeep
QuestNPC 	= 451

Greeting{
	"Adventurers! I don't know why you got here, but it seems you're stuck with us now.",
}


NPCTopic{
	Slot 	= A,
	Topic 	= "Difficult Times",
	Text 	= "Even though Powder Keg Inn is just few steps away from the house, it's really difficult to find a way home once you over stayed your time there. The mist can get so thick I can barely see my hands. Damn this Archmage!"
}
------------------------------------------------------------------------------
-- Aria Nightkeep
QuestNPC 	= 452

NPCTopic{
	Slot 	= A,
	Topic 	= "Husband",
	Text 	= "William works as a mercenary, mostly guarding trade ships. Nowadays, trade route is slowed due to Archmage's shenanigans. As a result, he gets hired less frequently. Husband stays most days at the Inn until he is three sheets to the wind. I wish he could get a temporary job or at least help at the house."
}
------------------------------------------------------------------------------
-- James Gladwyn
QuestNPC 	= 482

Greeting{
	"James Gladwyn at your service!\n\nOh, you're those \"new people\" everyone keeps talking about, right? Good. New people means more trade and more trade means more gold!",
}

NPCTopic{
	Slot 	= A,
	Topic 	= "Wealth",
	Text 	= "You probably heard it already: the island bleeds gold. It's true! Once a number one amber supplier, now a most succesful trade hubs in the world. Although, if you ask me, the real secret lies on low taxation. It's almost non-existent."
}
------------------------------------------------------------------------------
-- Mark Bolton
QuestNPC = 483

NPCTopic{
	Slot 	= A,
	Topic 	= "Goblins",
	Text 	= "Even for powerful sorcerer, such as Magnus the Archmage, it's not enough to operate alone. He brought few ships full of goblin mercenaries to support his cause. Most of them left to the castle, but some roam around and try to cause trouble. Be very careful when going outside the settlement."
}
------------------------------------------------------------------------------
-- Sheila Bolton
QuestNPC 	= 484

NPCTopic{
	Slot 	= A,
	Topic 	= "The Payne Family",
	Text 	= "Ashley is one my two sisters. She dwells in a small hut south-east from the amber island, in the swampy area. If you wish to become expert at alchemy, she's the one you need to find."
}

NPCTopic{
	Slot 	= B,
	Topic 	= "Make: Black Potion (Intelligence)",
	Text 	= "I'm not much of alchemist, but i know how to brew \"specialty of the house\" - Potion of Pure Intelligence. If you bring me proper ingridients, i can brew one for you!"
}
------------------------------------------------------------------------------
-- Julia Greene
QuestNPC 	= 485

Greeting{
	"Come in, come in! You're just an adventurers I've been looking for!\n\nPerhaps, you can do a little favour for an old lady, eh?",
}

NPCTopic{
	Slot 	= A,
	Topic 	= "Robert",
	Text 	= "My son was sent to that horrid swamp camp. The lord sends men to check for them once in a blue moon. Now, when whole town gone crazy they must've forgotten about him. Poor Robi!"
}

NPCTopic{
	Slot 	= B,
	Topic 	= "Quest: Mother's Anxiety",
	Text 	= "Robert must sitting in that damn camp all alone, cold, wet and hungry without anyone to take care of him! Would you be a lam and bring this crate for him? Not for free of course, i'll pay you in advance!"
}
------------------------------------------------------------------------------
-- James Halloran (bridge house)
QuestNPC 	= 486

NPCTopic{
	Slot 	= A,
	Topic 	= "Crime",
	Text 	= "Guarding this town was the most boring job in the world. Nothing happened at all... It was all piece and quiet around here, but things got real interesting right after archmage's arrival."
}

NPCTopic{
	Slot 	= B,
	Topic 	= "Quest: Investigation",
	Text 	= "--"
}
------------------------------------------------------------------------------
-- Thomas Beck
QuestNPC 	= 487

NPCTopic{
	Slot 	= A,
	Topic 	= "Ex-Miner",
	Text 	= "I used to mine amber before it was cool."
}

NPCTopic{
	Slot 	= B,
	Topic 	= "Abandoned Mines",
	Text 	= "Monster lives there, don't visit!"
}

-- Hidden quest
NPCTopic{
	Slot 	= C,
	Topic 	= "Quest: Family Sword",
	Text 	= "Holyshit, you found my family sword! Here's a million dollars for you!"
}