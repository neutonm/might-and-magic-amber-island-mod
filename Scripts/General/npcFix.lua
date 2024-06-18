-- fix hired npcs being modulo 256 (byte used for intermediate storage)
-- replace all references with dword instead
-- also increment pointeers by 4 not by 1 etc.
local hooks = HookManager{buffer = 0x5C5C30}

-- hooks.asmpatch(0x445A49, "lea eax,dword [ebp-4]", 3)

hooks.asmpatch(0x416AD2, [[
	mov dword [edi+%buffer%],ecx
	add edi, 4
]], 7)

hooks.asmpatch(0x416B28, [[
	; [ebp - 4] = npc id
	mov eax,dword [ebp-4]
	add eax,2
	mov dword [edi+%buffer%],eax
	add edi, 4
]], 12)

for _, addr in ipairs{0x445AB2, 0x445BF0, 0x445CEC} do
	hooks.asmpatch(addr, [[
		mov dword [ecx+%buffer%],edx
		add ecx, 4
	]], 7)
end

hooks.asmpatch(0x445B27, [[
	mov eax,dword [esi*4+%buffer%]
	cmp eax,2
]], 11)

hooks.nop(0x416B54) -- fix hired npc count being higher than 2 because edi was used above as hired npc count as well

hooks.asmpatch(0x491FAF, "mov dword [edx*4+%buffer%],ecx", 6)

hooks.asmpatch(0x492006, [[
	mov eax, ebx
	add eax,2
	inc dword [ebp-8]
	mov dword [ecx*4+%buffer%],eax
]], 13)

hooks.asmpatch(0x492046, [[
	mov eax,dword [eax*4+%buffer%]
	cmp eax,2
]], 11)

hooks.asmpatch(0x4920AF, [[
	mov eax,dword [eax*4+%buffer%]
]], 7)

hooks.asmpatch(0x445C51, [[
	; [ebp - 8] = npc index, [ebp - 0xC] = address in buffer to put npc number (yes, they use text buffer for that)
	mov eax,dword [ebp-0x8]
	mov ecx,dword [ebp-0xC]
	add eax,2
	add dword [ebp-0xC], 4
	mov dword [ecx],eax
]], 13)

hooks.asmpatch(0x445C72, [[
	mov eax,dword [%buffer% + esi * 4] ; npc id
	cmp eax,2
]], 11)

hooks.asmpatch(0x445C81, "mov eax,dword [esi*4+%buffer%]", 7)
hooks.asmpatch(0x445C93, "mov eax,dword [esi*4+%buffer%]", 7)

hooks.asmpatch(0x445B0E, [[
	; ebx = buffer, [ebp - 8] = npc id
	mov eax,dword [ebp-8]
	add eax,2
	mov dword [ebx],eax
	add ebx, 4
]], 8)

hooks.asmpatch(0x4306CF, [[
	; [esp + 0x10] = npc id, [esp + 0x18] = buffer offset
	mov eax,dword [esp+0x10]
	mov ecx,dword [esp+0x18]
	add eax,2
	add dword [esp+0x18], 4
	mov dword [ecx+%buffer%],eax
]], 20)

hooks.asmpatch(0x445D47, [[
	; ebp - points to buffer, ebx = npc id
	mov eax, ebx
	add eax,2
	mov dword [ebp],eax
	add ebp, 4
]], 8)

hooks.asmpatch(0x445D5F, "cmp dword [edi*4+%buffer%],2", 7)