local fcount = FacetRefsLimit or 8192

-- new limits:
IndoorLimits = {
	Vertexes = fcount*5,  -- suport 4 vertices for each facet plus some extra
	Facets = fcount,
	FacetData = fcount,
	VisibleFacets = fcount,
	BSPNodes = fcount,
	Outlines = IndoorOutlineLimit or 7000,
}

-- code
local mmver = offsets.MMVersion

local function mmv(...)
	local ret = select(mmver - 5, ...)
	assert(ret ~= nil)
	return ret
end

local abs, floor, ceil, round, max, min = math.abs, math.floor, math.ceil, math.round, math.max, math.min
local i4, i2, i1, u4, u2, u1, i8, u8 = mem.i4, mem.i2, mem.i1, mem.u4, mem.u2, mem.u1, mem.i8, mem.u8
mem.IgnoreProtection(true)

-- alloc limits

i4[mmv(0x48A80F, 0x498BD9, 0x496029)+1] = IndoorLimits.Vertexes*structs.MapVertex["?size"]
i4[mmv(0x48A82A, 0x498BF5, 0x496045)+1] = IndoorLimits.Facets*structs.MapFacet["?size"]
i4[mmv(0x48A84B, 0x498C12, 0x496062)+1] = IndoorLimits.FacetData*structs.FacetData["?size"]
i4[mmv(0x48A8D5, 0x498C81, 0x4960D6)+1] = IndoorLimits.BSPNodes*structs.BSPNode["?size"]

-- minimap outlines
if mmver == 7 and IndoorVisibleOutlinesPtr then
	local OutlineAllocSize = 4 + IndoorLimits.Outlines*structs.MapOutline["?size"]
	local OutlineAllocSizePtr = 0x498C9F + 1
	assert(i4[OutlineAllocSizePtr] == 4 + 7000*structs.MapOutline["?size"])
	i4[OutlineAllocSizePtr] = OutlineAllocSize

	local StdVisiblePtr = 0x6BE56C
	local StdVisibleSize = 875
	local ExtraVisibleSize = IndoorVisibleOutlinesSize - StdVisibleSize
	local SaveKey = "MMExtExtraVisibleOutlines"

	-- Places where the minimap renderer marks a newly discovered outline.
	local VisiblePtrRefs = {0x441EB9 + 2, 0x442AD8 + 2}
	for _, p in ipairs(VisiblePtrRefs) do
		assert(i4[p] == StdVisiblePtr)
		i4[p] = IndoorVisibleOutlinesPtr
	end

	-- Native DLV saving remains format-compatible and stores the first 7000
	-- bits.  The remaining bits are persisted in MMExtension mapvars below.
	local SaveVisiblePtrRef = 0x45FB81 + 1
	assert(i4[SaveVisiblePtrRef] == StdVisiblePtr)
	i4[SaveVisiblePtrRef] = IndoorVisibleOutlinesPtr

	-- Native DLV loading normally targets the fixed 875-byte field embedded in
	-- GameMap, then indexes past it when the outline count is above 7000.
	-- Redirect both load paths and the per-outline visibility test.
	assert(mem.string(0x49A6A9, 6, true) == string.char(0x8D, 0x86, 0x24, 0x03, 0x00, 0x00))
	assert(mem.string(0x49A6CE, 6, true) == string.char(0x8D, 0x86, 0x24, 0x03, 0x00, 0x00))
	assert(mem.string(0x49A6FA, 7, true) == string.char(0x8A, 0x84, 0x30, 0x24, 0x03, 0x00, 0x00))
	mem.asmpatch(0x49A6A9, "mov eax, "..IndoorVisibleOutlinesPtr, 6)
	mem.asmpatch(0x49A6CE, "mov eax, "..IndoorVisibleOutlinesPtr, 6)
	mem.asmpatch(0x49A6FA, "mov al, byte [eax + "..IndoorVisibleOutlinesPtr.."]", 7)

	local function SaveExtraVisibleOutlines()
		if Map.IsIndoor() and mapvars then
			mapvars[SaveKey] = Map.Outlines.Count > 7000 and
				mem.string(IndoorVisibleOutlinesPtr + StdVisibleSize,
					ExtraVisibleSize, true) or nil
		end
	end

	function events.BeforeLoadMap()
		mem.fill(IndoorVisibleOutlinesPtr, IndoorVisibleOutlinesSize, 0)
	end

	function events.LeaveMap()
		SaveExtraVisibleOutlines()
	end

	function events.BeforeSaveGame()
		SaveExtraVisibleOutlines()
	end

	function events.AfterLoadMap()
		if not Map.IsIndoor() then
			return
		end

		local s = mapvars and mapvars[SaveKey]
		if type(s) == "string" then
			mem.copy(IndoorVisibleOutlinesPtr + StdVisibleSize, s,
				min(#s, ExtraVisibleSize))
		end

		-- Native loading applies the first 7000 bits to MapOutline.Visible.
		-- Apply the extended part as well so it is shown immediately after load.
		for i = 7000, Map.Outlines.Count - 1 do
			local mask = 2^(7 - i%8)
			Map.Outlines[i].Visible = u1[IndoorVisibleOutlinesPtr + i:div(8)]%(mask*2) >= mask
		end
	end
end

-- visible facets

local StdVisFacetsPtr = mmv(0x4DA9C8, 0x51B5F8, 0x52CEE0)
local Offset = mem.malloc(4 + 4*IndoorLimits.VisibleFacets + 3) + 3 - StdVisFacetsPtr
Offset = Offset - Offset % 4  -- make sure it's 4-bite aligned

local CountRefs = mmv({0x494EBD+1}, {0x4B136C+1, 0x4AFEBC+1}, {0x4AF74C+1, 0x4AE27A+1})
local OffsetRefs = mmv(
	{0x4346FF+1, 0x4958D3+1},
	{0x440B92+4, 0x440BBC+4, 0x440BE0+4, 0x440BEE+4, 0x4B08DA+4, 0x4B08F6+4, 0x4C0CC0+4, 0x4C1647+4},
	{0x43DAE2, 0x43DB0C, 0x43DB30, 0x43DB38, 0x4AECBE, 0x4AECDA, 0x4BE84D, 0x4BF1F1}
)

for _, p in ipairs(CountRefs) do
	assert(i4[p] == 1000)
	i4[p] = IndoorLimits.VisibleFacets
end
for _, p in ipairs(OffsetRefs) do
	assert(abs(i4[p] - StdVisFacetsPtr) <= 6)
	i4[p] = i4[p] + Offset
end

if mmver == 6 then
	local CodeChunk1 = string.char(0xFF, 0x06, 0x05)
	-- inc dword ptr [esi]
	-- add eax, Offset/4
	local CodeChunk2 = string.char(0x66, 0x89, 0x6C, 0x86, 0x04,  0x66, 0x89, 0x4C, 0x86, 0x06)
	-- mov [esi+eax*4+4], bp
	-- mov [esi+eax*4+6], cx
	local CodeChunk = CodeChunk1.."1234"..CodeChunk2
	local code = 0x494EC9
	mem.copy(code, CodeChunk, #CodeChunk)
	i4[code + #CodeChunk1] = Offset/4
else
	local CodeChunk1 = string.char(0xFF, 0x03, 0x81, 0xC3)
	-- mov eax, [ebx]
	-- inc dword ptr [ebx]
	-- add ebx, Offset
	local CodeChunk2 = string.char(0x89, 0x03)
	-- mov [ebx], eax
	local CodeChunk = CodeChunk1.."1234"..CodeChunk2

	local function DoHook(p)
		local code = mem.copycode(p - (#CodeChunk + 4), 0x4AF76C - 0x4AF757 + (#CodeChunk + 4))
		mem.copy(code, CodeChunk, #CodeChunk)
		i4[code + #CodeChunk1] = Offset
		u1[p] = 0xE9
		i4[p + 1] = code - p - 5
	end

	DoHook(mmv(nil, 0x4B1377, 0x4AF757)) -- FacetDrawList_AddFacetHW
	DoHook(mmv(nil, 0x4AFEC7, 0x4AE285)) -- FacetDrawList_AddFacetSW
end

-- fix sky facet ObjRef in SW
local p = mmv(0x493341, 0x4ADC81, 0x4AC035)

if u1[p] == 0x8B then
	mem.asmhook(p, [[
		lea eax, [ecx*8 + 6]
		mov [ ]]..mmv(0x9DDA78, 0xF8ABA8, 0xFFCFB0)..[[ ], eax
	]])
end

mem.IgnoreProtection(false)
