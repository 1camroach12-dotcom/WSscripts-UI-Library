--[[
    WSscripts UI Library - Tween Util
    Author: WSscripts Team
--]]
local Tween = {}
Tween.__index = Tween

Tween.EASING = Enum.EasingStyle.Quint

function Tween:Tween(obj, props, time, easing)
    local ts = game:GetService("TweenService")
    local info = TweenInfo.new(time or 0.2, easing or Tween.EASING, Enum.EasingDirection.Out)
    local tween = ts:Create(obj, info, props)
    tween:Play()
    return tween
end

return Tween
