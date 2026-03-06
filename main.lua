-- NebulaX v0.1 - Universal Roblox Blox Fruits GUI
-- Fixed Version with Working UI & Insert Key Toggle

local NebulaX = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local NebulaXConfig = {
    Theme = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(60, 60, 80),
        Background = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 200, 100)
    },
    ToggleKey = Enum.KeyCode.Insert,
    Visible = true
}

-- Services
local GuiService = game:GetService("GuiService")

-- Custom Loading Screen
local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaX_Loading"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    MainFrame.BackgroundTransparency = 0
    MainFrame.Parent = ScreenGui
    
    -- Gradient Background
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
    })
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 400, 0, 100)
    Logo.Position = UDim2.new(0.5, -200, 0.4, -50)
    Logo.BackgroundTransparency = 1
    Logo.Text = "NEBULAX"
    Logo.TextColor3 = NebulaXConfig.Theme.Primary
    Logo.TextSize = 70
    Logo.Font = Enum.Font.GothamBold
    Logo.TextTransparency = 1
    Logo.Parent = MainFrame
    
    -- Loading Bar Background
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(0, 300, 0, 4)
    BarBg.Position = UDim2.new(0.5, -150, 0.6, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = MainFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 2)
    BarCorner.Parent = BarBg
    
    -- Loading Bar
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = NebulaXConfig.Theme.Primary
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = BarBg
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(0, 2)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Loading Text
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(0, 300, 0, 30)
    LoadingText.Position = UDim2.new(0.5, -150, 0.65, 0)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Initializing NebulaX Framework..."
    LoadingText.TextColor3 = Color3.fromRGB(200, 200, 255)
    LoadingText.TextSize = 16
    LoadingText.Font = Enum.Font.Gotham
    LoadingText.Parent = MainFrame
    
    -- Version
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0, 200, 0, 30)
    Version.Position = UDim2.new(1, -210, 1, -40)
    Version.BackgroundTransparency = 1
    Version.Text = "v0.1 | Blox Fruits"
    Version.TextColor3 = Color3.fromRGB(150, 150, 150)
    Version.TextSize = 14
    Version.Font = Enum.Font.Gotham
    Version.TextXAlignment = Enum.TextXAlignment.Right
    Version.Parent = MainFrame
    
    -- Loading Animation
    local tweenInfo = TweenInfo.new(
        2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(LoadingBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    
    local textTween = TweenService:Create(Logo, tweenInfo, {TextTransparency = 0})
    textTween:Play()
    
    local loadingTexts = {
        "Loading NebulaX Framework...",
        "Initializing Combat Systems...",
        "Loading Fruit Finder...",
        "Setting up Visuals...",
        "Calibrating Movement...",
        "Almost Ready..."
    }
    
    for i = 1, 6 do
        wait(0.5)
        LoadingText.Text = loadingTexts[i]
    end
    
    wait(1)
    
    -- Fade Out
    local fadeTween = TweenService:Create(MainFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
    fadeTween:Play()
    wait(1)
    
    ScreenGui:Destroy()
end

-- Main UI Framework
function NebulaX:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaX_Main"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 700, 0, 550)
    Main.Position = UDim2.new(0.5, -350, 0.5, -275)
    Main.BackgroundColor3 = NebulaXConfig.Theme.Background
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Parent = ScreenGui
    
    -- Make UI Draggable
    local function makeDraggable(frame)
        local dragging = false
        local dragInput
        local dragStart
        local startPos
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    -- Main Gradient
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    MainGradient.Rotation = 90
    MainGradient.Parent = Main
    
    -- Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main
    
    -- Title Bar (Draggable Area)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    makeDraggable(TitleBar)
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    TitleGradient.Parent = TitleBar
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "NEBULAX v0.1"
    TitleText.TextColor3 = NebulaXConfig.Theme.Primary
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    CloseBtn.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
        NebulaXConfig.Visible = false
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -80, 0.5, -15)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    MinBtn.AutoButtonColor = false
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn
    
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 700, 0, 40)}):Play()
            MinBtn.Text = "□"
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 700, 0, 550)}):Play()
            MinBtn.Text = "—"
        end
    end)
    
    -- Category Buttons Container
    local CategoryContainer = Instance.new("Frame")
    CategoryContainer.Size = UDim2.new(1, -20, 0, 45)
    CategoryContainer.Position = UDim2.new(0, 10, 0, 50)
    CategoryContainer.BackgroundTransparency = 1
    CategoryContainer.Parent = Main
    
    -- Content Area
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Size = UDim2.new(1, -20, 1, -150)
    ContentArea.Position = UDim2.new(0, 10, 0, 105)
    ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ContentArea.BackgroundTransparency = 0.3
    ContentArea.BorderSizePixel = 0
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentArea.ScrollBarThickness = 6
    ContentArea.ScrollBarImageColor3 = NebulaXConfig.Theme.Primary
    ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentArea.Parent = Main
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentArea
    
    -- Category Buttons
    local categories = {
        {Name = "Combat", Color = Color3.fromRGB(255, 100, 100)},
        {Name = "Fruits", Color = Color3.fromRGB(255, 200, 100)},
        {Name = "Farming", Color = Color3.fromRGB(100, 255, 100)},
        {Name = "Visuals", Color = Color3.fromRGB(100, 200, 255)},
        {Name = "Movement", Color = Color3.fromRGB(200, 100, 255)},
        {Name = "Misc", Color = Color3.fromRGB(200, 200, 200)}
    }
    
    local buttons = {}
    local currentCategory = nil
    
    for i, cat in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, (i-1) * 110, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BackgroundTransparency = 0.3
        btn.Text = cat.Name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = CategoryContainer
        btn.AutoButtonColor = false
        btn.ClipsDescendants = true
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        -- Indicator
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(1, 0, 0, 2)
        indicator.Position = UDim2.new(0, 0, 1, -2)
        indicator.BackgroundColor3 = cat.Color
        indicator.BackgroundTransparency = 1
        indicator.Parent = btn
        
        -- Hover Animation
        btn.MouseEnter:Connect(function()
            if currentCategory ~= btn then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if currentCategory ~= btn then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
                TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            if currentCategory then
                TweenService:Create(currentCategory, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
                local oldIndicator = currentCategory:FindFirstChildOfClass("Frame")
                if oldIndicator then
                    TweenService:Create(oldIndicator, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end
            end
            
            TweenService:Create(btn, TweenInfo.new(0.3), {
                BackgroundColor3 = cat.Color,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            
            currentCategory = btn
            NebulaX:LoadCategory(cat.Name, ContentArea, cat.Color)
        end)
        
        buttons[cat.Name] = btn
    end
    
    -- Player Stats Tracker
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -20, 0, 70)
    StatsFrame.Position = UDim2.new(0, 10, 1, -80)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    StatsFrame.BackgroundTransparency = 0.3
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = Main
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 6)
    StatsCorner.Parent = StatsFrame
    
    -- Stats Grid
    local statsGrid = Instance.new("UIGridLayout")
    statsGrid.FillDirection = Enum.FillDirection.Horizontal
    statsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    statsGrid.VerticalAlignment = Enum.VerticalAlignment.Center
    statsGrid.CellSize = UDim2.new(0.33, -10, 1, -10)
    statsGrid.CellPadding = UDim2.new(0, 5, 0, 0)
    statsGrid.Parent = StatsFrame
    
    -- Level Display
    local LevelContainer = Instance.new("Frame")
    LevelContainer.BackgroundTransparency = 1
    LevelContainer.Parent = StatsFrame
    
    local LevelIcon = Instance.new("TextLabel")
    LevelIcon.Size = UDim2.new(0, 30, 1, 0)
    LevelIcon.BackgroundTransparency = 1
    LevelIcon.Text = "📊"
    LevelIcon.TextColor3 = NebulaXConfig.Theme.Primary
    LevelIcon.TextSize = 20
    LevelIcon.Font = Enum.Font.Gotham
    LevelIcon.Parent = LevelContainer
    
    local LevelText = Instance.new("TextLabel")
    LevelText.Size = UDim2.new(1, -35, 1, 0)
    LevelText.Position = UDim2.new(0, 35, 0, 0)
    LevelText.BackgroundTransparency = 1
    LevelText.Text = "Level: 1"
    LevelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LevelText.TextSize = 14
    LevelText.Font = Enum.Font.GothamBold
    LevelText.TextXAlignment = Enum.TextXAlignment.Left
    LevelText.Parent = LevelContainer
    
    -- Stats Display
    local StatsContainer = Instance.new("Frame")
    StatsContainer.BackgroundTransparency = 1
    StatsContainer.Parent = StatsFrame
    
    local StatsIcon = Instance.new("TextLabel")
    StatsIcon.Size = UDim2.new(0, 30, 1, 0)
    StatsIcon.BackgroundTransparency = 1
    StatsIcon.Text = "⚔️"
    StatsIcon.TextColor3 = NebulaXConfig.Theme.Accent
    StatsIcon.TextSize = 20
    StatsIcon.Font = Enum.Font.Gotham
    StatsIcon.Parent = StatsContainer
    
    local StatsText = Instance.new("TextLabel")
    StatsText.Size = UDim2.new(1, -35, 1, 0)
    StatsText.Position = UDim2.new(0, 35, 0, 0)
    StatsText.BackgroundTransparency = 1
    StatsText.Text = "Melee: 0 | Defense: 0"
    StatsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatsText.TextSize = 14
    StatsText.Font = Enum.Font.Gotham
    StatsText.TextXAlignment = Enum.TextXAlignment.Left
    StatsText.Parent = StatsContainer
    
    -- Fruit Display
    local FruitContainer = Instance.new("Frame")
    FruitContainer.BackgroundTransparency = 1
    FruitContainer.Parent = StatsFrame
    
    local FruitIcon = Instance.new("TextLabel")
    FruitIcon.Size = UDim2.new(0, 30, 1, 0)
    FruitIcon.BackgroundTransparency = 1
    FruitIcon.Text = "🍎"
    FruitIcon.TextColor3 = Color3.fromRGB(255, 200, 100)
    FruitIcon.TextSize = 20
    FruitIcon.Font = Enum.Font.Gotham
    FruitIcon.Parent = FruitContainer
    
    local FruitText = Instance.new("TextLabel")
    FruitText.Size = UDim2.new(1, -35, 1, 0)
    FruitText.Position = UDim2.new(0, 35, 0, 0)
    FruitText.BackgroundTransparency = 1
    FruitText.Text = "Fruit: None"
    FruitText.TextColor3 = Color3.fromRGB(255, 200, 100)
    FruitText.TextSize = 14
    FruitText.Font = Enum.Font.Gotham
    FruitText.TextXAlignment = Enum.TextXAlignment.Left
    FruitText.Parent = FruitContainer
    
    -- Update Stats
    spawn(function()
        while ScreenGui and ScreenGui.Parent do
            pcall(function()
                local level = LocalPlayer.Data.Level.Value
                LevelText.Text = "Level: " .. level
                
                local stats = LocalPlayer.Stats
                StatsText.Text = string.format("Melee: %d | Defense: %d", 
                    stats.Melee.Level.Value, stats.Defense.Level.Value)
                
                local fruit = LocalPlayer.Data.Fruit.Value
                FruitText.Text = "Fruit: " .. (fruit ~= "" and fruit or "None")
            end)
            wait(1)
        end
    end)
    
    return ScreenGui
end

-- Load Category Content
function NebulaX:LoadCategory(category, container, accentColor)
    for _, v in ipairs(container:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") then
            v:Destroy()
        end
    end
    
    -- Create UI Elements Layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = container
    
    local function CreateToggle(name, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        frame.BackgroundTransparency = 0.2
        frame.Parent = container
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 60, 0, 30)
        toggle.Position = UDim2.new(1, -75, 0.5, -15)
        toggle.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 14
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = frame
        toggle.AutoButtonColor = false
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 15)
        toggleCorner.Parent = toggle
        
        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggle.BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
            toggle.Text = enabled and "ON" or "OFF"
            if callback then
                pcall(function() callback(enabled) end)
            end
        end)
        
        -- Hover effect
        toggle.MouseEnter:Connect(function()
            TweenService:Create(toggle, TweenInfo.new(0.2), {Size = UDim2.new(0, 65, 0, 32)}):Play()
        end)
        
        toggle.MouseLeave:Connect(function()
            TweenService:Create(toggle, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 30)}):Play()
        end)
    end
    
    local function CreateButton(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.BackgroundColor3 = accentColor or NebulaXConfig.Theme.Secondary
        btn.BackgroundTransparency = 0.2
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        btn.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if callback then
                pcall(function() callback() end)
            end
        end)
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = (accentColor or NebulaXConfig.Theme.Secondary):Lerp(Color3.fromRGB(255, 255, 255), 0.2),
                Size = UDim2.new(1, -15, 0, 42)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = accentColor or NebulaXConfig.Theme.Secondary,
                Size = UDim2.new(1, -20, 0, 40)
            }):Play()
        end)
    end
    
    local function CreateSlider(name, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 60)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        frame.BackgroundTransparency = 0.2
        frame.Parent = container
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. default
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -40, 0, 4)
        sliderBg.Position = UDim2.new(0, 20, 0, 35)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = frame
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 2)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = accentColor or NebulaXConfig.Theme.Primary
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 2)
        sliderFillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 20, 0, 20)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, -8)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.Parent = sliderBg
        sliderButton.AutoButtonColor = false
        
        local sliderButtonCorner = Instance.new("UICorner")
        sliderButtonCorner.CornerRadius = UDim.new(1, 0)
        sliderButtonCorner.Parent = sliderButton
        
        -- Slider functionality
        local dragging = false
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
                local pos = UIS:GetMouseLocation().X
                local sliderPos = sliderBg.AbsolutePosition.X
                local size = sliderBg.AbsoluteSize.X
                local percent = math.clamp((pos - sliderPos) / size, 0, 1)
                local value = min + (max - min) * percent
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderButton.Position = UDim2.new(percent, -10, 0, -8)
                label.Text = name .. ": " .. math.floor(value)
                
                if callback then
                    pcall(function() callback(math.floor(value)) end)
                end
            end
        end)
    end
    
    if category == "Combat" then
        CreateToggle("Auto Farm (Enemies)", false, function(state) NebulaX.AutoFarm = state end)
        CreateToggle("Auto Boss", false, function(state) NebulaX.AutoBoss = state end)
        CreateToggle("Auto Haki", true, function(state) NebulaX.AutoHaki = state end)
        CreateToggle("Auto Stats", true, function(state) NebulaX.AutoStats = state end)
        CreateSlider("Fast Attack Speed", 1, 20, 10, function(value) NebulaX.FastAttackSpeed = value end)
        CreateToggle("Kill Aura", false, function(state) NebulaX.KillAura = state end)
        CreateToggle("Auto Skill (Z X C V)", false, function(state) NebulaX.AutoSkill = state end)
        CreateButton("Quest Progress", function() NebulaX:ShowQuestProgress() end)
    elseif category == "Fruits" then
        CreateToggle("Auto Find Fruit", false, function(state) NebulaX.AutoFindFruit = state end)
        CreateToggle("Fruit Sniper", false, function(state) NebulaX.FruitSniper = state end)
        CreateToggle("Fruit ESP", true, function(state) NebulaX.FruitESP = state end)
        CreateToggle("Auto Store Fruit", true, function(state) NebulaX.AutoStoreFruit = state end)
        CreateToggle("Fruit Notifier", true, function(state) NebulaX.FruitNotifier = state end)
        CreateButton("Fruit List", function() NebulaX:ShowFruitList() end)
        CreateButton("Teleport to Fruit", function() NebulaX:TeleportToFruit() end)
    elseif category == "Farming" then
        CreateToggle("Auto Level", false, function(state) NebulaX.AutoLevel = state end)
        CreateToggle("Auto Quest", true, function(state) NebulaX.AutoQuest = state end)
        CreateToggle("Auto Farm Chest", false, function(state) NebulaX.AutoFarmChest = state end)
        CreateToggle
