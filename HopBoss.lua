-------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library.lua"))()
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Tp.lua"))()
end)

-------------------
_G.SelectedBoss = ""
_G.KillBoss = false
_G.KillHop = false
_G.EquipType = "Melee"
_G.BusoHaki = true
_G.Noclip = true
_G.DistanceY = 35

-------------------
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
-------------------
getgenv().FailedJobIds = {}
getgenv().LastApiRefresh = 0

local function HopToServerByAPI(filterNames, maxPlayers, waitTime)
    local isHopping = true
    maxPlayers = maxPlayers or 10
    waitTime = waitTime or 25
    local apiUrl = "http://fi11.bot-hosting.net:20758/api/name=" .. filterNames
 
    if not apiUrl then return false end

    if tick() - getgenv().LastApiRefresh > 600 then
        getgenv().FailedJobIds = {}
        getgenv().LastApiRefresh = tick()
    end

    local CURRENT_PLACE_ID = game.PlaceId

    local ok, result = pcall(function()
        local responseBody
        pcall(function() responseBody = game:HttpGet(apiUrl) end)
        
        if not responseBody then
            local reqFunc = (syn and syn.request) or http_request or request or (http and http.request)
            if reqFunc then
                local req = reqFunc({ Url = apiUrl, Method = "GET" })
                responseBody = req.Body
            end
        end
        
        if not responseBody then return false end
        
        local data = HttpService:JSONDecode(responseBody)
        if not data or not data.success or type(data.data) ~= "table" then
            return false
        end
        local seen = {}
        local servers = {}
        for _, entry in ipairs(data.data) do
            local jobId = entry.jobid
            local placeId = entry.placeid
            local players = tonumber(entry.player) or 99

            if jobId and placeId then
                if not seen[jobId] then
                    seen[jobId] = true
                    table.insert(servers, {
                        jobid = jobId,
                        placeid = placeId,
                        players = players,
                    })
                end
            end
        end
        local filtered = {}
        for _, s in ipairs(servers) do
            if s.placeid == CURRENT_PLACE_ID then
                table.insert(filtered, s)
            end
        end
        
        table.sort(filtered, function(a, b) return a.players < b.players end)
        
        for _, server in ipairs(filtered) do
            local jobId = server.jobid
            local players = server.players

            if jobId == game.JobId then continue end
            if getgenv().FailedJobIds[jobId] then continue end
            if players >= maxPlayers then continue end

            local teleportOk = pcall(function()
                RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobId)
            end)
            if teleportOk then
                task.wait(15)
                return true
            else
                getgenv().FailedJobIds[jobId] = tick()
                task.wait(1)
            end
        end
        
        for i = waitTime, 1, -1 do
            if not _G.KillHop then return false end
            task.wait(1)
        end
        return false
    end)
    return ok and result
end

-------------------
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

-------------------
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

-------------------
local function GetBoss()
    local enemiesDir = Workspace:FindFirstChild("Enemies")
    if enemiesDir then
        for _, enemy in pairs(enemiesDir:GetChildren()) do
            if string.find(enemy.Name, _G.SelectedBoss) then
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

-------------------
local function GetBossSpawn()
    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    if worldOrigin then
        local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
        if enemySpawns then
            for _, spawnPart in pairs(enemySpawns:GetChildren()) do
                if string.find(spawnPart.Name, _G.SelectedBoss) then
                    return spawnPart
                end
            end
        end
    end
    return nil
end

-------------------
local function EnableHaki()
    if _G.BusoHaki then
        local char = LocalPlayer.Character
        if char and not char:FindFirstChild("HasBuso") then
            pcall(function()
                RS.Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end

-------------------
RunService.Stepped:Connect(function()
    if _G.Noclip and (_G.KillBoss or _G.KillHop) then
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

-------------------
task.spawn(function()
    task.wait(2)
    while task.wait(0.5) do
        if _G.KillBoss or _G.KillHop then
            local boss = GetBoss()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if boss and root then
                EnableHaki()
                EquipWeapon()
                StartAttack()
                
                local bossRoot = boss:FindFirstChild("HumanoidRootPart")
                if bossRoot then
                    local targetCFrame = bossRoot.CFrame * CFrame.new(0, _G.DistanceY, 0)
                    if getgenv().TP then
                        getgenv().TP(targetCFrame)
                    else
                        root.CFrame = targetCFrame
                    end
                end
            else
                if _G.KillHop then
                    Library:SendNotification("System", "Hop Boss ~ wait 3sec")
                    task.wait(3)
                    if _G.KillHop then
                        local apiBossName = FormatForAPI(_G.SelectedBoss)
                        HopToServerByAPI(apiBossName, 10, 2)
                    end
                elseif _G.KillBoss then
                    local bossSpawn = GetBossSpawn()
                    if bossSpawn and root then
                        local targetCFrame = bossSpawn.CFrame * CFrame.new(0, _G.DistanceY, 0)
                        if getgenv().TP then
                            getgenv().TP(targetCFrame)
                        else
                            root.CFrame = targetCFrame
                        end
                    end
                end
            end
        else
            if getgenv().stoptp then
                getgenv().stoptp()
            end
        end
    end
end)
-------------------
local Window = Library:CreateWindow({
    Title = "HopBosss [premium] by meyy hub"
})

local MainTab = Window:CreateTab("Main", true, "rbxassetid://6031090990")
local SettingsTab = Window:CreateTab("Settings", false, "rbxthumb://type=Asset&id=125575515639947&w=420&h=420")
local EventsTab = Window:CreateTab("Events", false, "rbxassetid://88966134653623")

-------------------
MainTab:CreatePageTitle("Boss Configuration")

MainTab:CreateDropdown(
    "Select Boss", 
    "rip_indra", 
    {"rip_indra", "Dough King", "Tyrant of the Skies", "Darkbeard", "Cursed Captain", "Soul Reaper", "Cake Prince", "Elite"}, 
    "Select target boss", 
    function(selected)
        _G.SelectedBoss = selected
    end
)

MainTab:CreatePageTitle("Farming Method")

MainTab:CreateSwitch(
    "Kill Boss", 
    false, 
    "Wait and kill boss in current server", 
    function(state)
        _G.KillBoss = state
    end
)

MainTab:CreateSwitch(
    "Kill Hop", 
    false, 
    "Hop server to find and kill boss", 
    function(state)
        _G.KillHop = state
    end
)

-------------------
SettingsTab:CreatePageTitle("Player Settings")

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

SettingsTab:CreatePageTitle("UI Settings")

SettingsTab:CreateDropdown(
    "UI Theme", 
    "Dark", 
    {"Dark", "Ocean", "Dream"}, 
    "Change interface theme", 
    function(themeName)
        Window:ApplyTheme(themeName)
    end
)

-------------------
EventsTab:CreatePageTitle("Event Server Hop")

EventsTab:CreateButton(
    "Hop Sword Legend", 
    "Find server with Sword Legend", 
    function()
        Library:SendNotification("System", "Hopping to Sword Legend...")
        task.spawn(function() HopToServerByAPI("SwordLegend", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Cake Prince", 
    "Find server with Cake Prince", 
    function()
        Library:SendNotification("System", "Hopping to Cake Prince...")
        task.spawn(function() HopToServerByAPI("CakePrince", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Haki Legendary", 
    "Find server with Haki Legendary", 
    function()
        Library:SendNotification("System", "Hopping to Haki Legendary...")
        task.spawn(function() HopToServerByAPI("HakiLegendary", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Berry", 
    "Find server with Berry", 
    function()
        Library:SendNotification("System", "Hopping to Berry...")
        task.spawn(function() HopToServerByAPI("Berry", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Elite", 
    "Find server with Elite", 
    function()
        Library:SendNotification("System", "Hopping to Elite...")
        task.spawn(function() HopToServerByAPI("Elite", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Castle Raid", 
    "Find server with Castle Raid(Pirate Raid)", 
    function()
        Library:SendNotification("System", "Hopping to Castle Raid...")
        task.spawn(function() HopToServerByAPI("CastleRaid(PirateRaid)", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Rip Indra", 
    "Find server with Rip Indra", 
    function()
        Library:SendNotification("System", "Hopping to Rip Indra...")
        task.spawn(function() HopToServerByAPI("RipIndra", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Darkbeard", 
    "Find server with Darkbeard", 
    function()
        Library:SendNotification("System", "Hopping to Darkbeard...")
        task.spawn(function() HopToServerByAPI("Darkbeard", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Cursed Captain", 
    "Find server with Cursed Captain", 
    function()
        Library:SendNotification("System", "Hopping to Cursed Captain...")
        task.spawn(function() HopToServerByAPI("CursedCaptain", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Dough King", 
    "Find server with Dough King", 
    function()
        Library:SendNotification("System", "Hopping to Dough King...")
        task.spawn(function() HopToServerByAPI("DoughKing", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Tyrant of the Skies", 
    "Find server with Tyrant of the Skies", 
    function()
        Library:SendNotification("System", "Hopping to Tyrant of the Skies...")
        task.spawn(function() HopToServerByAPI("TyrantoftheSkies", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Soul Reaper", 
    "Find server with Soul Reaper", 
    function()
        Library:SendNotification("System", "Hopping to Soul Reaper...")
        task.spawn(function() HopToServerByAPI("SoulReaper", 12, 2) end)
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
    "Hop Near Moon", 
    "Find server with Near Moon", 
    function()
        Library:SendNotification("System", "Hopping to Near Moon...")
        task.spawn(function() HopToServerByAPI("NearMoon", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Fruit", 
    "Find server with Fruit", 
    function()
        Library:SendNotification("System", "Hopping to Fruit...")
        task.spawn(function() HopToServerByAPI("Fruit", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Mirage Island", 
    "Find server with Mirage Island", 
    function()
        Library:SendNotification("System", "Hopping to Mirage Island...")
        task.spawn(function() HopToServerByAPI("MirageIsland", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Prehistoric Island", 
    "Find server with Prehistoric Island", 
    function()
        Library:SendNotification("System", "Hopping to Prehistoric Island...")
        task.spawn(function() HopToServerByAPI("PrehistoricIsland", 12, 2) end)
    end
)

EventsTab:CreateButton(
    "Hop Kitsune Island", 
    "Find server with Kitsune Island", 
    function()
        Library:SendNotification("System", "Hopping to Kitsune Island...")
        task.spawn(function() HopToServerByAPI("KitsuneIsland", 12, 2) end)
    end
)
-------------------
