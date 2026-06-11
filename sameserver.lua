

local Config = getgenv().Config
if not Config then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

---------
local requestFunc = syn and syn.request or http_request or request
if not requestFunc then return end

local leaderName = ""
if Config["Account Join Raid"] and Config["Account Join Raid"].Users and Config["Account Join Raid"].Users[1] then
    leaderName = string.lower(Config["Account Join Raid"].Users[1])
end
if leaderName == "" then return end

local endpoint = "http://fi11.bot-hosting.net:20758/api/name=" .. leaderName

local targets = {}
local requiredCount = 0

local function addTargets(list)
    if list and type(list) == "table" then
        for _, v in pairs(list) do
            if type(v) == "string" and v ~= "" and not targets[v] then
                targets[v] = true
                requiredCount = requiredCount + 1
            end
        end
    end
end

addTargets(Config["Account Join Raid"] and Config["Account Join Raid"].Users)
addTargets(Config["Account Join"] and Config["Account Join"].Users)

if requiredCount <= 1 then return end

---------
local function getAPI()
    local success, response = pcall(function()
        return requestFunc({
            Url = endpoint,
            Method = "GET"
        })
    end)
    if success and response.StatusCode == 200 then
        local s, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)
        if s and type(data) == "table" then
            return data
        end
    end
    return {}
end

---------
local function postAPI(data)
    pcall(function()
        requestFunc({
            Url = endpoint,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

---------
local function fallbackHop()
    print("Fallback Hop Started")
    for i = 1, 50 do
        local success, test = pcall(function()
            return RS:WaitForChild("__ServerBrowser"):InvokeServer(i)
        end)
        
        if success and type(test) == "table" then
            for k, v in pairs(test) do
                if v.Count >= 7 and k ~= game.JobId then
                    print("Fallback joining: " .. tostring(k))
                    pcall(function()
                        RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", k)
                    end)
                    task.wait(3)
                end
            end
        end
    end
end

---------
task.spawn(function()
    while task.wait(3) do
        local data = getAPI()
        local currentTime = os.time()
        local cleanData = {}
        
        ---------
        for k, v in pairs(data) do
            if currentTime - (v.LastUpdate or 0) <= 30 then
                cleanData[k] = v
            end
        end
        data = cleanData
        
        ---------
        local teamInServer = {}
        for _, p in pairs(Players:GetPlayers()) do
            if targets[p.Name] then
                table.insert(teamInServer, p.Name)
            end
        end
        
        ---------
        data[game.JobId] = {
            PlaceId = game.PlaceId,
            JobId = game.JobId,
            Count = #Players:GetPlayers(),
            Players = teamInServer,
            LastUpdate = currentTime
        }
        
        postAPI(data)
    end
end)

---------
task.spawn(function()
    while task.wait(5) do
        local data = getAPI()
        local currentTime = os.time()
        
        ---------
        local activeSet = {}
        for k, v in pairs(data) do
            if currentTime - (v.LastUpdate or 0) <= 30 and v.Players then
                for _, pName in pairs(v.Players) do
                    if targets[pName] then
                        activeSet[pName] = true
                    end
                end
            end
        end
        
        local activeMembers = 0
        for _ in pairs(activeSet) do 
            activeMembers = activeMembers + 1 
        end
        
        if activeMembers < requiredCount then
            print("Waiting Team API Info...")
            continue
        end
        
        ---------
        local currentTeamCount = 0
        for _, p in pairs(Players:GetPlayers()) do
            if targets[p.Name] then
                currentTeamCount = currentTeamCount + 1
            end
        end
        
        if currentTeamCount >= requiredCount then
            print("Team Gathered!")
            break
        end
        
        ---------
        local maxPlayers = Players.MaxPlayers
        local validServers = {}
        
        for k, v in pairs(data) do
            if currentTime - (v.LastUpdate or 0) <= 30 and v.PlaceId == game.PlaceId then
                local teamInThatServer = v.Players and #v.Players or 0
                local realEmptySlots = (maxPlayers - v.Count) + teamInThatServer
                
                if realEmptySlots >= requiredCount then
                    table.insert(validServers, v)
                end
            end
        end
        
        ---------
        table.sort(validServers, function(a, b)
            if a.Count == b.Count then
                return a.JobId < b.JobId 
            end
            return a.Count < b.Count
        end)
        
        ---------
        local needFallback = true
        
        if #validServers > 0 then
            local bestServer = validServers[1]
            if bestServer.JobId == game.JobId then
                needFallback = false
            else
                print("Trying Server: " .. bestServer.JobId .. " | Players: " .. bestServer.Count .. "/" .. maxPlayers)
                local teleportSuccess = pcall(function()
                    RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", bestServer.JobId)
                end)
                
                if teleportSuccess then
                    task.wait(6)
                end
            end
        end
        
        if needFallback then
            fallbackHop()
        end
    end
end)
