local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local UI_Elements = {}

local Themes = {
	Dark = {
		Background = Color3.fromRGB(0, 0, 0),
		BackgroundTrans = 0.4,
		StrokeColor = Color3.fromRGB(82, 82, 82),
		TextColor = Color3.fromRGB(255, 255, 255),
		LoopSeq = {
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(0, 0, 0),
			Color3.fromRGB(255, 255, 255),
			Color3.fromRGB(0, 0, 0)
		}
	}
}

local CurrentTheme = Themes.Dark
local StartTime = os.time()
local TotalTimeOffset = 0

local success, result = pcall(function()
	if isfile and readfile and isfile("meyy_capsule_time.json") then
		local data = HttpService:JSONDecode(readfile("meyy_capsule_time.json"))
		if data and data.FirstLaunch then
			TotalTimeOffset = os.time() - data.FirstLaunch
		end
	else
		if writefile then
			local data = {FirstLaunch = os.time()}
			writefile("meyy_capsule_time.json", HttpService:JSONEncode(data))
		end
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CapsuleStatusHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainCapsule = Instance.new("Frame")
MainCapsule.Name = "MainCapsule"
MainCapsule.Size = UDim2.new(0, 240, 0, 45)
MainCapsule.Position = UDim2.new(0.5, -120, 0, 20)
MainCapsule.BackgroundColor3 = CurrentTheme.Background
MainCapsule.BackgroundTransparency = CurrentTheme.BackgroundTrans
MainCapsule.BorderSizePixel = 0
MainCapsule.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainCapsule

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = MainCapsule

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainCapsule

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 0
UIStroke.Parent = MainCapsule 
UIGradient.Parent = UIStroke

local ExecutedLabel = Instance.new("TextLabel")
ExecutedLabel.Name = "ExecutedLabel"
ExecutedLabel.Size = UDim2.new(0.5, -15, 1, 0)
ExecutedLabel.Position = UDim2.new(0, 15, 0, 0)
ExecutedLabel.BackgroundTransparency = 1
ExecutedLabel.Font = Enum.Font.GothamBold
ExecutedLabel.TextSize = 12
ExecutedLabel.TextColor3 = CurrentTheme.TextColor
ExecutedLabel.TextXAlignment = Enum.TextXAlignment.Left
ExecutedLabel.Parent = MainCapsule

local TotalLabel = Instance.new("TextLabel")
TotalLabel.Name = "TotalLabel"
TotalLabel.Size = UDim2.new(0.5, -15, 1, 0)
TotalLabel.Position = UDim2.new(0.5, 0, 0, 0)
TotalLabel.BackgroundTransparency = 1
TotalLabel.Font = Enum.Font.GothamBold
TotalLabel.TextSize = 12
TotalLabel.TextColor3 = CurrentTheme.TextColor
TotalLabel.TextXAlignment = Enum.TextXAlignment.Right
TotalLabel.Parent = MainCapsule

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 1, 0, 20)
Divider.Position = UDim2.new(0.5, -0.5, 0.5, -10)
Divider.BackgroundColor3 = CurrentTheme.TextColor
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.Parent = MainCapsule

table.insert(UI_Elements, {Object = MainCapsule, Type = "Background"})
table.insert(UI_Elements, {Object = ExecutedLabel, Type = "Text"})
table.insert(UI_Elements, {Object = TotalLabel, Type = "Text"})

local function FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function ApplyTheme(theme)
	for _, element in ipairs(UI_Elements) do
		if element.Type = "Background" then
			TweenService:Create(element.Object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = theme.Background,
				BackgroundTransparency = theme.BackgroundTrans
			}):Play()
		elseif element.Type = "Text" then
			TweenService:Create(element.Object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextColor3 = theme.TextColor
			}):Play()
		end
	end
end

MainCapsule.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1.05}):Play()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
	end
end)

MainCapsule.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		local bounceTween = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1.2})
		bounceTween:Play()
		bounceTween.Completed:Connect(function()
			TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	local currentTime = os.time()
	local sessionElapsed = currentTime - StartTime
	local totalElapsed = TotalTimeOffset + sessionElapsed
	
	ExecutedLabel.Text = "EXE: " .. FormatTime(sessionElapsed)
	TotalLabel.Text = "TOT: " .. FormatTime(totalElapsed)
	
	local t = tick()
	UIGradient.Rotation = (t * 45) % 360
	
	local colorIndex = (math.floor(t * 2) % #CurrentTheme.LoopSeq) + 1
	local nextColorIndex = (colorIndex % #CurrentTheme.LoopSeq) + 1
	local alpha = (t * 2) % 1
	
	local sampledColor = CurrentTheme.LoopSeq[colorIndex]:Lerp(CurrentTheme.LoopSeq[nextColorIndex], alpha)
	UIStroke.Color = sampledColor
end)
