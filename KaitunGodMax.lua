repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Time.lua"))()
timeee = os.time()

Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        blackscreen = false
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = false
    }
}
 
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

---------
---------
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Darker = Color3.fromRGB(8, 8, 8),
    ContainerBg = Color3.fromHex("#525252"),
    ContainerTrans = 0.6,
    PillBack = Color3.fromRGB(20, 25, 30),
    Text = Color3.fromHex("#FFFFFF"),
    TextDim = Color3.fromHex("#808080"),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(130, 255, 100),
    Active = Color3.fromHex("#888888"),
    TextContrast = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#808080")),
        ColorSequenceKeypoint.new(0.50, Color3.fromHex("#D3D3D3")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
    }),
    TextGrad = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")), 
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8A8A8A")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("#1A1A1A")) 
    }),
    RowStroke = Color3.fromHex("#FFFFFF"),
    RowStrokeGrad = ColorSequence.new({ 
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")), 
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#555555")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("#54626F")) 
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
local AnimatedGradients = {}
local AllRows = {}

---------
---------
local KaitunGui = Instance.new("ScreenGui")
KaitunGui.Name = "MeyyKaitunCompact"
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
local function ApplyTextGradient(obj, isContrast)
    obj.TextColor3 = Theme.Text
    local grad = Instance.new("UIGradient", obj)
    grad.Rotation = 90
    grad.Color = isContrast and Theme.TextContrast or Theme.TextGrad
    
    local shadow = Instance.new("UIStroke")
    shadow.Color = Theme.Darker
    shadow.Thickness = 0.5
    shadow.Transparency = 0
    shadow.Parent = obj
    
    return grad
end

---------
---------
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleContainer"
ToggleContainer.Size = UDim2.new(0, 60, 0, 30)
ToggleContainer.Position = UDim2.new(0, 15, 0, 15)
ToggleContainer.BackgroundColor3 = Theme.Darker
ToggleContainer.BackgroundTransparency = 0.4
ToggleContainer.BorderSizePixel = 0
ToggleContainer.Parent = KaitunGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleContainer

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleContainer

local ToggleGrad = Instance.new("UIGradient")
ToggleGrad.Color = Theme.StrokeGrad
ToggleGrad.Parent = ToggleStroke
table.insert(StrokeGradients, ToggleGrad)

local ToggleBall = Instance.new("Frame")
ToggleBall.Size = UDim2.new(0, 22, 0, 22)
ToggleBall.Position = UDim2.new(0, 34, 0.5, -11)
ToggleBall.BackgroundColor3 = Theme.Text
ToggleBall.Parent = ToggleContainer
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleContainer
MakeDraggable(ToggleContainer, ToggleContainer)

---------
---------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 355)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = KaitunGui

local MainGroup = Instance.new("CanvasGroup")
MainGroup.Size = UDim2.new(1, 0, 1, 0)
MainGroup.BackgroundTransparency = 1
MainGroup.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

---------
local MainStrokeGrad = Instance.new("UIGradient")
MainStrokeGrad.Color = Theme.StrokeGrad
MainStrokeGrad.Parent = MainStroke
table.insert(StrokeGradients, MainStrokeGrad)

MakeDraggable(MainFrame, MainFrame)

---------
local MainScale = Instance.new("UIScale")
MainScale.Name = "MainScale"
MainScale.Parent = MainFrame

local ToggleScale = Instance.new("UIScale")
ToggleScale.Name = "ToggleScale"
ToggleScale.Parent = ToggleContainer

local Camera = workspace.CurrentCamera

local function UpdateUiScale()
    if not Camera then return end
    local viewport = Camera.ViewportSize
    local scale = viewport.Y / 530
    scale = math.clamp(scale, 0.7, 3)
    
    MainScale.Scale = scale
    ToggleScale.Scale = scale
end

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUiScale)
UpdateUiScale()
---------

---------
---------
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = MainGroup

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MEYY HUB | Kaitun Blox Fruit"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
ApplyTextGradient(Title, false)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0.5, -10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Header
CreateButtonEffects(CloseBtn)

local HDivider = Instance.new("Frame")
HDivider.Name = "HDivider"
HDivider.Size = UDim2.new(1, -20, 0, 1)
HDivider.Position = UDim2.new(0, 10, 0, 35)
HDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HDivider.BorderSizePixel = 0
HDivider.Parent = MainGroup

local HDivGrad = Instance.new("UIGradient")
HDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 1)
})
HDivGrad.Parent = HDivider

---------
---------
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 1, -110)
Body.Position = UDim2.new(0, 0, 0, 45)
Body.BackgroundTransparency = 1
Body.Parent = MainGroup

local LeftCol = Instance.new("Frame")
LeftCol.Name = "LeftCol"
LeftCol.Size = UDim2.new(0.46, 0, 1, 0)
LeftCol.Position = UDim2.new(0, 15, 0, 0)
LeftCol.BackgroundTransparency = 1
LeftCol.Parent = Body

local RightCol = Instance.new("Frame")
RightCol.Name = "RightCol"
RightCol.Size = UDim2.new(0.46, 0, 1, 0)
RightCol.Position = UDim2.new(0.5, 5, 0, 0)
RightCol.BackgroundTransparency = 1
RightCol.Parent = Body

---------
---------
local StatsTitle = Instance.new("TextLabel")
StatsTitle.Size = UDim2.new(1, 0, 0, 15)
StatsTitle.Position = UDim2.new(0, 0, 0, 0)
StatsTitle.BackgroundTransparency = 1
StatsTitle.Text = "STATS"
StatsTitle.TextColor3 = Theme.TextDim
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.TextSize = 11
StatsTitle.TextXAlignment = Enum.TextXAlignment.Left
StatsTitle.Parent = LeftCol

local function CreateStatBlock(parent, titleText, index)
    local Block = Instance.new("Frame")
    Block.Size = UDim2.new(1, 0, 0, 45)
    Block.Position = UDim2.new(0, 0, 0, 20 + (index - 1) * 52)
    Block.BackgroundColor3 = Theme.ContainerBg
    Block.BackgroundTransparency = Theme.ContainerTrans
    Block.Parent = parent
    Instance.new("UICorner", Block).CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", Block)
    Stroke.Color = Theme.RowStroke
    Stroke.Thickness = 1
    
    local StrokeGrad = Instance.new("UIGradient", Stroke)
    StrokeGrad.Color = Theme.RowStrokeGrad
    table.insert(AnimatedGradients, StrokeGrad)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -10, 0, 15)
    TitleLbl.Position = UDim2.new(0, 10, 0, 5)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = titleText
    TitleLbl.TextColor3 = Theme.TextDim
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Block

    local ValueLbl = Instance.new("TextLabel")
    ValueLbl.Size = UDim2.new(1, -10, 0, 20)
    ValueLbl.Position = UDim2.new(0, 10, 0, 20)
    ValueLbl.BackgroundTransparency = 1
    ValueLbl.Text = "0"
    ValueLbl.Font = Enum.Font.GothamBold
    ValueLbl.TextSize = 16
    ValueLbl.TextXAlignment = Enum.TextXAlignment.Left
    ValueLbl.Parent = Block
    ApplyTextGradient(ValueLbl, false)

    return ValueLbl
end

local LevelVal = CreateStatBlock(LeftCol, "LEVEL", 1)
local RaceVal = CreateStatBlock(LeftCol, "RACE", 2)
local BeliVal = CreateStatBlock(LeftCol, "BELI", 3)
local FragVal = CreateStatBlock(LeftCol, "FRAGMENTS", 4)

RaceVal.Text = "Human"

---------
---------
local ItemsTitle = Instance.new("TextLabel")
ItemsTitle.Size = UDim2.new(1, 0, 0, 15)
ItemsTitle.Position = UDim2.new(0, 5, 0, 0)
ItemsTitle.BackgroundTransparency = 1
ItemsTitle.Text = "ITEMS"
ItemsTitle.TextColor3 = Theme.TextDim
ItemsTitle.Font = Enum.Font.GothamBold
ItemsTitle.TextSize = 11
ItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
ItemsTitle.Parent = RightCol

local SeasTitle = Instance.new("TextLabel")
SeasTitle.Size = UDim2.new(1, 0, 0, 15)
SeasTitle.Position = UDim2.new(0, 5, 0, 145)
SeasTitle.BackgroundTransparency = 1
SeasTitle.Text = "SEAS"
SeasTitle.TextColor3 = Theme.TextDim
SeasTitle.Font = Enum.Font.GothamBold
SeasTitle.TextSize = 11
SeasTitle.TextXAlignment = Enum.TextXAlignment.Left
SeasTitle.Parent = RightCol

local function CreateItemRow(parent, itemName, yPos)
    local Row = Instance.new("CanvasGroup")
    Row.Size = UDim2.new(1, -10, 0, 22)
    Row.Position = UDim2.new(0, 5, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local RingBase = Instance.new("Frame")
    RingBase.Size = UDim2.new(0, 16, 0, 16)
    RingBase.Position = UDim2.new(0, 0, 0.5, -8)
    RingBase.BackgroundTransparency = 1
    RingBase.Parent = Row

    local CenterDot = Instance.new("Frame")
    CenterDot.Size = UDim2.new(0, 6, 0, 6)
    CenterDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    CenterDot.BackgroundColor3 = Theme.Red
    CenterDot.BorderSizePixel = 0
    CenterDot.Parent = RingBase
    Instance.new("UICorner", CenterDot).CornerRadius = UDim.new(1, 0)

    local Wave1 = Instance.new("Frame")
    Wave1.Size = UDim2.new(0, 6, 0, 6)
    Wave1.Position = UDim2.new(0.5, -3, 0.5, -3)
    Wave1.BackgroundColor3 = Theme.Red
    Wave1.BackgroundTransparency = 0.5
    Wave1.BorderSizePixel = 0
    Wave1.Parent = RingBase
    Instance.new("UICorner", Wave1).CornerRadius = UDim.new(1, 0)

    local Wave2 = Instance.new("Frame")
    Wave2.Size = UDim2.new(0, 6, 0, 6)
    Wave2.Position = UDim2.new(0.5, -3, 0.5, -3)
    Wave2.BackgroundColor3 = Theme.Red
    Wave2.BackgroundTransparency = 0.8
    Wave2.BorderSizePixel = 0
    Wave2.Parent = RingBase
    Instance.new("UICorner", Wave2).CornerRadius = UDim.new(1, 0)

    local ItemText = Instance.new("TextLabel")
    ItemText.Size = UDim2.new(1, -25, 1, 0)
    ItemText.Position = UDim2.new(0, 25, 0, 0)
    ItemText.BackgroundTransparency = 1
    ItemText.Text = itemName
    ItemText.TextColor3 = Theme.TextDim
    ItemText.TextTransparency = 0.4
    ItemText.Font = Enum.Font.GothamBold
    ItemText.TextSize = 12
    ItemText.TextXAlignment = Enum.TextXAlignment.Left
    ItemText.Parent = Row
    
    local ItemGrad = ApplyTextGradient(ItemText, true)
    ItemGrad.Enabled = false

    local itemData = {
        Row = Row,
        CenterDot = CenterDot,
        Wave1 = Wave1,
        Wave2 = Wave2,
        Text = ItemText,
        Grad = ItemGrad,
        HasItem = false,
        Name = itemName,
        TargetY = yPos
    }

    table.insert(AllRows, itemData)
    table.insert(ActiveWaves, itemData)

    return itemData
end

CreateItemRow(RightCol, "Cursed Dual Katana", 20)
CreateItemRow(RightCol, "Valkyrie Helm", 44)
CreateItemRow(RightCol, "Skull Guitar", 68)
CreateItemRow(RightCol, "Mirror Fractal", 92)
CreateItemRow(RightCol, "Pull Lever", 116)

CreateItemRow(RightCol, "Sea 1", 165)
CreateItemRow(RightCol, "Sea 2", 189)
CreateItemRow(RightCol, "Sea 3", 213)

---------
---------
local StatusPill = Instance.new("Frame")
StatusPill.Name = "StatusPill"
StatusPill.Size = UDim2.new(1, -30, 0, 50)
StatusPill.Position = UDim2.new(0, 15, 1, -65)
StatusPill.BackgroundColor3 = Theme.PillBack
StatusPill.BackgroundTransparency = 0.3
StatusPill.BorderSizePixel = 0
StatusPill.Parent = MainGroup

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(0, 8)
PillCorner.Parent = StatusPill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 60, 1, 0)
StatusLabel.Position = UDim2.new(0, 15, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "STATUS"
StatusLabel.TextColor3 = Theme.TextDim
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusPill

local StatusDotFrame = Instance.new("Frame")
StatusDotFrame.Size = UDim2.new(0, 16, 0, 16)
StatusDotFrame.Position = UDim2.new(0, 65, 0.5, -8)
StatusDotFrame.BackgroundTransparency = 1
StatusDotFrame.Parent = StatusPill

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 6, 0, 6)
StatusDot.Position = UDim2.new(0.5, -3, 0.5, -3)
StatusDot.BackgroundColor3 = Theme.Green
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusDotFrame
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusAction = Instance.new("TextLabel")
StatusAction.Size = UDim2.new(1, -95, 0, 18)
StatusAction.Position = UDim2.new(0, 85, 0, 6)
StatusAction.BackgroundTransparency = 1
StatusAction.Text = "Buying Melee"
StatusAction.TextColor3 = Theme.Text
StatusAction.Font = Enum.Font.GothamBold
StatusAction.TextSize = 13
StatusAction.TextXAlignment = Enum.TextXAlignment.Left
StatusAction.Parent = StatusPill

local StatusSubAction = Instance.new("TextLabel")
StatusSubAction.Size = UDim2.new(1, -95, 0, 15)
StatusSubAction.Position = UDim2.new(0, 85, 0, 26)
StatusSubAction.BackgroundTransparency = 1
StatusSubAction.Text = "Moving to location..."
StatusSubAction.TextColor3 = Theme.TextDim
StatusSubAction.Font = Enum.Font.GothamBold
StatusSubAction.TextSize = 11
StatusSubAction.TextXAlignment = Enum.TextXAlignment.Left
StatusSubAction.Parent = StatusPill

---------
---------
local function TweenNumber(label, targetValue)
    local startTime = tick()
    local duration = 2.0
    local connection

    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        
        if elapsed >= duration then
            label.Text = FormatNumber(targetValue)
            connection:Disconnect()
            return
        end
        
        local t = elapsed / duration
        local c1 = 1.70158
        local c3 = c1 + 1
        local ease = 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
        
        local currentValue = targetValue * ease
        if currentValue < 0 then currentValue = 0 end
        
        label.Text = FormatNumber(currentValue)
    end)
end

---------
---------
local function SetItemState(index, hasItem)
    local item = AllRows[index]
    if not item then return end
    
    item.HasItem = hasItem
    
    if hasItem then
        TweenService:Create(item.CenterDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Green}):Play()
        TweenService:Create(item.Wave1, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Green}):Play()
        TweenService:Create(item.Wave2, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Green}):Play()
        
        TweenService:Create(item.Text, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
            TextColor3 = Theme.Text,
            TextTransparency = 0
        }):Play()
        item.Grad.Enabled = true
    else
        TweenService:Create(item.CenterDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Red}):Play()
        TweenService:Create(item.Wave1, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Red}):Play()
        TweenService:Create(item.Wave2, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Red}):Play()
        
        TweenService:Create(item.Text, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
            TextColor3 = Theme.TextDim,
            TextTransparency = 0.4
        }):Play()
        item.Grad.Enabled = false
    end
end

---------
---------
local function CascadeItems()
    for _, item in ipairs(AllRows) do
        item.Row.Position = UDim2.new(0, 30, 0, item.TargetY)
        item.Row.GroupTransparency = 1
    end
    
    for _, item in ipairs(AllRows) do
        TweenService:Create(item.Row, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 5, 0, item.TargetY),
            GroupTransparency = 0
        }):Play()
        task.wait(0.05)
    end
end

---------
---------
local isMainVisible = true

local function ToggleMainUI()
    isMainVisible = not isMainVisible
    if isMainVisible then
        MainFrame.Visible = true
        
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 34, 0.5, -11)}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Darker}):Play()
        
        TweenService:Create(MainGroup, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play()
        
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, -200)
        }):Play()
        
        task.spawn(CascadeItems)
    else
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Active}):Play()
        
        local t = TweenService:Create(MainGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            GroupTransparency = 1
        })
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -250, 0.5, -180)
        }):Play()
        
        t:Play()
        t.Completed:Connect(function()
            if not isMainVisible then MainFrame.Visible = false end
        end)
    end
end

ToggleBtn.MouseButton1Click:Connect(ToggleMainUI)

CloseBtn.MouseButton1Click:Connect(function()
    KaitunGui:Destroy()
end)

---------
---------
RunService.RenderStepped:Connect(function(dt)
    local t = tick()
    
    for _, grad in ipairs(StrokeGradients) do
        grad.Rotation = (t * 100) % 360
    end
    
    local animatedOffset = Vector2.new(math.sin(t * 2) * 0.4, 0)
    for _, grad in ipairs(AnimatedGradients) do
        if grad and grad.Parent then
            grad.Offset = animatedOffset
        end
    end
    
    StatusDot.BackgroundTransparency = math.abs(math.sin(t * 4))
    
    for _, waveData in ipairs(ActiveWaves) do
        local phase1 = (t * 3) % math.pi
        local alpha1 = phase1 / math.pi
        local size1 = 6 + (alpha1 * 14)
        waveData.Wave1.Size = UDim2.new(0, size1, 0, size1)
        waveData.Wave1.Position = UDim2.new(0.5, -size1/2, 0.5, -size1/2)
        waveData.Wave1.BackgroundTransparency = alpha1
        
        local phase2 = (t * 3 + math.pi/2) % math.pi
        local alpha2 = phase2 / math.pi
        local size2 = 6 + (alpha2 * 14)
        waveData.Wave2.Size = UDim2.new(0, size2, 0, size2)
        waveData.Wave2.Position = UDim2.new(0.5, -size2/2, 0.5, -size2/2)
        waveData.Wave2.BackgroundTransparency = alpha2
        
        if waveData.HasItem and waveData.Grad then
            waveData.Grad.Offset = Vector2.new(math.sin(t * 2), 0)
        end
    end
end)

---------
---------
---------
---------
getgenv().FailedJobIds = {}
getgenv().LastApiRefresh = 0
function HopToServerByAPI(filterNames, maxPlayers, waitTime)
    isHopping = true
    maxPlayers = maxPlayers or 10
    waitTime = waitTime or 25
    apiUrl = "http://fi11.bot-hosting.net:20758/api/name=" .. filterNames
 
    if not apiUrl then
        print("[Hop] Không tìm thấy API cho: " .. tostring(filterNames))
        return false
    end

    if tick() - getgenv().LastApiRefresh > 600 then
        getgenv().FailedJobIds = {}
        getgenv().LastApiRefresh = tick()
    end

    local CURRENT_PLACE_ID = game.PlaceId

    local ok, result = pcall(function()
        local responseBody
        pcall(function() responseBody = game:HttpGet(apiUrl) end)
        if not responseBody then
            local reqFunc = (syn and syn.request) or request or http.request
            local req = reqFunc({ Url = apiUrl, Method = "GET" })
            responseBody = req.Body
        end
        local data = game:GetService("HttpService"):JSONDecode(responseBody)
        if not data or not data.success or type(data.data) ~= "table" then
            print(" API trả về dữ liệu sai")
            return false
        end
        local seen = {}
        local servers = {}
        for _, entry in ipairs(data.data) do
            local jobId = entry.jobid
            local placeId = entry.placeid
            local players = tonumber(entry.player) or 99

            if jobId and placeId then
                if not seen[jobId] then
                    seen[jobId] = true
                    table.insert(servers, {
                        jobid = jobId,
                        placeid = placeId,
                        players = players,
                    })
                end
            end
        end
        local filtered = {}
        for _, s in ipairs(servers) do
            if s.placeid == CURRENT_PLACE_ID then
                table.insert(filtered, s)
            end
        end
        table.sort(filtered, function(a, b) return a.players < b.players end)
        print(" Tìm thấy " .. #filtered .. " server hợp lệ")
        local triedCount = 0
        for _, server in ipairs(filtered) do
            local jobId = server.jobid
            local players = server.players

            if jobId == game.JobId then continue end
            if getgenv().FailedJobIds[jobId] then continue end
            if players >= maxPlayers then continue end

            triedCount = triedCount + 1
            print(" " .. filterNames .. " | " .. players .. " người | Đang join...")
            local teleportOk = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobId)
            end)
            if teleportOk then
                task.wait(15)
                return true
            else
                getgenv().FailedJobIds[jobId] = tick()
                print(" Không vào được server #" .. triedCount)
                task.wait(1)
            end
        end
        print(" Hết server phù hợp | Đợi API cập nhật...")
        for i = waitTime, 1, -1 do
            if getgenv().StopV3 then return false end
            print(" Đợi API: " .. i .. "s | " .. filterNames)
            task.wait(1)
        end
        return false
    end)
    return ok and result
end

---------
local function CheckItem(itemName)
    local hasItem = false
    local count = 0
    pcall(function()
        local inventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
        if inventory then
            for _, item in pairs(inventory) do
                if item.Name == itemName then
                    hasItem = true
                    count = item.Count or 1
                    break
                end
            end
        end
    end)
    return hasItem, count
end

local function checkPullLevel()
    local pullLV = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CheckTempleDoor")
    if pullLV then
        return true
    else
        return false
    end
end
---------
task.spawn(function()
    task.wait(0.5)
    CascadeItems()
    
    while true do
        
        
        pcall(function()
            local player = game.Players.LocalPlayer
            if player and player:FindFirstChild("Data") then
                TweenNumber(LevelVal, player.Data.Level.Value)
                TweenNumber(BeliVal, player.Data.Beli.Value)
                TweenNumber(FragVal, player.Data.Fragments.Value)
                
                ---------
                local raceName = player.Data.Race.Value
                local raceLevel = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getRaceLevel")
                RaceVal.Text = raceName .. " V" .. tostring(raceLevel)
                ---------
            end
        end)
        
        local itemsToCheck = {
            "Cursed Dual Katana",
            "Valkyrie Helm",
            "Skull Guitar",
            "Mirror Fractal",
            "Pull Lever"
        }
        
        for i, itemName in ipairs(itemsToCheck) do
            if itemName == "Pull Lever" then
                local hasPullLevel = false
                pcall(function()
                    hasPullLevel = checkPullLevel()
                end)
                SetItemState(i, hasPullLevel)
            else
                local hasItem, _ = CheckItem(itemName)
                SetItemState(i, hasItem)
            end
        end
        
        local currentPlaceId = game.PlaceId
        local seaLevel = 1
        if currentPlaceId == 4442272183 or currentPlaceId == 79091703265657 then
            seaLevel = 2
        elseif currentPlaceId == 7449423635 or currentPlaceId == 100117331123089 then
            seaLevel = 3
        end
        
        SetItemState(6, seaLevel >= 1)
        SetItemState(7, seaLevel >= 2)
        SetItemState(8, seaLevel >= 3)
        
        task.wait(1)
        StatusAction.Text = "Idle"
        StatusSubAction.Text = "Waiting for next cycle..."
        
        task.wait(9)
    end
end)
---------

function hoangtuveu()
    function a()
    for b, _ in next, require(game.ReplicatedStorage.GuideModule).Data do if b == "QuestData" then return true end end
    return false
end

function c()
    if a() then for d, _ in next, require(game.ReplicatedStorage.GuideModule).Data.QuestData.Task do return d end end
end

function e()
    local f = {}
    if a() then for g, _ in next, require(game.ReplicatedStorage.GuideModule).Data.QuestData.Task do table.insert(f, g) end end
    return f
end
    ---------
    local function GetTripleQuest()
        local i = game.Players.LocalPlayer.Data.Level.Value
        local j, k, l
        local m = 0
        if i >= 275 and i < 300 then
            j, k, l = "ColosseumQuest", "Toga Warrior", 1
        elseif i >= 1450 and (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 or SeaIndex == 2) then
            j, k, l = "ForgottenQuest", "Water Fighter", 2
        elseif i >= 700 and (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 or SeaIndex == 1) then
            j, k, l = "FountainQuest", "Galley Captain", 2
        else
            for n, o in pairs(require(game.ReplicatedStorage.Quests)) do
                for p, q in pairs(o) do
                    for r, _ in pairs(q.Task) do
                        if i >= q.LevelReq and q.LevelReq >= m and q.Task[r] > 1 and not table.find({"BartiloQuest", "Trainees", "MarineQuest", "CitizenQuest"}, tostring(n)) then
                            m, j, k, l = q.LevelReq, n, tostring(r), p
                        end
                    end
                end
            end
        end
        local s = {}
        if i >= 20 then
            for n, o in pairs(require(game.ReplicatedStorage.Quests)) do
                for _, t in pairs(o) do
                    for u, _ in pairs(t.Task) do
                        if tostring(u) == k then
                            for v, w in next, o do
                                for x, y in next, w.Task do
                                    if x ~= k and y == 1 and (function()
                                        for _,z in {game.ReplicatedStorage,workspace.Enemies} do
                                            for _,aa in next,z:GetChildren() do
                                                if aa.Name == tostring(x) and aa:FindFirstChild('Humanoid') and aa:FindFirstChild('HumanoidRootPart') then
                                                    if aa.Humanoid.Health > 0 then
                                                        return true
                                                    end
                                                end
                                            end
                                        end
                                        return false
                                    end)() then
                                        s.NameMonster = w.LevelReq <= i and tostring(x) or k
                                        s.NameQuest = w.LevelReq <= i and n or j
                                        s.ID = w.LevelReq <= i and v or l
                                        return s
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if i >= 10 and a() and c() == k and #e() > 2 then
            for n, o in pairs(require(game.ReplicatedStorage.Quests)) do
                for _, t in pairs(o) do
                    for u, _ in pairs(t.Task) do
                        if tostring(u) == k then
                            for v, w in next, o do
                                for x, y in next, w.Task do
                                    if x ~= k and y > 1 then
                                        s.NameMonster = w.LevelReq <= i and tostring(x) or k
                                        s.NameQuest = w.LevelReq <= i and n or j
                                        s.ID = w.LevelReq <= i and v or l
                                        return s
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        s.NameMonster = k
        s.NameQuest = j
        s.ID = l
        return s
    end
---------

    
    local J = {'Task1', 'Task2', "Currencies", 'Melees', 'LiveTime', 'DebugLine'}
    local W = {Instances = {}}
    local K = true
    local a = false
    local h = game.Players.LocalPlayer
    if not isfile("fluent.lua") then
        writefile('fluent.lua', game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))
    end
    local J = loadstring(readfile('fluent.lua'))()
    function alert(a, h)
       print(a)
       print(h)
    end
    OldSessionTime = isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    repeat wait() until game.Players.LocalPlayer.Character
    spawn(function()
        game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild('NewIslandLOD', 9999):Destroy()
        game:GetService("Players")
        LocalPlayer.PlayerScripts:WaitForChild('IslandLOD', 9999):Destroy()
    end)
    local J = {'RawConstants', "Utilly", "QuestManager", 'SpawnRegionLoader', 'TweenController', "AttackController", 'CombatController', 'FunctionsHandler', "Hooks", "Debug", "Hop", "Storage"}
    StartTick = tick()
    local J = "Rua_Hub/Blox_Fruit/Assets/"
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or LocalPlayer.Backpack:FindFirstChild(J) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})
    function CreateTraceback(J, W) table.insert(ScriptStorage.Tracebacks, (GetCurrentDateTime() .. ' ( ' .. DispTime(os.time() - os.time(), true) .. ' ) after execution | ' .. J .. " | " .. W)) end
        ---------
---------
    function SetTask(J, W)
        if J == "MainTask" then
            local mainText, subText = string.match(W, "^([^|]+)%s*|%s*(.+)$")
            if mainText and subText then
                StatusAction.Text = mainText:gsub("%s+$", "")
                StatusSubAction.Text = subText
            else
                StatusAction.Text = W
            end
        elseif J == "SubTask" then
            StatusSubAction.Text = W
        end
    end
---------
---------

        Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DragonClaw = "Sabi", Superhuman = "Martial Arts Master", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}
    local J = {}
    setmetatable(Remotes, {__index = function(W, W)
        if W ~= 'CommF_' then
            print('captured unregistered signal', W)
            return Services.ReplicatedStorage.Remotes[W]
        end
        local W = {InvokeServer = function(a, ...)
            print('remote fired', ...)
            local a, h = ...
            if type(a) == "string" and string.find(a, "Buy") == 1 and not h then
                local h = string.gsub(a, 'Buy', "")
                if BindedMeleeNPCNames and BindedMeleeNPCNames[h] then
                    local npcData = ScriptStorage.NPCs[BindedMeleeNPCNames[h]]
                    if npcData then
                        local pivot = npcData.WorldPivot
                        if CaculateDistance(pivot) > 15 then
                            repeat
                                task.wait()
                                TweenController.Create(pivot.Position)
                            until CaculateDistance(pivot) < 15
                            task.wait(1)
                        end
                    end
                end
            end
            return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
        end}
        return W
    end})

    Tasks = {}
    function AwaitUntilPlayerLoaded(W, a)
        repeat task.wait() until W.Character
        W.Character:WaitForChild('Humanoid')
        repeat task.wait() until W.Character.Humanoid.Health > 0
    end
    function AddPoint()
        local W = {}
        local a
        for h, h in LocalPlayer.Data.Stats:GetChildren() do
            if h and h:FindFirstChild('Level') then W[h.Name] = h.Level.Value end
        end
        if W.Defense < MaxLevel and (W.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - W.Melee < 100) then
            a = 'Defense'
        elseif W.Melee < MaxLevel then
            a = "Melee"
        else
            a = 'Sword'
        end
        Remotes.CommF_:InvokeServer("AddPoint", a, 999)
    end
    local W = {Currencies = {Level = "#00FF48", Beli = "#FF7800", Fragments = "#6C00FF"}, Races = {}}
function RefreshPlayerData()
    pcall(function()
        for a, a in LocalPlayer.Data:GetChildren() do 
            pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
        end
    end)
    local a = ""
    for h, X in ScriptStorage.PlayerData do
        local w = W.Currencies[h]
        if w then a = a .. '<font color="' .. w .. '">' .. h .. "</font>: " .. X .. ' ' end
    end
end
    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack2 = {}
        for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack2[W.Name] = W end
        ScriptStorage.Backpack = ScriptStorage.Backpack2
    end
    function ResearchMoves(W)
        if W and tostring(W) == 'V' then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            print('[ Debug ] Registering burst', W)
            ScriptStorage.Connections.BurstCheck = W.Cooldown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then return end
                local a = W.Cooldown.AbsoluteSize.X
                if a < 3 then
                    EnablingBurstDebounce = os.time()
                    task.wait(5)
                    SendKey('V', 0)
                end
            end)
        end
    end
    function CheckMeleeBurstMove(W)
        if W.Name == "Black Leg" or W.Name == "Death Step" then
            local a = PlayerGui.Main.Skills:WaitForChild(W.Name, 9)
            ResearchMoves(a:WaitForChild("V"))
        end
    end
    function RefreshMelees(W)
        local a = ''
        for h, X in ScriptStorage.Melees do a = a .. h .. ": " .. X .. " " end
        a = a == '' and '[0]' or a
        if W then return a end
    end
    function MeleeCheck(W)
        print('Melee check', W)
        if W and typeof(W) == "Instance" and W:IsA("Tool") then
            if W.ToolTip == "Melee" then
                if ScriptStorage.Connections.Melees then ScriptStorage.Connections.Melees:Disconnect() end
                ScriptStorage.CurrentMeleeData.Name = W.Name
                pcall(function() ScriptStorage.Connections.Melees:Destroy() end)
                ScriptStorage.Connections.Melees = W.Level.Changed:Connect(function(a)
                    ScriptStorage.Melees[W.Name] = a
                    RefreshMelees()
                end)
                ScriptStorage.Melees[W.Name] = W.Level.Value
                RefreshMelees()
            elseif string.find(tostring(W), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, W:GetAttribute('OriginalName')) then return end
                    local a = Remotes.CommF_:InvokeServer("StoreFruit", W:GetAttribute("OriginalName"), W)
                end)
            end
        end
    end
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass('Tool'))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            task.wait(6)
            if LocalPlayer.Character:FindFirstChild('HasBuso') then return end
            Remotes.CommF_:InvokeServer("Buso")
        end)
        for W, W in ScriptStorage.Connections.LocalPlayer do pcall(function() W:Disconnect() end) end
        AwaitUntilPlayerLoaded(LocalPlayer)
        LocalPlayer:SetAttribute("IsAvailable", true)
        ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
            local W = LocalPlayer.Character.Humanoid.Health
            LocalPlayer:SetAttribute("IsAvailable", W > 10)
            ScriptStorage.LocalPlayerHealth = W
        end)
        ScriptStorage.Connections.LocalPlayer['Melee'] = LocalPlayer.Character.ChildAdded:Connect(MeleeCheck)
        ScriptStorage.Connections.LocalPlayer['Fruit'] = LocalPlayer.Backpack.ChildAdded:Connect(MeleeCheck)
        table.foreach(LocalPlayer.Backpack:GetChildren(), function(W, W) MeleeCheck(W) end)
        LastIdleCheck = os.time()
        ScriptStorage.Connections.LocalPlayer.PositionChecker = LocalPlayer.Character.HumanoidRootPart:GetPropertyChangedSignal('CFrame'):Connect(function()
            if os.time() == LastIdleCheck then return end
            LastIdleCheck = os.time()
            if oldPos then
                if (LocalPlayer.Character.HumanoidRootPart.CFrame.p - oldPos).magnitude < 2 then return end
            end
            oldPos = (LocalPlayer.Character.HumanoidRootPart.CFrame.p)
            LastIdling = os.time()
        end)
        local W = LocalPlayer.Data:WaitForChild('Points')
        ScriptStorage.Connections.LocalPlayer.PointConnection = W:GetPropertyChangedSignal('Value'):Connect(function()
            local W = LocalPlayer.Data:WaitForChild('Points')
            if OldPointValue == W then return end
            OldPointValue = W
            AddPoint()
        end)
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(W)
        print('[ Debug ] re-registering events')
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then return end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    print(1)
    MeleesTable = {"Black Leg", 'Electro', "Fishman Karate", "Dragon Claw", "Superhuman", 'Death Step', 'Electric Claw', 'Sharkman Karate', 'Dragon Talon', "Godhuman", "SanguineArt"}
    MeleesId = {'BlackLeg', "Electro", 'FishmanKarate', "DragonClaw", "Superhuman", 'DeathStep', "ElectricClaw", "SharkmanKarate", 'DragonTalon', 'Godhuman', "SanguineArt"}
    MeleePrices = {["Black Leg"] = {Price = {Beli = 150000}, Id = "BlackLeg", NextLevelRequirement = 400, position = CFrame.new(), Requirements = function() return true end, Buy = function(W) return BuyMelee("BlackLeg", W, 'Dark Step Teacher') end}, ['Electro'] = {Price = {Beli = 500000}, Id = 'Electro', NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('Electro', W, "Mad Scientist") end}, ['Fishman Karate'] = {Price = {Beli = 750000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('FishmanKarate', W, 'Water Kung-fu Teacher') end}, ['Dragon Claw'] = {Price = {Fragments = 1500}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonClaw", W, "Sabi") end}, ["Superhuman"] = {Price = {Beli = 3000000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("Superhuman", W, "Martial Arts Master") end}, ["Death Step"] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DeathStep", W, "Phoeyu, the Reformed") end}, ['Sharkman Karate'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('SharkmanKarate', W, 'Sharkman Teacher') end}, ['Electric Claw'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("ElectricClaw", W, 'Previous Hero') end}, ['Dragon Talon'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonTalon", W, 'Uzoth') end}, ["Godhuman"] = {Price = {Beli = 5000000, Fragments = 5000}, NextLevelRequirement = 350, Requirements = function() return true end, Buy = function(W) return BuyMelee("Godhuman", W, 'Ancient Monk') end}}
    DropItemData = {['Buddy Sword'] = {Sea = 3, Level = 1500, Boss = "Cake Queen"}, ['Canvander'] = {Sea = 3, Level = 1500, Boss = "Beautiful Pirate"}, ['Twin Hooks'] = {Sea = 3, Level = 1500, Boss = 'Captain Elephant'}, ["Venom Bow"] = {Sea = 3, Level = 1500, Boss = "Hydra Leader"}}
    GodhumanMaterials = {['Fish Tail'] = {20, 3, {"Fishman Raider", "Fishman Captain"}, {'DeepForestIsland3', 1, 1775, 'Turtle Adventure Quest Giver'}}, ['Dragon Scale'] = {10, 3, {"Dragon Crew Warrior", "Dragon Crew Archer"}, {'DragonCrewQuest', 1, 1575, 'Dragon Crew Quest Giver'}}, ["Magma Ore"] = {20, 2, {'Magma Ninja'}, {"FireSideQuest", 1, 1100, "Fire Quest Giver"}}, ["Mystic Droplet"] = {10, 2, {'Sea Soldier', 'Water Fighter'}, {'ForgottenQuest', 2, 1425, 'Forgotten Quest Giver'}}}
    SeaIndexes = {"Main", "Dressrosa", "Zou"}
    TasksOrder = {"MirrorAndValk","Tushita", 'Yama', "SpecialBossesTask", "RaidController", 'Trevor', "UtillyItemsActivitation", 'ColosseumPuzzle', "Wenlocktoad", "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", 'ThirdSeaPuzzle', "CollectDrops", 'BossesTask', "ExpRedeem", "LevelFarm", "MeleesController"}
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406), Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625), Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875), Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)}, {Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312), Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625), Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)}, {}})[SeaIndex]
    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper', 'Cake Prince' , 'Tyrant of the Skies'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ["Cake Prince"] = 1500, ['Soul Reaper'] = 1500 , ['Tyrant of the Skies'] = 1550}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Cake Prince'] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700 , ['Tyrant of the Skies'] = 1550}
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700}
    BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
    Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
    Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}
    function GenerateUUID()
        local W = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", '[xy]', function(W)
            local W = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', W)
        end)
    end
    function CheckIsPlayerAlive(W) W = W or LocalPlayer; return W and W.Character and W.Character.Humanoid and W.Character.HumanoidRootPart and W.Character.Head and W.Character.Humanoid.Health > 0 end
    function ConvertTo(W, a) return W.new(a.X, a.Y, a.Z) end
    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local h, X = ConvertTo(Vector3, W), ConvertTo(Vector3, a)
        return (h - X).magnitude
    end
    function DispTime(W, a)
        W = tonumber(W)
        if not W then return "[err]" end
        local h = math.floor(W / 86400)
        local X = math.floor(math.fmod(W, 86400) / 3600)
        local w = math.floor(math.fmod(W, 3600) / 60)
        local D = math.floor(math.fmod(W, 60))
        if a then return (h .. "day, " .. X .. "hrs, " .. w .. "min, " .. D .. 'sec.') end
        return (h .. 'day, ' .. X .. "hrs.")
    end
    function GetCurrentDateTime()
        local W = os.date("*t")
        local a = W.hour
        local h = W.min
        local X = W.day
        local w = W.month
        local D = W.year
        local y = W.wday
        local W = string.format('%02d:%02d ', a, h)
        local a = {'Sun', "Mon", 'Tue', "Wed", 'Thu', "Fri", 'Sat'}
        local h = a[y]
        local a = {"Jan", "Feb", "Mar", 'Apr', "May", 'Jun', "Jul", 'Aug', 'Sep', "Oct", 'Nov', "Dec"}
        local y = a[w]
        local a = string.format('%s, %s %d %d', h, y, X, D)
        return W .. a
    end
    function RandomArguments(...) local W = {...}; return W[math.random(0, #W)] end
    function RoundVector3Down(W) return Vector3.new(math.floor(W.X / 10) * 10, math.floor(W.Y / 10) * 10, math.floor(W.Z / 10) * 10) end
    local W = 30
    lastChange = tick()
    CaculateCircreDirection = function(a)
        if W > 50000 then W = 60 end
        W = W + ((tick() - lastChange) > .4 and 80 or 0)
        if tick() - lastChange > .4 then lastChange = tick() end
        local h = a + Vector3.new(math.cos(math.rad(W)) * 40, 0, math.sin(math.rad(W)) * 40)
        return CFrame.new(RoundVector3Down(h.p))
    end
    function GetMonAsSortedRange()
        local W = {}
        table.foreach(Services.Workspace.Enemies:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.foreach(game.ReplicatedStorage:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
        return W
    end
    print(1.5)
    function GetMeleeIdByName(W) for a, h in MeleesTable do if h == W then return MeleesId[a] end end end
    function getpos(W)
        for a, a in game:GetService("ReplicatedStorage").NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
        for a, a in workspace.NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
    end
    function BuyMelee(W, a)
        if W == "DragonClaw" and workspace.NPCs:FindFirstChild('Sabi') then
            if a then
                if type(Remotes.CommF_:InvokeServer("BlackbeardReward", 'DragonClaw', '1') == 1) == "number" and Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1') == 1 == 1 and not table.find(J, W) then table.insert(J, W) end
                return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
            end
            return Remotes.CommF_:InvokeServer('BlackbeardReward', "DragonClaw", '2')
        end
        if a then
            local a = Remotes.CommF_:InvokeServer('Buy' .. W, true)
            print("Response_", a == 1, typeof(a))
            if type(a) == 'number' and not table.find(J, W) then table.insert(J, W) end
            return a == 1
        end
        return Remotes.CommF_:InvokeServer("Buy" .. W)
    end
    function SendKey(J, W)
        (function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, J, false, game)
            task.wait(W)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, J, false, game)
        end)()
    end
    function FruitIdToName(J)
        local W = string.match(J, "((%u)[^%-]+)$")
        return W .. ' Fruit'
    end
    function Split(J, W)
        if W == nil then W = "%s" end
        local a = {}
        for h in string.gmatch(J, '([^' .. W .. ']+)') do table.insert(a, h) end
        return a
    end
    function FruitNameToId(J)
        local W = Split(J)[1]
        return W .. '-' .. W
    end
    local J = {CurrentLevel = 2, DoubleQuest = true, CurrentQuests = {}, BlacklistedQuestIds = {BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1}}
    local W = require(game.ReplicatedStorage.GuideModule).Data.NPCList
    repeat task.wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage
    J.Quests = require(game.ReplicatedStorage.Quests)
    function J.Set(W, a, h) W[a] = h end
    function J.RefreshQuest(W)
    local timeout = os.time()
    while not ScriptStorage.PlayerData.Level do
        task.wait(1)
        print('[ Debug ] Waiting for LocalPlayer datas.')
        -- Thêm timeout 30 giây
        if os.time() - timeout > 30 then
            print('[ Debug ] Timeout waiting for player data, skipping quest refresh')
            return
        end
    end
        local a = 0
        local h
        for X, w in J.Quests do
            if not J.BlacklistedQuestIds[X] then
                if (w[1].LevelReq >= a and w[1].LevelReq <= ScriptStorage.PlayerData.Level) then
                    a = w[1].LevelReq
                    h = w
                    W.CurrentQuestId = X
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and X == 'ForgottenQuest' then break end
                end
            end
        end
        local a = h[#h]
        for X, X in a.Task do if X == 1 then table.remove(h, #h) end end
        for a, X in require(game.ReplicatedStorage.GuideModule).Data.NPCList do
            for w, w in X.Levels do if w == h[#h].LevelReq then W.CurrentNpc = a.CFrame end end
        end
        W.CurrentQuests = h
    end
    function J.GetCurrentQuest(W)
        local a = W.CurrentQuests[W.CurrentLevel] and W.CurrentQuests[W.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level and W.CurrentLevel or 1
        for h in W.CurrentQuests[a].Task do return h, W.CurrentNpc, W.CurrentQuestId, a, W.CurrentQuests[a].Name end
    end
    function J.MarkAsCompleted(W) W.CurrentLevel = W.CurrentLevel == 2 and 1 or 2 end
    function J.AbandonQuest()
        print('Abandon Quest')
        Remotes.CommF_:InvokeServer("AbandonQuest")
    end
    function J.GetCurrentClaimQuest(W)
        local W = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", '%2')
        return W, game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    function J.StartQuest(W, a)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('ColorsDealer', "2")
        return Remotes.CommF_:InvokeServer("StartQuest", W, a)
    end
    ScriptStorage.MobRegions = {}
    for W, W in game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder:GetChildren() do
        ScriptStorage.MobRegions[tostring(W)] = ScriptStorage.MobRegions[tostring(W)] or {}
        table.insert(ScriptStorage.MobRegions[tostring(W)], W.CFrame)
    end
    TweenController = {}
    local W = 0
    local W = {}
    for a, a in game.ReplicatedStorage.NPCs:GetChildren() do if a.Name == 'Set Home Point' then table.insert(W, a:GetModelCFrame()) end end
    function TweenController.Update()
        local a = game.Players.LocalPlayer.Character.HumanoidRootPart
        HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if CaculateDistance(a.CFrame) > 250 then
            pcall(function() TweenInstance:Cancel() end)
            TweenDebounce = true
            a.CFrame = HumanoidRootPart.CFrame
            TweenDebounce = false
        end
        HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 3, 0)
    end
    function GetPortal(a)
        local h, X = 9e9, nil
        for w, w in Portals do
            local D = CaculateDistance(w, a)
            if D < (CaculateDistance(a) - 300) and D < h then
                h = D
                X = w
            end
        end
        if X then
            Remotes.CommF_:InvokeServer("requestEntrance", X)
            return task.wait()
        end
    end
    function GetEntries(a)
        local h, X = 9e9, nil
        for w, w in W do
            local W = CaculateDistance(w, a)
            if W < (CaculateDistance(a) - 700) and W < h then
                h = W
                X = w
            end
        end
        if X then if os.time() - 0 > 30 then for W = 1, 10, 1 do task.wait() end end end
    end
    function TweenController.Tween2(W, a)
        TweenInstance2 = Services.TweenService:Create(W, TweenInfo.new(CaculateDistance(W.CFrame, a) / 50, Enum.EasingStyle.Linear), {CFrame = ConvertTo(CFrame, a) - Vector3.new(0, 0, 0)})
        TweenInstance2:Play()
    end
    function TweenController.Create(W)
        if not W or TweenDebounce then return end
        local a = typeof(W) ~= 'CFrame' and ConvertTo(CFrame, W) or W
        if TweenInstance then pcall(function() TweenInstance:Cancel() end) end
        for W, W in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do if W:IsA("BasePart") then W.CanCollide = false end end
        local W = game.Players.LocalPlayer.Character:WaitForChild("Head")
        if not W:FindFirstChild("eltrul") then
            local h = Instance.new('BodyVelocity')
            h.Name = "eltrul"
            h.MaxForce = Vector3.new(0, math.huge, 0)
            h.Velocity = Vector3.zero
            h.Parent = W
        end
        if CaculateDistance(a) > 500 then
            if SeaIndex == 3 and not ScriptStorage.Backpack['Valkyrie Helm'] then
            elseif SeaIndex ~= 3 then
                print(a)
                GetPortal(a)
            end
        end
        if CaculateDistance(Vector3.new(11256, -2138.0, 9888), a) < (CaculateDistance(a) - 700) and SeaIndex == 3 then
            local W = CFrame.new(-16269.0, 23, 1371)
            if CaculateDistance(W) > 60 then return TweenController.Create(W) and task.wait(1) end
            local W = require(game.ReplicatedStorage.Modules.Net)
            W:RemoteFunction('SubmarineWorkerSpeak'):InvokeServer('TravelToSubmergedIsland')
        end
        a = CFrame.new(a.Position)
        local W = CaculateDistance(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, a)
        local h = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(h.x, a.y, h.z)
        TweenInstance = Services.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(W / (W < 18 and 25 or 330), Enum.EasingStyle.Linear), {CFrame = a})
        TweenInstance:Play()
    end
    local W = {}
    local a = game:GetService('Players')
    local h = game:GetService("RunService")
    local h = game:GetService('ReplicatedStorage')
    local X = game:GetService("Workspace")
    local X = game:GetService("VirtualInputManager")
    local X = a.LocalPlayer
    local X = h:WaitForChild('Modules')
    local w = X:WaitForChild("Net")
    local X = w:WaitForChild("RE/RegisterAttack")
    local X = w:WaitForChild('RE/RegisterHit')
    local X = w:WaitForChild('RE/ShootGunEvent')
    local X = h:WaitForChild("Remotes"):WaitForChild('Validator2')
    local h = game.ReplicatedStorage.Modules
    local X = h.Net
    local h, h = X:WaitForChild("RE/RegisterHit"), X:WaitForChild('RE/RegisterAttack')
    local h = {}
    function GetAllBladeHits()
        bladehits = {}
        for X, X in pairs(workspace.Enemies:GetChildren()) do
            if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    function Getplayerhit()
        bladehits = {}
        for X, X in pairs(workspace.Characters:GetChildren()) do
            if X.Name ~= game.Players.LocalPlayer.Name and X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    local X = (Services.ReplicatedStorage.Modules.Net)
    local w = require(X):RemoteEvent("RegisterAttack", true)
    local D = require(X):RemoteEvent("RegisterHit", true)
    function h:Attack()
        local X = {}
        for y, y in pairs(GetAllBladeHits()) do table.insert(X, y) end
        for y, y in pairs(Getplayerhit()) do table.insert(X, y) end
        if #X == 0 then return end
        local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
        for L, L in pairs(X) do
            w:FireServer(0)
            if not y[1] then y[1] = L.Head end
            table.insert(y[2], {[1] = L, [2] = L.HumanoidRootPart})
            table.insert(y[2], L)
        end
        D:FireServer(unpack(y))
    end
    task.spawn(function()
        while task.wait(.06) do if _G.FastAttack == os.time() then pcall(function() h:Attack() end) end end
    end)
    function W.Attack(h) pcall(function() _G.FastAttack = os.time() end) end
    CombatController = {GRAB = true, GRAB_DISTANCE = SeaIndex == 1 and 250 or 350, MAX_ATTACK_DURATION = 2, MAX_ATTACK_DURATION_2 = 60, LEVITATE_TIME = 0, CurrentIndex = 1}
    LastFound = os.time()
    function CombatController.Grab(h)
        pcall(sethiddenproperty, game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        if not CombatController.GRAB or GrabDebounce == os.time() then end
        GrabDebounce = os.time()
        local X, w = Vector3.zero, 0
        ForcePosition = nil
        local D = {}
        for y, y in Services.Workspace.Enemies:GetChildren() do
            if y.Name == h then
                if y:FindFirstChild('Humanoid') and y:FindFirstChild("HumanoidRootPart") and y.Humanoid.Health > 0 then
                    local h = y.HumanoidRootPart.Position
                    if h and isnetworkowner(y.PrimaryPart) then
                        if not ForcePosition or CaculateDistance(h, ForcePosition) < CombatController.GRAB_DISTANCE then
                            w = w + 1
                            y:SetAttribute("OldPosition", y:GetAttribute('OldPosition') or h)
                            X = X + h
                            ForcePosition = ForcePosition or h
                            table.insert(D, y)
                        end
                    end
                end
            end
        end
        X = CFrame.new(X / w)
        table.foreach(D, function(h, h)
            (function()
                if h:GetAttribute("IgnoreGrab") then return end
                if (h:GetAttribute("FailureCount") or 0) > 7 then return end
                local w = h:FindFirstChild("HumanoidRootPart")
                local D = w:FindFirstChild('FarmingVelocity')
                if not D then
                    D = Instance.new('BodyVelocity')
                    D.Name = 'FarmingVelocity'
                    D.MaxForce = Vector3.new(4000, 4000, 4000)
                    D.Parent = w
                end
                D.Velocity = Vector3.new(0, 0, 0)
                local D = w:FindFirstChild("FarmingPosition")
                if not D then
                    D = Instance.new("BodyPosition")
                    D.Name = 'FarmingPosition'
                    D.MaxForce = Vector3.new(4000, 4000, 4000)
                    D.P = 4.12
                    D.D = 1000
                    D.Parent = w
                end
                h:SetAttribute('IsGrabbed', true)
                h.HumanoidRootPart.CFrame = X
                h:SetAttribute("MidPoint", X)
            end)()
        end)
    end
    function Sort1(h) return h and h:FindFirstChild("HumanoidRootPart") and math.floor(CaculateDistance(h.HumanoidRootPart.CFrame)) end
    function CombatController.Search(h)
        local X = {}
        local w = false
        for D, D in GetMonAsSortedRange() do
            if table.find(h, D.Name) and D:FindFirstChild("Humanoid") and D.Humanoid.Health > 0 then
                if (D:GetAttribute('FailureCount') or 0) < 3 then
                    w = true
                    table.insert(X, D)
                end
            end
        end
        table.sort(X, function(D, y) return Sort1(D) < Sort1(y) end)
        if w then
            local w = X[1]
            return w
        end
        for X, X in h do
            local h = game.ReplicatedStorage:FindFirstChild(X)
            if h then return h end
        end
    end
    function CombatController.Attack(h, X, w, D)
        if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]['InCombat'] then
            TweenController.Create(Vector3.new(0, 0, 0))
            return
        end
        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        h = type(h) == "string" and {h} or (h or {})
        for y, L in (h) do
            local b = tostring(L)
            if b == 'Deandre' or b == "Urban" or b == "Diablo" and (os.time() - (LastFire12 or 0)) > 180 then
                LastFire12 = os.time()
                Remotes.CommF_:InvokeServer("EliteHunter")
            end
            if X then
                local b = GetMonAsSortedRange()[1]
                local C = b and b:FindFirstChild('HumanoidRootPart') and b.HumanoidRootPart.Position
                if C and CaculateDistance(C) < w then MonResult = b end
            else
                MonResult = CombatController.Search(h)
            end
            if MonResult then
                LastFound = os.time()
                local h, w = 0, os.time()
                local w, b = 0, os.time()
                while task.wait() do
                    if _G.Stop then return end
                    if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"] then
                        TweenController.Create(Vector3.new(0, 0, 0))
                        return
                    end
                    local C = MonResult:FindFirstChild('Humanoid')
                    local p = MonResult:FindFirstChild('HumanoidRootPart')
                    if not C or C.Health <= 0 then
                        if MonResult.Name == "Don Swan" then Storage:Set("SwanDefeated", true) end
                        break
                    end
                    TweenController.Create(CaculateCircreDirection(p.CFrame) + Vector3.new(0, 35, 0))
                    if CaculateDistance(p.Position + Vector3.new(0, 35, 0)) < 150 then
                        y = D and D()
                        CombatController.Grab(L or '')
                        if MonResult.Name ~= "Core" then
                            if ScriptStorage.PlayerData.Level > 100 and w >= CombatController.MAX_ATTACK_DURATION_2 and C.Health - C.MaxHealth == 0 then
                                SetTask('SubTask', 'Hop Server - Mob Health Unchanged ( ' .. C.Health .. ' / ' .. C.MaxHealth .. ')')
                                alert("stuck", "Mob health unchanged")
                                _G.Stop = true
                                
                            end
                            if h >= CombatController.MAX_ATTACK_DURATION and C.Health - C.MaxHealth == 0 then
                                h = 0
                                local D = MonResult:GetAttribute('OldPosition')
                                if D then
                                    MonResult:SetPrimaryPartCFrame(CFrame.new(D))
                                    MonResult:SetAttribute('IgnoreGrab', true)
                                    MonResult:SetAttribute('FailureCount', (MonResult:GetAttribute("FailureCount") or 0) + 1)
                                    alert('Failed to attack', "Returning to the old posiiton ( #" .. MonResult:GetAttribute("FailureCount") .. " )")
                                    MonResult.HumanoidRootPart.CFrame = (CFrame.new(D))
                                    task.wait()
                                    return
                                end
                            end
                        end
                        if (FarmFruitMastery or math.huge) - os.time() < 3 and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30 and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                            TweenController.Create((p.CFrame) + Vector3.new(0, 25, 0))
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Blox Fruit')
                            LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                            local D = {'Z', 'X', "C", 'V'}
                            local y = D[math.random(1, #D)]
                            SendKey(y, .31)
                        else
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(ScriptStorage.ForceToUseSword and 'Sword' or "Melee")
                        end
                        W:Attack(MonResult)
                        if os.time() ~= b then
                            b = os.time()
                            h = h + 1
                            w = w + 1
                        end
                        if h > 30 and MonResult.Name ~= "Core" then
                            alert("Take more than 30s to attack, canceling")
                            break
                        end
                    end
                end
            elseif not X then
                local h = ScriptStorage.MobRegions[L]
                if not h then
                    local X = Services.Workspace.Enemies:FindFirstChild(L) or game.ReplicatedStorage:FindFirstChild(L)
                    h = X and {X:GetPrimaryPartCFrame().p}
                end
                if not h then
                    Report('[ Game data error ] Mob with name ' .. tostring(L) .. ' have no spawn region datas')
                    return
                end
                local X
                if not h[CombatController.CurrentIndex] then CombatController.CurrentIndex = 1 end
                X = h[CombatController.CurrentIndex]
                local h = os.time()
                TweenController.Create(X + Vector3.new(0, 35, 35))
                if CaculateDistance(X + Vector3.new(0, 35, 35)) < 15 then CombatController.CurrentIndex = CombatController.CurrentIndex + 1 end
            end
        end
    end
    LevelFarmTTL = 0
    LastTravel = os.time()
    FunctionsHandler = {Initalized = false}
    print(3000)
    setmetatable(FunctionsHandler, {__index = function(h, X)
        QueryResult = rawget(h, X)
        if not QueryResult then
            return {
                Register = function(w)
                    if w == false then return end
                    Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                    function Result.RegisterMethod(w, D, y)
                        w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                        return true
                    end
                    setmetatable(Result.Constants, {__newindex = function() assert(false, 'cannot change constant value!') end})
                    if h.Constants[Key] then
                        function Result.SaveConstant(w, w, w) return assert(false, 'constant name was used before!') end
                        rawset(h.Constants, Key, Value)
                    end
                    function Result.Set(h, w, D)
                        h.CacheListener[w] = D
                        return D
                    end
                    function Result.Get(h, w) return h.Constants[w] or h.RealCache[w] end
                    function Result.AddVariableChangeListener(h, w, D) h.Events[w] = D end
                    Result.CacheListener.__parent = Result
                    setmetatable(Result.CacheListener, {__newindex = function(h, w, D)
                        _ = h.__parent.Events[w] and h.__parent.Events[w](w, D)
                        h.__parent.RealCache[w] = D
                    end})
                    FunctionsHandler[X] = Result
                end, Initalized = false
            }
        end
        return QueryResult
    end})
    function FunctionsHandler.SynchorizeUntilModuleLoaded(h, X)
        local w = os.time()
        while not h.Initalized do
            task.wait()
            local h = os.time() - w
            assert(not (X and h > X), "timed out")
        end
    end
    function GetCurrentClaimQuest(h)
        local h = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        return h, game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    FunctionsHandler.MirrorAndValk:Register()
    FunctionsHandler.LocalPlayerController.Register()
    FunctionsHandler.ExpRedeem:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.Saber:Register()
    FunctionsHandler.Rengoku:Register()
    FunctionsHandler.Yama:Register()
    FunctionsHandler.Tushita:Register()
    FunctionsHandler.SpikeyTrident:Register()
    FunctionsHandler.SharkAchor:Register()
    FunctionsHandler.Pole:Register()
    FunctionsHandler.FoxLamp:Register()
    FunctionsHandler.DarkDagger:Register()
    FunctionsHandler.Canvander:Register()
    FunctionsHandler.BuddySword:Register()
    FunctionsHandler.HallowScythe:Register()
    FunctionsHandler.CursedDualKatana:Register()
    FunctionsHandler.AcidumRifle:Register()
    FunctionsHandler.Kabucha:Register()
    FunctionsHandler.VenomBow:Register()
    FunctionsHandler.SoulGuitar:Register()
    FunctionsHandler.DragonStorm:Register()
    FunctionsHandler.InsictV2:Register()
    FunctionsHandler.RainbowSaviour:Register()
    FunctionsHandler.DarkBladeV2:Register()
    FunctionsHandler.SecondSeaPuzzle:Register()
    FunctionsHandler.ColosseumPuzzle:Register()
    FunctionsHandler.Trevor:Register()
    FunctionsHandler.EvoRace:Register()
    FunctionsHandler.Wenlocktoad:Register()
    FunctionsHandler.DarkBladeV3:Register()
    FunctionsHandler.ThirdSeaPuzzle:Register()
    FunctionsHandler.DojoQuest:Register()
    FunctionsHandler.RaceAwakening:Register()
    FunctionsHandler.PirateRaid:Register()
    FunctionsHandler.RaidController:Register()
    FunctionsHandler.MeleesController:Register()
    FunctionsHandler.Superhuman:Register()
    FunctionsHandler.DeathStep:Register()
    FunctionsHandler.SharkmanKarate:Register()
    FunctionsHandler.ElectricClaw:Register()
    FunctionsHandler.DragonTalon:Register()
    FunctionsHandler.Godhuman:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.CollectDrops:Register()
    FunctionsHandler.CollectBerries:Register()
    FunctionsHandler.UtillyItemsActivitation:Register()
    FunctionsHandler.ExpRedeem:RegisterMethod("Refresh", function() return ScriptStorage.PlayerData.Level < MaxLevel and getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 and not Storage.Get(Storage, "IsCodesRanOut") end)
    FunctionsHandler.ExpRedeem:RegisterMethod("Start", function()
        local h = {'BANEXPLOIT', 'NOMOREHACKS', "WildDares", 'BossBuild', 'GetPranked', 'EARN_FRUITS', "Sub2UncleKizaru", 'FIGHT4FRUIT', "kittgaming", 'TRIPLEABUSE', "Sub2CaptainMaui", 'Sub2Fer999', "Enyu_is_Pro", "Magicbus", "JCWK", 'Starcodeheo', 'Bluxxy', 'SUB2GAMERROBOT_EXP1', 'Sub2NoobMaster123', 'Sub2Daigrock', "Axiore", "TantaiGaming", 'StrawHatMaine', 'Sub2OfficialNoobie', "TheGreatAce", "SEATROLLIN", "24NOADMIN", 'ADMIN_TROLL', 'NEWTROLL', 'SECRET_ADMIN', "staffbattle", "NOEXPLOIT", "NOOB2ADMIN", "CODESLIDE", "fruitconcepts"}
        for X, X in h do
            SetTask("MainTask", 'Code Redemption | ' .. X .. ' | Redeeming...')
            local h = (Remotes.Redeem:InvokeServer(X))
            task.wait()
            SetTask('MainTask', 'Code Redemption | ' .. X .. " | " .. (h or "Failed"))
            if getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 then
                if h and string.find(h, 'SUCC') then
                    return SetTask('MainTask', 'Code Redemption | X2 Exp Boost Activated!') and task.wait(1)
                end
            else
                return
            end
        end
        Storage:Set("IsCodesRanOut", 1)
        Storage:Save()
    end)
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        local h = ScriptStorage.PlayerData.Level
        if h < 50 then return 1
        elseif h < 70 then return 2
        else return 4 end
        return true
    end)
        FunctionsHandler.LevelFarm:RegisterMethod("Start", function(h)
        if FunctionsHandler.MeleesController and FunctionsHandler.MeleesController.Methods.Start then
            pcall(function() FunctionsHandler.MeleesController.Methods.Start:Call() end)
        end
        if SeaIndex == 3 then
            if (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 50 then

                if os.time() > (BonesCooldown or 0) then
                    local X, X, X, w = Remotes.CommF_:InvokeServer("Bones", 'Check')
                    print("State", X, "Message", w)
                    if tonumber(X or 1) == 0 then
                        local X = Split(w, ":")
                        local w = ((tonumber(X[1]) * 60) + tonumber(X[2])) * 60
                        BonesCooldown = os.time() + w
                        print('Next', BonesCooldown)
                    else
                        print('Roll')
                        Remotes.CommF_:InvokeServer('Bones', 'Buy', 1, 1)
                    end
                end
            end
        end
        local X = ScriptStorage.PlayerData.Level
        if GodHumanFlag then
            local w, D = (function()
                getgenv()["   mphm ><<3"] = {}
                for y, L in GodhumanMaterials do
                    if (ScriptStorage.Backpack[y] or {Count = 0}).Count < L[1] then
                        getgenv()['   mphm >< <3'] = {y, L}
                    end
                end
                return unpack(getgenv()["   mphm >< <3"])
            end)()
            if w then
                if SeaIndex ~= D[2] then
                    alert('Material - ' .. w, "Travelling sea " .. D[2])
                    SetTask("MainTask", 'Sea Travel | Godhuman Materials | Travelling to Sea ' .. D[2])
                    Remotes.CommF_:InvokeServer("Travel" .. SeaIndexes[D[2]])
                    return
                end
                SetTask("MainTask", "Material Farming | Godhuman | " .. w .. " | In Progres")
                if X >= D[4][3] then
                    local w, y = GetCurrentClaimQuest()
                    if w then
                        if not string.find(y, D[3][1]) and not string.find(y, D[3][2]) then J.AbandonQuest()
                        else CombatController.Attack(D[3]); return end
                    else
                        local w = ScriptStorage.NPCs[D[4][4]]
                        w = w and w:GetModelCFrame()
                        if w then
                            TweenController.Create(w + Vector3.new(0, 5, 3))
                            if CaculateDistance(w) < 10 then task.wait(1)
                            else return end
                        else
                            Report("NPC HauntedQuest2 not found")
                        end
                        J.StartQuest(D[4][1], D[4][2])
                        return
                    end
                end
                CombatController.Attack(D[3])
            end
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            Remotes.CommF_:InvokeServer("BuyGodhuman")
            GodHumanFlag = false
            return true
        end
        if os.time() - LastTravel > 60 then
            LastTravel = os.time()
            if X >= 1500 and SeaIndex == 2 then
                if Config.Settings.StayInSea2UntilHaveDarkFragments and not ScriptStorage.Backpack['Dark Fragment'] then
                elseif not Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') then
                    Remotes.CommF_:InvokeServer("TravelZou")
                    SetTask('MainTask', 'Sea Travel | Teleporting to Third Sea')
                end
            elseif X >= 700 and SeaIndex == 1 then
                SetTask('MainTask', 'Sea Travel | Teleporting to Second Sea')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
        end
        if ScriptStorage.Tools['God\'s Chalice'] and not ScriptStorage.Backpack['Mirror Fractal'] then
            if (ScriptStorage.Backpack["Conjured Cocoa"] or {Count = 0}).Count < 10 then
                SetTask("MainTask", "Material Farming | Conjured Cocoa | Need 10x | Farming...")
                CombatController.Attack({"Cocoa Warrior", "Chocolate Bar Battler"})
                return
            end
            Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        end
        if ScriptStorage.Tools['Sweet Chalice'] or (X == MaxLevel and (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 500) then
            SetTask("MainTask", "Fragments Farming | Cake Prince | Dough King")
            if (ScriptStorage.Tools["Sweet Chalice"]) and (not SpawnReflect or os.time() - SpawnReflect > 10) then
                task.spawn(function()
                    while not ScriptStorage.Enemies['Dough King'] and task.wait() and ScriptStorage.Tools["Sweet Chalice"] do
                        SpawnReflect = os.time()
                        Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end
                end)
            end
            CombatController.Attack({"Head Baker", 'Baking Staff', 'Cookie Crafter', "Cake Guard"})
            if X >= 2200 then
                local w, D = GetCurrentClaimQuest()
                if w then
                    if not string.find(D, "Cookie") then J.AbandonQuest()
                    else Remotes.CommF_:InvokeServer('CakePrinceSpawner'); return end
                else
                    print('Start Quest')
                    local w = ScriptStorage.NPCs["Cake Quest Giver 1"]
                    w = w and w:GetModelCFrame()
                    if w then
                        TweenController.Create(w + Vector3.new(0, 5, 3))
                        if CaculateDistance(w) < 10 then task.wait(1)
                        else return end
                    else
                        Report("NPC HauntedQuest2 not found")
                    end
                    J.StartQuest("CakeQuest1", 1)
                    return
                end
            end
            print("attack ohoo")
            return
        end
        if X >= 2025 and (getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 or X <= MaxLevel) and (ScriptStorage.Backpack.Bones or {Count = 0}).Count < 500 then
            SetTask('MainTask', "Farming | Bones | For Mastery/Beli")
            CurrentClaimQuest3 = GetCurrentClaimQuest(true)
            if CurrentClaimQuest3 then
                if not string.find(CurrentClaimQuest3, 'Demonic') then J.AbandonQuest(); return
                else CombatController.Attack({'Reborn Skeleton', "Living Zombie", "Demonic Soul", 'Posessed Mummy'}); return end
            else
                print("StartQuest", CurrentClaimQuest3)
                local X = ScriptStorage.NPCs["Haunted Castle Quest Giver 2"]
                X = X and X:GetModelCFrame()
                if X then
                    TweenController.Create(X + Vector3.new(0, 5, 3))
                    if CaculateDistance(X) < 20 then task.wait(1)
                    else return end
                else
                    Report("NPC HauntedQuest2 not found")
                end
                J.StartQuest('HauntedQuest2', 1)
                return
            end
        end
        if h == 1 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack("Sky Bandit")
        elseif h == 2 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack('God\'s Guard')
        elseif h == 4 then
    local questData = GetTripleQuest()  
    local mobName   = questData.NameMonster
    local questId   = questData.NameQuest
    local questIdx  = questData.ID

    if not mobName or not questId then
        J:RefreshQuest()
        return
    end

    CurrentClaimQuest1 = GetCurrentClaimQuest()

    if CurrentClaimQuest1 then
        if CurrentClaimQuest1 ~= mobName and CurrentClaimQuest1 ~= (mobName .. "s") then
            J.AbandonQuest()
            return
        end
        SetTask("MainTask", "Level Farming | " .. mobName .. " | Defeating Enemies")
        local t = os.time()
        CombatController.Attack(mobName)
        LevelFarmTTL = LevelFarmTTL + os.time() - t
    else
        local npcCFrame = nil
        for _, npc in pairs(game.ReplicatedStorage.NPCs:GetChildren()) do
            if npc.Name and require(game.ReplicatedStorage.Quests)[questId] then
                -- Tìm NPC giao quest trong workspace
                local found = workspace.NPCs:FindFirstChild(npc.Name)
                if found and require(game.ReplicatedStorage.Quests)[questId][questIdx] then
                    local req = require(game.ReplicatedStorage.Quests)[questId][questIdx].LevelReq
                    if req then
                        npcCFrame = found:GetModelCFrame()
                        break
                    end
                end
            end
        end
        if not npcCFrame then
            J:RefreshQuest()
            npcCFrame = J.CurrentNpc
        end

        if not npcCFrame then
            Report("failed to get npc position for quest: " .. tostring(questId))
            return
        end

        TweenController.Create(npcCFrame + Vector3.new(0, 5, 3))
        SetTask("MainTask", "Level Farming | " .. mobName .. " | Claiming Quest")
        if CaculateDistance(npcCFrame) > 10 then return end

        task.wait(2)
        LevelFarmTTL = 0
        J.StartQuest(questId, questIdx)
        task.wait(1)

        SetTask("MainTask", "Level Farming | " .. mobName .. " | Defeating Enemies")
        local t = os.time()
        CombatController.Attack(mobName)
        LevelFarmTTL = LevelFarmTTL + os.time() - t
    end
end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod("EquipTool", function(h)
        if not Humanoid then return end
        for X, X in LocalPlayer.Backpack:GetChildren() do
            if X:IsA('Tool') and X.Name ~= "Tool" and (X.Name == tostring(h) or X.ToolTip == h) then
                LocalPlayer.Character:WaitForChild('Humanoid'):EquipTool(X)
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ToggleAbilities', function(h, X)
        if h == 'Buso' then
            if LocalPlayer:HasTag('Buso') and not X or X then Remotes.CommF_:InvokeServer('Buso') end
        elseif h == "Observation" then
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ConfigurationAbilitiesToggle', function()
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Buso', SCRIPT_CONFIG.BUSO)
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Observation', SCRIPT_CONFIG.OBSERVATION)
    end)
    print(3)
    FunctionsHandler.Saber:RegisterMethod('Refresh', function()
        if not Config.Items.Saber then return end
        if not Config.Items.Saber then return end
        local h
        if ScriptStorage.Backpack.Saber then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        local X = Remotes.CommF_:InvokeServer('ProQuestProgress')
        for w, w in X.Plates do if w == false then h = 1 end end
        if not h then
            if not X.UsedTorch then h = 2
            elseif not X.UsedCup then h = 3
            elseif not X.TalkedSon then h = 4
            elseif not X.KilledMob then h = 5
            elseif not X.UsedRelic then h = 6
            elseif not X.KilledShanks and ScriptStorage.Enemies["Saber Expert"] then h = 7 end
        end
        FunctionsHandler.Saber:Set("CurrentProgressLevel", h)
        FunctionsHandler.Saber:Set('LastestRefreshSenque', os.time())
        return h
    end)

    FunctionsHandler.Saber:RegisterMethod('GetQuestplates', function()
        local h = FunctionsHandler.Saber:Get("QuestplatesCache")
        if h then return h end
        local h = Services.Workspace.Map.Jungle
        local X = {}
        table.foreach(h.QuestPlates:GetChildren(), function(h, w) h = w:FindFirstChild("Button") and table.insert(X, w) end)
        FunctionsHandler.Saber:Get('QuestplatesCache', X)
        return X
    end)
    FunctionsHandler.Saber:RegisterMethod('Start', function()
        local h, X = FunctionsHandler.Saber:Get("CurrentProgressLevel"), FunctionsHandler.Saber:Get('LastestRefreshSenque')
        print("[ Debug ] Saber quest indexes", h)
        if not h then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        elseif h == 0 then
        elseif os.time() - X > 60 then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        else
            if h == 1 then
                local X = FunctionsHandler.Saber.Methods.GetQuestplates:Call()
                for w, D in X do
                    SetTask('MainTask', "Saber Quest | Quest Plates | Touching " .. w .. "/5")
                    while CaculateDistance(D.Button.CFrame) > 20 do
                        task.wait()
                        TweenController.Create(D.Button.CFrame)
                    end
                    task.wait(1)
                end
            elseif h == 2 then
                SetTask('MainTask', 'Saber Quest | Torch Puzzle | Using Torch')
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'GetTorch')
                task.wait(1)
                Remotes.CommF_:InvokeServer('ProQuestProgress', "DestroyTorch")
            elseif h == 3 then
                SetTask('MainTask', "Saber Quest | Sick Man | Helping with Cup")
                Remotes.CommF_:InvokeServer('ProQuestProgress', "GetCup")
                if ScriptStorage.Tools.Cup then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Cup')
                    task.wait(1)
                    Remotes.CommF_:InvokeServer("ProQuestProgress", 'FillCup', LocalPlayer.Character.Cup)
                end
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'SickMan')
            elseif h == 4 then
                SetTask('MainTask', 'Saber Quest | Rich Son | Getting Information')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
            elseif h == 5 then
                SetTask("MainTask", "Saber Quest | Mob Leader | Defeating Boss")
                CombatController.Attack('Mob Leader')
            elseif h == 6 then
                SetTask("MainTask", 'Saber Quest | Relic | Placing at Location')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            elseif h == 7 then
                SetTask('MainTask', "Saber Quest | Saber Expert | Final Battle")
                CombatController.Attack("Saber Expert")
            end
        end
    end)
    Remotes.RefreshQuestPro.OnClientEvent:Connect(FunctionsHandler.Saber.Methods.Refresh.Callback)
    MeleeLastCursor = 1
    FirstCall = true
    CanPurchase = {}
    FunctionsHandler.MeleesController:RegisterMethod('Start', function()
        for h, X in MeleesTable do
            if X ~= "SanguineArt" then
                if not Config.Items.AutoFullyMelees then break end
                Data = MeleePrices[X]
local w = Data.Buy(1)
CanPurchase[X] = w
                if not Data then
                    print('no m1 data')
                    break
                end
                if X == "Dragon Talon" then
                    IsFireEssenceGave = (function()
                        if IsFireEssenceGave ~= nil then return IsFireEssenceGave end
                        local D = Remotes.CommF_:InvokeServer('BuyDragonTalon', true)
                        alert('Dragon Talon Purchased', tostring(typeof(D) ~= "string"))
                        return typeof(D) ~= 'string' and true or false
                    end)()
                    print("IsFireEssenceGave", IsFireEssenceGave)
                    if not IsFireEssenceGave then
                        print('no fire essence provided')
                        break
                    end
                end
                if X == 'Godhuman' and not GodHumanFlag then
                    if (ScriptStorage.Melees['Dragon Talon'] or 0) > 399 then
                        if not ScriptStorage.Melees.Godhuman then
                            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                            Remotes.CommF_:InvokeServer('BuyGodhuman')
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                            if not ScriptStorage.Melees.Godhuman then
                                GodHumanFlag = true
                                return
                            end
                        end
                    end
                end
                if not ScriptStorage.Melees[X] or (ScriptStorage.Melees[X] or 0) < Data.NextLevelRequirement then
                    local D = GetMeleeIdByName(X)
                    local y = ScriptStorage.PlayerData
                    local L = true
                    if not D then return print('[ Debug ] Failed to get melee id of', X) end
                    MSet = false
                    if not w then
                        for w, D in Data.Price do
                            if y[w] < D and not FirstCall then
                                L = false
                                if not ScriptStorage.Melees[X] then
                                    MSet = true
                                    SetTask('SubTask', "Farming Until Enough " .. w .. " ( " .. D .. ' ) For ' .. X)
                                end
                                return
                            end
                        end
                    end
                    if not MSet and ScriptStorage.Melees[X] and ScriptStorage.Melees[X] < Data.NextLevelRequirement then
                        SetTask('SubTask', "Farming Until Enough Mastery For " .. X .. ' ( ' .. ScriptStorage.Melees[X] .. ' / ' .. Data.NextLevelRequirement .. " )")
                        if not ScriptStorage.Tools[X] then
                            print('no m1 found, buy')
                            Data.Buy()
                        end
                        return
                    end
                    if not FirstCall then
                        if L and Data.Requirements() and not ScriptStorage.Tools[X] then
                            if X == "Dragon Talon" and not IsFireEssenceGave then
                                alert('IsFireEssenceGave', tostring(IsFireEssenceGave))
                                return SetTask("SubTask", 'Waiting until have fire essence for dragon talon.')
                            end
                            Data.Buy()
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                            if not ScriptStorage.Tools[X] then
                                task.wait()
                                if not ScriptStorage.Tools[X] then
                                    if (X == 'Death Step' or X == "Sharkman Karate") and SeaIndex ~= 2 then
                                        alert("Go Back To Second Sea", "Water Key / Library Key")
                                        Remotes.CommF_:InvokeServer("TravelDressrosa")
                                    end
                                else
                                    MeleeLastCursor = h + 1
                                    return
                                end
                            else
                                MeleeLastCursor = h + 1
                                return
                            end
                        end
                    elseif not FirstCall then
                        MeleeLastCursor = h + 1
                    end
                end
            end
        end
        if FirstCall then
            FirstCall = false
            return
        end
        FarmingItem = nil
        for h, h in ScriptStorage.Backpack do
            if h.Type == "Sword" then
                if h.Name == 'Yama' or h.Name == "Tushita" then
                    MasteryRequirement = 350
                else
                    for X, X in h.MasteryRequirements do MasteryRequirement = X end
                end
                if h.Mastery < MasteryRequirement then
                    if h.Name == "Yama" or h.Name == "Tushita" then
                        FarmingItem = {h.Name, h.Mastery, MasteryRequirement}
                        break
                    end
                end
            end
        end
                if FarmingItem then
            SetTask("SubTask", "Farming mastery for " .. FarmingItem[1] .. " ( " .. FarmingItem[2] .. " / " .. FarmingItem[3] .. " )")
            if not ScriptStorage.Tools[FarmingItem[1]] then Remotes.CommF_:InvokeServer("LoadItem", FarmingItem[1]) end
            ScriptStorage.ForceToUseSword = FarmingItem
        end
    end)

    FunctionsHandler.SecondSeaPuzzle:RegisterMethod('Refresh', function()
        if ScriptStorage.PlayerData.Level < 700 or SeaIndex ~= 1 then return end
        if FunctionsHandler.SecondSeaPuzzle:Get('IsCompleted') then return end
        local k = Remotes.CommF_:InvokeServer('DressrosaQuestProgress')
        print(959, k.TalkedDetective, k.KilledIceBoss)
        if not k.TalkedDetective then Result = 1
        elseif not k.KilledIceBoss then
            if ScriptStorage.Enemies["Ice Admiral"] then Result = 2 end
        else
            FunctionsHandler.SecondSeaPuzzle:Set("IsCompleted", true)
        end
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.SecondSeaPuzzle:Set('LastestRefreshSenque', os.time())
        return Result
    end)
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Start", function()
        local k, h = FunctionsHandler.SecondSeaPuzzle:Get('CurrentProgressLevel'), FunctionsHandler.SecondSeaPuzzle:Get('LastestRefreshSenque')
        FunctionsHandler.SecondSeaPuzzle:Set('CurrentProgressLevel', nil)
        if not k then
            FunctionsHandler.SecondSeaPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.SecondSeaPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask('MainTask', "Auto Second Sea - Talk To Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
        elseif k == 2 then
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
            SetTask("MainTask", "Auto Second Sea - Defeating Ice Admiral")
            CombatController.Attack("Ice Admiral")
            Remotes.CommF_:InvokeServer('TravelDressrosa')
        end
    end)
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Refresh", function()
        if SeaIndex ~= 2 then return end
        if ScriptStorage.PlayerData.Level < 850 or ScriptStorage.Backpack['Warrior Helmet'] then return end
        local k = Remotes.CommF_:InvokeServer("BartiloQuestProgress")
        if not k.KilledBandits then Result = 1
        elseif not k.KilledSpring then
            if ScriptStorage.Enemies.Jeremy then Result = 2 end
        elseif not k.DidPlates then Result = 3 end
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.ColosseumPuzzle:Set("LastestRefreshSenque", os.time())
        return Result
    end)
    print(4)
    FunctionsHandler.ColosseumPuzzle:RegisterMethod('Start', function()
        local k, h = FunctionsHandler.ColosseumPuzzle:Get("CurrentProgressLevel"), FunctionsHandler.ColosseumPuzzle:Get("LastestRefreshSenque")
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", nil)
        print("Progress", k)
        if not k then
            FunctionsHandler.ColosseumPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.ColosseumPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask("MainTask", 'Auto Bartilo Quest - Defeating 50x Swan Pirate')
            local h, X = J:GetCurrentClaimQuest()
            if h then
                if not string.find(X, '50') then J.AbandonQuest()
                else CombatController.Attack("Swan Pirate") end
            else
                J.StartQuest('BartiloQuest', 1)
            end
        elseif k == 2 then
            SetTask('MainTask', "Auto Bartilo Quest - Defeating Jeremy")
            CombatController.Attack("Jeremy")
        elseif k == 3 then
            SetTask("MainTask", 'Auto Bartilo Quest - Doing Puzzle')
            if CaculateDistance(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566)) > 10 then
                alert("tween to")
                TweenController.Create(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566))
            else
                LocalPlayer = game.Players.LocalPlayer
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.0, 11, 1714)
                alert("1")
                task.wait(.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                alert('2')
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
                alert("3")
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(1)
                alert("4")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(1)
                alert('5')
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(1)
                alert("6")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(1)
                alert("7")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(1)
                alert("8")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
            end
        end
    end)
    FunctionsHandler.EvoRace:RegisterMethod("Refresh", function()
        if not Config.Items.RaceV2 then return end
        if SeaIndex ~= 2 then return end
        if getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost ~= 0 or ScriptStorage.PlayerData.Level < 900 or ScriptStorage.PlayerData.Beli < 1000000 or ScriptStorage.PlayerData.RaceLevel ~= 1 then return end
        return true
    end)
    FunctionsHandler.EvoRace:RegisterMethod('Start', function()
        Remotes.CommF_:InvokeServer('Alchemist', "1")
        Remotes.CommF_:InvokeServer('Alchemist', '2')
        for k = 1, 2, 1 do
            local h = ScriptStorage.Tools["Flower " .. k]
            local X = Services.Workspace:FindFirstChild('Flower' .. k)
            if not h then
                if X and X.Transparency == 0 then
                    SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. k)
                    while not ScriptStorage.Tools["Flower " .. k] do
                        task.wait()
                        TweenController.Create(X.CFrame + Vector3.new(0, math.random(-1.0, 2), 0))
                    end
                end
            end
        end
        if not ScriptStorage.Tools['Flower 3'] then
            SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. 3)
            CombatController.Attack('Swan Pirate')
        else
            SetTask("MainTask", 'Auto Race V2 - Idling')
            if LocalPlayer.Character.HumanoidRootPart.CFrame.Y < 50000 then
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
            end
            Remotes.CommF_:InvokeServer("Alchemist", "3")
            RefreshRace()
        end
    end)
    FunctionsHandler.BossesTask:RegisterMethod("Refresh", function()
        local k
        for h, h in BossesOrder do
            local X = BossesOrderLevel[h]
            if ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild("Humanoid") and X.Humanoid.Health > 0 then k = X end
            end
        end
        if k and (CaculateDistance(k.HumanoidRootPart.CFrame) < (SeaIndex == 2 and 3000 or 5000) or BossesOrderWL[tostring(k)] or ScriptStorage.PlayerData.Level == MaxLevel) then
            return k
        end
    end)
    FunctionsHandler.BossesTask:RegisterMethod('Start', function(k)
        if k then
            SetTask("MainTask", "Auto Farm Boss | Defeating " .. k.Name)
            CombatController.Attack(tostring(k), null, null, function() SpecialItems = nil end)
            SpecialItems = nil
        end
    end)
    FunctionsHandler.SpecialBossesTask:RegisterMethod('Refresh', function()
        local k
        for h, X in SpecialBossesOrder do
            if ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild('Humanoid') and X.Humanoid.Health > 0 then k = X end
            end
        end
        return k
    end)
    FunctionsHandler.SpecialBossesTask:RegisterMethod('Start', function(k)
        if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
            pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
        end
        if k then
            SetTask('MainTask', "Auto Farm Boss | Defeating " .. k.Name)
            CombatController.Attack(tostring(k))
        end
    end)
    FunctionsHandler.RaidController:RegisterMethod('RefreshRaidType', function()
        for k, k in require(game.ReplicatedStorage.Raids).raids do
            if string.find(ScriptStorage.PlayerData.DevilFruit, k) then
                FunctionsHandler.RaidController:Set('CurrentChip', k)
                return
            end
        end
        FunctionsHandler.RaidController:Set('CurrentChip', 'Flame')
    end)
    FunctionsHandler.RaidController:RegisterMethod('GetRaidableFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value < 1000000 then return k end
            end
        end
    end)
    FunctionsHandler.RaidController:RegisterMethod("GetCurrentRaidIsland", function()
        PlayerPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        IslandsList = {{}, {}, {}, {}, {}}
        for k, k in workspace['_WorldOrigin'].Locations:GetChildren() do
            if string.find(k.Name, 'Island ') and CaculateDistance(k.Position, Vector3.new(0, 0, 0)) > 7000 then
                (function()
                    local h = string.gsub(k.Name, "Island ", "")
                    local X = tonumber(h)
                    table.insert(IslandsList[X], k)
                end)()
            end
        end
        do
            for k = 5, 1, -1.0 do
                for h, h in IslandsList[k] do if CaculateDistance(h.Position) < 2000 then return h end end
            end
        end
    end)
    function CheckSpecialMicrochip()
        for k, k in {LocalPlayer.Character:GetChildren(), LocalPlayer.Backpack:GetChildren()} do
            for h, h in k do if k.Name == "Special Microchip" then return k end end
        end
    end
    FunctionsHandler.RaidController:RegisterMethod("Refresh", function()
    local k = ScriptStorage.PlayerData.Level
    local h = ScriptStorage.PlayerData.Fragments

    if k < 1300 or SeaIndex == 1 then return end
    if k < 1500 and h > 2000 then return end
    if k >= MaxLevel then
        local hasMirror = ScriptStorage.Backpack["Mirror Fractal"] ~= nil
        local hasValk = ScriptStorage.Backpack["Valkyrie Helm"] ~= nil
        if not hasMirror or not hasValk then
            return  
        end
    end

    if k < MaxLevel then
        if h > 5000 then return end
    else
        if h > 10000 then return end
    end

    local k = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
    if k then FunctionsHandler.RaidController:Set("CurrentProgressLevel", k) end
    return k or FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() or CheckSpecialMicrochip()
end)
    ---------
            FunctionsHandler.RaidController:RegisterMethod("Start", function()
        if not FunctionsHandler.RaidController:Get('CurrentChip') then FunctionsHandler.RaidController.Methods.RefreshRaidType:Call() end
        local k = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        RefreshInventory()
        FunctionsHandler.RaidController:Set("CurrentProgressLevel", nil)
        
        if not k then
            SetTask('MainTask', 'Auto Raid - Buying Chip - ' .. FunctionsHandler.RaidController:Get("CurrentChip"))
            if not ScriptStorage.Tools['Special Microchip'] then
                local h = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
                if h then
                    table.insert(ScriptStorage.IgnoreStoreFruits, h.Name)
                    Remotes.CommF_:InvokeServer('LoadFruit', h.Name)
                end
                Remotes.CommF_:InvokeServer("RaidsNpc", 'Select', FunctionsHandler.RaidController:Get('CurrentChip'))
                task.wait(2)
            end
            
            local targetIslandName = ({nil, 'Circle Island', "Boat Castle"})[SeaIndex]
            local targetIsland = ScriptStorage.Map[targetIslandName] or workspace.Map:FindFirstChild(targetIslandName)
            
            if not targetIsland then
                task.wait(1)
                return
            end
            
            if not targetIsland:FindFirstChild('RaidSummon2') then
                task.wait(1)
                TweenController.Create(targetIsland:GetModelCFrame() or targetIsland.CFrame)
            end
            
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
            
            task.spawn(function()
                local chip = LocalPlayer.Backpack:FindFirstChild("Special Microchip") or LocalPlayer.Character:FindFirstChild("Special Microchip")
                local raidButton = nil
                
                if targetIsland:FindFirstChild("RaidSummon2") and targetIsland.RaidSummon2:FindFirstChild("Button") then
                    raidButton = targetIsland.RaidSummon2.Button:FindFirstChild("Main")
                end

                if chip and raidButton and raidButton:FindFirstChild("ClickDetector") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(chip)
                    end
                    task.wait(0.2)
                    
                    local cd = raidButton.ClickDetector
                    local oldDist = cd.MaxActivationDistance
                    cd.MaxActivationDistance = math.huge
                    
                    fireclickdetector(cd)
                    
                    task.wait(0.1)
                    cd.MaxActivationDistance = oldDist
                else
                    if chip and raidButton and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid:EquipTool(chip)
                        end
                        task.wait(0.2)
                        
                        local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        LocalPlayer.Character.HumanoidRootPart.CFrame = raidButton.CFrame
                        task.wait(0.1)
                        if raidButton:FindFirstChild("ClickDetector") then
                            fireclickdetector(raidButton.ClickDetector)
                        end
                        task.wait(0.1)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                    end
                end
            end)
            
            local waitStart = os.time()
            SetTask("MainTask", "Auto Raid - Waiting Until Raid Is Started")
            
            repeat task.wait() until os.time() - (LastRaidAlert2 or 0) < 20 or os.time() - waitStart > 30
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            
            repeat task.wait() until os.time() - (LastRaidAlert or 0) < 20 or os.time() - waitStart > 30
            task.wait(0.5)
            
            if os.time() - waitStart > 30 then
                if not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                    Hop()
                    SetTask('MainTask', "Auto Raid | Raid Is Not Started?")
                end
            end
            LastRaidAlert = 0
        else
            SetTask('MainTask', "Auto Raid | " .. k.Name .. " /5")
            local h = false
            for X, X in GetMonAsSortedRange() do
                local w = os.time()
                while X and X:FindFirstChild("HumanoidRootPart") and X.Humanoid.Health > 0 and CaculateDistance(X.HumanoidRootPart.Position) < 1000 and os.time() - w < 60 and task.wait(.05) do
                    h = true
                    if string.find(X.Name, "Master") or true then
                        CombatController.Attack(X.Name)
                    else
                        pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
                        pcall(function()
                            X.HumanoidRootPart.CanCollide = false
                            X.Humanoid.Health = 0
                            X:BreakJoints()
                        end)
                    end
                end
            end
            if not h then TweenController.Create(k.Position + Vector3.new(0, 100, 0)) end
        end
    end)

---------

    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local k = {}
        for h in ScriptStorage.Backpack do k[FruitIdToName(h)] = h end
        for h, h in workspace:GetChildren() do
            if string.find(h.Name, 'Fruit') and not a:FindFirstChild(h.Name) and h:FindFirstChild("Handle") and not k[tostring(h)] and not ScriptStorage.Backpack[FruitNameToId(tostring(h))] then
                FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', h)
                return h
            end
        end
    end)
    FunctionsHandler.CollectDrops:RegisterMethod('Start', function()
        local k = FunctionsHandler.CollectDrops:Get('CurrentProgressLevel')
        FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', nil)
        if k then
            SetTask("MainTask", "Auto Collect Drop Items | " .. tostring(k))
            TweenController.Create(k:GetModelCFrame())
        end
    end)
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Refresh', function()
        print(1)
        if os.time() - timeee < 20 then return end
        print(2)
        if not SpecialItems then
            SpecialItems = {}
            local k = {}
            IceAdmiralPassed = true
            if not ScriptStorage.Backpack.Rengoku then
                table.insert(SpecialItems, "Hidden Key")
                IceAdmiralPassed = false
            end
            print(3)
            if SeaIndex == 2 and Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor") then
                table.insert(SpecialItems, 'Library Key')
                IceAdmiralPassed = false
            end
            print(4)
            if IceAdmiralPassed then table.insert(k, 'Awakened Ice Admiral') end
            print(5)
            local h = not ScriptStorage.Melees['Sharkman Karate'] and Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            print(6)
            SharkmanPassed = typeof(h) == 'string'
            if typeof(h) == "string" then
                table.insert(SpecialItems, 'Water Key')
            else
                TidePassed = true
                table.insert(k, 'Tide Keeper')
            end
            print(7)
            if ScriptStorage.Backpack.Yama then
                print("Elite")
                table.insert(k, "Deandre")
                table.insert(k, 'Urban')
                table.insert(k, 'Diablo')
            end
            print(8)
            local function h()
                local X = {}
                for w, w in BossesOrder do
                    local D = true
                    for y, y in k do if y == w then D = false end end
                    if D then table.insert(X, w) end
                end
                local k = #X
                for w = 1, k - 1 do
                    for D = 1, k - w do
                        local k = key and tostring(X[D][key]):lower() or tostring(X[D]):lower()
                        local w = key and tostring(X[D + 1][key]):lower() or tostring(X[D + 1]):lower()
                        if k > w then X[D], X[D + 1] = X[D + 1], X[D] end
                    end
                end
                return X
            end
            print(9)
            BossesOrder = h()
            for k, h in DropItemData do
                if not ScriptStorage.Backpack[k] and SeaIndex == h.Sea then
                    if ScriptStorage.PlayerData.Level >= h.Level then
                        BossesOrderLevel[h.Boss] = h.Level
                        table.insert(BossesOrder, h.Boss)
                    end
                end
            end
            print(10)
            if FunctionsHandler.Trevor:Get("IsCompleted") and not Storage:Get('SwanDefeated') then
                print("Added Don Swan to boss orser list")
                BossesOrderLevel["Don Swan"] = 1100
                table.insert(BossesOrder, 'Don Swan')
                print(ScriptStorage.PlayerData.Level, ScriptStorage.Enemies["Don Swan"])
                if SeaIndex == 2 and ScriptStorage.PlayerData.Level > 1500 and not ScriptStorage.Enemies['Don Swan'] then
                    print('hop')
                    alert("Don Swan", 'Hopping for Don Swan')
                    Hop()
                end
            end
        end
        print(11)
        for k, k in SpecialItems do
            if ScriptStorage.Tools[k] then
                FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', k)
                return k
            end
        end
        print(12)
        if SeaIndex == 3 and (ScriptStorage.Melees["Death Step"] or 0) >= 400 and (ScriptStorage.Melees["Black Leg"] or 0) >= 400 and ScriptStorage.PlayerData.Beli >= 2500000 and ScriptStorage.PlayerData.Fragments >= 5000 and not ScriptStorage.Melees['Electric Claw'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Previous Hero")
            return 'Previous Hero'
        end
        print(13)
        if ScriptStorage.Tools["Red Key"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Red Key")
            return 'Red Key'
        end
        print(14)
        if ScriptStorage.Tools['Hallow Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", 'Soul Reaper Spawner')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Hallow Essence")
            return "Soul Reaper Spawner"
        end
        print(15)
        if ScriptStorage.Tools['Fire Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Uzoth")
            return 'Uzoth'
        end
        print(16)
    end)
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Start', function()
        local k = FunctionsHandler.UtillyItemsActivitation:Get("CurrentProgressLevel")
        if k == 'Hidden Key' then
            Remotes.CommF_:InvokeServer("OpenRengoku")
        elseif k == 'Water Key' then
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Water Key")
            Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        elseif k == "Library Key" then
            Remotes.CommF_:InvokeServer("OpenLibrary")
            Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor"):Destroy()
        elseif k == "Red Key" then
            alert('Red Key', "Submitting red key to the scienctist.")
            Remotes.CommF_:InvokeServer('CakeScientist', "Check")
            ScriptStorage.Tools["Red Key"]:Destroy()
        ---------
        elseif k == 'Previous Hero' then
            SetTask("MainTask", "Electric Claw Quest | Running to Mansion")
            Remotes.CommF_:InvokeServer('BuyElectricClaw', "Start")
            task.wait(3)
            repeat
                task.wait()
                TweenController.Create(CFrame.new(-12548.0, 332.378 + math.random(-2.0, 2), -7617.0))
            until CaculateDistance(CFrame.new(-12548.0, 332.378, -7617.0)) < 30
            
            SetTask("MainTask", "Electric Claw Quest | Buying Melee")
            local Data = MeleePrices["Electric Claw"]
            if Data then
                Data.Buy()
            end
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
        elseif k == "Uzoth" then
---------

            print('Use Fire Essence')
            Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
            Remotes.CommF_:InvokeServer('BuyDragonTalon')
            IsFireEssenceGave = true
            Report("Fire Essence Used")
                elseif k == "Soul Reaper Spawner" then
            print("Use Hallow Essence")
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Hallow Essence")
            if CaculateDistance(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame) < 100 then SpecialItems = nil end
            TweenController.Create(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
        end

    end)
    FunctionsHandler.Trevor:RegisterMethod('GetFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value > 1000000 and k.Value < 2500000 then return k end
            end
        end
    end)
    FunctionsHandler.Trevor:RegisterMethod('Refresh', function()
        if FunctionsHandler.Trevor:Get('IsCompleted') or os.time() -  timeee < 1 then return end
        if ScriptStorage.PlayerData.Level < 1100 then return end
        local k = FunctionsHandler.Trevor.Methods.GetFruit:Call()
        if k then FunctionsHandler.Trevor:Set('Fruit', k) end
        TrevorDebounce = os.time()
        if not FunctionsHandler.Trevor:Get('IsCompleted') then
            print('Update IsCompleted')
            FunctionsHandler.Trevor:Set('IsCompleted', (Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0))
            print("Update IsCompleted", FunctionsHandler.Trevor:Get('IsCompleted'), Remotes.CommF_:InvokeServer("TalkTrevor", "1"), Remotes.CommF_:InvokeServer('TalkTrevor', "1") == 0)
        end
        return not FunctionsHandler.Trevor:Get("IsCompleted") and k
    end)
    FunctionsHandler.Trevor:RegisterMethod("Start", function()
        alert('[ cac ]', "Pulling fruit for trevor...")
        local k = FunctionsHandler.Trevor:Get("Fruit")
        FunctionsHandler.Trevor:Set('Fruit', nil)
        table.insert(ScriptStorage.IgnoreStoreFruits, k.Name)
        Remotes.CommF_:InvokeServer('LoadFruit', k.Name)
        task.wait()
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(FruitIdToName(k.Name))
        Remotes.CommF_:InvokeServer('TalkTrevor', '1')
        Remotes.CommF_:InvokeServer('TalkTrevor', "2")
        Remotes.CommF_:InvokeServer("TalkTrevor", "3")
        task.wait(1)
        FunctionsHandler.Trevor:Set('IsCompleted', true)
    end)
    print(4)
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 1500 or SeaIndex ~= 2 then return end
        if nil == FunctionsHandler.ThirdSeaPuzzle:Get('State') then
            ZQuestProgress = Remotes.CommF_:InvokeServer("ZQuestProgress", 'Check')
            print('ZQuestProgress', ZQuestProgress)
            FunctionsHandler.ThirdSeaPuzzle:Set("State", ZQuestProgress == 0)
        end
        return FunctionsHandler.ThirdSeaPuzzle:Get('State')
    end)
    ---------
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod('Start', function()
        local k = FunctionsHandler.ThirdSeaPuzzle:Get("State")
        if k then
            SetTask("MainTask", "Third Sea Puzzle | Teleporting to Boss")
            repeat
                task.wait(1)
                Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
            until CaculateDistance(Vector3.new(0, 0, 0)) > 20000
            
            task.wait(5)
            SetTask("MainTask", "Third Sea Puzzle | Defeating rip_indra")
            
            CombatController.Attack("rip_indra")
            FunctionsHandler.ThirdSeaPuzzle:Set("State", nil)
        end
    end)
---------

    FunctionsHandler.Yama:RegisterMethod('Refresh', function()
        if SeaIndex ~= 3 then return end
        if ScriptStorage.Backpack.Yama then return end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if FunctionsHandler.Yama:Get('EliteCount') >= 30 then return true end
    end)
    FunctionsHandler.Yama:RegisterMethod("Start", function()
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
    end)
    FunctionsHandler.PirateRaid:RegisterMethod("Refresh", function()
        local k = FunctionsHandler.PirateRaid:Get('Senque')
        return k and os.time() - k < 500
    end)
    FunctionsHandler.PirateRaid:RegisterMethod("Start", function()
        local k = GetMonAsSortedRange()
        local h = Vector3.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if k[1] then
            local X, w = k[1]:FindFirstChild("Humanoid"), k[1]:FindFirstChild("HumanoidRootPart")
            if w and X and X.Health > 0 and CaculateDistance(w.CFrame, h) < 500 then
                CombatController.Attack(k[1].Name)
                return
            end
        end
        TweenController.Create(h)
    end)
    function CheckFullMoon(k)
        if Lighting.Sky.MoonTextureId ~= 'http://www.roblox.com/asset/?id=970914431' then return end
        if k then return true end
        return Lighting.ClockTime > 18 or Lighting.ClockTime < 5
    end
    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items.SoulGuitar then return end
        if ScriptStorage.Backpack['Skull Guitar'] or not ScriptStorage.Backpack['Dark Fragment'] then return end
        if ScriptStorage.PlayerData.Level < 2300 then return end
        local k = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0})["Count"]
        local h = (ScriptStorage.Backpack["Bones"] or {Count = 0})['Count']
        if k < 250 then return 1 end
        if SeaIndex ~= 3 then return end
        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", 'Check')
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                SetTask('MainTask', 'Hopping for full moon ( soul guitar )')
                Hop()
            end
            return 7
        end
        if not SoulGuitarProcess.Swamp then return 2
        elseif not SoulGuitarProcess.Gravestones then return 3
        elseif not SoulGuitarProcess.Ghost then return 4
        elseif not SoulGuitarProcess.Trophies then return 5
        elseif not SoulGuitarProcess.Pipes then return 6
        elseif h >= 500 and not ScriptStorage.Backpack["Skull Guitar"] then return 8 end
    end)
    FunctionsHandler.SoulGuitar:RegisterMethod('Start', function(k)
        if k == 7 then
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            SoulGuitarProcess = Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
        elseif k == 1 then
            if SeaIndex ~= 2 then
                SetTask("MainTask", 'Teleport to second sea to farm ectoplasm')
                return Remotes.CommF_:InvokeServer("TravelDressrosa")
            else
                SetTask("MainTask", "Farming ectoplasms for soul guitar")
                CombatController.Attack({"Ship Deckhand", "Ship Engineer", 'Ship Steward', "Ship Officer"})
                return
            end
        elseif k == 2 then
            TTL9 = TTL9 or 0
            if os.time() ~= LastestTime1 then
                TTL9 = TTL9 + 1
                LastestTime1 = os.time()
            end
            if TTL9 > 60 then return Hop() end
            local h = {}
            for X, X in Services.Workspace.Enemies:GetChildren() do
                if X.name == "Living Zombie" then table.insert(h, X) end
            end
            if #h < 6 then
                SetTask('MainTask', 'Soul Guitar task 1 / 5: waiting until entity spawn')
                TweenController.Create(ScriptStorage.MobRegions["Living Zombie"][1] + Vector3.new(0, 30, 0))
            else
                local X = os.time()
                for w, D in h do
                    while task.wait() and D.Humanoid.Health > 7000 do
                        SetTask('MainTask', 'Soul Guitar task 1 / 5: Hit mob ' .. w .. " / 6")
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                        if os.time() - X > 60 then Hop() end
                        TweenController.Create(D.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
                        W:Attack()
                    end
                end
                SetTask("MainTask", 'Soul Guitar task 1 / 5: Attack')
                while workspace.Enemies:FindFirstChild("Living Zombie") and task.wait() do
                    if os.time() - X > 60 then Hop() end
                    CombatController.Attack('Living Zombie')
                end
            end
        elseif k == 3 then
            local W = workspace.Map["Haunted Castle"]
            while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                task.wait()
                SetTask("MainTask", "Soul Guitar task 2 / 5: completing placards")
                TweenController.Create(CFrame.new(-8800.0, 178, 6033))
            end
            for h, X in {Placard1 = "Right", Placard2 = "Right", Placard3 = "Left", Placard4 = 'Right', Placard5 = 'Left', Placard6 = 'Left', Placard7 = "Left"} do
                fireclickdetector(W[h][X].ClickDetector)
            end
        elseif k == 4 then
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
        elseif k == 5 then
            if CaculateDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                TweenController.Create(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
            else
                local W = workspace.Map['Haunted Castle'].Tablet
                for h, h in pairs(BlankTablets) do
                    local X = W[h]
                    if X.Line.Rotation.Z ~= 0 then
                        repeat task.wait() fireclickdetector(X.ClickDetector) until X.Line.Rotation.Z == 0
                    end
                end
                for h, X in pairs(Trophy) do
                    local w = workspace.Map["Haunted Castle"].Trophies.Quest[X].Handle.CFrame
                    w = tostring(w)
                    w = w:split(", ")[4]
                    local X = "180"
                    if w == "1" or w == "-1" then X = "90" end
                    if not string.find(tostring(W[h].Line.Rotation.Z), X) then
                        repeat task.wait() fireclickdetector(W[h].ClickDetector) until string.find(tostring(W[h].Line.Rotation.Z), X)
                    end
                end
            end
        elseif k == 6 then
            for W, h in pairs(Pipes) do
                pcall(function()
                    local X = workspace.Map['Haunted Castle']['Lab Puzzle'].ColorFloor.Model[W]
                    if X.BrickColor.Name ~= h then
                        repeat task.wait() fireclickdetector(X.ClickDetector) until X.BrickColor.Name == h
                    end
                end)
            end
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        elseif k == 8 then
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        end
    end)
    FunctionsHandler.Tushita:RegisterMethod("Refresh", function()
        if ScriptStorage.Backpack.Tushita then return end
        if ScriptStorage.PlayerData.Level < 2000 then return end
        if SeaIndex ~= 3 then return end
        TushitaProgress = TushitaProgress or Remotes.CommF_:InvokeServer("TushitaProgress")
        if not TushitaProgress.OpenedDoor then
            if ScriptStorage.Enemies["rip_indra True Form"] then
                TushitaProgress = nil
                return 1
            end
        else
            if ScriptStorage.Enemies['Longma'] then
                TushitaProgress = nil
                return 2
            end
        end
    end)
    FunctionsHandler.Tushita:RegisterMethod('Start', function(k)
        if k == 1 then
            alert('Auto Tushita', 'Placing torches...')
            TweenController.Create(CFrame.new(5714, math.random(19, 21), 256))
            if ScriptStorage.Tools["Holy Torch"] then
                for W = 1, 5 do Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", W) end
                return true
            end
        elseif k == 2 then
            alert("Auto Tushita", "Defeating Longma")
            CombatController.Attack("Longma")
        end
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items.CursedDualKatana then return end
        local k = ScriptStorage.Backpack
        if ScriptStorage.PlayerData.Level < 2200 then return end
        if k["Cursed Dual Katana"] or not k.Tushita or k.Tushita.Mastery < 350 or not k.Yama or k.Yama.Mastery < 350 then return end
        if SeaIndex ~= 3 then return end
        local k = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", 'Progress') or 'uwu'
        if not k or k == 'uwu' then return end
        if workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            alert('Cursed Dual Katana', 'Open Door')
            return {"break"}
        end
        local W = {Good = 'Tushita', Evil = 'Yama'}
        if k.Good == 4 and k.Evil == 4 then
            print("burn 2")
            return {'burn 2'}
        end
        if k.Good == 3 or k.Evil == 3 then
            print('burn 1')
            return {"burn"}
        end
        if k.Opened then
            for h, X in k do
                if h ~= 'Opened' and h ~= "Finished" and X < 3 then
                    print(h, X)
                    ScriptStorage.CdkCache = {h, X + 1}
                    if not ScriptStorage.Tools[W[h]] then Remotes.CommF_:InvokeServer('LoadItem', W[h]) end
                    alert("Cursed Dual Katana", "Start " .. tostring(W[h]) .. ' ' .. tostring(h))
                    Remotes.CommF_:InvokeServer('CDKQuest', 'StartTrial', h)
                    SetTask("MainTask", "Cursed Dual Katana - " .. tostring(W[h]) .. ' ' .. tostring(h))
                    return false
                end
            end
        end
        local k = ScriptStorage.CdkCache
        if not k then return end
        local W, h = k[1], k[2]
        if W == "Evil" and h == 3 then
            if not ScriptStorage.Enemies['Soul Reaper'] then
                ForceToRollBone = true
                return
            end
        elseif W == 'Good' then
            if h == 2 then
                SetTask("SubTask", 'CDK Quest / Waiting until pirate raid started')
                return
            elseif h == 3 and not ScriptStorage.Enemies["Cake Queen"] then
                Hop()
                SetTask('SubTask', "CDK Quest / Waiting until Cake Queen boss spawned")
                return
            end
        end
        return k
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("GetHazeMon", function()
        local k = {}
        for W, W in LocalPlayer.QuestHaze:GetChildren() do if W.Value > 0 then table.insert(k, W) end end
        table.sort(k, function(W, h) return CaculateDistance(W:GetAttribute('Position')) < CaculateDistance(h:GetAttribute('Position')) end)
        return tostring(k[1])
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("DoDimension", function(k)
        local W = string.gsub(k, ' ', "")
        local k = os.time()
        repeat
            task.wait()
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            if os.time() - k > 60 then return end
        until os.time() - TorchEnabledTime < 10
        repeat
            task.wait()
            local k = workspace.Map:WaitForChild(W, 10)
            if k then
                for h, h in k:GetChildren() do
                    if h and string.find(h.Name, "Torch") and h:FindFirstChild('ProximityPrompt') and h.ProximityPrompt.Enabled then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        h.ProximityPrompt.HoldDuration = 0
                        task.wait(1)
                        local X = game:GetService("VirtualInputManager")
                        X:SendKeyEvent(true, "E", 0, game)
                        X:SendKeyEvent(false, "E", 0, game)
                        fireproximityprompt(workspace.Map:WaitForChild(W, 10):FindFirstChild(tostring(h)).ProximityPrompt)
                    end
                    for W, W in workspace.Enemies:GetChildren() do
                        local h = W:FindFirstChild("HumanoidRootPart")
                        local X = W:FindFirstChild("Humanoid")
                        if h and X and CaculateDistance(h.CFrame) < 1000 then CombatController.Attack(W.Name) end
                    end
                end
                ExitDoor = k:FindFirstChild("Exit")
                print("exit door", ExitDoor)
                if ExitDoor then
                    PortalBrick = tostring(ExitDoor.BrickColor)
                    print("Brick color", ExitDoor, ExitDoor.BrickColor, PortalBrick)
                end
            else
                print('no island idk wt-')
            end
            print('loop damn', PortalBrick)
        until PortalBrick == 'Olive' or PortalBrick == "Cloudy grey"
        print('leave')
        while os.time() - DoneCdkTick > 15 do
            TweenController.Create(ExitDoor.CFrame + Vector3.new(0, math.random(1, 5), 0))
            task.wait()
        end
        Hop()
    end)
FunctionsHandler.MirrorAndValk:RegisterMethod("Refresh", function()
    if ScriptStorage.PlayerData.Level < MaxLevel then return end

    local hasMirror = ScriptStorage.Backpack["Mirror Fractal"] ~= nil
    local hasValk = ScriptStorage.Backpack["Valkyrie Helm"] ~= nil

    if not hasMirror then
        return "Mirror"
    end

    if not hasValk then
        return "Valk"
    end
end)

FunctionsHandler.MirrorAndValk:RegisterMethod("Start", function(State)

    if State == "Mirror" then

        SetTask("MainTask","Mirror Fractal")

        if ScriptStorage.Enemies["Dough King"] then
            CombatController.Attack("Dough King")
            return
        end

        HopToServerByAPI("Doughking" , 12 , 2)
        return
    end

    if State == "Valk" then

        SetTask("MainTask","Valkyrie Helm")

        if ScriptStorage.Enemies["rip_indra True Form"] then
            CombatController.Attack("rip_indra True Form")
            return
        end

        if ScriptStorage.Enemies["rip_indra"] then
            CombatController.Attack("rip_indra")
            return
        end

        HopToServerByAPI("RipIndra" , 12 , 2)
        return
    end
end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(k)
        local W = workspace.Map.Turtle.Cursed
        if k[1] == 'break' then
            TweenController.Create(workspace.Map.Turtle.Cursed.Breakable.CFrame)
            Remotes.CommF_:InvokeServer('CDKQuest', "OpenDoor")
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
            workspace.Map.Turtle.Cursed.Breakable:Destroy()
            CdkProgess = nil
            return
        end
        if k[1] == "burn 2" then
            if workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(10)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                task.wait(5)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(5)
                if CDKAttempts > 5 then Hop() end
                CdkProgess = nil
            end
        elseif k[1] == "burn" then
            for W = 1, 3, 1 do
                local h = workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W)
                if workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).CFrame)
                    until CaculateDistance(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).CFrame) < 5
                    fireproximityprompt(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).ProximityPrompt)
                    task.wait(3)
                    pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                end
                CdkProgess = nil
            end
        elseif k[1] == 'Evil' then
            if k[2] == 1 then
                local W = ScriptStorage.Enemies["Forest Pirate"]
                TweenController.Create((W and W.HumanoidRootPart.CFrame) or ScriptStorage.MobRegions["Forest Pirate"][0])
                CdkProgess = nil
            elseif k[2] == 2 then
                CombatController.Attack(FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call())
                CdkProgess = nil
            elseif k[2] == 3 then
                Report("found cdk yama 3")
                while not (os.time() - TorchEnabledTime < 100 or not ScriptStorage.Enemies["Soul Reaper"]) do
                    print("tweening to soul reaper")
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                    end
                    TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                end
                if not ScriptStorage.Enemies["Soul Reaper"] then return end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Hell Dimension")
                CdkProgess = nil
            end
        else
            if k[2] == 1 then
                for W, W in game.ReplicatedStorage.NPCs:GetChildren() do
                    if W.Name == "Luxury Boat Dealer" then
                        repeat
                            task.wait()
                            if os.time() - DoneCdkTick < 15 then return end
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (W:GetModelCFrame())
                            RealNPC = nil
                            for h, h in workspace.NPCs:GetChildren() do
                                if CaculateDistance(h:GetModelCFrame(), W:GetModelCFrame()) < 20 then
                                    RealNPC = h
                                    break
                                end
                            end
                        until CaculateDistance(W:GetModelCFrame()) < 5 and RealNPC
                        Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", RealNPC)
                    end
                end
                CdkProgess = nil
            elseif k[2] == 3 then
                repeat
                    task.wait()
                    print('attacking cage queen')
                    CombatController.Attack("Cage Queen")
                until os.time() - TorchEnabledTime < 10 or not ScriptStorage.Enemies['Cake Queen']
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                Report('Cake Queen')
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)
    local k = {Listeners = {}}
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = (function(W)
        for h, X in k.Listeners do
            if string.find(string.lower(W), string.lower(h)) then X(W) end
        end
    end)
    function k:RegisterNotifyListener(W, h) k.Listeners[W] = h end
    k:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    k:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    k:RegisterNotifyListener("been spotted approaching", function() FunctionsHandler.PirateRaid:Set('Senque', os.time()) end)
    k:RegisterNotifyListener('job', function() FunctionsHandler.PirateRaid:Set('Senque', 0) end)
    k:RegisterNotifyListener("level", function() AddPoint() end)
    k:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    k:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    k:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("[MeyyHub ] ", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or 'n/a'))
    end)
    k:RegisterNotifyListener('the raid with', function()
        if ScriptStorage.PlayerData.Level < MaxLevel then return end
        Remotes.CommF_:InvokeServer('Awakener', "Awaken")
    end)
    k:RegisterNotifyListener('quest completed', function()
        J:RefreshQuest()
        task.wait()
        if not J:GetCurrentClaimQuest() then J:MarkAsCompleted() end
    end)
    local k
    k = hookfunction(require(game.ReplicatedStorage.Notification).new, function(W, h)
        v21 = tostring(tostring(W or '') .. tostring(h or "")) or ""
        getgenv().NotificationCallBack(v21)
        return k(W, h)
    end)
    if SeaIndex ~= 1 then end
    function IfTableHaveIndex(k) for W in k do return true end end
    print(1)
    function GetServers()
        if LastServersDataPulled then
            if os.time() - LastServersDataPulled < 60 then return CachedServers end
        end
        for k = 1, 100, 1 do
            local W = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(k)
            if IfTableHaveIndex(W) then
                LastServersDataPulled = os.time()
                CachedServers = W
                return W
            end
        end
    end
    spawn(function()
        GetServers()
        while task.wait(180) do GetServers() end
    end)    
    function Hop()
    local servers = Services.HttpService:JSONDecode(
        game:HttpGetAsync("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    ).data

    for _, server in pairs(servers) do
        if server.playing < 8 and server.id ~= game.JobId then
            game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", server.id)
            break
        end
    end
    end
    Storage = {WRITE_DELAY = .5, Data = {}}
    LocalPlayer = game.Players.LocalPlayer
    local k = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(W) return Services.HttpService:JSONDecode(W) end
    function Encode(W) return Services.HttpService:JSONEncode(W) end
    print(5)
    function Storage.Set(W, h, X) W.Data[h] = X end
    function Storage.Get(W, h) return W.Data[h] end
    function Storage.Save(W) writefile(k, Encode(W.Data)) end
    if not isfile(k) then
        writefile(k, "{}")
        task.wait(1)
    end
    Storage.Data = {}
    pcall(function() Storage.Data = Decode(readfile(k) or '{}') end)
    spawn(function() while task.wait(Storage.WRITE_DELAY) do Storage:Save() end end)
    CreateTraceback('Initalize', "Initalizing script..")
    local k = {}
    SetTask("MainTask", 'n/a')
    SetTask("SubTask", 'n/a')
    ParsingTimes = 0
    function RefreshTasksData()
        if _G.Stop then return end
        for W, W in TasksOrder do
            local h = FunctionsHandler[W]
            if not h.Initalized then
                if not k[W] then
                    print("[ Debug ] Task", Name, "is not registered yet")
                    k[W] = true
                end
            else
                local k = h.Methods.Refresh
                local X = h.Methods.Start
                if k then
                    local h = k:Call(ParsingTimes < 100)
                    ParsingTimes = ParsingTimes + 1
                    if h and ParsingTimes > 100 then
                        CurrentTask = CurrentTask ~= W
                        CurrentTask = W
                        X:Call(h)
                        return
                    end
                end
            end
        end
    end
    AddPoint()
    J:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local J = {...}
        if string.find(J[1], 'Item') then RefreshInventory() end
    end)
    RefreshRace()
    a.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    QueueList = {}
    function NearbyHopHandler()
        do return end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
        NearbyHopHandlerDebounce = os.time()
        for J, J in a:GetPlayers() do
            local k = J and J.Character and J.Character:FindFirstChild("HumanoidRootPart") and J.Character.HumanoidRootPart.Position
            if k then
                local W = QueueList[J.Name]
                if not W then
                    QueueList[J.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop()
                            task.wait(5)
                        else
                            QueueList[J.Name] = nil
                        end
                    end
                end
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Stop then
                NearbyHopHandler()
                if LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.Humanoid.Sit then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
do
    pcall(RefreshPlayerData)
    local J = os.time() - timeee  -- dùng timeee thay vì r[3][r[2]]
    local r = J + OldSessionTime
    writefile(".tdif-" .. game.Players.LocalPlayer.Name, tostring(r))
    RefreshDebounce = os.time()
end
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", 'Buy')
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if not Config.Configuration.AutoHop then Hop() end
    end)
    while task.wait() do
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoinjng due idle in 10 min!")
            Hop()
        end
    if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
        local J, r = xpcall(RefreshTasksData, debug.traceback)
        if not J then 
            print('[ Error ]', r)
            task.wait(1) -- Tránh spam lỗi
        end
    else
        task.wait(1)
        pcall(RefreshPlayerData)
    end
    end
    --------
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if not isHopping and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", game.JobId)
    end
end)
end
hoangtuveu()
---------
---------
task.spawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    while true do
        local Backpack = LocalPlayer.Backpack
        local Character = LocalPlayer.Character
        
        if Character and Backpack then
            local chip = Backpack:FindFirstChild("Special Microchip") or Character:FindFirstChild("Special Microchip")
            
            local raidButton = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "RaidSummon2" and obj:FindFirstChild("Button") then
                    raidButton = obj.Button:FindFirstChild("Main")
                    break
                end
            end

            if chip and raidButton and raidButton:FindFirstChild("ClickDetector") then
                Character.Humanoid:EquipTool(chip)
                task.wait(0.2)
                
                local cd = raidButton.ClickDetector
                local oldDist = cd.MaxActivationDistance
                cd.MaxActivationDistance = math.huge
                
                fireclickdetector(cd)
                
                task.wait(0.1)
                cd.MaxActivationDistance = oldDist
            else
                if chip and raidButton and Character:FindFirstChild("HumanoidRootPart") and raidButton:FindFirstChild("ClickDetector") then
                    Character.Humanoid:EquipTool(chip)
                    task.wait(0.2)
                    
                    local oldCFrame = Character.HumanoidRootPart.CFrame
                    Character.HumanoidRootPart.CFrame = raidButton.CFrame
                    task.wait(0.1)
                    fireclickdetector(raidButton.ClickDetector)
                    task.wait(0.1)
                    Character.HumanoidRootPart.CFrame = oldCFrame
                end
            end
        end
        task.wait(5)
    end
end)
---------
