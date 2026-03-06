-- NebulaX v0.1 - Universal Roblox LOCOfficial! GUI
-- Professional UI/UX Framework with Insert Key Toggle

local NebulaX = {}
NebulaX.__index = NebulaX

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Constants
local COLORS = {
    Background = Color3.fromRGB(18, 20, 28),
    Surface = Color3.fromRGB(28, 32, 42),
    Primary = Color3.fromRGB(105, 108, 255), -- Nebula indigo
    PrimaryDark = Color3.fromRGB(75, 78, 200),
    Text = Color3.fromRGB(240, 242, 255),
    TextMuted = Color3.fromRGB(160, 170, 200),
    Border = Color3.fromRGB(50, 55, 70),
    Success = Color3.fromRGB(70, 210, 140),
    Warning = Color3.fromRGB(255, 190, 80),
    Danger = Color3.fromRGB(255, 85, 100),
    Card = Color3.fromRGB(38, 42, 55)
}

-- Utility functions
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Children" then
            obj[k] = v
        end
    end
    if props.Children then
        for _, child in ipairs(props.Children) do
            child.Parent = obj
        end
    end
    return obj
end

local function AddShadow(parent, thickness, transparency, sizeOffset)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Size = UDim2.new(1, sizeOffset or 20, 1, sizeOffset or 20),
        Position = UDim2.new(0, -(sizeOffset or 20)/2, 0, -(sizeOffset or 20)/2),
        ZIndex = parent.ZIndex - 1,
        Parent = parent
    })
    return shadow
end

local function createToggle(parent, text, default, callback)
    local container = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = COLORS.Card,
        Size = UDim2.new(1, -12, 0, 40),
        AutomaticSize = Enum.AutomaticSize.None,
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 1,
                Transparency = 0.5
            })
        }
    })
    
    local label = Create("TextLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleBg = Create("Frame", {
        Parent = container,
        BackgroundColor3 = default and COLORS.Primary or COLORS.Border,
        Position = UDim2.new(1, -52, 0.5, -10),
        Size = UDim2.new(0, 40, 0, 20),
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        }
    })
    
    local toggleKnob = Create("Frame", {
        Parent = toggleBg,
        BackgroundColor3 = COLORS.Text,
        Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 0.5
            })
        }
    })
    
    local state = default
    local button = Create("TextButton", {
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    
    button.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and COLORS.Primary or COLORS.Border}):Play()
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(state)
    end)
    
    return container
end

local function createButton(parent, text, icon, callback)
    local button = Create("TextButton", {
        Parent = parent,
        BackgroundColor3 = COLORS.Card,
        Size = UDim2.new(1, -12, 0, 40),
        Font = Enum.Font.Gotham,
        Text = "",
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 1,
                Transparency = 0.5
            })
        }
    })
    
    if icon then
        Create("ImageLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = icon,
            ImageColor3 = COLORS.Text
        })
    end
    
    Create("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 44 or 12, 0, 0),
        Size = UDim2.new(1, icon and -56 or -24, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Primary:lerp(COLORS.Card, 0.3)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Card}):Play()
    end)
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Main GUI Builder
function NebulaX:Build()
    -- Check for existing
    local existing = CoreGui:FindFirstChild("NebulaX")
    if existing then existing:Destroy() end
    
    -- Main ScreenGui
    local GUI = Create("ScreenGui", {
        Name = "NebulaX",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Container (for open/close animation)
    local MainContainer = Create("Frame", {
        Parent = GUI,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    
    -- Main Frame (Card style)
    local Main = Create("Frame", {
        Name = "Main",
        Parent = MainContainer,
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Size = UDim2.new(0, 700, 0, 500),
        ClipsDescendants = true,
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 1.5,
                Transparency = 0.3
            })
        }
    })
    AddShadow(Main, 10, 0.7, 40)
    
    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 60),
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 1,
                Transparency = 0.3
            })
        }
    })
    
    -- Title with gradient
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0, 300, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "NebulaX v0.1",
        TextColor3 = COLORS.Text,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 30),
        Size = UDim2.new(0, 300, 1, -30),
        Font = Enum.Font.Gotham,
        Text = "Universal Roblox LOCOfficial",
        TextColor3 = COLORS.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Header Buttons
    local HeaderButtons = Create("Frame", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -120, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        Children = {
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8)
            })
        }
    })
    
    -- Rejoin button
    do
        local btn = Create("ImageButton", {
            Parent = HeaderButtons,
            BackgroundTransparency = 1,
            Image = "rbxassetid://6031094678",
            ImageColor3 = COLORS.TextMuted,
            Size = UDim2.new(0, 30, 0, 30),
            Children = {
                Create("UICorner", { CornerRadius = UDim.new(0, 8) })
            }
        })
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.Text}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.TextMuted}):Play() end)
        btn.MouseButton1Click:Connect(function()
            local ts = game:GetService("TeleportService")
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
    
    -- Copy JobID button
    do
        local btn = Create("ImageButton", {
            Parent = HeaderButtons,
            BackgroundTransparency = 1,
            Image = "rbxassetid://6031288002",
            ImageColor3 = COLORS.TextMuted,
            Size = UDim2.new(0, 30, 0, 30)
        })
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.Text}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.TextMuted}):Play() end)
        btn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(game.JobId)
                btn.ImageColor3 = COLORS.Success
                task.wait(0.3)
                btn.ImageColor3 = COLORS.TextMuted
            end
        end)
    end
    
    -- Destroy GUI button
    do
        local btn = Create("ImageButton", {
            Parent = HeaderButtons,
            BackgroundTransparency = 1,
            Image = "rbxassetid://6031094851",
            ImageColor3 = COLORS.TextMuted,
            Size = UDim2.new(0, 30, 0, 30)
        })
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.Danger}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = COLORS.TextMuted}):Play() end)
        btn.MouseButton1Click:Connect(function() GUI:Destroy() end)
    end
    
    -- Category Bar
    local CategoryBar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(0, 160, 1, -60),
        Children = {
            Create("UIStroke", {
                Color = COLORS.Border,
                Thickness = 1,
                Transparency = 0.3
            }),
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 20),
                PaddingBottom = UDim.new(0, 20)
            }),
            Create("UIListLayout", {
                Name = "Layout",
                Padding = UDim.new(0, 4),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
        }
    })
    
    -- Pages Container
    local PagesContainer = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 160, 0, 60),
        Size = UDim2.new(1, -160, 1, -60),
        Children = {
            Create("UICorner", { CornerRadius = UDim.new(0, 16) })
        }
    })
    
    -- Pages
    local pages = {}
    local categoryButtons = {}
    
    -- Home Page
    pages.Home = Create("ScrollingFrame", {
        Parent = PagesContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = COLORS.Primary,
        Visible = true,
        Children = {
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 16),
                PaddingBottom = UDim.new(0, 16)
            })
        }
    })
    
    -- Home Page Content
    createButton(pages.Home, "Rejoin Server", "rbxassetid://6031094678", function()
        local ts = game:GetService("TeleportService")
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    
    createButton(pages.Home, "Copy Job ID", "rbxassetid://6031288002", function()
        if setclipboard then
            setclipboard(game.JobId)
        end
    end)
    
    createButton(pages.Home, "Destroy GUI", "rbxassetid://6031094851", function()
        GUI:Destroy()
    end)
    
    -- Card Tools Page
    pages["Card Tools"] = Create("ScrollingFrame", {
        Parent = PagesContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = COLORS.Primary,
        Visible = false,
        Children = {
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 16),
                PaddingBottom = UDim.new(0, 16)
            })
        }
    })
    
    createToggle(pages["Card Tools"], "Show All Cards", false, function(state) print("Show All Cards:", state) end)
    createToggle(pages["Card Tools"], "Highlight Playable Cards", true, function(state) print("Highlight Playable Cards:", state) end)
    createToggle(pages["Card Tools"], "Card Counter", true, function(state) print("Card Counter:", state) end)
    createToggle(pages["Card Tools"], "Deck Viewer", false, function(state) print("Deck Viewer:", state) end)
    createToggle(pages["Card Tools"], "Auto Sort Cards", false, function(state) print("Auto Sort Cards:", state) end)
    
    -- Player ESP Page
    pages["Player ESP"] = Create("ScrollingFrame", {
        Parent = PagesContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = COLORS.Primary,
        Visible = false,
        Children = {
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 16),
                PaddingBottom = UDim.new(0, 16)
            })
        }
    })
    
    createToggle(pages["Player ESP"], "Player ESP", false, function(state) print("Player ESP:", state) end)
    createToggle(pages["Player ESP"], "Name ESP", true, function(state) print("Name ESP:", state) end)
    createToggle(pages["Player ESP"], "Highlight Player Turn", false, function(state) print("Highlight Player Turn:", state) end)
    createToggle(pages["Player ESP"], "Tracer Lines", false, function(state) print("Tracer Lines:", state) end)
    createToggle(pages["Player ESP"], "Show Card Count", true, function(state) print("Show Card Count:", state) end)
    
    -- Settings Page
    pages.Settings = Create("ScrollingFrame", {
        Parent = PagesContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = COLORS.Primary,
        Visible = false,
        Children = {
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 16),
                PaddingBottom = UDim.new(0, 16)
            })
        }
    })
    
    -- Theme Color Picker (simulated)
    createButton(pages.Settings, "UI Theme Color", "rbxassetid://6034508245", function()
        -- Cycle theme colors
        COLORS.Primary = COLORS.Primary == Color3.fromRGB(105, 108, 255) and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(105, 108, 255)
    end)
    
    createButton(pages.Settings, "Reset GUI", "rbxassetid://6034819442", function()
        Main.Position = UDim2.new(0.5, -350, 0.5, -250)
    end)
    
    createButton(pages.Settings, "Close GUI", "rbxassetid://6031094851", function()
        -- Animate close
        local closeTween = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            Main.Visible = false
        end)
    end)
    
    -- Category Buttons
    local categories = {"Home", "Card Tools", "Player ESP", "Settings"}
    local icons = {
        Home = "rbxassetid://6034507788",
        ["Card Tools"] = "rbxassetid://6034508136",
        ["Player ESP"] = "rbxassetid://6034507970",
        Settings = "rbxassetid://6034508191"
    }
    
    for _, catName in ipairs(categories) do
        local btn = Create("TextButton", {
            Parent = CategoryBar,
            BackgroundColor3 = catName == "Home" and COLORS.Primary or COLORS.Card,
            Size = UDim2.new(0, 140, 0, 45),
            Font = Enum.Font.Gotham,
            Text = "",
            Children = {
                Create("UICorner", { CornerRadius = UDim.new(0, 10) })
            }
        })
        
        local icon = Create("ImageLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = icons[catName],
            ImageColor3 = catName == "Home" and COLORS.Text or COLORS.TextMuted
        })
        
        local label = Create("TextLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 44, 0, 0),
            Size = UDim2.new(1, -52, 1, 0),
            Font = Enum.Font.Gotham,
            Text = catName,
            TextColor3 = catName == "Home" and COLORS.Text or COLORS.TextMuted,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        categoryButtons[catName] = {btn = btn, icon = icon, label = label}
        
        btn.MouseButton1Click:Connect(function()
            -- Update active category
            for name, data in pairs(categoryButtons) do
                local isActive = (name == catName)
                TweenService:Create(data.btn, TweenInfo.new(0.2), {BackgroundColor3 = isActive and COLORS.Primary or COLORS.Card}):Play()
                TweenService:Create(data.icon, TweenInfo.new(0.2), {ImageColor3 = isActive and COLORS.Text or COLORS.TextMuted}):Play()
                TweenService:Create(data.label, TweenInfo.new(0.2), {TextColor3 = isActive and COLORS.Text or COLORS.TextMuted}):Play()
                pages[name].Visible = (name == catName)
            end
        end)
    end
    
    -- Open/Close with Insert key
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            guiVisible = not guiVisible
            
            if guiVisible then
                Main.Visible = true
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 700, 0, 500),
                    Position = UDim2.new(0.5, -350, 0.5, -250)
                }):Play()
            else
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                -- Hide after animation
                task.wait(0.3)
                if not guiVisible then
                    Main.Visible = false
                end
            end
        end
    end)
    
    -- Make GUI draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return GUI
end

-- Initialize
NebulaX:Build()
