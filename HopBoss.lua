-------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library.lua"))()

---------
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/TpForKaitun.lua"))()
end)

_G.SelectedBoss = "Cake Prince"
_G.AutoBoss = false
_G.EquipType = "Melee"
_G.BusoHaki = true
_G.Noclip = true
_G.DistanceY = 35
_G.AutoBuyHaki = false
_G.AutoBuySword = false
_G.SelectedTeam = "Pirates"
---------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RS = ReplicatedStorage

local function FormatForAPI(str)
    if not str then return "" end
    return string.gsub(str, "[%s_%(%)%[%]%%]", "")
end
getgenv().FailedJobIds = {}
getgenv().LastApiRefresh = 0
joinFailed = false

local isHopping = false
local isFighting = false

local function HopToServerByAPI(filterNames, maxPlayers, waitTime)
    maxPlayers = maxPlayers or 10
    waitTime = waitTime or 25
    local apiUrl = "https://chiucacboroimeyyhub.up.railway.app/api/" .. filterNames
    local CURRENT_PLACE_ID = game.PlaceId
    local ok, result = pcall(function()
        local responseBody
        pcall(function()
            responseBody = game:HttpGet(apiUrl)
        end)
        if not responseBody then
            local reqFunc = (syn and syn.request) or request or http.request
            local req = reqFunc({ Url = apiUrl, Method = "GET" })
            responseBody = req.Body
        end
        if not responseBody then return false end
        
        local data = HttpService:JSONDecode(responseBody)
        local dataList
        if type(data) == "table" then
            if data.success and type(data.data) == "table" then
                dataList = data.data
            elseif data[1] ~= nil then
                dataList = data
            end
        end
        if not dataList then return false end
        
        local seen = {}
        local servers = {}
        for _, entry in ipairs(dataList) do
            local jobId  = entry.jobId or entry.jobid
            local placeId = tonumber(entry.placeId) or tonumber(entry.placeid)
            local players = tonumber(entry.players) or 99
            if jobId and placeId and not seen[jobId] then
                seen[jobId] = true
                table.insert(servers, {
                    jobid   = jobId,
                    placeid = placeId,
                    players = players,
                })
            end
        end
        
        local filtered = {}
        for _, s in ipairs(servers) do
            if s.placeid == CURRENT_PLACE_ID then
                table.insert(filtered, s)
            end
        end
        table.sort(filtered, function(a, b) return a.players < b.players end)
        
        if #filtered == 0 then
            for i = waitTime, 1, -1 do
                if getgenv().StopV3 or isFighting then return false end
                task.wait(1)
            end
            return false
        end
        
        local triedCount = 0
        for _, server in ipairs(filtered) do
            if isFighting then return false end
            local jobId   = server.jobid
            local players = server.players
            if jobId == game.JobId then continue end
            if getgenv().FailedJobIds[jobId] then continue end
            if players >= maxPlayers then continue end
            triedCount = triedCount + 1
            
            local teleportOk = pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("__ServerBrowser")
                    :InvokeServer("teleport", jobId)
            end)
            if teleportOk then
                game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, result, err)
                    if result == Enum.TeleportResult.GameFull then
                        joinFailed = true
                        getgenv().FailedJobIds[jobId] = tick()
                    end
                end)
                if not joinFailed then
                    return true
                end
            else
                getgenv().FailedJobIds[jobId] = tick()
                task.wait(1)
            end
        end
        
        for i = waitTime, 1, -1 do
            if getgenv().StopV3 or isFighting then return false end
            task.wait(1)
        end
        return false
    end)
    return ok and result
end

local function joinSelectedTeam()
    local args = {
        [1] = "SetTeam",
        [2] = _G.SelectedTeam
    }
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    remote:InvokeServer(unpack(args))
end

task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Team and LocalPlayer.Team.Name == _G.SelectedTeam then
            continue
        end
        pcall(function() joinSelectedTeam() end)
    end
end)

task.spawn(function()
    while task.wait(2.5) do
        if _G.AutoBuyHaki then
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ColorsDealer", "2") end)
        end
        if _G.AutoBuySword then
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") end)
        end
    end
end)

---------
local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    
    local function CheckParent(parent)
        for _, item in pairs(parent:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip == _G.EquipType then
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
local attackExecuted = false
local function StartAttack()
    if attackExecuted then return end
    attackExecuted = true
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/m1-attack.lua"))()
        end)
    end)
end

---------
local function IsBossMatch(name)
    if _G.SelectedBoss == nil or _G.SelectedBoss == "" then return false end
    if _G.SelectedBoss == "Elite" then
        return name == "Urban" or name == "Deandre" or name == "Diablo"
    elseif _G.SelectedBoss == "rip_indra" then
        return name == "rip_indra True Form"
    else
        return string.find(name, _G.SelectedBoss) ~= nil
    end
end

local function GetBoss()
    local enemiesDir = Workspace:FindFirstChild("Enemies")
    if enemiesDir then
        for _, enemy in pairs(enemiesDir:GetChildren()) do
            if IsBossMatch(enemy.Name) then
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
local function EnableHaki()
    if _G.BusoHaki then
        local char = LocalPlayer.Character
        if char and not char:FindFirstChild("HasBuso") and not char:FindFirstChild("Buso") then
            pcall(function()
                RS.Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end

---------
---------
RunService.Stepped:Connect(function()
    if _G.Noclip and _G.AutoBoss then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)
---------
local W = 30
local lastChange = tick()

local function RoundVector3Down(Vector)
    return Vector3.new(math.floor(Vector.X / 10) * 10, math.floor(Vector.Y / 10) * 10, math.floor(Vector.Z / 10) * 10)
end

local function CaculateCircreDirection(PositionCFrame)
    if W > 50000 then W = 60 end
    W = W + ((tick() - lastChange) > 0.4 and 80 or 0)
    if tick() - lastChange > 0.4 then lastChange = tick() end
    local TargetPosition = PositionCFrame.Position + Vector3.new(math.cos(math.rad(W)) * _G.DistanceY, 0, math.sin(math.rad(W)) * _G.DistanceY)
    return CFrame.new(RoundVector3Down(TargetPosition))
end

---------
task.spawn(function()
    while task.wait(0.1) do
        if not _G.AutoBoss then
            if getgenv().stoptp then getgenv().stoptp() end
            isFighting = false
            isInBossRoom = false
            waitingForTeleport = false
            continue
        end

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local boss = GetBoss()

        if boss then
            isFighting = true
            isHopping = false 
            
            local isCakeBoss = (_G.SelectedBoss == "Cake Prince" or _G.SelectedBoss == "Dough King")

            if isCakeBoss and not isInBossRoom then
                local targetPosition = Vector3.new(-2133.97, 70.32, -12400.57)
                local dist = (root.Position - targetPosition).Magnitude
                
                if dist > 20 then
                    if getgenv().TP then
                        getgenv().TP(CFrame.new(targetPosition) * CFrame.new(0, 0, 5))
                    else
                        root.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 0, 5)
                    end
                    waitingForTeleport = false
                else
                    if not waitingForTeleport then
                        waitingForTeleport = true
                        lastYCheck = root.Position.Y
                        lastTimeCheck = tick()
                    else
                        if tick() - lastTimeCheck >= 1 then
                            if math.abs(root.Position.Y - lastYCheck) > 1000 then
                                isInBossRoom = true
                                waitingForTeleport = false
                            end
                            lastYCheck = root.Position.Y
                            lastTimeCheck = tick()
                        end
                    end
                end
                continue
            end

            EnableHaki()
            EquipWeapon()
            StartAttack()

            local bossRoot = boss:FindFirstChild("HumanoidRootPart")
            if bossRoot then
                local targetCFrame = CaculateCircreDirection(bossRoot.CFrame)
                if getgenv().TP then
                    getgenv().TP(targetCFrame)
                else
                    root.CFrame = targetCFrame
                end
            end
        else
            isFighting = false
            isInBossRoom = false
            waitingForTeleport = false
            if getgenv().stoptp then getgenv().stoptp() end

            if not isHopping then
                isHopping = true
                Library:SendNotification("System", "No boss found. Hopping in 3s...")
                task.spawn(function()
                    task.wait(3)
                    local recheckBoss = GetBoss()
                    if not recheckBoss then
                        Library:SendNotification("System", "Hopping to find " .. _G.SelectedBoss)
                        local apiBossName = FormatForAPI(_G.SelectedBoss)
                        HopToServerByAPI(apiBossName, 10, 2)
                    end
                    task.wait(3) 
                    isHopping = false
                end)
            end
        end
    end
end)
---------


local Window = Library:CreateWindow({
    Title = "HopBosss [premium] by meyy hub"
})

local MainTab = Window:CreateTab("Main", true, "rbxassetid://6031090990")
local SettingsTab = Window:CreateTab("Settings", false, "rbxthumb://type=Asset&id=125575515639947&w=420&h=420")
local EventsTab = Window:CreateTab("Events", false, "rbxassetid://88966134653623")

---------
MainTab:CreatePageTitle("Boss Configuration")

MainTab:CreateDropdown(
    "Select Boss", 
    "rip_indra", 
    {"rip_indra", "Dough King", "Darkbeard", "Cursed Captain", "Soul Reaper", "Cake Prince", "Elite"}, 
    "Select target boss", 
    function(selected)
        _G.SelectedBoss = selected
    end
)

MainTab:CreatePageTitle("Kill Hop")

MainTab:CreateSwitch(
    "Auto Kill & Hop Boss", 
    false, 
    "Auto kill boss or hop if not found", 
    function(state)
        _G.AutoBoss = state
    end
)

MainTab:CreatePageTitle("Buy Legend Haki")
MainTab:CreateSwitch(
    "Auto Buy Haki Legend (Red, Pink, White)",
    false,
    "Auto buy legendary haki colors if have cousin",
    function(state)
        _G.AutoBuyHaki = state
    end
)
MainTab:CreatePageTitle("Buy Legend Sword")
MainTab:CreateSwitch(
    "Auto Buy Sword Legend (Oroshi, Saishi, Shizu)", 
    false,
    "buy legendary swords if have NPC",
    function(state)
        _G.AutoBuySword = state
    end
)
---------
SettingsTab:CreatePageTitle("Settings Team")

SettingsTab:CreateDropdown(
    "Select Team",
    "Pirates",
    {"Pirates", "Marines"},
    "Choose your team",
    function(selected)
        _G.SelectedTeam = selected
        joinSelectedTeam()
    end
)
SettingsTab:CreatePageTitle("Settings Weapon")

SettingsTab:CreateDropdown(
    "Equip Weapon", 
    "Melee", 
    {"Melee", "Sword", "Gun", "Blox Fruit"}, 
    "Select weapon to use", 
    function(selected)
        _G.EquipType = selected
        if selected == "Melee" then
            _G.DistanceY = 35
        elseif selected == "Sword" then
            _G.DistanceY = 35
        elseif selected == "Gun" then
            _G.DistanceY = 50
        elseif selected == "Blox Fruit" then
            _G.DistanceY = 5
        end
    end
)
SettingsTab:CreatePageTitle("Player Settings")

SettingsTab:CreateSwitch(
    "Buso Haki", 
    true, 
    "Auto enable Aura", 
    function(state)
        _G.BusoHaki = state
    end
)

SettingsTab:CreateSwitch(
    "Noclip", 
    true, 
    "Walk through walls", 
    function(state)
        _G.Noclip = state
    end
)

SettingsTab:CreateSlider(
    "Distance Attack (Y)", 
    0, 
    100, 
    35, 
    "Height distance from target", 
    function(value)
        _G.DistanceY = value
    end
)

---------
EventsTab:CreatePageTitle("Server Hop Ghoul")

EventsTab:CreateButton(
    "Hop Cursed Captain", 
    "Find server with Cursed Captain", 
    function()
        Library:SendNotification("System", "Hopping to Cursed Captain...")
        task.spawn(function() HopToServerByAPI("CursedCaptain", 12, 2) end)
    end
)

EventsTab:CreatePageTitle("Server Hop Legend Sword")

EventsTab:CreateButton(
    "Hop Sword Oroshi", 
    "Find server with Sword ", 
    function()
        Library:SendNotification("System", "Hopping to Sword Legend...")
        task.spawn(function() HopToServerByAPI("Oroshi", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Sword Saishi", 
    "Find server with Sword ", 
    function()
        Library:SendNotification("System", "Hopping to Sword Legend...")
        task.spawn(function() HopToServerByAPI("Saishi", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Sword Shizu", 
    "Find server with Sword ", 
    function()
        Library:SendNotification("System", "Hopping to Sword Legend...")
        task.spawn(function() HopToServerByAPI("Shizu", 12, 2) end)
    end
)

EventsTab:CreatePageTitle("Server Hop Legend Haki")

EventsTab:CreateButton(
    "Hop Haki Legendary Pure Red", 
    "Find server with Haki Legendary", 
    function()
        Library:SendNotification("System", "Hopping to Haki Legendary...")
        task.spawn(function() HopToServerByAPI("PureRed", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Haki Legendary Snow White", 
    "Find server with Haki Legendary", 
    function()
        Library:SendNotification("System", "Hopping to Haki Legendary...")
        task.spawn(function() HopToServerByAPI("SnowWhite", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Haki Legendary Winter Sky", 
    "Find server with Haki Legendary", 
    function()
        Library:SendNotification("System", "Hopping to Haki Legendary...")
        task.spawn(function() HopToServerByAPI("WinterSky", 12, 2) end)
    end
)

EventsTab:CreatePageTitle("Server Hop Event")

EventsTab:CreateButton(
    "Hop Castle Raid", 
    "Find server with Castle Raid(Pirate Raid)", 
    function()
        Library:SendNotification("System", "Hopping to Castle Raid...")
        task.spawn(function() HopToServerByAPI("RaidCastle", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Full Moon", 
    "Find server with Full Moon", 
    function()
        Library:SendNotification("System", "Hopping to Full Moon...")
        task.spawn(function() HopToServerByAPI("FullMoon", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Mirage Island", 
    "Find server with Mirage Island", 
    function()
        Library:SendNotification("System", "Hopping to Mirage Island...")
        task.spawn(function() HopToServerByAPI("Mirage", 12, 2) end)
    end
)


