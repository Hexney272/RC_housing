-- DataView library for binary data manipulation in Lua
local dataView = setmetatable({
    EndBig = ">",
    EndLittle = "<",
    
    Types = {
        Int8 = { code = "i1" },
        Uint8 = { code = "I1" },
        Int16 = { code = "i2" },
        Uint16 = { code = "I2" },
        Int32 = { code = "i4" },
        Uint32 = { code = "I4" },
        Int64 = { code = "i8" },
        Uint64 = { code = "I8" },
        Float32 = { code = "f", size = 4 },
        Float64 = { code = "d", size = 8 },
        LuaInt = { code = "j" },
        UluaInt = { code = "J" },
        LuaNum = { code = "n" },
        String = { code = "z", size = -1 }
    },
    
    FixedTypes = {
        String = { code = "c" },
        Int = { code = "i" },
        Uint = { code = "I" }
    }
}, {
    __call = function(self, size)
        return dataView.ArrayBuffer(size)
    end
})

dataView.__index = dataView

-- Create a new ArrayBuffer with specified size
function dataView.ArrayBuffer(size)
    return setmetatable({
        blob = string.rep("\0", size),
        length = size,
        offset = 1,
        cangrow = true
    }, dataView)
end

-- Wrap an existing blob
function dataView.Wrap(blob)
    return setmetatable({
        blob = blob,
        length = #blob,
        offset = 1,
        cangrow = true
    }, dataView)
end

-- Get the underlying buffer
function dataView.Buffer(self)
    return self.blob
end

-- Get byte length
function dataView.ByteLength(self)
    return self.length
end

-- Get byte offset
function dataView.ByteOffset(self)
    return self.offset
end

-- Create a sub-view of the buffer
function dataView.SubView(self, offset, length)
    return setmetatable({
        blob = self.blob,
        length = length or self.length,
        offset = 1 + offset,
        cangrow = false
    }, dataView)
end

-- Get endianness string
local function getEndian(isBig)
    return isBig and dataView.EndBig or dataView.EndLittle
end

-- Internal pack function
local function pack(view, offset, value, format)
    local newBlob = view.blob:sub(1, offset - 1) .. string.pack(format, value) .. view.blob:sub(offset + string.packsize(format))
    
    if not view.cangrow and newBlob ~= view.blob then
        return false
    end
    
    view.blob = newBlob
    view.length = #newBlob
    return true
end

-- Generate getter and setter methods for each type
for typeName, typeInfo in pairs(dataView.Types) do
    -- Calculate size if not provided
    if not typeInfo.size then
        typeInfo.size = string.packsize(typeInfo.code)
    elseif typeInfo.size >= 0 then
        local actualSize = string.packsize(typeInfo.code)
        if actualSize ~= typeInfo.size then
            error(string.format(
                "Pack size of %s (%d) does not match cached length: (%d)",
                typeName, actualSize, typeInfo.size
            ))
        end
    end
    
    -- Create getter method
    local getterName = "Get" .. typeName
    dataView[getterName] = function(self, offset, isBigEndian)
        offset = offset or 0
        if offset >= 0 then
            local pos = self.offset + offset
            local format = getEndian(isBigEndian) .. typeInfo.code
            return string.unpack(format, self.blob, pos)
        end
        return nil
    end
    
    -- Create setter method
    local setterName = "Set" .. typeName
    dataView[setterName] = function(self, offset, value, isBigEndian)
        if offset >= 0 and value then
            local pos = self.offset + offset
            local size = typeInfo.size
            
            -- For variable-length types, get actual size
            if size < 0 then
                size = #value or typeInfo.size
            end
            
            -- Check bounds if not growable
            if not self.cangrow and (pos + size - 1) > self.length then
                error("cannot grow dataview")
            end
            
            local format = getEndian(isBigEndian) .. typeInfo.code
            if not pack(self, pos, value, format) then
                error("cannot grow subview")
            end
        end
        return self
    end
end

-- Generate getter and setter methods for fixed-size types
for typeName, typeInfo in pairs(dataView.FixedTypes) do
    typeInfo.size = -1
    
    -- Create fixed-size getter
    local getterName = "GetFixed" .. typeName
    dataView[getterName] = function(self, offset, length, isBigEndian)
        if offset >= 0 and (self.offset + offset + length - 1) <= self.length then
            local pos = self.offset + offset
            local format = getEndian(isBigEndian) .. "c" .. tostring(length)
            return string.unpack(format, self.blob, pos)
        end
        return nil
    end
    
    -- Create fixed-size setter
    local setterName = "SetFixed" .. typeName
    dataView[setterName] = function(self, offset, length, value, isBigEndian)
        if offset >= 0 and value then
            local pos = self.offset + offset
            
            -- Check bounds if not growable
            if not self.cangrow and (pos + length - 1) > self.length then
                error("cannot grow dataview")
            end
            
            local format = getEndian(isBigEndian) .. "c" .. tostring(length)
            if not pack(self, pos, value, format) then
                error("cannot grow subview")
            end
        end
        return self
    end
end

-- Vector normalization helper
local function normalize(x, y, z)
    local length = math.sqrt(x*x + y*y + z*z)
    if length == 0 then
        return 0, 0, 0
    end
    return x/length, y/length, z/length
end

-- Create entity matrix buffer from game entity
function makeEntityMatrix(entity)
    local forward, right, up, pos = GetEntityMatrix(entity)
    
    local buffer = dataView.ArrayBuffer(60)
    buffer:SetFloat32(0, right[1])
        :SetFloat32(4, right[2])
        :SetFloat32(8, right[3])
        :SetFloat32(12, 0)
        :SetFloat32(16, forward[1])
        :SetFloat32(20, forward[2])
        :SetFloat32(24, forward[3])
        :SetFloat32(28, 0)
        :SetFloat32(32, up[1])
        :SetFloat32(36, up[2])
        :SetFloat32(40, up[3])
        :SetFloat32(44, 0)
        :SetFloat32(48, pos[1])
        :SetFloat32(52, pos[2])
        :SetFloat32(56, pos[3])
        :SetFloat32(60, 1)
    
    return buffer
end

-- Apply matrix buffer to entity
function applyEntityMatrix(entity, buffer)
    -- Extract matrix components
    local fx = buffer:GetFloat32(16)
    local fy = buffer:GetFloat32(20)
    local fz = buffer:GetFloat32(24)
    
    local rx = buffer:GetFloat32(0)
    local ry = buffer:GetFloat32(4)
    local rz = buffer:GetFloat32(8)
    
    local ux = buffer:GetFloat32(32)
    local uy = buffer:GetFloat32(36)
    local uz = buffer:GetFloat32(40)
    
    local px = buffer:GetFloat32(48)
    local py = buffer:GetFloat32(52)
    local pz = buffer:GetFloat32(56)
    
    -- Normalize vectors
    fx, fy, fz = normalize(fx, fy, fz)
    rx, ry, rz = normalize(rx, ry, rz)
    ux, uy, uz = normalize(ux, uy, uz)
    
    -- Apply to entity
    SetEntityMatrix(entity, fx, fy, fz, rx, ry, rz, ux, uy, uz, px, py, pz)
end

-- ============================================================================
-- Key Mappings for Gizmo Controls
-- ============================================================================

-- Register mouse selection control
RegisterKeyMapping(
    "+gizmoSelect",
    TRANSLATE("control.gizmo:select"),
    "MOUSE_BUTTON",
    "MOUSE_LEFT"
)

-- Register translation mode control
RegisterKeyMapping(
    "+gizmoTranslation",
    TRANSLATE("control.gizmo:translation"),
    "keyboard",
    Config.FurnitureControls.GIZMO_TRANSLATION.control
)

-- Register rotation mode control
RegisterKeyMapping(
    "+gizmoRotation",
    TRANSLATE("control.gizmo:rotation"),
    "keyboard",
    Config.FurnitureControls.GIZMO_ROTATION.control
)