-- NebulaX v0.1 - Universal South London RP GUI
-- Main Framework & Loader Script

local NebulaX = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaX"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Menu State
local menuOpen = false
local dragging = false
local dragInput, dragStart, startPos

-- Configuration
local config = {
    theme = {
        primary = Color3.fromRGB(40, 40, 50),
        secondary = Color3.fromRGB(30, 30, 40),
        accent = Color3.fromRGB(0, 255, 255), -- Cyan
        text = Color3.fromRGB(255, 255, 255),
        highlight = Color3.fromRGB(60, 60, 70)
    }
}

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 800, 0, 500)
MainWindow.Position = UDim2.new(0.5, -400, 0.5, -250)
MainWindow.BackgroundColor3 = config.theme.primary
MainWindow.BackgroundTransparency = 0.1
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true
MainWindow.Parent = ScreenGui

-- Rounded corners for main window
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainWindow

-- Shadow effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainWindow
Shadow.ZIndex = -1

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = config.theme.secondary
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NebulaX v0.1"
Title.TextColor3 = config.theme.accent
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = config.theme.highlight
CloseButton.Text = "X"
CloseButton.TextColor3 = config.theme.text
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 4)
UICorner4.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    menuOpen = false
    MainWindow.Visible = false
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = config.theme.highlight
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = config.theme.text
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 4)
UICorner5.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    menuOpen = false
end)

-- Category Buttons Container
local CategoryContainer = Instance.new("Frame")
CategoryContainer.Name = "CategoryContainer"
CategoryContainer.Size = UDim2.new(0, 150, 1, -40)
CategoryContainer.Position = UDim2.new(0, 0, 0, 40)
CategoryContainer.BackgroundColor3 = config.theme.secondary
CategoryContainer.BorderSizePixel = 0
CategoryContainer.Parent = MainWindow

local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0, 0)
UICorner6.Parent = CategoryContainer

-- Content Frame (where tabs will be displayed)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -155, 1, -45)
ContentFrame.Position = UDim2.new(0, 155, 0, 45)
ContentFrame.BackgroundColor3 = config.theme.primary
ContentFrame.BorderSizePixel = 0
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 5
ContentFrame.ScrollBarImageColor3 = config.theme.accent
ContentFrame.Parent = MainWindow

local UICorner7 = Instance.new("UICorner")
UICorner7.CornerRadius = UDim.new(0, 4)
UICorner7.Parent = ContentFrame

-- Function to create category button
function NebulaX:CreateCategoryButton(name, position)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Position = UDim2.new(0, 5, 0, position * 40)
    Button.BackgroundColor3 = config.theme.highlight
    Button.BackgroundTransparency = 0.5
    Button.Text = name
    Button.TextColor3 = config.theme.text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = CategoryContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Button
    
    return Button
end

-- Function to create toggle
function NebulaX:CreateToggle(parent, name, default, callback)
    local yPos = #parent:GetChildren() * 35
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    ToggleFrame.BackgroundColor3 = config.theme.secondary
    ToggleFrame.BackgroundTransparency = 0.5
    ToggleFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, -5, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = config.theme.text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 20)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Parent = ToggleFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = ToggleButton
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ToggleButton.Text = toggled and "ON" or "OFF"
        if callback then callback(toggled) end
    end)
    
    return ToggleFrame
end

-- Function to create slider
function NebulaX:CreateSlider(parent, name, min, max, default, callback)
    local yPos = #parent:GetChildren() * 35
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Size = UDim2.new(1, -20, 0, 45)
    SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    SliderFrame.BackgroundColor3 = config.theme.secondary
    SliderFrame.BackgroundTransparency = 0.5
    SliderFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.5, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = config.theme.text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "ValueLabel"
    ValueLabel.Size = UDim2.new(0.5, -10, 0, 20)
    ValueLabel.Position = UDim2.new(0.5, 0, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = config.theme.accent
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Parent = SliderFrame
    
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, -20, 0, 5)
    Slider.Position = UDim2.new(0, 10, 0, 30)
    Slider.BackgroundColor3 = config.theme.highlight
    Slider.Parent = SliderFrame
    
    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = config.theme.accent
    Fill.Parent = Slider
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 4)
    UICorner3.Parent = Slider
    UICorner3.Parent = Fill
    
    local dragging = false
    
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos - Slider.AbsolutePosition.X
            local percent = math.clamp(relativePos / Slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = math.floor(value * 10) / 10
            if callback then callback(value) end
        end
    end)
end

-- Function to create dropdown
function NebulaX:CreateDropdown(parent, name, options, default, callback)
    local yPos = #parent:GetChildren() * 35
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    DropdownFrame.Position = UDim2.new(0, 10, 0, yPos)
    DropdownFrame.BackgroundColor3 = config.theme.secondary
    DropdownFrame.BackgroundTransparency = 0.5
    DropdownFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.5, -5, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = config.theme.text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(0.5, -10, 1, -10)
    DropdownButton.Position = UDim2.new(0.5, 0, 0, 5)
    DropdownButton.BackgroundColor3 = config.theme.highlight
    DropdownButton.Text = default or "Select"
    DropdownButton.TextColor3 = config.theme.text
    DropdownButton.TextSize = 14
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Parent = DropdownFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = DropdownButton
    
    return DropdownFrame
end

-- Create all category buttons and their content
local categories = {
    "Combat",
    "Visuals", 
    "FOV",
    "Player",
    "Teleport",
    "Farming"
}

local currentTab = nil

-- Combat Tab
local CombatTab = Instance.new("Frame")
CombatTab.Name = "CombatTab"
CombatTab.Size = UDim2.new(1, -10, 1, -10)
CombatTab.Position = UDim2.new(0, 5, 0, 5)
CombatTab.BackgroundTransparency = 1
CombatTab.Visible = false
CombatTab.Parent = ContentFrame

NebulaX:CreateToggle(CombatTab, "Aimbot", false, function(state)
    print("Aimbot:", state)
end)

NebulaX:CreateToggle(CombatTab, "Silent Aim", false, function(state)
    print("Silent Aim:", state)
end)

NebulaX:CreateToggle(CombatTab, "Trigger Bot", false, function(state)
    print("Trigger Bot:", state)
end)

NebulaX:CreateToggle(CombatTab, "No Recoil", false, function(state)
    print("No Recoil:", state)
end)

NebulaX:CreateToggle(CombatTab, "No Spread", false, function(state)
    print("No Spread:", state)
end)

-- Visuals Tab
local VisualsTab = Instance.new("Frame")
VisualsTab.Name = "VisualsTab"
VisualsTab.Size = UDim2.new(1, -10, 1, -10)
VisualsTab.Position = UDim2.new(0, 5, 0, 5)
VisualsTab.BackgroundTransparency = 1
VisualsTab.Visible = false
VisualsTab.Parent = ContentFrame

NebulaX:CreateToggle(VisualsTab, "ESP", false, function(state)
    print("ESP:", state)
end)

NebulaX:CreateToggle(VisualsTab, "Player ESP", false, function(state)
    print("Player ESP:", state)
end)

NebulaX:CreateToggle(VisualsTab, "Name ESP", false, function(state)
    print("Name ESP:", state)
end)

NebulaX:CreateToggle(VisualsTab, "Distance ESP", false, function(state)
    print("Distance ESP:", state)
end)

NebulaX:CreateToggle(VisualsTab, "Box ESP", false, function(state)
    print("Box ESP:", state)
end)

NebulaX:CreateToggle(VisualsTab, "Health ESP", false, function(state)
    print("Health ESP:", state)
end)

-- FOV Tab
local FOVTab = Instance.new("Frame")
FOVTab.Name = "FOVTab"
FOVTab.Size = UDim2.new(1, -10, 1, -10)
FOVTab.Position = UDim2.new(0, 5, 0, 5)
FOVTab.BackgroundTransparency = 1
FOVTab.Visible = false
FOVTab.Parent = ContentFrame

NebulaX:CreateToggle(FOVTab, "FOV Circle", false, function(state)
    print("FOV Circle:", state)
end)

NebulaX:CreateSlider(FOVTab, "FOV Size", 50, 500, 150, function(value)
    print("FOV Size:", value)
end)

-- Color picker placeholder
local ColorFrame = Instance.new("Frame")
ColorFrame.Name = "ColorFrame"
ColorFrame.Size = UDim2.new(1, -20, 0, 30)
ColorFrame.Position = UDim2.new(0, 10, 0, #FOVTab:GetChildren() * 35)
ColorFrame.BackgroundColor3 = config.theme.secondary
ColorFrame.BackgroundTransparency = 0.5
ColorFrame.Parent = FOVTab

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = ColorFrame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0.5, 0, 1, 0)
Label.Position = UDim2.new(0, 10, 0, 0)
Label.BackgroundTransparency = 1
Label.Text = "FOV Color"
Label.TextColor3 = config.theme.text
Label.TextSize = 14
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Font = Enum.Font.Gotham
Label.Parent = ColorFrame

local ColorPreview = Instance.new("Frame")
ColorPreview.Size = UDim2.new(0, 30, 0, 20)
ColorPreview.Position = UDim2.new(1, -40, 0.5, -10)
ColorPreview.BackgroundColor3 = config.theme.accent
ColorPreview.Parent = ColorFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 4)
UICorner2.Parent = ColorPreview

NebulaX:CreateToggle(FOVTab, "Show / Hide FOV", true, function(state)
    print("Show FOV:", state)
end)

-- Player Tab
local PlayerTab = Instance.new("Frame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, -10, 1, -10)
PlayerTab.Position = UDim2.new(0, 5, 0, 5)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.Parent = ContentFrame

NebulaX:CreateSlider(PlayerTab, "Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed:", value)
end)

NebulaX:CreateSlider(PlayerTab, "Jump Power", 50, 200, 50, function(value)
    print("Jump Power:", value)
end)

NebulaX:CreateToggle(PlayerTab, "Infinite Jump", false, function(state)
    print("Infinite Jump:", state)
end)

NebulaX:CreateToggle(PlayerTab, "No Clip", false, function(state)
    print("No Clip:", state)
end)

-- Teleport Tab
local TeleportTab = Instance.new("Frame")
TeleportTab.Name = "TeleportTab"
TeleportTab.Size = UDim2.new(1, -10, 1, -10)
TeleportTab.Position = UDim2.new(0, 5, 0, 5)
TeleportTab.BackgroundTransparency = 1
TeleportTab.Visible = false
TeleportTab.Parent = ContentFrame

local playerList = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

NebulaX:CreateDropdown(TeleportTab, "Teleport to Player", playerList, "Select Player", function(selected)
    print("Selected Player:", selected)
end)

-- Farming Tab
local FarmingTab = Instance.new("Frame")
FarmingTab.Name = "FarmingTab"
FarmingTab.Size = UDim2.new(1, -10, 1, -10)
FarmingTab.Position = UDim2.new(0, 5, 0, 5)
FarmingTab.BackgroundTransparency = 1
FarmingTab.Visible = false
FarmingTab.Parent = ContentFrame

NebulaX:CreateToggle(FarmingTab, "Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

NebulaX:CreateToggle(FarmingTab, "Money Farm", false, function(state)
    print("Money Farm:", state)
end)

NebulaX:CreateToggle(FarmingTab, "Item Farm", false, function(state)
    print("Item Farm:", state)
end)

-- Create category buttons
for i, category in ipairs(categories) do
    local button = NebulaX:CreateCategoryButton(category, i)
    
    button.MouseButton1Click:Connect(function()
        -- Hide all tabs
        CombatTab.Visible = false
        VisualsTab.Visible = false
        FOVTab.Visible = false
        PlayerTab.Visible = false
        TeleportTab.Visible = false
        FarmingTab.Visible = false
        
        -- Show selected tab
        if category == "Combat" then
            CombatTab.Visible = true
        elseif category == "Visuals" then
            VisualsTab.Visible = true
        elseif category == "FOV" then
            FOVTab.Visible = true
        elseif category == "Player" then
            PlayerTab.Visible = true
        elseif category == "Teleport" then
            TeleportTab.Visible = true
        elseif category == "Farming" then
            FarmingTab.Visible = true
        end
        
        -- Update button appearance
        for _, btn in ipairs(CategoryContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundTransparency = 0.5
            end
        end
        button.BackgroundTransparency = 0
    end)
end

-- Set initial tab
CombatTab.Visible = true

-- Make window draggable
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- F3 Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F3 then
        menuOpen = not menuOpen
        MainWindow.Visible = menuOpen
    end
end)

-- Initialize with menu closed
MainWindow.Visible = false

print("NebulaX v0.1 loaded successfully! Press F3 to open/close the menu.")
