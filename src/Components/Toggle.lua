--[[
    WSscripts UI Library - Toggle
    Author: WSscripts Team
--]]
local Tween = require(script.Parent.Parent.Utils.Tween)
local Theme = require(script.Parent.Parent.Utils.Theme)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Toggle)
    self.Enabled = opts.Default or false

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -32, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Section

    -- Label
    local label = Instance.new("TextLabel")
    label.Text = opts.Name or "Toggle"
    label.Font = Theme.FONT_SEMIBOLD
    label.TextSize = 18
    label.TextColor3 = Theme.FG
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -56, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Toggle Outer
    local toggB = Instance.new("Frame")
    toggB.Size = UDim2.new(0, 42, 0, 22)
    toggB.Position = UDim2.new(1, -46, 0.5, -11)
    toggB.BackgroundColor3 = Theme.BG_DARK
    Theme:StyleFrame(toggB)
    toggB.Parent = frame

    -- Neon glow
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Image = Theme.GLOW_IMG
    glow.ImageColor3 = Theme.ACCENT
    glow.ImageTransparency = self.Enabled and 0.65 or 0.92
    glow.Size = UDim2.new(1,10,1,10)
    glow.Position = UDim2.new(0,-5,0,-5)
    glow.ZIndex = 0
    glow.Parent = toggB

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundTransparency = 1
    fill.Size = UDim2.new(1,0,1,0)
    fill.Parent = toggB

    -- Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = self.Enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = self.Enabled and Theme.ACCENT or Theme.FG_DIM
    Theme:StyleFrame(knob)
    knob.Parent = toggB

    -- Clickable Surface
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1,0,1,0)
    button.Text = ""
    button.Parent = toggB

    local function update(enabled, animate)
        Tween:Tween(knob, {
            Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = enabled and Theme.ACCENT or Theme.FG_DIM
        }, 0.19, Theme.EASING)
        Tween:Tween(glow, {
            ImageTransparency = enabled and 0.55 or 0.92
        }, 0.25, Theme.EASING)
    end

    button.MouseButton1Click:Connect(function()
        self.Enabled = not self.Enabled
        update(self.Enabled, true)
        if opts.Callback then
            task.spawn(opts.Callback, self.Enabled)
        end
    end)

    update(self.Enabled, false)

    self.Destroy = function()
        frame:Destroy()
    end

    return self
end

return Toggle
