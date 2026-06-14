
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
    Background = Color3.fromRGB(12, 12, 12),
    Darker = Color3.fromRGB(8, 8, 8),
    Active = Color3.fromHex("#888888"),
    ContainerBg = Color3.fromHex("#525252"),
    ContainerTrans = 0.4,
    PillBack = Color3.fromRGB(20, 25, 30),
    Text = Color3.fromHex("#FFFFFF"),
    TextDim = Color3.fromHex("#808080"),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(150, 255, 50),
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
local isMainVisible = true
local isMini3D = false

local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleContainer"
ToggleContainer.Size = UDim2.new(0, 60, 0, 30)
ToggleContainer.Position = UDim2.new(0, 20, 1, -60)
ToggleContainer.BackgroundColor3 = Theme.Active
ToggleContainer.BackgroundTransparency = 0.2
ToggleContainer.BorderSizePixel = 0
ToggleContainer.Parent = KaitunGui
Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleContainer)
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
local ToggleGrad = Instance.new("UIGradient", ToggleStroke)
ToggleGrad.Color = Theme.StrokeGrad
table.insert(StrokeGradients, ToggleGrad)

local ToggleBall = Instance.new("Frame")
ToggleBall.Name = "ToggleBall"
ToggleBall.Size = UDim2.new(0, 22, 0, 22)
ToggleBall.Position = UDim2.new(1, -26, 0.5, -11)
ToggleBall.BackgroundColor3 = Theme.Text
ToggleBall.BorderSizePixel = 0
ToggleBall.Parent = ToggleContainer
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = ""
ToggleButton.Parent = ToggleContainer
MakeDraggable(ToggleContainer, ToggleContainer)

---------
---------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = KaitunGui

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
Header.Parent = MainFrame

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

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -50, 0.5, -10)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextDim
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = Header
CreateButtonEffects(MinBtn)

local HDivider = Instance.new("Frame")
HDivider.Name = "HDivider"
HDivider.Size = UDim2.new(1, -20, 0, 1)
HDivider.Position = UDim2.new(0, 10, 0, 35)
HDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HDivider.BorderSizePixel = 0
HDivider.Parent = MainFrame

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
Body.Size = UDim2.new(1, 0, 1, -90)
Body.Position = UDim2.new(0, 0, 0, 40)
Body.BackgroundTransparency = 1
Body.Parent = MainFrame

local LeftCol = Instance.new("Frame")
LeftCol.Name = "LeftCol"
LeftCol.Size = UDim2.new(0.46, 0, 1, 0)
LeftCol.Position = UDim2.new(0, 15, 0, 5)
LeftCol.BackgroundTransparency = 1
LeftCol.Parent = Body

local RightCol = Instance.new("Frame")
RightCol.Name = "RightCol"
RightCol.Size = UDim2.new(0.46, 0, 1, 0)
RightCol.Position = UDim2.new(0.5, 4, 0, 5)
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
StatsTitle.TextSize = 10
StatsTitle.TextXAlignment = Enum.TextXAlignment.Left
StatsTitle.Parent = LeftCol

local function CreateStatBlock(parent, titleText, index)
    local Block = Instance.new("Frame")
    Block.Size = UDim2.new(1, 0, 0, 42)
    Block.Position = UDim2.new(0, 0, 0, 20 + ((index - 1) * 48))
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
    TitleLbl.Position = UDim2.new(0, 10, 0, 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = titleText
    TitleLbl.TextColor3 = Theme.TextDim
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Block

    local ValueLbl = Instance.new("TextLabel")
    ValueLbl.Size = UDim2.new(1, -10, 0, 20)
    ValueLbl.Position = UDim2.new(0, 10, 0, 18)
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
ItemsTitle.Text = "ITEMS & WORLD"
ItemsTitle.TextColor3 = Theme.TextDim
ItemsTitle.Font = Enum.Font.GothamBold
ItemsTitle.TextSize = 10
ItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
ItemsTitle.Parent = RightCol

local ItemLabels = {}

local function CreateItemRow(parent, itemName, index)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 20)
    Row.Position = UDim2.new(0, 5, 0, 20 + ((index - 1) * 24))
    Row.BackgroundTransparency = 1
    Row.GroupTransparency = 1
    Row.Parent = parent

    local RingBase = Instance.new("Frame")
    RingBase.Size = UDim2.new(0, 14, 0, 14)
    RingBase.Position = UDim2.new(0, 0, 0.5, -7)
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
    ItemText.Size = UDim2.new(1, -25, 1, 0)
    ItemText.Position = UDim2.new(0, 25, 0, 0)
    ItemText.BackgroundTransparency = 1
    ItemText.Text = itemName
    ItemText.TextTransparency = 0.6
    ItemText.Font = Enum.Font.GothamBold
    ItemText.TextSize = 11
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
        Index = index,
        Name = itemName
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
CreateItemRow(RightCol, "Sea 1", 6)
CreateItemRow(RightCol, "Sea 2", 7)
CreateItemRow(RightCol, "Sea 3", 8)

---------
---------
local StatusPill = Instance.new("Frame")
StatusPill.Name = "StatusPill"
StatusPill.Size = UDim2.new(1, -30, 0, 42)
StatusPill.Position = UDim2.new(0, 15, 1, -55)
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
StatusDotFrame.Position = UDim2.new(0, 60, 0.5, -8)
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
StatusAction.Size = UDim2.new(1, -85, 0, 18)
StatusAction.Position = UDim2.new(0, 80, 0, 5)
StatusAction.BackgroundTransparency = 1
StatusAction.Text = "Idle"
StatusAction.TextColor3 = Theme.Text
StatusAction.Font = Enum.Font.GothamBold
StatusAction.TextSize = 12
StatusAction.TextXAlignment = Enum.TextXAlignment.Left
StatusAction.Parent = StatusPill

local StatusSubAction = Instance.new("TextLabel")
StatusSubAction.Size = UDim2.new(1, -85, 0, 15)
StatusSubAction.Position = UDim2.new(0, 80, 0, 22)
StatusSubAction.BackgroundTransparency = 1
StatusSubAction.Text = "Waiting for tasks..."
StatusSubAction.TextColor3 = Theme.TextDim
StatusSubAction.Font = Enum.Font.GothamBold
StatusSubAction.TextSize = 10
StatusSubAction.TextXAlignment = Enum.TextXAlignment.Left
StatusSubAction.Parent = StatusPill

---------
---------
local MiniUI = Instance.new("Frame")
MiniUI.Name = "MiniUI"
MiniUI.Size = UDim2.new(0, 180, 0, 160)
MiniUI.Position = UDim2.new(1, -200, 0, 20)
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

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1, -20, 0, 20)
MiniTitle.Position = UDim2.new(0, 10, 0, 5)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "OWNER ITEM"
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 12
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniUI
ApplyTextGradient(MiniTitle, false)

local MiniDiv = Instance.new("Frame")
MiniDiv.Size = UDim2.new(1, -20, 0, 1)
MiniDiv.Position = UDim2.new(0, 10, 0, 30)
MiniDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniDiv.BorderSizePixel = 0
MiniDiv.Parent = MiniUI

local MiniDivGrad = Instance.new("UIGradient")
MiniDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
})
MiniDivGrad.Parent = MiniDiv

local OwnerItemsScroll = Instance.new("ScrollingFrame")
OwnerItemsScroll.Size = UDim2.new(1, -10, 1, -35)
OwnerItemsScroll.Position = UDim2.new(0, 5, 0, 35)
OwnerItemsScroll.BackgroundTransparency = 1
OwnerItemsScroll.ScrollBarThickness = 0
OwnerItemsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
OwnerItemsScroll.Parent = MiniUI

local OwnerListLayout = Instance.new("UIListLayout")
OwnerListLayout.Padding = UDim.new(0, 5)
OwnerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
OwnerListLayout.Parent = OwnerItemsScroll

local function AddToOwnerList(itemName)
    local newItem = Instance.new("TextLabel")
    newItem.Size = UDim2.new(1, -10, 0, 0)
    newItem.AutomaticSize = Enum.AutomaticSize.Y
    newItem.BackgroundTransparency = 1
    newItem.Text = "- " .. itemName
    newItem.Font = Enum.Font.GothamBold
    newItem.TextSize = 11
    newItem.TextXAlignment = Enum.TextXAlignment.Left
    newItem.TextWrapped = true
    newItem.Parent = OwnerItemsScroll
    
    local grad = ApplyTextGradient(newItem, false)
    table.insert(AnimatedGradients, grad)
end

---------
---------
local function TweenNumber(label, targetValue)
    local numVal = Instance.new("NumberValue")
    numVal.Value = 0
    
    numVal.Changed:Connect(function(val)
        label.Text = FormatNumber(math.floor(val))
    end)
    
    local tInfo = TweenInfo.new(2.0, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tw = TweenService:Create(numVal, tInfo, {Value = targetValue})
    tw:Play()
    
    tw.Completed:Connect(function()
        numVal:Destroy()
    end)
end

---------
---------
local function SetItemState(index, hasItem)
    local item = ItemLabels[index]
    if not item then return end
    
    item.HasItem = hasItem
    local targetColor = hasItem and Theme.Green or Theme.Red
    local targetTrans = hasItem and 0 or 0.6
    
    TweenService:Create(item.CenterDot, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(item.Wave1, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(item.Wave2, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(item.Text, TweenInfo.new(0.4), {TextTransparency = targetTrans}):Play()
    
    if hasItem then
        item.Grad.Enabled = true
        AddToOwnerList(item.Name)
    else
        item.Grad.Enabled = false
    end
end

---------
---------
local function CascadeItems()
    for _, item in ipairs(ItemLabels) do
        item.Row.Position = UDim2.new(0, 30, 0, 20 + ((item.Index - 1) * 24))
        item.Row.GroupTransparency = 1
    end
    
    for _, item in ipairs(ItemLabels) do
        TweenService:Create(item.Row, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 5, 0, 20 + ((item.Index - 1) * 24)),
            GroupTransparency = 0
        }):Play()
        task.wait(0.05)
    end
end

---------
---------
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
        MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, -200),
            GroupTransparency = 0
        }):Play()
        
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Active}):Play()
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -26, 0.5, -11)}):Play()
        CascadeItems()
    else
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Darker}):Play()
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
        
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -250, 0.5, -150),
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
    
    local animatedOffset = Vector2.new(math.sin(t * 2) * 0.4, 0)
    for _, grad in ipairs(AnimatedGradients) do
        if grad and grad.Parent then
            grad.Offset = animatedOffset
        end
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
    StatusAction.Text = "Checking Inventory"
    StatusSubAction.Text = "Scanning items..."
    
    task.wait(1.5)
    SetItemState(3, true)
    SetItemState(4, true)
    SetItemState(8, true)
    StatusAction.Text = "Idle"
    StatusSubAction.Text = "Waiting for next task..."
end)
---------
---------


