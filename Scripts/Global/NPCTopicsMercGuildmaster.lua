--[[
Mercenary Guildmaster Topic Template,
Author: Henrik Chukhran, 2022 - 2024
]]

-- @note Declare QuestNPC before usage 
local A, B, C, D, E, F = 0, 1, 2, 3, 4, 5
local Q = vars.Quests

local function SetBranch(t)
	QuestBranch(t.NewBranch)
end

local function Merc_NPCTopicGuildmasterDeclare()

	GuildMasterNotEnoughGoldStr = "It seems your pockets aren't deep enough for my services. Come back when you've got the coin. Quality defense doesn't come cheap, after all."

	NPCTopic{
		Slot        	=   D,
		Branch      	=   "",
		NewBranch   	=   "MercsBrowse0",
		Ungive      	=   function(t)
								if #vars.MercNPCAvailableList > 0 then
									SetBranch(t) 
								else
									Message("It appears we are currently short on mercenaries. Come back later.")
								end
							end,
		Texts 			= 
		{		
			Topic 		= 	"Browse: Mercenaries",
			Ungive 		= 	"Of course. We've got a range of skilled fighters, each with their own specialties. Take your pick, but remember - quality comes at a price",
		},
	}

	Quest{
		Slot 			= 	E,
		Branch			=	"",
		Texts 			= 	{
			Topic 		= 	"Find and Return Mercenaries (100g)",
			Done		=	"If any of your mercenaries are missing, just let me know. I'll ensure they're found and returned to your side promptly, no matter their specialty.",
			Undone		=	GuildMasterNotEnoughGoldStr
		},
		NeverDone       =   true,
		NeverGiven      =   true,
		QuestGold		=	100,
		CanShow			=	function(t) 
								return #vars.MercNPCHiredList > 0
							end,
		Done			= 	function(t) 
								
								table.clear(vars.MercNPCLostList)
								for _, npc in ipairs(vars.MercNPCHiredList) do
									if not evt.Cmp("NPCs", npc) then
										evt.Add("NPCs", npc)
										table.insert(vars.MercNPCLostList, npc)
									end
								end

								for _, mon in Map.Monsters do
									if mon.NPC_ID > 0 and mon.Group == 35 then
										if ContainsNumber(vars.MercNPCLostList, mon.NPC_ID) then
											TableRemoveByValue(vars.MercNPCLostList, mon.NPC_ID)
											RemoveMonster(mon)
										end
									end
								end
							end,
	}

	-- BRANCH: MERCSBROWSE
	local NPCMercBaseTopic = {
		Slot 			= 	A,
		GetTopic 	    = 	function(t) return "<unknown>" end,
	}
	local function MercBrowseTopic(t)
		table.copy(NPCMercBaseTopic, t)
		return Quest(t)
	end

	local Page 	= 0
	for _, Merc in ipairs(MercsDB) do
		
		local Index 		= 	Page + 1
		local CTopic 		= 	"MercsBrowse"..tostring(Page)
		local NTopic 		= 	"MercsBrowse"..tostring(Page+1)
		local PTopic 		= 	"MercsBrowse"..tostring(Page-1)
		
		-- gotta check everywhere for save/load compactibility
		local IsAvailable	=	function(t)
									return ContainsNumber(vars.MercNPCAvailableList, Merc.NPC_ID)
								end,

		MercBrowseTopic{
			Slot 			= 	A,
			Branch			=	CTopic,
			GetTopic 	    = 	function(t) 
									return "About: "..Merc.Name 
								end,
			CanShow			=	IsAvailable,
			Ungive			= 	function(t)
									local MercText = Merc.Credentials.TextAbout
									Message(MercText)
								end
		}

		MercBrowseTopic{
			Slot 			= 	B,
			Branch			=	CTopic,
			GetTopic 	    = 	function(t) 
									local MercName 	= Merc.Name
									local MercPrice = Merc.Credentials.PriceHire
									t.QuestGold = MercPrice
									return "Hire: "..MercName.."("..MercPrice.."g)"
								end,
			Texts 			= 	{
				Undone		=	GuildMasterNotEnoughGoldStr,
			},
			NeverGiven		=	true,
			NeverDone		=	true,
			CanShow			=	function(t) 
									local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
									return IsAvailable() and Merc_IsHired(Merc) == false and MercSaveData.HiredOnce == false
								end,
			Done			=	function(t)
									Merc_Hire(Merc)
									evt.Add("NPCs", Merc.NPC_ID)

									local MercText = Merc.Credentials.TextHired
									Message(MercText)
									evt.PlaySound(14060)
								end
		}

		MercBrowseTopic{
			Slot 			= 	B,
			Branch			=	CTopic,
			GetTopic 	    = 	function(t) 
									local MercName 	= Merc.Name
									local MercPrice = Merc.Credentials.PriceReHire
									t.QuestGold = MercPrice
									return "Rehire: "..MercName.."("..MercPrice.."g)" 
								end,
			Texts 			= 	{
				Undone		=	GuildMasterNotEnoughGoldStr,
			},
			NeverGiven		=	true,
			NeverDone		=	true,
			CanShow			=	function(t) 
									local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
									return IsAvailable() and Merc_IsHired(Merc) == false and MercSaveData.HiredOnce == true
								end,
			Done			=	function(t)
									Merc_Hire(Merc)
									evt.Add("NPCs", Merc.NPC_ID)

									local MercText = Merc.Credentials.TextHired
									Message(MercText)
									evt.PlaySound(14060)
								end
		}

		MercBrowseTopic{
			Slot 			= 	B,
			Branch			=	CTopic,
			GetTopic 	    = 	function(t)
									local MercName 	= Merc.Name
									local MercPrice = Merc.Credentials.PriceResurrect
									t.QuestGold = MercPrice
									return "Resurrect: "..MercName.."("..MercPrice.."g)" 
								end,
			Texts 			= 	{
				Done		=	"Lost the mercenary, have you? No matter. With a bit of magic and the right price, I can have him standing, ready for battle once again, right here, right now.",
				Undone		=	GuildMasterNotEnoughGoldStr
			},
			CanShow			=	function(t) 
									local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
									return IsAvailable() and evt.Cmp("NPCs", Merc.NPC_ID) and Merc_IsHired(Merc) and MercSaveData.Dead == true 
								end,
			NeverDone       =   true,
			NeverGiven      =   true,
			Done			= 	function(t)
									local MercSaveData = Merc_GetSaveDataByID(Merc.NPC_ID)
									MercSaveData.Dead = false 
								end,
		}

		MercBrowseTopic{
			Slot        	=   D,
			Branch      	=   "MercsBrowse0",
			NewBranch   	=   "",
			GetTopic		=	function(t) return "Back" end,
			Ungive      	=   SetBranch
		}

		MercBrowseTopic{
			Slot        	=   D,
			Branch      	=   CTopic,
			NewBranch   	=   PTopic,
			GetTopic		=	function(t) return "Previous" end,
			Ungive      	=   SetBranch,
			CanShow			=	(|| Index > 1)
		}

		MercBrowseTopic{
			Slot        	=   E,
			Branch      	=   CTopic,
			NewBranch   	=   NTopic,
			GetTopic		=	function(t) return "Next" end,
			Ungive      	=   SetBranch,
			CanShow			=	(|| Index < #vars.MercNPCAvailableList )
		}
		
		-- inc
		Page = Page + 1
	end
end

------------------------------------------------------------------------------
-- Derick McBane
-- Amber Island, SW Town
QuestNPC 			= 	505

Greeting{
	"Welcome to the Mercenary Guild, adventurers. You're in the right place if you seek skilled companions for your journey. How can I assist you today?",
}

NPCTopic{
	Slot 			= 	A,
	Branch			=	"",
	Topic 			= 	"Mercenaries",
	Text 			= 	"Mercenaries, like tools in your kit, can turn the tide of your quests. Each one is unique, with their own strengths and quirks. For a fee, you can enhance their abilities and summon them to your side a few times each day. Should they fall or wander off, come back to me. I'll sort it out."
}

Merc_NPCTopicGuildmasterDeclare()
