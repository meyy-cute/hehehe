local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        Transparency = 0.3,
        TextLight = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 160, 160),
        StrokeColors = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
    }
}

local UI_Elements = {}

---------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScannerUI"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local SelectionBox = Instance.new("Frame")
SelectionBox.Name = "SelectionBox"
SelectionBox.Size = UDim2.new(0, 200, 0, 200)
SelectionBox.Position = UDim2.new(0.5, -100, 0.5, -100)
SelectionBox.BackgroundTransparency = 1
SelectionBox.Parent = ScreenGui

local SelectionStroke = Instance.new("UIStroke")
SelectionStroke.Color = Color3.fromRGB(255, 255, 255)
SelectionStroke.Thickness = 2
SelectionStroke.LineJoinMode = Enum.LineJoinMode.Round
SelectionStroke.Parent = SelectionBox

local SelectionGradient = Instance.new("UIGradient")
SelectionGradient.Color = Themes.Dark.StrokeColors
SelectionGradient.Parent = SelectionStroke

local DragCorner = Instance.new("TextButton")
DragCorner.Name = "DragCorner"
DragCorner.Size = UDim2.new(0, 20, 0, 20)
DragCorner.Position = UDim2.new(1, -10, 1, -10)
DragCorner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DragCorner.Text = ""
DragCorner.Parent = SelectionBox

local DragCornerCorner = Instance.new("UICorner")
DragCornerCorner.CornerRadius = UDim.new(1, 0)
DragCornerCorner.Parent = DragCorner

---------
local ResultFrame = Instance.new("Frame")
ResultFrame.Name = "ResultFrame"
ResultFrame.Size = UDim2.new(0, 300, 0, 400)
ResultFrame.Position = UDim2.new(0, 20, 0.5, -200)
ResultFrame.BackgroundColor3 = Themes.Dark.Background
ResultFrame.BackgroundTransparency = Themes.Dark.Transparency
ResultFrame.Parent = ScreenGui

local ResultCorner = Instance.new("UICorner")
ResultCorner.CornerRadius = UDim.new(0, 10)
ResultCorner.Parent = ResultFrame

local ResultStroke = Instance.new("UIStroke")
ResultStroke.Color = Color3.fromRGB(255, 255, 255)
ResultStroke.Thickness = 1.5
ResultStroke.Parent = ResultFrame

local ResultStrokeGradient = Instance.new("UIGradient")
ResultStrokeGradient.Color = Themes.Dark.StrokeColors
ResultStrokeGradient.Parent = ResultStroke

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "SCANNED UI PATHS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Parent = ResultFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Themes.Dark.TextDark),
    ColorSequenceKeypoint.new(0.5, Themes.Dark.TextLight),
    ColorSequenceKeypoint.new(1, Themes.Dark.TextDark)
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleLabel

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -50)
ScrollFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = ResultFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 5)
ScrollLayout.Parent = ScrollFrame

---------
table.insert(UI_Elements, {Object = ResultFrame, Type = "Background"})
table.insert(UI_Elements, {Object = SelectionGradient, Type = "AnimatedGradient"})
table.insert(UI_Elements, {Object = ResultStrokeGradient, Type = "AnimatedGradient"})

---------
local isDraggingCorner = false
local dragStartPos = nil
local startSize = nil

DragCorner.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingCorner = true
        dragStartPos = input.Position
        startSize = SelectionBox.AbsoluteSize
        TweenService:Create(DragCorner, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -12, 1, -12)}):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingCorner then
            isDraggingCorner = false
            TweenService:Create(DragCorner, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 1, -10)}):Play()
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingCorner and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        local newWidth = math.max(50, startSize.X + delta.X)
        local newHeight = math.max(50, startSize.Y + delta.Y)
        SelectionBox.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

---------
local isDraggingBox = false
local boxDragStart = nil
local boxStartPos = nil

SelectionBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not isDraggingCorner then
            isDraggingBox = true
            boxDragStart = input.Position
            boxStartPos = SelectionBox.Position
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingBox = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingBox and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - boxDragStart
        SelectionBox.Position = UDim2.new(
            boxStartPos.X.Scale, boxStartPos.X.Offset + delta.X,
            boxStartPos.Y.Scale, boxStartPos.Y.Offset + delta.Y
        )
    end
end)

---------
local function getFullPath(obj)
    local path = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path = current.Name .. "." .. path
        current = current.Parent
    end
    return path
end

local function scanUI()
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local minX = SelectionBox.AbsolutePosition.X
    local minY = SelectionBox.AbsolutePosition.Y
    local maxX = minX + SelectionBox.AbsoluteSize.X
    local maxY = minY + SelectionBox.AbsoluteSize.Y

    local foundPaths = {}

    local function traverse(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsDescendantOf(ScreenGui) then
                local cX = child.AbsolutePosition.X
                local cY = child.AbsolutePosition.Y
                local cMaxX = cX + child.AbsoluteSize.X
                local cMaxY = cY + child.AbsoluteSize.Y

                if cX >= minX and cMaxX <= maxX and cY >= minY and cMaxY <= maxY then
                    table.insert(foundPaths, getFullPath(child))
                end
            end
            traverse(child)
        end
    end

    traverse(PlayerGui)

    for _, path in ipairs(foundPaths) do
        local pathLabel = Instance.new("TextLabel")
        pathLabel.Size = UDim2.new(1, 0, 0, 20)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Font = Enum.Font.Code
        pathLabel.Text = path
        pathLabel.TextColor3 = Themes.Dark.TextDark
        pathLabel.TextSize = 12
        pathLabel.TextXAlignment = Enum.TextXAlignment.Left
        pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
        pathLabel.Parent = ScrollFrame
    end
end

---------
local lastScan = 0
RunService.RenderStepped:Connect(function(dt)
    local timeTick = tick()
    
    for _, element in ipairs(UI_Elements) do
        if element.Type == "AnimatedGradient" then
            element.Object.Rotation = (timeTick * 50) % 360
        end
    end
    
    DragCorner.BackgroundTransparency = 0.5 + 0.3 * math.sin(timeTick * 5)
    
    if timeTick - lastScan > 0.5 then
        lastScan = timeTick
        scanUI()
    end
end)
