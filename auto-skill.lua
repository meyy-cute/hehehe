local lp = game:GetService("Players").LocalPlayer
local vim1 = game:GetService("VirtualInputManager")

---------


---------

local function down(use, waitTime)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            vim1:SendKeyEvent(true, use, false, lp.Character.HumanoidRootPart)
            task.wait(waitTime or 0.1)
            vim1:SendKeyEvent(false, use, false, lp.Character.HumanoidRootPart)
        end
    end)
end

---------

local function Useskills(weapon, skill)
    if weapon == "nil" and skill == "Y" then
        vim1:SendKeyEvent(true, "Y", false, game)
        vim1:SendKeyEvent(false, "Y", false, game)
    end
end

---------

local function equip(typeCheck)
    local tooltipToFind = typeCheck
    if typeCheck == "Fruit" then tooltipToFind = "Blox Fruit" end
    
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltipToFind then
            local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                humanoid:EquipTool(item)
                return item.Name
            end
        end
    end
    for _, item in pairs(lp.Character:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltipToFind then
            return item.Name
        end
    end
    return nil
end

---------

---------
task.spawn(function()
    while task.wait() do
        pcall(function()
            local targetToSet = nil
            
            if getgenv().CurrentTarget then
                targetToSet = getgenv().CurrentTarget
            else
                local shortestDistance = 40
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            local distance = (player.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= shortestDistance then
                                targetToSet = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
            
            getgenv().targ = targetToSet
        end)
    end
end)
---------
---------
task.spawn(function()
    while task.wait() do 
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                
                local targetPos = getgenv().targ.Character.HumanoidRootPart.Position
                if getgenv().Config and getgenv().Config["SpinLock"] == "WhiteGlow" and getgenv().LatestPredictedPos then
                    targetPos = getgenv().LatestPredictedPos
                end
                
                if (targetPos - lp.Character.HumanoidRootPart.Position).Magnitude < 50 then
                    
                    if getgenv().Config and getgenv().Config["Auto Enable V3"] then
                        if getgenv().Config["Custom Health"] and lp.Character:FindFirstChild("Humanoid") and
                            lp.Character.Humanoid.Health <= getgenv().Config["Health"] then
                            down("T", 0.1)
                        end
                    end
                    
                    if getgenv().Config and getgenv().Config["Auto Enable V4"] then
                        if lp.Character:FindFirstChild("RaceEnergy") and lp.Character.RaceEnergy.Value == 1 then
                            Useskills("nil", "Y")
                        end
                    end
                    
                end
            end
        end)
    end
end)
---------
---------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and 
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                
                local targetPos = getgenv().targ.Character.HumanoidRootPart.Position
                if getgenv().Config and getgenv().Config["SpinLock"] == "WhiteGlow" and getgenv().LatestPredictedPos then
                    targetPos = getgenv().LatestPredictedPos
                end
                
                if (targetPos - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 40 then 
                    
                    local queue = {}
                    local hasSkillEnabled = false
                    if getgenv().Config then
                        for typeName, typeData in pairs(getgenv().Config) do
                            if type(typeData) == "table" and typeData.Enable then
                                for skillKey, skillData in pairs(typeData) do
                                    if type(skillData) == "table" and skillData.Enable and skillData.Priority then
                                        hasSkillEnabled = true
                                        table.insert(queue, {
                                            Type = typeName,
                                            Key = skillKey,
                                            Data = skillData
                                        })
                                    end
                                end
                            end
                        end
                    end
                    
                    table.sort(queue, function(a, b) return a.Data.Priority < b.Data.Priority end)
                    
                    local allOnCooldown = true
                    
                    for _, item in ipairs(queue) do
                        local toolName = equip(item.Type)
                        if toolName then
                            local skillGui = lp.PlayerGui.Main.Skills:FindFirstChild(toolName)
                            if skillGui and skillGui:FindFirstChild(item.Key) then
                                local cdGui = skillGui[item.Key]:FindFirstChild("Cooldown")
                                
                                if cdGui and cdGui.AbsoluteSize.X <= 0 then
                                    allOnCooldown = false
                                    for i = 1, (item.Data.Count or 1) do
                                        if cdGui.AbsoluteSize.X > 0 then
                                            break
                                        end
                                        down(item.Key, item.Data.HoldTime)
                                        task.wait(item.Data.CountInterval or 0.05)
                                    end
                                end
                            end
                        end
                    end
                    
                    if hasSkillEnabled and allOnCooldown then
                        getgenv().SkillsOnCooldown = true
                    else
                        getgenv().SkillsOnCooldown = false
                    end
                else
                    getgenv().SkillsOnCooldown = false
                end
            else
                getgenv().SkillsOnCooldown = false
            end
        end)
    end
end)
---------

---------
