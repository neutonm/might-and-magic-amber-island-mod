--[[
Description:    Fountains mechanic
Author:         Henrik Chukhran, 2022 - 2026

Overview:

    Defines a data-driven fountain/altar system with dynamic hints, usage tracking, and effect handling.
    Uses mapvars (uses/explored) and PlayerBits (temporary effects) for state.
    Supports custom behavior via OnCheckLua / OnUseLua without changing core logic.

    Notes:
    - Technically, any fountain/well/spring/basin or altar/shrine is treated as "Fountain"
    - Uses data table: Data/Tables/Fountains.txt
        - $ marker is used in <>W vars (Warrior) to inherit the value from normal vars
        - Added "ElemRes" and "ElemResBonus" as grouped bonus for all elemental resistances (fire/air/water/earth)
        - Added "SelfRes" and "ElemeResBonus" as grouped bonus for all self magic resistances (spirit/body/mind)
    - Uses mapvars for tracking:
        - FountainUses_<ID>     -> usage count
        - FountainExplored_<ID> -> discovery state
    - Autonotes are added on first successful use
    - RequiredCondition supports simple named checks. Check Fountain_ResolveCondition:
    - - Null        -> For empty fountains (Just drop "Refreshing!" wuthout autonote)
    - - Warrior     -> Will workin warrior difficulty only

Todo:
    - Find the way to localize UserStatusMsg

--]]

local INHERIT_MARKER    = "$"

------------------------------------------------------------------------------
-- GLOBALS
------------------------------------------------------------------------------

FountainsAndAltarsDB   = {}

-- Fountain/Well Structure
SFountain = {

    ID                  = "unnamed",
    Map                 = "amber.odt",
    X                   = 0,
    Y                   = 0,
    Z                   = 0,
    Type                = "Fountain",

    MaxUses             = 0,    -- 0 = unlimited
    MaxUsesW            = INHERIT_MARKER,

    Effect1             = "",
    Bonus1              = 0,
    Effect2             = "",
    Bonus2              = 0,
    Effect3             = "",
    Bonus3              = 0,
    Effect4             = "",
    Bonus4              = 0,

    Effect1W            = INHERIT_MARKER,
    Bonus1W             = INHERIT_MARKER,
    Effect2W            = INHERIT_MARKER,
    Bonus2W             = INHERIT_MARKER,
    Effect3W            = INHERIT_MARKER,
    Bonus3W             = INHERIT_MARKER,
    Effect4W            = INHERIT_MARKER,
    Bonus4W             = INHERIT_MARKER,

    UserStatusMsg       = "",
    UserStatusMsgW      = INHERIT_MARKER,
    Autonote            = "",

    RequiredCondition   = "",
    RequiredConditionW  = INHERIT_MARKER,
    OnCheckLua          = "",
    OnCheckLuaW         = INHERIT_MARKER,
    OnUseLua            = "",
    OnUseLuaW           = INHERIT_MARKER,
}

SFountainSchema         = {
    ID                  = { type = "string", required = true },
    Map                 = { type = "string" },
    X                   = { type = "number" },
    Y                   = { type = "number" },
    Z                   = { type = "number" },
    Type                = { type = "string" },

    MaxUses             = { type = "number_or_string" },
    MaxUsesW            = { type = "number_or_string" },

    Effect1             = { type = "string" },
    Bonus1              = { type = "number_or_string" },
    Effect2             = { type = "string" },
    Bonus2              = { type = "number_or_string" },
    Effect3             = { type = "string" },
    Bonus3              = { type = "number_or_string" },
    Effect4             = { type = "string" },
    Bonus4              = { type = "number_or_string" },

    Effect1W            = { type = "string" },
    Bonus1W             = { type = "number_or_string" },
    Effect2W            = { type = "string" },
    Bonus2W             = { type = "number_or_string" },
    Effect3W            = { type = "string" },
    Bonus3W             = { type = "number_or_string" },
    Effect4W            = { type = "string" },
    Bonus4W             = { type = "number_or_string" },

    UserStatusMsg       = { type = "string" },
    UserStatusMsgW      = { type = "string" },
    Autonote            = { type = "string" },

    RequiredCondition   = { type = "string" },
    RequiredConditionW  = { type = "string" },
    OnCheckLua          = { type = "string" },
    OnCheckLuaW         = { type = "string" },
    OnUseLua            = { type = "string" },
    OnUseLuaW           = { type = "string" },
}

-------------------------------------------------------------------------------

function Fountain_FindByID(id)

    if id == nil or id == "" then
        return nil
    end

    for i = 1, #FountainsAndAltarsDB do
        if FountainsAndAltarsDB[i] ~= nil and FountainsAndAltarsDB[i].ID == id then
            return FountainsAndAltarsDB[i]
        end
    end

    return nil
end

function Fountain_Register(t)

    local newt = nil

    if type(t) ~= "table" then
        return nil
    end

    if t.ID ~= nil and t.ID ~= "" and Fountain_FindByID(t.ID) ~= nil then
        return nil
    end

    newt = table.copy(SFountain)

    for k, v in pairs(t) do
        newt[k] = v
    end

    table.insert(FountainsAndAltarsDB, newt)
    return newt
end

function Fountain_ParseTables(Table)

    return TableLoader.ParseFile{
        Path            = "Data/Tables/FountainsAndAltars.txt",
        Schema          = SFountainSchema,
        Defaults        = SFountain,
        Out             = Table,
        KeyField        = "ID",
        DetectDuplicates= true,
    }
end

------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------

function events.GameInitialized2()
    Fountain_ParseTables(FountainsAndAltarsDB)
end

function events.AfterLoadMap(WasInGame)

    Fountain_RefillByMap(Game.Map.Name)
end

------------------------------------------------------------------------------
-- LOCALS
------------------------------------------------------------------------------

local FOUNTAIN_TEMPBIT_BASE     = 1
local FOUNTAIN_TEMPBIT_MAX      = 32

local FountainTxt               = LocalizeAll{

    FtTypeFountain              = "Fountain",
    FtTypeWell                  = "Well",
    FtTypeSpring                = "Spring",
    FtTypePool                  = "Pool",
    FtTypeBasin                 = "Basin",
    FtTypeShrine                = "Shrine",
    FtTypeAltar                 = "Altar",

    FtVerbDrink                 = "Drink from the %s",
    FtVerbUse                   = "Use the %s",
    FtVerbPray                  = "Pray at the %s",
    FtVerbTouch                 = "Touch the %s",

    FtRefreshing                = "Refreshing!",
    FtTemp                      = "(Temporary)",
    FtPermanent                 = "(Permanent)",

    FtRestoreHPSP               = "+%d HP & SP restored",
    FtRestoreHP                 = "+%d HP restored",
    FtRestoreSP                 = "+%d SP restored",

    FtRestoreShortHPSP          = "+%d HP/SP",
    FtHP                        = "+%d HP",
    FtSP                        = "+%d SP",

    FtNameHP                    = "HP",
    FtNameSP                    = "SP",
    FtNameAC                    = "AC",

    FtNameFireRes               = "Fire Resistance",
    FtNameAirRes                = "Air Resistance",
    FtNameWaterRes              = "Water Resistance",
    FtNameEarthRes              = "Earth Resistance",
    FtNameSpiritRes             = "Spirit Resistance",
    FtNameMindRes               = "Mind Resistance",
    FtNameBodyRes               = "Body Resistance",
    FtNameLightRes              = "Light Resistance",
    FtNameDarkRes               = "Dark Resistance",

    ElemRes                     = "Elemental Resistance",
    ElemResBonus                = "Elemental Resistance",
    SelfRes                     = "Self Resistance",
    SelfResBonus                = "Self Resistance",

    FtNameGold                  = "Gold",
    FtNameExp                   = "Experience",
    FtNameSkillPoints           = "Skill Points",
    FtNameLevel                 = "Level",
}

local EffectDisplayNames        = {
    HP                          = FountainTxt.FtNameHP,
    SP                          = FountainTxt.FtNameSP,
    ArmorClass                  = FountainTxt.FtNameAC,
    ArmorClassBonus             = FountainTxt.FtNameAC,

    FireResistance              = FountainTxt.FtNameFireRes,
    AirResistance               = FountainTxt.FtNameAirRes,
    WaterResistance             = FountainTxt.FtNameWaterRes,
    EarthResistance             = FountainTxt.FtNameEarthRes,
    SpiritResistance            = FountainTxt.FtNameSpiritRes,
    MindResistance              = FountainTxt.FtNameMindRes,
    BodyResistance              = FountainTxt.FtNameBodyRes,
    LightResistance             = FountainTxt.FtNameLightRes,
    DarkResistance              = FountainTxt.FtNameDarkRes,

    ElemRes                     = FountainTxt.ElemRes,
    ElemResBonus                = FountainTxt.ElemResBonus,
    SelfRes                     = FountainTxt.SelfRes,
    SelfResBonus                = FountainTxt.SelfResBonus,

    FireResBonus                = FountainTxt.FtNameFireRes,
    AirResBonus                 = FountainTxt.FtNameAirRes,
    WaterResBonus               = FountainTxt.FtNameWaterRes,
    EarthResBonus               = FountainTxt.FtNameEarthRes,
    SpiritResBonus              = FountainTxt.FtNameSpiritRes,
    MindResBonus                = FountainTxt.FtNameMindRes,
    BodyResBonus                = FountainTxt.FtNameBodyRes,
    LightResBonus               = FountainTxt.FtNameLightRes,
    DarkResBonus                = FountainTxt.FtNameDarkRes,

    Gold                        = FountainTxt.FtNameGold,
    Exp                         = FountainTxt.FtNameExp,
    Experience                  = FountainTxt.FtNameExp,
    SkillPoints                 = FountainTxt.FtNameSkillPoints,
    Level                       = FountainTxt.FtNameLevel,
}

local FountainTypeNames         = {
    Fountain                    = FountainTxt.FtTypeFountain,
    Well                        = FountainTxt.FtTypeWell,
    Spring                      = FountainTxt.FtTypeSpring,
    Pool                        = FountainTxt.FtTypePool,
    Basin                       = FountainTxt.FtTypeBasin,
    Shrine                      = FountainTxt.FtTypeShrine,
    Altar                       = FountainTxt.FtTypeAltar,
}

local FountainTypeVerbs = {
    Fountain                    = FountainTxt.FtVerbDrink,
    Well                        = FountainTxt.FtVerbDrink,
    Spring                      = FountainTxt.FtVerbDrink,
    Pool                        = FountainTxt.FtVerbDrink,
    Basin                       = FountainTxt.FtVerbDrink,
    Shrine                      = FountainTxt.FtVerbPray,
    Altar                       = FountainTxt.FtVerbUse,
}

-------------------------------------------------------------------------------

local function NormalizeType(t)
    if type(t) ~= "string" then
        return nil
    end
    return t:match("^%s*(.-)%s*$") -- trim spaces
end

local function ResolveWarriorValue(normalValue, warriorValue)

    if IsWarrior() then
        if warriorValue == INHERIT_MARKER then
            return normalValue
        end

        return warriorValue
    end

    return normalValue
end

local function Fountain_GetEffectDisplayName(effect)

    local statIndex
    local normalized

    if effect == nil or effect == "" then
        return ""
    end

    if EffectDisplayNames[effect] ~= nil then
        return EffectDisplayNames[effect]
    end

    normalized = effect:gsub("^Base", ""):gsub("Bonus$", "")

    if const.Stats and const.Stats[normalized] ~= nil and Game.StatsNames then
        statIndex = const.Stats[normalized]

        if statIndex >= 0 and statIndex < #Game.StatsNames then
            return Game.StatsNames[statIndex]
        end
    end

    return EffectDisplayNames[normalized] or normalized or effect
end

local function Fountain_GetIndex(fountain)

    local f = fountain

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return nil
    end

    for i = 1, #FountainsAndAltarsDB do
        if FountainsAndAltarsDB[i] == f then
            return i
        end
    end

    return nil
end

local function Fountain_GetUsesVarKey(fountain)

    local f = fountain

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil or f.ID == nil or f.ID == "" then
        return nil
    end

    return "FountainUses_" .. tostring(f.ID)
end

local function Fountain_IsPermanentEffect(effect)

    if type(effect) ~= "string" or effect == "" then
        return false
    end

    return effect:sub(1, 4) == "Base"
        or effect == "ElemRes"
        or effect == "SelfRes"
end

local function Fountain_HasPermanentEffect(fountain)

    local f = fountain

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return false
    end

    for i = 1, 4 do
        local effect = ResolveWarriorValue(f["Effect" .. i], f["Effect" .. i .. "W"])
        if Fountain_IsPermanentEffect(effect) then
            return true
        end
    end

    return false
end

local function Fountain_IsTemporaryEffect(effect)
    return type(effect) == "string" and effect:find("Bonus", 1, true) ~= nil
end

local function Fountain_HasTemporaryEffect(fountain)

    local f = fountain

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return false
    end

    for i = 1, 4 do
        local effect = ResolveWarriorValue(f["Effect" .. i], f["Effect" .. i .. "W"])
        if Fountain_IsTemporaryEffect(effect) then
            return true
        end
    end

    return false
end

local function Fountain_GetTempIndex(fountain)

    local f = fountain
    local idx
    local tempCounter = 0

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return nil
    end

    idx = Fountain_GetIndex(f)
    if idx == nil then
        return nil
    end

    for i = 1, idx do
        if Fountain_HasTemporaryEffect(FountainsAndAltarsDB[i]) then
            tempCounter = tempCounter + 1
        end
    end

    return tempCounter
end

local function Fountain_GetTempBitNameByIndex(index)

    local num

    if index == nil then
        return nil
    end

    num = FOUNTAIN_TEMPBIT_BASE + index - 1
    if num > FOUNTAIN_TEMPBIT_MAX then
        return nil
    end

    return num
end

local function Fountain_GetResolvedEffects(fountain)

    local f = fountain
    local out = {}

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return out
    end

    for i = 1, 4 do
        local effect = ResolveWarriorValue(f["Effect" .. i], f["Effect" .. i .. "W"])
        local bonus  = ResolveWarriorValue(f["Bonus" .. i],  f["Bonus" .. i .. "W"])

        if effect ~= nil and effect ~= "" and bonus ~= nil and bonus ~= 0 then
            table.insert(out, {
                Effect  = effect,
                Bonus   = bonus,
                Slot    = i,
                IsTemp  = Fountain_IsTemporaryEffect(effect),
            })
        end
    end

    return out
end

local function Fountain_RunLuaChunk(code, fountain, chunkName)

    local fn
    local ok
    local ret

    if code == nil or code == "" then
        return true
    end

    fn = loadstring(code, chunkName or "FountainLua")
    if fn == nil then
        return false
    end

    _G.FountainCurrent = fountain
    ok, ret = pcall(fn)
    _G.FountainCurrent = nil

    if not ok then
        return false
    end

    if ret == nil then
        return true
    end

    return ret
end

local function Fountain_ResolveCondition(cond)

    if cond == nil or cond == "" then
        return true
    end

    -- @todo - Extend later with reusable named conditions if needed
    if cond == "Null" then
        return false
    elseif cond == "Warrior" then
        return IsWarrior()
    end

    return false
end

local function Fountain_GetExploredVarKey(fountain)
    local f = type(fountain) == "string" and Fountain_FindByID(fountain) or fountain
    if f == nil or f.ID == nil or f.ID == "" then
        return nil
    end
    return "FountainExplored_" .. tostring(f.ID)
end

local function Fountain_SetExplored(fountain)
    local key = Fountain_GetExploredVarKey(fountain)
    if key ~= nil then
        mapvars[key] = true
    end
end

local function Fountain_GetMapTempBits(mapName)

    local bits = {}
    local seen = {}
    local curMap = mapName or Game.Map.Name

    for i = 1, #FountainsAndAltarsDB do
        local f = FountainsAndAltarsDB[i]
        local bit

        if f ~= nil and f.Map == curMap and Fountain_HasTemporaryEffect(f) then
            bit = Fountain_GetTempBitNameByIndex(Fountain_GetTempIndex(f))

            if bit ~= nil and not seen[bit] then
                seen[bit] = true
                table.insert(bits, bit)
            end
        end
    end

    return bits
end

------------------------------------------------------------------------------
-- FUNCTIONALITY
------------------------------------------------------------------------------

function Fountain_IsExplored(fountain)
    local key = Fountain_GetExploredVarKey(fountain)
    return key ~= nil and mapvars[key] == true
end

function Fountain_GetMeshHint(fountain)

    local f
    local typeName
    local hint
    local effects
    local parts     = {}
    local hasHP     = false
    local hasSP     = false
    local hpBonus   = 0
    local spBonus   = 0

    f = fountain
    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return Game.Debug and "dbg: null fountain - " .. tostring(fountain) or ""
    end

    typeName    = FountainTypeNames[NormalizeType(f.Type)] or FountainTypeNames.Fountain
    hint        = typeName

    if not Fountain_IsExplored(f) then
        return hint
    end

    effects = Fountain_GetResolvedEffects(f)

    for i = 1, #effects do
        local effect = effects[i].Effect
        local bonus  = effects[i].Bonus

        if effect == "HP" then
            hasHP   = true
            hpBonus = bonus
        elseif effect == "SP" then
            hasSP   = true
            spBonus = bonus
        else
            table.insert(parts, string.format("+%d %s", bonus, Fountain_GetEffectDisplayName(effect)))
        end
    end

    if hasHP and hasSP and hpBonus == spBonus then
        table.insert(parts, 1, string.format(FountainTxt.FtRestoreShortHPSP, hpBonus))
    else
        if hasHP then
            table.insert(parts, 1, string.format(FountainTxt.FtHP, hpBonus))
        end
        if hasSP then
            table.insert(parts, hasHP and 2 or 1, string.format(FountainTxt.FtSP, spBonus))
        end
    end

    if #parts > 0 then
        local suffix = ""

        if Fountain_HasTemporaryEffect(f) and not Fountain_HasPermanentEffect(f) then
            suffix = " " .. FountainTxt.FtTemp
        elseif Fountain_HasPermanentEffect(f) and not Fountain_HasTemporaryEffect(f) then
            suffix = " " .. FountainTxt.FtPermanent
        end

        hint = string.format("%s (%s) %s", hint, table.concat(parts, ", "), suffix)
    end

    return hint
end

function Fountain_GetHint(fountain)

    local f
    local typeName
    local hint
    local maxUses
    local usesLeft
    local usesVarKey
    
    f = fountain
    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return Game.Debug and "dbg: drink from null fountain - "..fountain or ""
    end

    typeName    = FountainTypeNames[NormalizeType(f.Type)] or FountainTypeNames.Fountain
    hint        = string.format(FountainTypeVerbs[NormalizeType(f.Type)] or FountainTxt.FtVerbDrink, typeName)
    maxUses     = tonumber(ResolveWarriorValue(f.MaxUses, f.MaxUsesW))

    if maxUses ~= nil and maxUses > 0 then

        if Fountain_IsExplored(f) then

            usesVarKey = Fountain_GetUsesVarKey(f)

            if usesVarKey ~= nil then
                usesLeft = maxUses - (mapvars[usesVarKey] or 0)

                if usesLeft < 0 then
                    usesLeft = 0
                end

                hint = string.format("%s (%d uses left)", hint, usesLeft)
            end
        end
    end

    return hint
end

function Fountain_GetStatusMessage(fountain)

    local f
    local msg
    local effects   = {}
    local hasHP     = false
    local hasSP     = false
    local hpBonus   = 0
    local spBonus   = 0

    f = fountain
    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return ""
    end

    msg = ResolveWarriorValue(f.UserStatusMsg, f.UserStatusMsgW)
    if msg ~= nil and msg ~= "" then
        return msg
    end

    for i = 1, 4 do
        local effect = ResolveWarriorValue(f["Effect" .. i], f["Effect" .. i .. "W"])
        local bonus  = ResolveWarriorValue(f["Bonus" .. i],  f["Bonus" .. i .. "W"])

        if effect ~= nil and effect ~= "" and bonus ~= nil and bonus ~= 0 then
            if effect == "HP" then
                hasHP   = true
                hpBonus = bonus
            elseif effect == "SP" then
                hasSP   = true
                spBonus = bonus
            else
                table.insert(effects, string.format("+%d %s", bonus, Fountain_GetEffectDisplayName(effect)))
            end
        end
    end

    -- Special compact restore messages
    if hasHP and hasSP and hpBonus == spBonus then
        msg = string.format(FountainTxt.FtRestoreHPSP, hpBonus)
    elseif hasHP and not hasSP and #effects == 0 then
        msg = string.format(FountainTxt.FtRestoreHP, hpBonus)
    elseif hasSP and not hasHP and #effects == 0 then
        msg = string.format(FountainTxt.FtRestoreSP, spBonus)
    else
        if hasHP then
            table.insert(effects, 1, string.format(FountainTxt.FtHP, hpBonus))
        end
        if hasSP then
            table.insert(effects, hasHP and 2 or 1, string.format(FountainTxt.FtSP, spBonus))
        end

        msg = table.concat(effects, ", ")
    end

    if Fountain_HasTemporaryEffect(f) and not (hasHP or hasSP) then
        msg = msg .. " " .. FountainTxt.FtTemp
    elseif Fountain_HasPermanentEffect(f) and not (hasHP or hasSP) then
        msg = msg .. " " .. FountainTxt.FtPermanent
    end

    return msg
end

local function IsNonEmptyString(s)
    return s ~= nil and tostring(s):match("^%s*(.-)%s*$") ~= ""
end

function Fountain_GetAutonoteText(fountain)

    local f
    local note
    local stats

    f = fountain    
    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return ""
    end

    note  = f.Autonote or ""
    stats = Fountain_GetStatusMessage(f) or ""

    if IsNonEmptyString(note) and IsNonEmptyString(stats) then
        return note .. "\n\n" .. stats
    elseif IsNonEmptyString(note) then
        return note
    elseif IsNonEmptyString(stats) then
        return stats
    end

    return ""
end

function Fountain_Use(fountain)

    local f                 = fountain
    local maxUses           = 0
    local requiredCondition = ""
    local onCheckLua        = ""
    local onUseLua          = ""
    local statusMsg         = ""
    local checkOk           = true
    local tempIndex         = nil
    local tempBit           = nil
    local effects           = {}
    local usesVarKey        = nil
    local wasExplored       = nil

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    end

    if f == nil then
        return false, false
    end

    usesVarKey        = Fountain_GetUsesVarKey(f)
    maxUses           = ResolveWarriorValue(f.MaxUses,           f.MaxUsesW)
    requiredCondition = ResolveWarriorValue(f.RequiredCondition, f.RequiredConditionW)
    onCheckLua        = ResolveWarriorValue(f.OnCheckLua,        f.OnCheckLuaW)
    onUseLua          = ResolveWarriorValue(f.OnUseLua,          f.OnUseLuaW)
    effects           = Fountain_GetResolvedEffects(f)

    -- Max uses tracking
    if tonumber(maxUses) ~= nil and tonumber(maxUses) > 0 then
        if usesVarKey == nil then
            if Game.Debug then
                Game.ShowStatusText("Dbg: usesVarKey is nil")
            else
                Game.ShowStatusText(FountainTxt.FtRefreshing)
            end
            return false, false
        end

        if (mapvars[usesVarKey] or 0) >= tonumber(maxUses) then
            if Game.Debug then
                Game.ShowStatusText("Dbg: Out of charges: " .. usesVarKey .. " - maxUses: " .. tostring(maxUses))
            else
                Game.ShowStatusText(FountainTxt.FtRefreshing)
            end
            return false, false
        end
    end

    -- Named reusable condition
    if requiredCondition ~= nil and requiredCondition ~= "" and requiredCondition ~= INHERIT_MARKER then
        if not Fountain_ResolveCondition(requiredCondition) then
            if Game.Debug then
                Game.ShowStatusText("Dbg: check condition failed: " .. requiredCondition)
            else
                Game.ShowStatusText(FountainTxt.FtRefreshing)
            end
            return false, false
        end
    end

    -- Temporary fountain re-use blocking by internal temp index
    if Fountain_HasTemporaryEffect(f) then

        tempIndex   = Fountain_GetTempIndex(f)
        tempBit     = Fountain_GetTempBitNameByIndex(tempIndex)

        if tempBit == nil then
            if Game.Debug then
                Game.ShowStatusText("Dbg: tempBit is nil")
            else
                Game.ShowStatusText(FountainTxt.FtRefreshing)
            end
            return false, false
        end

        if evt.Cmp("PlayerBits", tempBit) then
            if Game.Debug then
                Game.ShowStatusText("Dbg: already drank! (PlayerBits Cmp is true)")
            else
                Game.ShowStatusText(FountainTxt.FtRefreshing)
            end
            return false, false
        end
    end

    checkOk = Fountain_RunLuaChunk(onCheckLua, f, "FountainOnCheckLua:" .. tostring(f.ID))
    if checkOk == false then
        Game.ShowStatusText(FountainTxt.FtRefreshing)
        return false, false
    end

    for i = 1, #effects do
        if effects[i].Effect == "ElemResBonus" then
            evt.Add("FireResBonus",   effects[i].Bonus)
            evt.Add("AirResBonus",    effects[i].Bonus)
            evt.Add("WaterResBonus",  effects[i].Bonus)
            evt.Add("EarthResBonus",  effects[i].Bonus)
        elseif effects[i].Effect == "SelfResBonus" then
            evt.Add("SpiritResBonus", effects[i].Bonus)
            evt.Add("MindResBonus",   effects[i].Bonus)
            evt.Add("BodyResBonus",   effects[i].Bonus)
        elseif effects[i].Effect == "ElemRes" then
            evt.Add("FireResistance",  effects[i].Bonus)
            evt.Add("AirResistance",   effects[i].Bonus)
            evt.Add("WaterResistance", effects[i].Bonus)
            evt.Add("EarthResistance", effects[i].Bonus)
        elseif effects[i].Effect == "SelfRes" then
            evt.Add("SpiritResistance", effects[i].Bonus)
            evt.Add("MindResistance",   effects[i].Bonus)
            evt.Add("BodyResistance",   effects[i].Bonus)
        else
            evt.Add(effects[i].Effect, effects[i].Bonus)
        end
    end

    if tempBit ~= nil then
        evt.Add("PlayerBits", tempBit)
    end

    if tonumber(maxUses) ~= nil and tonumber(maxUses) > 0 and usesVarKey ~= nil then
        mapvars[usesVarKey] = (mapvars[usesVarKey] or 0) + 1
    end

    if onUseLua ~= nil and onUseLua ~= "" and onUseLua ~= INHERIT_MARKER then
        Fountain_RunLuaChunk(onUseLua, f, "FountainOnUseLua:" .. tostring(f.ID))
    end

    statusMsg = Fountain_GetStatusMessage(f)
    if statusMsg ~= nil and statusMsg ~= "" then
        Game.ShowStatusText(statusMsg)
    else
        Game.ShowStatusText(FountainTxt.FtRefreshing)
    end
    
    wasExplored = Fountain_IsExplored(f)
    Fountain_SetExplored(f)

    if f.Autonote ~= nil and f.Autonote ~= "" then
        local autonoteStr = ":" .. f.ID
        AddAutonote(autonoteStr)
    end

    return true, not wasExplored
end

function Fountain_RefillByMap(mapName)

    local bits = Fountain_GetMapTempBits(mapName)

    if #bits == 0 then
        return false
    end

    RefillTimer(function()
        for i = 1, #bits do
            evt.All.Subtract("PlayerBits", bits[i])
        end
    end, const.Day)

    return true
end

function Fountain(evID, evMeshID, fountain)

    local f = nil
    local hasLimitedUses = false

    if type(fountain) == "string" then
        f = Fountain_FindByID(fountain)
    else
        f = fountain
    end

    if Game.Debug and f == nil then
        debug.ErrorMessage("Fountain doesn't exist: " .. tostring(fountain))
    end

    if f ~= nil then
        local maxUses   = tonumber(ResolveWarriorValue(f.MaxUses, f.MaxUsesW))
        hasLimitedUses  = maxUses ~= nil and maxUses > 0
    end

    if evMeshID > 0 then
        evt.hint[evMeshID] = Fountain_GetMeshHint(f)
    end

    evt.hint[evID]  = Fountain_GetHint(f)
    evt.map[evID]   = function()

        local ok, discoveredNow = Fountain_Use(f)

        if ok and (hasLimitedUses or discoveredNow) then
            evt.hint[evID] = Fountain_GetHint(f)
        end

        if ok and evMeshID > 0 and discoveredNow then
            evt.hint[evMeshID] = Fountain_GetMeshHint(f)
        end
    end
end
