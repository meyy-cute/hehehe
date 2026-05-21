
if not getgenv().MacroConfig then
    getgenv().MacroConfig = {
        Settings = {
            Enabled = true,
            ActivationKey = "G",
            LoopCombo = false,
            AimTargetMode = "ClosestPlayer"
        },
        PredictionSettings = {
            Prediction = true,
            PredictionFactor = 0.15,
            MaxDistance = 500
        },
        ComboBlocks = {
            {
                BlockName = "Combo 1: Melee Open",
                EquipItem = { Enabled = true, ItemName = "Blox Fruit" },
                BeforeSkill = {
                    Enabled = true,
                    Actions = {
                        { Action = "Soru", Enabled = true, RunInThread = false, DelayAfter = 0.00001 }
                    }
                },
                SkillAction = {
                    Button = "C", SpamCount = 15, SpamInterval = 0.001,
                    HoldTime = 0, DelayTime = 0.01, AimMode = "Body", VectorOffset = Vector3.new(0, 0, 0)
                },
                AfterSkill = { Enabled = false, Actions = {} },
                BlockDelayAfter = 0.1
            },
            {
                BlockName = "Combo 2: Sword Break",
                EquipItem = { Enabled = true, ItemName = "Sword" },
                BeforeSkill = { Enabled = false, Actions = {} },
                SkillAction = {
                    Button = "X", SpamCount = 20, SpamInterval = 0.01,
                    HoldTime = 0.4, DelayTime = 0.3, AimMode = "Vector", VectorOffset = Vector3.new(0, -15, 0)
                },
                AfterSkill = { Enabled = false, Actions = {} },
                BlockDelayAfter = 0.1
            },
            {
                BlockName = "Combo 3: Gun Extender",
                EquipItem = { Enabled = true, ItemName = "Melee" },
                BeforeSkill = { Enabled = false, Actions = {} },
                SkillAction = {
                    Button = "X", SpamCount = 10, SpamInterval = 0.01,
                    HoldTime = 0, DelayTime = 0.1, AimMode = "Vector", VectorOffset = Vector3.new(0, -2, 0)
                },
                AfterSkill = { Enabled = false, Actions = {} },
                BlockDelayAfter = 0.05
            },
            {
                BlockName = "Combo 4: Fruit Finisher",
                EquipItem = { Enabled = true, ItemName = "Blox Fruit" },
                BeforeSkill = { Enabled = false, Actions = {} },
                SkillAction = {
                    Button = "F", SpamCount = 25, SpamInterval = 0.01,
                    HoldTime = 0.6, DelayTime = 0.4, AimMode = "Body", VectorOffset = Vector3.new(0, 0, 0)
                },
                AfterSkill = {
                    Enabled = true,
                    Actions = {
                        { Action = "Key", Button = "Space", Enabled = true, RunInThread = false, Count = 2, Interval = 0.1, DelayAfter = 0 }
                    }
                },
                BlockDelayAfter = 0.5
            }
        }
    }
end

---------------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

local function RunMacroSequence()
    local config = getgenv().MacroConfig
    
    repeat
        for i, block in ipairs(config.ComboBlocks) do
            if not IsMacroRunning then break end
            
            local targetPlayer, targetPart = GetTarget()
            CurrentTarget = targetPlayer
            
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
end

---------------------------------------------------------

local function ToggleMacroState()
    local config = getgenv().MacroConfig
    if not config.Settings.Enabled then return end
    
    IsMacroRunning = not IsMacroRunning
    
    if IsMacroRunning then
        task.spawn(RunMacroSequence)
    else
        if AimUpdaterConnection then
            AimUpdaterConnection:Disconnect()
            AimUpdaterConnection = nil
        end
        getgenv().MacroAimPos = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local config = getgenv().MacroConfig
    local success, toggleKey = pcall(function() return Enum.KeyCode[config.Settings.ActivationKey] end)
    
    if success and input.KeyCode == toggleKey then
        ToggleMacroState()
    end
end)

---------------------------------------------------------

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

---------------------------------------------------------

pcall(function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library"))()
    Library:SendNotification("Meyy Hub", "Macro Combo Initialized!")
    local Window = Library:CreateWindow({Title = "Meyy Hub - Super Macro"})

    local MainTab = Window:CreateTab("Main Combo", true)
    local SettingsTab = Window:CreateTab("Settings", false)

    SettingsTab:CreatePageTitle("System Configurations")
    SettingsTab:CreatePageSubTitle("Global & Aim Prediction Settings")
    
    SettingsTab:CreateSwitch("Macro Master Switch", getgenv().MacroConfig.Settings.Enabled, function(state)
        getgenv().MacroConfig.Settings.Enabled = state
        if not state and IsMacroRunning then
            ToggleMacroState()
        end
    end)

    local keys = {"Q", "E", "R", "T", "Y", "F", "G", "H", "Z", "X", "C", "V", "B"}
    local defaultKey = getgenv().MacroConfig.Settings.ActivationKey
    SettingsTab:CreateDropdown("Activation Key", defaultKey, keys, function(selected)
        getgenv().MacroConfig.Settings.ActivationKey = selected
    end)

    SettingsTab:CreateSwitch("Loop Continuous Combo", getgenv().MacroConfig.Settings.LoopCombo, function(state)
        getgenv().MacroConfig.Settings.LoopCombo = state
    end)

    SettingsTab:CreateDropdown("Aim Target Mode", getgenv().MacroConfig.Settings.AimTargetMode, {"ClosestPlayer", "Mouse"}, function(selected)
        getgenv().MacroConfig.Settings.AimTargetMode = selected
    end)

    SettingsTab:CreateSwitch("Enable Velocity Prediction", getgenv().MacroConfig.PredictionSettings.Prediction, function(state)
        getgenv().MacroConfig.PredictionSettings.Prediction = state
    end)

    local factorPercent = math.floor(getgenv().MacroConfig.PredictionSettings.PredictionFactor * 100)
    SettingsTab:CreateSlider("Prediction Factor", 0, 100, factorPercent, function(value)
        getgenv().MacroConfig.PredictionSettings.PredictionFactor = value / 100
    end)

    SettingsTab:CreateSlider("Max Aim Distance", 100, 2000, getgenv().MacroConfig.PredictionSettings.MaxDistance, function(value)
        getgenv().MacroConfig.PredictionSettings.MaxDistance = value
    end)

    for _, block in ipairs(getgenv().MacroConfig.ComboBlocks) do
        MainTab:CreatePageTitle(block.BlockName)
        
        MainTab:CreateSwitch("Equip Tool Before Skill", block.EquipItem.Enabled, function(state)
            block.EquipItem.Enabled = state
        end)
        
        MainTab:CreateDropdown("Select Equip Weapon", block.EquipItem.ItemName, {"Melee", "Sword", "Gun", "Fruit"}, function(selected)
            block.EquipItem.ItemName = selected
        end)
        
        MainTab:CreateParagraph("Information", "Before & After Actions Configuration")
        
        local beforeActionsAvailable = {}
        local beforeActionsSelected = {}
        if block.BeforeSkill.Actions then
            for _, act in ipairs(block.BeforeSkill.Actions) do
                local actName = act.Action or "Unknown"
                table.insert(beforeActionsAvailable, actName)
                if act.Enabled then table.insert(beforeActionsSelected, actName) end
            end
        end
        if #beforeActionsAvailable == 0 then beforeActionsAvailable = {"None"} end
        
        MainTab:CreateMultiDropdown("Before Skill Features", beforeActionsSelected, beforeActionsAvailable, function(selectedItems)
            block.BeforeSkill.Enabled = (#selectedItems > 0)
            if block.BeforeSkill.Actions then
                for _, act in ipairs(block.BeforeSkill.Actions) do
                    local actName = act.Action or "Unknown"
                    local found = false
                    for _, sel in ipairs(selectedItems) do
                        if actName == sel then found = true; break end
                    end
                    act.Enabled = found
                end
            end
        end)
        
        local afterActionsAvailable = {}
        local afterActionsSelected = {}
        if block.AfterSkill.Actions then
            for _, act in ipairs(block.AfterSkill.Actions) do
                local actName = act.Action or "Unknown"
                table.insert(afterActionsAvailable, actName)
                if act.Enabled then table.insert(afterActionsSelected, actName) end
            end
        end
        if #afterActionsAvailable == 0 then afterActionsAvailable = {"None"} end

        MainTab:CreateMultiDropdown("After Skill Features", afterActionsSelected, afterActionsAvailable, function(selectedItems)
            block.AfterSkill.Enabled = (#selectedItems > 0)
            if block.AfterSkill.Actions then
                for _, act in ipairs(block.AfterSkill.Actions) do
                    local actName = act.Action or "Unknown"
                    local found = false
                    for _, sel in ipairs(selectedItems) do
                        if actName == sel then found = true; break end
                    end
                    act.Enabled = found
                end
            end
        end)
        
        MainTab:CreateSlider("Spam Click Count", 1, 50, block.SkillAction.SpamCount, function(value)
            block.SkillAction.SpamCount = value
        end)
        
        local holdMs = math.floor(block.SkillAction.HoldTime * 1000)
        MainTab:CreateSlider("Skill Hold Time (ms)", 0, 3000, holdMs, function(value)
            block.SkillAction.HoldTime = value / 1000
        end)
        
        local delayMs = math.floor(block.SkillAction.DelayTime * 1000)
        MainTab:CreateSlider("Post-Skill Delay Time (ms)", 0, 3000, delayMs, function(value)
            block.SkillAction.DelayTime = value / 1000
        end)
        
        MainTab:CreateDropdown("Skill Aim Mode", block.SkillAction.AimMode, {"Body", "Vector"}, function(selected)
            block.SkillAction.AimMode = selected
        end)
        
        local nextBlockMs = math.floor(block.BlockDelayAfter * 1000)
        MainTab:CreateSlider("Next Block Cooldown (ms)", 0, 3000, nextBlockMs, function(value)
            block.BlockDelayAfter = value / 1000
        end)
    end
end)

