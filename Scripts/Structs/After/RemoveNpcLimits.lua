local u1, u2, u4, i1, i2, i4 = mem.u1, mem.u2, mem.u4, mem.i1, mem.i2, mem.i4
local hook, autohook, autohook2, asmpatch = mem.hook, mem.autohook, mem.autohook2, mem.asmpatch
local max, min, floor, ceil, round, random = math.max, math.min, math.floor, math.ceil, math.round, math.random
local format = string.format

if offsets.MMVersion ~= 7 then return end

function arrayFieldOffsetName(arr, offset)
	local i = offset:div(arr.ItemSize)
	local off = offset % arr.ItemSize
	for k, v in pairs(structs.o[structs.name(arr[0])]) do
		if v == off then
			print(k)
			return
		end
	end
	print("not found")
end

local arrs = {"NPCDataTxt", "NPC", "NPCNames", "NPCProfTxt", "StreetNPC", "NPCNews", "NPCGreet", "NPCGroup", "NPCProfNames"}
local arrPtrs = {}
for i, v in ipairs(arrs) do
	arrPtrs[i] = Game[v]["?ptr"]
end
local npcDataPtr = Game.NPCDataTxt["?ptr"]
function npcArrayFieldOffsetName(offset)
	for i, v in ipairs(arrs) do
		local dataOffset = arrPtrs[i] - npcDataPtr
		local nextOffset = (i ~= #arrs and (arrPtrs[i + 1] - npcDataPtr) or 0)
		if offset >= dataOffset and offset <= nextOffset then
			print(v)
			arrayFieldOffsetName(Game[v], offset - dataOffset)
			return
		end
	end
	print("Couldn't find NPC array for given offset")
end

function replacePtrs(addrTable, newAddr, origin, cmdSize, check)
	for i, oldAddr in ipairs(addrTable) do
		local old = u4[oldAddr + cmdSize]
		local new = newAddr - (origin - old)
		check(old, new, cmdSize, i)
		u4[oldAddr + cmdSize] = new
	end
end

-- DataTables.ComputeRowCountInPChar(p, minCols, needCol)
-- minCols is minimum cell count - if less, function stops reading file and returns current count
-- if col #needCol is not empty, current count is updated to its index, otherwise nothing is done - meant to exclude empty entries at the end of some files

do
	--[[
		local format = string.format
		local arrs = {"NPCDataTxt", "NPC", "NPCProfTxt", "NPCProfNames", "NPCTopic", "NPCText", "NPCNews", "NPCGroup", "NPCGreet", "StreetNPC", "NPCNames"}
		local out = {}
		for k, name in pairs(arrs) do
			local s = Game[name]
			local low, high, size, itemSize, dataOffset = s["?ptr"], s["?ptr"] + s.Limit * s.ItemSize, s.Size, s.ItemSize, s["?ptr"] - 0x724050
			table.insert(out, {name = name, low = low, high = high, size = size, itemSize = itemSize, dataOffset = dataOffset})
		end
		table.sort(out, function(a, b) return a.low < b.low end)
		for _, data in ipairs(out) do
			print(format("%-15s %-17s %-17s %-17s %-17s %-17s",
				data.name .. ":",
				format("low = 0x%X", data.low),
				format("high = 0x%X", data.high),
				format("size = 0x%X", data.size),
				format("itemSize = 0x%X", data.itemSize), 
				format("dataOffset = 0x%X", data.dataOffset)
			))
		end
	]]

	--[[
		NPCTopic:       low = 0x7214E8    high = 0x722D90   size = 0x18A8     itemSize = 0x8    dataOffset = 0xFFFFFFFFFFFFD498
		NPCText:        low = 0x7214EC    high = 0x722D94   size = 0x18A8     itemSize = 0x8    dataOffset = 0xFFFFFFFFFFFFD49C
		NPCDataTxt:     low = 0x724050    high = 0x72D50C   size = 0x94BC     itemSize = 0x4C   dataOffset = 0x0 
		NPC:            low = 0x72D50C    high = 0x7369C8   size = 0x94BC     itemSize = 0x4C   dataOffset = 0x94BC
		NPCNames:       low = 0x7369C8    high = 0x737AA8   size = 0x10E0     itemSize = 0x8    dataOffset = 0x12978
		NPCProfTxt:     low = 0x737AA8    high = 0x737F44   size = 0x49C      itemSize = 0x14   dataOffset = 0x13A58
		StreetNPC:      low = 0x737F44    high = 0x739CF4   size = 0x0        itemSize = 0x4C   dataOffset = 0x13EF4
		NPCNews:        low = 0x739CF4    high = 0x739DC0   size = 0xCC       itemSize = 0x4    dataOffset = 0x15CA4
		NPCGreet:       low = 0x73B8D4    high = 0x73BF44   size = 0x670      itemSize = 0x8    dataOffset = 0x17884
		NPCGroup:       low = 0x73BFAA    high = 0x73C010   size = 0x66       itemSize = 0x2    dataOffset = 0x17F5A
		NPCProfNames:   low = 0x73C110    high = 0x73C1FC   size = 0xEC       itemSize = 0x4    dataOffset = 0x180C0
	]]

	--[[
		REMOVE LIMITS WORKFLOW:
		1) generate above text to facilitate finding references
		2) find all references which are findable by search
		3) patch each place where files are loaded, allocating space for data, asmpatching some addresses to use new data, and replace all references with function call
		4) test and fix all bugs you can find
	]]

	-- maybe unrelated addresses: 0x4764B4, 0x4BC81E, 0x4BC82C - reference 0x724048
	
	-- npc tables data range: 0x724004 - 0x73C027
	
	local gameNpcRefs = { -- [cmd offset] = {addresses...}
		[1] = {0x445B41, 0x445C9D, 0x416AEF, 0x420C20, 0x445A69, 0x445AD5, 0x445BA2, 0x445C15, 0x445D0E, 0x44A5A0, 0x45F1C3, 0x45F91E, 0x44BF16, 0x44613D, 0x463528, 0x491B23, 0x491FCA, 0x494156, 0x4BC484, 0x4BC589, 0x4763B3,
			0x47638B, -- directly references Baby Dragon's hired bit
		},
		[2] = {0x420C90, 0x446DC1, 0x4326A8, 0x446D68, 0x44A2E1, 0x44AD77, 0x44B73C, 0x44BFA8, 0x44713B, 0x446D6F, 0x49214F,
			0x491B3E, -- directly references Margaret the Docent's hired bit
			},
		[3] = {0x42E269},
		[4] = {0x430687},
		lowerBoundIncrease = 1, -- minimum address will be increased by this * ItemSize,
		size = {
			[1] = {0x45F1BE},
			[3] = {0x45F916},
		}
	}

	local npcDataRefs = {
		[1] = {0x45F1D0, 0x4613B2, 0x491B1E}, -- 0x4646DD (cleanup tables) handled below, 0x465EBE happens before tables are extended, no need to change it
		size = { -- npc data size and game.npc size is same (at least should be)
			[1] = {0x491B19}
		},
		limit = { -- same as above
			-- this is where variable holding amount is accessed
			-- [2] = {0x416AE4, 0x416B3D, 0x420C18, 0x420C6F, 0x42E25B, 0x42E2D0, 0x43067B, 0x4306F0, 0x445AC4, 0x445B1F, 0x445C06, 0x445C67, 0x445CFE, 0x445D53, 0x446132, 0x446187, 0x44A597, 0x44A5E3, 0x44BF0E, 0x44BF2E, 0x463520, 0x463539, 0x4763A7, 0x491FC2, 0x492017, 0x494142, 0x494161, 0x4BC478, 0x4BC4A7, 0x4BC581, 0x4BC5A8, 0x445A34},

			-- those are hardcoded values
			[0] = {0x73C014},
			[2] = {0x445A34, 0x445B6B},
			[3] = {0x476CFE},
			--[6] = {0x476E1B},
		}
	}

	-- TODO? Grayface removed npc prof limits? might be unnecessary
	local npcProfRefs = {
		[3] = {0x737AB7, 0x416B8C, 0x420CA8, 0x445523, 0x44536B, 0x445545, 0x4455AD, 0x44551A, 0x4455A4, 0x49597C, 0x4B1FE2, 0x4B228C, 0x4B2295, 0x4B22EA, 0x4B2364, 0x4B3DD9, 0x4B4101, 0x4BC67D},
	}

	local npcGroupRefs = {
		[1] = {0x45F229, 0x45F98A, 0x491B34},
		[4] = {0x4224F5, 0x446FD1, 0x46A572},
		size = {
			arr = u1,
			[1] = {0x491B2D,},
			[3] = {{arr = u4, 0x45F982}}
		},
		limit = {
			[3] = {0x476EEA}
		}
	}
	-- TODO: 0x491B2F has npc groups, which are copied into Game.NPCGroup (or vice versa) at 0x491B2D. Investigate this

	local npcNewsRefs = {
		[3] = {0x422509, 0x46A586},
		limit = {
			[3] = {0x476F83}
		}
	}

	local streetNpcRefs = {
		[1] = {0x445A84, 0x445BA2, 0x4613AB},
		count = {
			[1] = {0x46139E, 0x4613BC},
			[2] = {0x46117C, 0x4613C6},
		},
	}

	-- these really are random npc names, not those that npcs in npcdata.txt use
	local npcNamesRefs = {
		[2] = {0x4953BD},
		[3] = {0x49543D, 0x48E9DA},
		count = {
			[2] = {0x4953B5, 0x4953FD, 0x495427},
			[3] = {0x48E9CA}
		},
		limit = {
			[3] = {0x477133}
		}
	}

	local npcGreetRefs = {
		limit = {
			[3] = {0x476E42}
		}
		-- yes, only limit, because apparently mmextension patches the places where data is referenced
	}

	-- NPC TOPIC ref ends with 8 or 0, NPC TEXT with 4 or C

	-- command sizes below 3 seem to use hardcoded values, 3 and above uses variable topic/text index - important for de-hardcoding npcs
	local npcTopicRefs = {
		[1] = {0x445362, },
		[2] = {},
		[3] = {0x4212F7, 0x4457B9, 0x46ABDE, 0x4B2CFF, 0x4B2D80},
		[4] = {0x476A8F},
		End = {
			[4] = {0x476B13}
		}
	}

	local npcTextRefs = {
		[1] = {0x416B7F, 0x446EFA, 0x4B1E37, 0x4B24DC, 0x4B262D, 0x4B263B, 0x4B26E9, 0x4B298B, 0x4B29A8, 0x4B29BC, 0x4BBC20, 0x4BBC2A, 0x4BBC31, 0x4BD241, 0x4BD2C9, 0x4BD2D0},
		[2] = {0x431DF1, 0x4956B6, 0x4B1EB0, 0x4B4A56, 0x4B638E, 0x4B6800, 0x4B8CA8},
		[3] = {0x447BEE, 0x447C0D, 0x447C65, 0x4B2654, 0x4B29C3, 0x4B3E61, 0x4B3F57, 0x4B8BF5},
		[4] = {0x4769C4},
		End = {
			[4] = {0x476A48}
		}
	}

	local function processReferencesTable(arrName, newAddress, newCount, addressTable)
		local arr = Game[arrName]
		local origin = arr["?ptr"]
		local lowerBoundIncrease = (addressTable.lowerBoundIncrease or 0) * arr.ItemSize
		addressTable.lowerBoundIncrease = nil -- eliminate special case in loop below
		local oldMin, oldMax = origin - arr.ItemSize - lowerBoundIncrease, origin + arr.Size + arr.ItemSize
		local newMin, newMax = newAddress - arr.ItemSize - lowerBoundIncrease, newAddress + arr.ItemSize * (newCount + 1)
		local function check(old, new, cmdSize, i)
			assert(old >= oldMin and old <= oldMax, format("[%s] old address 0x%X [cmdSize %d; array index %d] is outside array bounds [0x%X, 0x%X] (new entry count: %d)", arrName, old, cmdSize, i, oldMin, oldMax, newCount))
			assert(new >= newMin and new <= newMax, format("[%s] new address 0x%X [cmdSize %d; array index %d] is outside array bounds [0x%X, 0x%X] (new entry count: %d)", arrName, new, cmdSize, i, newMin, newMax, newCount))
		end
		mem.prot(true)
		for cmdSize, addresses in pairs(addressTable) do
			if type(cmdSize) == "number" then
				-- normal refs
				replacePtrs(addresses, newAddress, origin, cmdSize, check)
			else
				-- special refs
				local what = cmdSize
				local memArr = addresses.arr or i4
				for cmdSize, addresses in pairs(addresses) do
					for i, data in ipairs(addresses) do
						-- support per-address mem array types
						local memArr, addr = memArr -- intentionally override local
						if type(data) == "table" then
							memArr = data.arr or memArr
							addr = data[1]
						else
							addr = data
						end
						if what == "limit" then
							memArr[addr + cmdSize] = memArr[addr + cmdSize] - arr.Limit + newCount
						elseif what == "count" then
							-- skip (I don't move count addresses atm)
						elseif what == "size" then
							memArr[addr + cmdSize] = arr.ItemSize * newCount
						elseif what == "End" then
							memArr[addr + cmdSize] = newAddress + arr.ItemSize * newCount
						end
					end
				end
			end
		end
		mem.ChangeGameArray(arrName, newAddress, newCount)
		mem.prot()
	end

	-- freeing tables
	-- game uses offsets from this value, so I subtract lowest among them
	asmpatch(0x4646DD, "mov ecx, 0x73C028 - 0x17FD8")

	-- also important to finish checking references in range 0x11000-0x20000

	-- 0x73C028 - text data ptrs, in order: npcdata, npc names, npcprof, npcnews, npctopic, npctext, (empty), npcgreeting, npcgroup

	autohook(0x476CD5, function(d)
		-- just loaded npcdata.txt, eax = data pointer, esi = space for processed data
		local count = DataTables.ComputeRowCountInPChar(d.eax, 6, 6) - 2 + 1 -- +1, because there is empty npc at the beginning
		local newNpcDataAddress = mem.StaticAlloc(count * Game.NPCDataTxt.ItemSize)
		d.esi = newNpcDataAddress
		processReferencesTable("NPCDataTxt", newNpcDataAddress, count, npcDataRefs)
		asmpatch(0x476CDA, "mov [0x73C028], eax")
		-- 0x739DC4 contains pointers to npcdata.txt npc names (Game.NPCNames is for random names)
		asmpatch(0x476CEF, "mov eax, 0x739DC4")
		asmpatch(0x476E1B, "mov dword ptr [0x73C014]," .. count)

		-- here we have to use original ptr, because removeMapstatsLimit script apparently uses original address to calculate new data position
		HookManager{origNpcdataPtr = 0x724050}.asmpatch(0x4774E9, [[
			shl eax, 6
			lea esi, [eax + %origNpcdataPtr%]
		]])

		local newGameNpcAddress = mem.StaticAlloc(count * Game.NPC.ItemSize)
		processReferencesTable("NPC", newGameNpcAddress, count, gameNpcRefs)

		-- function resetting npc names
		local hooks = HookManager{npcLimitPtr = 0x73C014, newNpcDataAddress = newNpcDataAddress, newGameNpcAddress = newGameNpcAddress, firstRealGameNpcAddress = newGameNpcAddress + Game.NPC.ItemSize, npcdataNpcNamePtrs = 0x739DC4}
		hooks.asmpatch(0x476C68, "cmp dword ptr [%npcLimitPtr%],esi")
		hooks.asmpatch(0x476C88, "cmp esi,dword ptr [%npcLimitPtr%]")
		hooks.asmpatch(0x476C70, "mov edx,%firstRealGameNpcAddress%")
		hooks.asmpatch(0x476C76, "mov eax, %npcdataNpcNamePtrs%")
	end)

	autohook2(0x476E25, function(d)
		-- just loaded npcgreet.txt
		local count = DataTables.ComputeRowCountInPChar(d.eax, 1, 2) - 1
		local newGreetingDataAddress = mem.StaticAlloc((count + 1) * Game.NPCGreet.ItemSize) -- +1, because there is empty entry at the beginning
		d.esi = newGreetingDataAddress + 8 -- size of two editpchars (game gets address of entry it should write to)
		processReferencesTable("NPCGreet", newGreetingDataAddress, count + 1, npcGreetRefs) -- but mmextension gets real address
		asmpatch(0x476E2C, "mov [0x73C044], eax") -- correct data pointer
		asmpatch(0x476E38, "mov eax, esi")
	end)

	autohook2(0x476ECD, function(d)
		-- just loaded npcgroup.txt
		local count = DataTables.ComputeRowCountInPChar(d.eax, 1, 2) - 1
		local newNpcGroupAddress = mem.StaticAlloc(count * Game.NPCGroup.ItemSize)
		d.esi = newNpcGroupAddress
		processReferencesTable("NPCGroup", newNpcGroupAddress, count, npcGroupRefs)
		asmpatch(0x476ED4, "mov [0x73C048],eax") -- correct data pointer
		asmpatch(0x476EE0, "mov eax, esi")
	end)

	autohook2(0x476F66, function(d)
		-- just loaded npcnews.txt
		local count = DataTables.ComputeRowCountInPChar(d.eax, 1, 2) - 1
		local newNpcNewsAddress = mem.StaticAlloc(count * Game.NPCNews.ItemSize)
		d.esi = newNpcNewsAddress
		processReferencesTable("NPCNews", newNpcNewsAddress, count, npcNewsRefs)
		asmpatch(0x476F6D, "mov [0x73C034],eax") -- correct data pointer
		mem.nop(0x476F79)
	end)

	autohook(0x477088, function(d)
		-- just loaded npcnames.txt
		-- male/female count can be different, and need to fit all
		local count = max(DataTables.ComputeRowCountInPChar(d.eax, 1, 1), DataTables.ComputeRowCountInPChar(d.eax, 1, 2)) - 1
		local newSize = count * Game.NPCNames.ItemSize
		local newNpcNamesAddress = mem.StaticAlloc(newSize)
		mem.nop(0x47706A) -- don't calculate destination space before file has been loaded
		mem.nop(0x477081) -- don't zero invalid field (because it's not calculated, see above)
		asmpatch(0x47707B, "mov [0x73C010],ebx") -- zeroes Game.StreetNPC size

		-- generate random name
		HookManager{npcNames = newNpcNamesAddress}.asmpatch(0x47737A, [[
			lea eax,dword ptr [esi+edx*2] ; esi = sex, edx = name offset (male/female names are interleaved)
			mov eax,dword ptr [eax*4 + %npcNames%]
		]], 0xA)

		processReferencesTable("NPCNames", newNpcNamesAddress, count, npcNamesRefs)
		asmpatch(0x477097, "mov eax, " .. newNpcNamesAddress)
		-- male/female name counts
		local female, male = 0x73C020, 0x73C024
		asmpatch(0x47710C, "mov eax, " .. male)
		asmpatch(0x477158, format("mov [%d],eax", female))
		asmpatch(0x47736D, format("idiv dword ptr [esi*4+%d]", female))
		asmpatch(0x4CA7B3, [[
			; don't overwrite npc name count due to my script splitting npc tables space into multiple ones
			push dword [0x73C020]
			push dword [0x73C024]
			rep movsd
			pop ecx
			mov [0x73C024], ecx
			pop ecx
			mov [0x73C020], ecx
			jmp dword ptr [edx*4+0x4CA8C8]
		]])
	end)

	local npcTextTopicPtrs = mem.StaticAlloc(8)
	local npcTextPtr, npcTopicPtr = npcTextTopicPtrs, npcTextTopicPtrs + 4

	local topicTextHooks = HookManager{
		npcTextPtr = npcTextPtr, npcTopicPtr = npcTopicPtr, loadFileFromLod = 0x410897, eventsLod = Game.EventsLod["?ptr"],
		npcTextFileName = 0x4EB710, npcTopicFileName = 0x4EB700
	}

	local NOP = string.char(0x90)
	
	local addr = topicTextHooks.asmpatch(0x47699B, [[
		push ebx ; is 0
		push %npcTopicFileName%
		mov ecx, %eventsLod%
		call absolute %loadFileFromLod%
		mov [%npcTopicPtr%], eax
		push ebx
		push %npcTextFileName%
		mov ecx, %eventsLod%
		call absolute %loadFileFromLod%
		mov [%npcTextPtr%], eax
		nop
		nop
		nop
		nop
		nop
	]], 0x16)

	hook(mem.findcode(addr, NOP), function(d) -- load npctext
		local newTextCount = DataTables.ComputeRowCountInPChar(d.eax, 1, 2) - 1
		local newTopicCount = DataTables.ComputeRowCountInPChar(u4[npcTopicPtr], 1, 2) - 1

		local count = max(newTopicCount, newTextCount, 789) -- mmextension uses hardcoded topic ids up to this number for quests
		local newSpacePtr = mem.StaticAlloc(count * 8)

		-- NPC TEXT

		processReferencesTable("NPCText", newSpacePtr + 4, newTextCount, npcTextRefs)
		internal.SetArrayUpval(Game.NPCText, "count", max(newTextCount, 789)) -- override actual number with minimum number

		asmpatch(0x4769B6, "mov [0x73C03C],eax") -- correct file text ptrs

		-- NPC TOPIC

		asmpatch(0x476A56, "mov eax, [0x73C038]") -- correct file text ptrs
		topicTextHooks.ref.npcTopicData = u4[npcTopicPtr]
		topicTextHooks.asmpatch(0x476A6B, [[
			mov eax, %npcTopicData%
			jmp absolute 0x476A81
		]])
		asmpatch(0x476A83, "mov [0x73C038],eax")

		processReferencesTable("NPCTopic", newSpacePtr, newTopicCount, npcTopicRefs)
		internal.SetArrayUpval(Game.NPCTopic, "count", max(newTopicCount, 789))

		-- TODO: stuff to do conditional limits removal only if needed

	end)

	--[[ custom NPCs:
		520, mia lucille house
		795, mia lucille house
		947, grant valandir house
		1011, map npc
		1018, grant valandir house

		custom greetings:
		208, 216

		new npc groups:
		51, 53, 55, 60

		new npc news:
		52, 54, 56

		new npc topics (no ingame test, because evt limits not removed):
		584, 591, 595, 602, 609

		new npc text (no ingame test)
		780, 799, 807
	]]
	--function showTopics() for i, v in Game.NPC[GetCurrentNPC()].Events do if v ~= 0 then print(v, Game.NPCTopic[v]) end end end
	--function findGreetIndexes(text) for k, v in Game.NPCGreet do for i, t in v do if t:match(text) then print(k, i); break end end end end
end