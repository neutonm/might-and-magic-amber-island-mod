local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
QuestNPC = 447

Greeting{
	"Greetings adventurers! I wasn't sure you would show up, but here you are.",
	"Ah, adventuters, you're back! Any good news?",
}

KillMonstersQuest{
	Name = "CoreQuest",
	Slot = A,
	{Map = "testlevel.blv", MonsterIndex = 4},
	CheckDone = function()
		--return evt.Cmp("QBits",7)
		return vars.MyQuests.QVar1
	end,
	Exp = 25000,
	Gold = 25000
}
.SetTexts{	
	Topic 		= "Quest: The Fog",
	Give 		= "The people of Amber Island are the victims of extortion scheme performed by a local dweller, Magnus the Archmage. He constructed wonderous weather machine, capable of generating dense fog around the island, enough to make it harder for ships to navigate through the sea. Magnus turns it off whenever we need it... for of hefty sum of gold, of course. Each day the fog spreads further as well as the price for such \"service\". We wouldn't bother hiring adventurers such as yourself, but alas, Magnus managed to persuade a band of goblins under the command of swamp Troll to guard his machine. We can't afford to overtake the castle, but... we can afford you! Our militia will keep most of the invaders busy while you need to infliltrae the castle, find and eliminate archmage. Don't forget to disable that damn fog machine. Hurry up!",
	Done 		= "Adventuters, you actually did it! You've saved us all! Here, take this gold as a reward.",
	Undone 		= "You still here? The machine won't turn off by itself. Make sure to take care of Magnus, otherwise you know... he'll turn it on again. Carry on, then.",
	TopicDone 	= false,
	Quest 		= "The Fog\nMaximus Derpus, Amber Island\n\nFind and kill Magnus the Archmage and turn off his sinister fog machine.",
	Award 		= "Saved Amber Island from the terrors of Magnus the Archmage"
}

NPCTopic{
	Slot = B,
	"Magnus the Archmage",
	"Nobody knows for sure what made Magnus turn against his countrymen, but nevertheless, his impudent extortortion can't be tolerated anymore. We must use every opportunity to stop him.",
}

NPCTopic{
	Slot = C,
	"Invaders",
	"Archmage's henchmen, the ominous band of goblins occupied our castle. It blows my mind that they're relying on swamp troll as their leader. Trolls are cannibals. Do they realize that once humans are out of troll's diet... they will be next?",
}

NPCTopic{
	Slot = D,
	Topic = "The End",
	Text = "Good job!",
	CanShow = || vars.Quests.CoreQuest == "Done",
	Ungive = function()

		if not vars.MyQuests.QVarEndGame then
			vars.MyQuests.QVarEndGame = true   
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

-- "NPC"
QuestNPC = 449

NPCTopic{
	Slot = A,
	Topic = "Greetings!",
	Text = "Greetings and Salutations, adventurers. My name is Henrik Chukhran and i'm creator of this dungeon. You about to experience one hour of blasting gameplay. Exciting, isn't it?\n\nCareful, Archmage will pose quite a challenge."
}

NPCTopic{
	Slot = B,
	Topic = "Secrets!",
	Text = "There are about 3 secret places + 1 secret room here, can you find them all?"
}

NPCTopic{
	Slot = C,
	Topic = "Want more?",
	Text = "So, you wish to experience more content? New world, dungeons, monsters, towns and quests? It's all possible, but I can't do this stuff all by myself, so, I need your support, and the best way to do that is through patreon:\n\nwww.patreon.com/HenrikChukhran\n\nCheck out mod's Website: www.mightandmagicmod.com"
}

NPCTopic{
	Slot = D,
	Topic = "Special Thanks to...",
	Text = "Big thanks to Sergey Rozhenko aka GrayFace for making wonderful tools such as MMEditor and MMExtension as well patch for Might and Magic. Thanks to his tools it was possible to craft this dungeon.\n\nAlso, I'd like to thank my first patreon supporterers - BVB and Alkapivo. You rock, guys!"
}

