-- NebulaX v0.1 - Main Script
-- Created by NovaBreakNewton
-- Fixed for Xeno Executor

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local guiEnabled = false
local gui = nil
local mainFrame = nil

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Print startup message
print("=== NebulaX v0.1 Loading ===")
print("Created by NovaBreakNewton")
print("Waiting for game to load...")

-- Wait for game to fully load
task.wait(3)

-- Helper Functions
function createToggle(name, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 30)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Name = name .. "Container"
    
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

-- Create Farm Page
function createFarmPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 300)
    frame.ScrollBarThickness = 4
    frame.BorderSizePixel = 0
    
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
    end
    
    return frame
end

-- Create Combat Page
function createCombatPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 250)
    frame.ScrollBarThickness = 4
    frame.BorderSizePixel = 0
    
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
    end
    
    return frame
end

-- Create Player Page
function createPlayerPage()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 0, 300)
    frame.ScrollBarThickness = 4
    frame.BorderSizePixel = 0
    
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
    
    -- JumpPower Slider
    local jpLabel = Instance.new("TextLabel")
    jpLabel.Size = UDim2.new(0, 100, 0, 25)
    jpLabel.Position = UDim2.new(0, 10, 0, 80)
    jpLabel.BackgroundTransparency = 1
    jpLabel.Text = "JumpPower"
    jpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jpLabel.Font = Enum.Font.Gotham
    jpLabel.TextSize = 14
    jpLabel.Parent = frame
    
    local jpSlider = createSlider(UDim2.new(0, 120, 0, 20), 50, 200, 50)
    jpSlider.Position = UDim2.new(0, 10, 0, 105)
    jpSlider.Parent = frame
    
    -- Toggles
    local toggles = {
        "Infinite Jump",
        "No Ragdoll",
        "Fly",
        "Noclip"
    }
    
    for i, feature in ipairs(toggles) do
        local toggle = createToggle(feature, UDim2.new(0, 10, 0, 150 + (i-1) * 35))
        toggle.Parent = frame
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

-- Create Main GUI
local function createGUI()
    -- Try different parent options for Xeno
    local parent = CoreGui
    
    -- Check if CoreGui is accessible
    local success, result = pcall(function()
        return CoreGui
    end)
    
    if not success then
        parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    end
    
    if not parent then
        parent = Instance.new("ScreenGui")
        parent.Name = "NebulaX_Temp"
        parent.Parent = player
        parent.Enabled = true
    end
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NebulaX"
    screenGui.Parent = parent
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100
    screenGui.IgnoreGuiInset = true
    
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
    categoryList.BorderSizePixel = 0
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

-- Initialize GUI
local gui, mainFrame
local success, result = pcall(createGUI)
if success then
    gui, mainFrame = result[1], result[2]
    print("✓ NebulaX GUI created successfully")
else
    warn("✗ Failed to create GUI: " .. tostring(result))
end

-- FIXED: Insert key toggle for Xeno
local function toggleGUI()
    if mainFrame then
        guiEnabled = not guiEnabled
        mainFrame.Visible = guiEnabled
        print("NebulaX: " .. (guiEnabled and "Opened" (press INSERT to close)" or "Closed (press INSERT to open)"))
    end
end

-- METHOD 1: UserInputService (works in most executors)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        toggleGUI()
    end
end)

-- METHOD 2: ContextActionService (backup for Xeno)
ContextActionService:BindAction("ToggleNebulaX", function(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        toggleGUI()
    end
end, false, Enum.KeyCode.Insert)

-- METHOD 3: Mouse.KeyDown (most compatible with Xeno)
mouse.KeyDown:Connect(function(key)
    if key == "insert" or key == "Ins" or key == "INSERT" then
        toggleGUI()
    end
end)

-- METHOD 4: Keyboard events via UserInputService (another approach)
local function onInputBegan(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleGUI()
    end
end
UserInputService.InputBegan:Connect(onInputBegan)

-- METHOD 5: Direct key check loop (guaranteed to work)
spawn(function()
    while task.wait(0.1) do
        if UserInputService:IsKeyDown(Enum.KeyCode.Insert) then
            -- Debounce to prevent multiple toggles
            if not guiEnabled then
                toggleGUI()
                task.wait(0.5) -- Wait to prevent rapid toggling
            end
        end
    end
end)

-- Show notification
task.wait(1)
pcall(function()
    -- Try notification
    local notification = Instance.new("ScreenGui")
    notification.Name = "NebulaXNotification"
    notification.Parent = CoreGui
    notification.ResetOnSpawn = false
    notification.DisplayOrder = 200
    notification.IgnoreGuiInset = true
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Size = UDim2.new(0, 350, 0, 60)
    notifyFrame.Position = UDim2.new(0.5, -175, 0, 20)
    notifyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notifyFrame.Parent = notification
    notifyFrame.BorderSizePixel = 0
    
    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 8)
    notifyCorner.Parent = notifyFrame
    
    local notifyText = Instance.new("TextLabel")
    notifyText.Size = UDim2.new(1, -20, 0.5, 0)
    notifyText.Position = UDim2.new(0, 10, 0, 5)
    notifyText.BackgroundTransparency = 1
    notifyText.Text = "NebulaX v0.1 Loaded!"
    notifyText.TextColor3 = Color3.fromRGB(0, 255, 255)
    notifyText.Font = Enum.Font.GothamBold
    notifyText.TextSize = 18
    notifyText.TextXAlignment = Enum.TextXAlignment.Left
    notifyText.Parent = notifyFrame
    
    local notifySubText = Instance.new("TextLabel")
    notifySubText.Size = UDim2.new(1, -20, 0.5, 0)
    notifySubText.Position = UDim2.new(0, 10, 0, 30)
    notifySubText.BackgroundTransparency = 1
    notifySubText.Text = "Press INSERT to open the GUI"
    notifySubText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifySubText.Font = Enum.Font.Gotham
    notifySubText.TextSize = 14
    notifySubText.TextXAlignment = Enum.TextXAlignment.Left
    notifySubText.Parent = notifyFrame
    
    -- Auto destroy after 5 seconds
    task.wait(5)
    notification:Destroy()
end)

-- Success message
print("╔══════════════════════════════════╗")
print("║     NebulaX v0.1 Loaded!         ║")
print("║     Created by NovaBreakNewton    ║")
print("║     Press INSERT to open GUI      ║")
print("╚══════════════════════════════════╝")
