--[[
Description:    Optional local sound panning correction
]]

-- MM7 has separate paths for emulated stereo positioning and Miles 3D
-- positioning.  Intercept the final Miles calls so no earlier coordinate
-- conversion can bypass the correction.

local PatchState = {
    Loaded              = true,
    Enabled             = not not Game.InvertLocalSoundPanning,
    Pan2DCalls          = 0,
    Position3DCalls     = 0,
}

Game.LocalSoundPanningPatch = PatchState

local function IsEnabled()

    PatchState.Enabled = not not Game.InvertLocalSoundPanning
    return PatchState.Enabled
end

local function Invert2DPan(d)

    -- Stack at AIL_set_sample_pan: sample handle, pan (0 = left, 127 = right).
    local panAddress = d.esp + 4
    local pan = mem.i4[panAddress]

    PatchState.Pan2DCalls = PatchState.Pan2DCalls + 1
    PatchState.Last2DPan = pan

    if IsEnabled() then
        pan = 127 - pan
        mem.i4[panAddress] = pan
    end

    PatchState.Last2DResult = pan
end

-- Initial object sound, explicit X/Y sound, and moving-source update.
mem.autohook(0x4AAC94, Invert2DPan, 6)
mem.autohook(0x4AADAF, Invert2DPan, 6)
mem.autohook(0x4AB435, Invert2DPan, 6)

local function Invert3DPosition(d)

    -- Stack at AIL_set_3D_position: sample handle, X, Y, Z.
    local xAddress = d.esp + 4
    local x = mem.r4[xAddress]

    PatchState.Position3DCalls = PatchState.Position3DCalls + 1
    PatchState.Last3DX = x

    if IsEnabled() then
        x = -x
        mem.r4[xAddress] = x
    end

    PatchState.Last3DResult = x
end

-- Initial placement and subsequent updates of active Miles 3D samples.
mem.autohook(0x4AA91F, Invert3DPosition, 6)
mem.autohook(0x4AB290, Invert3DPosition, 6)

local function Invert3DOrientation(d)

    if IsEnabled() then
        -- Stack: handle, X_face, Y_face, Z_face, X_up, Y_up, Z_up.
        mem.r4[d.esp + 4] = -mem.r4[d.esp + 4]
        mem.r4[d.esp + 16] = -mem.r4[d.esp + 16]
    end
end

-- Keep source orientation consistent with its mirrored position.
mem.autohook(0x4AA953, Invert3DOrientation, 6)
mem.autohook(0x4AB2C4, Invert3DOrientation, 6)
