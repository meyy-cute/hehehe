local Config = {
    FileName = "Cute_same_servers.json" 
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

---------
local function getServers()
    if isfile(Config.FileName) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(Config.FileName))
        end)
        if success and type(data) == "table" then
            return data
        end
    end
    return {}
end

---------
local function saveServer()
    local data = getServers()
    data[game.JobId] = {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        Count = #Players:GetPlayers(),
        LastUpdate = os.time()
    }
    
    ---------
    for k, v in pairs(data) do
        if os.time() - (v.LastUpdate or 0) > 60 then
            data[k] = nil
        end
    end
    
    pcall(function()
        writefile(Config.FileName, HttpService:JSONEncode(data))
    end)
    return data
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
    while task.wait(5) do
        local data = saveServer()
        
        ---------
        local totalMyAccs = 0
        for k, v in pairs(data) do
            if v.PlaceId == game.PlaceId then
                totalMyAccs = totalMyAccs + 1
            end
        end
        if totalMyAccs == 0 then totalMyAccs = 1 end
        
        local maxPlayers = Players.MaxPlayers
        local validServers = {}
        
        for k, v in pairs(data) do
            if v.PlaceId == game.PlaceId and (maxPlayers - v.Count) >= totalMyAccs then
                table.insert(validServers, v)
            end
        end
        
        table.sort(validServers, function(a, b)
            return a.Count < b.Count
        end)
        
        local needFallback = true
        
        if #validServers > 0 then
            for i, srv in ipairs(validServers) do
                if srv.JobId == game.JobId then
                    needFallback = false
                    break
                else
                    print("Trying Server: " .. srv.JobId .. " | Players: " .. srv.Count .. "/" .. maxPlayers)
                    local teleportSuccess = pcall(function()
                        RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", srv.JobId)
                    end)
                    
                    if teleportSuccess then
                        task.wait(6)
                    end
                end
            end
        end
        
        if needFallback then
            fallbackHop()
        end
    end
end)
