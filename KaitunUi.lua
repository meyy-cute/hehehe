
--------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

--------------------------------------------------
local Themes = {
    Dark = {
        Background = Color3.fromHex("#000000"),
        GlassOpacity = 0.4,
        PrimaryText = Color3.fromHex("#FFFFFF"),
        SecondaryText = Color3.fromHex("#808080"),
        InactiveText = Color3.fromHex("#A0A0A0"),
        RedDot = Color3.fromHex("#FF4C4C"),
        GreenDot = Color3.fromHex("#39FF14"),
        StrokeColors = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#303030")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
        }),
        DivGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#222222")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#222222"))
        }),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#D3D3D3")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#D3D3D3"))
        }),
        AcquiredGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4DCFF")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")), 
            ColorSequenceKeypoint.new(1, Color3.fromHex("#B4DCFF"))
        }),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#AAAAAA")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#222222")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
        })
    }
}

local CurrentTheme = Themes.Dark
local UI_Elements = {
    RotatingGradients = {},
    AnimatedGradients = {}
}

--------------------------------------------------
local function Create(className, properties, children)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        inst[k] = v
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

--------------------------------------------------
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--------------------------------------------------
local function ApplyTextGradient(obj, colorSeq)
    obj.TextColor3 = CurrentTheme.PrimaryText
    local grad = Create("UIGradient", {
        Color = colorSeq or CurrentTheme.TextContrast,
        Rotation = 0
    })
    grad.Parent = obj
    table.insert(UI_Elements.AnimatedGradients, grad)
    return grad
end

--------------------------------------------------
local function CreateButtonAnimation(button, scaleInst)
    button.MouseEnter:Connect(function()
        TweenService:Create(scaleInst, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1.05}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(scaleInst, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(scaleInst, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(scaleInst, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
        task.wait(0.1)
        TweenService:Create(scaleInst, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
    end)
end

--------------------------------------------------
local ScreenUI = Create("ScreenGui", {
    Name = "MeyyKaitunUI_V2",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local existing = CoreGui:FindFirstChild("MeyyKaitunUI_V2")
if existing then existing:Destroy() end
ScreenUI.Parent = CoreGui

--------------------------------------------------
local ToggleButton = Create("TextButton", {
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0, 20, 1, -65),
    BackgroundColor3 = CurrentTheme.Background,
    BackgroundTransparency = CurrentTheme.GlassOpacity,
    Text = "M",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    AnchorPoint = Vector2.new(0, 1),
    AutoButtonColor = false
}, {
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    Create("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.5
    }, {
        Create("UIGradient", {Color = CurrentTheme.StrokeColors})
    }),
    Create("UIScale", {Name = "Scale"})
})
ApplyTextGradient(ToggleButton, CurrentTheme.TextContrast)
ToggleButton.Parent = ScreenUI
MakeDraggable(ToggleButton)
CreateButtonAnimation(ToggleButton, ToggleButton.Scale)
table.insert(UI_Elements.RotatingGradients, ToggleButton.UIStroke.UIGradient)

--------------------------------------------------
local MainUI = Create("Frame", {
    Size = UDim2.new(0, 480, 0, 280),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CurrentTheme.Background,
    BackgroundTransparency = CurrentTheme.GlassOpacity,
    ClipsDescendants = false
}, {
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
    Create("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.5
    }, {
        Create("UIGradient", {Color = CurrentTheme.StrokeColors})
    }),
    Create("UIScale", {Name = "MainScale"})
})
MainUI.Parent = ScreenUI
MakeDraggable(MainUI)
table.insert(UI_Elements.RotatingGradients, MainUI.UIStroke.UIGradient)

--------------------------------------------------
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0)
}, {
    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "MEYY HUB | KAITUN STATUS",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }),
    Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -55, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 20
    }, {Create("UIScale", {Name = "Scale"})}),
    Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextSize = 15
    }, {Create("UIScale", {Name = "Scale"})})
})
ApplyTextGradient(Header.TextLabel, CurrentTheme.TextContrast)
ApplyTextGradient(Header.Minimize, CurrentTheme.TextContrast)
ApplyTextGradient(Header.Close, CurrentTheme.TextContrast)
Header.Parent = MainUI
CreateButtonAnimation(Header.Minimize, Header.Minimize.Scale)
CreateButtonAnimation(Header.Close, Header.Close.Scale)

--------------------------------------------------
local TopDivider = Create("Frame", {
    Size = UDim2.new(1, -30, 0, 1),
    Position = UDim2.new(0.5, 0, 0, 40),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0
}, {
    Create("UIGradient", {
        Color = CurrentTheme.DivGrad,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
})
TopDivider.Parent = MainUI

local BottomDivider = Create("Frame", {
    Size = UDim2.new(1, -30, 0, 1),
    Position = UDim2.new(0.5, 0, 1, -20),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0
}, {
    Create("UIGradient", {
        Color = CurrentTheme.DivGrad,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
})
BottomDivider.Parent = MainUI

--------------------------------------------------
local Body = Create("Frame", {
    Size = UDim2.new(1, 0, 1, -65),
    Position = UDim2.new(0, 0, 0, 43),
    BackgroundTransparency = 1
})
Body.Parent = MainUI

local MidDivider = Create("Frame", {
    Size = UDim2.new(0, 1, 1, -20),
    Position = UDim2.new(0.45, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0
}, {
    Create("UIGradient", {
        Color = CurrentTheme.DivGrad,
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
})
MidDivider.Parent = Body

--------------------------------------------------
local LeftCol = Create("Frame", {
    Size = UDim2.new(0.45, -15, 1, -10),
    Position = UDim2.new(0, 15, 0, 5),
    BackgroundTransparency = 1
}, {
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
})
LeftCol.Parent = Body

local function CreateStat(name)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1
    }, {
        Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = CurrentTheme.SecondaryText,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Center
        }),
        Create("TextLabel", {
            Name = "Value",
            Size = UDim2.new(1, 0, 0, 23),
            Position = UDim2.new(0, 0, 0, 12),
            BackgroundTransparency = 1,
            Text = "0",
            Font = Enum.Font.GothamBlack,
            TextSize = 22,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    })
    ApplyTextGradient(container.Value, CurrentTheme.TextContrast)
    container.Parent = LeftCol
    return container.Value
end

local StatLevel = CreateStat("LEVEL")
local StatRace = CreateStat("RACE")
local StatBeli = CreateStat("BELI")
local StatFrag = CreateStat("FRAGMENTS")
StatRace.Text = "HUMAN"

--------------------------------------------------
local RightCol = Create("Frame", {
    Size = UDim2.new(0.55, -20, 1, -10),
    Position = UDim2.new(0.45, 10, 0, 5),
    BackgroundTransparency = 1
}, {
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
})
RightCol.Parent = Body

local ItemList = {}
local function CreateItem(name)
    local wrapper = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 30, 0, 0), 
        BackgroundTransparency = 1
    }, {
        Create("Frame", {
            Name = "Dot",
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(0, 5, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = CurrentTheme.RedDot
        }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})}),
        Create("TextLabel", {
            Name = "ItemName",
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = CurrentTheme.InactiveText,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    container.Parent = wrapper
    wrapper.Parent = RightCol
    table.insert(ItemList, container)
    
    task.spawn(function()
        while task.wait() do
            if not container:FindFirstChild("Dot") then break end
            local wave = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = container.Dot.BackgroundColor3,
                ZIndex = 0
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            wave.Parent = container.Dot
            
            TweenService:Create(wave, TweenInfo.new(1 + math.sin(tick()*3)*0.2, Enum.EasingStyle.Sine), {
                Size = UDim2.new(2.5, 0, 2.5, 0),
                BackgroundTransparency = 1
            }):Play()
            game.Debris:AddItem(wave, 1.5)
            task.wait(0.8)
        end
    end)
    return container
end

local Item1 = CreateItem("Cursed Dual Katana")
local Item2 = CreateItem("Valkyrie Helm")
local Item3 = CreateItem("Item 1")
local Item4 = CreateItem("Item 2")
local Item5 = CreateItem("Item 3")

--------------------------------------------------
local MiniUI = Create("Frame", {
    Size = UDim2.new(0, 220, 0, 60),
    Position = UDim2.new(1, -240, 0, 40),
    BackgroundColor3 = CurrentTheme.Background,
    BackgroundTransparency = CurrentTheme.GlassOpacity,
    ClipsDescendants = true
}, {
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
    Create("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.5
    }, {
        Create("UIGradient", {Color = CurrentTheme.StrokeColors})
    }),
    Create("TextLabel", {
        Name = "Task",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "TARGET: STANDBY",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }),
    Create("TextLabel", {
        Name = "SubTask",
        Size = UDim2.new(1, -25, 0, 15),
        Position = UDim2.new(0, 15, 0, 30),
        BackgroundTransparency = 1,
        Text = "Doing: Waiting for command...",
        TextColor3 = CurrentTheme.SecondaryText,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }),
    Create("Frame", {
        Name = "ProgressBg",
        Size = UDim2.new(1, -30, 0, 2),
        Position = UDim2.new(0, 15, 0, 48),
        BackgroundColor3 = CurrentTheme.SecondaryText,
        BorderSizePixel = 0
    }, {
        Create("Frame", {
            Name = "Fill",
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0
        })
    })
})
ApplyTextGradient(MiniUI.Task, CurrentTheme.TextContrast)
local miniprogGrad = ApplyTextGradient(MiniUI.ProgressBg.Fill, CurrentTheme.AcquiredGrad)
MiniUI.Parent = ScreenUI
MakeDraggable(MiniUI)
table.insert(UI_Elements.RotatingGradients, MiniUI.UIStroke.UIGradient)

--------------------------------------------------
local Mini3DIcon = Create("Frame", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Visible = false
}, {
    Create("Frame", {
        Name = "Box1",
        Size = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, {
        Create("UIStroke", {Thickness = 2}, {
            Create("UIGradient", {Color = CurrentTheme.StrokeColors})
        })
    }),
    Create("Frame", {
        Name = "Box2",
        Size = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, {
        Create("UIStroke", {Color = Color3.new(1,1,1), Thickness = 1.5}, {
            Create("UIGradient", {Color = CurrentTheme.StrokeColors})
        })
    })
})
Mini3DIcon.Parent = ScreenUI
table.insert(UI_Elements.RotatingGradients, Mini3DIcon.Box1.UIStroke.UIGradient)
table.insert(UI_Elements.RotatingGradients, Mini3DIcon.Box2.UIStroke.UIGradient)

--------------------------------------------------
RunService.RenderStepped:Connect(function(dt)
    local t = tick()
    local rotation = (t * 50) % 360
    local offsetAnim = Vector2.new(math.sin(t * 2) * 0.4, 0)
    
    for _, grad in ipairs(UI_Elements.RotatingGradients) do
        if grad and grad.Parent then
            grad.Rotation = rotation
        end
    end
    
    for _, grad in ipairs(UI_Elements.AnimatedGradients) do
        if grad and grad.Parent then
            grad.Offset = offsetAnim
        end
    end
    
    if Mini3DIcon.Visible then
        Mini3DIcon.Box1.Rotation = rotation
        Mini3DIcon.Box2.Rotation = -rotation
        Mini3DIcon.Box1.Size = UDim2.new(0, 40 + 20 * math.sin(t*2), 0, 40 + 20 * math.cos(t*2))
        Mini3DIcon.Box2.Size = UDim2.new(0, 40 + 20 * math.cos(t*2), 0, 40 + 20 * math.sin(t*2))
    end
end)

--------------------------------------------------
local function AnimateNumber(label, targetVal)
    local numVal = Instance.new("NumberValue")
    numVal.Value = 0
    numVal.Changed:Connect(function()
        local formatted = tostring(math.floor(numVal.Value)):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
        label.Text = formatted
    end)
    local tw = TweenService:Create(numVal, TweenInfo.new(2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Value = targetVal})
    tw:Play()
    tw.Completed:Connect(function() numVal:Destroy() end)
end

--------------------------------------------------
local function SetItemAcquired(itemUI)
    TweenService:Create(itemUI.Dot, TweenInfo.new(0.5), {BackgroundColor3 = CurrentTheme.GreenDot}):Play()
    
    local txtGrad = ApplyTextGradient(itemUI.ItemName, CurrentTheme.AcquiredGrad)
    itemUI.ItemName.TextTransparency = 1
    
    TweenService:Create(itemUI.ItemName, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
end

--------------------------------------------------
local function UpdateMiniTask(newTask, newSubTask)
    local oldTask = MiniUI.Task:Clone()
    oldTask.Parent = MiniUI
    TweenService:Create(oldTask, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Position = UDim2.new(0, 10, 0, -20), TextTransparency = 1
    }):Play()
    game.Debris:AddItem(oldTask, 0.4)
    
    MiniUI.Task.Position = UDim2.new(0, 10, 0, 30)
    MiniUI.Task.TextTransparency = 1
    MiniUI.Task.Text = newTask
    TweenService:Create(MiniUI.Task, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Position = UDim2.new(0, 10, 0, 10), TextTransparency = 0
    }):Play()
    
    MiniUI.SubTask.Text = newSubTask
end

local function AnimateMiniProgress()
    local fill = MiniUI.ProgressBg.Fill
    fill.Size = UDim2.new(0, 0, 1, 0)
    local tw = TweenService:Create(fill, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tw:Play()
    
    tw.Completed:Connect(function()
        TweenService:Create(fill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        task.wait(0.5)
        TweenService:Create(fill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    end)
end

--------------------------------------------------
local isMinimizing = false
Header.Minimize.MouseButton1Click:Connect(function()
    if isMinimizing then return end
    isMinimizing = true
    TweenService:Create(MainUI.MainScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
    task.wait(0.4)
    MainUI.Visible = false
    Mini3DIcon.Visible = true
    Mini3DIcon.Position = MainUI.Position
    TweenService:Create(Mini3DIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    isMinimizing = false
end)

Mini3DIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        TweenService:Create(Mini3DIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        Mini3DIcon.Visible = false
        MainUI.Visible = true
        TweenService:Create(MainUI.MainScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end
end)

Header.Close.MouseButton1Click:Connect(function()
    TweenService:Create(MainUI.MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
    TweenService:Create(MiniUI, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 200, 0, 40)}):Play()
    task.wait(0.3)
    ScreenUI:Destroy()
end)

local toggled = true
ToggleButton.MouseButton1Click:Connect(function()
    toggled = not toggled
    if toggled then
        MainUI.Visible = true
        MiniUI.Visible = true
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(MainUI.MainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Background}):Play()
    else
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.7, 0)}):Play()
        TweenService:Create(MainUI.MainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromHex("#505050")}):Play()
        task.wait(0.5)
        MainUI.Visible = false
        MiniUI.Visible = false
    end
end)

--------------------------------------------------
local function CascadeItems()
    for i, item in ipairs(ItemList) do
        task.wait(0.05)
        TweenService:Create(item, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end
end

--------------------------------------------------
task.spawn(function()
    MainUI.Position = UDim2.new(0.5, 0, 0.6, 0)
    MainUI.MainScale.Scale = 0
    TweenService:Create(MainUI, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(MainUI.MainScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    
    task.wait(0.2)
    CascadeItems()
    
    AnimateNumber(StatLevel, 2800)
    AnimateNumber(StatBeli, 19555559)
    AnimateNumber(StatFrag, 150000)
    
    task.wait(1.5)
    SetItemAcquired(Item1)
    
    task.wait(0.5)
    UpdateMiniTask("TARGET: FARM LEVEL", "Doing: Defeating Island Monsters...")
    AnimateMiniProgress()
    
    task.wait(2)
    SetItemAcquired(Item2)
end)
--------------------------------------------------


