
if internal.MMVersion == 6 then

	offsets = {
		MMVersion = 6,
		CurrentEvtLines = 0x533EC0,
		CurrentEvtLinesCount = 0x54D010,
		CurrentEvtBuf = 0x551D14,
		EvtLinesBufCount = 3000,
		GlobalEventInfo = 0x55BC00,
		EvtTargetObj = 0x552F3C,
		AbortEvt = 0x552F4C,
		MainWindow = 0x61076C,
		Windowed = 0x9B10B4,
		GameStateFlags = 0x6107D8,
		MapName = 0x6107BC,
		CurrentPlayer = 0x4D50E8,
		PlayersCount = 4,
		MapStrBuf = 0x54D044,
		MapStrOffsets = 0x551F9C,
		PauseTime = 0x420DB0,
		ResumeTime = 0x420DF0,
		TimeStruct1 = 0x4D5180,
		TimeStruct2 = 0x4D51A8,
		FindFileInLod = 0x44CBC0,
		SaveFileToLod = 0x44D3F0,
		fread = 0x4AE63C,
		SaveGameLod = 0x610830,
		new = 0x4AEBA5,
		free = 0x4AE724,
		malloc = 0x4AE753,
		realloc = 0x4B33A8,
		exit = 0x4AF9CD,
		allocMM = 0x421390,
		freeMM = 0x420FA0,
		allocatorMM = 0x5FCB50,
		SummonMonster = 0x4A35F0,
	}

elseif internal.MMVersion == 7 then

	offsets = {
		MMVersion = 7,
		CurrentEvtLines = 0x5840B8,
		CurrentEvtLinesCount = 0x590EF8,
		CurrentEvtBuf = 0x590EFC,
		EvtLinesBufCount = 4400,
		GlobalEventInfo = 0x5C32A0,
		EvtTargetObj = 0x5B57A0,
		AbortEvt = 0x5B6444,
		MainWindow = 0x6BE174,
		Windowed = 0xE31AC0,
		GameStateFlags = 0x6BE1E4,
		MapName = 0x6BE1C4,
		CurrentPlayer = 0x507A6C,
		PlayersCount = 4,
		MapStrBuf = 0x5B0FA0,
		MapStrOffsets = 0x597DA0,
		PauseTime = 0x4262F2,
		ResumeTime = 0x42630C,
		TimeStruct1 = 0x50BA60,
		TimeStruct2 = 0x50BA38,
		FindFileInLod = 0x4615BD,
		SaveFileToLod = 0x461B85,
		fread = 0x4CB8A5,
		SaveGameLod = 0x6A06A0,
		new = 0x4CB06B,
		free = 0x4CAEFC,
		malloc = 0x4CADC2,
		realloc = 0x4CEDD8,
		exit = 0x4CCFAA,
		allocMM = 0x4266FE,
		freeMM = 0x42641D,
		allocatorMM = 0x7029A8,
		SummonMonster = 0x4BBEC4,
	}

else

	offsets = {
		MMVersion = 8,
		CurrentEvtLines = 0x596908,
		CurrentEvtLinesCount = 0x5A5368,
		CurrentEvtBuf = 0x5A536C,
		EvtLinesBufCount = 5000,
		GlobalEventInfo = 0x5DB750,
		EvtTargetObj = 0x5CC030,
		AbortEvt = 0x5CCCD4,
		MainWindow = 0x6F3934,
		Windowed = 0xF019D8,
		GameStateFlags = 0x6F39A4,
		MapName = 0x6F3984,
		CurrentPlayer = 0x519350,
		PlayersCount = 5,
		MapStrBuf = 0x5C7030,
		MapStrOffsets = 0x5AC210,
		PauseTime = 0x424754,
		ResumeTime = 0x42476E,
		TimeStruct1 = 0x51D338,
		TimeStruct2 = 0x51D310,
		FindFileInLod = 0x45EFFF,
		SaveFileToLod = 0x45F5A1,
		fread = 0x4DA641,
		SaveGameLod = 0x6CE5F8,
		new = 0x4D9E0B,
		free = 0x4DA09C,
		malloc = 0x4D9F62,
		realloc = 0x4E093C,
		exit = 0x4DBFB0,
		allocMM = 0x424B4D,
		freeMM = 0x424863,
		allocatorMM = 0x73F910,
		SummonMonster = 0x4BA076,
	}
end
offsets.EvtLinesBuf = offsets.CurrentEvtLines + 12
offsets.EvtLinesBufCount = offsets.EvtLinesBufCount - 1