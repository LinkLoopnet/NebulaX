-- NebulaX v0.1 - Universal Roblox South London Remastered GUI
-- Main Framework

local NebulaX = {
    Version = "v0.1",
    Name = "NebulaX",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.F3,
    Library = nil
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Protected environment
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaX"
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui, fallback to PlayerGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

-- Notification System
local Notifications = {}
do
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 300, 0, 0)
    NotificationHolder.Position = UDim2.new(1, -320, 0, 20)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = ScreenGui
    
    function Notifications:Send(title, text, duration)
        duration = duration or 5
        
        local notifFrame = Instance.new("Frame")
        notifFrame.Name = "Notification"
        notifFrame.Size = UDim2.new(1, 0, 0, 60)
        notifFrame.Position = UDim2.new(1, 10, 0, #NotificationHolder:GetChildren() * 70)
        notifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        notifFrame.BackgroundTransparency = 0.1
        notifFrame.BorderSizePixel = 0
        notifFrame.ClipsDescendants = true
        notifFrame.Parent = NotificationHolder
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = notifFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -10, 0, 20)
        titleLabel.Position = UDim2.new(0, 5, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notifFrame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Text"
        textLabel.Size = UDim2.new(1, -10, 0, 25)
        textLabel.Position = UDim2.new(0, 5, 0, 25)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextSize = 13
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextWrapped = true
        textLabel.Parent = notifFrame
        
        local progressBar = Instance.new("Frame")
        progressBar.Name = "Progress"
        progressBar.Size = UDim2.new(1, 0, 0, 2)
        progressBar.Position = UDim2.new(0, 0, 1, -2)
        progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        progressBar.BorderSizePixel = 0
        progressBar.Parent = notifFrame
        
        -- Slide in animation
        notifFrame.Position = UDim2.new(1, 10, 0, #NotificationHolder:GetChildren() * 70 - 70)
        TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 0, #NotificationHolder:GetChildren() * 70 - 70)}):Play()
        
        -- Progress bar animation
        TweenService:Create(progressBar, TweenInfo.new(duration), {Size = UDim2.new(0, 0, 0, 2)}):Play()
        
        task.delay(duration, function()
            if notifFrame and notifFrame.Parent then
                TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, notifFrame.Position.Y.Offset)}):Play()
                task.wait(0.3)
                notifFrame:Destroy()
                
                -- Rearrange remaining notifications
                for i, child in ipairs(NotificationHolder:GetChildren()) do
                    if child:IsA("Frame") then
                        TweenService:Create(child, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 0, (i-1) * 70)}):Play()
                    end
                end
            end
        end)
    end
end

-- Main GUI Library
NebulaX.Library = {}
local Library = NebulaX.Library

-- Theme system
local Themes = {
    Dark = {
        Main = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60),
        Danger = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 255, 120)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 250),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(80, 130, 255),
        Text = Color3.fromRGB(30, 30, 40),
        TextSecondary = Color3.fromRGB(80, 80, 90),
        Border = Color3.fromRGB(200, 200, 210),
        Danger = Color3.fromRGB(255, 70, 70),
        Success = Color3.fromRGB(70, 200, 70)
    },
    Purple = {
        Main = Color3.fromRGB(20, 10, 30),
        Secondary = Color3.fromRGB(40, 20, 50),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 180, 220),
        Border = Color3.fromRGB(60, 40, 70),
        Danger = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 255, 120)
    },
    Neon = {
        Main = Color3.fromRGB(0, 0, 0),
        Secondary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(40, 40, 40),
        Danger = Color3.fromRGB(255, 0, 0),
        Success = Color3.fromRGB(0, 255, 0)
    }
}

local CurrentTheme = Themes.Dark

-- Update theme function
local function UpdateTheme(theme)
    CurrentTheme = Themes[theme] or Themes.Dark
    -- Update all UI elements color (implemented later)
end

-- Create Main Window
function Library:CreateWindow(title, size)
    local Window = {}
    
    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size or UDim2.new(0, 800, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.BackgroundColor3 = CurrentTheme.Main
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = CurrentTheme.Secondary
    topBar.BackgroundTransparency = 0.1
    topBar.BorderSizePixel = 0
    topBar.Parent = MainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 8)
    topBarCorner.Parent = topBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title .. " - " .. NebulaX.Version
    titleLabel.TextColor3 = CurrentTheme.Accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = CurrentTheme.Danger
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = CurrentTheme.Secondary
    TabContainer.BackgroundTransparency = 0.1
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local tabContainerCorner = Instance.new("UICorner")
    tabContainerCorner.CornerRadius = UDim.new(0, 8)
    tabContainerCorner.Parent = TabContainer
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = TabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabList
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = tabList
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Tabs table
    Window.Tabs = {}
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button
    closeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    -- Toggle functionality
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == NebulaX.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Window functions
    function Window:AddTab(name, icon)
        icon = icon or "■"
        local Tab = {}
        
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name .. "Tab"
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.BackgroundColor3 = CurrentTheme.Accent
        tabBtn.BackgroundTransparency = 0.7
        tabBtn.Text = "  " .. icon .. "  " .. name
        tabBtn.TextColor3 = CurrentTheme.Text
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = tabBtn
        
        -- Content page
        local contentPage = Instance.new("ScrollingFrame")
        contentPage.Name = name .. "Page"
        contentPage.Size = UDim2.new(1, -20, 1, -20)
        contentPage.Position = UDim2.new(0, 10, 0, 10)
        contentPage.BackgroundTransparency = 1
        contentPage.BorderSizePixel = 0
        contentPage.ScrollBarThickness = 4
        contentPage.ScrollBarImageColor3 = CurrentTheme.Accent
        contentPage.Visible = false
        contentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentPage.Parent = ContentContainer
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = contentPage
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 5)
        pagePadding.PaddingBottom = UDim.new(0, 5)
        pagePadding.PaddingLeft = UDim.new(0, 5)
        pagePadding.PaddingRight = UDim.new(0, 5)
        pagePadding.Parent = contentPage
        
        -- Tab switching
        tabBtn.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Button.BackgroundTransparency = 0.7
                otherTab.Page.Visible = false
            end
            tabBtn.BackgroundTransparency = 0.3
            contentPage.Visible = true
        end)
        
        -- Default open first tab
        if #Window.Tabs == 0 then
            tabBtn.BackgroundTransparency = 0.3
            contentPage.Visible = true
        end
        
        Tab.Button = tabBtn
        Tab.Page = contentPage
        
        -- Section system
        function Tab:AddSection(name)
            local Section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = CurrentTheme.Secondary
            sectionFrame.BackgroundTransparency = 0.2
            sectionFrame.BorderSizePixel = 0
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = contentPage
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = sectionFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -20, 0, 25)
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = CurrentTheme.Accent
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 16
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionFrame
            
            local divider = Instance.new("Frame")
            divider.Name = "Divider"
            divider.Size = UDim2.new(1, -20, 0, 2)
            divider.Position = UDim2.new(0, 10, 0, 30)
            divider.BackgroundColor3 = CurrentTheme.Border
            divider.BorderSizePixel = 0
            divider.Parent = sectionFrame
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Position = UDim2.new(0, 10, 0, 35)
            sectionContent.BackgroundTransparency = 1
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = sectionFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = sectionContent
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingBottom = UDim.new(0, 10)
            sectionPadding.Parent = sectionContent
            
            Section.Frame = sectionFrame
            Section.Content = sectionContent
            
            -- Toggle element
            function Section:AddToggle(text, default, callback)
                callback = callback or function() end
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = text .. "Toggle"
                toggleFrame.Size = UDim2.new(1, 0, 0, 30)
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Parent = sectionContent
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Name = "Button"
                toggleBtn.Size = UDim2.new(0, 50, 0, 20)
                toggleBtn.Position = UDim2.new(1, -60, 0, 5)
                toggleBtn.BackgroundColor3 = CurrentTheme.Border
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Text = ""
                toggleBtn.AutoButtonColor = false
                toggleBtn.Parent = toggleFrame
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(1, 0)
                toggleCorner.Parent = toggleBtn
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "Circle"
                toggleCircle.Size = UDim2.new(0, 16, 0, 16)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                toggleCircle.BackgroundColor3 = CurrentTheme.Text
                toggleCircle.BorderSizePixel = 0
                toggleCircle.Parent = toggleBtn
                
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(1, 0)
                circleCorner.Parent = toggleCircle
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = toggleFrame
                
                local toggled = default or false
                
                local function updateToggle()
                    if toggled then
                        toggleBtn.BackgroundColor3 = CurrentTheme.Accent
                        toggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.2, true)
                    else
                        toggleBtn.BackgroundColor3 = CurrentTheme.Border
                        toggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
                    end
                end
                
                updateToggle()
                
                toggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    callback(toggled)
                end)
                
                return toggleFrame
            end
            
            -- Slider element
            function Section:AddSlider(text, min, max, default, callback)
                callback = callback or function() end
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = text .. "Slider"
                sliderFrame.Size = UDim2.new(1, 0, 0, 45)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(0, 100, 0, 20)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sliderFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.Size = UDim2.new(0, 50, 0, 20)
                valueLabel.Position = UDim2.new(1, -55, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = CurrentTheme.Accent
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sliderFrame
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Size = UDim2.new(1, -20, 0, 4)
                sliderBar.Position = UDim2.new(0, 10, 0, 30)
                sliderBar.BackgroundColor3 = CurrentTheme.Border
                sliderBar.BorderSizePixel = 0
                sliderBar.Parent = sliderFrame
                
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(1, 0)
                barCorner.Parent = sliderBar
                
                local fillBar = Instance.new("Frame")
                fillBar.Name = "Fill"
                fillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                fillBar.BackgroundColor3 = CurrentTheme.Accent
                fillBar.BorderSizePixel = 0
                fillBar.Parent = sliderBar
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fillBar
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "Button"
                sliderButton.Size = UDim2.new(1, 0, 0, 20)
                sliderButton.Position = UDim2.new(0, 0, 0, 25)
                sliderButton.BackgroundTransparency = 1
                sliderButton.Text = ""
                sliderButton.Parent = sliderFrame
                
                local dragging = false
                local value = default
                
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    fillBar.Size = pos
                    value = math.floor(min + (max - min) * pos.X.Scale)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
                
                sliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                sliderButton.MouseButton1Click:Connect(updateSlider)
                
                return sliderFrame
            end
            
            -- Button element
            function Section:AddButton(text, callback)
                callback = callback or function() end
                
                local btn = Instance.new("TextButton")
                btn.Name = text .. "Button"
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = CurrentTheme.Accent
                btn.BackgroundTransparency = 0.3
                btn.Text = text
                btn.TextColor3 = CurrentTheme.Text
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = sectionContent
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(callback)
                
                return btn
            end
            
            -- Dropdown element
            function Section:AddDropdown(text, options, default, callback)
                callback = callback or function() end
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = text .. "Dropdown"
                dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
                dropdownFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, -10, 0, 20)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = dropdownFrame
                
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Name = "Button"
                dropdownBtn.Size = UDim2.new(1, -10, 0, 30)
                dropdownBtn.Position = UDim2.new(0, 5, 0, 25)
                dropdownBtn.BackgroundColor3 = CurrentTheme.Secondary
                dropdownBtn.BorderSizePixel = 0
                dropdownBtn.Text = default or "Select..."
                dropdownBtn.TextColor3 = CurrentTheme.Text
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.TextSize = 14
                dropdownBtn.Parent = dropdownFrame
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = dropdownBtn
                
                local arrow = Instance.new("TextLabel")
                arrow.Name = "Arrow"
                arrow.Size = UDim2.new(0, 20, 1, 0)
                arrow.Position = UDim2.new(1, -25, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.Text = "▼"
                arrow.TextColor3 = CurrentTheme.TextSecondary
                arrow.Font = Enum.Font.Gotham
                arrow.TextSize = 12
                arrow.Parent = dropdownBtn
                
                local dropdownList = Instance.new("ScrollingFrame")
                dropdownList.Name = "List"
                dropdownList.Size = UDim2.new(1, -10, 0, 0)
                dropdownList.Position = UDim2.new(0, 5, 0, 60)
                dropdownList.BackgroundColor3 = CurrentTheme.Secondary
                dropdownList.BorderSizePixel = 0
                dropdownList.Visible = false
                dropdownList.ScrollBarThickness = 4
                dropdownList.ScrollBarImageColor3 = CurrentTheme.Accent
                dropdownList.AutomaticSize = Enum.AutomaticSize.Y
                dropdownList.Parent = dropdownFrame
                
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 4)
                listCorner.Parent = dropdownList
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 2)
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Parent = dropdownList
                
                local listPadding = Instance.new("UIPadding")
                listPadding.PaddingTop = UDim.new(0, 5)
                listPadding.PaddingBottom = UDim.new(0, 5)
                listPadding.PaddingLeft = UDim.new(0, 5)
                listPadding.PaddingRight = UDim.new(0, 5)
                listPadding.Parent = dropdownList
                
                for _, option in ipairs(options) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Name = option .. "Option"
                    optionBtn.Size = UDim2.new(1, 0, 0, 25)
                    optionBtn.BackgroundColor3 = CurrentTheme.Accent
                    optionBtn.BackgroundTransparency = 0.7
                    optionBtn.Text = option
                    optionBtn.TextColor3 = CurrentTheme.Text
                    optionBtn.Font = Enum.Font.Gotham
                    optionBtn.TextSize = 14
                    optionBtn.Parent = dropdownList
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionBtn
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = option
                        dropdownList.Visible = false
                        arrow.Text = "▼"
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
                        callback(option)
                    end)
                end
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    dropdownList.Visible = not dropdownList.Visible
                    arrow.Text = dropdownList.Visible and "▲" or "▼"
                    if dropdownList.Visible then
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 60 + dropdownList.AbsoluteSize.Y + 5)
                    else
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
                    end
                end)
                
                return dropdownFrame
            end
            
            -- Color picker element (simplified)
            function Section:AddColorPicker(text, default, callback)
                callback = callback or function() end
                
                local pickerFrame = Instance.new("Frame")
                pickerFrame.Name = text .. "ColorPicker"
                pickerFrame.Size = UDim2.new(1, 0, 0, 30)
                pickerFrame.BackgroundTransparency = 1
                pickerFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, -50, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = pickerFrame
                
                local colorDisplay = Instance.new("Frame")
                colorDisplay.Name = "Display"
                colorDisplay.Size = UDim2.new(0, 30, 0, 20)
                colorDisplay.Position = UDim2.new(1, -35, 0, 5)
                colorDisplay.BackgroundColor3 = default or CurrentTheme.Accent
                colorDisplay.BorderSizePixel = 0
                colorDisplay.Parent = pickerFrame
                
                local displayCorner = Instance.new("UICorner")
                displayCorner.CornerRadius = UDim.new(0, 4)
                displayCorner.Parent = colorDisplay
                
                return pickerFrame
            end
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    function Window:SetVisible(bool)
        MainFrame.Visible = bool
    end
    
    return Window
end

-- Create main window
local MainWindow = Library:CreateWindow("NebulaX " .. NebulaX.Version)

-- Player Category
local PlayerTab = MainWindow:AddTab("Player", "👤")
local PlayerSection = PlayerTab:AddSection("Player Settings")
PlayerSection:AddSlider("WalkSpeed", 16, 100, 16, function(value)
    LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
PlayerSection:AddSlider("JumpPower", 50, 200, 50, function(value)
    LocalPlayer.Character.Humanoid.JumpPower = value
end)
PlayerSection:AddToggle("Infinite Jump", false, function(state)
    _G.InfiniteJump = state
    if state then
        UserInputService.JumpRequest:Connect(function()
            if _G.InfiniteJump and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)
PlayerSection:AddToggle("Noclip", false, function(state)
    _G.Noclip = state
    if state then
        RunService.Stepped:Connect(function()
            if _G.Noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)
PlayerSection:AddToggle("Anti-Ragdoll", false, function(state)
    _G.AntiRagdoll = state
    -- Implementation would check for ragdoll states
end)
PlayerSection:AddToggle("Auto Sprint", false, function(state)
    _G.AutoSprint = state
    if state then
        RunService.RenderStepped:Connect(function()
            if _G.AutoSprint and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:SetAttribute("Sprinting", true)
            end
        end)
    end
end)
PlayerSection:AddButton("Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

-- ESP / Visuals Category
local ESPTab = MainWindow:AddTab("ESP", "👁️")
local ESPMainSection = ESPTab:AddSection("ESP Settings")
ESPMainSection:AddToggle("Player ESP", false, function(state)
    _G.PlayerESP = state
    -- ESP implementation would go here
end)
ESPMainSection:AddToggle("Name ESP", false, nil)
ESPMainSection:AddToggle("Health ESP", false, nil)
ESPMainSection:AddToggle("Distance ESP", false, nil)
ESPMainSection:AddToggle("Box ESP", false, nil)
ESPMainSection:AddToggle("Tracer Lines", false, nil)
ESPMainSection:AddToggle("Highlight Enemies", false, nil)

-- Combat Category
local CombatTab = MainWindow:AddTab("Combat", "⚔️")
local CombatSection = CombatTab:AddSection("Combat Settings")
CombatSection:AddToggle("Silent Aim", false, nil)
CombatSection:AddToggle("Aim Assist", false, nil)
CombatSection:AddSlider("FOV Circle", 50, 500, 100, function(value)
    _G.FOVSize = value
end)
CombatSection:AddToggle("No Recoil", false, nil)
CombatSection:AddToggle("No Spread", false, nil)
CombatSection:AddToggle("Fast Reload", false, nil)

-- Settings Category
local SettingsTab = MainWindow:AddTab("Settings", "⚙️")
local SettingsSection = SettingsTab:AddSection("UI Settings")

-- Theme changer
SettingsSection:AddDropdown("UI Theme", {"Dark", "Light", "Purple", "Neon"}, "Dark", function(theme)
    NebulaX.Theme = theme
    UpdateTheme(theme)
end)

SettingsSection:AddDropdown("Toggle Keybind", {"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9"}, "F3", function(key)
    NebulaX.ToggleKey = Enum.KeyCode[key]
end)

SettingsSection:AddSlider("UI Size", 0.5, 1.5, 1, function(value)
    MainWindow.Frame.Size = UDim2.new(0, 800 * value, 0, 500 * value)
    MainWindow.Frame.Position = UDim2.new(0.5, -400 * value, 0.5, -250 * value)
end)

SettingsSection:AddButton("Reset Settings", function()
    -- Reset all settings to default
end)

local InfoSection = SettingsTab:AddSection("Script Info")
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 0, 60)
infoText.BackgroundTransparency = 1
infoText.Text = "NebulaX " .. NebulaX.Version .. "\nCreated for South London Remastered\nPress F3 to toggle"
infoText.TextColor3 = CurrentTheme.TextSecondary
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 14
infoText.TextWrapped = true
infoText.Parent = InfoSection.Content

-- Initialize
Notifications:Send("NebulaX Loaded", "Press F3 to open the menu", 3)

return NebulaX
