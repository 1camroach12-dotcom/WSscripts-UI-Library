--[[
    WSscripts UI Library - Theme Util
    Author: WSscripts Team
--]]
local Theme = {}

Theme.BG = Color3.fromRGB(25, 28, 34)
Theme.BG_DARK = Color3.fromRGB(18, 21, 27)
Theme.ACCENT = Color3.fromRGB(0, 255, 255)
Theme.FG = Color3.fromRGB(230, 240, 255)
Theme.FG_DIM = Color3.fromRGB(105, 140, 180)
Theme.BG_BTN = Color3.fromRGB(34, 38, 50)
Theme.BG_TAB_HOVER = Color3.fromRGB(36, 43, 55)
Theme.BG_TAB_ACTIVE = Color3.fromRGB(24, 34, 56)
Theme.GLOW_IMG = "rbxassetid://4925836605"
Theme.EASING = Enum.EasingStyle.Quint
Theme.FONT_BOLD = Enum.Font.GothamBold
Theme.FONT_SEMIBOLD = Enum.Font.GothamSemibold

function Theme:StyleFrame(frame)
    if not frame:FindFirstChildOfClass("UICorner") then
        local cor = Instance.new("UICorner")
        cor.CornerRadius = UDim.new(0,16)
        cor.Parent = frame
    end
    if not frame:FindFirstChildOfClass("UIStroke") then
        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.ACCENT
        stroke.Width = 1.6
        stroke.Thickness = 1
        stroke.Transparency = (frame.Name == "Main" or frame.Name == "Sidebar") and 0.65 or 0.48
        stroke.Parent = frame
    end
end

return Theme
