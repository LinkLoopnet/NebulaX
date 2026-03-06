-- NebulaX v0.1 - Universal Roblox Blade Ball GUI
-- Xeno Optimized Version

-- Check if Xeno UI library exists, if not create a simple one
local Library = {}
local Window = {}

-- Create a simple GUI if no library is loaded
local function CreateBasicGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NebulaX"
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Add title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "NebulaX v0.1"
    titleText.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = not screenGui.Enabled
    end)
    
    -- Create tabs
    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = mainFrame
    tabFrame.Size = UDim2.new(0, 120, 1, -30)
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabFrame.BorderSizePixel = 0
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(1, -120, 1, -30)
    contentFrame.Position = UDim2.new(0, 120, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    
    return screenGui, mainFrame, tabFrame, contentFrame
end

-- Create the GUI
local screenGui, mainFrame, tabFrame, contentFrame = CreateBasicGUI()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Variables
local guiVisible = true
local currentTab = nil
local tabButtons = {}
local toggles = {}
local connections = {}
local espObjects = {}

local settings = {
    themeColor = Color3.fromRGB(0, 255, 255),
    keybind = Enum.KeyCode.Insert,
    autoParry = false,
    fastParry = 50,
    parryAura = false,
    autoTarget = false,
    hitPrediction = false,
    walkspeed = 16,
    jumppower = 50,
    infiniteJump = false,
    noSlow = false,
    spinBot = false,
    ballESP = false,
    playerESP = false,
    fpsBoost = false,
    antiAFK = false
}

-- Function to create tabs
local function CreateTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabFrame
    tabButton.Size = UDim2.new(1, 0, 0, 35)
    tabButton.Position = UDim2.new(0, 0, 0, (#tabButtons * 35))
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Parent = contentFrame
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    tabButton.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        for _, content in pairs(contentFrame:GetChildren()) do
            if content:IsA("ScrollingFrame") then
                content.Visible = false
            end
        end
        tabButton.BackgroundColor3 = settings.themeColor
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabContent.Visible = true
    end)
    
    table.insert(tabButtons, tabButton)
    
    -- Create helper functions for the tab
    local tabAPI = {}
    
    function tabAPI:CreateToggle(name, default, callback)
        local yPos = #toggles * 35
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = tabContent
        toggleFrame.Size = UDim2.new(1, -10, 0, 30)
        toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
        toggleFrame.BackgroundTransparency = 1
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = toggleFrame
        toggleBtn.Size = UDim2.new(0, 50, 0, 25)
        toggleBtn.Position = UDim2.new(1, -55, 0, 2.5)
        toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleBtn.Text = default and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 12
        
        local label = Instance.new("TextLabel")
        label.Parent = toggleFrame
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        
        local enabled = default
        
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            toggleBtn.Text = enabled and "ON" or "OFF"
            callback(enabled)
        end)
        
        table.insert(toggles, toggleFrame)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, #toggles * 35)
        
        -- Initial callback
        if default then
            callback(true)
        end
    end
    
    function tabAPI:CreateSlider(name, min, max, default, callback)
        local yPos = #toggles * 35
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = tabContent
        sliderFrame.Size = UDim2.new(1, -10, 0, 45)
        sliderFrame.Position = UDim2.new(0, 5, 0, yPos)
        sliderFrame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Parent = sliderFrame
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        
        local slider = Instance.new("Frame")
        slider.Parent = sliderFrame
        slider.Size = UDim2.new(1, -20, 0, 10)
        slider.Position = UDim2.new(0, 10, 0, 25)
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        slider.BorderSizePixel = 0
        
        local fill = Instance.new("Frame")
        fill.Parent = slider
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = settings.themeColor
        fill.BorderSizePixel = 0
        
        local dragBtn = Instance.new("TextButton")
        dragBtn.Parent = slider
        dragBtn.Size = UDim2.new(0, 20, 0, 20)
        dragBtn.Position = UDim2.new((default - min) / (max - min), -10, -5, 0)
        dragBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dragBtn.Text = ""
        dragBtn.BorderSizePixel = 0
        
        local dragging = false
        
        dragBtn.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize.X
                local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                
                fill.Size = UDim2.new(percent, 0, 1, 0)
                dragBtn.Position = UDim2.new(percent, -10, -5, 0)
                label.Text = name .. ": " .. value
                callback(value)
            end
        end)
        
        table.insert(toggles, sliderFrame)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, #toggles * 45)
    end
    
    function tabAPI:CreateButton(name, callback)
        local yPos = #toggles * 35
        local btn = Instance.new("TextButton")
        btn.Parent = tabContent
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = settings.themeColor
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        
        btn.MouseButton1Click:Connect(callback)
        
        table.insert(toggles, btn)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, #toggles * 35)
    end
    
    function tabAPI:CreateColorPicker(name, default, callback)
        -- Simplified color picker
        local yPos = #toggles * 35
        local colorFrame = Instance.new("Frame")
        colorFrame.Parent = tabContent
        colorFrame.Size = UDim2.new(1, -10, 0, 30)
        colorFrame.Position = UDim2.new(0, 5, 0, yPos)
        colorFrame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Parent = colorFrame
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        
        local colorBtn = Instance.new("Frame")
        colorBtn.Parent = colorFrame
        colorBtn.Size = UDim2.new(0, 25, 0, 25)
        colorBtn.Position = UDim2.new(1, -30, 0, 2.5)
        colorBtn.BackgroundColor3 = default
        
        callback(default)
        
        table.insert(toggles, colorFrame)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, #toggles * 35)
    end
    
    function tabAPI:CreateKeybind(name, default, callback)
        local yPos = #toggles * 35
        local keyFrame = Instance.new("Frame")
        keyFrame.Parent = tabContent
        keyFrame.Size = UDim2.new(1, -10, 0, 30)
        keyFrame.Position = UDim2.new(0, 5, 0, yPos)
        keyFrame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Parent = keyFrame
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = keyFrame
        keyBtn.Size = UDim2.new(0, 40, 0, 25)
        keyBtn.Position = UDim2.new(1, -45, 0, 2.5)
        keyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        keyBtn.Text = "Insert"
        keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBtn.Font = Enum.Font.Gotham
        keyBtn.TextSize = 12
        
        callback(default)
        
        table.insert(toggles, keyFrame)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, #toggles * 35)
    end
    
    return tabAPI
end

-- Ensure GUI is visible
task.wait(1)
screenGui.Enabled = true
print("NebulaX v0.1 loaded successfully! Press Insert to toggle UI.")

-- Main Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == settings.keybind then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- Create Tabs
local CombatTab = CreateTab("Combat")
local PlayerTab = CreateTab("Player")
local VisualsTab = CreateTab("Visuals")
local MiscTab = CreateTab("Misc")
local SettingsTab = CreateTab("Settings")

-- Combat Tab
CombatTab:CreateToggle("Auto Parry", false, function(state)
    settings.autoParry = state
    if state then
        connections.autoParry = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, ball in pairs(workspace:GetDescendants()) do
                    if ball:IsA("Part") and (ball.Name:find("Ball") or ball.Name:find("Energy")) then
                        local distance = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 15 then
                            -- Parry logic here
                        end
                    end
                end
            end
        end)
    else
        if connections.autoParry then
            connections.autoParry:Disconnect()
        end
    end
end)

CombatTab:CreateSlider("Fast Parry", 0, 100, 50, function(value)
    settings.fastParry = value
end)

CombatTab:CreateToggle("Parry Aura", false, function(state)
    settings.parryAura = state
    if state then
        connections.parryAura = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, ball in pairs(workspace:GetDescendants()) do
                    if ball:IsA("Part") and (ball.Name:find("Ball") or ball.Name:find("Energy")) then
                        local distance = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 20 then
                            -- Aura parry logic
                        end
                    end
                end
            end
        end)
    else
        if connections.parryAura then
            connections.parryAura:Disconnect()
        end
    end
end)

CombatTab:CreateToggle("Auto Target", false, function(state)
    settings.autoTarget = state
    if state then
        connections.autoTarget = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local closestPlayer = nil
                local closestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
                
                if closestPlayer then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                        LocalPlayer.Character.HumanoidRootPart.Position,
                        Vector3.new(closestPlayer.Character.HumanoidRootPart.Position.X, 
                                   LocalPlayer.Character.HumanoidRootPart.Position.Y, 
                                   closestPlayer.Character.HumanoidRootPart.Position.Z)
                    )
                end
            end
        end)
    else
        if connections.autoTarget then
            connections.autoTarget:Disconnect()
        end
    end
end)

CombatTab:CreateToggle("Hit Prediction", false, function(state)
    settings.hitPrediction = state
end)

-- Player Tab
PlayerTab:CreateSlider("WalkSpeed", 16, 120, 16, function(value)
    settings.walkspeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

PlayerTab:CreateSlider("JumpPower", 50, 200, 50, function(value)
    settings.jumppower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

PlayerTab:CreateToggle("Infinite Jump", false, function(state)
    settings.infiniteJump = state
    if state then
        connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections.infiniteJump then
            connections.infiniteJump:Disconnect()
        end
    end
end)

PlayerTab:CreateToggle("No Slow", false, function(state)
    settings.noSlow = state
end)

PlayerTab:CreateToggle("Spin Bot", false, function(state)
    settings.spinBot = state
    if state then
        connections.spinBot = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        end)
    else
        if connections.spinBot then
            connections.spinBot:Disconnect()
        end
    end
end)

-- Visuals Tab
VisualsTab:CreateToggle("Ball ESP", false, function(state)
    settings.ballESP = state
    if state then
        connections.ballESP = RunService.Heartbeat:Connect(function()
            for _, ball in pairs(workspace:GetDescendants()) do
                if ball:IsA("Part") and (ball.Name:find("Ball") or ball.Name:find("Energy")) and not espObjects[ball] then
                    local billboard = Instance.new("BillboardGui")
                    local textLabel = Instance.new("TextLabel")
                    
                    billboard.Parent = ball
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    
                    textLabel.Parent = billboard
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.Text = "⚽"
                    textLabel.TextColor3 = settings.themeColor
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextScaled = true
                    
                    espObjects[ball] = billboard
                end
            end
        end)
    else
        if connections.ballESP then
            connections.ballESP:Disconnect()
        end
        for obj, billboard in pairs(espObjects) do
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
        end
        table.clear(espObjects)
    end
end)

VisualsTab:CreateToggle("Player ESP", false, function(state)
    settings.playerESP = state
    if state then
        connections.playerESP = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not espObjects[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = settings.themeColor
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    
                    espObjects[player] = highlight
                end
            end
        end)
    else
        if connections.playerESP then
            connections.playerESP:Disconnect()
        end
        for obj, highlight in pairs(espObjects) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
        end
        table.clear(espObjects)
    end
end)

VisualsTab:CreateColorPicker("Theme Color", settings.themeColor, function(color)
    settings.themeColor = color
end)

-- Misc Tab
MiscTab:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

MiscTab:CreateButton("Server Hop", function()
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end)

MiscTab:CreateToggle("FPS Boost", false, function(state)
    settings.fpsBoost = state
    if state then
        settings:GetService("RenderSettings").QualityLevel = 1
    else
        settings:GetService("RenderSettings").QualityLevel = 2
    end
end)

MiscTab:CreateToggle("Anti AFK", false, function(state)
    settings.antiAFK = state
    if state then
        connections.antiAFK = LocalPlayer.Idled:Connect(function()
            LocalPlayer.VirtualUser:CaptureController()
            LocalPlayer.VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if connections.antiAFK then
            connections.antiAFK:Disconnect()
        end
    end
end)

MiscTab:CreateButton("Copy Server ID", function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

-- Settings Tab
SettingsTab:CreateKeybind("Toggle Keybind", Enum.KeyCode.Insert, function(key)
    settings.keybind = key
end)

SettingsTab:CreateColorPicker("UI Color", settings.themeColor, function(color)
    settings.themeColor = color
    -- Update tab button colors
    for _, btn in pairs(tabButtons) do
        if btn.BackgroundColor3 == settings.themeColor then
            btn.BackgroundColor3 = color
        end
    end
end)

SettingsTab:CreateButton("Save Settings", function()
    if writefile then
        writefile("NebulaX_Settings.json", game:GetService("HttpService"):JSONEncode(settings))
    end
end)

SettingsTab:CreateButton("Load Settings", function()
    if isfile and isfile("NebulaX_Settings.json") then
        local loaded = game:GetService("HttpService"):JSONDecode(readfile("NebulaX_Settings.json"))
        for k, v in pairs(loaded) do
            settings[k] = v
        end
    end
end)

-- Select first tab by default
if #tabButtons > 0 then
    tabButtons[1].BackgroundColor3 = settings.themeColor
    tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
    for _, content in pairs(contentFrame:GetChildren()) do
        if content:IsA("ScrollingFrame") then
            content.Visible = false
        end
    end
    contentFrame:GetChildren()[1].Visible = true
end

print("=== NebulaX v0.1 ===")
print("Press Insert to toggle GUI")
print("GUI should now be visible!")
