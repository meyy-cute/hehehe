---------
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

---------
local isfile = isfile or function() return false end
local readfile = readfile or function() return "{}" end
local writefile = writefile or function() end

---------
local guiName = "CapsuleStatusHub"
if CoreGui:FindFirstChild(guiName) then
	CoreGui[guiName]:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

---------
local Themes = {
	Dark = {
		BackgroundColor = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		TextColor = Color3.fromRGB(255, 255, 255),
		TextGradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 128, 128)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(211, 211, 211)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		}),
		DividerColor = Color3.fromRGB(255, 255, 255),
		DividerTransparency = 0.5,
		StrokeGradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		})
	}
}

local UI_Elements = {}

---------
local mainCapsule = Instance.new("Frame")
mainCapsule.Name = "MainCapsule"
mainCapsule.Size = UDim2.new(0, 240, 0, 45)
mainCapsule.Position = UDim2.new(0.5, -120, 0, 20)
mainCapsule.BackgroundColor3 = Themes.Dark.BackgroundColor
mainCapsule.BackgroundTransparency = Themes.Dark.BackgroundTransparency
mainCapsule.BorderSizePixel = 0
mainCapsule.Active = true
mainCapsule.Parent = screenGui
table.insert(UI_Elements, mainCapsule)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainCapsule

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = mainCapsule

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = Themes.Dark.StrokeGradient
strokeGradient.Parent = stroke

---------
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(0, 1, 0.6, 0)
divider.Position = UDim2.new(0.5, 0, 0.2, 0)
divider.BackgroundColor3 = Themes.Dark.DividerColor
divider.BackgroundTransparency = Themes.Dark.DividerTransparency
divider.BorderSizePixel = 0
divider.Parent = mainCapsule

local divGrad = Instance.new("UIGradient")
divGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 1)
})
divGrad.Rotation = 90
divGrad.Parent = divider

---------
local function createLabel(name, pos, align)
	local lbl = Instance.new("TextLabel")
	lbl.Name = name
	lbl.Size = UDim2.new(0.5, -15, 1, 0)
	lbl.Position = pos
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextColor3 = Themes.Dark.TextColor
	lbl.TextXAlignment = align
	lbl.Text = ""
	lbl.Parent = mainCapsule

	local txtGrad = Instance.new("UIGradient")
	txtGrad.Rotation = 90
	txtGrad.Color = Themes.Dark.TextGradient
	txtGrad.Parent = lbl

	table.insert(UI_Elements, lbl)
	return lbl
end

local executedLabel = createLabel("ExecutedLabel", UDim2.new(0, 15, 0, 0), Enum.TextXAlignment.Left)
local totalLabel = createLabel("TotalLabel", UDim2.new(0.5, 0, 0, 0), Enum.TextXAlignment.Right)

---------
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainCapsule

mainCapsule.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
	end
end)

mainCapsule.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local bounceTw = TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3})
		bounceTw:Play()
		bounceTw.Completed:Wait()
		TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
	end
end)

---------
local fileName = "meyy_capsule_time.json"
local firstLaunch = os.time()
local sessionStart = os.time()

if isfile(fileName) then
	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile(fileName))
	end)
	if success and data and data.FirstLaunch then
		firstLaunch = data.FirstLaunch
	end
else
	local data = { FirstLaunch = firstLaunch }
	pcall(function()
		writefile(fileName, HttpService:JSONEncode(data))
	end)
end

local function formatTime(seconds)
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

---------
RunService.RenderStepped:Connect(function()
	strokeGradient.Rotation = (tick() * 45) % 360
	
	local current = os.time()
	local sessionDiff = os.difftime(current, sessionStart)
	local totalDiff = os.difftime(current, firstLaunch)
	
	executedLabel.Text = "EXE: " .. formatTime(sessionDiff)
	totalLabel.Text = "TOT: " .. formatTime(totalDiff)
end)
