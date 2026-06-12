
local CFG = getgenv().Config
local DungeonHubID = 73902483975735
Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name))
    end
end})
local TeleportService = Services.TeleportService
local Players = Services.Players
local CoreGui = Services.CoreGui
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local plr = Players.LocalPlayer

local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        BackgroundTrans = 0.4,
        Stroke = Color3.fromRGB(150, 150, 150),
        TextLight = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(100, 100, 100),
        Warning = Color3.fromRGB(255, 80, 80)
    }
}
local UI_Elements = {}

local function GetSyncTargets()
    local targets = {}
    local config = getgenv().Config
    if not config then return targets end

    if config["Account Join Raid"] and config["Account Join Raid"].Users then
        for _, v in pairs(config["Account Join Raid"].Users) do
            if v and tostring(v) ~= "" then targets[string.lower(tostring(v))] = true end
        end
    end
    
    if config["Account Join"] and config["Account Join"].Users then
        for _, v in pairs(config["Account Join"].Users) do
            if v and tostring(v) ~= "" then targets[string.lower(tostring(v))] = true end
        end
    end
    
    return targets
end

---------
if game.PlaceId ~= DungeonHubID then
    local function JoinTeam()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("SetTeam", "Pirates")
        end
    end

    local function AutoJoinDungeon()
        task.spawn(function()
            repeat 
                JoinTeam()
                task.wait(0.5)
            until (plr.Team ~= nil and tostring(plr.Team) ~= "Neutral")
            
            task.wait(1.5)
            
            local dungeonRemote = ReplicatedStorage:WaitForChild("Modules")
                :WaitForChild("Net")
                :WaitForChild("RF/DungeonNPCNetworkFunction")
            
            if dungeonRemote then
                local args = {
                    "TeleportToDungeonHub",
                    false
                }
                dungeonRemote:InvokeServer(unpack(args))
            end
        end)
    end

    task.spawn(function()
        while task.wait(1) do
            if plr.Team == nil or tostring(plr.Team) == "Neutral" then
                JoinTeam()
            else
                break 
            end
        end
    end)

    AutoJoinDungeon()

else
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        repeat task.wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end

    local g = Instance.new("ScreenGui")
    g.Name = "Naa_UI_Dark_Theme_Clean_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = plr:WaitForChild("PlayerGui") end
    getgenv().kc = g

    local m = Instance.new("Frame", g)
    m.Name = "Main"
    m.BackgroundColor3 = Themes.Dark.Background
    m.BackgroundTransparency = Themes.Dark.BackgroundTrans
    m.Position = UDim2.new(0.5, 0, 0, -150)
    m.Size = UDim2.new(0, 320, 0, 100)
    m.AnchorPoint = Vector2.new(0.5, 0)

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.0
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)
    table.insert(UI_Elements, {Element = e, Type = "Rotation_Color"})

    local bgGradient = Instance.new("UIGradient", m)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
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
        label.TextSize = 14
        label.TextColor3 = Color3.new(1, 1, 1)
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 0.5
        txtStroke.Color = Themes.Dark.Background
        
        local txtGradient = Instance.new("UIGradient", label)
        table.insert(statusGradients, txtGradient)
        return label, txtGradient
    end

    _G.StatusItemLabel, _G.TopInfoGradient = CreateStatusLabel("TopInfo", 10, "Meyy Hub")
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
    creditLabel.TextColor3 = Themes.Dark.Stroke
    creditLabel.TextXAlignment = Enum.TextXAlignment.Right

    local lastFarmText = ""
    local lastMobText = ""

    function _G.SetFarmStatus(text)
        if text ~= lastFarmText then
            lastFarmText = text
            _G.StatusFarmLabel.Text = text
        end
    end

    function _G.SetMobStatus(text)
        if text ~= lastMobText then
            lastMobText = text
            _G.StatusMobLabel.Text = text
        end
    end

    local r = 0
    task.spawn(function()
        while true do
            local delta = RunService.RenderStepped:Wait()
            r = (r + 1.5) % 360
            
            local c1, c2 = Themes.Dark.TextDark, Themes.Dark.TextLight
            local colorSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1), 
                ColorSequenceKeypoint.new(0.5, c2), 
                ColorSequenceKeypoint.new(1, c1)
            })

            for _, item in ipairs(UI_Elements) do
                if item.Type == "Rotation" then
                    item.Element.Rotation = r
                elseif item.Type == "Rotation_Color" then
                    item.Element.Rotation = r
                    item.Element.Color = colorSeq
                end
            end
            
            for _, grad in ipairs(statusGradients) do
                grad.Rotation = r
                grad.Color = colorSeq
            end
            bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
        end
    end)

    TweenService:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    _G.AccjoinRaid = false
    _G.AccountJoin = false
    _G.StartDuggeon = false
    _G.FoundDungeon = nil
    
    local DungeonRadius = 25 
    local HeightOffset = Vector3.new(0, 100, 0) 
    local WaitingSpot = Vector3.new(-360, 232, -350)

    local Dungeons = {
        {name = "Dungeon 1", center = Vector3.new(-487.545, 232.758, -433.559)},
        {name = "Dungeon 2", center = Vector3.new(-360.278, 232.758, -447.755)},
        {name = "Dungeon 3", center = Vector3.new(-231.965, 232.758, -433.251)},
    }

    local function CreatePlatform(pos)
        local pName = "Meyy_Platform_AntiFall"
        local old = workspace:FindFirstChild(pName)
        if old then old:Destroy() end
        local p = Instance.new("Part")
        p.Name = pName
        p.Size = Vector3.new(20, 1, 20)
        p.CFrame = CFrame.new(pos - Vector3.new(0, 3.5, 0))
        p.Anchored = true
        p.Transparency = 1
        p.CanCollide = true
        p.Parent = workspace
    end

    local function tp(cframe)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = cframe
            CreatePlatform(cframe.Position)
        end
    end

    local function isDungeonSafe(center)
        local allowedUsers = GetSyncTargets()
        local teamInPad = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pPos = player.Character.HumanoidRootPart.Position
                local dist = (Vector2.new(pPos.X, pPos.Z) - Vector2.new(center.X, center.Z)).Magnitude
                if dist <= DungeonRadius then
                    if not allowedUsers[string.lower(player.Name)] then return false, 0 end
                    teamInPad = teamInPad + 1
                end
            end
        end
        return true, teamInPad
    end

    ---------
    
    local function fallbackHop()
        _G.SetFarmStatus("Status: Fallback Hop Started")
        for i = 1, 50 do
            local success, test = pcall(function()
                return ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(i)
            end)
            
            if success and type(test) == "table" then
                for k, v in pairs(test) do
                    if v.Count >= 7 and k ~= game.JobId then
                        _G.SetFarmStatus("Fallback joining: " .. string.sub(tostring(k), 1, 8) .. "...")
                        pcall(function()
                            ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", k)
                        end)
                        if ok then return end 
                        task.wait(3)
                    end
                end
            end
        end
    end
local function getServers(leaderName)
    if not leaderName or leaderName == "" then return {} end
    local url = "https://meyyhub.xyz/api/mainaccount/" .. leaderName
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFunc then return {} end
    
    local success, response = pcall(function()
        return requestFunc({
            Url = url,
            Method = "GET",
            Headers = {["Content-Type"] = "application/json"}
        })
    end)
    if success and response and response.Body and response.Body ~= "" then
        local s, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if s and type(data) == "table" then
            return data
        end
    end
    return {}
end

local function saveServer(leaderName, targets)
    if not leaderName or leaderName == "" then return end
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFunc then return end

    local myTeamInServer = {}
    for _, p in pairs(Players:GetPlayers()) do
        if targets[string.lower(tostring(p.Name))] then
            table.insert(myTeamInServer, string.lower(tostring(p.Name)))
        end
    end

    pcall(function()
        requestFunc({
            Url = "https://meyyhub.xyz/api/mainaccount/" .. leaderName,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                jobid = game.JobId,
                placeid = game.PlaceId,
                count = #Players:GetPlayers(),
                players = myTeamInServer
            })
        })
    end)
end
local function EnsureTeamGathered()
    local targets = GetSyncTargets()
    local requiredCount = 0
    for _ in pairs(targets) do requiredCount = requiredCount + 1 end

    if requiredCount <= 1 then return true end
    
    local leaderName = ""
    local config = getgenv().Config
    if config and config["Account Join Raid"] and config["Account Join Raid"].Users and config["Account Join Raid"].Users[1] then
        leaderName = string.lower(tostring(config["Account Join Raid"].Users[1]))
    end
    task.spawn(function()
        while task.wait(3) do
            if leaderName ~= "" then
                pcall(function()
                    saveServer(leaderName, targets)
                end)
            end
        end
    end)
    while task.wait(5) do
        if leaderName == "" then
            _G.SetFarmStatus("Status: Waiting for Leader Name...")
            if config and config["Account Join Raid"] and config["Account Join Raid"].Users[1] then
                leaderName = string.lower(tostring(config["Account Join Raid"].Users[1]))
            end
        else
            local inServerCount = 0
            for _, p in pairs(Players:GetPlayers()) do
                if targets[string.lower(tostring(p.Name))] then
                    inServerCount = inServerCount + 1
                end
            end
            if inServerCount >= requiredCount then
                _G.SetFarmStatus("Status: Team Gathered!")
                return true
            end
            _G.SetFarmStatus("Syncing Team: " .. inServerCount .. "/" .. requiredCount)
            local data = getServers(leaderName)
            local maxPlayers = Players.MaxPlayers
            local validServers = {}
            if data and data.success and type(data.data) == "table" then
                local srv = data.data
                local serverTime = srv.time or 0
                if os.time() - serverTime <= 30 and srv.placeid == game.PlaceId then
                    local srvCount = srv.count or 0
                    table.insert(validServers, {
                        JobId = srv.jobid,
                        Count = srvCount
                    })
                end
            end
            local needFallback = true
            if #validServers > 0 then
                for i, srv in ipairs(validServers) do
                    if srv.JobId == game.JobId then
                        needFallback = false
                        _G.SetFarmStatus("Status: In Leader Server!")
                        break
                    else
                        _G.SetFarmStatus("Joining Leader: " .. srv.Count .. "/" .. maxPlayers)
                        local teleportSuccess = pcall(function()
                            ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", srv.JobId)
                        end)
                        
                        if teleportSuccess then
                            task.wait(6)
                        end
                    end
                end
            else
                _G.SetFarmStatus("Status: Leader Room Not Found...")
            end
            if needFallback and #validServers == 0 then
                fallbackHop()
            end
        end
    end
end
    ---------
    local function JoinDungeonTeleport()
        while task.wait(0) do
            if _G.AccjoinRaid then
                local padStatus = {}
                for _, d in pairs(Dungeons) do
                    local count = 0
                    local amIHere = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local pPos = p.Character.HumanoidRootPart.Position
                            local dist = (Vector2.new(pPos.X, pPos.Z) - Vector2.new(d.center.X, d.center.Z)).Magnitude
                            if dist <= DungeonRadius then
                                count = count + 1
                                if p == plr then
                                    amIHere = true
                                end
                            end
                        end
                    end
                    padStatus[d.name] = {count = count, amIHere = amIHere, data = d}
                end

                if _G.FoundDungeon then
                    local currentD = nil
                    for _, d in pairs(Dungeons) do 
                        if d.name == _G.FoundDungeon then 
                            currentD = d 
                            break 
                        end 
                    end

                    if currentD then
                        if CFG["ModeJoin"] == "single" then
                            local myPadInfo = padStatus[_G.FoundDungeon]
                            if myPadInfo then
                                if myPadInfo.amIHere then
                                    if myPadInfo.count <= 1 then
                                        _G.SetFarmStatus("Status: Abandoned! Finding new pad...")
                                        _G.FoundDungeon = nil
                                        _G.StartDuggeon = false
                                        task.wait(0.5)
                                    else
                                        local betterPad = nil
                                        local maxBetterCount = myPadInfo.count
                                        
                                        for dName, info in pairs(padStatus) do
                                            if dName ~= _G.FoundDungeon and info.count > 0 and info.count < 5 then
                                                if info.count > maxBetterCount then
                                                    maxBetterCount = info.count
                                                    betterPad = info.data
                                                end
                                            end
                                        end

                                        if betterPad then
                                            _G.SetFarmStatus("Status: Switching to more crowded pad...")
                                            _G.FoundDungeon = betterPad.name
                                            tp(CFrame.new(betterPad.center + HeightOffset))
                                            task.wait(1)
                                            _G.StartDuggeon = true
                                        else
                                            _G.SetFarmStatus("Status: Secured! Waiting Start...")
                                        end
                                    end
                                else
                                    if myPadInfo.count >= 5 then
                                        _G.SetFarmStatus("Status: Pad Full! Changing...")
                                        _G.FoundDungeon = nil
                                        _G.StartDuggeon = false
                                        task.wait(0.5)
                                    end
                                end
                            end
                        else
                            local isSafe, _ = isDungeonSafe(currentD.center)
                            if not isSafe then
                                _G.SetFarmStatus("Status: Stranger detected! Changing...")
                                _G.FoundDungeon = nil
                                _G.StartDuggeon = false
                                task.wait(0.5)
                            end
                        end
                    end
                end
                
                if not _G.FoundDungeon then
                    if CFG["ModeJoin"] == "single" then
                        local bestPad = nil
                        local maxPlayers = 0 
                        local emptyPad = nil
                        
                        for dName, info in pairs(padStatus) do
                            if info.count > 0 and info.count < 5 then
                                if info.count > maxPlayers then
                                    maxPlayers = info.count
                                    bestPad = info.data
                                end
                            elseif info.count == 0 and not emptyPad then
                                emptyPad = info.data
                            end
                        end
                        
                        if bestPad then
                            _G.SetFarmStatus("Status: Entering " .. bestPad.name)
                            _G.FoundDungeon = bestPad.name
                            tp(CFrame.new(bestPad.center + HeightOffset))
                            task.wait(1)
                            _G.StartDuggeon = true
                        elseif emptyPad then
                            _G.SetFarmStatus("Status: Entering " .. emptyPad.name)
                            _G.FoundDungeon = emptyPad.name
                            tp(CFrame.new(emptyPad.center + HeightOffset))
                            task.wait(1)
                            _G.StartDuggeon = true
                        else
                            _G.SetFarmStatus("Status: Pads full! Waiting...")
                            tp(CFrame.new(WaitingSpot + HeightOffset))
                        end
                    else
                        local foundAnyFree = false
                        for _, dungeon in pairs(Dungeons) do
                            local isSafe, count = isDungeonSafe(dungeon.center)
                            if isSafe and count == 0 then
                                foundAnyFree = true
                                _G.SetFarmStatus("Status: Entering " .. dungeon.name)
                                _G.FoundDungeon = dungeon.name
                                tp(CFrame.new(dungeon.center + HeightOffset))
                                task.wait(1)
                                _G.StartDuggeon = true
                                break
                            end
                        end
                        if not foundAnyFree then
                            _G.SetFarmStatus("Status: Pads full! Waiting area...")
                            tp(CFrame.new(WaitingSpot + HeightOffset))
                        end
                    end
                end
            end
        end
    end

    ---------
    local function Accountteleaccjoin()
        local leaderName = ""
        if CFG["Account Join Raid"] and CFG["Account Join Raid"].Users and CFG["Account Join Raid"].Users[1] then
            leaderName = string.lower(CFG["Account Join Raid"].Users[1])
        end
        
        while task.wait(0.5) do
            if _G.AccountJoin then
                local leader = nil
                for _, v in pairs(Players:GetPlayers()) do
                    if string.lower(v.Name) == leaderName then 
                        leader = v 
                        break 
                    end
                end
                
                if leader and leader.Character and leader.Character:FindFirstChild("HumanoidRootPart") then
                    local leaderPos = leader.Character.HumanoidRootPart.Position
                    local currentLeaderPad = nil
                    for _, dungeon in pairs(Dungeons) do
                        local dist = (Vector2.new(leaderPos.X, leaderPos.Z) - Vector2.new(dungeon.center.X, dungeon.center.Z)).Magnitude
                        if dist <= DungeonRadius then 
                            currentLeaderPad = dungeon 
                            break 
                        end
                    end
                    if currentLeaderPad then
                        _G.FoundDungeon = currentLeaderPad.name
                        tp(leader.Character.HumanoidRootPart.CFrame)
                        _G.SetFarmStatus("Status: Joining pad")
                        task.wait(0.5)
                        _G.StartDuggeon = true
                    else
                        _G.SetFarmStatus("Status: Waiting Leader")
                        _G.StartDuggeon = false
                        tp(leader.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-2,2), 0, math.random(-2,2)))
                    end
                else
                    _G.SetFarmStatus("Status: Searching Leader...")
                end
            end
        end
    end

    local function StartDungeon()
        while task.wait(0.5) do
            if _G.StartDuggeon then
                local padName = nil
                if _G.FoundDungeon == "Dungeon 1" then padName = "DUNGEON_TELEPORTER1"
                elseif _G.FoundDungeon == "Dungeon 2" then padName = "DUNGEON_TELEPORTER2"
                elseif _G.FoundDungeon == "Dungeon 3" then padName = "DUNGEON_TELEPORTER3" end
                if padName then
                    pcall(function()
                        local padsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Simulation Hub") and workspace.Map["Simulation Hub"]:FindFirstChild("Pads")
                        local pad = padsFolder and padsFolder:FindFirstChild(padName)
                    end)
                    _G.StartDuggeon = false
                end
            end
        end
    end

    ---------
    local function Init()
        EnsureTeamGathered()

        local name = string.lower(plr.Name)
        local isLeader, isMember = false, false
        
        if CFG["Account Join Raid"] and CFG["Account Join Raid"].Users then
            for _, v in pairs(CFG["Account Join Raid"].Users) do 
                if string.lower(v) == name then isLeader = true end 
            end
        end
        if CFG["Account Join"] and CFG["Account Join"].Users then
            for _, v in pairs(CFG["Account Join"].Users) do 
                if string.lower(v) == name then isMember = true end 
            end
        end

        if isLeader then
            _G.SetMobStatus("Status: Raid Leader")
            _G.AccjoinRaid = true
            task.spawn(JoinDungeonTeleport)
            task.spawn(StartDungeon)
        elseif isMember then
            _G.SetMobStatus("Status: Join Member")
            _G.AccountJoin = true
            task.spawn(Accountteleaccjoin)
            task.spawn(StartDungeon)
        else
            _G.SetMobStatus("Status: Not in Config")
        end
    end

    task.spawn(Init)

    task.spawn(function()
        while task.wait(0.5) do 
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and _G.FoundDungeon then
                local currentPadName = _G.FoundDungeon:gsub("Dungeon ", "DUNGEON_TELEPORTER")
                local padsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Simulation Hub") and workspace.Map["Simulation Hub"]:FindFirstChild("Pads")
                local pad = padsFolder and padsFolder:FindFirstChild(currentPadName)
                
                if pad then
                    if CFG["ModeJoin"] == "single" then
                        pcall(function() pad.DungeonSettingsChanged:FireServer("Start") end)
                    else
                        local currentD = nil
                        for _, d in pairs(Dungeons) do 
                            if d.name == _G.FoundDungeon then currentD = d break end 
                        end
                        if currentD then
                            local isSafe, _ = isDungeonSafe(currentD.center)
                            if isSafe then
                                pcall(function() pad.DungeonSettingsChanged:FireServer("Start") end)
                            end
                        end
                    end
                end
            end
        end
    end)
    ---------
    task.spawn(function()
        local lastDiffSent = ""
        while task.wait(2) do
            pcall(function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local diff = tostring(getgenv().Config["Select Difficulty"])
                local padsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Simulation Hub") and workspace.Map["Simulation Hub"]:FindFirstChild("Pads")
                if padsFolder then
                    for _, d in pairs(Dungeons) do
                        local padName = d.name:gsub("Dungeon ", "DUNGEON_TELEPORTER")
                        if (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(d.center.X, d.center.Z)).Magnitude <= 20 then
                            if lastDiffSent ~= diff then
                                local pad = padsFolder:FindFirstChild(padName)
                                if pad and pad:FindFirstChild("DungeonSettingsChanged") then
                                    pad.DungeonSettingsChanged:FireServer("Difficulty", diff)
                                    lastDiffSent = diff
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end
---------
while true do
    pcall(function()
        -- Chỉ return hub khi đang ở trong dungeon, không phải hub
        if game.PlaceId == DungeonHubID then
            local dungeonShared = game:GetService("ReplicatedStorage"):FindFirstChild("DungeonShared")
            if dungeonShared then
                local returnToHub = dungeonShared:FindFirstChild("ReturnToHub")
                if returnToHub then
                    returnToHub:FireServer()
                end
            end
        end
    end)
    task.wait(5)
end
---------
