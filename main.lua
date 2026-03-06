-- NebulaX v0.1 - Universal Roblox Blox Fruits GUI
-- Main Framework & UI System

local NebulaX = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Custom Loading Screen
local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaX_Loading"
    ScreenGui.Parent = CoreGui
    
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
    Logo.TextColor3 = Color3.fromRGB(100, 200, 255)
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
    
    -- Loading Bar
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = BarBg
    
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
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 450)
    Main.Position = UDim2.new(0.5, -300, 0.5, -225)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
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
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
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
    TitleText.TextColor3 = Color3.fromRGB(100, 200, 255)
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
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Category Buttons Container
    local CategoryContainer = Instance.new("Frame")
    CategoryContainer.Size = UDim2.new(1, -20, 0, 40)
    CategoryContainer.Position = UDim2.new(0, 10, 0, 50)
    CategoryContainer.BackgroundTransparency = 1
    CategoryContainer.Parent = Main
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -20, 1, -110)
    ContentArea.Position = UDim2.new(0, 10, 0, 100)
    ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ContentArea.BackgroundTransparency = 0.3
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = Main
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentArea
    
    -- Category Buttons Animation
    local categories = {
        "Combat", "Fruits", "Farming", "Visuals", "Movement", "Misc"
    }
    
    local buttons = {}
    local currentCategory = nil
    
    for i, name in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 85, 1, 0)
        btn.Position = UDim2.new(0, (i-1) * 90, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BackgroundTransparency = 0.3
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = CategoryContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        -- Hover Animation
        btn.MouseEnter:Connect(function()
            if currentCategory ~= btn then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if currentCategory ~= btn then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            if currentCategory then
                TweenService:Create(currentCategory, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
            end
            
            TweenService:Create(btn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(100, 200, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            currentCategory = btn
            NebulaX:LoadCategory(name, ContentArea)
        end)
        
        buttons[name] = btn
    end
    
    -- Player Stats Tracker
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -20, 0, 60)
    StatsFrame.Position = UDim2.new(0, 10, 1, -70)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    StatsFrame.BackgroundTransparency = 0.3
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = Main
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 6)
    StatsCorner.Parent = StatsFrame
    
    -- Level Display
    local LevelText = Instance.new("TextLabel")
    LevelText.Size = UDim2.new(0.33, -5, 1, -10)
    LevelText.Position = UDim2.new(0, 5, 0, 5)
    LevelText.BackgroundTransparency = 1
    LevelText.Text = "Level: Loading..."
    LevelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LevelText.TextSize = 14
    LevelText.Font = Enum.Font.Gotham
    LevelText.TextXAlignment = Enum.TextXAlignment.Left
    LevelText.Parent = StatsFrame
    
    -- Stats Display
    local StatsText = Instance.new("TextLabel")
    StatsText.Size = UDim2.new(0.34, -5, 1, -10)
    StatsText.Position = UDim2.new(0.33, 0, 0, 5)
    StatsText.BackgroundTransparency = 1
    StatsText.Text = "Melee: 0 | Defense: 0"
    StatsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatsText.TextSize = 14
    StatsText.Font = Enum.Font.Gotham
    StatsText.Parent = StatsFrame
    
    -- Fruit Display
    local FruitText = Instance.new("TextLabel")
    FruitText.Size = UDim2.new(0.33, -5, 1, -10)
    FruitText.Position = UDim2.new(0.67, 0, 0, 5)
    FruitText.BackgroundTransparency = 1
    FruitText.Text = "Fruit: None"
    FruitText.TextColor3 = Color3.fromRGB(255, 200, 100)
    FruitText.TextSize = 14
    FruitText.Font = Enum.Font.Gotham
    FruitText.TextXAlignment = Enum.TextXAlignment.Right
    FruitText.Parent = StatsFrame
    
    -- Update Stats
    spawn(function()
        while ScreenGui.Parent do
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
function NebulaX:LoadCategory(category, container)
    for _, v in ipairs(container:GetChildren()) do
        v:Destroy()
    end
    
    local function CreateToggle(name, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.Position = UDim2.new(0, 10, 0, (#container:GetChildren() * 45))
        frame.BackgroundTransparency = 1
        frame.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggle.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = frame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 12)
        toggleCorner.Parent = toggle
        
        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggle.BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
            toggle.Text = enabled and "ON" or "OFF"
            callback(enabled)
        end)
    end
    
    local function CreateButton(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = UDim2.new(0, 10, 0, (#container:GetChildren() * 45))
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end)
    end
    
    if category == "Combat" then
        CreateToggle("Auto Farm (Enemies)", false, function(state) NebulaX.AutoFarm = state end)
        CreateToggle("Auto Boss", false, function(state) NebulaX.AutoBoss = state end)
        CreateToggle("Auto Haki", true, function(state) NebulaX.AutoHaki = state end)
        CreateToggle("Auto Stats", true, function(state) NebulaX.AutoStats = state end)
        CreateToggle("Fast Attack", true, function(state) NebulaX.FastAttack = state end)
        CreateToggle("Kill Aura", false, function(state) NebulaX.KillAura = state end)
        CreateToggle("Auto Skill", false, function(state) NebulaX.AutoSkill = state end)
    elseif category == "Fruits" then
        CreateToggle("Auto Find Fruit", false, function(state) NebulaX.AutoFindFruit = state end)
        CreateToggle("Fruit Sniper", false, function(state) NebulaX.FruitSniper = state end)
        CreateToggle("Fruit ESP", true, function(state) NebulaX.FruitESP = state end)
        CreateToggle("Auto Store Fruit", true, function(state) NebulaX.AutoStoreFruit = state end)
        CreateToggle("Fruit Notifier", true, function(state) NebulaX.FruitNotifier = state end)
    elseif category == "Farming" then
        CreateToggle("Auto Level", false, function(state) NebulaX.AutoLevel = state end)
        CreateToggle("Auto Quest", true, function(state) NebulaX.AutoQuest = state end)
        CreateToggle("Auto Farm Chest", false, function(state) NebulaX.AutoFarmChest = state end)
        CreateToggle("Auto Material Farm", false, function(state) NebulaX.AutoMaterialFarm = state end)
        CreateToggle("Auto Elite Hunter", false, function(state) NebulaX.AutoEliteHunter = state end)
    elseif category == "Visuals" then
        CreateToggle("Player ESP", true, function(state) NebulaX.PlayerESP = state end)
        CreateToggle("Fruit ESP", true, function(state) NebulaX.FruitESP = state end)
        CreateToggle("Chest ESP", true, function(state) NebulaX.ChestESP = state end)
        CreateToggle("Island ESP", false, function(state) NebulaX.IslandESP = state end)
        CreateToggle("Boss ESP", true, function(state) NebulaX.BossESP = state end)
        CreateButton("Rainbow UI", function() NebulaX:RainbowUI() end)
    elseif category == "Movement" then
        CreateToggle("Fly", false, function(state) NebulaX.Fly = state end)
        CreateToggle("Speed Hack", false, function(state) NebulaX.SpeedHack = state end)
        CreateToggle("Infinite Jump", false, function(state) NebulaX.InfiniteJump = state end)
        CreateButton("Teleport to Island", function() NebulaX:TeleportUI() end)
        CreateToggle("Boat Fly", false, function(state) NebulaX.BoatFly = state end)
    elseif category == "Misc" then
        CreateButton("Toggle UI Key (Right Ctrl)", function() end)
        CreateButton("Theme Changer", function() NebulaX:ChangeTheme() end)
        CreateToggle("Sound", true, function(state) NebulaX.Sound = state end)
        CreateButton("Reset Script", function() 
            ScreenGui:Destroy()
            loadstring(game:HttpGet("raw.githubusercontent.com/yourusername/NebulaX/main/loader.lua"))()
        end)
    end
end

-- ESP System
function NebulaX:CreateESP()
    local ESP = {}
    
    function ESP:Create(obj, color, text)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NebulaX_ESP"
        billboard.Adornee = obj
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = color
        frame.BorderSizePixel = 0
        frame.Parent = billboard
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.Position = UDim2.new(0, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.Parent = frame
        
        billboard.Parent = obj
    end
    
    return ESP
end

-- Initialize
CreateLoadingScreen()
wait(0.5)
NebulaX:CreateUI()

-- Features Implementation
spawn(function()
    while wait(0.1) do
        pcall(function()
            if NebulaX.AutoHaki then
                -- Auto Haki logic
                if LocalPlayer.Character then
                    local buso = LocalPlayer.Character:FindFirstChild("Buso")
                    if not buso or buso.Value == false then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                    end
                end
            end
            
            if NebulaX.FastAttack then
                -- Fast Attack logic
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Activate()
                    end
                end
            end
            
            if NebulaX.AutoStats then
                -- Auto Stats logic (prioritize melee and defense)
                local args = {
                    [1] = "AddPoint",
                    [2] = "Melee",
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
            
            if NebulaX.Fly then
                -- Fly logic
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(0, 50, 0)
                    end
                end
            end
            
            if NebulaX.SpeedHack then
                -- Speed Hack
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if NebulaX.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fruit ESP
spawn(function()
    while wait(1) do
        if NebulaX.FruitESP then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Fruit" and not v:FindFirstChild("NebulaX_ESP") then
                    NebulaX:CreateESP():Create(v, Color3.fromRGB(255, 200, 0), "Fruit")
                end
            end
        end
    end
end)

-- Fruit Notifier
workspace.ChildAdded:Connect(function(child)
    if NebulaX.FruitNotifier and child.Name == "Fruit" then
        LocalPlayer:Notify("NebulaX", "Fruit spawned at " .. tostring(child.Position))
    end
end)

return NebulaX
