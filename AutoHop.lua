repeat wait() until game:IsLoaded() and game.Players.LocalPlayer 
replicated = game.ReplicatedStorage

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

    local function GetBossSpawn()
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
            local bossSpawn = GetBossSpawn()
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

AutoFarmBoss()
