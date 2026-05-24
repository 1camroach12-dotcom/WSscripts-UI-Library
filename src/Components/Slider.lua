--[[
    WSscripts UI Library - Slider
    Author: WSscripts Team
--]]
local Tween = require(script.Parent.Parent.Utils.Tween)
local Theme = require(script.Parent.Parent.Utils.Theme)

local Slider = {}
Slider.__index = Slider

function Slider.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Slider)
    self.Value = opts.Default or opts.Min or 0
    local min, max = opts.Min or 0, opts.Max or 100

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -32, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Section

    -- Label
    local label = Instance.new("TextLabel")
    label.Text = opts.Name or "Slider"
    label.Font = Theme.FONT_SEMIBOLD
    label.TextSize = 18
    label.TextColor3 = Theme.FG
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 22)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Bar background
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.BackgroundColor3 = Theme.BG_DARK
    bar.Size = UDim2.new(1, -56, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 30)
    Theme:StyleFrame(bar)
    bar.Parent = frame

    -- Neon fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Theme.ACCENT
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0,0,0,0)
    Theme:StyleFrame(fill)
    fill.Parent = bar

    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Image = Theme.GLOW_IMG
    glow.ImageColor3 = Theme.ACCENT
    glow.ImageTransparency = 0.80
    glow.Size = UDim2.new(1,18,1,18)
    glow.Position = UDim2.new(0,-9,0,-9)
    glow.ZIndex = 0
    glow.Parent = bar

    -- Knob
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Theme.ACCENT
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 0, 0.5, -10)
    Theme:StyleFrame(knob)
    knob.Parent = bar

    -- Value Text
    local valueLbl = Instance.new("TextLabel")
    valueLbl.Text = tostring(self.Value)
    valueLbl.Font = Theme.FONT_SEMIBOLD
    valueLbl.TextSize = 16
    valueLbl.TextColor3 = Theme.ACCENT
    valueLbl.BackgroundTransparency = 1
    valueLbl.Size = UDim2.new(0, 46, 1, 0)
    valueLbl.Position = UDim2.new(1, 8, 0, 0)
    valueLbl.Parent = bar

    -- Input logic
    local dragging = false
    local function setValueFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        self.Value = math.floor((rel * (max-min) + min) + 0.5)
        local percent = (self.Value-min)/(max-min)
        Tween:Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.21, Theme.EASING)
        Tween:Tween(knob, {Position = UDim2.new(percent, -10, 0.5, -10)}, 0.21, Theme.EASING)
        valueLbl.Text = tostring(self.Value)
        if opts.Callback and dragging then
            task.spawn(opts.Callback, self.Value)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setValueFromX(input.Position.X)
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setValueFromX(input.Position.X)
        end
    end)

    -- Init
    setValueFromX(bar.AbsolutePosition.X + fill.AbsoluteSize.X)

    self.Destroy = function()
        frame:Destroy()
    end

    return self
end

return Slider
