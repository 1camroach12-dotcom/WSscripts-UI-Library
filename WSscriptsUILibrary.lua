--[[
    WSscripts UI Library (Single-File HTTP Version)
    Author: WSscripts Team
    All modules inlined for loadstring/Raw GH use.
]]

--------------------
-- Theme Utility  --
--------------------
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

----------------------
-- Tween Utility    --
----------------------
local TweenUtil = {}
TweenUtil.__index = TweenUtil

TweenUtil.EASING = Enum.EasingStyle.Quint

function TweenUtil:Tween(obj, props, time, easing)
    local ts = game:GetService("TweenService")
    local info = TweenInfo.new(time or 0.2, easing or TweenUtil.EASING, Enum.EasingDirection.Out)
    local tween = ts:Create(obj, info, props)
    tween:Play()
    return tween
end

---------------------
-- Drag Utility    --
---------------------
local UIS = game:GetService("UserInputService")
local Drag = {}
Drag.__index = Drag

function Drag:Draggable(frame, dragBar)
    local dragging = false
    local dragStart, startPos

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--------------------------------
-- Toggle Component           --
--------------------------------
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Toggle)
    self.Enabled = opts.Default or false

    local Tween = TweenUtil

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

    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1,0,1,0)
    button.Text = ""
    button.Parent = toggB

    local function update(enabled)
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
        update(self.Enabled)
        if opts.Callback then
            task.spawn(opts.Callback, self.Enabled)
        end
    end)

    update(self.Enabled)

    self.Destroy = function()
        frame:Destroy()
    end

    return self
end

--------------------------------
-- Button Component           --
--------------------------------
local Button = {}
Button.__index = Button

function Button.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Button)
    local Tween = TweenUtil

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -32, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Section

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
        circ.Image = "rbxassetid://3570695787"
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

--------------------------------
-- Slider Component           --
--------------------------------
local Slider = {}
Slider.__index = Slider

function Slider.new(tab, opts)
    opts = opts or {}
    local self = setmetatable({}, Slider)
    local Tween = TweenUtil
    self.Value = opts.Default or opts.Min or 0
    local min, max = opts.Min or 0, opts.Max or 100

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -32, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Section

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

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.BackgroundColor3 = Theme.BG_DARK
    bar.Size = UDim2.new(1, -56, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 30)
    Theme:StyleFrame(bar)
    bar.Parent = frame

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

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Theme.ACCENT
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 0, 0.5, -10)
    Theme:StyleFrame(knob)
    knob.Parent = bar

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Text = tostring(self.Value)
    valueLbl.Font = Theme.FONT_SEMIBOLD
    valueLbl.TextSize = 16
    valueLbl.TextColor3 = Theme.ACCENT
    valueLbl.BackgroundTransparency = 1
    valueLbl.Size = UDim2.new(0, 46, 1, 0)
    valueLbl.Position = UDim2.new(1, 8, 0, 0)
    valueLbl.Parent = bar

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

    setValueFromX(bar.AbsolutePosition.X + fill.AbsoluteSize.X)

    self.Destroy = function()
        frame:Destroy()
    end

    return self
end

----------------------------------
-- Dropdown/Tab Component       --
----------------------------------
local Tab = {}
Tab.__index = Tab

function Tab.NewTab(window, tabName)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Name = tabName
    self.Active = false

    local Tween = TweenUtil

    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName
    tabBtn.Text = tabName
    tabBtn.Size = UDim2.new(1, -16, 0, 38)
    tabBtn.Position = UDim2.new(0, 8, 0, 0)
    tabBtn.Font = Theme.FONT_BOLD
    tabBtn.TextColor3 = Theme.ACCENT
    tabBtn.TextSize = 18
    tabBtn.BackgroundColor3 = Theme.BG_DARK
    tabBtn.AutoButtonColor = false
    Theme:StyleFrame(tabBtn)
    tabBtn.Parent = window.Sidebar

    local origColor = tabBtn.BackgroundColor3
    tabBtn.MouseEnter:Connect(function()
        Tween:Tween(tabBtn, {BackgroundColor3 = Theme.BG_TAB_HOVER}, 0.17, Theme.EASING)
    end)
    tabBtn.MouseLeave:Connect(function()
        Tween:Tween(tabBtn, {BackgroundColor3 = origColor}, 0.18, Theme.EASING)
    end)

    local section = Instance.new("Frame")
    section.Name = tabName .. "_Section"
    section.Size = UDim2.new(1, 0, 1, 0)
    section.Position = UDim2.new(0, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.Visible = false
    section.Parent = window.Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.Parent = section

    function self:Show()
        for _, t in pairs(window._TabOrder) do
            t.Section.Visible = false
        end
        section.Visible = true
        for _, btn in pairs(window.Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                Tween:Tween(btn, {BackgroundColor3 = Theme.BG_DARK}, 0.14, Theme.EASING)
            end
        end
        Tween:Tween(tabBtn, {BackgroundColor3 = Theme.BG_TAB_ACTIVE}, 0.15, Theme.EASING)
    end

    tabBtn.MouseButton1Click:Connect(function()
        self:Show()
        window._CurrentTab = self
    end)

    self.Section = section
    function self:CreateToggle(opts)
        return Toggle.new(self, opts)
    end
    function self:CreateButton(opts)
        return Button.new(self, opts)
    end
    function self:CreateSlider(opts)
        return Slider.new(self, opts)
    end

    self.Destroy = function()
        tabBtn:Destroy()
        section:Destroy()
    end

    return self
end

---------------------
-- Window Module   --
---------------------
local Window = {}
Window.__index = Window

function Window.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Window)

    local Tween = TweenUtil
    local DragUtil = Drag
    local ThemeUtil = Theme

    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Name = "WSscriptsUILibrary"
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 540, 0, 340)
    main.Position = UDim2.new(0.5, -270, 0.5, -170)
    main.BackgroundColor3 = Theme.BG
    main.BackgroundTransparency = 0.18
    main.BorderSizePixel = 0
    main.Parent = gui
    main.ClipsDescendants = true

    for i = 1, 2 do
        local neon = Instance.new("ImageLabel")
        neon.Size = UDim2.new(1, 24 - i*12, 1, 24 - i*12)
        neon.Position = UDim2.new(0, -12 + (i-1)*6, 0, -12 + (i-1)*6)
        neon.Image = Theme.GLOW_IMG
        neon.BackgroundTransparency = 1
        neon.ImageColor3 = Theme.ACCENT
        neon.ImageTransparency = 0.78 + i*0.07
        neon.ZIndex = 0
        neon.Parent = main
    end

    Theme:StyleFrame(main)

    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.BackgroundTransparency = 1
    topbar.Size = UDim2.new(1, 0, 0, 44)
    topbar.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = opts.Name or "WSscripts"
    title.Font = Theme.FONT_BOLD
    title.TextSize = 22
    title.TextColor3 = Theme.ACCENT
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 20, 0, 3)
    title.Size = UDim2.new(1, -120, 1, -6)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topbar

    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Text = "□"
    minBtn.Font = Theme.FONT_BOLD
    minBtn.TextColor3 = Theme.FG
    minBtn.TextSize = 18
    minBtn.BackgroundTransparency = 1
    minBtn.Size = UDim2.new(0, 40, 0, 36)
    minBtn.Position = UDim2.new(1, -82, 0, 7)
    minBtn.ZIndex = 2
    minBtn.AutoButtonColor = false
    minBtn.Parent = topbar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Text = "✕"
    closeBtn.Font = Theme.FONT_BOLD
    closeBtn.TextColor3 = Theme.FG
    closeBtn.TextSize = 18
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 40, 0, 36)
    closeBtn.Position = UDim2.new(1, -38, 0, 7)
    closeBtn.ZIndex = 2
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topbar

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 128, 1, -44)
    sidebar.Position = UDim2.new(0, 0, 0, 44)
    sidebar.BackgroundTransparency = 0.07
    sidebar.BackgroundColor3 = Theme.BG_DARK
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    Theme:StyleFrame(sidebar)

    local tabsList = Instance.new("UIListLayout")
    tabsList.FillDirection = Enum.FillDirection.Vertical
    tabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsList.Padding = UDim.new(0, 10)
    tabsList.Parent = sidebar

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -136, 1, -44)
    content.Position = UDim2.new(0, 136, 0, 44)
    content.BackgroundTransparency = 1
    content.Parent = main

    Drag:Draggable(main, topbar)

    gui.Parent = (game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui)

    self.Gui = gui
    self.Main = main
    self.Content = content
    self.Sidebar = sidebar
    self._Tabs = {}
    self._TabOrder = {}
    self._CurrentTab = nil

    function self:CreateTab(tabName)
        local tab = Tab.NewTab(self, tabName)
        self._Tabs[tabName] = tab
        table.insert(self._TabOrder, tab)
        if not self._CurrentTab then
            tab:Show()
            self._CurrentTab = tab
        end
        return tab
    end

    local minimized = false
    local reopenBtn

    minBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        minimized = true
        Tween:Tween(main, {Size=UDim2.new(0,180,0,44)}, 0.3, Theme.EASING)
        Tween:Tween(main, {Position=UDim2.new(0, 16, 0, 16)}, 0.3, Theme.EASING)
        wait(0.31)
        main.Visible = false

        reopenBtn = Instance.new("TextButton")
        reopenBtn.Text = "WS"
        reopenBtn.Font = Theme.FONT_BOLD
        reopenBtn.TextSize = 20
        reopenBtn.BackgroundColor3 = Theme.BG
        reopenBtn.Size = UDim2.new(0,64,0,32)
        reopenBtn.Position = UDim2.new(0, 16, 0, 16)
        Theme:StyleFrame(reopenBtn)
        reopenBtn.Parent = gui
        reopenBtn.ZIndex = 99

        reopenBtn.MouseButton1Click:Connect(function()
            reopenBtn:Destroy()
            main.Visible = true
            Tween:Tween(main, {Size=UDim2.new(0,540,0,340)}, 0.33, Theme.EASING)
            Tween:Tween(main, {Position=UDim2.new(0.5,-270,0.5,-170)}, 0.33, Theme.EASING)
            minimized = false
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween:Tween(main, {BackgroundTransparency=1}, 0.35, Theme.EASING)
        Tween:Tween(main, {Size=UDim2.new(0,10,0,10)},0.35,Theme.EASING)
        wait(0.37)
        gui:Destroy()
        if reopenBtn and reopenBtn.Parent then
            reopenBtn:Destroy()
        end
    end)

    return self
end

------------------------
-- Library Main      --
------------------------
local Library = {}
Library.__index = Library

function Library:CreateWindow(opts)
    opts = opts or {}
    return Window.new(opts)
end

return Library
