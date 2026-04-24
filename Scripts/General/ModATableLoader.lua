--[[
Description:    Generic table loader
Author:         Henrik Chukhran, 2022 - 2026

Overview:
    Shared table parser that uses column names instead of fixed indices.
    It handles defaults, basic type conversion, and skips bad or empty rows,
    making tables much safer to edit.
    
    The goal is to keep parsing logic in one place and avoid fragile,
    copy-pasted code across scripts.

Usage example:

    local FountainSchema    = {
        ID                  = { type = "string", required = true },
        Map                 = { type = "string" },
        X                   = { type = "number" },
        Y                   = { type = "number" },
        Z                   = { type = "number" },
        Type                = { type = "string" },
        ...
    }

    function Fountain_ParseTables(out)
        return TableLoader.ParseFile{
            Path        = "Data/Tables/Fountains.txt",
            Schema      = FountainSchema,
            Defaults    = SFountain,
            Out         = out,
            KeyField    = "ID",
        }
    end
--]]

TableLoader = TableLoader or {}

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local function TL_Trim(s)

    if s == nil then
        return ""
    end

    return tostring(s):match("^%s*(.-)%s*$")
end

local function TL_IsEmptyRow(words)

    for i = 1, #words do
        if TL_Trim(words[i]) ~= "" then
            return false
        end
    end

    return true
end

local function TL_BuildHeaderMap(words)

    local map = {}

    for i = 1, #words do
        local key = TL_Trim(words[i])
        if key ~= "" then
            map[key] = i
        end
    end

    return map
end

local function TL_ToString(v)

    v = TL_Trim(v)
    if v == "" then
        return nil
    end

    return v
end

local function TL_ProcessEscapes(str)

    if str == nil then
        return nil
    end

    str = tostring(str)
    str = str:gsub("\\n", "\n")
    str = str:gsub("\\012", "\012")

    return str
end

local function TL_ToNumber(v)

    v = TL_Trim(v)
    if v == "" then
        return nil
    end

    return tonumber(v)
end

local function TL_ToNumberOrString(v)

    v = TL_Trim(v)
    if v == "" then
        return nil
    end

    return tonumber(v) or v
end

local function TL_ToBool(v)

    v = TL_Trim(v):lower()

    if v == "" then
        return nil
    end

    if v == "1" or v == "true" or v == "yes" then
        return true
    elseif v == "0" or v == "false" or v == "no" then
        return false
    end

    return nil
end

local function TL_GetParser(spec)

    if type(spec) ~= "table" then
        return nil
    end

    if type(spec.parse) == "function" then
        return spec.parse
    end

    if spec.type == "string" then
        return TL_ToString
    elseif spec.type == "number" then
        return TL_ToNumber
    elseif spec.type == "number_or_string" then
        return TL_ToNumberOrString
    elseif spec.type == "bool" then
        return TL_ToBool
    elseif spec.type == "raw" then
        return function(v) return v end
    end

    return nil
end

local function TL_CopyDefaults(defaults)

    if defaults == nil then
        return {}
    end

    return table.copy(defaults)
end

local function TL_Debug(msg)

    if Game and Game.Debug then
        debug.Message(msg)
    end
end

local function TL_HasRequiredFields(record, schema)

    for field, spec in pairs(schema) do
        if type(spec) == "table" and spec.required then
            local v = record[field]
            if v == nil or (type(v) == "string" and TL_Trim(v) == "") then
                return false, field
            end
        end
    end

    return true, nil
end

------------------------------------------------------------------------------
-- GLOBAL
------------------------------------------------------------------------------

function TableLoader.ParseFile(opts)

    local path
    local schema
    local defaults
    local out
    local keyField
    local detectDuplicates
    local file
    local lines
    local headerLine
    local headerWords
    local header
    local rowIndex
    local seenKeys

    if type(opts) ~= "table" then
        return false, "ParseFile expects table opts"
    end

    path                = opts.Path
    schema              = opts.Schema or {}
    defaults            = opts.Defaults or {}
    out                 = opts.Out or {}
    keyField            = opts.KeyField
    detectDuplicates    = opts.DetectDuplicates ~= false
    seenKeys            = {}

    if path == nil or path == "" then
        return false, "Missing Path"
    end

    file = io.open(path)
    if not file then
        return false, "Cannot open file: " .. tostring(path)
    end

    lines = file:lines()
    headerLine = lines()

    if not headerLine then
        io.close(file)
        return false, "Empty file: " .. tostring(path)
    end

    headerWords = string.split(headerLine, "\9")
    header      = TL_BuildHeaderMap(headerWords)

    rowIndex = 1

    for line in lines do

        local words
        local record
        local isValid
        local missingField

        words = string.split(line, "\9")

        if TL_IsEmptyRow(words) then
            goto continue
        end

        record = TL_CopyDefaults(defaults)

        for field, spec in pairs(schema) do

            local colName
            local colIndex
            local rawValue
            local parser
            local parsedValue

            if type(spec) ~= "table" then
                spec = { type = spec }
            end

            colName     = spec.column or field
            colIndex    = header[colName]

            if colIndex ~= nil then
                rawValue = words[colIndex]
                parser = TL_GetParser(spec)

                if parser ~= nil then
                    parsedValue = parser(rawValue, words, header, record, field, spec)
                else
                    parsedValue = rawValue
                end

                if spec.escaped then
                    parsedValue = TL_ProcessEscapes(parsedValue)
                end

                if parsedValue ~= nil then
                    record[field] = parsedValue
                end
            end
        end

        isValid, missingField = TL_HasRequiredFields(record, schema)
        if not isValid then
            TL_Debug(string.format("TableLoader: skipped row %d in %s (missing required field: %s)", rowIndex, path, tostring(missingField)))
            goto continue
        end

        if keyField ~= nil and detectDuplicates then
            local key = record[keyField]
            if key ~= nil and key ~= "" then
                if seenKeys[key] then
                    TL_Debug(string.format("TableLoader: duplicate key '%s' in %s (row %d)", tostring(key), path, rowIndex))
                    goto continue
                end
                seenKeys[key] = true
            end
        end

        out[#out + 1] = record

        ::continue::
        rowIndex = rowIndex + 1
    end

    io.close(file)
    return true, out
end

function TableLoader.ParseCSV(valueType, separator)

    local sep = separator or ","

    local conv

    if valueType == "number" then
        conv = tonumber
    elseif valueType == "string" then
        conv = tostring
    else
        conv = function(v) return v end
    end

    return function(raw)

        local out = {}

        raw = tostring(raw or ""):match("^%s*(.-)%s*$")
        if raw == "" then
            return nil
        end

        for part in raw:gmatch("([^" .. sep .. "]+)") do
            local v = part:match("^%s*(.-)%s*$")

            if v ~= "" then
                local val = conv(v)
                if val ~= nil then
                    out[#out + 1] = val
                end
            end
        end

        return #out > 0 and out or nil
    end
end

function TableLoader.ParseCSVOrInherit(valueType, inheritMarker, separator)

    local csvParser = TableLoader.ParseCSV(valueType, separator)
    local marker    = inheritMarker or "$" -- @todo use Global variable instead of '$'

    return function(raw)
        raw = tostring(raw or ""):match("^%s*(.-)%s*$")

        if raw == "" then
            return nil
        end

        if raw == marker then
            return marker
        end

        return csvParser(raw)
    end
end

function TableLoader.ParseIndexedColumns(prefix, valueType, startIndex, endIndex)

    local conv

    if valueType == "number" then
        conv = tonumber
    else
        conv = tostring
    end

    startIndex = startIndex or 0
    endIndex   = endIndex or 3

    return function(raw, words, header, record)

        local out = {}

        for i = startIndex, endIndex do
            local idx = header[prefix .. "_" .. i]
            if idx ~= nil then
                local v = tostring(words[idx] or ""):match("^%s*(.-)%s*$")
                if v ~= "" then
                    out[i - startIndex + 1] = conv(v)
                end
            end
        end

        return next(out) and out or nil
    end
end

--[[
Example:

local NotesSchema = TableLoader.MakeSchemaFromFieldList({
    "ID",
    "Title",
    "Text",
}, "string")
]]
function TableLoader.MakeSchemaFromFieldList(fieldList, defaultType)

    local schema = {}
    local t = defaultType or "string"

    if type(fieldList) ~= "table" then
        return schema
    end

    for i = 1, #fieldList do
        schema[fieldList[i]] = { type = t }
    end

    return schema
end

--[[
Example:

local BaseLocSchema = TableLoader.MakeSchemaFromFieldList({
    "ID",
    "Map",
}, "string")

local ExtendedLocSchema = TableLoader.MergeSchema(BaseLocSchema, {
    X = { type = "number" },
    Y = { type = "number" },
    Z = { type = "number" },
})
]]
function TableLoader.MergeSchema(baseSchema, extraSchema)

    local out = table.copy(baseSchema or {})

    if type(extraSchema) == "table" then
        for k, v in pairs(extraSchema) do
            out[k] = v
        end
    end

    return out
end

TableLoader.CSVNumber           = TableLoader.ParseCSV("number")
TableLoader.CSVString           = TableLoader.ParseCSV("string")
TableLoader.CSVNumberOrInherit  = TableLoader.ParseCSVOrInherit("number", "$")
TableLoader.CSVStringOrInherit  = TableLoader.ParseCSVOrInherit("string", "$")
