 
---------
---------
---------
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
MainFrame.Size = UDim2.new(0, 500, 0, 340)
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

local MainStrokeGrad = Instance.new("UIGradient")
MainStrokeGrad.Color = Theme.StrokeGrad
MainStrokeGrad.Parent = MainStroke
table.insert(StrokeGradients, MainStrokeGrad)

MakeDraggable(MainFrame, MainFrame)

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
Title.Text = "MEYY HUB | COMPACT STATS"
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
task.spawn(function()
    task.wait(0.5)
    CascadeItems()
    TweenNumber(LevelVal, 2800)
    TweenNumber(BeliVal, 19555559)
    TweenNumber(FragVal, 118249)
    
    task.wait(2.5)
    StatusAction.Text = "Buying Melee"
    StatusSubAction.Text = "Moving to location..."
    
    task.wait(1.5)
    SetItemState(1, true)
    
    task.wait(1.0)
    SetItemState(2, true)
    SetItemState(7, true)
    StatusAction.Text = "Checking Inventory"
    StatusSubAction.Text = "Scanning items & seas..."
    
    task.wait(1.5)
    SetItemState(3, true)
    SetItemState(4, true)
    SetItemState(8, true)
    StatusAction.Text = "Idle"
    StatusSubAction.Text = "Waiting for next task..."
end)
---------
---------
