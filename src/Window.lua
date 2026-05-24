--[[
    WSscripts UI Library - Window
    Author: WSscripts Team
--]]
local Tween = require(script.Parent.Utils.Tween)
local Drag = require(script.Parent.Utils.Drag)
local Theme = require(script.Parent.Utils.Theme)
local Components = script.Parent.Components

local Window = {}
Window.__index = Window

function Window.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Window)

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Name = "WSscriptsUILibrary"
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 540, 0, 340)
    main.Position = UDim2.new(0.5, -270, 0.5, -170)
    main.BackgroundColor3 = Theme.BG
    main.BackgroundTransparency = 0.18
    main.BorderSizePixel = 0
    main.Parent = gui
    main.ClipsDescendants = true

    -- Neon Glow (layered ImageLabels)
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

    -- UICorner & Stroke
    Theme:StyleFrame(main)

    -- Topbar
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.BackgroundTransparency = 1
    topbar.Size = UDim2.new(1, 0, 0, 44)
    topbar.Parent = main

    -- Title
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

    -- Minimize button □
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

    -- Close button ✕
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

    -- Tab Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 128, 1, -44)
    sidebar.Position = UDim2.new(0, 0, 0, 44)
    sidebar.BackgroundTransparency = 0.07
    sidebar.BackgroundColor3 = Theme.BG_DARK
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    Theme:StyleFrame(sidebar)

    -- Tabs UIList
    local tabsList = Instance.new("UIListLayout")
    tabsList.FillDirection = Enum.FillDirection.Vertical
    tabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsList.Padding = UDim.new(0, 10)
    tabsList.Parent = sidebar

    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -136, 1, -44)
    content.Position = UDim2.new(0, 136, 0, 44)
    content.BackgroundTransparency = 1
    content.Parent = main

    -- Dragging
    Drag:Draggable(main, topbar)

    gui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui

    -- Window Methods
    self.Gui = gui
    self.Main = main
    self.Content = content
    self.Sidebar = sidebar
    self._Tabs = {}
    self._TabOrder = {}
    self._CurrentTab = nil

    function self:CreateTab(tabName)
        local tab = require(Components.Dropdown).NewTab(self, tabName)
        self._Tabs[tabName] = tab
        table.insert(self._TabOrder, tab)
        if not self._CurrentTab then
            tab:Show()
            self._CurrentTab = tab
        end
        return tab
    end

    -- Minimize/reopen logic
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

return Window
