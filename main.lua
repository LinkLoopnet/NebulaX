-- NebulaX v0.1 - Redesigned with Better UI/UX
loadstring(game:HttpGet("https://raw.githubusercontent.com/LinkLoopnet/NebulaX/main/main.lua"))()

-- Wait for the GUI to load
task.wait(2)

-- Get the existing GUI and reposition it
local player = game:GetService("Players").LocalPlayer
local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("NebulaX") or 
           game:GetService("CoreGui"):FindFirstChild("NebulaX")

if gui then
    gui:Destroy() -- Remove old GUI to recreate it properly
end

-- Create a brand new, properly positioned GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NebulaX"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main frame with better positioning (top right corner, not overlapping game UI)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(1, -400, 0, 10) -- Positioned at top right with padding
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- Add a nice shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = mainFrame
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title bar with gradient
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Title gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Parent = titleBar
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
})

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "NEBULAX v0.1"
titleText.TextColor3 = Color3.fromRGB(0, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextStrokeTransparency = 0.8

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- Create tab buttons with modern design
local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.Size = UDim2.new(1, 0, 0, 45)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0

local tabList = {
    "⚔️ Combat",
    "👤 Player",
    "👁️ Visuals",
    "⚙️ Misc",
    "🔧 Settings"
}

local tabButtons = {}
local activeTab = nil
local contentFrame = nil

-- Create content container
contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -20, 1, -105)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
contentFrame.BorderSizePixel = 0

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 6)
contentCorner.Parent = contentFrame

-- Create scrolling frame for content
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = contentFrame
scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Create tab buttons
for i, tabName in ipairs(tabList) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = tabFrame
    tabBtn.Size = UDim2.new(0, 76, 0, 35)
    tabBtn.Position = UDim2.new(0, 5 + ((i-1) * 76), 0, 5)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 55)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = i == 1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 12
    tabBtn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        tabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Clear content
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Populate based on selected tab
        PopulateTab(i)
    end)
end

-- Function to create toggle switches
local function CreateToggle(parent, name, default, yPos, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.Size = UDim2.new(1, -10, 0, 35)
    toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = toggleFrame
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = toggleFrame
    toggleBtn.Size = UDim2.new(0, 45, 0, 25)
    toggleBtn.Position = UDim2.new(1, -50, 0, 5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 70, 70)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleBtn
    
    local enabled = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 70, 70)
        toggleBtn.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)
    
    return toggleFrame, toggleBtn
end

-- Function to create sliders
local function CreateSlider(parent, name, min, max, default, yPos, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.Position = UDim2.new(0, 5, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = sliderFrame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = sliderFrame
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local dragBtn = Instance.new("TextButton")
    dragBtn.Parent = sliderBg
    dragBtn.Size = UDim2.new(0, 16, 0, 16)
    dragBtn.Position = UDim2.new((default - min) / (max - min), -8, -4, 0)
    dragBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dragBtn.Text = ""
    dragBtn.BorderSizePixel = 0
    
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 8)
    dragCorner.Parent = dragBtn
    
    local dragging = false
    local UserInputService = game:GetService("UserInputService")
    
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
            local sliderPos = sliderBg.AbsolutePosition
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            dragBtn.Position = UDim2.new(percent, -8, -4, 0)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- Function to create buttons
local function CreateButton(parent, name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Function to populate tabs
local yPos = 5
local toggles = {}
local sliders = {}
local buttons = {}

local function PopulateTab(tabIndex)
    yPos = 5
    
    if tabIndex == 1 then -- Combat
        local toggle1 = CreateToggle(scrollingFrame, "Auto Parry", false, yPos, function(state)
            -- Auto parry logic
            print("Auto Parry:", state)
        end)
        yPos = yPos + 40
        
        local slider1 = CreateSlider(scrollingFrame, "Fast Parry", 0, 100, 50, yPos, function(value)
            -- Fast parry logic
            print("Fast Parry:", value)
        end)
        yPos = yPos + 55
        
        local toggle2 = CreateToggle(scrollingFrame, "Parry Aura", false, yPos, function(state)
            -- Parry aura logic
            print("Parry Aura:", state)
        end)
        yPos = yPos + 40
        
        local toggle3 = CreateToggle(scrollingFrame, "Auto Target", false, yPos, function(state)
            -- Auto target logic
            print("Auto Target:", state)
        end)
        yPos = yPos + 40
        
        local toggle4 = CreateToggle(scrollingFrame, "Hit Prediction", false, yPos, function(state)
            -- Hit prediction logic
            print("Hit Prediction:", state)
        end)
        yPos = yPos + 40
        
    elseif tabIndex == 2 then -- Player
        local slider1 = CreateSlider(scrollingFrame, "WalkSpeed", 16, 120, 16, yPos, function(value)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
        end)
        yPos = yPos + 55
        
        local slider2 = CreateSlider(scrollingFrame, "JumpPower", 50, 200, 50, yPos, function(value)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
            end
        end)
        yPos = yPos + 55
        
        local toggle1 = CreateToggle(scrollingFrame, "Infinite Jump", false, yPos, function(state)
            -- Infinite jump logic
            print("Infinite Jump:", state)
        end)
        yPos = yPos + 40
        
        local toggle2 = CreateToggle(scrollingFrame, "No Slow", false, yPos, function(state)
            -- No slow logic
            print("No Slow:", state)
        end)
        yPos = yPos + 40
        
        local toggle3 = CreateToggle(scrollingFrame, "Spin Bot", false, yPos, function(state)
            -- Spin bot logic
            print("Spin Bot:", state)
        end)
        yPos = yPos + 40
        
    elseif tabIndex == 3 then -- Visuals
        local toggle1 = CreateToggle(scrollingFrame, "Ball ESP", false, yPos, function(state)
            -- Ball ESP logic
            print("Ball ESP:", state)
        end)
        yPos = yPos + 40
        
        local toggle2 = CreateToggle(scrollingFrame, "Player ESP", false, yPos, function(state)
            -- Player ESP logic
            print("Player ESP:", state)
        end)
        yPos = yPos + 40
        
        local toggle3 = CreateToggle(scrollingFrame, "Highlight Ball", false, yPos, function(state)
            -- Highlight ball logic
            print("Highlight Ball:", state)
        end)
        yPos = yPos + 40
        
        local toggle4 = CreateToggle(scrollingFrame, "Tracer Lines", false, yPos, function(state)
            -- Tracer lines logic
            print("Tracer Lines:", state)
        end)
        yPos = yPos + 40
        
    elseif tabIndex == 4 then -- Misc
        local btn1 = CreateButton(scrollingFrame, "Rejoin Server", yPos, function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end)
        yPos = yPos + 40
        
        local btn2 = CreateButton(scrollingFrame, "Server Hop", yPos, function()
            -- Server hop logic
            print("Server Hop")
        end)
        yPos = yPos + 40
        
        local toggle1 = CreateToggle(scrollingFrame, "FPS Boost", false, yPos, function(state)
            -- FPS boost logic
            if state then
                settings().RenderSettings.QualityLevel = 1
            else
                settings().RenderSettings.QualityLevel = 2
            end
        end)
        yPos = yPos + 40
        
        local toggle2 = CreateToggle(scrollingFrame, "Anti AFK", false, yPos, function(state)
            -- Anti AFK logic
            print("Anti AFK:", state)
        end)
        yPos = yPos + 40
        
        local btn3 = CreateButton(scrollingFrame, "Copy Server ID", yPos, function()
            if setclipboard then
                setclipboard(game.JobId)
            end
        end)
        yPos = yPos + 40
        
    elseif tabIndex == 5 then -- Settings
        local toggle1 = CreateToggle(scrollingFrame, "Save Settings", false, yPos, function(state)
            -- Save settings logic
            print("Save Settings:", state)
        end)
        yPos = yPos + 40
        
        local toggle2 = CreateToggle(scrollingFrame, "Load Settings", false, yPos, function(state)
            -- Load settings logic
            print("Load Settings:", state)
        end)
        yPos = yPos + 40
    end
    
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- Initialize first tab
PopulateTab(1)

-- Add a subtle border
local border = Instance.new("Frame")
border.Parent = mainFrame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- Status bar at bottom
local statusBar = Instance.new("Frame")
statusBar.Parent = mainFrame
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, -25)
statusBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
statusBar.BorderSizePixel = 0

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusBar

local statusText = Instance.new("TextLabel")
statusText.Parent = statusBar
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "⚡ NebulaX Active | Press Insert to toggle"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 11

-- Keybind toggle
local UserInputService = game:GetService("UserInputService")
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

print("✨ NebulaX v0.1 - Modern UI Loaded!")
print("📍 GUI positioned at top right corner")
print("🔑 Press Insert to toggle visibility")
