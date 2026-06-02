
local Config = { LeaderName = "meomeo_cte111", FileName = "ann_shared_data.txt" }
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function isLeader()
    return LocalPlayer.Name == Config.LeaderName or LocalPlayer.DisplayName == Config.LeaderName
end

if isLeader() then
    task.spawn(function()
        pcall(function()
            local data = tostring(game.PlaceId) .. "|" .. tostring(game.JobId)
            writefile(Config.FileName, data)
        end)
        print("Äang o Map: " .. game.PlaceId .. " - Server: " .. game.JobId)
    end)
else
    print("Member, wait Leader ...")
    task.spawn(function()
        while task.wait(5) do
            local success, rawData = pcall(function()
                if isfile(Config.FileName) then
                    return readfile(Config.FileName)
                end
            end)
            if success and rawData and rawData ~= "" then
                local splitData = string.split(rawData, "|")
                local targetPlaceId = tonumber(splitData[1])
                local targetJobId = splitData[2]
                if targetPlaceId and targetJobId and targetJobId ~= game.JobId then
                    local cleanJobId = string.gsub(targetJobId, "^%s*(.-)%s*$", "%1")
                    if #cleanJobId == 36 and string.find(cleanJobId, "-") then
                        print("...")
                        local pia = false
                        ---------
                        for i=1,50 do
                            local test = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
                            for k,v in pairs(test) do
                                if v.Count >= 10 and k ~= game.JobId then
                                    pcall(function()
                                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",k)
                                    end)
                                    pia = true
                                    break
                                end
                            end
                            if pia then break end
                        end
                        ---------
                        if pia then break else task.wait(5) end
                    end
                end
            end
        end
    end)
end
