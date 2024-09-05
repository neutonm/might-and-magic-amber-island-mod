--~ Script to manage custom Arcomage games in Might and Magic VII.
--~ Put it into your "...\Scripts\General" folder.
--~ Leave any questions\answers at http://www.celestialheavens.com/forum/10/10423
--~  - Rod.

local NopPos = 0
local new1 = 0
local new2 = 0
local new3 = 0
local new4 = 0
local new5 = 0
local res = 0
local AiAMTable = {107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120}

local AMBuffer, AMTrigger, TowerToWin, ResourceToWin, TowerPl, WallPl, HammersPl, GemsPl, MonstersPl, ProductionPl, MagicPl, RecruitmentPl, TowerEn, WallEn, HammmersEn, GemsEn, MonstersEn, ProductionEn, MagicEn, RecruitmentEn, AInt

function ArcomageMatchEnd() end -- Triggered after end of match, started by StartArcomage(). Use it as function on event. Add commands before starting, clear them after.



----- Initialization area -----

mem.asmproc([[nop
nop
nop
nop]])

AMBuffer = mem.asmproc([[
retn
retn
retn
retn]])
AMTrigger = mem.asmproc([[retn]])
TowerToWin = mem.asmproc([[
retn
retn]])
ResourceToWin = mem.asmproc([[
retn
retn]])
TowerPl = mem.asmproc([[
retn
retn]])
WallPl = mem.asmproc([[
retn
retn]])
HammersPl = mem.asmproc([[
retn
retn]])
GemsPl = mem.asmproc([[
retn
retn]])
MonstersPl = mem.asmproc([[
retn
retn]])
ProductionPl = mem.asmproc([[
retn
retn]])
MagicPl = mem.asmproc([[
retn
retn]])
RecruitmentPl = mem.asmproc([[
retn
retn]])
TowerEn = mem.asmproc([[
retn
retn]])
WallEn = mem.asmproc([[
retn
retn]])
HammersEn = mem.asmproc([[
retn
retn]])
GemsEn = mem.asmproc([[
retn
retn]])
MonstersEn = mem.asmproc([[
retn
retn]])
ProductionEn = mem.asmproc([[
retn
retn]])
MagicEn = mem.asmproc([[
retn
retn]])
RecruitmentEn = mem.asmproc([[
retn
retn]])
AInt = mem.asmproc([[retn
retn
retn
retn]])

mem.asmproc([[nop
nop
nop
nop]])

mem.u1[AMTrigger] = 0

new1 = mem.asmproc([[
	cmp byte []] .. AMTrigger .. [[], 0x0
	jnz @nst
@std:
	cmp byte [0x505812], bl
	jmp 0x463356
@nst:
	cmp byte []] .. AMTrigger .. [[], 0x2
	je @equ
	cmp byte []] .. AMTrigger .. [[], 0x3
	jnz @std
	mov byte []] .. AMTrigger .. [[], 0x0
	call 0x444444
	jmp @std
@equ:
]])

mem.asmpatch(0x463350, "jmp " .. new1 .. " - 0x463350")
mem.hook(new1 + 45, function() ArcomageMatchEnd() end)
mem.asmpatch(new1 + 15, "jmp 0x463356 - " .. new1 + 15)

mem.asmproc([[mov byte []] .. AMTrigger .. [[], 0x4]])

NopPos = mem.asmproc([[call 0x4bf518]])
mem.asmpatch(NopPos, "call 0x4bf518 - " .. NopPos)

mem.asmproc([[
	mov byte []] .. AMTrigger .. [[], 0x1
	mov byte [0x505812], 0x1
]])

NopPos = mem.asmproc([[call 0x409c8c]])
mem.asmpatch(NopPos, "call 0x409c8c - " .. NopPos)

mem.asmproc([[
	mov word []] .. AMBuffer .. [[], ax
	mov ax, word []] .. TowerToWin .. [[]
	mov word [0x4e1884], ax
	mov ax, word []] .. ResourceToWin .. [[]
	mov word [0x4e1888], ax
	mov ax, word []] .. TowerPl .. [[]
	mov word [0x5055ac], ax
	mov ax, word []] .. WallPl .. [[]
	mov word [0x5055b0], ax
	mov ax, word []] .. ProductionPl .. [[]
	mov word [0x5055b4], ax
	mov ax, word []] .. MagicPl .. [[]
	mov word [0x5055b8], ax
	mov ax, word []] .. RecruitmentPl .. [[]
	mov word [0x5055bc], ax
	mov ax, word []] .. HammersPl .. [[]
	mov word [0x5055c0], ax
	mov ax, word []] .. GemsPl .. [[]
	mov word [0x5055c4], ax
	mov ax, word []] .. MonstersPl .. [[]
	mov word [0x5055c8], ax
	mov ax, word []] .. TowerEn .. [[]
	mov word [0x505668], ax
	mov ax, word []] .. WallEn .. [[]
	mov word [0x50566c], ax
	mov ax, word []] .. ProductionEn .. [[]
	mov word [0x505670], ax
	mov ax, word []] .. MagicEn .. [[]
	mov word [0x505674], ax
	mov ax, word []] .. RecruitmentEn .. [[]
	mov word [0x505678], ax
	mov ax, word []] .. HammersEn .. [[]
	mov word [0x50567c], ax
	mov ax, word []] .. GemsEn .. [[]
	mov word [0x505680], ax
	mov ax, word []] .. MonstersEn .. [[]
	mov word [0x505684], ax
	mov ax, word []] .. AMBuffer .. [[]
	mov ebp, 0x50ba60
	mov edi, 0xdf1a68
	mov ecx, 0x50bf48
]])

NopPos = mem.asmproc([[jmp 0x4637b3]])
mem.asmpatch(NopPos, "jmp 0x4637b3 - " .. NopPos)

new2 = mem.asmproc([[
	cmp byte []] .. AMTrigger .. [[], 0x1
	jnz @neq
	mov byte []] .. AMTrigger .. [[], 0x3
@neq:
	mov ecx, edi
]])

NopPos = mem.asmproc([[call 0x49fbc7]])
mem.asmpatch(NopPos, "call 0x49fbc7 - " .. NopPos)

NopPos = mem.asmproc([[jmp 0x4637bf]])
mem.asmpatch(NopPos, "jmp 0x4637bf - " .. NopPos)

mem.asmpatch(0x4637b8, "jmp " .. new2 .. " - 0x4637b8")


new3 = mem.asmproc([[
	cmp byte []] .. AMTrigger .. [[], 0x1
	je @equ
	mov eax, dword [0x507a40]
	mov eax, dword [ds:eax+0x1c]
	jnz @neq
@equ:
	mov eax, dword [ds:]] .. AInt .. [[]
@neq:
	mov dword [0x4e1874], 0x5
	sub eax, 0x6c
]])

NopPos = mem.asmproc([[jmp 0x409bfe]])
mem.asmpatch(NopPos, "jmp 0x409bfe - " .. NopPos)

mem.asmpatch(0x409be9, "jmp " .. new3 .. " - 0x409be9")

new4 = mem.asmproc([[
	cmp byte []] .. AMTrigger .. [[], 0x1
	je @equ
	mov ecx, dword [0x507a40]
	jmp @end
@equ:
	mov ecx, 0x506e24
@end:
]])

NopPos = mem.asmproc([[jmp 0x40d604]])
mem.asmpatch(NopPos, "jmp 0x40d604 - " .. NopPos)

mem.asmpatch(0x40d5fe, "jmp " .. new4 .. " - 0x40d5fe")

new5 = mem.asmproc([[
	cmp byte []] .. AMTrigger .. [[], 0x4
	jnz @neq
	mov esi, 0x1bb0180
@neq:
	mov eax, dword [esi+0x3a8]
]])

NopPos = mem.asmproc([[
	jmp 0x10006b4f
]])
mem.asmpatch(NopPos, "jmp 0x10006b4f - " .. NopPos)
mem.asmpatch(0x10006b49, "jmp " .. new5 .. " - 0x10006b49")


----- Functions area -----

function StartArcomage(TWin, RWin, TPl, WPl, HamPl, GemPl, MonPl, ProdPl, MagPl, RecPl, TEn, WEn, HamEn, GemEn, MonEn, ProdEn, MagEn, RecEn, Ai)

	PlTab = {TPl, WPl, HamPl, GemPl, MonPl, ProdPl, MagPl, RecPl}
	EnTab = {TEn, WEn, HamEn, GemEn, MonEn, ProdEn, MagEn, RecEn}

	for i = 1, 8 do
		if EnTab[i] == nil then
			EnTab[i] = PlTab[i]
		end
	end

	for i = 3, 5 do
		PlTab[i] = PlTab[i] - PlTab[i + 3]
	end

	for i = 6, 8 do
		EnTab[i] = EnTab[i] - 1
		PlTab[i] = PlTab[i] - 1
	end

	if Ai == nil or Ai > 11 then
		Ai = math.random(14)
	end


	mem.u4[AInt] = AiAMTable[Ai]

	mem.u2[TowerToWin] 		= TWin
	mem.u2[ResourceToWin] 	= RWin

	mem.u2[TowerPl] 		= PlTab[1]
	mem.u2[WallPl] 			= PlTab[2]
	mem.u2[ProductionPl]	= PlTab[6]
	mem.u2[MagicPl] 		= PlTab[7]
	mem.u2[RecruitmentPl] 	= PlTab[8]
	mem.u2[HammersPl] 		= PlTab[3]
	mem.u2[GemsPl] 			= PlTab[4]
	mem.u2[MonstersPl] 		= PlTab[5]

	mem.u2[TowerEn] 		= EnTab[1]
	mem.u2[WallEn] 			= EnTab[2]
	mem.u2[ProductionEn] 	= EnTab[6]
	mem.u2[MagicEn] 		= EnTab[7]
	mem.u2[RecruitmentEn]	= EnTab[8]
	mem.u2[HammersEn] 		= EnTab[3]
	mem.u2[GemsEn]	 		= EnTab[4]
	mem.u2[MonstersEn] 		= EnTab[5]

	mem.u1[AMTrigger] = 2


end

function GetLastAMresult()
	res = mem.u4[0x5057c4]
	if res > 2 then
		res = 3
	end
	return res
end
