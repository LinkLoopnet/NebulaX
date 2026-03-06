-- NebulaX v0.1 - Universal Roblox Arsenal GUI
-- Professional Framework with Draggable UI

local NebulaX = {}
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local guiService = game:GetService("GuiService")

-- Settings storage
NebulaX.Settings = {
    Aimbot = {
        Enabled = false,
        LockOn = true,
        AimAssist = false,
        SilentAim = false,
        TriggerBot = false,
        AutoShoot = false,
        HeadshotMode = true,
        RecoilControl = true,
        Smoothness = 0.5,
        FOV = 120
    },
    ESP = {
        Enabled = false,
        Boxes = false,
        Health = false,
        Names = false,
        Distance = false,
        Weapon = false,
        Tracers = false,
        Color = Color3.fromRGB(255, 255, 255)
    },
    Movement = {
        SpeedBoost = false,
        SpeedAmount = 32,
        FlyMode = false,
        InfiniteJump = false,
        NoFallDamage = false,
        SlideBoost = false
    },
    Weapon = {
        NoRecoil = false,
        RapidFire = false,
        InfiniteAmmo = false,
        InstantReload = false,
        SpreadReduction = false
    },
    Visuals = {
        Theme = "Dark",
        AccentColor = Color3.fromRGB(0, 170, 255),
        Transparency = 0.1,
        ShowWatermark = true
    }
}

-- Main GUI Creation
function NebulaX:CreateMainGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NebulaXFramework"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (Draggable)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Top Bar (for dragging)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 8)
    topBarCorner.Parent = topBar
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    gradient.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NebulaX v0.1 | Universal Arsenal"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = topBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    -- Minimize Button
    local minButton = Instance.new("TextButton")
    minButton.Name = "MinimizeButton"
    minButton.Size = UDim2.new(0, 30, 0, 30)
    minButton.Position = UDim2.new(1, -70, 0, 5)
    minButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    minButton.Text = "−"
    minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minButton.Font = Enum.Font.GothamBold
    minButton.TextSize = 25
    minButton.Parent = topBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = minButton
    
    -- Tab Selection Frame
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 50)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -110)
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = contentFrame
    
    -- Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, -20, 0, 30)
    statusBar.Position = UDim2.new(0, 10, 1, -40)
    statusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusBar
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Ready | Press INSERT to toggle"
    statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Gotham
    statusText.TextSize = 12
    statusText.Parent = statusBar
    
    -- Make UI Draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
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
    
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Close/Minimize Functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local minimized = false
    local originalSize = mainFrame.Size
    minButton.MouseButton1Click:Connect(function()
        if minimized then
            mainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            minButton.Text = "−"
        else
            mainFrame:TweenSize(UDim2.new(0, 700, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            minButton.Text = "+"
        end
        minimized = not minimized
    end)
    
    return mainFrame, contentFrame, tabFrame
end

-- Create Tabs
function NebulaX:CreateTabs(tabFrame, contentFrame)
    local tabs = {"Combat", "ESP", "Movement", "Weapon", "Settings"}
    local colors = {
        Combat = Color3.fromRGB(255, 70, 70),
        ESP = Color3.fromRGB(70, 255, 70),
        Movement = Color3.fromRGB(70, 70, 255),
        Weapon = Color3.fromRGB(255, 255, 70),
        Settings = Color3.fromRGB(255, 170, 70)
    }
    
    local activeTab = "Combat"
    local tabButtons = {}
    
    -- Create tab buttons
    for i, tabName in ipairs(tabs) do
        local button = Instance.new("TextButton")
        button.Name = tabName .. "Tab"
        button.Size = UDim2.new(0, 140, 1, -10)
        button.Position = UDim2.new(0, (i-1) * 140 + 5, 0, 5)
        button.BackgroundColor3 = colors[tabName]
        button.BackgroundTransparency = 0.8
        button.Text = tabName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Parent = tabFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            if activeTab ~= tabName then
                button.BackgroundTransparency = 0.6
            end
        end)
        
        button.MouseLeave:Connect(function()
            if activeTab ~= tabName then
                button.BackgroundTransparency = 0.8
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            activeTab = tabName
            for _, btn in pairs(tabButtons) do
                btn.BackgroundTransparency = 0.8
                btn.TextTransparency = 0.3
            end
            button.BackgroundTransparency = 0.3
            button.TextTransparency = 0
            
            -- Clear content frame
            for _, child in pairs(contentFrame:GetChildren()) do
                child:Destroy()
            end
            
            -- Create new content based on tab
            NebulaX:CreateTabContent(tabName, contentFrame)
        end)
        
        tabButtons[tabName] = button
        
        -- Set initial active tab
        if i == 1 then
            button.BackgroundTransparency = 0.3
            button.TextTransparency = 0
        end
    end
    
    -- Create initial content
    NebulaX:CreateTabContent("Combat", contentFrame)
end

-- Create Tab Content
function NebulaX:CreateTabContent(tabName, contentFrame)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = contentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = contentFrame
    
    if tabName == "Combat" then
        NebulaX:CreateSection(contentFrame, "Aimbot Settings", {
            {Type = "Toggle", Name = "Aimbot", Setting = "Enabled", Category = "Aimbot"},
            {Type = "Toggle", Name = "Lock On", Setting = "LockOn", Category = "Aimbot"},
            {Type = "Toggle", Name = "Aim Assist", Setting = "AimAssist", Category = "Aimbot"},
            {Type = "Toggle", Name = "Silent Aim", Setting = "SilentAim", Category = "Aimbot"},
            {Type = "Toggle", Name = "Trigger Bot", Setting = "TriggerBot", Category = "Aimbot"},
            {Type = "Toggle", Name = "Auto Shoot", Setting = "AutoShoot", Category = "Aimbot"},
            {Type = "Toggle", Name = "Headshot Mode", Setting = "HeadshotMode", Category = "Aimbot"},
            {Type = "Toggle", Name = "Recoil Control", Setting = "RecoilControl", Category = "Aimbot"},
            {Type = "Slider", Name = "Smoothness", Setting = "Smoothness", Category = "Aimbot", Min = 0, Max = 1, Default = 0.5},
            {Type = "Slider", Name = "FOV", Setting = "FOV", Category = "Aimbot", Min = 30, Max = 360, Default = 120}
        })
        
    elseif tabName == "ESP" then
        NebulaX:CreateSection(contentFrame, "ESP Settings", {
            {Type = "Toggle", Name = "Enable ESP", Setting = "Enabled", Category = "ESP"},
            {Type = "Toggle", Name = "Box ESP", Setting = "Boxes", Category = "ESP"},
            {Type = "Toggle", Name = "Health Bars", Setting = "Health", Category = "ESP"},
            {Type = "Toggle", Name = "Name Tags", Setting = "Names", Category = "ESP"},
            {Type = "Toggle", Name = "Distance", Setting = "Distance", Category = "ESP"},
            {Type = "Toggle", Name = "Weapon Info", Setting = "Weapon", Category = "ESP"},
            {Type = "Toggle", Name = "Tracers", Setting = "Tracers", Category = "ESP"},
            {Type = "Color", Name = "ESP Color", Setting = "Color", Category = "ESP", Default = Color3.fromRGB(255, 255, 255)}
        })
        
    elseif tabName == "Movement" then
        NebulaX:CreateSection(contentFrame, "Movement Options", {
            {Type = "Toggle", Name = "Speed Boost", Setting = "SpeedBoost", Category = "Movement"},
            {Type = "Slider", Name = "Speed Amount", Setting = "SpeedAmount", Category = "Movement", Min = 16, Max = 200, Default = 32},
            {Type = "Toggle", Name = "Fly Mode", Setting = "FlyMode", Category = "Movement"},
            {Type = "Toggle", Name = "Infinite Jump", Setting = "InfiniteJump", Category = "Movement"},
            {Type = "Toggle", Name = "No Fall Damage", Setting = "NoFallDamage", Category = "Movement"},
            {Type = "Toggle", Name = "Slide Boost", Setting = "SlideBoost", Category = "Movement"}
        })
        
    elseif tabName == "Weapon" then
        NebulaX:CreateSection(contentFrame, "Weapon Modifications", {
            {Type = "Toggle", Name = "No Recoil", Setting = "NoRecoil", Category = "Weapon"},
            {Type = "Toggle", Name = "Rapid Fire", Setting = "RapidFire", Category = "Weapon"},
            {Type = "Toggle", Name = "Infinite Ammo", Setting = "InfiniteAmmo", Category = "Weapon"},
            {Type = "Toggle", Name = "Instant Reload", Setting = "InstantReload", Category = "Weapon"},
            {Type = "Toggle", Name = "Spread Reduction", Setting = "SpreadReduction", Category = "Weapon"}
        })
        
    elseif tabName == "Settings" then
        NebulaX:CreateSection(contentFrame, "UI Settings", {
            {Type = "Dropdown", Name = "Theme", Setting = "Theme", Category = "Visuals", Options = {"Dark", "Light", "Midnight", "Blood"}},
            {Type = "Color", Name = "Accent Color", Setting = "AccentColor", Category = "Visuals", Default = Color3.fromRGB(0, 170, 255)},
            {Type = "Slider", Name = "Transparency", Setting = "Transparency", Category = "Visuals", Min = 0, Max = 0.9, Default = 0.1},
            {Type = "Toggle", Name = "Show Watermark", Setting = "ShowWatermark", Category = "Visuals"}
        })
        
        -- Save/Load buttons
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, -20, 0, 40)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = contentFrame
        
        local saveButton = NebulaX:CreateButton("Save Settings", function()
            NebulaX:SaveSettings()
        end)
        saveButton.Parent = buttonFrame
        
        local loadButton = NebulaX:CreateButton("Load Settings", function()
            NebulaX:LoadSettings()
        end)
        loadButton.Position = UDim2.new(0.5, 5, 0, 0)
        loadButton.Parent = buttonFrame
    end
end

-- Create Section
function NebulaX:CreateSection(parent, title, items)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, #items * 35 + 40)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, 30)
    line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    line.BorderSizePixel = 0
    line.Parent = section
    
    local yOffset = 35
    for _, item in ipairs(items) do
        if item.Type == "Toggle" then
            NebulaX:CreateToggle(section, item, yOffset)
        elseif item.Type == "Slider" then
            NebulaX:CreateSlider(section, item, yOffset)
        elseif item.Type == "Color" then
            NebulaX:CreateColorPicker(section, item, yOffset)
        elseif item.Type == "Dropdown" then
            NebulaX:CreateDropdown(section, item, yOffset)
        end
        yOffset = yOffset + 35
    end
end

-- Create Toggle
function NebulaX:CreateToggle(parent, item, yOffset)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 24)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBg.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Parent = toggleBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleBg
    
    -- Set initial state
    local setting = NebulaX.Settings[item.Category][item.Setting]
    if setting then
        toggleBg.BackgroundColor3 = NebulaX.Settings.Visuals.AccentColor
        toggleCircle.Position = UDim2.new(0, 28, 0.5, -10)
    else
        toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    end
    
    button.MouseButton1Click:Connect(function()
        NebulaX.Settings[item.Category][item.Setting] = not NebulaX.Settings[item.Category][item.Setting]
        if NebulaX.Settings[item.Category][item.Setting] then
            toggleBg.BackgroundColor3 = NebulaX.Settings.Visuals.AccentColor
            toggleCircle:TweenPosition(UDim2.new(0, 28, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end
    end)
end

-- Create Slider
function NebulaX:CreateSlider(parent, item, yOffset)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 1, 0)
    valueLabel.Position = UDim2.new(1, -120, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(NebulaX.Settings[item.Category][item.Setting])
    valueLabel.TextColor3 = NebulaX.Settings.Visuals.AccentColor
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 100, 0, 4)
    sliderBg.Position = UDim2.new(1, -110, 0.5, -2)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((NebulaX.Settings[item.Category][item.Setting] - item.Min) / (item.Max - item.Min), 1, 1, 0)
    sliderFill.BackgroundColor3 = NebulaX.Settings.Visuals.AccentColor
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 20, 1, 10)
    sliderButton.Position = UDim2.new(0, -10, 0, -5)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderFill
    
    -- Slider functionality
    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local relX = math.clamp(mousePos.X - absPos.X, 0, sliderBg.AbsoluteSize.X)
            local value = item.Min + (relX / sliderBg.AbsoluteSize.X) * (item.Max - item.Min)
            value = math.floor(value * 100) / 100
            
            NebulaX.Settings[item.Category][item.Setting] = value
            sliderFill.Size = UDim2.new(relX / sliderBg.AbsoluteSize.X, 0, 1, 0)
            valueLabel.Text = tostring(value)
        end
    end)
end

-- Create Color Picker
function NebulaX:CreateColorPicker(parent, item, yOffset)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 50, 0, 20)
    colorDisplay.Position = UDim2.new(1, -60, 0.5, -10)
    colorDisplay.BackgroundColor3 = NebulaX.Settings[item.Category][item.Setting]
    colorDisplay.Parent = frame
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 4)
    displayCorner.Parent = colorDisplay
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = colorDisplay
    
    -- Simple color picker dialog
    button.MouseButton1Click:Connect(function()
        local colors = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 128, 0)
        }
        
        -- Cycle through colors for simplicity
        local current = NebulaX.Settings[item.Category][item.Setting]
        local index = table.find(colors, current) or 1
        index = (index % #colors) + 1
        NebulaX.Settings[item.Category][item.Setting] = colors[index]
        colorDisplay.BackgroundColor3 = colors[index]
        
        if item.Category == "Visuals" and item.Setting == "AccentColor" then
            NebulaX:UpdateAccentColor(colors[index])
        end
    end)
end

-- Create Dropdown
function NebulaX:CreateDropdown(parent, item, yOffset)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 100, 0, 24)
    dropdown.Position = UDim2.new(1, -110, 0.5, -12)
    dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdown.Text = NebulaX.Settings[item.Category][item.Setting]
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    dropdown.Parent = frame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdown
    
    dropdown.MouseButton1Click:Connect(function()
        -- Cycle through options
        local options = item.Options
        local current = NebulaX.Settings[item.Category][item.Setting]
        local index = table.find(options, current) or 1
        index = (index % #options) + 1
        NebulaX.Settings[item.Category][item.Setting] = options[index]
        dropdown.Text = options[index]
        
        if item.Category == "Visuals" and item.Setting == "Theme" then
            NebulaX:ApplyTheme(options[index])
        end
    end)
end

-- Create Button
function NebulaX:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -5, 0, 30)
    button.BackgroundColor3 = NebulaX.Settings.Visuals.AccentColor
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Helper Functions
function NebulaX:UpdateAccentColor(color)
    -- Update all accent colors in UI
    NebulaX.Settings.Visuals.AccentColor = color
    -- Update toggle states, sliders, etc.
end

function NebulaX:ApplyTheme(theme)
    local themes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 20),
            Secondary = Color3.fromRGB(30, 30, 30),
            Tertiary = Color3.fromRGB(35, 35, 35),
            Text = Color3.fromRGB(255, 255, 255)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(220, 220, 220),
            Tertiary = Color3.fromRGB(200, 200, 200),
            Text = Color3.fromRGB(0, 0, 0)
        },
        Midnight = {
            Background = Color3.fromRGB(10, 10, 30),
            Secondary = Color3.fromRGB(20, 20, 50),
            Tertiary = Color3.fromRGB(30, 30, 70),
            Text = Color3.fromRGB(200, 200, 255)
        },
        Blood = {
            Background = Color3.fromRGB(30, 10, 10),
            Secondary = Color3.fromRGB(50, 20, 20),
            Tertiary = Color3.fromRGB(70, 30, 30),
            Text = Color3.fromRGB(255, 200, 200)
        }
    }
    
    local selected = themes[theme]
    if selected then
        -- Apply theme colors to UI elements
        -- This would require storing references to all UI elements
    end
end

function NebulaX:SaveSettings()
    local success, err = pcall(function()
        writefile("NebulaX_Settings.json", game:GetService("HttpService"):JSONEncode(NebulaX.Settings))
    end)
    
    if success then
        print("Settings saved successfully!")
    end
end

function NebulaX:LoadSettings()
    local success, data = pcall(function()
        return readfile("NebulaX_Settings.json")
    end)
    
    if success then
        local decoded = game:GetService("HttpService"):JSONDecode(data)
        for category, settings in pairs(decoded) do
            if NebulaX.Settings[category] then
                for key, value in pairs(settings) do
                    NebulaX.Settings[category][key] = value
                end
            end
        end
        print("Settings loaded successfully!")
        -- Refresh UI
    end
end

-- Feature Implementations
function NebulaX:InitializeFeatures()
    -- Aimbot
    runService.RenderStepped:Connect(function()
        if NebulaX.Settings.Aimbot.Enabled then
            -- Aimbot logic here
            local target = NebulaX:GetClosestPlayerToCursor()
            if target then
                if NebulaX.Settings.Aimbot.LockOn then
                    NebulaX:LockOnTarget(target)
                end
                if NebulaX.Settings.Aimbot.TriggerBot then
                    NebulaX:TriggerBot(target)
                end
            end
        end
    end)
    
    -- ESP
    if NebulaX.Settings.ESP.Enabled then
        NebulaX:InitializeESP()
    end
    
    -- Movement
    if NebulaX.Settings.Movement.SpeedBoost then
        NebulaX:SpeedBoost()
    end
    
    if NebulaX.Settings.Movement.FlyMode then
        NebulaX:FlyMode()
    end
    
    -- Weapon Mods
    if NebulaX.Settings.Weapon.NoRecoil then
        NebulaX:NoRecoil()
    end
    
    if NebulaX.Settings.Weapon.RapidFire then
        NebulaX:RapidFire()
    end
end

function NebulaX:GetClosestPlayerToCursor()
    -- Implementation for finding closest player to cursor
    local closest = nil
    local shortest = math.huge
    
    for _, otherPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(otherPlayer.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if distance < shortest and distance < NebulaX.Settings.Aimbot.FOV then
                    shortest = distance
                    closest = otherPlayer
                end
            end
        end
    end
    
    return closest
end

function NebulaX:LockOnTarget(target)
    -- Implementation for locking onto target
    if target and target.Character and target.Character:FindFirstChild("Head") then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
    end
end

function NebulaX:TriggerBot(target)
    -- Implementation for trigger bot
    if target and target.Character then
        -- Check if crosshair is on target and shoot
    end
end

function NebulaX:InitializeESP()
    -- Create ESP for all players
    for _, otherPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player then
            NebulaX:CreateESPForPlayer(otherPlayer)
        end
    end
    
    game:GetService("Players").PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            NebulaX:CreateESPForPlayer(newPlayer)
        end
    end)
end

function NebulaX:CreateESPForPlayer(targetPlayer)
    -- Implementation for creating ESP for a player
    -- This would create BillboardGuis or Drawing objects
end

function NebulaX:SpeedBoost()
    -- Implementation for speed boost
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if NebulaX.Settings.Movement.SpeedBoost then
            humanoid.WalkSpeed = NebulaX.Settings.Movement.SpeedAmount
        else
            humanoid.WalkSpeed = 16
        end
    end)
end

function NebulaX:FlyMode()
    -- Implementation for fly mode
    local flying = false
    local bodyVelocity = nil
    
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and NebulaX.Settings.Movement.FlyMode then
            if input.KeyCode == Enum.KeyCode.Space then
                flying = not flying
                
                if flying then
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                    
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                    bodyVelocity.Parent = humanoidRootPart
                else
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end
        end
    end)
end

function NebulaX:NoRecoil()
    -- Implementation for no recoil
    -- Hook into weapon firing events
end

function NebulaX:RapidFire()
    -- Implementation for rapid fire
    -- Modify weapon fire rate
end

-- Initialize
function NebulaX:Init()
    -- Create main GUI
    local mainFrame, contentFrame, tabFrame = self:CreateMainGUI()
    
    -- Create tabs
    self:CreateTabs(tabFrame, contentFrame)
    
    -- Initialize features
    self:InitializeFeatures()
    
    -- Toggle GUI with Insert key
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    -- Watermark
    if NebulaX.Settings.Visuals.ShowWatermark then
        local watermark = Instance.new("TextLabel")
        watermark.Name = "Watermark"
        watermark.Size = UDim2.new(0, 200, 0, 30)
        watermark.Position = UDim2.new(0, 10, 1, -40)
        watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        watermark.BackgroundTransparency = 0.3
        watermark.Text = "NebulaX v0.1 | Loaded"
        watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
        watermark.Font = Enum.Font.GothamBold
        watermark.TextSize = 14
        watermark.Parent = player:WaitForChild("PlayerGui")
        
        local watermarkCorner = Instance.new("UICorner")
        watermarkCorner.CornerRadius = UDim.new(0, 6)
        watermarkCorner.Parent = watermark
    end
    
    print("NebulaX v0.1 Loaded Successfully!")
end

-- Start NebulaX
NebulaX:Init()

return NebulaX
