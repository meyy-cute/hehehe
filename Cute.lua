local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local PREDICT_RATIO = 65 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}
local glowPart = nil

local DISTANCE = 10
local Y_MIN = -4
local Y_MAX = 7
local latestPredictedPos = nil

local activeOffset = nil
local activeRandomY = 0

---------
local function getClosestPlayer()
	local closest, shortest, char = nil, math.huge, LocalPlayer.Character
	local myPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
	if not myPart then return nil end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local tPart = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("Head")
			if tPart and (myPart.Position - tPart.Position).Magnitude < shortest then
				shortest, closest = (myPart.Position - tPart.Position).Magnitude, p
			end
		end
	end
	return closest, shortest
end

---------
local function createGlowEffect()
	if glowPart then return end
	glowPart = Instance.new("Part")
	glowPart.Name = "MeyyGlowPoint"
	glowPart.Shape = Enum.PartType.Ball
	glowPart.Size = Vector3.new(1.5, 1.5, 1.5)
	glowPart.Material = Enum.Material.Neon
	glowPart.Color = Color3.new(1, 1, 1)
	glowPart.CanCollide = false
	glowPart.Anchored = true
	glowPart.Transparency = 0.3
	glowPart.Parent = workspace
	
	local att = Instance.new("Attachment", glowPart)
	local emit = Instance.new("ParticleEmitter", att)
	emit.Rate = 50
	emit.Lifetime = NumberRange.new(0.3, 0.6)
	emit.Speed = NumberRange.new(1, 3)
	emit.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0)})
	emit.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
	emit.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))})
end

---------
local function getPredictedPosition(target)
	if not target or not target.Character then return nil end
	local tChar = target.Character
	local tPart = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("Head")
	local tHum = tChar:FindFirstChild("Humanoid")
	if not tPart then return nil end
	
	local curTime, curPos = tick(), tPart.Position
	if not enemyHistory[target.Name] then 
		enemyHistory[target.Name] = {lastPos = curPos, lastTime = curTime, speeds = {}} 
		return curPos 
	end
	
	local data = enemyHistory[target.Name]
	local dT = curTime - data.lastTime
	if dT > 0 then
		table.insert(data.speeds, (curPos - data.lastPos).Magnitude / dT)
		if #data.speeds > MAX_SAMPLES then table.remove(data.speeds, 1) end
		local sum = 0 
		for _, s in ipairs(data.speeds) do sum = sum + s end
		local avgSpd, moveActDir = sum / #data.speeds, (curPos - data.lastPos).Unit
		data.lastPos, data.lastTime = curPos, curTime
		if avgSpd > 0.5 then
			local fDir = (tHum and tHum.MoveDirection.Magnitude > 0) and (tHum.MoveDirection.Unit + tPart.CFrame.LookVector).Unit or moveActDir
			return tPart.Position + (fDir * (avgSpd * PREDICT_RATIO))
		end
	end
	return curPos
end

---------
RunService.RenderStepped:Connect(function()
	local target, dist = getClosestPlayer()
	local pPos = target and dist < 3000 and getPredictedPosition(target)
	
	if pPos then 
		latestPredictedPos = pPos
		createGlowEffect() 
		glowPart.Position = pPos
		glowPart.Transparency = 0.3 + math.sin(tick() * 5) * 0.2
		
		local localCharacter = LocalPlayer.Character
		if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and activeOffset then
			local targetRoot = target.Character.HumanoidRootPart
			local localRoot = localCharacter.HumanoidRootPart
			
			local baseCFrame = CFrame.new(latestPredictedPos, latestPredictedPos + targetRoot.CFrame.LookVector)
			local relativeOffset = Vector3.new(activeOffset.X * DISTANCE, activeRandomY, activeOffset.Z * DISTANCE)
			local targetCFrame = baseCFrame * CFrame.new(relativeOffset)
			local finalCFrame = CFrame.new(targetCFrame.Position, latestPredictedPos)
			
			local tweenInfo = TweenInfo.new(0.000005, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = TweenService:Create(localRoot, tweenInfo, {CFrame = finalCFrame})
			tween:Play()
		end
	else 
		latestPredictedPos = nil
		activeOffset = nil
		if glowPart then 
			glowPart:Destroy() 
			glowPart = nil 
		end 
	end
end)

---------
local function getOffsets()
	return {
		Vector3.new(0.707, 0, 0.707),
		Vector3.new(-0.707, 0, 0.707),
		Vector3.new(0.707, 0, -0.707),
		Vector3.new(-0.707, 0, -0.707),
		Vector3.new(0, 0, 1),
		Vector3.new(0, 0, -1),
		Vector3.new(-1, 0, 0),
		Vector3.new(1, 0, 0)
	}
end

---------
local function startTeleportLoop()
	local offsets = getOffsets()
	local currentIndex = 1
	
	while true do
		task.wait(0.5)
		
		local targetPlayer = getClosestPlayer()
		local localCharacter = LocalPlayer.Character
		
		if targetPlayer and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and latestPredictedPos then
			local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			local localRoot = localCharacter.HumanoidRootPart
			
			if targetRoot then
				activeOffset = offsets[currentIndex]
				activeRandomY = math.random(Y_MIN, Y_MAX)
				
				local baseCFrame = CFrame.new(latestPredictedPos, latestPredictedPos + targetRoot.CFrame.LookVector)
				local relativeOffset = Vector3.new(activeOffset.X * DISTANCE, activeRandomY, activeOffset.Z * DISTANCE)
				local targetCFrame = baseCFrame * CFrame.new(relativeOffset)
				
				localRoot.CFrame = CFrame.new(targetCFrame.Position, latestPredictedPos)
				
				currentIndex = currentIndex % #offsets + 1
			end
		end
	end
end

---------
task.spawn(startTeleportLoop)
---------
