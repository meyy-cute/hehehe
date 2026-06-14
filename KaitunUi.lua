
---------
---------
---------
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

---------
---------
local Theme = {
    Background = Color3.fromRGB(12, 12, 12),
    Darker = Color3.fromRGB(8, 8, 8),
    PillBack = Color3.fromRGB(20, 25, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 140),
    Active = Color3.fromRGB(136, 136, 136),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(80, 220, 120),
    Blue = Color3.fromRGB(80, 180, 255),
    Grad3Layer = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    }),
    StrokeGrad = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
}

---------
---------
local UI_Elements = {}
local ActiveWaves = {}
local StrokeGradients = {}

---------
---------
local KaitunGui = Instance.new("ScreenGui")
KaitunGui.Name = "MeyyKaitunHub"
KaitunGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KaitunGui.ResetOnSpawn = false

if gethui then
    KaitunGui.Parent = gethui()
else
    KaitunGui.Parent = CoreGui
end

---------
---------
local function MakeDraggable(topbar, object)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

---------
---------
local function FormatNumber(n)
    n = tostring(math.floor(n))
    return n:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

---------
---------
local function CreateButtonEffects(button)
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1.05}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)

    button.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
    end)

    button.MouseButton1Up:Connect(function()
        local t1 = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1.3})
        t1:Play()
        t1.Completed:Connect(function()
            TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
end

---------
---------
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Name = "ToggleFrame"
ToggleFrame.Size = UDim2.new(0, 50, 0, 50)
ToggleFrame.Position = UDim2.new(0, 20, 1, -70)
ToggleFrame.BackgroundColor3 = Theme.Background
ToggleFrame.BackgroundTransparency = 0.4
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Parent = KaitunGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleFrame

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleFrame

local ToggleGrad = Instance.new("UIGradient")
ToggleGrad.Color = Theme.StrokeGrad
ToggleGrad.Parent = ToggleStroke
table.insert(StrokeGradients, ToggleGrad)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "UI"
ToggleButton.TextColor3 = Theme.Text
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = ToggleFrame
CreateButtonEffects(ToggleButton)
MakeDraggable(ToggleFrame, ToggleFrame)

local ToggleTextGrad = Instance.new("UIGradient")
ToggleTextGrad.Color = Theme.Grad3Layer
ToggleTextGrad.Rotation = 90
ToggleTextGrad.Parent = ToggleButton

---------
---------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = KaitunGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local MainStrokeGrad = Instance.new("UIGradient")
MainStrokeGrad.Color = Theme.StrokeGrad
MainStrokeGrad.Parent = MainStroke
table.insert(StrokeGradients, MainStrokeGrad)

MakeDraggable(MainFrame, MainFrame)

---------
---------
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MEYY HUB | ACCOUNT STATS"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = Theme.Grad3Layer
TitleGrad.Rotation = 90
TitleGrad.Parent = Title

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header
CreateButtonEffects(CloseBtn)

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -60, 0.5, -10)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextDim
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header
CreateButtonEffects(MinBtn)

local HDivider = Instance.new("Frame")
HDivider.Name = "HDivider"
HDivider.Size = UDim2.new(0.9, 0, 0, 1)
HDivider.Position = UDim2.new(0.05, 0, 0, 40)
HDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HDivider.BorderSizePixel = 0
HDivider.Parent = MainFrame

local HDivGrad = Instance.new("UIGradient")
HDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.6),
    NumberSequenceKeypoint.new(1, 1)
})
HDivGrad.Parent = HDivider

---------
---------
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 1, -95)
Body.Position = UDim2.new(0, 0, 0, 45)
Body.BackgroundTransparency = 1
Body.Parent = MainFrame

local LeftCol = Instance.new("Frame")
LeftCol.Name = "LeftCol"
LeftCol.Size = UDim2.new(0.45, 0, 1, 0)
LeftCol.Position = UDim2.new(0, 25, 0, 10)
LeftCol.BackgroundTransparency = 1
LeftCol.Parent = Body

local RightCol = Instance.new("Frame")
RightCol.Name = "RightCol"
RightCol.Size = UDim2.new(0.45, 0, 1, 0)
RightCol.Position = UDim2.new(0.5, 10, 0, 10)
RightCol.BackgroundTransparency = 1
RightCol.Parent = Body

---------
---------
local function CreateStatBlock(parent, titleText, posY, isHighlight)
    local Block = Instance.new("Frame")
    Block.Size = UDim2.new(1, 0, 0, 45)
    Block.Position = UDim2.new(0, 0, posY, 0)
    Block.BackgroundTransparency = 1
    Block.Parent = parent

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, 0, 0, 15)
    TitleLbl.Position = UDim2.new(0, 0, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = titleText
    TitleLbl.TextColor3 = Theme.TextDim
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Block

    local ValueLbl = Instance.new("TextLabel")
    ValueLbl.Size = UDim2.new(1, 0, 0, 30)
    ValueLbl.Position = UDim2.new(0, 0, 0, 15)
    ValueLbl.BackgroundTransparency = 1
    ValueLbl.Text = "0"
    ValueLbl.TextColor3 = isHighlight and Theme.Blue or Theme.Text
    ValueLbl.Font = Enum.Font.GothamBold
    ValueLbl.TextSize = isHighlight and 28 or 18
    ValueLbl.TextXAlignment = Enum.TextXAlignment.Left
    ValueLbl.Parent = Block

    if not isHighlight then
        local ValGrad = Instance.new("UIGradient")
        ValGrad.Color = Theme.Grad3Layer
        ValGrad.Rotation = 90
        ValGrad.Parent = ValueLbl
    end

    return ValueLbl
end

local LevelVal = CreateStatBlock(LeftCol, "LEVEL", 0, true)
local RaceVal = CreateStatBlock(LeftCol, "RACE", 0.25, false)
local BeliVal = CreateStatBlock(LeftCol, "BELI", 0.5, false)
local FragVal = CreateStatBlock(LeftCol, "FRAGMENTS", 0.75, false)

RaceVal.Text = "Human"

---------
---------
local ItemsTitle = Instance.new("TextLabel")
ItemsTitle.Size = UDim2.new(1, 0, 0, 15)
ItemsTitle.Position = UDim2.new(0, 15, 0, 0)
ItemsTitle.BackgroundTransparency = 1
ItemsTitle.Text = "ITEMS"
ItemsTitle.TextColor3 = Theme.TextDim
ItemsTitle.Font = Enum.Font.GothamBold
ItemsTitle.TextSize = 10
ItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
ItemsTitle.Parent = RightCol

local ItemLabels = {}

local function CreateItemRow(parent, itemName, index)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 20)
    Row.Position = UDim2.new(0, 15, 0, (index * 25))
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local RingBase = Instance.new("Frame")
    RingBase.Size = UDim2.new(0, 20, 0, 20)
    RingBase.Position = UDim2.new(0, -15, 0, 0)
    RingBase.BackgroundTransparency = 1
    RingBase.Parent = Row

    local CenterDot = Instance.new("Frame")
    CenterDot.Size = UDim2.new(0, 4, 0, 4)
    CenterDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    CenterDot.BackgroundColor3 = Theme.Red
    CenterDot.BorderSizePixel = 0
    CenterDot.Parent = RingBase
    Instance.new("UICorner", CenterDot).CornerRadius = UDim.new(1, 0)

    local Wave1 = Instance.new("Frame")
    Wave1.Size = UDim2.new(0, 4, 0, 4)
    Wave1.Position = UDim2.new(0.5, -2, 0.5, -2)
    Wave1.BackgroundColor3 = Theme.Red
    Wave1.BackgroundTransparency = 0.5
    Wave1.BorderSizePixel = 0
    Wave1.Parent = RingBase
    Instance.new("UICorner", Wave1).CornerRadius = UDim.new(1, 0)

    local Wave2 = Instance.new("Frame")
    Wave2.Size = UDim2.new(0, 4, 0, 4)
    Wave2.Position = UDim2.new(0.5, -2, 0.5, -2)
    Wave2.BackgroundColor3 = Theme.Red
    Wave2.BackgroundTransparency = 0.8
    Wave2.BorderSizePixel = 0
    Wave2.Parent = RingBase
    Instance.new("UICorner", Wave2).CornerRadius = UDim.new(1, 0)

    local ItemText = Instance.new("TextLabel")
    ItemText.Size = UDim2.new(1, -5, 1, 0)
    ItemText.Position = UDim2.new(0, 5, 0, 0)
    ItemText.BackgroundTransparency = 1
    ItemText.Text = itemName
    ItemText.TextColor3 = Theme.TextDim
    ItemText.Font = Enum.Font.GothamBold
    ItemText.TextSize = 12
    ItemText.TextXAlignment = Enum.TextXAlignment.Left
    ItemText.Parent = Row

    local ItemGrad = Instance.new("UIGradient")
    ItemGrad.Color = Theme.Grad3Layer
    ItemGrad.Rotation = 90
    ItemGrad.Enabled = false
    ItemGrad.Parent = ItemText

    local itemData = {
        Row = Row,
        CenterDot = CenterDot,
        Wave1 = Wave1,
        Wave2 = Wave2,
        Text = ItemText,
        Grad = ItemGrad,
        HasItem = false,
        Index = index
    }

    table.insert(ItemLabels, itemData)
    table.insert(ActiveWaves, itemData)

    return itemData
end

CreateItemRow(RightCol, "Cursed Dual Katana", 1)
CreateItemRow(RightCol, "Valkyrie Helm", 2)
CreateItemRow(RightCol, "Skull Guitar", 3)
CreateItemRow(RightCol, "Mirror Fractal", 4)
CreateItemRow(RightCol, "Pull Lever", 5)

---------
---------
local StatusPill = Instance.new("Frame")
StatusPill.Name = "StatusPill"
StatusPill.Size = UDim2.new(1, -50, 0, 30)
StatusPill.Position = UDim2.new(0, 25, 1, -45)
StatusPill.BackgroundColor3 = Theme.PillBack
StatusPill.BackgroundTransparency = 0.3
StatusPill.BorderSizePixel = 0
StatusPill.Parent = MainFrame

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(0, 6)
PillCorner.Parent = StatusPill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 60, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "STATUS"
StatusLabel.TextColor3 = Theme.TextDim
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusPill

local StatusDotFrame = Instance.new("Frame")
StatusDotFrame.Size = UDim2.new(0, 16, 0, 16)
StatusDotFrame.Position = UDim2.new(0, 65, 0.5, -8)
StatusDotFrame.BackgroundTransparency = 1
StatusDotFrame.Parent = StatusPill

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 4, 0, 4)
StatusDot.Position = UDim2.new(0.5, -2, 0.5, -2)
StatusDot.BackgroundColor3 = Theme.Green
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusDotFrame
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusAction = Instance.new("TextLabel")
StatusAction.Size = UDim2.new(1, -100, 1, 0)
StatusAction.Position = UDim2.new(0, 85, 0, 0)
StatusAction.BackgroundTransparency = 1
StatusAction.Text = "Buying Melee"
StatusAction.TextColor3 = Theme.Text
StatusAction.Font = Enum.Font.GothamBold
StatusAction.TextSize = 12
StatusAction.TextXAlignment = Enum.TextXAlignment.Left
StatusAction.Parent = StatusPill

---------
---------
local MiniUI = Instance.new("Frame")
MiniUI.Name = "MiniUI"
MiniUI.Size = UDim2.new(0, 220, 0, 60)
MiniUI.Position = UDim2.new(1, -240, 0, 20)
MiniUI.BackgroundColor3 = Theme.Background
MiniUI.BackgroundTransparency = 0.4
MiniUI.BorderSizePixel = 0
MiniUI.ClipsDescendants = true
MiniUI.Parent = KaitunGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = MiniUI

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 255, 255)
MiniStroke.Thickness = 1.5
MiniStroke.Parent = MiniUI

local MiniStrokeGrad = Instance.new("UIGradient")
MiniStrokeGrad.Color = Theme.StrokeGrad
MiniStrokeGrad.Parent = MiniStroke
table.insert(StrokeGradients, MiniStrokeGrad)

MakeDraggable(MiniUI, MiniUI)

local TaskContainer = Instance.new("Frame")
TaskContainer.Name = "TaskContainer"
TaskContainer.Size = UDim2.new(1, 0, 1, 0)
TaskContainer.Position = UDim2.new(0, 0, 0, 0)
TaskContainer.BackgroundTransparency = 1
TaskContainer.Parent = MiniUI

local MainTask = Instance.new("TextLabel")
MainTask.Name = "MainTask"
MainTask.Size = UDim2.new(1, -20, 0, 20)
MainTask.Position = UDim2.new(0, 10, 0, 12)
MainTask.BackgroundTransparency = 1
MainTask.Text = "TARGET: STANDBY"
MainTask.TextColor3 = Theme.Text
MainTask.Font = Enum.Font.GothamBold
MainTask.TextSize = 13
MainTask.TextXAlignment = Enum.TextXAlignment.Left
MainTask.Parent = TaskContainer

local MainTaskGrad = Instance.new("UIGradient")
MainTaskGrad.Color = Theme.Grad3Layer
MainTaskGrad.Rotation = 90
MainTaskGrad.Parent = MainTask

local SubTask = Instance.new("TextLabel")
SubTask.Name = "SubTask"
SubTask.Size = UDim2.new(1, -30, 0, 15)
SubTask.Position = UDim2.new(0, 20, 0, 32)
SubTask.BackgroundTransparency = 1
SubTask.Text = "Doing: Waiting for input..."
SubTask.TextColor3 = Theme.TextDim
SubTask.Font = Enum.Font.GothamBold
SubTask.TextSize = 11
SubTask.TextXAlignment = Enum.TextXAlignment.Left
SubTask.Parent = TaskContainer

---------
---------
local function TweenNumber(label, targetValue)
    local startTime = tick()
    local duration = 2.0
    local connection

    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local t = math.clamp(elapsed / duration, 0, 1)
        
        local ts = t - 1
        local s = 1.70158
        local value = targetValue * (ts * ts * ((s + 1) * ts + s) + 1)
        
        if value < 0 then value = 0 end
        
        label.Text = FormatNumber(value)
        
        if elapsed >= duration then
            label.Text = FormatNumber(targetValue)
            connection:Disconnect()
        end
    end)
end

---------
---------
local function SetItemState(index, hasItem)
    local item = ItemLabels[index]
    if not item then return end
    
    item.HasItem = hasItem
    
    if hasItem then
        TweenService:Create(item.CenterDot, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Green}):Play()
        TweenService:Create(item.Wave1, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Green}):Play()
        TweenService:Create(item.Wave2, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Green}):Play()
        
        TweenService:Create(item.Text, TweenInfo.new(0.5), {TextColor3 = Theme.Text}):Play()
        item.Grad.Enabled = true
    else
        TweenService:Create(item.CenterDot, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Red}):Play()
        TweenService:Create(item.Wave1, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Red}):Play()
        TweenService:Create(item.Wave2, TweenInfo.new(0.5), {BackgroundColor3 = Theme.Red}):Play()
        
        TweenService:Create(item.Text, TweenInfo.new(0.5), {TextColor3 = Theme.TextDim}):Play()
        item.Grad.Enabled = false
    end
end

---------
---------
local function CascadeItems()
    for _, item in ipairs(ItemLabels) do
        item.Row.Position = UDim2.new(0, 50, 0, (item.Index * 25))
        item.Row.GroupTransparency = 1
    end
    
    for _, item in ipairs(ItemLabels) do
        TweenService:Create(item.Row, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 15, 0, (item.Index * 25)),
            GroupTransparency = 0
        }):Play()
        task.wait(0.05)
    end
end

---------
---------
local function UpdateMiniTask(newMain, newSub)
    local oldMain = MainTask:Clone()
    local oldSub = SubTask:Clone()
    oldMain.Parent = TaskContainer
    oldSub.Parent = TaskContainer
    
    MainTask.Text = newMain
    SubTask.Text = newSub
    MainTask.Position = UDim2.new(0, 10, 0, 32)
    SubTask.Position = UDim2.new(0, 20, 0, 52)
    MainTask.TextTransparency = 1
    SubTask.TextTransparency = 1
    MainTaskGrad.Parent = MainTask
    
    TweenService:Create(oldMain, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0, 10, 0, -8), TextTransparency = 1}):Play()
    TweenService:Create(oldSub, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0, 20, 0, 12), TextTransparency = 1}):Play()
    
    TweenService:Create(MainTask, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 12), TextTransparency = 0}):Play()
    TweenService:Create(SubTask, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, 32), TextTransparency = 0}):Play()
    
    task.wait(0.5)
    oldMain:Destroy()
    oldSub:Destroy()
end

---------
---------
local isMainVisible = true
local isMini3D = false

local Mini3DIcon = Instance.new("Frame")
Mini3DIcon.Name = "Mini3DIcon"
Mini3DIcon.Size = UDim2.new(0, 60, 0, 60)
Mini3DIcon.Position = UDim2.new(0.5, -30, 0.5, -30)
Mini3DIcon.BackgroundColor3 = Theme.Background
Mini3DIcon.BackgroundTransparency = 0.2
Mini3DIcon.Visible = false
Mini3DIcon.Parent = KaitunGui
Instance.new("UICorner", Mini3DIcon).CornerRadius = UDim.new(0, 12)
local IconStroke = Instance.new("UIStroke", Mini3DIcon)
IconStroke.Color = Color3.fromRGB(255,255,255)
IconStroke.Thickness = 2
local IconGrad = Instance.new("UIGradient", IconStroke)
IconGrad.Color = Theme.StrokeGrad
table.insert(StrokeGradients, IconGrad)
MakeDraggable(Mini3DIcon, Mini3DIcon)

local function ToggleMainUI()
    isMainVisible = not isMainVisible
    if isMainVisible then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, -200),
            GroupTransparency = 0
        }):Play()
        CascadeItems()
    else
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -250, 0.6, 0),
            GroupTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function()
            if not isMainVisible then MainFrame.Visible = false end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleMainUI)

CloseBtn.MouseButton1Click:Connect(function()
    KaitunGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    isMini3D = not isMini3D
    if isMini3D then
        MainFrame.Visible = false
        Mini3DIcon.Visible = true
        Mini3DIcon.Position = UDim2.new(0.5, -30, 0.5, -30)
        TweenService:Create(Mini3DIcon, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    else
        Mini3DIcon.Visible = false
        MainFrame.Visible = true
        MainFrame.GroupTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    end
end)

---------
---------
RunService.RenderStepped:Connect(function(dt)
    local t = tick()
    
    for _, grad in ipairs(StrokeGradients) do
        grad.Rotation = (t * 100) % 360
    end
    
    if isMini3D and Mini3DIcon.Visible then
        Mini3DIcon.Rotation = math.sin(t * 2) * 15
    end
    
    StatusDot.BackgroundTransparency = math.abs(math.sin(t * 4))
    
    for _, waveData in ipairs(ActiveWaves) do
        local alpha1 = (t * 3 % math.pi) / math.pi
        local size1 = 4 + (alpha1 * 10)
        waveData.Wave1.Size = UDim2.new(0, size1, 0, size1)
        waveData.Wave1.Position = UDim2.new(0.5, -size1/2, 0.5, -size1/2)
        waveData.Wave1.BackgroundTransparency = alpha1
        
        local alpha2 = ((t * 3 + math.pi/2) % math.pi) / math.pi
        local size2 = 4 + (alpha2 * 10)
        waveData.Wave2.Size = UDim2.new(0, size2, 0, size2)
        waveData.Wave2.Position = UDim2.new(0.5, -size2/2, 0.5, -size2/2)
        waveData.Wave2.BackgroundTransparency = alpha2
        
        if waveData.HasItem then
            waveData.Grad.Offset = Vector2.new(math.sin(t * 2), 0)
        end
    end
end)

---------
---------
task.spawn(function()
    task.wait(0.5)
    CascadeItems()
    TweenNumber(LevelVal, 2800)
    TweenNumber(BeliVal, 19555559)
    TweenNumber(FragVal, 118249)
    
    task.wait(2.5)
    UpdateMiniTask("TARGET: BUYING MELEE", "Doing: Moving to location...")
    
    task.wait(1.5)
    SetItemState(1, true)
    
    task.wait(1.0)
    SetItemState(2, true)
    StatusAction.Text = "Buying Melee..."
    
    task.wait(1.5)
    SetItemState(3, true)
    SetItemState(4, true)
    UpdateMiniTask("ALL TASKS COMPLETED", "Doing: Hanging around...")
    StatusAction.Text = "Idle"
end)
---------
---------

