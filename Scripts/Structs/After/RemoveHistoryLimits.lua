local u1 = mem.u1
local mmver = offsets.MMVersion

-- MM7-only
if mmver ~= 7 then
    return
end

local HistoryLimit = 69
local OriginalHistoryPtr = 0xACD364
local OriginalHistoryCount = 29
local HistorySound = 0x4E21
local HistorySoundObject = 0x194

assert(HistoryLimit <= 127, "HistoryLimit must fit the native History book byte comparison")

local function TrimNull(s)
    local i = s:match("()%z+$")
    return i and s:sub(1, i - 1) or s
end

-- Extend Game.HistoryTxt and redirect the native loader/book/event references.
mem.ExtendGameStructure{'HistoryTxt', Size = 12,
    Refs = {
        0x411E58, -- History book list: first text pointer
        0x412F8C, -- History book draw: entry title pointer
        0x4130D7, -- History book draw: entry text pointer
        0x44AE23, -- evt.Set History1-29: non-empty text check
        0x44B7E8, -- evt.Add History1-29: non-empty text check
        0x456E09, -- HISTORY.txt loader base
    },
    EndRefs = {
        0x411EE3, -- History book list: end of HistoryTxt table
    },
    Custom = {function(count)
        mem.prot(true)
        u1[0x411E3D] = count - 1 -- History book top-level entry count
        mem.prot(false)
    end},
}
Game.HistoryTxt.SetHigh(HistoryLimit)

local function ParseHistoryTxt(s)
    local rows, row, field, quoted = {}, {}, {}, false
    local i, n = 1, #s
    while i <= n do
        local ch = s:sub(i, i)
        if quoted then
            if ch == '"' then
                if s:sub(i + 1, i + 1) == '"' then
                    field[#field + 1] = ch
                    i = i + 1
                else
                    quoted = false
                end
            else
                field[#field + 1] = ch
            end
        elseif ch == '"' and #field == 0 then
            quoted = true
        elseif ch == "\t" then
            row[#row + 1], field = table.concat(field), {}
        elseif ch == "\r" or ch == "\n" then
            row[#row + 1], field = table.concat(field), {}
            if ch == "\r" and s:sub(i + 1, i + 1) == "\n" then
                i = i + 1
            end
            if row[1] ~= nil and not (#row == 1 and row[1] == "") then
                rows[#rows + 1] = row
            end
            row = {}
        else
            field[#field + 1] = ch
        end
        i = i + 1
    end
    row[#row + 1] = table.concat(field)
    if row[1] ~= nil and not (#row == 1 and row[1] == "") then
        rows[#rows + 1] = row
    end
    return rows
end

local function LoadHistoryTxtString()
    local ok, s = pcall(Game.LoadTextFileFromLod, "HISTORY.txt")
    if not ok or not s then
        ok, s   = pcall(Game.LoadTextFileFromLod, "History.txt")
    end
    return ok and s or nil
end

local function SetHistoryTxtRow(index, cols, textCol)
    local item  = Game.HistoryTxt[index]
    if not item then
        return
    end

    item.Text   = cols[textCol] or ""
    item.Title  = cols[textCol + 2] or cols[textCol + 1] or ""
    item.Time   = tonumber(cols[textCol + 1]) or 0
end

-- The native loader still reads only the original 29 rows. Fill only the
-- extended rows from the same LOD-backed source after text files are loaded.
local function LoadExtraHistoryTxt()
    local s = LoadHistoryTxtString()
    if not s then
        return
    end

    local rows  = ParseHistoryTxt(s)
    local first = rows[1] or {}
    local c1    = (first[1] or ""):lower()
    local c2    = (first[2] or ""):lower()
    local c3    = (first[3] or ""):lower()
    local c4    = (first[4] or ""):lower()
    local start = (
        c1 == "#"
        or c1 == "text"
        or c2 == "text"
        or c2 == "title"
        or c2 == "time"
        or c3 == "title"
        or c4 == "page title"
    ) and 2 or 1

    for i = start, #rows do
        local cols      = rows[i]
        local rowIndex  = tonumber(cols[1])
        local index     = rowIndex or (i - start + 1)
        if index > OriginalHistoryCount and index <= HistoryLimit then
            SetHistoryTxtRow(index, cols, rowIndex and 2 or 1)
        end
    end
end

if GameInitialized2 then
    LoadExtraHistoryTxt()
else
    events.GameInitialized2 = LoadExtraHistoryTxt
end
events.TxtFilesReloaded = LoadExtraHistoryTxt

-- Relocate Party.History out of the fixed party block so it no longer collides
-- with Party.SpecialDates when entries above 29 are used.
local HistorySize = HistoryLimit*8
local HistoryPtr = mem.allocMM(HistorySize)
mem.copy(HistoryPtr, OriginalHistoryPtr, OriginalHistoryCount*8)
mem.fill(HistoryPtr + OriginalHistoryCount*8, HistorySize - OriginalHistoryCount*8)

local dp = HistoryPtr - OriginalHistoryPtr
mem.BatchAdd({
    0x411E4A, -- History book list: Party.History[i]
    0x4130CE, -- History book draw: Party.History[i], stored as base - 8
    0x44AE00, -- evt.Set History1-29 timestamp
    0x44B7C5, -- evt.Add History1-29 timestamp
}, dp)

structs.o.GameParty.History = HistoryPtr
internal.SetArrayUpval(Party.History, "o", HistoryPtr)
internal.SetArrayUpval(Party.History, "count", HistoryLimit)
rawset(Party.History, "SetHigh", function(newMax)
    assert(newMax <= HistoryLimit, "Party.History is capped by HistoryLimit")
end)

local ExtraHistorySaveKey = "ExtraHistoryDates"

local function RestoreHistoryDates(loaded)
    local p = Party.History["?ptr"]
    mem.copy(p, OriginalHistoryPtr, OriginalHistoryCount*8)
    local extraSize = (HistoryLimit - OriginalHistoryCount)*8
    if extraSize <= 0 then
        return
    end
    local s = loaded and internal.SaveGameData[ExtraHistorySaveKey] or ""
    local len = math.min(#s, extraSize)
    if len > 0 then
        mem.copy(p + OriginalHistoryCount*8, s, len)
    end
    if len < extraSize then
        mem.fill(p + OriginalHistoryCount*8 + len, extraSize - len)
    end
end

function events.InternalBeforeSaveGame()
    local p = Party.History["?ptr"]
    mem.copy(OriginalHistoryPtr, p, OriginalHistoryCount*8)
    local extraSize = (HistoryLimit - OriginalHistoryCount)*8
    if extraSize > 0 then
        local s = TrimNull(mem.string(p + OriginalHistoryCount*8, extraSize, true))
        internal.SaveGameData[ExtraHistorySaveKey] = s ~= "" and s or nil
    end
end

function events.InternalBeforeLoadMap(wasInGame, loaded)
    if not wasInGame then
        RestoreHistoryDates(loaded)
    end
end

local function HistoryIndex(t)
    local v = type(t) == "table" and (t.VarNum or t[1]) or t
    if type(v) ~= "string" then
        return
    end
    return tonumber(v:match("^History(%d+)$"))
end

local function CheckExtendedHistoryIndex(index)
    if index <= OriginalHistoryCount then
        return false
    end
    if index > HistoryLimit then
        debug.Message(("History%d is above the configured HistoryLimit (%d)"):format(index, HistoryLimit), 3)
    end
    return true
end

local function FlashHistory(index)
    local item = Game.HistoryTxt[index]
    if item and item.Text and item.Text ~= "" then
        Game.FlashHistoryBook = true
        Game.PlaySound(HistorySound, HistorySoundObject)
    end
end

local function SetExtendedHistory(index)
    if not CheckExtendedHistoryIndex(index) then
        return false
    end
    Party.History[index] = Game.Time
    FlashHistory(index)
    return true
end

local function AddExtendedHistory(index)
    if not CheckExtendedHistoryIndex(index) then
        return false
    end
    if Party.History[index] == 0 then
        SetExtendedHistory(index)
    end
    return true
end

local function WrapHistoryCommand(t, name, handler)
    local old = t and t[name]
    if not old then
        return
    end
    t[name] = function(a, ...)
        local index = HistoryIndex(a)
        if index and handler(index) then
            return
        end
        return old(a, ...)
    end
end

for i = 0, 3 do
    WrapHistoryCommand(evt[i], "Add", AddExtendedHistory)
    WrapHistoryCommand(evt[i], "Set", SetExtendedHistory)
end
WrapHistoryCommand(evt, "Add", AddExtendedHistory)
WrapHistoryCommand(evt, "Set", SetExtendedHistory)
WrapHistoryCommand(evt.All, "Add", AddExtendedHistory)
WrapHistoryCommand(evt.All, "Set", SetExtendedHistory)
WrapHistoryCommand(evt.Random, "Add", AddExtendedHistory)
WrapHistoryCommand(evt.Random, "Set", SetExtendedHistory)
WrapHistoryCommand(evt.Current, "Add", AddExtendedHistory)
WrapHistoryCommand(evt.Current, "Set", SetExtendedHistory)
