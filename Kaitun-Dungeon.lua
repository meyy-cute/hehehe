
loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/no-gravity2.txt"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/AFK/refs/heads/main/AFK"))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local plr = Players.LocalPlayer

local function Useskills(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, key, false, game)
end
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            replicated.Remotes.CommE:FireServer("ActivateAbility")
        end)
        task.wait(30)
    end

    while task.wait(0.2) do
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("RaceEnergy") then
                    if char.RaceEnergy.Value >= 1 then 
                        Useskills("Y")
                    end
                end
            end)
    end

    while task.wait(1) do
        pcall(function()
            if plr.Character and not plr.Character:FindFirstChild("HasBuso") then
                replicated.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
end)

---------

if Workspace.Map:FindFirstChild("Dungeon") then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/m1-attack.lua"))()

    ---------
    
    local presetMap = {
        ["Sword"] = {"HYPER!", "Sword", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Fruit", "Fruit M1 Speed"},
        ["Melee"] = {"HYPER!", "Melee", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Sword", "Fruit", "Fruit M1 Speed"},
        ["Blox Fruit"] = {"Fruit M1 Speed", "Fruit", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Sword", "HYPER!"},
    }

    local function getMyPriorityList()
        local myName = plr.Name
        local myRole = "Blox Fruit"
        
        if getgenv().Config then
            for _, group in pairs(getgenv().Config) do
                if type(group) == "table" and group.Users then
                    for _, user in ipairs(group.Users) do
                        if user == myName then
                            myRole = group.ToolTip or "Blox Fruit"
                            break
                        end
                    end
                end
            end
        end
        return presetMap[myRole] or presetMap["Blox Fruit"]
    end

    local function simulateClick(obj)
        local x = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
        local y = obj.AbsolutePosition.Y + (obj.AbsoluteSize.Y / 2)
        
        if x > 10 and y > 10 then
            VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.1)
            VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end
    end

    local function autoPickBuff()
        local pGui = plr:WaitForChild("PlayerGui")
        local currentPriority = getMyPriorityList()
        
        for _, targetName in ipairs(currentPriority) do
            local targetLower = targetName:lower()
            
            for _, gui in ipairs(pGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Enabled then
                    local frame1 = gui:FindFirstChild("1")
                    if frame1 and frame1.Visible then
                        local foundMatch = false
                        for _, child in pairs(frame1:GetDescendants()) do
                            if child:IsA("TextLabel") and child.Visible then
                                if child.Text:lower():find(targetLower) then
                                    foundMatch = true
                                    break
                                end
                            end
                        end
                        
                        if foundMatch then
                            simulateClick(frame1)
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    task.spawn(function()
        while task.wait(0.5) do
            local success = autoPickBuff()
            if success then
                task.wait(0.5) 
            end
        end
    end)

    ---------

    local R = RunService
    local P = Players
    local TS = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local p = P.LocalPlayer

    workspace.Gravity = 0
    local EF = "Enemies"
    local IE = { 
        ["Blank Buddy"] = true, 
        ["PropHitboxPlaceholder"] = true,
        ["Raider"] = true
    }
    local PROP_NAME = "PropHitboxPlaceholder" 

    local function startAutoEquip()
        local player = game.Players.LocalPlayer
        
        spawn(function()
            local lastWeapon = _G.SelectWeapon
            
            while task.wait() do
                local character = player.Character
                local backpack = player.Backpack
                local currentSelection = _G.SelectWeapon
                
                if currentSelection ~= "" and currentSelection ~= nil then
                    if character and character:FindFirstChild("Humanoid") then
                        local toolInHand = character:FindFirstChildOfClass("Tool")
                        
                        if not toolInHand or toolInHand.ToolTip ~= currentSelection then
                            task.wait(4)
                            if _G.SelectWeapon == currentSelection then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == currentSelection then
                                        character.Humanoid:EquipTool(tool)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    lastWeapon = currentSelection
                else
                    if character then
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool and tool.ToolTip == lastWeapon then
                            tool.Parent = player.Backpack
                        end
                    end
                end
            end
        end)
    end

    startAutoEquip()

    local hasUnequippedForTransform = false 

    local function getCurrentToolTip()
        if not getgenv().Config then return nil end
        local myName = string.lower(p.Name)
        local myDisplayName = string.lower(p.DisplayName)
        for _, data in pairs(getgenv().Config) do
            if type(data) == "table" and data.Users then
                for _, user in pairs(data.Users) do
                    local configUser = string.lower(tostring(user))
                    if configUser == myName or configUser == myDisplayName then 
                        return data.ToolTip 
                    end
                end
            end
        end
        return nil
    end

    local function equipToolByRole()
        task.spawn(function()
            while task.wait(0.3) do 
                local character = p.Character
                if not character then continue end
                local hum = character:FindFirstChildOfClass("Humanoid")
                if not hum then continue end

                if _G.IsTransforming then
                    if not hasUnequippedForTransform then
                        local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                        if currentlyEquipped then
                            hum:UnequipTools() 
                        end
                        hasUnequippedForTransform = true 
                    end
                    continue 
                end
                hasUnequippedForTransform = false 

                if getgenv().AutoEquip == true then
                    local myToolTip = getCurrentToolTip()
                    local backpack = p:FindFirstChild("Backpack")
                    
                    if myToolTip and backpack then
                        local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                        
                        if not (currentlyEquipped and currentlyEquipped.ToolTip == myToolTip) then
                            for _, item in pairs(backpack:GetChildren()) do
                                if item:IsA("Tool") and item.ToolTip == myToolTip then
                                    hum:EquipTool(item) 
                                    break
                                end
                            end
                        end
                    end
                elseif getgenv().AutoEquip == false then
                    local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                    if currentlyEquipped then
                        hum:UnequipTools()
                    end
                end
            end
        end)
    end

    equipToolByRole()

    ---------

    local Themes = {
        BgColor = Color3.fromRGB(0, 0, 0),
        BgTransparency = 0.4,
        StrokeColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextStrokeColor = Color3.fromRGB(80, 80, 80),
        CreditColor = Color3.fromRGB(120, 120, 120)
    }

    local UI_Elements = {}

    local g = Instance.new("ScreenGui")
    g.Name = "Naa_UI_Cloud_Theme_Clean_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = p:WaitForChild("PlayerGui") end
    getgenv().kc = g

    local m = Instance.new("Frame", g)
    m.Name = "Main"
    m.BackgroundColor3 = Themes.BgColor
    m.BackgroundTransparency = Themes.BgTransparency
    m.Position = UDim2.new(0.5, 0, 0, -150)
    m.Size = UDim2.new(0, 320, 0, 100)
    m.AnchorPoint = Vector2.new(0.5, 0)
    table.insert(UI_Elements, m)

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.5
    u.Color = Themes.StrokeColor
    table.insert(UI_Elements, u)

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
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = 15
        label.TextColor3 = Themes.TextColor
        table.insert(UI_Elements, label)
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 0.5
        txtStroke.Color = Themes.TextStrokeColor
        table.insert(UI_Elements, txtStroke)
        
        local txtGradient = Instance.new("UIGradient", label)
        table.insert(statusGradients, txtGradient)
        return label, txtGradient
    end

    _G.StatusItemLabel, _G.TopInfoGradient = CreateStatusLabel("TopInfo", 10, "meyy Hub")
    _G.StatusFarmLabel, _G.FarmGradient = CreateStatusLabel("StatusFarm", 35, "Status Farm: N/A")
    _G.StatusMobLabel, _G.MobGradient = CreateStatusLabel("StatusMob", 60, "Farm Mob: N/A")

    local creditLabel = Instance.new("TextLabel", m)
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(0, 50, 0, 15)
    creditLabel.Position = UDim2.new(1, -10, 1, -5)
    creditLabel.AnchorPoint = Vector2.new(1, 1)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.Text = "by naa-banv"
    creditLabel.TextSize = 10
    creditLabel.TextColor3 = Themes.CreditColor
    creditLabel.TextXAlignment = Enum.TextXAlignment.Right
    table.insert(UI_Elements, creditLabel)

    local rRot = 0
    task.spawn(function()
        while true do
            local delta = R.RenderStepped:Wait()
            rRot = (rRot + 1.5) % 360
            e.Rotation = rRot
            local c1, c2 = Color3.fromRGB(180, 220, 255), Color3.new(1, 1, 1)
            local colorSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1), 
                ColorSequenceKeypoint.new(0.5, c2), 
                ColorSequenceKeypoint.new(1, c1)
            })
            e.Color = colorSeq
            for _, grad in ipairs(statusGradients) do
                grad.Rotation = rRot
                grad.Color = colorSeq
            end
            bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
        end
    end)

    TS:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    ---------

    local function gH()
        local c = p.Character or p.CharacterAdded:Wait()
        return c:WaitForChild("HumanoidRootPart")
    end

    local function isAlive()
        local c = p.Character
        local u = c and c:FindFirstChildOfClass("Humanoid")
        return u and u.Health > 0
    end

    local function fE()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return nil end
        local h = gH()
        local n = nil
        local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local ePart = r:FindFirstChild("ExitTeleporter")
            if ePart then 
                local t = ePart:FindFirstChild("Root")
                if t and t:IsA("BasePart") then 
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; n = t end 
                end 
            end 
        end
        return n 
    end

    local function getCurrentRoomNumber()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return 0 end
        local h = gH(); if not h then return 0 end
        local cR = 0; local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local n = tonumber(r.Name)
            if n then
                local ePart = r:FindFirstChild("ExitTeleporter")
                local t = ePart and ePart:FindFirstChild("Root")
                if t then
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; cR = n end
                end
            end
        end
        return cR
    end

    local function PromoteHub()
        pcall(function()
            local msgs = {
                "meyy hub - top tier script for smooth raids",
                "running fast and clean with meyy hub",
                "meyy hub - best performance for you",
                "clearing rooms instantly thanks to meyy hub"
            }
            local msg = msgs[math.random(1, #msgs)]
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end)
    end

    local function GetDynamicTarget(rNum)
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return nil end

        if rNum == 10 or rNum == 15 or rNum == 20 then
            for _, v in pairs(enemies:GetChildren()) do
                if v.Name == PROP_NAME then
                    local hum = v:FindFirstChildOfClass("Humanoid")
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp then
                        return v 
                    end
                end
            end
        end

        local highestHealth = -1
        local bestTarget = nil

        for _, v in pairs(enemies:GetChildren()) do
            if not IE[v.Name] and v.Name ~= PROP_NAME then
                local hum = v:FindFirstChildOfClass("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    if hum.MaxHealth > highestHealth then
                        highestHealth = hum.MaxHealth
                        bestTarget = v
                    end
                end
            end
        end

        return bestTarget
    end

    ---------

    local function CleanAndDisable(v, humanoid)
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        
        local animator = humanoid:FindFirstChild("Animator")
        if animator then animator:Destroy() end
        
        for _, obj in ipairs(v:GetDescendants()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") or obj:IsA("BodyThrust") or obj:IsA("AlignPosition") or obj:IsA("LinearVelocity") or obj:IsA("VectorForce") then
                obj:Destroy()
            elseif obj:IsA("BaseScript") then
                pcall(function() obj.Disabled = true end)
            end
        end
    end

    local function GetMobClusters(plrRoot)
        local validEnemies = {}
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        
        if enemiesFolder and plrRoot then
            for _, v in ipairs(enemiesFolder:GetChildren()) do
                if not IE[v.Name] and v.Name ~= PROP_NAME then
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    local hum = v:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 and (hrp.Position - plrRoot.Position).Magnitude <= 350 then
                        table.insert(validEnemies, v)
                    end
                end
            end
        end
        
        local clusters = {}
        while #validEnemies > 0 do
            local cluster = {table.remove(validEnemies, 1)}
            for i = 1, 1 do
                if #validEnemies == 0 then break end
                local closestIdx, minDistance = 1, math.huge
                local firstHrp = cluster[1]:FindFirstChild("HumanoidRootPart")
                
                for j, otherMob in ipairs(validEnemies) do
                    local otherHrp = otherMob:FindFirstChild("HumanoidRootPart")
                    local dist = (firstHrp and otherHrp) and (firstHrp.Position - otherHrp.Position).Magnitude or math.huge
                    if dist < minDistance then
                        minDistance, closestIdx = dist, j
                    end
                end
                table.insert(cluster, table.remove(validEnemies, closestIdx))
            end
            table.insert(clusters, cluster)
        end
        return clusters
    end

    local function BringMob(enable)
        if not enable then return end
        local plrChar = plr.Character
        local plrRoot = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
        if not plrRoot then return end

        local clusters = GetMobClusters(plrRoot)
        for _, cluster in ipairs(clusters) do
            local centerPos, validCount = Vector3.zero, 0
            for _, mob in ipairs(cluster) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hrp then
                    centerPos, validCount = centerPos + hrp.Position, validCount + 1
                end
            end
            
            if validCount > 0 then
                local TargetCFrame = CFrame.new(centerPos / validCount)
                for _, v in ipairs(cluster) do
                    local humanoid = v:FindFirstChild("Humanoid")
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    
                    if humanoid and hrp and humanoid.Health > 0 and (hrp.Position - plrRoot.Position).Magnitude <= 350 then
                        local Distance = (hrp.Position - TargetCFrame.Position).Magnitude
                        if Distance > 3 and Distance <= 280 then
                            hrp.Size = Vector3.new(50, 50, 50)
                            hrp.CanCollide = false
                            
                            CleanAndDisable(v, humanoid)
                            local info = TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear)
                            game:GetService("TweenService"):Create(hrp, info, {CFrame = TargetCFrame}):Play()
                            pcall(function() sethiddenproperty(plr, "SimulationRadius", math.huge) end)
                        end
                    end
                end
            end
        end
    end

    task.spawn(function()
        while true do
            BringMob(true)
            task.wait(0.5)
        end
    end)

    ---------

    task.spawn(function()
        local lastFarmText = ""
        local lastMobText = ""
        local global_lastRoomCheck = 0
        _G.PromotedRoom = {}

        local function updateUI(farmMsg, mobMsg)
            task.spawn(function()
                local farmFullText = "Status Farm: " .. tostring(farmMsg)
                local mobFullText = "Farm Mob: " .. tostring(mobMsg)
                
                if farmFullText ~= lastFarmText then
                    lastFarmText = farmFullText
                    if _G.StatusFarmLabel then _G.StatusFarmLabel.Text = farmFullText end
                end
                if mobFullText ~= lastMobText then
                    lastMobText = mobFullText
                    if _G.StatusMobLabel then _G.StatusMobLabel.Text = mobFullText end
                end
            end)
        end

        local function getMyBuddhaConfig()
            if not getgenv().Config then return false end
            local myName = string.lower(p.Name)
            local myDisplayName = string.lower(p.DisplayName)
            
            for _, data in pairs(getgenv().Config) do
                if type(data) == "table" and data.Users then
                    for _, user in pairs(data.Users) do
                        local configUser = string.lower(tostring(user))
                        if configUser == myName or configUser == myDisplayName then 
                            return data.ModeBuddha 
                        end
                    end
                end
            end
            return false
        end

        while true do 
            task.wait() 
            local currentRoom = getCurrentRoomNumber()
            
            if currentRoom > 0 and currentRoom ~= global_lastRoomCheck then
                global_lastRoomCheck = currentRoom
            end
        
            if currentRoom >= getgenv().Config["Room Settings"].MaxRoom then
                updateUI("Room " .. tostring(getgenv().Config["Room Settings"].MaxRoom) .. " Reached", getgenv().Config["Room Settings"].StatusMessage)
                task.wait(2)
                continue
            end

            local modebuddha = getMyBuddhaConfig()
            if modebuddha then
                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not _G.OriginalSize then _G.OriginalSize = hrp.Size end
                    if hrp.Size.Magnitude <= _G.OriginalSize.Magnitude * 1.2 then
                        if not _G.IsTransforming then
                            _G.IsTransforming = true
                            getgenv().AutoEquip = false 
                            
                            task.spawn(function()
                                local vi = game:GetService("VirtualInputManager")
                                task.wait(0.5)
                                vi:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                                task.wait(0.6)
                                vi:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                task.wait(2) 
                                getgenv().AutoEquip = true 
                                _G.IsTransforming = false
                            end)
                        end
                        updateUI("Activating Buddha", "Waiting...")
                        task.wait(0.1)
                        continue 
                    else
                        local mult = 3
                        local targetMag = _G.OriginalSize.Magnitude * 3 * mult * 0.9
                        if hrp.Size.Magnitude < targetMag then
                            for _, part in pairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Size = part.Size * mult
                                    for _, att in pairs(part:GetChildren()) do 
                                        if att:IsA("Attachment") then att.Position = att.Position * mult end 
                                    end
                                    local mesh = part:FindFirstChildOfClass("SpecialMesh")
                                    if mesh then mesh.Scale = mesh.Scale * mult end
                                elseif part:IsA("Motor6D") then
                                    local c0, c1 = part.C0, part.C1
                                    part.C0 = CFrame.new(c0.Position * mult) * (c0 - c0.Position)
                                    part.C1 = CFrame.new(c1.Position * mult) * (c1 - c1.Position)
                                end
                            end
                        end
                    end
                end
            end

            local myRole = getCurrentToolTip()
            _G.SelectWeapon = myRole

            local target = GetDynamicTarget(currentRoom)

            if target then
                updateUI("Room " .. tostring(currentRoom), "Combat Active")
                
                while target and isAlive() do
                    local success, _ = pcall(function()
                        local hum = target:FindFirstChildOfClass("Humanoid")
                        local hrp = target:FindFirstChild("HumanoidRootPart")
                        
                        if not hum or hum.Health <= 0 or not hrp then
                            target = nil
                            return
                        end
                        
                        local mHRP = gH()
                        if mHRP then
                            local heightOffset = modebuddha and 75 or (myRole == "Blox Fruit" and 5 or 45)
                            local targetPos = hrp.Position + Vector3.new(0, heightOffset, 0)
                            
                            mHRP.CFrame = mHRP.CFrame:Lerp(CFrame.new(targetPos), 0.4)
                        end
                    end)
                    
                    if not success then target = nil end
                    task.wait()
                    
                    local newTarget = GetDynamicTarget(currentRoom)
                    if newTarget and newTarget ~= target then
                        target = newTarget
                    end
                end
                
                if currentRoom == 15 or currentRoom == 20 or currentRoom == 100 then
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("DungeonShared"):WaitForChild("ReturnToHub"):FireServer()
                    end)
                end
            else
                local exitRoot = fE()
                if exitRoot then
                    updateUI("Room Cleared", "Rushing Portal")
                    
                    if not _G.PromotedRoom[currentRoom] then
                        PromoteHub()
                        _G.PromotedRoom[currentRoom] = true
                    end
                    
                    local tStart = tick()
                    while exitRoot and exitRoot.Parent and isAlive() do
                        local success = pcall(function()
                            local mHRP = gH()
                            if mHRP then
                                local targetPos = exitRoot.Position + Vector3.new(0, 3, 0)
                                mHRP.CFrame = mHRP.CFrame:Lerp(CFrame.new(targetPos), 0.4)
                            end
                        end)
                        if not success or (tick() - tStart > 4) then break end
                        task.wait()
                    end
                end
            end
        end
    end)
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/pad.lua"))()
end

