getgenv().AutoAimbot = true
getgenv().AimPos = nil
getgenv().SpamSkills = {"Z", "X", "C", "F"} -- Config các phím muốn auto xài nhaa
getgenv().AutoSpam = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local PREDICT_RATIO = 65 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}
local glowPart = nil

local DISTANCE = 10
local Y_MIN = -4
local Y_MAX = 7
local latestPredictedPos = nil

---------
local function GetNearestHumanoid()
    local dist = math.huge
    local targetPart = nil
    local char = LocalPlayer.Character

    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end

    local myPos = char.HumanoidRootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if mag < dist then
                dist = mag
                targetPart = p.Character.HumanoidRootPart
            end
        end
    end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, e in pairs(enemiesFolder:GetChildren()) do
            if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                local mag = (e.HumanoidRootPart.Position - myPos).Magnitude
                if mag < dist then
                    dist = mag
                    targetPart = e.HumanoidRootPart
                end
            end
        end
    end

    return targetPart
end

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
        if getgenv().AutoAimbot then
            getgenv().AimPos = CFrame.new(pPos) -- Gắn điểm silent aim vào chỗ dự đoán lun nhaa
        end
		createGlowEffect() 
		glowPart.Position = pPos
		glowPart.Transparency = 0.3 + math.sin(tick() * 5) * 0.2
	else 
		latestPredictedPos = nil
        if getgenv().AutoAimbot then
            getgenv().AimPos = nil
        end
		if glowPart then 
			glowPart:Destroy() 
			glowPart = nil 
		end 
	end
end)

---------
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
setreadonly(MT, false)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if Method == "FireServer" and getgenv().AutoAimbot and getgenv().AimPos then
        if self.Name == "RemoteEvent" then 
            if typeof(Args[1]) == "Vector3" then
                Args[1] = getgenv().AimPos.Position
                return OldNameCall(self, unpack(Args))
            elseif typeof(Args[1]) == "CFrame" then
                Args[1] = getgenv().AimPos
                return OldNameCall(self, unpack(Args))
            end
        end
    end
    
    return OldNameCall(self, ...)
end)

setreadonly(MT, true)

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
local function getWaterSafeY()
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
        if waterPlane then
            return waterPlane.Position.Y + (waterPlane.Size.Y / 2) + 2
        end
    end
    return 15 -- Điểm an toàn dự phòng nhó
end

---------
local function startTeleportLoop()
	local offsets = getOffsets()
	local currentIndex = 1
	
	while true do
        local offsetStartTime = tick()
        local directionOffset = offsets[currentIndex]
        local randomY = math.random(Y_MIN, Y_MAX)
		
        while tick() - offsetStartTime < 0.5 do
            local targetPlayer, dist = getClosestPlayer()
            local localCharacter = LocalPlayer.Character
            
            if targetPlayer and dist < 150 and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and latestPredictedPos then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = localCharacter.HumanoidRootPart
                
                if targetRoot then
                    local baseCFrame = CFrame.new(latestPredictedPos, latestPredictedPos + targetRoot.CFrame.LookVector)
                    local relativeOffset = Vector3.new(directionOffset.X * DISTANCE, randomY, directionOffset.Z * DISTANCE)
                    local targetCFrame = baseCFrame * CFrame.new(relativeOffset)
                    
                    local safeY = getWaterSafeY()
                    local finalY = math.max(targetCFrame.Position.Y, safeY) -- Ép trên mặt nước mừ
                    local finalPos = Vector3.new(targetCFrame.Position.X, finalY, targetCFrame.Position.Z)
                    
                    localRoot.CFrame = CFrame.new(finalPos, latestPredictedPos)
                end
            end
            RunService.Heartbeat:Wait() -- Bám siêu lẹ nhó
        end
        currentIndex = currentIndex % #offsets + 1
	end
end

---------
task.spawn(startTeleportLoop)

---------
task.spawn(function()
    while task.wait() do
        if getgenv().AutoSpam and getgenv().AutoAimbot and latestPredictedPos then
            local localChar = LocalPlayer.Character
            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                local dist = (localChar.HumanoidRootPart.Position - latestPredictedPos).Magnitude
                if dist < 150 then
                    for _, keyStr in ipairs(getgenv().SpamSkills) do
                        local success, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
                        if success then
                            for i = 1, 20 do
                                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                                task.wait(0.0001)
                                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                            end
                        end
                    end
                end
            end
        end
    end
end)
