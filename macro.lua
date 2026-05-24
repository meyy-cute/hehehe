-------------------------
if not getgenv().MacroConfig then
    getgenv().MacroConfig = {
        Settings = {
            Enabled = false,
            ActivationKey = "G",
            LoopCombo = false,
            AimTargetMode = "ClosestPlayer"
        },
        PredictionSettings = {
            Prediction = true,
            PredictionFactor = 0.15,
            MaxDistance = 500
        },
        ComboBlocks = {}
    }
    
    for i = 1, 12 do
        getgenv().MacroConfig.ComboBlocks[i] = {
            BlockName = "Combo " .. i,
            EquipItem = { Enabled = false, ItemName = "Melee" },
            BeforeSkill = {
                Enabled = true,
                Actions = {
                    { Action = "Soru", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Jump", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, DelayAfter = 0 }
                }
            },
            SkillAction = {
                Button = "Z", SpamCount = 1, SpamInterval = 0.01,
                HoldTime = 0, DelayTime = 0, AimMode = "Body", VectorOffset = Vector3.new(0, 0, 0)
            },
            AfterSkill = {
                Enabled = true,
                Actions = {
                    { Action = "Soru", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Jump", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, DelayAfter = 0 }
                }
            },
            BlockDelayAfter = 0
        }
    end
end

-------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library.lua"))()
local Window = Library:CreateWindow({Title = "meyy Premium Hub"})

local SettingsTab = Window:CreateTab("Settings", true, "")
local Combo1_6 = Window:CreateTab("Combo 1-6", false, "")
local Combo7_12 = Window:CreateTab("Combo 7-12", false, "")

-------------------------
SettingsTab:CreatePageTitle("Global Configuration")

SettingsTab:CreateSwitch("Master Switch", getgenv().MacroConfig.Settings.Enabled, "", function(state)
    getgenv().MacroConfig.Settings.Enabled = state
end)

SettingsTab:CreateDropdown("Activation Key", getgenv().MacroConfig.Settings.ActivationKey, {"Z", "X", "C", "V", "E", "G", "F", "Q", "R", "T", "Y", "H"}, "", function(val)
    getgenv().MacroConfig.Settings.ActivationKey = val
end)

SettingsTab:CreateSwitch("Loop Combo", getgenv().MacroConfig.Settings.LoopCombo, "", function(state)
    getgenv().MacroConfig.Settings.LoopCombo = state
end)

SettingsTab:CreateDropdown("Aim Target Mode", getgenv().MacroConfig.Settings.AimTargetMode, {"ClosestPlayer", "Mouse"}, "", function(val)
    getgenv().MacroConfig.Settings.AimTargetMode = val
end)

SettingsTab:CreatePageTitle("Prediction Engine")

SettingsTab:CreateSwitch("Enable Prediction", getgenv().MacroConfig.PredictionSettings.Prediction, "", function(state)
    getgenv().MacroConfig.PredictionSettings.Prediction = state
end)

SettingsTab:CreateSlider("Prediction Factor (%)", 0, 100, math.floor(getgenv().MacroConfig.PredictionSettings.PredictionFactor * 100), "", function(val)
    getgenv().MacroConfig.PredictionSettings.PredictionFactor = val / 100
end)

SettingsTab:CreateSlider("Max Target Distance", 100, 2000, getgenv().MacroConfig.PredictionSettings.MaxDistance, "", function(val)
    getgenv().MacroConfig.PredictionSettings.MaxDistance = val
end)

-------------------------
---------
local Keys = {"Z", "X", "C", "V", "F", "E", "Q"}
local Weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}

for i = 1, 12 do
    local currentTab = i <= 6 and Combo1_6 or Combo7_12
    
    currentTab:CreatePageTitle("Combo Block " .. i)
    
    currentTab:CreateSwitch("Enable Equip", getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled, "", function(state)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled = state
    end)
    
    currentTab:CreateDropdown("Select Weapon", getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName, Weapons, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName = val
    end)
    
    currentTab:CreateMultiDropdown("Before Skill", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    
    currentTab:CreateDropdown("Skill Key", getgenv().MacroConfig.ComboBlocks[i].SkillAction.Button, Keys, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.Button = val
    end)
    
    currentTab:CreateSlider("Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].SkillAction.SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.SpamCount = val
    end)
    
    currentTab:CreateSlider("Hold Time (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].SkillAction.HoldTime * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.HoldTime = val / 1000
    end)
    
    currentTab:CreateSlider("Delay Time (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].SkillAction.DelayTime * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.DelayTime = val / 1000
    end)
    
    currentTab:CreateDropdown("Aim Mode", getgenv().MacroConfig.ComboBlocks[i].SkillAction.AimMode, {"Body", "Vector"}, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.AimMode = val
    end)
    
    local currentDir = "Ground"
    local currentDist = 0
    local function UpdateVector()
        local vec = Vector3.new(0,0,0)
        if currentDir == "Ground" then vec = Vector3.new(0, -currentDist, 0)
        elseif currentDir == "Sky" then vec = Vector3.new(0, currentDist, 0)
        elseif currentDir == "Left" then vec = Vector3.new(-currentDist, 0, 0)
        elseif currentDir == "Right" then vec = Vector3.new(currentDist, 0, 0)
        end
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.VectorOffset = vec
    end
    
    currentTab:CreateDropdown("Vector Direction", "Ground", {"Ground", "Sky", "Left", "Right"}, "", function(val)
        currentDir = val
        UpdateVector()
    end)
    
    currentTab:CreateSlider("Vector Offset Distance", 0, 50, 0, "", function(val)
        currentDist = val
        UpdateVector()
    end)
    
    currentTab:CreateMultiDropdown("After Skill", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    
    currentTab:CreateSlider("Block Cooldown (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter = val / 1000
    end)
end
---------
-------------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().MacroAimPos = nil
getgenv().SilentAimActive = false
local IsMacroRunning = false
local CurrentTarget = nil
local ActiveAimMode = "Body"
local ActiveVectorOffset = Vector3.new(0,0,0)
local AimUpdaterConnection = nil

local PREDICT_RATIO = 70 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}

local FOV_RADIUS = 1500
local SMOOTHNESS = 1

-------------------------
local function GetTarget()
    local config = getgenv().MacroConfig
    local mode = config.Settings.AimTargetMode
    local maxDist = config.PredictionSettings.MaxDistance
    
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    if not myRoot then return nil, nil end
    local myPos = myRoot.Position

    if mode == "ClosestPlayer" then
        local dist = maxDist
        local targetPlayer = nil
        local targetPart = nil
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("Head")
                if root then
                    local mag = (root.Position - myPos).Magnitude
                    if mag <= dist then
                        dist = mag
                        targetPlayer = p
                        targetPart = root
                    end
                end
            end
        end
        return targetPlayer, targetPart
    elseif mode == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then
            return nil, mouse.Hit.Position
        end
    end
    
    return nil, nil
end

-------------------------
local function getClosestPlayerForSoru()
    local closestPlayer = nil
    local shortestDistance = 3000
    local char = LocalPlayer.Character
    if not char then return nil end
    local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    if not myPart then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetChar = player.Character
            local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
            if targetPart then
                local distance = (myPart.Position - targetPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-------------------------
local function GetClosestPlayerInFOV()
    local Target = nil
    local ShortestDistance = FOV_RADIUS
    local MousePosition = UserInputService:GetMouseLocation()

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local RootPart = Player.Character.HumanoidRootPart
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                local Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - MousePosition).Magnitude
                if Distance < ShortestDistance then
                    ShortestDistance = Distance
                    Target = RootPart
                end
            end
        end
    end
    return Target
end

-------------------------
local function getPredictedPosition(target)
    if not target or not target.Character then return nil end
    
    local targetChar = target.Character
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
    local targetHum = targetChar:FindFirstChild("Humanoid")
    
    if not targetPart then return nil end
    
    local config = getgenv().MacroConfig.PredictionSettings
    if not config.Prediction then
        return targetPart.Position
    end
    
    local currentTime = tick()
    local currentPos = targetPart.Position
    
    if not enemyHistory[target.Name] then
        enemyHistory[target.Name] = {
            lastPos = currentPos,
            lastTime = currentTime,
            speeds = {}
        }
        return targetPart.Position + (targetPart.CFrame.LookVector * 5)
    end
    
    local data = enemyHistory[target.Name]
    local deltaTime = currentTime - data.lastTime
    
    if deltaTime > 0.001 then
        local distance = (currentPos - data.lastPos).Magnitude
        local instantSpeed = distance / deltaTime
        
        table.insert(data.speeds, instantSpeed)
        if #data.speeds > MAX_SAMPLES then
            table.remove(data.speeds, 1)
        end
        
        data.lastPos = currentPos
        data.lastTime = currentTime
    end
    
    local averageSpeed = 0
    if #data.speeds > 0 then
        local sumSpeed = 0
        for _, s in ipairs(data.speeds) do
            sumSpeed = sumSpeed + s
        end
        averageSpeed = sumSpeed / #data.speeds
    end
    
    local moveActualDir = Vector3.new(0, 0, 0)
    local diff = currentPos - data.lastPos
    if diff.Magnitude > 0 then
        moveActualDir = diff.Unit
    end
    
    local basePos
    if averageSpeed > 0.5 then
        local finalDir
        if targetHum and targetHum.MoveDirection.Magnitude > 0 then
            local moveDir = targetHum.MoveDirection
            local lookDir = targetPart.CFrame.LookVector
            finalDir = (moveDir.Unit + lookDir).Unit
        else
            finalDir = moveActualDir
        end
        
        local predictStud = averageSpeed * PREDICT_RATIO
        basePos = targetPart.Position + (finalDir * predictStud)
    else
        basePos = targetPart.Position + (targetPart.CFrame.LookVector * 5)
    end
    
    return basePos
end

-------------------------
local function SimulateKey(keyStr, isHold, releaseDelay)
    local success, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
    if not success then return end
    
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    if not isHold then
        task.wait(0.01)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    elseif releaseDelay then
        task.spawn(function()
            task.wait(releaseDelay)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        end)
    end
end

local function SimulateClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-------------------------
local function ExecuteActionPipeline(actionData)
    if not actionData.Enabled or not IsMacroRunning then return end
    local actionType = actionData.Action
    local count = actionData.Count or 1
    local interval = actionData.Interval or 0
    
    for i = 1, count do
        if not IsMacroRunning then break end
        
        if actionType == "Soru" then
            pcall(function()
                local targetPlayer = getClosestPlayerForSoru()
                local char = LocalPlayer.Character
                if not char then return end
                local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
                
                if myPart and targetPlayer then
                    local targetChar = targetPlayer.Character
                    if not targetChar then return end
                    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
                    local targetHum = targetChar:FindFirstChild("Humanoid")
                    
                    if targetPart then
                        local currentTime = tick()
                        local currentPos = targetPart.Position
                        
                        if not enemyHistory[targetPlayer.Name] then
                            enemyHistory[targetPlayer.Name] = {
                                lastPos = currentPos,
                                lastTime = currentTime,
                                speeds = {}
                            }
                            local basePos = targetPart.Position + (targetPart.CFrame.LookVector * 5)
                            local offsets = {
                                Vector3.new(7, 5, 0),
                                Vector3.new(-7, 5, 0),
                                Vector3.new(0, 5, 7),
                                Vector3.new(0, 5, -4)
                            }
                            local randomOffset = offsets[math.random(1, #offsets)]
                            local finalTpPos = basePos + randomOffset
                            myPart.CFrame = CFrame.new(finalTpPos, finalTpPos + myPart.CFrame.LookVector)
                            return
                        end
                        
                        local data = enemyHistory[targetPlayer.Name]
                        local deltaTime = currentTime - data.lastTime
                        
                        if deltaTime > 0 then
                            local distance = (currentPos - data.lastPos).Magnitude
                            local instantSpeed = distance / deltaTime
                            
                            table.insert(data.speeds, instantSpeed)
                            if #data.speeds > MAX_SAMPLES then
                                table.remove(data.speeds, 1)
                            end
                            
                            local sumSpeed = 0
                            for _, s in ipairs(data.speeds) do
                                sumSpeed = sumSpeed + s
                            end
                            local averageSpeed = sumSpeed / #data.speeds
                            
                            local diff = currentPos - data.lastPos
                            local moveActualDir = diff.Magnitude > 0 and diff.Unit or Vector3.new(0, 0, 0)
                            
                            data.lastPos = currentPos
                            data.lastTime = currentTime
                            
                            local basePos
                            if averageSpeed > 0.5 then
                                local finalDir
                                if targetHum and targetHum.MoveDirection.Magnitude > 0 then
                                    local moveDir = targetHum.MoveDirection
                                    local lookDir = targetPart.CFrame.LookVector
                                    finalDir = (moveDir.Unit + lookDir).Unit
                                else
                                    finalDir = moveActualDir
                                end
                                
                                local predictStud = averageSpeed * PREDICT_RATIO
                                basePos = targetPart.Position + (finalDir * predictStud)
                            else
                                basePos = targetPart.Position + (targetPart.CFrame.LookVector * 5)
                            end

                            local offsets = {
                                Vector3.new(7, 5, 0),
                                Vector3.new(-7, 5, 0),
                                Vector3.new(0, 5, 7),
                                Vector3.new(0, 5, -4)
                            }
                            local randomOffset = offsets[math.random(1, #offsets)]
                            local finalTpPos = basePos + randomOffset
                            
                            myPart.CFrame = CFrame.new(finalTpPos, finalTpPos + myPart.CFrame.LookVector)
                        end
                    end
                end
            end)
        elseif actionType == "Jump" then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").Jump = true
                end
            end)
        elseif actionType == "Key" and actionData.Button then
            SimulateKey(actionData.Button, false)
        elseif actionType == "Click" then
            SimulateClick()
        end
        
        if i < count and interval > 0 then
            task.wait(interval)
        end
    end
end

-------------------------
local function ProcessActionList(sectionInfo)
    if not sectionInfo.Enabled or not IsMacroRunning then return end
    
    for _, actionData in ipairs(sectionInfo.Actions) do
        if not IsMacroRunning then break end
        if not actionData.Enabled then continue end
        
        if actionData.RunInThread then
            task.spawn(function()
                ExecuteActionPipeline(actionData)
                if actionData.DelayAfter and actionData.DelayAfter > 0 then
                    task.wait(actionData.DelayAfter)
                end
            end)
        else
            ExecuteActionPipeline(actionData)
            if actionData.DelayAfter and actionData.DelayAfter > 0 then
                task.wait(actionData.DelayAfter)
            end
        end
    end
end

-------------------------
local function ProcessSkillAction(skillData)
    if not IsMacroRunning or not skillData.Button then return end
    
    ActiveAimMode = skillData.AimMode or "Body"
    ActiveVectorOffset = skillData.VectorOffset or Vector3.new(0,0,0)
    
    AimUpdaterConnection = RunService.RenderStepped:Connect(function()
        if not IsMacroRunning then return end
        local targetPlayer, targetPart = GetTarget()
        
        if targetPlayer and targetPart then
            CurrentTarget = targetPlayer
            local predPos = getPredictedPosition(targetPlayer)
            
            if predPos then
                if ActiveAimMode == "Vector" and ActiveVectorOffset then
                    predPos = predPos + ActiveVectorOffset
                end
                
                local char = LocalPlayer.Character
                local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
                
                if myRoot then
                    getgenv().MacroAimPos = CFrame.new(myRoot.Position, predPos)
                    myRoot.CFrame = CFrame.new(myRoot.Position, predPos)
                end
            end
        elseif targetPart and typeof(targetPart) == "Vector3" then
            local predPos = targetPart
            if ActiveAimMode == "Vector" and ActiveVectorOffset then
                predPos = predPos + ActiveVectorOffset
            end
            
            local char = LocalPlayer.Character
            local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
            
            if myRoot then
                getgenv().MacroAimPos = CFrame.new(myRoot.Position, predPos)
                myRoot.CFrame = CFrame.new(myRoot.Position, predPos)
            end
        else
            getgenv().MacroAimPos = nil
        end
        
        if not getgenv().SilentAimActive then
            pcall(function()
                local lockTarget = GetClosestPlayerInFOV()
                if lockTarget then
                    local MousePosition = UserInputService:GetMouseLocation()
                    local TargetScreenPos, OnScreen = Camera:WorldToViewportPoint(lockTarget.Position)
                    
                    if OnScreen then
                        local TargetCFrame = Camera.CFrame * CFrame.Angles(0, math.rad((MousePosition.X - TargetScreenPos.X) * 0.1), 0) * CFrame.Angles(math.rad((MousePosition.Y - TargetScreenPos.Y) * 0.1), 0, 0)
                        Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, SMOOTHNESS)
                    end
                end
            end)
        end
    end)

    local spamCount = skillData.SpamCount or 1
    local spamInterval = skillData.SpamInterval or 0
    local holdTime = skillData.HoldTime or 0
    local delayTime = skillData.DelayTime or 0
    
    for i = 1, spamCount do
        if not IsMacroRunning then break end
        SimulateKey(skillData.Button, false)
        if spamInterval > 0 then
            task.wait(spamInterval)
        end
    end
    
    if IsMacroRunning and holdTime > 0 then
        SimulateKey(skillData.Button, true, holdTime)
        task.wait(holdTime)
    end
    
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
    getgenv().MacroAimPos = nil
    
    if IsMacroRunning and delayTime > 0 then
        task.wait(delayTime)
    end
end

-------------------------
local function EquipConfiguredItem(equipInfo)
    if not equipInfo.Enabled or not equipInfo.ItemName or not IsMacroRunning then return end
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2))
    
    if humanoid and backpack and char then
        local targetTool = nil
        local searchType = string.lower(equipInfo.ItemName)
        
        local function scanTools(container)
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local nameLower = string.lower(item.Name)
                    local tipLower = string.lower(item.ToolTip)
                    
                    if searchType == "fruit" or searchType == "blox fruit" then
                        if tipLower == "blox fruit" or string.find(nameLower, "fruit") then
                            return item
                        end
                    elseif searchType == "melee" then
                        if tipLower == "melee" or string.find(nameLower, "combat") or string.find(nameLower, "style") or item:FindFirstChild("MeleeScript") then
                            return item
                        end
                    elseif searchType == "sword" then
                        if tipLower == "sword" or item:FindFirstChild("SwordScript") then
                            return item
                        end
                    elseif searchType == "gun" then
                        if tipLower == "gun" or item:FindFirstChild("GunScript") then
                            return item
                        end
                    else
                        if string.find(nameLower, searchType) then
                            return item
                        end
                    end
                end
            end
            return nil
        end
        
        targetTool = scanTools(char) or scanTools(backpack)
        
        if targetTool then
            if targetTool.Parent == backpack then
                humanoid:EquipTool(targetTool)
            end
        end
    end
end

-------------------------
local function TurnOffMacroUI()
    if getgenv().ComboLabelUpdate then getgenv().ComboLabelUpdate("Combo: None") end
    
    local screenGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MacroToggleUI")
    if screenGui then
        local mainFrame = screenGui:FindFirstChild("Main")
        if mainFrame then
            local btn = mainFrame:FindFirstChild("ToggleButton")
            if btn then
                btn.Text = "OFF"
                btn.TextColor3 = Color3.fromRGB(255, 85, 85)
            end
        end
    end
end

local function RunMacroSequence()
    local config = getgenv().MacroConfig
    
    repeat
        for i, block in ipairs(config.ComboBlocks) do
            if not IsMacroRunning then break end
            
            local targetPlayer, targetPart = GetTarget()
            CurrentTarget = targetPlayer
            
            local nextBlock = config.ComboBlocks[i + 1]
            local nextName = nextBlock and nextBlock.BlockName or "End"
            if getgenv().ComboLabelUpdate then
                getgenv().ComboLabelUpdate(block.BlockName .. " -> " .. nextName)
            end
            
            EquipConfiguredItem(block.EquipItem)
            ProcessActionList(block.BeforeSkill)
            ProcessSkillAction(block.SkillAction)
            ProcessActionList(block.AfterSkill)
            
            if block.BlockDelayAfter and block.BlockDelayAfter > 0 and IsMacroRunning then
                task.wait(block.BlockDelayAfter)
            end
        end
    until not config.Settings.LoopCombo or not IsMacroRunning
    
    IsMacroRunning = false
    getgenv().MacroAimPos = nil
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
    
    TurnOffMacroUI()
end

-------------------------
local function TriggerButtonAnimation(btn)
    local normalBtnSize = UDim2.new(0.6, 0, 0, 35)
    local popSize = UDim2.new(0.65, 0, 0, 40)
    
    TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = popSize, Rotation = 5
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = normalBtnSize, Rotation = -5
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = normalBtnSize, Rotation = 0
    }):Play()
end

local function ToggleMacroState()
    local config = getgenv().MacroConfig
    if not config.Settings.Enabled then return end
    
    IsMacroRunning = not IsMacroRunning
    
    local screenGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MacroToggleUI")
    if screenGui then
        local mainFrame = screenGui:FindFirstChild("Main")
        if mainFrame then
            local btn = mainFrame:FindFirstChild("ToggleButton")
            if btn then
                task.spawn(TriggerButtonAnimation, btn)
                if IsMacroRunning then
                    btn.Text = "ON"
                    btn.TextColor3 = Color3.fromRGB(85, 255, 127)
                else
                    btn.Text = "OFF"
                    btn.TextColor3 = Color3.fromRGB(255, 85, 85)
                end
            end
        end
    end
    
    if IsMacroRunning then
        task.spawn(RunMacroSequence)
    else
        if AimUpdaterConnection then
            AimUpdaterConnection:Disconnect()
            AimUpdaterConnection = nil
        end
        getgenv().MacroAimPos = nil
        TurnOffMacroUI()
    end
end

-------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local config = getgenv().MacroConfig
    local success, toggleKey = pcall(function() return Enum.KeyCode[config.Settings.ActivationKey] end)
    
    if success and input.KeyCode == toggleKey then
        ToggleMacroState()
    end
end)

-------------------------
local function CreateUI()
    local oldUI = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MacroToggleUI")
    if oldUI then oldUI:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MacroToggleUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "Main"
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.Position = UDim2.new(0.3, 0, 0, 50)
    MainFrame.Size = UDim2.new(0, 240, 0, 280) 
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.ClipsDescendants = false 

    local mainCorner = Instance.new("UICorner", MainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke", MainFrame)
    mainStroke.Thickness = 2.5
    mainStroke.Color = Color3.new(1, 1, 1)
    local strokeGradient = Instance.new("UIGradient", mainStroke)

    local bgGradient = Instance.new("UIGradient", MainFrame)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
    })

    local statusGradients = {strokeGradient}

    local function CreateStatusLabel(name, pos, text)
        local label = Instance.new("TextLabel", MainFrame)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 30) 
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = 13
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextWrapped = true 
        label.RichText = true
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 0.5
        txtStroke.Color = Color3.fromRGB(150, 200, 220)
        
        local txtGradient = Instance.new("UIGradient", label)
        table.insert(statusGradients, txtGradient)
        return label
    end

    local TitleLabel = CreateStatusLabel("TopInfo", 10, "Combo Macro UI")
    
    local divider = Instance.new("Frame", MainFrame)
    divider.Name = "Divider"
    divider.Size = UDim2.new(0, 180, 0, 2)
    divider.Position = UDim2.new(0.5, 0, 0, 45)
    divider.AnchorPoint = Vector2.new(0.5, 0)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Color3.fromRGB(173, 216, 230) 
    
    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.1, 0),
        NumberSequenceKeypoint.new(0.9, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local TargetLabel = CreateStatusLabel("TargetInfo", 55, "Target: None")
    local DistanceLabel = CreateStatusLabel("DistanceInfo", 90, "Distance: 0m")
    local AimModeLabel = CreateStatusLabel("AimModeInfo", 125, "Aim: Body")
    local ComboLabel = CreateStatusLabel("ComboInfo", 160, "Combo: None")

    local toggleBtn = Instance.new("TextButton", MainFrame)
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0.6, 0, 0, 35) 
    toggleBtn.Position = UDim2.new(0.5, 0, 0, 220) 
    toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
    toggleBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    toggleBtn.TextSize = 16

    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local btnStroke = Instance.new("UIStroke", toggleBtn)
    btnStroke.Thickness = 2.5
    btnStroke.Color = Color3.new(1, 1, 1)

    local btnBgGradient = Instance.new("UIGradient", toggleBtn)
    table.insert(statusGradients, btnBgGradient)
    local btnStrokeGradient = Instance.new("UIGradient", btnStroke)
    table.insert(statusGradients, btnStrokeGradient) 

    toggleBtn.MouseButton1Click:Connect(function()
        ToggleMacroState()
    end)

    local DirFrame = Instance.new("Frame", ScreenGui)
    DirFrame.Name = "DirectionAimUI"
    DirFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DirFrame.BackgroundTransparency = 0.3
    DirFrame.Position = UDim2.new(0, 20, 0.5, 0)
    DirFrame.Size = UDim2.new(0, 80, 0, 80) 
    DirFrame.AnchorPoint = Vector2.new(0, 0.5)
    DirFrame.ClipsDescendants = false 

    local dirCorner = Instance.new("UICorner", DirFrame)
    dirCorner.CornerRadius = UDim.new(0, 10)

    local dirStroke = Instance.new("UIStroke", DirFrame)
    dirStroke.Thickness = 2.5
    dirStroke.Color = Color3.new(1, 1, 1)
    local dirStrokeGrad = Instance.new("UIGradient", dirStroke)
    
    local dirBgGradient = Instance.new("UIGradient", DirFrame)
    dirBgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
    })

    local DirText = Instance.new("TextLabel", DirFrame)
    DirText.Size = UDim2.new(1, 0, 1, 0)
    DirText.BackgroundTransparency = 1
    DirText.Font = Enum.Font.GothamBold
    DirText.Text = "NONE"
    DirText.TextSize = 14
    DirText.TextColor3 = Color3.new(1, 1, 1)
    
    local dirTxtStroke = Instance.new("UIStroke", DirText)
    dirTxtStroke.Thickness = 0.5
    dirTxtStroke.Color = Color3.fromRGB(150, 200, 220)
    
    local dirTxtGradient = Instance.new("UIGradient", DirText)
    table.insert(statusGradients, dirTxtGradient)
    table.insert(statusGradients, dirStrokeGrad)
    table.insert(statusGradients, dirBgGradient)

    local function MakeDraggable(gui)
        local dragging, dragInput, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                TweenService:Create(gui, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end)
    end

    MakeDraggable(MainFrame)
    MakeDraggable(DirFrame)

    local ESPhighlight = Instance.new("Highlight")
    ESPhighlight.Name = "MacroESP"
    ESPhighlight.FillColor = Color3.fromRGB(255, 50, 50)
    ESPhighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    ESPhighlight.FillTransparency = 0.5
    ESPhighlight.OutlineTransparency = 0
    ESPhighlight.Parent = CoreGui

    local TracerLine = Instance.new("LineHandleAdornment")
    TracerLine.Name = "MacroTracer"
    TracerLine.Color3 = Color3.fromRGB(255, 0, 0)
    TracerLine.Thickness = 3
    TracerLine.ZIndex = 10
    TracerLine.AlwaysOnTop = true
    TracerLine.Parent = CoreGui

    getgenv().ComboLabelUpdate = function(text)
        if ComboLabel then ComboLabel.Text = text end
    end

    local r = 0
    RunService.RenderStepped:Connect(function()
        r = (r + 1.5) % 360
        local c1, c2 = Color3.fromRGB(180, 220, 255), Color3.new(1, 1, 1)
        local colorSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1), 
            ColorSequenceKeypoint.new(0.5, c2), 
            ColorSequenceKeypoint.new(1, c1)
        })
        
        for _, grad in ipairs(statusGradients) do
            grad.Rotation = r
            grad.Color = colorSeq
        end
        bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
        dirBgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)

        AimModeLabel.Text = "Aim: " .. ActiveAimMode

        local targetPlayer, targetPart = GetTarget()
        CurrentTarget = targetPlayer
        local char = LocalPlayer.Character
        local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))

        if CurrentTarget and CurrentTarget.Character and myRoot then
            local tarRoot = CurrentTarget.Character:FindFirstChild("HumanoidRootPart") or CurrentTarget.Character:FindFirstChild("UpperTorso")
            
            if tarRoot then
                TargetLabel.Text = "Target: " .. CurrentTarget.Name
                local dist = (myRoot.Position - tarRoot.Position).Magnitude
                DistanceLabel.Text = "Distance: " .. math.floor(dist) .. "m"

                ESPhighlight.Adornee = CurrentTarget.Character
                
                TracerLine.Adornee = myRoot
                TracerLine.Length = dist
                TracerLine.CFrame = CFrame.lookAt(Vector3.new(0,0,0), tarRoot.Position - myRoot.Position)
                TracerLine.Visible = true

                local rel = myRoot.CFrame:PointToObjectSpace(tarRoot.Position)
                local absX, absY, absZ = math.abs(rel.X), math.abs(rel.Y), math.abs(rel.Z)
                
                if absY > absX and absY > absZ then
                    DirText.Text = rel.Y > 0 and "UP" or "DOWN"
                elseif absX > absZ then
                    DirText.Text = rel.X > 0 and "RIGHT" or "LEFT"
                else
                    DirText.Text = rel.Z > 0 and "BACK" or "FRONT"
                end
            else
                TargetLabel.Text = "Target: None"
                DistanceLabel.Text = "Distance: 0m"
                DirText.Text = "NONE"
                ESPhighlight.Adornee = nil
                TracerLine.Visible = false
            end
        else
            TargetLabel.Text = "Target: None"
            DistanceLabel.Text = "Distance: 0m"
            DirText.Text = "NONE"
            ESPhighlight.Adornee = nil
            TracerLine.Visible = false
        end
    end)
end

task.spawn(CreateUI)

-------------------------
local successHook = pcall(function()
    local MT = getrawmetatable(game)
    local OldNameCall = MT.__namecall
    setreadonly(MT, false)

    MT.__namecall = newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        
        if Method == "FireServer" and getgenv().MacroAimPos then
            if self.Name == "RemoteEvent" then 
                if typeof(Args[1]) == "Vector3" then
                    Args[1] = getgenv().MacroAimPos.Position
                    return OldNameCall(self, unpack(Args))
                elseif typeof(Args[1]) == "CFrame" then
                    Args[1] = getgenv().MacroAimPos
                    return OldNameCall(self, unpack(Args))
                end
            end
        end
        
        return OldNameCall(self, ...)
    end)

    setreadonly(MT, true)
end)

if successHook then
    getgenv().SilentAimActive = true
end
