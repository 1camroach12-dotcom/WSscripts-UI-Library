--[[
    WSscripts UI Library - Main Entry
    Author: WSscripts Team
--]]
local Tween = require(script.Utils.Tween)
local Drag = require(script.Utils.Drag)
local Theme = require(script.Utils.Theme)
local Window = require(script.Window)

local Library = {}
Library.__index = Library

function Library:CreateWindow(opts)
    opts = opts or {}
    return Window.new(opts)
end

return setmetatable(Library, {
    __call = function(self, ...)
        return self
    end
})
