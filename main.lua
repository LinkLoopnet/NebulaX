-- NebulaX v0.1 Framework
-- Created by NovaBreakNewton

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local guiEnabled = false
local gui

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Create Main GUI
local function createGUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NebulaX"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "NebulaX v0.1"
    titleText.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        guiEnabled = false
        mainFrame.Visible = false
    end)
    
    -- Category Buttons
    local categories = {
        {name = "Auto Farm", color = Color3.fromRGB(255, 100, 100)},
        {name = "Combat", color = Color3.fromRGB(100, 255, 100)},
        {name = "Player", color = Color3.fromRGB(100, 100, 255)},
        {name = "Credits", color = Color3.fromRGB(255, 255, 100)}
    }
    
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Name = "CategoryFrame"
    categoryFrame.Size = UDim2.new(0, 120, 1, -30)
    categoryFrame.Position = UDim2.new(0, 0, 0, 30)
    categoryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    categoryFrame.BorderSizePixel = 0
    categoryFrame.Parent = mainFrame
    
    local categoryCorner = Instance.new("UICorner")
    categoryCorner.CornerRadius = UDim.new(0, 8)
    categoryCorner.Parent = categoryFrame
    
    local categoryList = Instance.new("ScrollingFrame")
    categoryList.Size = UDim2.new(1, -10, 1, -10)
    categoryList.Position = UDim2.new(0, 5, 0, 5)
    categoryList.BackgroundTransparency = 1
    categoryList.ScrollBarThickness = 4
    categoryList.CanvasSize = UDim2.new(0, 0, 0, #categories * 40)
    categoryList.Parent = categoryFrame
    
    local categoryButtons = {}
    
    for i, category in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Name = category.name
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.Text = category.name
        btn.TextColor3 = category.color
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = categoryList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        table.insert(categoryButtons, btn)
    end
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -130, 1, -30)
    contentFrame.Position = UDim2.new(0, 125, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Create category pages
    local pages = {}
    
    -- Auto Farm Page
    local farmPage = createFarmPage()
    farmPage.Parent = contentFrame
    farmPage.Visible = false
    pages["Auto Farm"] = farmPage
    
    -- Combat Page
    local combatPage = createCombatPage()
    combatPage.Parent = contentFrame
    combatPage.Visible = false
    pages["Combat"] = combatPage
    
    -- Player Page
    local playerPage = createPlayerPage()
    playerPage.Parent = contentFrame
    playerPage.Visible = false
    pages["Player"] = playerPage
    
    -- Credits Page
    local creditsPage = createCreditsPage()
    creditsPage.Parent = contentFrame
    creditsPage.Visible = false
    pages["Credits"] = creditsPage
    
    -- Show first page
    pages["Auto Farm"].Visible = true
    
    -- Category button functionality
    for _, btn in ipairs(categoryButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, page in pairs(pages) do
                page.Visible = false
            end
            pages[btn.Name].Visible = true
        end)
    end
    
    return screenGui, mainFrame
end

-- Create Farm Page
function createFarmPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 300)
    frame.ScrollBarThickness = 4
    
    local features = {
        "Auto Rob",
        "Auto Bank",
        "Auto Jewelry",
        "Auto Train Rob",
        "Auto Power Plant",
        "Auto Collect Money",
        "Auto Escape Prison"
    }
    
    for i, feature in ipairs(features) do
        local toggle = createToggle(feature, UDim2.new(0, 10, 0, (i-1) * 35))
        toggle.Parent = frame
        
        -- Add functionality
        if feature == "Auto Rob" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                -- Auto Rob functionality
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        -- Auto rob logic
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        elseif feature == "Auto Bank" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        -- Auto bank logic
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        elseif feature == "Auto Jewelry" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        -- Auto jewelry logic
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        end
        -- Add similar logic for other farm features
    end
    
    return frame
end

-- Create Combat Page
function createCombatPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 200)
    frame.ScrollBarThickness = 4
    
    local features = {
        "Aimbot",
        "Silent Aim",
        "No Recoil",
        "Fast Shooting",
        "Infinite Ammo",
        "Gun Mods"
    }
    
    for i, feature in ipairs(features) do
        local toggle = createToggle(feature, UDim2.new(0, 10, 0, (i-1) * 35))
        toggle.Parent = frame
        
        -- Add aimbot functionality
        if feature == "Aimbot" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                local aimbotEnabled = false
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        if aimbotEnabled then
                            -- Aimbot logic
                            local closestPlayer = getClosestPlayer()
                            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                                camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
                            end
                        end
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        elseif feature == "No Recoil" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                -- No recoil logic
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        -- Remove recoil
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        end
    end
    
    return frame
end

-- Create Player Page
function createPlayerPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 250)
    frame.ScrollBarThickness = 4
    
    -- WalkSpeed Slider
    local wsLabel = Instance.new("TextLabel")
    wsLabel.Size = UDim2.new(0, 100, 0, 25)
    wsLabel.Position = UDim2.new(0, 10, 0, 10)
    wsLabel.BackgroundTransparency = 1
    wsLabel.Text = "WalkSpeed"
    wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wsLabel.TextXAlignment = Enum.TextXAlignment.Left
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.TextSize = 14
    wsLabel.Parent = frame
    
    local wsSlider = createSlider(UDim2.new(0, 120, 0, 20), 16, 100, 16)
    wsSlider.Position = UDim2.new(0, 10, 0, 35)
    wsSlider.Parent = frame
    
    wsSlider:FindFirstChild("SliderButton").MouseButton1Down:Connect(function()
        local sliding = true
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if sliding and player.Character and player.Character:FindFirstChild("Humanoid") then
                local sliderPos = math.clamp(mouse.X - wsSlider.AbsolutePosition.X, 0, wsSlider.AbsoluteSize.X)
                local percent = sliderPos / wsSlider.AbsoluteSize.X
                local value = math.floor(16 + (percent * 84))
                player.Character.Humanoid.WalkSpeed = value
                wsSlider:FindFirstChild("Value").Text = tostring(value)
            end
        end)
        
        local release
        release = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = false
                connection:Disconnect()
                release:Disconnect()
            end
        end)
    end)
    
    -- JumpPower Slider
    local jpLabel = Instance.new("TextLabel")
    jpLabel.Size = UDim2.new(0, 100, 0, 25)
    jpLabel.Position = UDim2.new(0, 10, 0, 70)
    jpLabel.BackgroundTransparency = 1
    jpLabel.Text = "JumpPower"
    jpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jpLabel.Font = Enum.Font.Gotham
    jpLabel.TextSize = 14
    jpLabel.Parent = frame
    
    local jpSlider = createSlider(UDim2.new(0, 120, 0, 20), 50, 200, 50)
    jpSlider.Position = UDim2.new(0, 10, 0, 95)
    jpSlider.Parent = frame
    
    jpSlider:FindFirstChild("SliderButton").MouseButton1Down:Connect(function()
        local sliding = true
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if sliding and player.Character and player.Character:FindFirstChild("Humanoid") then
                local sliderPos = math.clamp(mouse.X - jpSlider.AbsolutePosition.X, 0, jpSlider.AbsoluteSize.X)
                local percent = sliderPos / jpSlider.AbsoluteSize.X
                local value = math.floor(50 + (percent * 150))
                player.Character.Humanoid.JumpPower = value
                jpSlider:FindFirstChild("Value").Text = tostring(value)
            end
        end)
        
        local release
        release = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = false
                connection:Disconnect()
                release:Disconnect()
            end
        end)
    end)
    
    -- Toggles
    local toggles = {
        "Infinite Jump",
        "No Ragdoll",
        "Fly",
        "Noclip"
    }
    
    for i, feature in ipairs(toggles) do
        local toggle = createToggle(feature, UDim2.new(0, 200, 0, 130 + (i-1) * 35))
        toggle.Parent = frame
        
        if feature == "Infinite Jump" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                local infiniteJumpEnabled = false
                UserInputService.JumpRequest:Connect(function()
                    if toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState("Jumping")
                    end
                end)
            end)
        elseif feature == "Fly" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        -- Fly logic
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local root = player.Character.HumanoidRootPart
                            local moveDirection = Vector3.new()
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
                            
                            if moveDirection.Magnitude > 0 then
                                root.Velocity = moveDirection.Unit * 50
                            else
                                root.Velocity = Vector3.new()
                            end
                        end
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        elseif feature == "Noclip" then
            toggle:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
                spawn(function()
                    while toggle:FindFirstChild("ToggleBtn").BackgroundColor3 == Color3.fromRGB(0, 255, 0) do
                        if player.Character then
                            for _, part in ipairs(player.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                        RunService.Heartbeat:Wait()
                    end
                end)
            end)
        end
    end
    
    return frame
end

-- Create Credits Page
function createCreditsPage()
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    
    local credits = {
        {text = "Script Creator:", value = "NovaBreakNewton"},
        {text = "Script Name:", value = "NebulaX v0.1"},
        {text = "Version:", value = "0.1 Alpha"},
        {text = "Special Thanks:", value = "All Beta Testers"},
        {text = "Discord:", value = "discord.gg/novabreak"}
    }
    
    for i, credit in ipairs(credits) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 30)
        label.Position = UDim2.new(0, 10, 0, 20 + (i-1) * 35)
        label.BackgroundTransparency = 1
        label.Text = credit.text .. " " .. credit.value
        label.TextColor3 = i == 1 and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = i == 1 and Enum.Font.GothamBold or Enum.Font.Gotham
        label.TextSize = i == 1 and 18 or 14
        label.Parent = frame
    end
    
    local versionBox = Instance.new("Frame")
    versionBox.Size = UDim2.new(1, -20, 0, 100)
    versionBox.Position = UDim2.new(0, 10, 0, 180)
    versionBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    versionBox.Parent = frame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = versionBox
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, -10, 1, -10)
    versionLabel.Position = UDim2.new(0, 5, 0, 5)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Version Updates:\n\n- Initial release\n- Added all categories\n- Insert key toggle\n- UI Framework"
    versionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.TextYAlignment = Enum.TextYAlignment.Top
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 12
    versionLabel.Parent = versionBox
    
    return frame
end

-- Helper function to create toggle buttons
function createToggle(name, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 30)
    frame.Position = position
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0, 160, 0, 2.5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        if toggleBtn.BackgroundColor3 == Color3.fromRGB(255, 50, 50) then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            toggleBtn.Text = "OFF"
        end
    end)
    
    return frame
end

-- Helper function to create sliders
function createSlider(position, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 25)
    frame.Position = position
    frame.BackgroundTransparency = 1
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 150, 0, 5)
    sliderBg.Position = UDim2.new(0, 0, 0.5, -2.5)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    sliderFill.Parent = sliderBg
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Name = "SliderButton"
    sliderBtn.Size = UDim2.new(0, 10, 0, 10)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    btnCorner.Parent = sliderBtn
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 40, 1, 0)
    valueLabel.Position = UDim2.new(0, 160, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = frame
    
    return frame
end

-- Function to get closest player for aimbot
function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
            local headPos = otherPlayer.Character.Head.Position
            local screenPos, onScreen = camera:WorldToScreenPoint(headPos)
            
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance and distance < 200 then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    
    return closestPlayer
end

-- Initialize GUI
local guiObject, mainFrame = createGUI()

-- Insert key toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        guiEnabled = not guiEnabled
        mainFrame.Visible = guiEnabled
    end
end)

-- Notification
local notification = Instance.new("ScreenGui")
notification.Parent = CoreGui

local notifyFrame = Instance.new("Frame")
notifyFrame.Size = UDim2.new(0, 300, 0, 50)
notifyFrame.Position = UDim2.new(0.5, -150, 0, -60)
notifyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
notifyFrame.Parent = notification

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 8)
notifyCorner.Parent = notifyFrame

local notifyText = Instance.new("TextLabel")
notifyText.Size = UDim2.new(1, -20, 1, 0)
notifyText.Position = UDim2.new(0, 10, 0, 0)
notifyText.BackgroundTransparency = 1
notifyText.Text = "NebulaX v0.1 Loaded! Press Insert to open"
notifyText.TextColor3 = Color3.fromRGB(0, 255, 255)
notifyText.Font = Enum.Font.Gotham
notifyText.TextSize = 14
notifyText.Parent = notifyFrame

-- Animate notification
local goal = {Position = UDim2.new(0.5, -150, 0, 20)}
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(notifyFrame, tweenInfo, goal)
tween:Play()

task.wait(3)

local hideGoal = {Position = UDim2.new(0.5, -150, 0, -60)}
local hideTween = TweenService:Create(notifyFrame, tweenInfo, hideGoal)
hideTween:Play()

hideTween.Completed:Connect(function()
    notification:Destroy()
end)

print("NebulaX v0.1 Loaded Successfully!")
print("Press Insert to open/close the GUI")
print("Created by NovaBreakNewton")
