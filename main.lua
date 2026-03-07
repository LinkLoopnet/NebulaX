-- NebulaX v0.1 - Universal Roblox Jailbreak GUI
-- Premium Edition - £100 Million UI/UX Design

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variables
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local guiEnabled = false
local currentToggles = {}
local connections = {}

-- Create Main GUI Holder
local NebulaX = Instance.new("ScreenGui")
NebulaX.Name = "NebulaX"
NebulaX.DisplayOrder = 999
NebulaX.ResetOnSpawn = false
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NebulaX.Parent = CoreGui

-- Premium Shadow Effect
local ShadowHolder = Instance.new("Frame")
ShadowHolder.Name = "ShadowHolder"
ShadowHolder.Size = UDim2.new(0, 500, 0, 600)
ShadowHolder.Position = UDim2.new(0.5, -250, 0.5, -300)
ShadowHolder.BackgroundTransparency = 1
ShadowHolder.Parent = NebulaX

-- Create multiple shadow layers for depth
local shadows = {}
for i = 1, 5 do
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"..i
    shadow.Size = UDim2.new(1, 20 + (i*2), 1, 20 + (i*2))
    shadow.Position = UDim2.new(0.5, -(10 + i), 0.5, -(10 + i))
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.9 - (i * 0.15)
    shadow.BorderSizePixel = 0
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.ZIndex = -i
    shadow.Parent = ShadowHolder
    shadows[i] = shadow
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

-- Add gradient background
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 15, 25))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Premium border glow
local BorderGlow = Instance.new("Frame")
BorderGlow.Name = "BorderGlow"
BorderGlow.Size = UDim2.new(1, 4, 1, 4)
BorderGlow.Position = UDim2.new(0, -2, 0, -2)
BorderGlow.BackgroundTransparency = 1
BorderGlow.ZIndex = 1

local BorderGlowGradient = Instance.new("UIGradient")
BorderGlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
BorderGlowGradient.Rotation = 90
BorderGlowGradient.Parent = BorderGlow

local BorderGlowStroke = Instance.new("UIStroke")
BorderGlowStroke.Thickness = 2
BorderGlowStroke.Color = Color3.fromRGB(255, 255, 255)
BorderGlowStroke.Transparency = 0.5
BorderGlowStroke.Parent = BorderGlow

BorderGlow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(5, 7, 12)
TitleBar.BorderSizePixel = 0

-- Title Bar Gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 15, 25))
})
TitleGradient.Parent = TitleBar

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0.5, -15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://139139139" -- Replace with actual logo
Logo.ImageColor3 = Color3.fromRGB(0, 255, 255)
Logo.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 45, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "NEBULA X"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Add text stroke
local TitleStroke = Instance.new("UIStroke")
TitleStroke.Thickness = 1
TitleStroke.Color = Color3.fromRGB(0, 200, 255)
TitleStroke.Transparency = 0.5
TitleStroke.Parent = TitleText

-- Version Tag
local VersionTag = Instance.new("TextLabel")
VersionTag.Name = "VersionTag"
VersionTag.Size = UDim2.new(0, 40, 0, 20)
VersionTag.Position = UDim2.new(0, 210, 0.5, -10)
VersionTag.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
VersionTag.BackgroundTransparency = 0.7
VersionTag.Text = "v0.1"
VersionTag.Font = Enum.Font.Gotham
VersionTag.TextSize = 12
VersionTag.TextColor3 = Color3.fromRGB(200, 230, 255)
VersionTag.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.AutoButtonColor = false

-- Close Button Hover
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    toggleGUI()
end)

CloseButton.Parent = TitleBar

-- Category Buttons Frame
local CategoryFrame = Instance.new("Frame")
CategoryFrame.Name = "CategoryFrame"
CategoryFrame.Size = UDim2.new(1, 0, 0, 50)
CategoryFrame.Position = UDim2.new(0, 0, 0, 40)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
CategoryFrame.BorderSizePixel = 0

local CategoryList = Instance.new("UIListLayout")
CategoryList.FillDirection = Enum.FillDirection.Horizontal
CategoryList.HorizontalAlignment = Enum.HorizontalAlignment.Center
CategoryList.VerticalAlignment = Enum.VerticalAlignment.Center
CategoryList.Padding = UDim.new(0, 5)
CategoryList.Parent = CategoryFrame

-- Categories
local categories = {
    {name = "CHARACTER", icon = "👤"},
    {name = "AUTO FARM", icon = "⚡"},
    {name = "VEHICLE", icon = "🚗"},
    {name = "TELEPORTS", icon = "🌍"},
    {name = "COMBAT", icon = "⚔️"},
    {name = "ESP", icon = "👁️"}
}

local categoryButtons = {}
local currentCategory = "CHARACTER"

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 8)
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = ContentFrame

-- Function to create toggle button
local function createToggle(name, icon, category, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name.."Toggle"
    toggleFrame.Size = UDim2.new(1, -10, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = ContentFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = toggleFrame
    
    -- Inner glow
    local InnerGlow = Instance.new("Frame")
    InnerGlow.Size = UDim2.new(1, -2, 1, -2)
    InnerGlow.Position = UDim2.new(0, 1, 0, 1)
    InnerGlow.BackgroundTransparency = 1
    InnerGlow.BorderSizePixel = 0
    
    local GlowStroke = Instance.new("UIStroke")
    GlowStroke.Thickness = 1
    GlowStroke.Color = Color3.fromRGB(0, 200, 255)
    GlowStroke.Transparency = 0.8
    GlowStroke.Parent = InnerGlow
    InnerGlow.Parent = toggleFrame
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 40, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.Font = Enum.Font.Gotham
    IconLabel.TextSize = 20
    IconLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    IconLabel.Parent = toggleFrame
    
    -- Name
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0, 150, 1, 0)
    NameLabel.Position = UDim2.new(0, 40, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 14
    NameLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = toggleFrame
    
    -- Toggle button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 12
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.AutoButtonColor = false
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = ToggleButton
    
    local toggled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        }):Play()
        ToggleButton.Text = toggled and "ON" or "OFF"
        callback(toggled)
        currentToggles[name] = toggled
    end)
    
    ToggleButton.Parent = toggleFrame
    
    return toggleFrame
end

-- Function to create slider
local function createSlider(name, icon, min, max, default, format, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name.."Slider"
    sliderFrame.Size = UDim2.new(1, -10, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = ContentFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = sliderFrame
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Position = UDim2.new(0, 10, 0, 10)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.Font = Enum.Font.Gotham
    IconLabel.TextSize = 20
    IconLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    IconLabel.Parent = sliderFrame
    
    -- Name and Value
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0, 150, 0, 20)
    NameLabel.Position = UDim2.new(0, 60, 0, 10)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 14
    NameLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = sliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -70, 0, 10)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = format:gsub("{value}", default)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = sliderFrame
    
    -- Slider background
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -80, 0, 6)
    SliderBg.Position = UDim2.new(0, 60, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    SliderBg.BorderSizePixel = 0
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(0, 3)
    BgCorner.Parent = SliderBg
    
    -- Slider fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    SliderFill.BorderSizePixel = 0
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    -- Slider button
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = SliderButton
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Thickness = 2
    ButtonStroke.Color = Color3.fromRGB(0, 200, 255)
    ButtonStroke.Parent = SliderButton
    
    -- Slider functionality
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    mouse.Move:Connect(function()
        if dragging then
            local relativeX = math.clamp((mouse.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (relativeX * (max - min)) * 100) / 100
            
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
            ValueLabel.Text = format:gsub("{value}", value)
            callback(value)
        end
    end)
    
    SliderFill.Parent = SliderBg
    SliderButton.Parent = SliderBg
    SliderBg.Parent = sliderFrame
end

-- Function to create category content
local function loadCategory(category)
    -- Clear content
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if category == "CHARACTER" then
        createSlider("WalkSpeed", "🏃", 16, 100, 16, "{value}", function(v)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = v
            end
        end)
        
        createSlider("JumpPower", "🦘", 50, 200, 50, "{value}", function(v)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = v
            end
        end)
        
        createToggle("Infinite Jump", "🔄", category, false, function(v)
            currentToggles.InfiniteJump = v
            if v then
                connections.InfiniteJump = mouse.Jump:Connect(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if connections.InfiniteJump then
                    connections.InfiniteJump:Disconnect()
                    connections.InfiniteJump = nil
                end
            end
        end)
        
        createToggle("No Ragdoll", "🛡️", category, false, function(v)
            currentToggles.NoRagdoll = v
            -- Implement no ragdoll logic
        end)
        
        createToggle("Anti Taze", "⚡", category, false, function(v)
            currentToggles.AntiTaze = v
            -- Implement anti taze logic
        end)
        
        createToggle("Noclip", "🔲", category, false, function(v)
            currentToggles.Noclip = v
            -- Implement noclip logic
        end)
        
        createToggle("Fly", "🕊️", category, false, function(v)
            currentToggles.Fly = v
            -- Implement fly logic
        end)
        
    elseif category == "AUTO FARM" then
        createToggle("Auto Rob Bank", "🏦", category, false, function(v) currentToggles.AutoBank = v end)
        createToggle("Auto Rob Jewelry", "💎", category, false, function(v) currentToggles.AutoJewelry = v end)
        createToggle("Auto Rob Museum", "🏛️", category, false, function(v) currentToggles.AutoMuseum = v end)
        createToggle("Auto Rob Cargo Train", "🚂", category, false, function(v) currentToggles.AutoCargo = v end)
        createToggle("Auto Rob Passenger Train", "🚆", category, false, function(v) currentToggles.AutoPassenger = v end)
        createToggle("Auto Collect Airdrops", "📦", category, false, function(v) currentToggles.AutoAirdrops = v end)
        createToggle("Auto Escape Prison", "🔓", category, false, function(v) currentToggles.AutoEscape = v end)
        createToggle("Smart Robbery Loop", "🔄", category, false, function(v) currentToggles.SmartLoop = v end)
        
    elseif category == "VEHICLE" then
        createSlider("Car Speed", "🚗", 50, 500, 150, "{value}", function(v)
            currentToggles.CarSpeed = v
            -- Implement car speed
        end)
        
        createToggle("Infinite Nitro", "💨", category, false, function(v) currentToggles.InfiniteNitro = v end)
        createToggle("Fly Car", "🛸", category, false, function(v) currentToggles.FlyCar = v end)
        createToggle("Vehicle Teleport", "📡", category, false, function(v) currentToggles.VehicleTeleport = v end)
        createToggle("Spawn Anywhere", "✨", category, false, function(v) currentToggles.SpawnAnywhere = v end)
        createSlider("Suspension", "🔧", 0, 10, 5, "{value}", function(v) currentToggles.Suspension = v end)
        createToggle("No Cooldown", "⏱️", category, false, function(v) currentToggles.NoCooldown = v end)
        
    elseif category == "TELEPORTS" then
        local teleportLocations = {
            {"Prison", CFrame.new(480, 20, 2450)},
            {"Bank", CFrame.new(260, 20, 200)},
            {"Jewelry Store", CFrame.new(-630, 20, 290)},
            {"Museum", CFrame.new(180, 20, -90)},
            {"Power Plant", CFrame.new(710, 30, 500)},
            {"Criminal Base", CFrame.new(-950, 25, 650)},
            {"Military Base", CFrame.new(2000, 30, 1300)},
            {"Gun Shop", CFrame.new(520, 20, 50)},
            {"Airport", CFrame.new(1650, 30, 200)}
        }
        
        for _, loc in ipairs(teleportLocations) do
            local teleportFrame = Instance.new("Frame")
            teleportFrame.Size = UDim2.new(1, -10, 0, 45)
            teleportFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
            teleportFrame.BackgroundTransparency = 0.3
            teleportFrame.BorderSizePixel = 0
            teleportFrame.Parent = ContentFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = teleportFrame
            
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Size = UDim2.new(0, 200, 1, 0)
            NameLabel.Position = UDim2.new(0, 15, 0, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = loc[1]
            NameLabel.Font = Enum.Font.Gotham
            NameLabel.TextSize = 14
            NameLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.Parent = teleportFrame
            
            local TeleportButton = Instance.new("TextButton")
            TeleportButton.Size = UDim2.new(0, 70, 0, 30)
            TeleportButton.Position = UDim2.new(1, -85, 0.5, -15)
            TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            TeleportButton.Text = "TP"
            TeleportButton.Font = Enum.Font.GothamBold
            TeleportButton.TextSize = 12
            TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TeleportButton.AutoButtonColor = false
            
            local TPButtonCorner = Instance.new("UICorner")
            TPButtonCorner.CornerRadius = UDim.new(0, 4)
            TPButtonCorner.Parent = TeleportButton
            
            TeleportButton.MouseButton1Click:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = loc[2]
                end
            end)
            
            TeleportButton.Parent = teleportFrame
        end
        
    elseif category == "COMBAT" then
        createToggle("Silent Aim", "🎯", category, false, function(v) currentToggles.SilentAim = v end)
        createToggle("Aimbot", "⚡", category, false, function(v) currentToggles.Aimbot = v end)
        createToggle("No Recoil", "🔫", category, false, function(v) currentToggles.NoRecoil = v end)
        createToggle("Instant Reload", "🔄", category, false, function(v) currentToggles.InstantReload = v end)
        createToggle("Infinite Ammo", "∞", category, false, function(v) currentToggles.InfiniteAmmo = v end)
        createSlider("Hitbox Size", "📏", 1, 5, 1, "{value}x", function(v) currentToggles.HitboxSize = v end)
        createToggle("Auto Arrest", "⛓️", category, false, function(v) currentToggles.AutoArrest = v end)
        
    elseif category == "ESP" then
        createToggle("Player ESP", "👥", category, false, function(v) currentToggles.PlayerESP = v end)
        createToggle("Police ESP", "👮", category, false, function(v) currentToggles.PoliceESP = v end)
        createToggle("Criminal ESP", "🦹", category, false, function(v) currentToggles.CriminalESP = v end)
        createToggle("Vehicle ESP", "🚗", category, false, function(v) currentToggles.VehicleESP = v end)
        createToggle("Airdrop ESP", "📦", category, false, function(v) currentToggles.AirdropESP = v end)
        createToggle("Robbery ESP", "💰", category, false, function(v) currentToggles.RobberyESP = v end)
        createToggle("Distance Tracker", "📐", category, false, function(v) currentToggles.DistanceTracker = v end)
    end
end

-- Create category buttons
for i, cat in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Name = cat.name.."Btn"
    button.Size = UDim2.new(0, 100, 0, 35)
    button.BackgroundColor3 = cat.name == currentCategory and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 35, 50)
    button.BackgroundTransparency = cat.name == currentCategory and 0 or 0.5
    button.Text = cat.icon .. " " .. cat.name
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        if cat.name ~= currentCategory then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if cat.name ~= currentCategory then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        for _, btn in ipairs(categoryButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 35, 50),
                BackgroundTransparency = 0.5
            }):Play()
        end
        
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 200, 255),
            BackgroundTransparency = 0
        }):Play()
        
        currentCategory = cat.name
        loadCategory(cat.name)
    end)
    
    button.Parent = CategoryFrame
    table.insert(categoryButtons, button)
end

-- Assemble GUI
TitleBar.Parent = MainFrame
CategoryFrame.Parent = MainFrame
ContentFrame.Parent = MainFrame
MainFrame.Parent = ShadowHolder

-- Animation variables
local isOpen = false
local loadingDots = ""

-- Loading animation
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 100, 0, 30)
LoadingFrame.Position = UDim2.new(0.5, -50, 0.5, -15)
LoadingFrame.BackgroundTransparency = 1
LoadingFrame.Parent = NebulaX

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "NEBULA X LOADING"
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 14
LoadingText.TextColor3 = Color3.fromRGB(0, 200, 255)
LoadingText.TextStrokeTransparency = 0.5
LoadingText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.Parent = LoadingFrame

local LoadingDots = Instance.new("TextLabel")
LoadingDots.Size = UDim2.new(1, 0, 1, 20)
LoadingDots.Position = UDim2.new(0, 0, 0, 20)
LoadingDots.BackgroundTransparency = 1
LoadingDots.Text = "..."
LoadingDots.Font = Enum.Font.GothamBold
LoadingDots.TextSize = 20
LoadingDots.TextColor3 = Color3.fromRGB(0, 200, 255)
LoadingDots.Parent = LoadingFrame

-- Loading animation coroutine
coroutine.wrap(function()
    while true do
        for i = 1, 3 do
            LoadingDots.Text = string.rep(".", i)
            wait(0.3)
        end
    end
end)()

-- Simulate loading
wait(2)

-- Fade out loading
TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(LoadingDots, TweenInfo.new(0.5), {TextTransparency = 1}):Play()

wait(0.5)
LoadingFrame:Destroy()

-- Load default category
loadCategory("CHARACTER")

-- Toggle function
function toggleGUI()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
    
    if isOpen then
        -- Play open animation
        for i, shadow in ipairs(shadows) do
            TweenService:Create(shadow, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.9 - (i * 0.15)
            }):Play()
        end
        
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, -300)
        }):Play()
    else
        -- Play close animation
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -250, 0.5, -250)
        }):Play()
        
        for i, shadow in ipairs(shadows) do
            TweenService:Create(shadow, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
end

-- Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        toggleGUI()
    end
end)

-- Make GUI draggable
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        
        -- Update shadows
        for i, shadow in ipairs(shadows) do
            shadow.Position = UDim2.new(
                0.5,
                -(10 + i) + delta.X,
                0.5,
                -(10 + i) + delta.Y
            )
        end
    end
end)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundTransparency = 0.5
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.Text = "NEBULA X | LOADED"
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextColor3 = Color3.fromRGB(0, 255, 255)
Watermark.TextStrokeTransparency = 0.3
Watermark.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

local WatermarkCorner = Instance.new("UICorner")
WatermarkCorner.CornerRadius = UDim.new(0, 4)
WatermarkCorner.Parent = Watermark

Watermark.Parent = NebulaX

-- Fade out watermark after 5 seconds
wait(5)
TweenService:Create(Watermark, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
wait(1)
Watermark:Destroy()

print("NebulaX v0.1 successfully loaded! Press INSERT to open the menu.")
