repeat wait() until game:IsLoaded() and game.Players.LocalPlayer 
replicated = game.ReplicatedStorage
local plr = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function joinMarines()
    ---------
    local args = {
        [1] = "SetTeam",
        [2] = "Marines"
    }
    ---------
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    remote:InvokeServer(unpack(args))
end

---------
while task.wait(0.5) do
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        break
    end
    
    local success, err = pcall(function()
        joinMarines()
    end)
    
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        break
    end
end
---------


-- Soul Cane
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
-- Bisento
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
-- Dual-Headed Blade
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
-- Pipe
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual Katana")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Katana")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
-- kabucha 
 replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
-- Cannon
 replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
-- Refined Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
-- Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
--  Dual Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
-- Musket
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Musket")
-- Slingshot
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
-- Bizarre Rifle
replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)


local Config = {
    TargetBossName = "Greybeard", 
    TweenSpeed = 400,
    HoverHeight = 40
}

local function AutoFarmBoss()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")

    local LocalPlayer = Players.LocalPlayer
    local RS = ReplicatedStorage

    ---------
    
    local function HopServer(player)
        pcall(function()
            local servers = HttpService:JSONDecode(
                game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            ).data
            for _, server in pairs(servers) do
                if server.playing < (player or 4) and server.id ~= game.JobId then
                    RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", server.id)
                    task.wait(4)
                    break
                end
            end
        end)
    end

    ---------
    
    local function EquipWeapon()
        local char = LocalPlayer.Character
        if not char then return end
        
        local function CheckParent(parent)
            for _, item in pairs(parent:GetChildren()) do
                if item:IsA("Tool") and item.ToolTip == "Sword" then
                    item.Parent = char
                    return true
                end
            end
            return false
        end
        
        if not CheckParent(char) then
            CheckParent(LocalPlayer.Backpack)
        end
    end

    ---------
    
    local function StartAttack()
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/m1-attack.lua"))()
        end)
    end

    ---------

    local function GetBoss()
        local enemiesDir = Workspace:FindFirstChild("Enemies")
        if enemiesDir then
            for _, enemy in pairs(enemiesDir:GetChildren()) do
                if string.find(enemy.Name, Config.TargetBossName) then
                    local hum = enemy:FindFirstChild("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then
                        return enemy
                    end
                end
            end
        end
        return nil
    end

    ---------

    local function CuteGetBossSpawn()
        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        if worldOrigin then
            local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
            if enemySpawns then
                for _, spawnPart in pairs(enemySpawns:GetChildren()) do
                    if string.find(spawnPart.Name, Config.TargetBossName) then
                        return spawnPart
                    end
                end
            end
        end
        return nil
    end

    ---------

    ---------
    local function ExecuteFarm()
        local boss = GetBoss()
        
        if boss then
            StartAttack()
            
            local farmConnection
            farmConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    
                    local root = char.HumanoidRootPart
                    local bossRoot = boss.HumanoidRootPart
                    local targetCFrame = bossRoot.CFrame * CFrame.new(0, Config.HoverHeight, 0)
                    
                    local distance = (root.Position - targetCFrame.Position).Magnitude
                    
                    if distance > 10 then
                        local tweenTime = distance / Config.TweenSpeed
                        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
                        tween:Play()
                    else
                        root.CFrame = targetCFrame
                    end
                else
                    if farmConnection then
                        farmConnection:Disconnect()
                    end
                end
            end)
            
            while boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss.Parent do
                task.wait(0.5)
            end
            
            if farmConnection then
                farmConnection:Disconnect()
            end
            
            task.wait(1)
            HopServer()
        else
            local bossSpawn = CuteGetBossSpawn()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if bossSpawn and root then
                local distanceToSpawn = (root.Position - bossSpawn.Position).Magnitude
                
                if distanceToSpawn <= 1500 then
                    HopServer()
                else
                    local targetCFrame = bossSpawn.CFrame * CFrame.new(0, Config.HoverHeight, 0)
                    local tweenTime = distanceToSpawn / Config.TweenSpeed
                    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
                    
                    tween:Play()
                    
                    local foundBoss = false
                    while tween.PlaybackState == Enum.PlaybackState.Playing do
                        if GetBoss() then
                            tween:Cancel()
                            foundBoss = true
                            break
                        end
                        task.wait(0.5)
                    end
                    
                    if foundBoss then
                        ExecuteFarm()
                    else
                        task.wait(0.5)
                        HopServer()
                    end
                end
            else
                HopServer()
            end
        end
    end
    ---------

    ExecuteFarm()
end
------------- ♡♡♡ ---------
AutoFarmBoss()
-----------------------------


local World1, World2, World3 = false, false, false
local placeId = game.PlaceId

if placeId == 2753915549 or placeId == 85211729168715 then World1 = true
elseif placeId == 4442272183 or placeId == 79091703265657 then World2 = true
elseif placeId == 7449423635 or placeId == 100117331123089 then World3 = true end

---------

RunService.Stepped:Connect(function()
    if getgenv().AutoMaterial and plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

---------

local function TweenObject(Object, Pos, Speed)
    Speed = Speed or 350
    if not Object or not Pos then return end
    local Distance = (Pos.Position - Object.Position).Magnitude
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Object, info, {CFrame = Pos})
    tween:Play()
end

---------

local function MoveTo(targetCFrame)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    
    if not _G.PlatformPart then
        _G.PlatformPart = Instance.new("Part", workspace)
        _G.PlatformPart.Size = Vector3.new(10, 1, 10)
        _G.PlatformPart.Anchored = true
        _G.PlatformPart.Transparency = 1
        _G.PlatformPart.Name = "meyy_Platform"
    end

    if dist <= 200 then
        hrp.CFrame = targetCFrame
        _G.PlatformPart.CFrame = targetCFrame * CFrame.new(0, -3.5, 0)
    else
        local tweenInfo = TweenInfo.new(dist/250, Enum.EasingStyle.Linear)
        local tweenHrp = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        local tweenPlat = TweenService:Create(_G.PlatformPart, tweenInfo, {CFrame = targetCFrame * CFrame.new(0, -3.5, 0)})
        
        tweenHrp:Play()
        tweenPlat:Play()
        return tweenHrp
    end
end

---------

local function CheckItem(itemName)
    if itemName == "None" or not itemName then return false, 0 end
    local inv = RS.Remotes.CommF_:InvokeServer("getInventory")
    for _, v in ipairs(inv) do 
        if v.Name == itemName then 
            return true, v.Count or 1 
        end 
    end
    return false, 0
end

---------

local function GetMaterialData(matName)
    local MMon, MPos = {}, nil
    if World1 then
        if matName == "Angel Wings" then MMon = {"Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God"} MPos = CFrame.new(-4698, 845, -1912)
        elseif matName == "Leather" or matName == "Scrap Metal" then MMon = {"Brute", "Pirate"} MPos = CFrame.new(-1145, 15, 4350)
        elseif matName == "Magma Ore" then MMon = {"Military Soldier", "Military Spy", "Magma Admiral"} MPos = CFrame.new(-5815, 84, 8820)
        elseif matName == "Fish Tail" then MMon = {"Fishman Warrior", "Fishman Commando", "Fishman Lord"} MPos = CFrame.new(61123, 19, 1569) end
    elseif World2 then
        if matName == "Leather" or matName == "Scrap Metal" then MMon = {"Marine Captain"} MPos = CFrame.new(-2010.5, 73, -3326.6)
        elseif matName == "Magma Ore" then MMon = {"Magma Ninja", "Lava Pirate"} MPos = CFrame.new(-5428, 78, -5959)
        elseif matName == "Ectoplasm" then MMon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"} MPos = CFrame.new(911.3, 125.9, 33159.5)
        elseif matName == "Mystic Droplet" then MMon = {"Water Fighter"} MPos = CFrame.new(-3385, 239, -10542)
        elseif matName == "Radioactive Material" then MMon = {"Factory Staff"} MPos = CFrame.new(295, 73, -56)
        elseif matName == "Vampire Fang" then MMon = {"Vampire"} MPos = CFrame.new(-6033, 7, -1317) end
    elseif World3 then
        if matName == "Scrap Metal" then MMon = {"Jungle Pirate", "Forest Pirate"} MPos = CFrame.new(-11975.7, 331.7, -10620)
        elseif matName == "Fish Tail" then MMon = {"Fishman Raider", "Fishman Captain"} MPos = CFrame.new(-10993, 332, -8940)
        elseif matName == "Conjured Cocoa" then MMon = {"Chocolate Bar Battler", "Cocoa Warrior"} MPos = CFrame.new(620.6, 78.9, -12581.3)
        elseif matName == "Dragon Scale" then MMon = {"Dragon Crew Archer", "Dragon Crew Warrior"} MPos = CFrame.new(6594, 383, 139)
        elseif matName == "Gunpowder" then MMon = {"Pistol Billionaire"} MPos = CFrame.new(-84.8, 85.6, 6132)
        elseif matName == "Mini Tusk" then MMon = {"Mythological Pirate"} MPos = CFrame.new(-13545, 470, -6917)
        elseif matName == "Demonic Wisp" then MMon = {"Demonic Soul"} MPos = CFrame.new(-9495.6, 453.5, 5977.3) end
    end
    return MMon, MPos
end

---------

local function GetMobPosition(EnemiesName)
    local pos = Vector3.zero
    local count = 0
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == EnemiesName and v:FindFirstChild("HumanoidRootPart") then
            pos += v.HumanoidRootPart.Position
            count += 1
        end
    end
    if count == 0 then
        return nil
    end
    return pos / count
end

---------

local function BringMob(enable)
    if not enable then return end
    local enemies = workspace.Enemies:GetChildren()
    if #enemies == 0 then return end
    local totalpos = {}
    
    for _, v in pairs(enemies) do
        if not totalpos[v.Name] then
            totalpos[v.Name] = GetMobPosition(v.Name)
        end
    end
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local hrp = v.HumanoidRootPart
            local humanoid = v.Humanoid
            if humanoid.Health > 0 and (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 350 then
                local mobPos = totalpos[v.Name]
                if mobPos then
                    local TargetCFrame = CFrame.new(mobPos.X, mobPos.Y, mobPos.Z)
                    local Distance = (hrp.Position - TargetCFrame.Position).Magnitude
                    if Distance > 3 and Distance <= 280 then
                        TweenObject(hrp, TargetCFrame, 300)
                        hrp.CanCollide = false
                        if humanoid:FindFirstChild("Animator") then
                            humanoid.Animator:Destroy()
                        end
                        pcall(function()
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        end)
                    end
                end
            end
        end
    end
end

---------

local lastCampedSpawn = nil

local function GetBossSpawn(enemyNames)
    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    local bestSpawn = nil
    local minDistance = math.huge
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return nil end

    if worldOrigin then
        local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
        if enemySpawns then
            for _, spawnPart in pairs(enemySpawns:GetChildren()) do
                for _, eName in ipairs(enemyNames or {}) do
                    if string.find(spawnPart.Name, eName) then
                        if spawnPart ~= lastCampedSpawn then
                            local dist = (hrp.Position - spawnPart.Position).Magnitude
                            if dist < minDistance then
                                minDistance = dist
                                bestSpawn = spawnPart
                            end
                        end
                    end
                end
            end
        end
    end
    
    if bestSpawn then
        lastCampedSpawn = bestSpawn
    end
    
    return bestSpawn
end

---------

local function FarmMaterialLogic(matName, targetAmount)
    getgenv().AutoMaterial = true
    
    task.spawn(function()
        while getgenv().AutoMaterial do
            task.wait()
            
            local hasItem, currentAmount = CheckItem(matName)
            if currentAmount >= targetAmount then
                getgenv().AutoMaterial = false
                if _G.PlatformPart then 
                    _G.PlatformPart:Destroy() 
                    _G.PlatformPart = nil 
                end
                break
            end

            local MMon, MPos = GetMaterialData(matName)
            local targetEnemy = nil
            
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                local isTarget = false
                for _, en in ipairs(MMon or {}) do 
                    if v.Name == en then 
                        isTarget = true 
                        break 
                    end 
                end
                
                if isTarget and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                    targetEnemy = v
                    break
                end
            end
            
            if targetEnemy then
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local tw = MoveTo(targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0))
                
                repeat
                    task.wait()
                    BringMob(true)
                    
                    if hrp and targetEnemy:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0)
                        if _G.PlatformPart then 
                            _G.PlatformPart.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0) 
                        end
                    end
                    
                    hasItem, currentAmount = CheckItem(matName)
                    if currentAmount >= targetAmount or not getgenv().AutoMaterial then 
                        if tw then tw:Cancel() end 
                        break 
                    end
                until not targetEnemy.Parent or targetEnemy.Humanoid.Health <= 0
            else
                local nextSpawn = GetBossSpawn(MMon)
                if nextSpawn then
                    MoveTo(nextSpawn.CFrame * CFrame.new(0, 35, 0))
                    task.wait(1)
                elseif MPos then
                    MoveTo(MPos)
                end
            end
        end
    end)
end

-- Call Function Example
-- FarmMaterialLogic("Magma Ore", 100)

-------------------------
local function EquipItemInv(itemName)
    if itemName then
        replicated.Remotes.CommF_:InvokeServer("LoadItem", itemName)
    end
end
-------------------------

