local Config = {
    ["Main Account"] = { "88fpn3" } 
}
getgenv().Config = Config

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local requestFunc = (type(syn) == "table" and syn.request) or (type(http) == "table" and http.request) or request or http_request
if not requestFunc then
    local env = getgenv and getgenv() or _G
    requestFunc = env.request or env.http_request
end

local globalConfig = getgenv and getgenv().Config or {}
local mainAccounts = globalConfig["Main Account"] or {}
if type(mainAccounts) == "string" then
    mainAccounts = {mainAccounts}
end

local isaccmain = isaccmain or {}

local function isMain(playerName)
    if isaccmain[playerName] then return true end
    for _, name in pairs(mainAccounts) do
        if name == playerName then return true end
    end
    return false
end

local function status(msg)
    print("[Status] " .. tostring(msg))
end

if isMain(LocalPlayer.Name) then
    task.spawn(function()
        pcall(function()
            local payload = HttpService:JSONEncode({
                name = LocalPlayer.Name,
                placeid = game.PlaceId,
                jobid = game.JobId
            })
            requestFunc({
                Url = "https://www.meyyhub.xyz/api/mainaccount",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = payload
            })
        end)
        print("Main Account Identified. Data Sent to API.")
    end)
else
    print("Member Account. Waiting for Main...")
    task.spawn(function()
        local sameServer = false
        while task.wait(5) do
            if sameServer then break end
            
            for _, mainName in pairs(mainAccounts) do
                local success, response = pcall(function()
                    return requestFunc({
                        Url = "https://www.meyyhub.xyz/api/mainaccount/" .. tostring(mainName),
                        Method = "GET"
                    })
                end)

                if success and response and response.Body then
                    local decodeSuccess, decoded = pcall(function()
                        return HttpService:JSONDecode(response.Body)
                    end)

                    if decodeSuccess and decoded and decoded.success and decoded.data then
                        local data = decoded.data
                        local serverTime = os.time()
                        
                        if data.time and data.jobid then
                            local timeDiff = serverTime - data.time
                            if timeDiff < 30 then
                                if data.jobid == game.JobId then
                                    sameServer = true
                                    break
                                else
                                    status("Follow main: " .. mainName)
                                    pcall(function()
                                        ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", data.jobid)
                                    end)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
