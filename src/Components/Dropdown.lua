--[[
    WSscripts UI Library - Dropdown/Tab System (used for Tabs)
    Author: WSscripts Team
--]]
local Tween = require(script.Parent.Parent.Utils.Tween)
local Theme = require(script.Parent.Parent.Utils.Theme)
local Toggle = require(script.Parent.Toggle)
local Button = require(script.Parent.Button)
local Slider = require(script.Parent.Slider)

local Tab = {}
Tab.__index = Tab

function Tab.NewTab(window, tabName)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Name = tabName
    self.Active = false

    -- Tab Button
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

    -- Hover
    local origColor = tabBtn.BackgroundColor3
    tabBtn.MouseEnter:Connect(function()
        Tween:Tween(tabBtn, {BackgroundColor3 = Theme.BG_TAB_HOVER}, 0.17, Theme.EASING)
    end)
    tabBtn.MouseLeave:Connect(function()
        Tween:Tween(tabBtn, {BackgroundColor3 = origColor}, 0.18, Theme.EASING)
    end)

    -- Content Section
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

    -- Activate logic
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

    -- API
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
    -- Add more as needed

    self.Destroy = function()
        tabBtn:Destroy()
        section:Destroy()
    end

    return self
end

return Tab
