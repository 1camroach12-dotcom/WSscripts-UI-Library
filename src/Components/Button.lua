--[[
    WSscripts UI Library - Button
    Author: WSscripts Team
--]]
local Tween = require(script.Parent.Parent.Utils.Tween)
local Theme = require(script.Parent.Parent.Utils.Theme)

local Button = {}
Button.__index = Button

function Button.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Button)

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -32, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Section

    -- Button UI
    local btn = Instance.new("TextButton")
    btn.Text = opts.Name or "Button"
    btn.Font = Theme.FONT_BOLD
    btn.TextSize = 18
    btn.TextColor3 = Theme.FG
    btn.BackgroundColor3 = Theme.BG_BTN
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 1, 0)
    Theme:StyleFrame(btn)
    btn.Parent = frame

    -- Neon glow
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Image = Theme.GLOW_IMG
    glow.ImageColor3 = Theme.ACCENT
    glow.ImageTransparency = 0.88
    glow.Size = UDim2.new(1,12,1,12)
    glow.Position = UDim2.new(0,-6,0,-6)
    glow.ZIndex = 0
    glow.Parent = btn

    -- Ripple
    local function ripple()
        local circ = Instance.new("ImageLabel")
        circ.Image = "rbxassetid://3570695787" -- circle
        circ.ImageTransparency = 0.5
        circ.ImageColor3 = Theme.ACCENT
        circ.BackgroundTransparency = 1
        circ.Size = UDim2.new(0,0,0,0)
        circ.Position = UDim2.new(0.5,0,0.5,0)
        circ.AnchorPoint = Vector2.new(0.5,0.5)
        circ.ClipsDescendants = true
        circ.ZIndex = 3
        circ.Parent = btn

        Tween:Tween(circ, {Size=UDim2.new(1,28,1,28),ImageTransparency=1}, 0.35, Enum.EasingStyle.Quint)
        task.wait(0.35)
        circ:Destroy()
    end

    -- Hover
    btn.MouseEnter:Connect(function()
        Tween:Tween(glow, {ImageTransparency = 0.7}, 0.19, Theme.EASING)
    end)
    btn.MouseLeave:Connect(function()
        Tween:Tween(glow, {ImageTransparency = 0.88}, 0.19, Theme.EASING)
    end)

    btn.MouseButton1Click:Connect(function()
        ripple()
        if opts.Callback then
            task.spawn(opts.Callback)
        end
    end)

    self.Destroy = function()
        frame:Destroy()
    end

    return self
end

return Button
