local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

---------
if not getgenv().MacroConfig then
    getgenv().MacroConfig = {
        Settings = {
            Enabled = false,
            ActivationKey = "G",
            LoopCombo = false,
            AimTargetMode = "ClosestPlayer",
            SpamMode = false,
            SpamKeys = {},
            SpamDelay = 0.05,
            AutoSoruSkill = false,
            SoruSkills = {},
            SoruSkillDelay = 0.045,
            AutoSoruCombo = false,
            SoruComboDelay = 0
        },
        PredictionSettings = {
            PredictionAimbot = true,
            PredictionSoru = true,   
            MaxDistance = 500
        },
        ComboBlocks = {}
    }
    
    for i = 1, 12 do
        getgenv().MacroConfig.ComboBlocks[i] = {
            BlockName = "Combo " .. i,
            Enabled = false,
            EquipItem = { Enabled = false, ItemName = "Melee" },
            BeforeSkill = {
                Enabled = true,
                Actions = {
                    { Action = "Soru", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Jump", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 }
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
                    { Action = "Jump", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 }
                }
            },
            BlockDelayAfter = 0
        }
    end
end

---------
getgenv().MacroAimPos = nil
getgenv().SilentAimActive = true
getgenv().IsSpamming = getgenv().IsSpamming or {}

local IsMacroRunning = false
local CurrentTarget = nil
local ActiveAimMode = "Body"
local ActiveVectorOffset = Vector3.new(0,0,0)
local AimUpdaterConnection = nil

local PREDICT_RATIO = 65 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}
local playerSpeedHistory = {}

local FOV_RADIUS = 1500
local SMOOTHNESS = 1

---------
local function getMinValueSpeed(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer or not targetPlayer.Character then return nil end
    
    local targetChar = targetPlayer.Character
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
    if not targetPart then return nil end

    local currentTime = tick()
    local currentPos = targetPart.Position

    if not playerSpeedHistory[playerName] then
        playerSpeedHistory[playerName] = {
            lastPos = currentPos,
            lastTime = currentTime,
            lastCheckTime = currentTime,
            speeds = {},
            lastFinalValue = nil
        }
        return nil
    end

    local data = playerSpeedHistory[playerName]
    local deltaTime = currentTime - data.lastTime

    if deltaTime > 0 then
        local distance = (currentPos - data.lastPos).Magnitude
        local instantSpeed = distance / deltaTime
        table.insert(data.speeds, instantSpeed)
        data.lastPos = currentPos
        data.lastTime = currentTime
    end

    if currentTime - data.lastCheckTime >= 5 then
        if #data.speeds > 0 then
            local minSpeed = math.huge
            for _, s in ipairs(data.speeds) do
                if s < minSpeed then
                    minSpeed = s
                end
            end
            if minSpeed ~= math.huge then
                data.lastFinalValue = minSpeed + 30
            end
        end
        table.clear(data.speeds)
        data.lastCheckTime = currentTime
    end

    return data.lastFinalValue
end

task.spawn(function()
    while task.wait() do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                getMinValueSpeed(p.Name)
            end
        end
    end
end)

---------
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
        
        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if enemiesFolder and not targetPlayer then
            for _, e in pairs(enemiesFolder:GetChildren()) do
                if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                    local mag = (e.HumanoidRootPart.Position - myPos).Magnitude
                    if mag <= dist then
                        dist = mag
                        targetPart = e.HumanoidRootPart
                    end
                end
            end
            return nil, targetPart
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

---------
task.spawn(function()
    while task.wait() do
        if getgenv().MacroConfig.Settings.Enabled then
            if not IsMacroRunning then
                local targetPlayer, targetPart = GetTarget()
                if targetPart then
                    if typeof(targetPart) == "Instance" then
                        getgenv().MacroAimPos = targetPart.CFrame
                    elseif typeof(targetPart) == "Vector3" then
                        getgenv().MacroAimPos = CFrame.new(targetPart)
                    end
                else
                    getgenv().MacroAimPos = nil
                end
            end
        else
            getgenv().MacroAimPos = nil
        end
    end
end)

---------
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

---------
local function getPredictedPosition(target)
    if not target or not target.Character then return nil end
    
    local targetChar = target.Character
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
    local targetHum = targetChar:FindFirstChild("Humanoid")
    if not targetPart then return nil end
    
    local curTime = tick()
    local curPos = targetPart.Position
    
    if not enemyHistory[target.Name] then 
        enemyHistory[target.Name] = {lastPos = curPos, lastTime = curTime, speeds = {}} 
        return curPos 
    end
    
    local data = enemyHistory[target.Name]
    local dT = curTime - data.lastTime
    if dT > 0 then
        local distMoved = (curPos - data.lastPos).Magnitude
        table.insert(data.speeds, distMoved / dT)
        if #data.speeds > MAX_SAMPLES then table.remove(data.speeds, 1) end
        
        local sum = 0 
        for _, s in ipairs(data.speeds) do sum = sum + s end
        local avgSpd = sum / #data.speeds
        
        local moveActDir = Vector3.new(0, 0, 0)
        if distMoved > 0 then
            moveActDir = (curPos - data.lastPos).Unit
        end
        
        data.lastPos = curPos
        data.lastTime = curTime
        
        if avgSpd > 0.5 then
            local fDir = (targetHum and targetHum.MoveDirection.Magnitude > 0) and (targetHum.MoveDirection.Unit + targetPart.CFrame.LookVector).Unit or moveActDir
            return targetPart.Position + (fDir * (avgSpd * PREDICT_RATIO))
        end
    end
    return curPos
end

---------
local function SimulateKey(keyStr, isHold, releaseDelay)
    local success, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
    if not success then return end
    
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    if not isHold then
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
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

---------
local function ExecuteActionPipeline(actionData)
    if not actionData.Enabled or not IsMacroRunning then return true end
    local actionType = actionData.Action
    local count = actionData.SpamCount or 1
    local interval = actionData.SpamInterval or 0
    
    if actionType == "Soru" then
        local targetPlayer = getClosestPlayerForSoru()
        local char = LocalPlayer.Character
        if not char then return false end
        local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
        
        if not myPart or not targetPlayer then return false end
        
        local config = getgenv().MacroConfig.PredictionSettings
        local soruSuccess = false

        if config.PredictionSoru then
            local predPos = getPredictedPosition(targetPlayer)
            if predPos then
                char:PivotTo(CFrame.new(predPos, predPos + myPart.CFrame.LookVector))
                soruSuccess = true
            end
        else
            local startWaitTime = tick()
            while tick() - startWaitTime <= 5 do
                if not IsMacroRunning then return false end
                local targetChar = targetPlayer.Character
                if targetChar then
                    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
                    if targetPart then
                        local targetMinSpeed = playerSpeedHistory[targetPlayer.Name] and playerSpeedHistory[targetPlayer.Name].lastFinalValue or math.huge
                        local currentSpeed = 0
                        local histData = playerSpeedHistory[targetPlayer.Name]
                        if histData and #histData.speeds > 0 then
                            currentSpeed = histData.speeds[#histData.speeds]
                        end
                        
                        if currentSpeed < targetMinSpeed then
                            char:PivotTo(CFrame.new(targetPart.Position, targetPart.Position + myPart.CFrame.LookVector))
                            soruSuccess = true
                            break
                        end
                    end
                end
                task.wait()
            end
        end
        
        if soruSuccess then
            task.wait(0.075)
        end
        return soruSuccess
        
    elseif actionType == "Jump" then
        for i = 1, count do
            if not IsMacroRunning then break end
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            if interval > 0 then task.wait(interval) end
        end
        return true

    elseif actionType == "Click" then
        for i = 1, count do
            if not IsMacroRunning then break end
            SimulateClick()
            if interval > 0 then task.wait(interval) end
        end
        return true
    end

    return true
end

---------
local function ProcessActionList(sectionInfo)
    if not sectionInfo.Enabled or not IsMacroRunning then return true end
    
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
            local success = ExecuteActionPipeline(actionData)
            if success == false then return false end
            
            if actionData.DelayAfter and actionData.DelayAfter > 0 then
                task.wait(actionData.DelayAfter)
            end
        end
    end
    return true
end
---------
local function ProcessSkillAction(skillData, toolName)
    if not IsMacroRunning or not skillData.Button then return true end
    
    local skillGui = nil
    local cdGui = nil
    
    if toolName then
        local waitTime = tick()
        while not skillGui and tick() - waitTime < 0.2 do
            task.wait()
            local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
            if mainGui and mainGui:FindFirstChild("Skills") then
                skillGui = mainGui.Skills:FindFirstChild(toolName)
            end
        end
        
        if skillGui and skillGui:FindFirstChild(skillData.Button) then
            cdGui = skillGui[skillData.Button]:FindFirstChild("Cooldown")
        end
    end

    if cdGui and cdGui.AbsoluteSize.X > 0 then
        pcall(function()
            Library:SendNotification("System", "Skill " .. skillData.Button .. " of " .. (toolName or "Weapon") .. " is on cooldown")
        end)
        return false
    end
    
    ActiveAimMode = skillData.AimMode or "Body"
    ActiveVectorOffset = skillData.VectorOffset or Vector3.new(0,0,0)
    
    AimUpdaterConnection = RunService.RenderStepped:Connect(function()
        if not IsMacroRunning then return end
        local targetPlayer, targetPart = GetTarget()
        
        if targetPlayer and targetPart then
            CurrentTarget = targetPlayer
            local aimPos
            
            if getgenv().MacroConfig.PredictionSettings.PredictionAimbot then
                aimPos = getPredictedPosition(targetPlayer) or targetPart.Position
            else
                aimPos = targetPart.Position
            end
            
            if aimPos then
                if ActiveAimMode == "Vector" and ActiveVectorOffset then
                    aimPos = aimPos + ActiveVectorOffset
                end
                
                local char = LocalPlayer.Character
                local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
                
                if myRoot then
                    getgenv().MacroAimPos = CFrame.new(myRoot.Position, aimPos)
                end
            end
        elseif targetPart and typeof(targetPart) == "Vector3" then
            local aimPos = targetPart
            if ActiveAimMode == "Vector" and ActiveVectorOffset then
                aimPos = aimPos + ActiveVectorOffset
            end
            
            local char = LocalPlayer.Character
            local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
            
            if myRoot then
                getgenv().MacroAimPos = CFrame.new(myRoot.Position, aimPos)
            end
        else
            getgenv().MacroAimPos = nil
        end
    end)

    local spamCount = skillData.SpamCount or 1
    local spamInterval = skillData.SpamInterval or 0
    local holdTime = skillData.HoldTime or 0
    local delayTime = skillData.DelayTime or 0
    
    local successKey, keyEnum = pcall(function() return Enum.KeyCode[skillData.Button] end)
    if successKey then
        for i = 1, spamCount do
            if not IsMacroRunning then break end
            if cdGui and cdGui.AbsoluteSize.X > 0 then break end
            
            if holdTime > 0 then
                VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                task.wait(holdTime)
                VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
            else
                VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
            end
            
            if spamInterval > 0 and i < spamCount then
                task.wait(spamInterval)
            end
        end
    end
    
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
    
    if IsMacroRunning and delayTime > 0 then
        task.wait(delayTime)
    end
    
    return true
end
---------

local function EquipConfiguredItem(equipInfo)
    if not equipInfo.Enabled or not equipInfo.ItemName or not IsMacroRunning then return nil end
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
                        if tipLower == "blox fruit" or string.find(nameLower, "fruit") then return item end
                    elseif searchType == "melee" then
                        if tipLower == "melee" or string.find(nameLower, "combat") or string.find(nameLower, "style") or item:FindFirstChild("MeleeScript") then return item end
                    elseif searchType == "sword" then
                        if tipLower == "sword" or item:FindFirstChild("SwordScript") then return item end
                    elseif searchType == "gun" then
                        if tipLower == "gun" or item:FindFirstChild("GunScript") then return item end
                    else
                        if string.find(nameLower, searchType) then return item end
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
            return targetTool.Name
        end
    end
    return nil
end

local function RunMacroSequence()
    local config = getgenv().MacroConfig
    repeat
        for i, block in ipairs(config.ComboBlocks) do
            if not IsMacroRunning then break end
            if not block.Enabled then continue end
            
            local targetPlayer, targetPart = GetTarget()
            CurrentTarget = targetPlayer
            
            local toolName = EquipConfiguredItem(block.EquipItem)
            
            local beforeResult = ProcessActionList(block.BeforeSkill)
            if not beforeResult then continue end
            
            local skillResult = ProcessSkillAction(block.SkillAction, toolName)
            if not skillResult then continue end
            
            local afterResult = ProcessActionList(block.AfterSkill)
            if not afterResult then continue end
            
            if block.BlockDelayAfter and block.BlockDelayAfter > 0 and IsMacroRunning then
                task.wait(block.BlockDelayAfter)
            end
        end
    until not config.Settings.LoopCombo or not IsMacroRunning
    
    IsMacroRunning = false
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
end

---------
getgenv().ToggleMacroState = function()
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
    end
end
---------
---------
local boundSpamKeys = {}
getgenv().MacroIsVIM = getgenv().MacroIsVIM or {}

local function UpdateSpamBinds()
    for _, keyStr in ipairs(boundSpamKeys) do
        ContextActionService:UnbindAction("MacroSpam_" .. keyStr)
    end
    table.clear(boundSpamKeys)

    if not getgenv().MacroConfig.Settings.SpamMode then return end

    for _, keyStr in ipairs(getgenv().MacroConfig.Settings.SpamKeys) do
        if keyStr == "Click" then continue end 
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyStr] end)
        if success then
            ContextActionService:BindActionAtPriority("MacroSpam_" .. keyStr, function(actionName, state, inputObj)
                if getgenv().MacroIsVIM[keyStr] then return Enum.ContextActionResult.Pass end

                if state == Enum.UserInputState.Begin then
                    if getgenv().IsSpamming[keyStr] then return Enum.ContextActionResult.Sink end
                    getgenv().IsSpamming[keyStr] = true
                    task.spawn(function()
                        while getgenv().IsSpamming[keyStr] do
                            getgenv().MacroIsVIM[keyStr] = true
                            VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                            
                            task.wait(0.02)
                            
                            if not getgenv().IsSpamming[keyStr] then
                                VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
                                getgenv().MacroIsVIM[keyStr] = false
                                break
                            end
                            
                            VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
                            getgenv().MacroIsVIM[keyStr] = false
                            
                            local delayTime = getgenv().MacroConfig.Settings.SpamDelay or 0.05
                            if delayTime <= 0 then
                                RunService.RenderStepped:Wait()
                            else
                                local t = 0
                                while t < delayTime do
                                    if not getgenv().IsSpamming[keyStr] then break end
                                    t = t + task.wait()
                                end
                            end
                        end
                    end)
                elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                    getgenv().IsSpamming[keyStr] = false
                end
                return Enum.ContextActionResult.Sink 
            end, false, 99999, keyEnum)
            table.insert(boundSpamKeys, keyStr)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local config = getgenv().MacroConfig
    
    local successToggle, toggleKey = pcall(function() return Enum.KeyCode[config.Settings.ActivationKey] end)
    if successToggle and input.KeyCode == toggleKey then
        if typeof(getgenv().ToggleMacroState) == "function" then
            getgenv().ToggleMacroState()
        end
    end

    if config.Settings.SpamMode and table.find(config.Settings.SpamKeys, "Click") then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if getgenv().MacroIsVIM["Click"] then return end
            if getgenv().IsSpamming["Click"] then return end
            getgenv().IsSpamming["Click"] = true
            task.spawn(function()
                while getgenv().IsSpamming["Click"] do
                    getgenv().MacroIsVIM["Click"] = true
                    SimulateClick()
                    getgenv().MacroIsVIM["Click"] = false
                    
                    local delayTime = getgenv().MacroConfig.Settings.SpamDelay or 0.05
                    if delayTime <= 0 then
                        RunService.RenderStepped:Wait()
                    else
                        local t = 0
                        while t < delayTime do
                            if not getgenv().IsSpamming["Click"] then break end
                            t = t + task.wait()
                        end
                    end
                end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    local config = getgenv().MacroConfig
    if config.Settings.SpamMode and table.find(config.Settings.SpamKeys, "Click") then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if getgenv().MacroIsVIM["Click"] then return end
            getgenv().IsSpamming["Click"] = false
        end
    end
end)
---------
---------
---------
local function check_in_cd()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end
    local Main = PlayerGui:FindFirstChild("Main")
    if not Main then return false end
    local BottomHUDList = Main:FindFirstChild("BottomHUDList")
    if not BottomHUDList then return false end
    local UniversalContextButtons = BottomHUDList:FindFirstChild("UniversalContextButtons")
    if not UniversalContextButtons then return false end
    local BoundActionSoru = UniversalContextButtons:FindFirstChild("BoundActionSoru")
    if not BoundActionSoru then return false end
    local CooldownLabel = BoundActionSoru:FindFirstChild("CooldownLabel")
    if not CooldownLabel then return false end

    local cdText = CooldownLabel.Text
    local cdValue = tonumber(cdText)
    
    if cdValue and cdValue > 0 then
        return true
    end
    return false
end

local wasSoruInCD = false
task.spawn(function()
    while task.wait() do
        local config = getgenv().MacroConfig
        if config and config.Settings.Enabled then
            local isCD = check_in_cd()
            
            if isCD and not wasSoruInCD then
                if config.Settings.AutoSoruSkill and #config.Settings.SoruSkills > 0 then
                    task.spawn(function()
                        for _, skillKeyStr in ipairs(config.Settings.SoruSkills) do
                            local successK, kEnum = pcall(function() return Enum.KeyCode[skillKeyStr] end)
                            if successK then
                                VirtualInputManager:SendKeyEvent(true, kEnum, false, game)
                                task.wait(0.01)
                                VirtualInputManager:SendKeyEvent(false, kEnum, false, game)
                            end
                            task.wait(config.Settings.SoruSkillDelay)
                        end
                    end)
                end
                
                if config.Settings.AutoSoruCombo and not IsMacroRunning then
                    task.spawn(function()
                        if config.Settings.SoruComboDelay > 0 then
                            task.wait(config.Settings.SoruComboDelay)
                        end
                        IsMacroRunning = true
                        RunMacroSequence()
                    end)
                end
            end
            
            wasSoruInCD = isCD
        end
    end
end)

---------
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

RunService.RenderStepped:Connect(function()
    if not getgenv().MacroConfig.Settings.Enabled then 
        ESPhighlight.Adornee = nil
        TracerLine.Visible = false
        return 
    end

    local targetPlayer, targetPart = GetTarget()
    CurrentTarget = targetPlayer
    local char = LocalPlayer.Character
    local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))

    if CurrentTarget and CurrentTarget.Character and myRoot then
        local tarRoot = CurrentTarget.Character:FindFirstChild("HumanoidRootPart") or CurrentTarget.Character:FindFirstChild("UpperTorso")
        
        if tarRoot then
            local dist = (myRoot.Position - tarRoot.Position).Magnitude
            ESPhighlight.Adornee = CurrentTarget.Character
            TracerLine.Adornee = myRoot
            TracerLine.Length = dist
            TracerLine.CFrame = myRoot.CFrame:ToObjectSpace(CFrame.lookAt(myRoot.Position, tarRoot.Position))
            TracerLine.Visible = true
        else
            ESPhighlight.Adornee = nil
            TracerLine.Visible = false
        end
    else
        ESPhighlight.Adornee = nil
        TracerLine.Visible = false
    end
end)

---------
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
setreadonly(MT, false)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if Method == "FireServer" and getgenv().MacroConfig.Settings.Enabled and getgenv().MacroAimPos then
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

---------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library.lua"))()
local Window = Library:CreateWindow({Title = "meyy Premium Hub"})

local SettingsTab = Window:CreateTab("Settings", true, "")
local Combo1_6 = Window:CreateTab("Combo 1-6", false, "")
local Combo7_12 = Window:CreateTab("Combo 7-12", false, "")

---------
SettingsTab:CreatePageTitle("Global Configuration")

SettingsTab:CreateSwitch("Master Switch", getgenv().MacroConfig.Settings.Enabled, "", function(state)
    getgenv().MacroConfig.Settings.Enabled = state
end)

SettingsTab:CreateButton("Toggle Combo Macro", "", function()
    if typeof(getgenv().ToggleMacroState) == "function" then
        getgenv().ToggleMacroState()
    end
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

SettingsTab:CreatePageTitle("Spam Mode Settings")

SettingsTab:CreateSwitch("Enable Spam Mode", getgenv().MacroConfig.Settings.SpamMode, "", function(state)
    getgenv().MacroConfig.Settings.SpamMode = state
    UpdateSpamBinds()
end)

SettingsTab:CreateMultiDropdown("Spam Keys", getgenv().MacroConfig.Settings.SpamKeys, {"R", "V", "C", "X", "Z", "F", "T", "Click"}, "", function(selected)
    getgenv().MacroConfig.Settings.SpamKeys = selected
    UpdateSpamBinds()
end)

SettingsTab:CreateSlider("Spam Delay (ms)", 0, 100, getgenv().MacroConfig.Settings.SpamDelay * 1000, "", function(val)
    getgenv().MacroConfig.Settings.SpamDelay = val / 1000
end)

SettingsTab:CreatePageTitle("Auto Actions After Soru")

SettingsTab:CreateSwitch("Use Skills After Soru", getgenv().MacroConfig.Settings.AutoSoruSkill, "", function(state)
    getgenv().MacroConfig.Settings.AutoSoruSkill = state
end)

SettingsTab:CreateMultiDropdown("Select Soru Skills", getgenv().MacroConfig.Settings.SoruSkills, {"Z", "X", "C", "V", "F", "T", "R"}, "", function(selected)
    getgenv().MacroConfig.Settings.SoruSkills = selected
end)

SettingsTab:CreateSlider("Skill Switch Delay (ms)", 0, 300, getgenv().MacroConfig.Settings.SoruSkillDelay * 1000, "", function(val)
    getgenv().MacroConfig.Settings.SoruSkillDelay = val / 1000
end)

SettingsTab:CreateSwitch("Use Main Combo After Soru", getgenv().MacroConfig.Settings.AutoSoruCombo, "", function(state)
    getgenv().MacroConfig.Settings.AutoSoruCombo = state
end)

SettingsTab:CreateSlider("Combo Start Delay (ms)", 0, 300, getgenv().MacroConfig.Settings.SoruComboDelay * 1000, "", function(val)
    getgenv().MacroConfig.Settings.SoruComboDelay = val / 1000
end)

SettingsTab:CreatePageTitle("Prediction Engine")

SettingsTab:CreateSwitch("Prediction Aimbot", getgenv().MacroConfig.PredictionSettings.PredictionAimbot, "", function(state)
    getgenv().MacroConfig.PredictionSettings.PredictionAimbot = state
end)

SettingsTab:CreateSwitch("Prediction Soru", getgenv().MacroConfig.PredictionSettings.PredictionSoru, "", function(state)
    getgenv().MacroConfig.PredictionSettings.PredictionSoru = state
end)

SettingsTab:CreateSlider("Max Target Distance", 100, 2000, getgenv().MacroConfig.PredictionSettings.MaxDistance, "", function(val)
    getgenv().MacroConfig.PredictionSettings.MaxDistance = val
end)

---------
local Keys = {"Z", "X", "C", "V", "F", "E", "Q"}
local Weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}

for i = 1, 12 do
    local currentTab = i <= 6 and Combo1_6 or Combo7_12
    currentTab:CreatePageTitle("Combo Block " .. i)
    currentTab:CreateSwitch("Enable Block", getgenv().MacroConfig.ComboBlocks[i].Enabled, "", function(state)
        getgenv().MacroConfig.ComboBlocks[i].Enabled = state
    end)
    currentTab:CreateSwitch("Enable Equip", getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled, "", function(state)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled = state
    end)
    currentTab:CreateDropdown("Select Weapon", getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName, Weapons, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName = val
    end)
    currentTab:CreatePageSubTitle("Before Skill Settings")
    currentTab:CreateMultiDropdown("Before Skill Actions", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    currentTab:CreateSlider("Jump Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamCount = val
    end)
    currentTab:CreateSlider("Jump Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Click Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamCount = val
    end)
    currentTab:CreateSlider("Click Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamInterval = val / 1000
    end)
    currentTab:CreatePageSubTitle("Main Skill Action")
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
    currentTab:CreatePageSubTitle("After Skill Settings")
    currentTab:CreateMultiDropdown("After Skill Actions", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    currentTab:CreateSlider("Jump Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamCount = val
    end)
    currentTab:CreateSlider("Jump Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Click Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamCount = val
    end)
    currentTab:CreateSlider("Click Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Block Cooldown (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter = val / 1000
    end)
end
