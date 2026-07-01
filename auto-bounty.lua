Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name))
    end
end})
local Players = Services.Players
local player = Services.Players.LocalPlayer
local LocalPlayer = Services.Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local VirtualUser = Services.VirtualUser
local vim1 = Services.VirtualInputManager
local TweenService = Services.TweenService
local RunService = Services.RunService
local UserInputService = Services.UserInputService

local playerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

while not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
    Services.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", getgenv().Team )
    task.wait(1)
end
local placeId = game.PlaceId
local worldMap = {[2753915549] = "World1",[85211729168715] = "World1",[4442272183] = "World2",[79091703265657] = "World2",[7449423635] = "World3",[100117331123089] = "World3"}
sea = getgenv().Config["Select Sea"]
if sea == "Sea 1" then
   if placeId == 4442272183 or placeId == 79091703265657 or placeId == 7449423635 or placeId == 100117331123089 then
   Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
   end
elseif sea == "Sea 2" then
   if placeId == 2753915549 or placeId == 85211729168715 or placeId == 7449423635 or placeId == 100117331123089 then
   Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
   end
elseif sea == "Sea 3" then
    if placeId == 4442272183 or placeId == 79091703265657 or placeId == 2753915549 or placeId == 85211729168715 then
    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
    end
end
    
loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/m1-attack.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Tp.lua"))()
if not Util or not Util.FPSTracker then
    Util = { FPSTracker = { FPS = 60 } }
end
task.spawn(function()
    local lastTime = tick()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastTime >= 1 then
            if Util and Util.FPSTracker then
                Util.FPSTracker.FPS = math.clamp(frames / (now - lastTime), 1, 60)
            end
            frames = 0
            lastTime = now
        end
    end)
end)
if not setfpscap then setfpscap = function() 
    setfpscap(60)
end 
end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/no-gravity2.txt"))()




local character = LocalPlayer.Character or player.CharacterAdded:Wait()
local char = character


local controls = playerModule:GetControls()
local function disableControls()
    controls:Disable()
end

local function startWalking(char)
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")   
    disableControls()
    task.spawn(function()
        while char:IsDescendantOf(game) and humanoid.Health > 0 do
            local randomX = math.random(-20, 20)
            local randomZ = math.random(-20, 20)
            local targetPos = rootPart.Position + Vector3.new(randomX, 0, randomZ)           
            humanoid:MoveTo(targetPos)           
            humanoid.MoveToFinished:Wait()
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    char = newChar
    startWalking(newChar)
end)
if player.Character then
    startWalking(player.Character)
end
wait(.5)

local CONFIG = {
    FollowDelay = 0.0,
    SwitchDelay = 8,
    Offset = Vector3.new(3, 0, 0),
    SkimDelay = 0.0001
}

local isHopping = false 
local currentTarget = nil
local running = false
local followThread = nil
local switchTimer = 0
local rejoinEnabled = true
local kenEnabled = true
local lastDamageTime = tick()
local lastTargetHealth = 0

local Whitelist = {}
local Blacklist = {}
local ScanCompleted = false
local IsScanning = false

local NotificationSystem = {
    notifications = {},
    spacing = 90, 
    gui = nil
}

-------------------------------------------------------------------------
getgenv().AutoAimbot = true
getgenv().AimPos = nil


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
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid") and currentTarget.Character.Humanoid.Health > 0 then
        return currentTarget.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

---------
local function getTargetPlayer()
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("UpperTorso") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("Head"))
        if myRoot then
            local dist = (myRoot.Position - currentTarget.Character.HumanoidRootPart.Position).Magnitude
            return currentTarget, dist
        end
    end
    return nil, math.huge
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
    local target, dist = getTargetPlayer()
    local pPos = target and dist < 3000 and getPredictedPosition(target)
    
    if pPos then 
        latestPredictedPos = pPos
        if getgenv().AutoAimbot then
            getgenv().AimPos = CFrame.new(pPos) 
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
task.spawn(function()
    pcall(function()
        
        loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/auto-skill.lua"))()
        
    end)
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
local function getWaterSafeY()
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
        if waterPlane then
            return waterPlane.Position.Y + (waterPlane.Size.Y / 2) + 2
        end
    end
    return 15 
end

---------
---------
_G.IsSkyHopping = false

task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().AutoAimbot then continue end
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
            local hum = myChar.Humanoid
            local root = myChar.HumanoidRootPart

            if hum.Health > 0 and hum.MaxHealth > 0 then
                local hpPercent = hum.Health / hum.MaxHealth
                if hpPercent < 0.4 and not _G.IsSkyHopping then
                    _G.IsSkyHopping = true
                    pcall(function()
                        if _G.MainMoveTween and _G.MainMoveTween.PlaybackState == Enum.PlaybackState.Playing then
                            _G.MainMoveTween:Cancel()
                        end
                    end)

                    local safeX = root.Position.X
                    local safeZ = root.Position.Z
                    local startY = root.Position.Y
                    root.CFrame = CFrame.new(safeX, startY + 2000, safeZ)

                    task.wait(0.2)

                    local skyTween
                    while _G.IsSkyHopping do
                        task.wait(0.1)
                        if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 then
                            _G.IsSkyHopping = false
                            if skyTween then skyTween:Cancel() end
                            break
                        end

                        local currentHpPercent = myChar.Humanoid.Health / myChar.Humanoid.MaxHealth
                        if currentHpPercent >= 0.7 then
                            _G.IsSkyHopping = false
                            if skyTween then skyTween:Cancel() end

                            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                                local targetRoot = currentTarget.Character.HumanoidRootPart
                                root.CFrame = CFrame.new(root.Position.X, targetRoot.Position.Y, root.Position.Z)
                            end
                            break
                        end

                        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                            local targetRoot = currentTarget.Character.HumanoidRootPart
                            local targetDistX = targetRoot.Position.X
                            local targetDistZ = targetRoot.Position.Z
                            local targetDistY = targetRoot.Position.Y + 2000

                            local dist = (Vector3.new(targetDistX, targetDistY, targetDistZ) - root.Position).Magnitude
                            local timeToTween = dist / 350
                            
                            if timeToTween > 0 then
                                if skyTween then skyTween:Cancel() end
                                skyTween = Services.TweenService:Create(root, TweenInfo.new(timeToTween, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetDistX, targetDistY, targetDistZ)})
                                skyTween:Play()
                            end
                        end
                    end
                end
            end
        end
    end
end)



local function startTeleportLoop()
    local offsets = getOffsets()
    local currentIndex = 1

    _G.Meyy_LockTween = true

    while true do
        if not getgenv().AutoAimbot then
            _G.Meyy_LockTween = false
            break
        end

        if _G.IsSkyHopping then
            task.wait(0.1)
            continue
        end

        local offsetStartTime = tick()
        local directionOffset = offsets[currentIndex]
        local randomY = math.random(Y_MIN, Y_MAX)

        while tick() - offsetStartTime < 0.5 do
            if _G.IsSkyHopping then break end
            local targetPlayer, dist = getTargetPlayer()
            local localCharacter = LocalPlayer.Character

            if targetPlayer and dist < 60 and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = localCharacter.HumanoidRootPart

                if targetRoot then
                    ---------
                    pcall(function()
                        if _G.MainMoveTween and _G.MainMoveTween.PlaybackState == Enum.PlaybackState.Playing then
                            _G.MainMoveTween:Cancel()
                        end
                    end)

                local centerPos = latestPredictedPos or targetRoot.Position
                if getgenv().Config and getgenv().Config["SpinLock"] == "Body" then
                    centerPos = targetRoot.Position
                elseif getgenv().Config and getgenv().Config["SpinLock"] == "WhiteGlow" then
                    centerPos = latestPredictedPos or targetRoot.Position
                end
                
                local baseCFrame = CFrame.new(centerPos, centerPos + targetRoot.CFrame.LookVector)

                local currentDist = DISTANCE
                if math.abs(directionOffset.X) > 0 and math.abs(directionOffset.Z) > 0 then
                    currentDist = 7.5
                end

                local relativeOffset = Vector3.new(directionOffset.X * currentDist, randomY, directionOffset.Z * currentDist)
                local targetCFrame = baseCFrame * CFrame.new(relativeOffset)

                local safeY = getWaterSafeY()
                local finalY = math.max(targetCFrame.Position.Y, safeY)
                     ----------------------------------------
                    local lookPos = latestPredictedPos or targetRoot.Position
                    local finalPos = Vector3.new(targetCFrame.Position.X, finalY, targetCFrame.Position.Z)
                     --------------------------------------
                    local finalCFrame = CFrame.new(finalPos, lookPos)
                    ---------
                    localRoot.CFrame = finalCFrame
                end
            end
            RunService.Stepped:Wait()
        end

        currentIndex = currentIndex % #offsets + 1
    end
end
---------
task.spawn(startTeleportLoop)

local function CreateNotifyGui()
    local pGui = player:WaitForChild("PlayerGui")
    if pGui:FindFirstChild("MeyyCloudNotify") then return pGui:FindFirstChild("MeyyCloudNotify") end
    local sg = Instance.new("ScreenGui")
    sg.Name = "MeyyCloudNotify"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = Services.CoreGui or pGui
    return sg
end

NotificationSystem.gui = CreateNotifyGui()

function NotificationSystem:UpdatePositions()
    for i, notif in ipairs(self.notifications) do
        if notif and notif.Parent then
            local targetPos = UDim2.new(1, -20, 1, -20 - ((i - 1) * self.spacing))
            TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end
end

function NotificationSystem:Notify(title, message, duration)
    local m = Instance.new("Frame", self.gui)
    m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    m.BackgroundTransparency = 0.3
    m.Size = UDim2.new(0, 260, 0, 80) 
    m.Position = UDim2.new(1, 300, 1, -20) 
    m.AnchorPoint = Vector2.new(1, 1)
    Instance.new("UICorner", m).CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.5
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)
    
    local bgGrad = Instance.new("UIGradient", m)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
    })

    local function CreateLabel(txt, pos, sz)
        local l = Instance.new("TextLabel", m)
        l.Size = UDim2.new(1, -20, 0, 25)
        l.Position = UDim2.new(0.5, 0, 0, pos)
        l.AnchorPoint = Vector2.new(0.5, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = txt
        l.TextSize = sz
        l.TextColor3 = Color3.new(1, 1, 1)
        local ts = Instance.new("UIStroke", l)
        ts.Thickness = 1.2
        ts.Color = Color3.fromRGB(150, 200, 220)
        return l
    end

    CreateLabel(title, 12, 18)
    CreateLabel(message, 40, 12)

    local r = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        r = (r + 2) % 360
        e.Rotation = r
        local c1 = Color3.fromRGB(180, 220, 255)
        e.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, c1)})
    end)

    table.insert(self.notifications, m)
    self:UpdatePositions()

    task.delay(duration or 3, function()
        for i, notif in ipairs(self.notifications) do
            if notif == m then table.remove(self.notifications, i) break end
        end
        self:UpdatePositions()
        local hide = TweenService:Create(m, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, m.Position.Y.Scale, m.Position.Y.Offset)})
        hide:Play()
        hide.Completed:Connect(function()
            conn:Disconnect()
            m:Destroy()
        end)
    end)
end

_G.Notify = NotificationSystem
function notify(title, msg, time)
    _G.Notify:Notify(title, msg, time or 3)
end

local function getBounty(p)
    local ok, val = pcall(function()
        local ls = p:FindFirstChild("leaderstats")
        if ls then
            local b = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
            if b then return b.Value end
        end
        return 0
    end)
    return ok and val or 0
end

local function isInSafeZone(p)
    if not p.Character then return false end
    if p.Character:FindFirstChild("NoPvP") or p.Character:FindFirstChild("SafeZone") then return true end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local ok = pcall(function()
            for _, v in pairs(workspace["_WorldOrigin"]["SafeZones"]:GetChildren()) do
                if v:IsA("Part") and (v.Position - hrp.Position).Magnitude <= 400 then error("in") end
            end
        end)
        if not ok then return true end
    end
    return false
end

local function isPvPDisabled(p)
    return p:GetAttribute("PvpDisabled") == true
end

function CheckInCombat()
    return LocalPlayer:GetAttribute("PvpDisabled") == true
end



function risk() 
       local success, val = pcall(function()
        local mainGui = player.PlayerGui:FindFirstChild("Main")
        if mainGui then
            for _, v in ipairs(mainGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible then
                    local text = v.Text
                    if string.find(text, "risk") or string.find(text, "nguy hiem") then
                        return true
                    end
                end
            end
        end
        return false
    end)
    return success and val
end

local function getTargetCFrame(target)
    local success, result = pcall(function()
        if typeof(target) == "CFrame" then
            return target
        elseif typeof(target) == "Vector3" then
            return CFrame.new(target)
        elseif typeof(target) == "Instance" then
            if target:IsA("Player") then
                if target.Character then
                    local root = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
                    if root then
                        return root.CFrame
                    end
                end
            elseif target:IsA("Model") then
                local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                if root then
                    return root.CFrame
                else
                    return target:GetPivot()
                end
            elseif target:IsA("BasePart") then
                return target.CFrame
            end
        elseif type(target) == "table" and target.Character then
            local root = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
            if root then
                return root.CFrame
            end
        end
        return nil
    end)
    
    if success then
        return result
    end
    return nil
end
---------
function teleportTo(target)
    if _G.IsSkyHopping then return end
    local waited = 0
    while not getgenv().TP and waited < 5 do
        task.wait(0.1)
        waited = waited + 0.1
    end
    
    local targetCFrame = getTargetCFrame(target)
    if targetCFrame and getgenv().TP then
        getgenv().TP(targetCFrame)
    end
end
---------

local function hopServer()
    if isHopping then return end 
    isHopping = true 

    task.spawn(function()
        if not getgenv().Config["Reset"] then 
            notify("Hop System", "Moving to safety (10k height)...", 5) 

            task.spawn(function()
                while isHopping do
                    pcall(function()
                        local myHrp = character and character:FindFirstChild("HumanoidRootPart") 
                        if myHrp then
                            myHrp.CFrame = CFrame.new(myHrp.Position.X, 3000, myHrp.Position.Z) 
                            myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end)
                    task.wait()
                end
            end)
            local hasRisk = false
            pcall(function()
                local mainGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
                if mainGui then
                    for _, v in ipairs(mainGui:GetDescendants()) do
                        if v:IsA("TextLabel") and v.Visible then
                            if string.find(string.lower(v.Text), "risk") then
                                hasRisk = true
                                break
                            end
                        end
                    end
                end
            end)

            if hasRisk then
                notify("Hop System", "Risk detected! Waiting 30s...", 30)
                task.wait(25)
            end
        end

        notify("Hop System", "Searching servers...", 5) 
        
        pcall(function()
            LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = "Singapore" 
        end)
        
        while isHopping do
            task.wait()
            if not CheckInCombat() then
                for r = 1, 300 do 
                    local success, servers = pcall(function() 
                        return game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) 
                    end) 
                    
                    if success and servers then
                        for k, v in pairs(servers) do
                            if k ~= game.JobId and v["Count"] > 10 then 
                                local playerCount = v["Count"]
                                local serverBounty = v["Bounty"] or 0
                                if serverBounty > (playerCount * 1500000) then
                                    notify("Hop System", "Found server! Teleporting...", 3) 
                                    game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k) 
                                    task.wait()
                                end
                            end
                        end
                    end
                end
            end
        end
        isHopping = false 
    end)
end



---------------------------------------------------------
local function isValidTarget(p)
    if p == LocalPlayer then return false end
    if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    if Blacklist[p.Name] then return false end 

    
    local hum = p.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local localChar = LocalPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if localHrp then
        local distance = (localHrp.Position - hrp.Position).Magnitude
        if distance > 20500 then
            return false
        end
    end
    
    if isInSafeZone(p) then return false end
    if isPvPDisabled(p) then return false end
    
    
    
    local function getLv(plr)
        local d = plr:FindFirstChild("Data")
        local l = d and d:FindFirstChild("Level")
        return l and l.Value or 0
    end
    
    if math.abs(getLv(LocalPlayer) - getLv(p)) > 500 then 
        return false 
    end
    
    
    
    return true
end

---------------------------------------------------------

local function getRandomPlayer()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if isValidTarget(p) then
                table.insert(list, p)
        end
    end
    if #list == 0 then return nil end
    return list[math.random(1, #list)]
end

local function pickNewTarget(reason)
    local old = currentTarget and currentTarget.Name or "none"
    currentTarget = getRandomPlayer()
    switchTimer = 0
    
    lastTargetHealth = 0
    lastDamageTime = tick() 
    
    if currentTarget then
        print(string.format("Target [%s] %s -> %s", reason, old, currentTarget.Name))
    else
        print("Waiting for valid targets...")
            notify("Auto Bounty", "No targets left, hopping server...", 5)
		hopServer()
		
    end
end
local function checkCurrentTarget()
    if not currentTarget then return false end
    if not currentTarget.Parent then pickNewTarget("left game"); return false end
    local targetChar = currentTarget.Character
    if not targetChar then pickNewTarget("no character"); return false end
    local hum = targetChar:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then
        pickNewTarget("died"); return false
    end
    if isInSafeZone(currentTarget) then pickNewTarget("entered safezone"); return false end
    if isPvPDisabled(currentTarget) then pickNewTarget("pvp disabled"); return false end
    return true
end

local function RunFullScan()
    if ScanCompleted or IsScanning then return end
    IsScanning = true
    notify("Scan System", "Starting 5-cycle skimming scan...", 7)

    for cycle = 1, 7 do
        if not running then IsScanning = false return end
        notify("Scan System", "Cycle: " .. cycle .. "/7", 2)
        
        for _, p in pairs(Players:GetPlayers()) do
            if not running then break end
            local isMarine = LocalPlayer.Team and LocalPlayer.Team.Name == "Marines"
            local isSameTeam = p.Team == LocalPlayer.Team

            if p ~= LocalPlayer and not (isMarine and isSameTeam) then
                if Whitelist[p.Name] then
                    local hum = char and char:FindFirstChild("Humanoid")
                    if not char or not hum or hum.Health <= 0 then
                        Whitelist[p.Name] = nil
                    end
                    continue
                end

                if not Whitelist[p.Name] then
                    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                        if not isInSafeZone(p) and not isPvPDisabled(p) then
                        notify("Scan System", "Checking: " .. p.Name, 1.5)
                            local hum = char.Humanoid
                            local startHealth = hum.Health
                            
                            for i = 1, 60 do
                                if not running then break end
                                teleportTo(p)
                                task.wait(CONFIG.SkimDelay) 
                            end
                            
                            task.wait(0.01) 
                            local newHealth = hum.Health
                            if newHealth < startHealth then
                                Whitelist[p.Name] = true
                                notify("Scan System", "Whitelist added: " .. p.Name, 2)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end



    IsScanning = false
    ScanCompleted = true
    notify("Scan System", "Scan finished! Ready to hunt.", 7)
end

local function getPingInMs()
	if LocalPlayer then
		local ping = LocalPlayer:GetNetworkPing() 
		return math.round(ping * 10)
	end
	return 0
end 
--------------------------------------------------------------------------------

local function stopAll()
    running = false
    IsScanning = false
    if followThread then task.cancel(followThread); followThread = nil end
    currentTarget = nil
    switchTimer = 0
end

--------------------


---------------------------
---------
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if getgenv().Config and getgenv().Config["Bounty Find"] then
                local targetBounty = tonumber(getgenv().Config["Bounty Find"])
                if targetBounty and targetBounty > 0 then
                    local myBounty = getBounty(LocalPlayer)
                    if myBounty >= targetBounty then
                        if running or IsScanning then
                            task.wait(3)
                            stopAll()
                        end
                    end
                end
            end
        end)
    end
end)
---------

local function startRandom()
    stopAll() 
    running = true

    if getgenv().Config.mode == "method1" then
        pickNewTarget("start")
        local timeNear = 0
        followThread = task.spawn(function()
            while running do
                task.wait(0.1) 
                if not running then break end
                if not checkCurrentTarget() then task.wait(1); continue end
                
                teleportTo(currentTarget)
                
                local hum = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                local targetHrp = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if hum then
                    if hum.Health < lastTargetHealth then
                        timeNear = 0 
                    end
                    lastTargetHealth = hum.Health
                end

                if myHrp and targetHrp then
                    local dist = (myHrp.Position - targetHrp.Position).Magnitude
                    if dist < 100 then
                        timeNear = timeNear + 0.1
                    else
                        timeNear = 0
                    end
                end

                if timeNear >= 12 then
                    if currentTarget then
                        Blacklist[currentTarget.Name] = true
                    end
                    timeNear = 0
                    pickNewTarget("12s timeout near target")
                end
            end
        end)
    else
        followThread = task.spawn(function()
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                local placeId = game.PlaceId
                
                if placeId == 2753915133 then
                    local function hasValkyrieHelm()
                        local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
                        if inv then
                            for _, v in ipairs(inv) do
                                if v.Name == "Valkyrie Helm" then return true end
                            end
                        end
                        return false
                    end

                    if hasValkyrieHelm() then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
                    end

                elseif placeId == 4442272160 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923, 126, 32852))
                end
                
                task.wait(1.5)
            end

            if not ScanCompleted then RunFullScan() end 
            if not running then return end
            pickNewTarget("start")

            while running do
                task.wait(0.1) 
                if not running then break end
                if not checkCurrentTarget() then task.wait(1); continue end
                
                if Whitelist[currentTarget.Name] then
                    for i = 1, 5 do
                        if not running or not checkCurrentTarget() then break end
                        teleportTo(currentTarget) 
                        task.wait(CONFIG.SkimDelay) 
                    end
                else
                    teleportTo(currentTarget)
                end
               
                local hum = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                if hum then
                    if hum.Health < lastTargetHealth then
                        lastDamageTime = tick()
                    end
                    lastTargetHealth = hum.Health
                end

                switchTimer = switchTimer + 0.1 
                if switchTimer >= CONFIG.SwitchDelay then 
                    if currentTarget then
                        Whitelist[currentTarget.Name] = nil
                    end
                    pickNewTarget("8s timeout & blacklist") 
                end
            end
        end)
    end
end



local SKIP_NOTIF_KEYWORDS = {
    "pvp", "chua bat", "cannot attack", "unable to attack",
    "khong the tan cong", "nguoi choi", "player recently",
    "vua tu tran", "protection", "bao ve",
    "player", "safezone"
}

spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local notifs = LocalPlayer.PlayerGui:FindFirstChild("Notifications")
            if notifs then
                for _, v in pairs(notifs:GetChildren()) do
                    local lbl = v:IsA("TextLabel") and v or v:FindFirstChildWhichIsA("TextLabel", true)
                    if lbl and lbl.Text and lbl.Text ~= "" then
                        local text = lbl.Text:lower()
                        for _, kw in pairs(SKIP_NOTIF_KEYWORDS) do
                            if text:find(kw, 1, true) then
                                if currentTarget then 
                                    Blacklist[currentTarget.Name] = true
                                end
                                pickNewTarget("notification bypass")
                                pcall(function() v:Destroy() end)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

---------
task.spawn(function()
    local lastX = nil
    local lastZ = nil
    local timeStuck = 0
    
    while task.wait(1) do
        pcall(function()
            if running and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local currentX = LocalPlayer.Character.HumanoidRootPart.Position.X
                local currentZ = LocalPlayer.Character.HumanoidRootPart.Position.Z
                
                if lastX and lastZ then
                    if math.abs(currentX - lastX) < 1 and math.abs(currentZ - lastZ) < 1 then
                        timeStuck = timeStuck + 1
                    else
                        lastX = currentX
                        lastZ = currentZ
                        timeStuck = 0
                    end
                    
                    if timeStuck >= 120 then
                        stopAll()
                        timeStuck = 0
                    end
                else
                    lastX = currentX
                    lastZ = currentZ
                    timeStuck = 0
                end
            else
                lastX = nil
                lastZ = nil
                timeStuck = 0
            end
        end)
    end
end)
---------

------------------------------------------------------------------------
------------------------------------------------------------------------

local fileName = "hitbox.meyy"
local baseHitboxSize = 0

-------------------------------------------------------------------------
local function getHitboxSize()
    local success, result = pcall(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            return character.HumanoidRootPart.Size.Magnitude
        end
        return 0
    end)
    return success and result or 0
end

local function saveHitbox(size)
    pcall(function()
        writefile(fileName, tostring(size))
    end)
end

local function readHitbox()
    local success, result = pcall(function()
        if isfile(fileName) then
            return tonumber(readfile(fileName))
        end
    end)
    return success and result or nil
end

-------------------------------------------------------------------------
task.spawn(function()
    pcall(function()
        local savedSize = readHitbox()
        if not savedSize then
            baseHitboxSize = getHitboxSize()
            saveHitbox(baseHitboxSize)
        else
            baseHitboxSize = savedSize
        end
    end)
end)

-------------------------------------------------------------------------
task.spawn(function()
    while true do
        local success, err = pcall(function()
            -- Kiểm tra config nè ann oii (〃´∀｀)
            if getgenv().Config and getgenv().Config["transform"] == true then
                local currentSize = getHitboxSize()
                
                if currentSize > 0 and math.abs(currentSize - baseHitboxSize) < 0.1 then
                    local vim = Services.VirtualInputManager
                    vim:SendKeyEvent(true, Enum.KeyCode.V, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.V, false, game)
                end
            end
        end)
        
        if not success then
            warn("Á~ Lỗi vòng lặp rùi mò: " .. tostring(err))
        end
        
        task.wait(2)
    end
end)
-------------------------------------------------------------------------


-------------------------------------------------------------------------

local function ForceEnablePvP()
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
        if mainGui then
            local pvpBtn = mainGui:FindFirstChild("PvpDisabled") or mainGui:FindFirstChild("SafeZone")
            if pvpBtn and pvpBtn.Visible then
                for _, connection in pairs(getconnections(pvpBtn.MouseButton1Click)) do
                    connection:Fire()
                end
            end
        end
    end)
end
pcall(function()
    local _WaterBasePlane = workspace.Map and workspace.Map['WaterBase-Plane']
    if _WaterBasePlane then
        _WaterBasePlane.Size = Vector3.new(1000, 112, 1000)
    end
end)
task.spawn(function()
    while task.wait(2) do 
        ForceEnablePvP()
    end
end)

spawn(function()
    while task.wait(2) do
        if not kenEnabled then continue end
        pcall(function()
            if char and not char:FindFirstChild("HasObservation") then
                VirtualUser:CaptureController()
                VirtualUser:SetKeyDown("0x65")
                task.wait(0.05)
                VirtualUser:SetKeyUp("0x65")
            end
        end)
    end
end)
if getgenv().MainUI then
    pcall(function() getgenv().MainUI:Destroy() end)
    getgenv().MainUI = nil
end

if getgenv().Config.BlackScreen then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScreenGui"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Services.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.Position = UDim2.new(-0.206146, 0, -0.150063, 0)
    Frame.Size = UDim2.new(0, 2544, 0, 1355)
    Frame.BackgroundColor3 = Color3.new(0.0235294, 0.0235294, 0.0235294)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Position = UDim2.new(0.462572, 0, 0.343508, 0)
    TextLabel.Size = UDim2.new(0, 200, 0, 50)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Time Elapsed : ..."
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 28
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel.Parent = ScreenGui
    getgenv()._BS_TimeLabel = TextLabel

    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Position = UDim2.new(0.462572, 0, 0.266818, 0)
    TextLabel2.Size = UDim2.new(0, 200, 0, 50)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "Bounty Earned : ...."
    TextLabel2.TextColor3 = Color3.new(1, 1, 1)
    TextLabel2.TextSize = 28
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel2.Parent = ScreenGui
    getgenv()._BS_BountyLabel = TextLabel2

    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Position = UDim2.new(0.462572, 0, 0.204578, 0)
    TextLabel3.Size = UDim2.new(0, 200, 0, 50)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "Target : "
    TextLabel3.TextColor3 = Color3.new(1, 1, 1)
    TextLabel3.TextSize = 25
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel3.Parent = ScreenGui
    getgenv()._BS_TargetLabel = TextLabel3

    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Position = UDim2.new(0.350045, 0, 0.0638366, 0)
    TextLabel4.Size = UDim2.new(0, 571, 0, 102)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "Meyy Hub - Auto Bounty M1 Fruit"
    TextLabel4.TextColor3 = Color3.new(1, 1, 1)
    TextLabel4.TextSize = 35
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel4.Parent = ScreenGui

    local Line = Instance.new("Frame")
    Line.Position = UDim2.new(0.361577, 0, 0.191517, 0)
    Line.Size = UDim2.new(0, 533, 0, 1)
    Line.BackgroundColor3 = Color3.new(0.686275, 0.0980392, 0.658824)
    Line.BorderSizePixel = 0
    Line.Parent = ScreenGui
else
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "meyyy_hub_bounty_final_" .. math.random(100, 999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Services.CoreGui
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    getgenv().MainUI = ScreenGui

    local isMini = false
    local m = Instance.new("Frame", ScreenGui)
    m.Name = "MainFrame"
    m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    m.BackgroundTransparency = 0.2
    m.Size = UDim2.new(0, 500, 0, 350)
    m.Position = UDim2.new(0.5, 0, 0.5, 0)
    m.AnchorPoint = Vector2.new(0.5, 0.5)
    m.ClipsDescendants = true
    Instance.new("UICorner", m).CornerRadius = UDim.new(0, 15)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 3.5
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)
    local RotateGradients = {e}

    local bgGradient = Instance.new("UIGradient", m)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 250, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 245, 255))
    })

    local dragging, dragInput, dragStart, startPos
    m.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = m.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local SnowContainer = Instance.new("Frame", m)
    SnowContainer.Size = UDim2.new(1, -20, 1, -20)
    SnowContainer.Position = UDim2.new(0, 10, 0, 10)
    SnowContainer.BackgroundTransparency = 1
    SnowContainer.ZIndex = 0
    SnowContainer.ClipsDescendants = true 

    task.spawn(function()
        while task.wait(0.25) do 
            if not m.Visible or isMini then continue end
            local flake = Instance.new("ImageLabel", SnowContainer)
            flake.BackgroundTransparency = 1
            flake.Image = "rbxthumb://type=Asset&id=137906289429512&w=150&h=150"
            local randomSize = math.random(8, 15)
            flake.Size = UDim2.new(0, randomSize, 0, randomSize)
            flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
            flake.ImageTransparency = math.random(4, 8) / 10 
            local tween = TweenService:Create(flake, TweenInfo.new(math.random(3, 5), Enum.EasingStyle.Linear), {
                Position = UDim2.new(flake.Position.X.Scale, 0, 1.1, 0),
                Rotation = math.random(-180, 180)
            })
            tween:Play()
            tween.Completed:Connect(function() flake:Destroy() end)
        end
    end)

    local function CreateLabel(name, parent, pos, size, text, textSize, align)
        local l = Instance.new("TextLabel", parent)
        l.Name = name
        l.Size = size
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = text
        l.TextSize = textSize
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextXAlignment = align or Enum.TextXAlignment.Center
        local ts = Instance.new("UIStroke", l)
        ts.Thickness = 1.8
        ts.Color = Color3.fromRGB(130, 190, 230)
        local tg = Instance.new("UIGradient", l)
        table.insert(RotateGradients, tg)
        return l
    end

    local function CreateMeyyButton(parent, size, pos, anchor, buttonText)
        local btn = Instance.new("TextButton", parent)
        btn.Size = size
        btn.Position = pos
        btn.AnchorPoint = anchor
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.6 
        btn.AutoButtonColor = false
        btn.Text = "" 
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Thickness = 2.5 
        btnStroke.Color = Color3.new(1, 1, 1)
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

        local btnGrad = Instance.new("UIGradient", btnStroke)
        btnGrad.Color = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 230, 255)), 
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 230, 255))
        })

        table.insert(RotateGradients, btnGrad)
        
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = buttonText 
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 14 
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 1
        txtStroke.Color = Color3.fromRGB(100, 170, 220)
        
        local originalSize = size
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 4)}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = originalSize}):Play()
        end)
        return btn, label
    end

    CreateLabel("Title", m, UDim2.new(0, 0, 0, 10), UDim2.new(1, 0, 0, 30), "Meyy Hub - Auto Bounty", 22)

    local TargetLabel = CreateLabel("TargetLabel", m, UDim2.new(0, 25, 0, 125), UDim2.new(1, -50, 0, 30), "Target: --", 18, Enum.TextXAlignment.Left)
    local StatusLabel = CreateLabel("StatusLabel", m, UDim2.new(0, 25, 0, 75), UDim2.new(1, -50, 0, 30), "Status: --", 18, Enum.TextXAlignment.Left)
    local TargetLabel = CreateLabel("TargetLabel", m, UDim2.new(0, 25, 0, 125), UDim2.new(1, -50, 0, 30), "Target: --", 18, Enum.TextXAlignment.Left)
    local StatusLabel = CreateLabel("StatusLabel", m, UDim2.new(0, 25, 0, 75), UDim2.new(1, -50, 0, 30), "Status: --", 18, Enum.TextXAlignment.Left)
---------
    local DistanceLabel = CreateLabel("DistanceLabel", m, UDim2.new(0, -45, 0, 125), UDim2.new(1, 0, 0, 30), "Distance: --", 18, Enum.TextXAlignment.Right)
    local HpLabel = CreateLabel("HpLabel", m, UDim2.new(0, -45, 0, 75), UDim2.new(1, 0, 0, 30), "HP Target: --", 18, Enum.TextXAlignment.Right)
---------
    local ActionFrame = Instance.new("Frame", m)
    ActionFrame.Size = UDim2.new(1, -40, 0, 130)
    ActionFrame.Position = UDim2.new(0, 20, 1, -145) 
    ActionFrame.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", ActionFrame)
    UIList.Padding = UDim.new(0, 10)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function CreateRow()
        local r = Instance.new("Frame", ActionFrame)
        r.Size = UDim2.new(1, 0, 0, 35)
        r.BackgroundTransparency = 1
        return r
    end

    local Row1 = CreateRow()
    local ToggleBtn, ToggleLbl = CreateMeyyButton(Row1, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0,0), "Stop")
    local SkipBtn, SkipLbl = CreateMeyyButton(Row1, UDim2.new(0.48, 0, 1, 0), UDim2.new(1, 0, 0, 0), Vector2.new(1,0), "Skip Player")

    local Row2 = CreateRow()
    local HopBtn, HopLbl = CreateMeyyButton(Row2, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0,0), "Hop Server")
    local RejoinBtn, RejoinLbl = CreateMeyyButton(Row2, UDim2.new(0.48, 0, 1, 0), UDim2.new(1, 0, 0, 0), Vector2.new(1,0), "Auto Rejoin: ON")

    local Row3 = CreateRow()
    local KenBtn, KenLbl = CreateMeyyButton(Row3, UDim2.new(0.48, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), Vector2.new(0.5,0), "Ken: ON")

SkipBtn.MouseButton1Click:Connect(function()
    if currentTarget then
        Blacklist[currentTarget.Name] = true
        notify("Meyy Hub", "Skipped & Blacklisted: " .. currentTarget.Name, 2)
    end
    pickNewTarget("manual skip")
end)

    ToggleBtn.MouseButton1Click:Connect(function()
        if running then
            stopAll()
            ToggleLbl.Text = "Start"
            notify("Auto Bounty", "Script stopped, hopping server...", 3)
            hopServer()
        else
            startRandom()
            ToggleLbl.Text = "Stop"
        end
    end)

    HopBtn.MouseButton1Click:Connect(function() hopServer() end)

    RejoinBtn.MouseButton1Click:Connect(function()
        rejoinEnabled = not rejoinEnabled
        if rejoinEnabled then RejoinLbl.Text = "Auto Rejoin: ON" else RejoinLbl.Text = "Auto Rejoin: OFF" end
    end)
    
LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if not parent and rejoinEnabled then
        Services.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" then
                task.wait(1)
                pcall(function()
                    Services.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", game.JobId)
                end)
            end
        end)
    end
end)

    KenBtn.MouseButton1Click:Connect(function()
        kenEnabled = not kenEnabled
        if kenEnabled then KenLbl.Text = "Ken: ON" else KenLbl.Text = "Ken: OFF" end
    end)

        task.spawn(function()
        while task.wait() do
            pcall(function()
---------
                local distStr = "--"
                local hpStr = "--"
                
                if currentTarget and currentTarget.Character then
                    local targetHrp = currentTarget.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = currentTarget.Character:FindFirstChild("Humanoid")
                    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if targetHrp and myHrp then
                        distStr = tostring(math.floor((myHrp.Position - targetHrp.Position).Magnitude)) .. "m"
                    end
                    if targetHum and targetHum.MaxHealth > 0 then
                        hpStr = tostring(math.floor((targetHum.Health / targetHum.MaxHealth) * 100)) .. "%"
                    end
                end
                
                DistanceLabel.Text = "Dist: " .. distStr
                HpLabel.Text = "HP: " .. hpStr
---------
                if IsScanning then
                    TargetLabel.Text = "Target: --"
                    StatusLabel.Text = "Status: Scanning Server..."
                elseif currentTarget then
                    TargetLabel.Text = "Target: " .. currentTarget.Name
                    if not isValidTarget(currentTarget) then
                        if isInSafeZone(currentTarget) then StatusLabel.Text = "Status: SafeZone"
                        elseif isPvPDisabled(currentTarget) then StatusLabel.Text = "Status: No PvP"
                        else StatusLabel.Text = "Status: Switching..." end
                    else
                        StatusLabel.Text = "Status: Following"
                    end
                else
                    TargetLabel.Text = "Target: waiting scan"
                    if running then
                        StatusLabel.Text = "Status: Searching..."
                    else
                        StatusLabel.Text = "Status: Stopped"
                        if not currentTarget and not IsScanning then hopServer() end
                    end
                end
            end)
        end
    end)

    local ToggleIcon = Instance.new("ImageButton", ScreenGui)
    ToggleIcon.Name = "ToggleIcon"
    ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
    ToggleIcon.Position = UDim2.new(0, 20, 1, -65)
    ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIcon.BackgroundTransparency = 0.4
    ToggleIcon.Image = "rbxassetid://6031090990" 
    Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)
    local tst = Instance.new("UIStroke", ToggleIcon)
    tst.Thickness = 2
    tst.Color = Color3.new(1,1,1)

    ToggleIcon.MouseButton1Click:Connect(function()
        if not isMini then
            isMini = true
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        else
            isMini = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()
        end
    end)

    RunService.RenderStepped:Connect(function()
        local r = (tick() * 60) % 360
        local colorSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 230, 255)), 
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 230, 255))
        })
        for _, grad in ipairs(RotateGradients) do 
            grad.Rotation = r 
            grad.Color = colorSeq 
        end
        bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.1, 0)
    end)

    m.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(m, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()
end

LocalPlayer.Chatted:Connect(function(msg)
    local mText = msg:lower()
    if mText == "/randtp" then startRandom() 
    elseif mText == "/stoptp" then stopAll() hopServer()
    elseif mText == "/newtp" then pickNewTarget("manual") end
end)
function stopRandomTp() stopAll() hopServer() end
function newTarget() pickNewTarget("manual") end

startRandom()



spawn(function()
    while task.wait(0.2) do
            pcall(function()
                if char and char:FindFirstChild("RaceEnergy") and char.RaceEnergy.Value >= 1 then
                    vim1:SendKeyEvent(true, "Y", false, game)
                    vim1:SendKeyEvent(false, "Y", false, game)
                end
            end)
    end
end)

spawn(function()
    while task.wait(1) do
        pcall(function()
            if char and not char:FindFirstChild("HasBuso") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end
end)

				
   ---------
function sendKillWebhook(targetName, bountyEarned, currentBounty, totalEarned)
    if not getgenv().Config.Webhook.Enabled or getgenv().Config.Webhook.Url == "" then
        return
    end    
    local url = getgenv().Config.Webhook.Url
    local function formatBounty(bounty)
        if bounty >= 1000000 then
            return string.format("%.1fM", bounty / 1000000)
        elseif bounty >= 1000 then
            return string.format("%.1fK", bounty / 1000)
        else
            return tostring(bounty)
        end
    end
    local data = {
        ["username"] = "ʚ ᙏᥱყყ♡Bot ɞ ", 
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120553734766713/cte_2.jfif?ex=6a09783f&is=6a0826bf&hm=8d8bf1376c3a05cbf82f7f36dc174b1c4d026c73fd391c5daea947010c6b4d41&",
        ["embeds"] = {{
            ["title"] = " <a:a_afx_heart_pink:1213626268205973504> αυтσ вσυηту <a:a_afx_heart_pink:1213626268205973504> ",
            ["description"] = "Kill Player",
            ["color"] = 11986679,
            ["fields"] = {
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Target",
                    ["value"] = "```" .. targetName .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Bounty Earned",
                    ["value"] = "```" .. formatBounty(bountyEarned) .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Total Earned",
                    ["value"] = "```" .. formatBounty(totalEarned) .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Current Bounty",
                    ["value"] = "```" .. formatBounty(currentBounty) .. "```", 
                    ["inline"] = true
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Hunter",
                    ["value"] = "```" .. player.Name .. "```",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "ʚ ᙏᥱყყ♡Hub ɞ | " .. os.date("%H:%M:%S %d/%m/%Y"),
                ["icon_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120554104127528/cute.jfif?ex=6a09783f&is=6a0826bf&hm=5cf5e8f83ba3c797a5901813eb66d4df716f617473ce7c089d6f66912f205dc5&"
            },
            ["thumbnail"] = {
                ["url"] = "https://cdn.discordapp.com/attachments/1503282260856672367/1504877443993833714/1778860380021.png?ex=6a0895d5&is=6a074455&hm=86c9de11e9c2f8b291bda710bb406d11144c7af5fe5fd26edb34ea84b7c8aeef&"
            },
				["image"] = {
              ["url"] = "https://cdn.discordapp.com/attachments/1325479541195673610/1504873598450663595/1778860201529.png?ex=6a089241&is=6a0740c1&hm=5b09db29f8c9e48e88f5026c45977d2a41c9343746dae3bae37bbdbf4f7cfc3e&"
				}
			}}}
    pcall(function()
        local jsonData = Services.HttpService:JSONEncode(data)
        local success, response = pcall(function()
            if syn then
                return syn.request({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = jsonData
                })
            else
                return request({
                    Url = url,
                    Method = "POST", 
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = jsonData
                })
            end
        end)
        
        if success then
            print(" Sent kill webhook: " .. targetName)
        else
            print(" Webhook error: " .. tostring(response))
        end
    end)
end
---------

---------
local SAVE_FOLDER = "MeyyHub_DataBounty"
local SAVE_FILE = SAVE_FOLDER .. "/TotalBounty_" .. game.Players.LocalPlayer.Name .. ".json"
if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end

local totalBountyEarned = 0
local allTimeKills = 0
local sessionBountyEarned = 0
local totalTimeElapsed = 0
local bsStartTime = os.time()
local lastSaveTime = os.time()

local function loadEarnedData()
    local success, err = pcall(function()
        if isfile(SAVE_FILE) then
            local fileContent = readfile(SAVE_FILE)
            if fileContent and fileContent ~= "" then
                local data = Services.HttpService:JSONDecode(fileContent)
                totalBountyEarned = tonumber(data.TotalEarned) or 0
                allTimeKills = tonumber(data.AllTimeKills) or 0
                totalTimeElapsed = tonumber(data.TotalTimeElapsed) or 0
                
                sessionBountyEarned = 0 
            end
        else
            local defaultData = {
                TotalEarned = 0,
                AllTimeKills = 0,
                TotalTimeElapsed = 0,
                SessionEarned = 0,
                LastSaveTimestamp = os.time(),
                LastSave = os.date("%H:%M %d/%m/%Y"),
                Player = game.Players.LocalPlayer.Name
            }
            writefile(SAVE_FILE, Services.HttpService:JSONEncode(defaultData))
        end
    end)
    
    if not success then
        totalBountyEarned = 0
        allTimeKills = 0
        sessionBountyEarned = 0
        totalTimeElapsed = 0
    end
end

loadEarnedData()

local function saveEarnedData()
    pcall(function()
        local currentTimeInServer = math.floor(os.time() - bsStartTime)
        lastSaveTime = os.time()
        
        local dataToSave = {
            TotalEarned = totalBountyEarned,
            AllTimeKills = allTimeKills,
            TotalTimeElapsed = totalTimeElapsed + currentTimeInServer,
            SessionEarned = sessionBountyEarned,
            LastSaveTimestamp = lastSaveTime,
            LastSave = os.date("%H:%M %d/%m/%Y"),
            Player = game.Players.LocalPlayer.Name
        }
        
        writefile(SAVE_FILE, Services.HttpService:JSONEncode(dataToSave))
    end)
end
---------



local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%dh %dm %02ds", h, m, s)
end

spawn(function()
    task.wait(2)
    while task.wait(1) do
        pcall(function()
            saveEarnedData()
            
            if not getgenv().Config.BlackScreen then return end
            local tLbl = getgenv()._BS_TimeLabel
            local bLbl = getgenv()._BS_BountyLabel
            local tgLbl = getgenv()._BS_TargetLabel
            if not tLbl or not bLbl or not tgLbl then return end

            tLbl.Text = "Time Elapsed : " .. formatTime(totalTimeElapsed + math.floor(os.time() - bsStartTime))
            bLbl.Text = "Bounty Earned : +" .. tostring(sessionBountyEarned) .. "$ | Total: " .. tostring(totalBountyEarned) .. "$"

            if IsScanning then
                tgLbl.Text = "Target : Scanning..."
            elseif currentTarget then
                tgLbl.Text = "Target : " .. currentTarget.Name .. " (" .. tostring(getBounty(currentTarget)) .. "$)"
            else
                tgLbl.Text = "Target : Searching..."
            end
        end)
    end
end)

---------

---------
local lastTickBounty = 0

spawn(function()
    task.wait(1) 
    pcall(function()
        lastTickBounty = tonumber(getBounty(game.Players.LocalPlayer)) or 0
    end)
    
    while task.wait(0.1) do
        pcall(function()
            local currentBounty = tonumber(getBounty(game.Players.LocalPlayer)) or 0
            
            if lastTickBounty > 0 and currentBounty > lastTickBounty then
                local earnedBounty = currentBounty - lastTickBounty
                
                local deadTargetName = "Unknown Hunter"
                local myChar = game.Players.LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                
                if myHrp then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= game.Players.LocalPlayer and p.Character then
                            local pHrp = p.Character:FindFirstChild("HumanoidRootPart")
                            local pHum = p.Character:FindFirstChild("Humanoid")
                            
                            if pHrp and pHum then
                                local dist = (myHrp.Position - pHrp.Position).Magnitude
                                local hpPercent = pHum.Health / pHum.MaxHealth
                                
                                if dist <= 700 and (hpPercent <= 0.01 or pHum.Health <= 0) then
                                    deadTargetName = p.Name
                                    break
                                end
                            end
                        end
                    end
                end
                
                sessionBountyEarned = (tonumber(sessionBountyEarned) or 0) + earnedBounty
                totalBountyEarned = (tonumber(totalBountyEarned) or 0) + earnedBounty
                allTimeKills = (tonumber(allTimeKills) or 0) + 1
                
                sendKillWebhook(deadTargetName, earnedBounty, currentBounty, totalBountyEarned)
                saveEarnedData()
            end
            
            if currentBounty > 0 then
                lastTickBounty = currentBounty
            end
        end)
    end
end)
---------



local function IsPvpOn(player)
    return player:GetAttribute("PvpDisabled") ~= true
end


local CoreGui = Services.CoreGui

local existingUI = CoreGui:FindFirstChild("MeyyBountyMiniUI")
if existingUI then
    existingUI:Destroy()
end

local g = Instance.new("ScreenGui")
g.Name = "MeyyBountyMiniUI"
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() g.Parent = CoreGui end)
if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local m = Instance.new("Frame", g)
m.Name = "Main"
m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
m.BackgroundTransparency = 0.3
m.Position = UDim2.new(1, -255, 0, 45)
m.AnchorPoint = Vector2.new(0.15, 0)
m.Size = UDim2.new(0, 240, 0, 240)
m.ClipsDescendants = false 

local mainCorner = Instance.new("UICorner", m)
mainCorner.CornerRadius = UDim.new(0, 10)

local u = Instance.new("UIStroke", m)
u.Thickness = 2.5
u.Color = Color3.new(1, 1, 1)
local e = Instance.new("UIGradient", u)

local bgGradient = Instance.new("UIGradient", m)
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
})

local statusGradients = {}

local function CreateStatusLabel(name, pos, text)
    local label = Instance.new("TextLabel", m)
    label.Name = name
    label.Size = UDim2.new(1, -30, 0, 35) 
    label.Position = UDim2.new(0.5, 0, 0, pos)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextWrapped = true 
    label.RichText = true
    
    local txtStroke = Instance.new("UIStroke", label)
    txtStroke.Thickness = 0.5
    txtStroke.Color = Color3.fromRGB(150, 200, 220)
    
    local txtGradient = Instance.new("UIGradient", label)
    table.insert(statusGradients, txtGradient)
    return label, txtGradient
end

local TopInfoLabel, TopInfoGradient = CreateStatusLabel("TopInfo", 15, "Meyy Hub - Bounty Tracker")

local divider = Instance.new("Frame", m)
divider.Name = "Divider"
divider.Size = UDim2.new(0, 180, 0, 2)
divider.Position = UDim2.new(0.5, 0, 0, 60)
divider.AnchorPoint = Vector2.new(0.5, 0)
divider.BorderSizePixel = 0
divider.BackgroundColor3 = Color3.fromRGB(173, 216, 230) 
divider.ClipsDescendants = true 

local divGrad = Instance.new("UIGradient", divider)
divGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.1, 0),
    NumberSequenceKeypoint.new(0.9, 0),
    NumberSequenceKeypoint.new(1, 1)
})

local divCorner = Instance.new("UICorner", divider)
divCorner.CornerRadius = UDim.new(1, 0)

local shine = Instance.new("Frame", divider)
shine.Name = "Shine"
shine.Size = UDim2.new(0, 50, 1, 0)
shine.Position = UDim2.new(-0.5, 0, 0, 0)
shine.BorderSizePixel = 0
shine.BackgroundColor3 = Color3.new(1, 1, 1)

local shineGrad = Instance.new("UIGradient", shine)
shineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
})

local CurrentBountyLabel, _ = CreateStatusLabel("CurrentBounty", 75, "Current Bounty: Loading...")
local BountyEarnedLabel, _ = CreateStatusLabel("BountyEarned", 115, "Bounty Earned: +0$")
local TotalBountyLabel, _ = CreateStatusLabel("TotalBounty", 155, "Total Bounty: +0$")
local TimeLabel, _ = CreateStatusLabel("TimeElapsed", 195, "Time Elapsed: 00:00:00")

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    TweenService:Create(m, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
end

m.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = m.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

m.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local toggleBtn = Instance.new("TextButton", m)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 25, 0, 25) 
toggleBtn.Position = UDim2.new(1, 10, 0, -30) 
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = ""

local btnCorner = Instance.new("UICorner", toggleBtn)
btnCorner.CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Thickness = 2.5
btnStroke.Color = Color3.new(1, 1, 1)

local btnBgGradient = Instance.new("UIGradient", toggleBtn)
table.insert(statusGradients, btnBgGradient)

local btnStrokeGradient = Instance.new("UIGradient", btnStroke)
table.insert(statusGradients, btnStrokeGradient) 

local isOpen = true
local normalBtnSize = UDim2.new(0, 25, 0, 25) 
local hoverBtnSize = UDim2.new(0, 33, 0, 33) 

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {Size = hoverBtnSize}):Play() 
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {Size = normalBtnSize}):Play() 
end)

toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 240, 0, 260) 
        }):Play()
        for _, child in ipairs(m:GetChildren()) do
            if child ~= toggleBtn and child:IsA("GuiObject") then
                child.Visible = true 
            end
        end
    else
        TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0) 
        }):Play()
        for _, child in ipairs(m:GetChildren()) do
            if child ~= toggleBtn and child:IsA("GuiObject") then
                child.Visible = false 
            end
        end
    end
end)

local r = 0
RunService.RenderStepped:Connect(function()
    local speed = 2
    local t = (tick() * speed) % 2.5 
    shine.Position = UDim2.new(-0.5 + t, 0, 0, 0)

    r = (r + 1.5) % 360
    e.Rotation = r
    
    local c1, c2 = Color3.fromRGB(180, 220, 255), Color3.new(1, 1, 1)
    local colorSeq = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1), 
        ColorSequenceKeypoint.new(0.5, c2), 
        ColorSequenceKeypoint.new(1, c1)
    })
    e.Color = colorSeq
    
    for _, grad in ipairs(statusGradients) do
        grad.Rotation = r
        grad.Color = colorSeq
    end
    
    bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local currentSessionTime = math.floor(os.time() - bsStartTime)
            local totalElapsed = totalTimeElapsed + currentSessionTime
            TimeLabel.Text = "Time Elapsed: " .. formatTime(totalElapsed)
            
            local currentBounty = 0
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            if ls then
                local bh = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
                if bh then
                    currentBounty = bh.Value
                end
            end
            
            if currentBounty > 0 then
                local formattedCurrent = tostring(currentBounty):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                CurrentBountyLabel.Text = "Current Bounty: " .. formattedCurrent .. "$"
            end
            
            local formattedSession = tostring(sessionBountyEarned):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
            BountyEarnedLabel.Text = "Bounty Earned: +" .. formattedSession .. "$"

            local formattedTotal = tostring(totalBountyEarned):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
            TotalBountyLabel.Text = "Total Bounty: +" .. formattedTotal .. "$"
        end)
    end
end)
-------------------------------------------------------------------------
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

-------------------------------------------------------------------------
                            
