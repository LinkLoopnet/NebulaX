-- NebulaX v0.1 - Universal Roblox 8-Ball Pool Classic GUI
-- First Loader Script
-- Build: A unique, well-laid-out UI/UX with Insert key toggle.
-- Added: White aiming line for ball-to-hole alignment

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local guiParent = CoreGui
local NebulaX = Instance.new("ScreenGui")
local isVisible = false -- Start hidden, toggle on Insert

-- Configuration
local Theme = {
    Background = Color3.fromRGB(10, 15, 25),
    Element = Color3.fromRGB(20, 30, 45),
    Accent = Color3.fromRGB(0, 200, 255), -- Neon Cyan
    AccentSecondary = Color3.fromRGB(255, 50, 100), -- Neon Pink
    Text = Color3.fromRGB(240, 240, 240),
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(0, 150, 255),
    AimLine = Color3.fromRGB(255, 255, 255) -- Pure white for aiming line
}

-- Setup GUI Properties
NebulaX.Name = "NebulaX"
NebulaX.Parent = guiParent
NebulaX.Enabled = false -- Start disabled
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NebulaX.DisplayOrder = 100

-- Create Main Frame with Glassmorphism effect
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = NebulaX
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.ClipsDescendants = true

-- Add Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Add Stroke for outline
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Theme.Accent
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Add Drop Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Image = "rbxassetid://6014261993" -- Rounded shadow
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
Shadow.ZIndex = -1

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Theme.Element
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.5, -10, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "NebulaX v0.1 | 8-Ball Pool"
Title.TextColor3 = Theme.Accent
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

local GlowText = Instance.new("UITextSizeConstraint")
GlowText.MaxTextSize = 22
GlowText.Parent = Title

local SubText = Instance.new("TextLabel")
SubText.Name = "SubText"
SubText.Parent = Header
SubText.BackgroundTransparency = 1
SubText.Size = UDim2.new(0.5, -10, 1, 0)
SubText.Position = UDim2.new(0.5, 5, 0, 0)
SubText.Font = Enum.Font.Gotham
SubText.Text = "Universal Framework"
SubText.TextColor3 = Theme.Text
SubText.TextSize = 16
SubText.TextXAlignment = Enum.TextXAlignment.Right
SubText.TextTransparency = 0.3

-- Tab Selection Bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Theme.Element
TabBar.BackgroundTransparency = 0.3
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.Size = UDim2.new(1, 0, 0, 40)

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

-- Tab Buttons
local tabs = {"Aim Tools", "Aim/Shot Assist", "Gameplay Tools", "Visual Tools"}
local tabButtons = {}
local currentTab = "Aim Tools"

local function createTabButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Parent = TabBar
    btn.BackgroundColor3 = Theme.Element
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.TextSize = 16
    btn.TextTransparency = 0.2
    btn.ZIndex = 5
    
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Parent = btn
    underline.BackgroundColor3 = Theme.Accent
    underline.BackgroundTransparency = 1
    underline.BorderSizePixel = 0
    underline.Position = UDim2.new(0, 5, 1, -3)
    underline.Size = UDim2.new(1, -10, 0, 2)
    
    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(0, 2)
    underlineCorner.Parent = underline
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(underline, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(underline, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, v in pairs(tabButtons) do
            TweenService:Create(v.Underline, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            v.Button.TextTransparency = 0.2
        end
        TweenService:Create(underline, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        btn.TextTransparency = 0
        updateTabContent(name)
    end)
    
    table.insert(tabButtons, {Button = btn, Underline = underline})
    return btn
end

for i, name in ipairs(tabs) do
    createTabButton(name, (i-1)*0.25)
end

-- Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Theme.Background
ContentFrame.BackgroundTransparency = 0.2
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 0, 0, 90)
ContentFrame.Size = UDim2.new(1, 0, 1, -90)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Theme.Accent

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Name = "ContentList"
ContentList.Parent = ContentFrame
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 8)

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentFrame
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)

-- Aim Line Drawing System
local AimLineHolder = Instance.new("Folder")
AimLineHolder.Name = "AimLineHolder"
AimLineHolder.Parent = NebulaX

local aimLineEnabled = false
local aimLineConnections = {}

local function createAimLinePart()
    local part = Instance.new("Frame")
    part.Name = "AimLine"
    part.Parent = AimLineHolder
    part.BackgroundColor3 = Theme.AimLine
    part.BorderSizePixel = 0
    part.AnchorPoint = Vector2.new(0, 0.5)
    part.Size = UDim2.new(0, 0, 0, 2) -- Width will be set dynamically
    part.ZIndex = 1000
    part.Visible = false
    
    -- Add glow effect
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Parent = part
    glow.BackgroundColor3 = Theme.AimLine
    glow.BackgroundTransparency = 0.5
    glow.BorderSizePixel = 0
    glow.AnchorPoint = Vector2.new(0, 0.5)
    glow.Size = UDim2.new(1, 0, 1, 4)
    glow.Position = UDim2.new(0, 0, 0.5, 0)
    glow.ZIndex = 999
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow
    
    local partCorner = Instance.new("UICorner")
    partCorner.CornerRadius = UDim.new(1, 0)
    partCorner.Parent = part
    
    return part
end

local aimLineParts = {}
for i = 1, 10 do -- Create multiple line segments for dotted effect
    aimLineParts[i] = createAimLinePart()
end

local function updateAimLine()
    if not aimLineEnabled then
        for _, part in ipairs(aimLineParts) do
            part.Visible = false
        end
        return
    end
    
    -- Find cue ball and pockets
    local cueBall = nil
    local pockets = {}
    
    -- Scan for balls and pockets (simplified - adjust based on actual game structure)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            if obj.Name:lower():find("cue") or obj.Name:lower():find("white") then
                cueBall = obj
            elseif obj.Name:lower():find("pocket") or obj.Name:lower():find("hole") then
                table.insert(pockets, obj)
            end
        end
    end
    
    if not cueBall or #pockets == 0 then return end
    
    -- Find nearest pocket to mouse cursor or target ball
    local mousePos = UserInputService:GetMouseLocation()
    local camera = Workspace.CurrentCamera
    local targetPocket = nil
    local shortestDist = math.huge
    
    -- Convert mouse position to world ray
    local unitRay = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local mouseWorldOrigin = unitRay.Origin
    local mouseWorldDirection = unitRay.Direction * 1000
    
    for _, pocket in ipairs(pockets) do
        if pocket.Position then
            -- Project pocket position to screen
            local screenPos, onScreen = camera:WorldToScreenPoint(pocket.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    targetPocket = pocket
                end
            end
        end
    end
    
    if not targetPocket then return end
    
    -- Calculate direction from cue ball to target pocket
    local direction = (targetPocket.Position - cueBall.Position).Unit
    local lineLength = (targetPocket.Position - cueBall.Position).Magnitude
    
    -- Create line segments along the path
    local segmentLength = lineLength / #aimLineParts
    local gap = 5 -- Gap between segments in pixels
    
    for i, part in ipairs(aimLineParts) do
        local t = (i - 0.5) / #aimLineParts
        local point = cueBall.Position + direction * (t * lineLength)
        
        -- Convert world point to screen
        local screenPoint, onScreen = camera:WorldToScreenPoint(point)
        if onScreen then
            part.Visible = true
            part.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
            
            -- Set size based on distance and make it dotted
            local distFromCamera = (camera.CFrame.Position - point).Magnitude
            local scale = 1000 / distFromCamera
            local width = math.clamp(20 * scale, 10, 100)
            
            -- Alternate visibility for dotted effect
            if i % 2 == 0 then
                part.Size = UDim2.new(0, width, 0, 3)
                part.Glow.Size = UDim2.new(1, 0, 1, 6)
            else
                part.Size = UDim2.new(0, width, 0, 2)
                part.Glow.Size = UDim2.new(1, 0, 1, 4)
            end
            
            -- Rotate to face direction
            local angle = math.atan2(direction.Y, direction.X)
            part.Rotation = math.deg(angle)
        else
            part.Visible = false
        end
    end
end

-- Function to create a toggle item
local function createToggleItem(category, name, description, default)
    local item = Instance.new("Frame")
    item.Name = name .. "Item"
    item.Parent = ContentFrame
    item.BackgroundColor3 = Theme.Element
    item.BackgroundTransparency = 0.3
    item.BorderSizePixel = 0
    item.Size = UDim2.new(1, -10, 0, 60)
    item.LayoutOrder = #ContentFrame:GetChildren() - 2 -- approximate
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = item
    
    local itemStroke = Instance.new("UIStroke")
    itemStroke.Thickness = 1
    itemStroke.Color = Theme.Accent
    itemStroke.Transparency = 0.7
    itemStroke.Parent = item
    
    local label = Instance.new("TextLabel")
    label.Parent = item
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, -10, 0.5, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Font = Enum.Font.GothamSemibold
    label.Text = name
    label.TextColor3 = Theme.Text
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local desc = Instance.new("TextLabel")
    desc.Parent = item
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(0.7, -10, 0.5, -5)
    desc.Position = UDim2.new(0, 10, 0, 27)
    desc.Font = Enum.Font.Gotham
    desc.Text = description
    desc.TextColor3 = Theme.Text
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextTransparency = 0.3
    desc.TextWrapped = true
    
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Parent = item
    toggle.BackgroundColor3 = Theme.Background
    toggle.BackgroundTransparency = 0.3
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, -50, 0.5, -12)
    toggle.Size = UDim2.new(0, 40, 0, 24)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = toggle
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    toggleButton.ZIndex = 10
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Parent = toggle
    toggleCircle.BackgroundColor3 = Theme.Text
    toggleCircle.BackgroundTransparency = 0
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local enabled = default or false
    local function updateToggle()
        if enabled then
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentSecondary}):Play()
            itemStroke.Color = Theme.AccentSecondary
        else
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Background}):Play()
            itemStroke.Color = Theme.Accent
        end
        
        -- Special handling for Auto Aim Line
        if name == "Auto Aim Line" then
            aimLineEnabled = enabled
            if enabled then
                if #aimLineConnections == 0 then
                    table.insert(aimLineConnections, RunService.RenderStepped:Connect(updateAimLine))
                end
            else
                for _, conn in ipairs(aimLineConnections) do
                    conn:Disconnect()
                end
                aimLineConnections = {}
                for _, part in ipairs(aimLineParts) do
                    part.Visible = false
                end
            end
        end
    end
    updateToggle()
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateToggle()
        print(("[%s] %s toggled: %s"):format(category, name, enabled))
    end)
    
    return item
end

-- Function to update tab content based on selected tab
function updateTabContent(tabName)
    -- Clear existing content (except UIListLayout and UIPadding)
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if tabName == "Aim Tools" then
        createToggleItem("Aim Tools", "Auto Aim Line", "White aiming guide line from cue ball to pocket", true)
        createToggleItem("Aim Tools", "Perfect Shot Helper", "Shows the best angle for the current shot", false)
        createToggleItem("Aim Tools", "Spin Assist", "Visual indicator for cue ball spin direction", false)
        createToggleItem("Aim Tools", "Bank Shot Guide", "Highlights optimal bounce paths off walls", false)
    elseif tabName == "Aim/Shot Assist" then
        createToggleItem("Shot Assist", "100% Shot (Never Miss)", "Automatically lines up the perfect angle", false)
        createToggleItem("Shot Assist", "Auto Aim Line", "Extended guideline to the pocket", true)
        createToggleItem("Shot Assist", "Power Assist", "Shows best shot strength meter", false)
        createToggleItem("Shot Assist", "Spin Control Assist", "Helps control cue ball spin precisely", false)
        createToggleItem("Shot Assist", "Bank Shot Calculator", "Calculates and displays wall bounce shots", false)
        createToggleItem("Shot Assist", "Perfect Angle Finder", "Shows the best shot path to pocket", true)
    elseif tabName == "Gameplay Tools" then
        createToggleItem("Gameplay", "Ball Tracker", "Highlights all balls on the table", true)
        createToggleItem("Gameplay", "Hole Guide", "Shows the best pocket for current ball", false)
        createToggleItem("Gameplay", "Power Meter Assist", "Enhanced shot strength visualization", false)
        createToggleItem("Gameplay", "Turn Timer Display", "Shows remaining time for your turn", true)
    elseif tabName == "Visual Tools" then
        createToggleItem("Visual", "Ball ESP", "Glowing outline around all balls", false)
        createToggleItem("Visual", "Pocket Highlight", "Pockets glow for better visibility", true)
        createToggleItem("Visual", "Cue Trail Effect", "Shows line where cue will hit", false)
        createToggleItem("Visual", "Table Theme Changer", "Toggle between different table themes", false)
    end
    
    -- Update canvas size based on content
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
end

-- Initialize with first tab
updateTabContent("Aim Tools")
-- Set first tab underline active
TweenService:Create(tabButtons[1].Underline, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
tabButtons[1].Button.TextTransparency = 0

-- Toggle GUI on Insert key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        isVisible = not isVisible
        NebulaX.Enabled = isVisible
        -- Optional: Add tween animation for show/hide
        if isVisible then
            MainFrame:TweenPosition(UDim2.new(0.5, -350, 0.5, -250), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true)
        else
            -- Could add slide-out animation if desired
        end
    end
end)

-- Prevent GUI from being hidden by other keybinds (optional)
NebulaX.ResetOnSpawn = false

-- Example of a visual effect: subtle pulse on accent color (for header)
spawn(function()
    while true do
        wait(2)
        if NebulaX.Enabled then
            TweenService:Create(MainStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Theme.AccentSecondary}):Play()
            wait(1)
            TweenService:Create(MainStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Theme.Accent}):Play()
        else
            wait(1)
        end
    end
end)

print("NebulaX v0.1 loaded successfully with White Aim Line. Press Insert to toggle.")
