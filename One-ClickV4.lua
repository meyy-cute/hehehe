

_G.updateStatus = function(text) end

if workspace:GetAttribute("MAP") and workspace:GetAttribute("MAP") ~= "Sea3" then
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end
if not isfile("cachejobid.json") then
    writefile("cachejobid.json", "{}")
end
if not isfile("cache_v4.json") then
    writefile("cache_v4.json", "{}")
end
local B,A = pcall(function ()
    return  game.HttpService:JSONDecode(readfile("cache_v4.json"))
end)
if not B then
    A = {}
end
local isallies = {}
if getgenv().Config and getgenv().Config["Allies Account"] then
    for i, v in pairs(getgenv().Config["Allies Account"]) do
        isallies[v] = true
    end
end
isaccmain = {}
if getgenv().Config and getgenv().Config["Main Account"] then
    for i, v in pairs(getgenv().Config["Main Account"]) do
        isaccmain[v] = true
    end
end
local plr = game.Players.LocalPlayer
A[game.JobId] = math.floor(tick())
writefile("cache_v4.json", game.HttpService:JSONEncode(A))
function thuaaa()
    if game:GetService("Players").LocalPlayer.Team then return end
    if getgenv().Team == "Marines" or not getgenv().Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    elseif getgenv().Team == "Pirates" then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
end
if getgenv().Team == "Marines" or not getgenv().Team then
	thuaaa()
elseif getgenv().Team == "Pirates" then
	thuaaa()
end
local L_207_ = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ChooseTeam", true)
local L_208_ = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UIController", true)

if L_207_ and L_207_.Visible  then
	repeat
		task.wait(1)
		if L_207_ and L_207_.Visible and L_208_ then
			for L_209_forvar0, L_210_forvar1 in pairs(getgc(true)) do
				if type(L_210_forvar1) == "function" and getfenv(L_210_forvar1).script == L_208_ then
					local L_211_ = getconstants(L_210_forvar1)
					pcall(function()
						if (L_211_[1] == "Pirates" or L_211_[1] == "Marines") and #L_211_ == 1 then
							if L_211_[1] == getgenv().Team then
								L_210_forvar1(getgenv().Team)
							end
						end
					end)
				end
			end
		end

	until game:GetService("Players").LocalPlayer.Team
end

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
if not isfile("noguchi/fruitdatas.json") then
    writefile("noguchi/fruitdatas.json", game:HttpGet("https://raw.githubusercontent.com/noguchihyuga/bin/refs/heads/main/fruitdatas.json"))
end


getgenv().Config["Team"] = getgenv().Config["Team"] and (getgenv().Config["Team"] == "Marines" or getgenv().Config["Team"] == "Pirates") and getgenv().Config["Team"] or "Marines"
for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
    if v:FindFirstChild("ChooseTeam") then
        local thua = v.ChooseTeam.Container[getgenv().Config["Team"]].Frame.TextButton
        firesignal(thua.Activated)
    end
end

local module = loadstring(game:HttpGet("https://github.com/noguchihyuga/idk/blob/main/module_bf.lua?raw=true"))()
local topofgreattree = CFrame.new(3035.15137, 2281.15918, -7325.19189, 0.0284484141, 2.19495124e-08, 0.999595284, -3.29094476e-08, 1, -2.10217994e-08, -0.999595284, -3.22980895e-08, 0.0284484141)

function getdoor(vv)
    vv = vv or game:GetService("Players").LocalPlayer.Data.Race.Value
    return workspace.Map["Temple of Time"]:WaitForChild(vv .. "Corridor"):WaitForChild("Door").Entrance
end

function getdis(...)
    return module:getdis(...)
end
local topos = function (v)
    pcall(function ()
        if getdis(v) > 2500 and getdis(CFrame.new(28310.0234, 14895.1123, 109.456741, - 0.469690144, - 2.85620132e-08, - 0.882831335, - 3.23509219e-08, 1, - 1.51411736e-08, 0.882831335, 2.14487486e-08, - 0.469690144)) < 1500 then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
        end
    end)
    return module:topos(v)
end
local pos_plr_trial = {
    CFrame.new(28692.3477, 14887.5605, -53.7669983, 0.707131445, -0, -0.707082093, 0, 1, -0, 0.707082093, 0, 0.707131445),
    CFrame.new(28782.7246, 14898.9902, -59.6069946, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247),
    CFrame.new(28700.875, 14888.2598, -154.110992, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    CFrame.new(28795.7715, 14888.2598, -112.917999, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247),
    CFrame.new(28658.4551, 14888.2598, -121.372009, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298),
    CFrame.new(28742.4688, 14887.5596, -18.2120056, 0.92051065, 0, 0.390717506, 0, 1, 0, -0.390717506, 0, 0.92051065)
}

function isplrshouldkill(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
        for i, v in pairs(pos_plr_trial) do
            if getdis(plr.Character.HumanoidRootPart.CFrame, v) < 5 then
                return true
            end
        end
    end
    return false
end

local race_abilities = { 
    ["Human"] = "Last Resort", 
    ["Mink"] = "Agility", 
    ["Fishman"] = "Water Body", 
    ["Skypiea"] = "Heavenly Blood", 
    ["Ghoul"] = "Heightened Senses",
    ["Cyborg"] = "Energy Core",
    ["Draco"] = "Primordial Reign"
} 
local races_trial_place = { 
    ["Human"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of Strength"), 
    ["Mink"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of Speed"), 
    ["Fishman"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of Water"), 
    ["Skypiea"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of the King"), 
    ["Ghoul"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of Carnage"),
    ["Cyborg"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of the Machine"),
    ["Draco"] = workspace._WorldOrigin.Locations:WaitForChild("Trial of Flames")
} 
_G.playersinserver = {}
function updateplayers()
    if not _G.playersinserver then _G.playersinserver = {} end
    local players = {}
    for i, v in pairs(game.Players:GetChildren()) do
        if true then
            players[v] = {
                ["Race"] = v.Data.Race.Value,
                ["Door"] = (function ()
                    local x,y = pcall(function ()
                        return workspace.Map["Temple of Time"]:WaitForChild(v.Data.Race.Value .. "Corridor"):WaitForChild("Door"):WaitForChild("Entrance")
                    end)
                    if x then
                        return y
                    end
                    return nil
                end)()
            }
        end
    end
    _G.playersinserver = players
end

function isshouldturnonability()
    local count = 0
    for i, v in pairs(workspace.Characters:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name and v:FindFirstChild("HumanoidRootPart") then
            local theirrace = game.Players:FindFirstChild(v.Name).Data.Race.Value
            if theirrace == "Draco" then
            else
                local race_door = workspace.Map["Temple of Time"]:FindFirstChild(theirrace .. "Corridor"):FindFirstChild("Door"):FindFirstChild("Entrance")
                if getdis(race_door.CFrame, v.HumanoidRootPart.CFrame) < 10 then
                    if v.HumanoidRootPart:FindFirstChild(race_abilities[game.Players:WaitForChild(v.Name).Data.Race.Value]) then
                        count = count + 1
                    end
                end
            end
        end
    end
    if count >= 2 then
        return true
    end
    return false
end

function checkfullgear()
    
end

function talktoonggianaodo()
    local thua = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
    if thua == 1 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check");
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin");
    elseif thua == 2 then
        repeat
            wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport");
            topos(CFrame.new(3028, 2281, -7325))
        until module:getdis(CFrame.new(28286.35546875, 14896.5078125, 102.62469482422)) <= 15
    else
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check");
		wait(1);
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue");
    end
end

function getBlueGear()
	if not game.workspace.Map:FindFirstChild("MysticIsland") then
		return nil
	end
	for o, c in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
		if c:IsA("MeshPart") and c.MeshId == "rbxassetid://10153114969" then
			return c
		end
	end
end

function isnight()
	local c = game.Lighting.ClockTime;
	if c >= 16 or c < 5 then
		return true
    end
	return false
end
function isfullmoon()
    return game:GetService("Lighting"):GetAttribute("MoonPhase") == 5
end
module:noclip([[return true]])
function getmob1(pos)
    local allmobs = {}
    for i, v in pairs(workspace.Enemies:GetChildren())  do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and getdis(v.HumanoidRootPart.CFrame, pos) < 1000 then
            table.insert(allmobs, v)
        end
    end
    return allmobs
end
function checkmob_(v)
    return v and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0
end
function noideaforname(v)
    if isallies[v.Name] then
        return false
    end
    return true
end

function getplayers()
    local plrs = {}
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and not isaccmain[v.Name] and noideaforname(v) then
            if v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                for _, pos in pairs(pos_plr_trial) do
                    if getdis(v.Character.HumanoidRootPart.CFrame, pos) < 10 then
                        plrs[v.Character] = true
                    end
                end
            end
        end
    end
    return plrs
end
function checkbackpack(v)
	return game.Players.LocalPlayer.Backpack:FindFirstChild(v) or game.Players.LocalPlayer.Character:FindFirstChild(v)
end
function getdialogoftemple()
    if not game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then return "You have yet to achieve greatness" end
    local i, d, f = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
    return i == 5 and "You Are Done Your Race"
        or i == 6 and "Upgrades completed: " .. d - 2 .. "/3, Need Trains More"
        or (i == 1 or i == 3) and "Please Train More"
        or (i == 2 or i == 4 or i == 7) and "You Can Buy Gear With " .. f .. " Fragments"
        or i == 0 and ("You Are Ready For Trial [Gear: ".. d .. "]")
        or i ~= 8 and "You have yet to achieve greatness"
        or "Remaining " .. 10 - d .. " training sessions."
end
function trialable()
    if not game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        local abcxyz = checkbackpack(race_abilities[game:GetService("Players").LocalPlayer.Data.Race.Value])
        if abcxyz then
            return true
        end
        return false
    end
    local i,d,f = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
    if i == 5 then
        return false
    else
        if i == 6 then
            return false, d-2
        elseif i == 1 or i == 3 then
            return false
        elseif i == 2 or i == 4 or i == 7 then
                if f then
                    local totalfragments = tonumber(f)
                    if game:GetService("Players").LocalPlayer.Data.Fragments.Value >= totalfragments then
                        game:GetService("ReplicatedStorage")["Remotes"]["CommF_"]:InvokeServer("UpgradeRace", "Buy")
                    else
                        return false, "raiding"
                    end
                end
            return false, f
        elseif i == 0 then
            return true, d
        elseif i ~= 8 then
            return false
        else
            return true, 10 - d
        end
    end
end
function checkisvalidjobid(a)
    local b = game.HttpService:JSONDecode(readfile("cachejobid.json"))
    if not b[a] or tick() - b[a] > 3600 then
        return true
    end
    return false
end

local Gears = {
    "Alpha",
    "Omega"
}
function getnameofgear()
    for i, v in pairs(workspace.Map["Temple of Time"].InnerClock:GetChildren()) do
        if v:IsA("MeshPart") and v:FindFirstChild("Highlight") and v.Highlight.FillTransparency == 1 then
            return v.Name
        end
    end
end

---------
function status(v)
    if _G.updateStatus then
        _G.updateStatus(v)
    end
    _G.statusnow = v
end
---------

function followMainAccount()
    if isaccmain[game.Players.LocalPlayer.Name] then
        return true
    end
    local sameServer = false
    pcall(function()
        for _, mainName in pairs(getgenv().Config["Main Account"]) do
            local ok, dataplr = pcall(function()
                return game.HttpService:JSONDecode(game:HttpGet("https://meyyhub.xyz/api/mainaccount/" .. mainName))
            end)
            if ok and dataplr and dataplr["data"] then
                local jobid = dataplr["data"]["jobid"]
                local time  = dataplr["data"]["time"]
                local tick_ = gettimeserver()
                if tick_ - time < 30 then
                    if jobid == game.JobId then
                        sameServer = true
                        break
                    else
                        status("Follow main: " .. mainName)
                        game.ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobid)
                        break
                    end
                end
            end
        end
    end)
    return sameServer
end
getgenv().FailedJobIds = {}
getgenv().LastApiRefresh = 0
local apiUrlMap = {
    ["Fullmoon"]        = 'http://fi11.bot-hosting.net:20758/api/name=Fullmoon'
}
local function HopToServerByAPI(filterNames, maxPlayers, waitTime)
    isHopping = true
    maxPlayers = maxPlayers or 10
    waitTime = waitTime or 25
    apiUrl = apiUrlMap[filterNames]
    if not apiUrl then
        print("[Hop] Không tìm thấy API cho: " .. tostring(filterNames))
        return false
    end

    if tick() - getgenv().LastApiRefresh > 600 then
        getgenv().FailedJobIds = {}
        getgenv().LastApiRefresh = tick()
    end

    local CURRENT_PLACE_ID = game.PlaceId

    local ok, result = pcall(function()
        local HttpService = game:GetService("HttpService")
        local responseBody
        pcall(function() responseBody = game:HttpGet(apiUrl) end)
        if not responseBody then
            local reqFunc = (syn and syn.request) or request or http.request
            local req = reqFunc({ Url = apiUrl, Method = "GET" })
            responseBody = req.Body
        end
        local data = HttpService:JSONDecode(responseBody)
        if not data or not data.success or type(data.data) ~= "table" then
            print(" API trả về dữ liệu sai")
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
        print(" Tìm thấy " .. #filtered .. " server hợp lệ")
        local triedCount = 0
        for _, server in ipairs(filtered) do
            local jobId = server.jobid
            local players = server.players

            if jobId == game.JobId then continue end
            if getgenv().FailedJobIds[jobId] then continue end
            if players >= maxPlayers then continue end

            triedCount = triedCount + 1
            print(" " .. filterNames .. " | " .. players .. " người | Đang join...")
            local teleportOk = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobId)
            end)
            if teleportOk then
                task.wait(15)
                return true
            else
                getgenv().FailedJobIds[jobId] = tick()
                print(" Không vào được server #" .. triedCount)
                task.wait(1)
            end
        end
        print(" Hết server phù hợp | Đợi API cập nhật...")
        for i = waitTime, 1, -1 do
            if getgenv().StopV3 then return false end
            print(" Đợi API: " .. i .. "s | " .. filterNames)
            task.wait(1)
        end
        return false
    end)
    return ok and result
end
function checkgear()
    local success, dt = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "Check")
    end)
    
    if success and dt and type(dt) == "table" then
        if dt.HadPoint then
            local gearStr = getgenv().Config["Gear"] or "red-blue-red"
            if gearStr == "" then gearStr = "red-blue-red" end
            
            local g1, g2, g3 = gearStr:match("^(.-)%-(.-)%-(.-)$")
            if not (g1 and g2 and g3) then
                g1, g2, g3 = "red", "blue", "red"
            end
            
            local function parseGear(val)
                if not val then return "Alpha" end
                local v = string.lower(tostring(val))
                v = v:match("^%s*(.-)%s*$") or v
                
                if v == "đỏ" or v == "red" or v == "a" then 
                    return "Alpha" 
                elseif v == "xanh" or v == "blue" or v == "b" then 
                    return "Omega" 
                end
                return "Alpha"
            end

            local a23 = {
                [2] = parseGear(g1),
                [3] = parseGear(g2),
                [4] = parseGear(g3)
            }
            
            local lvl = dt.RaceDetails and dt.RaceDetails.Completed or 1
            local choosegear = (lvl == 1 or lvl == 5) and "Blank" or (a23[lvl] or "Alpha")
            
            local a = dt.RaceDetails and dt.RaceDetails.A or 0
            local b = dt.RaceDetails and dt.RaceDetails.B or 0
            
            local gearKey = "Gear" .. tostring(lvl)
            
            if a >= 2 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", gearKey, "Omega")
            elseif b >= 2 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", gearKey, "Alpha")
            else
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", gearKey, choosegear)
            end
            print("Gear chosen:", gearKey, choosegear)
        end
    end
end

CheckAlive = function(x)
    return x and x.Parent and x:FindFirstChild("Humanoid") and x:FindFirstChild("HumanoidRootPart") and
        x:FindFirstChild("Humanoid").Health > 0
end
TweenObject = function(Object, Pos, Speed)
    if Speed == nil then Speed = 350 end
    local Distance = (Pos.Position - Object.Position).Magnitude
    local tweenService = game:GetService("TweenService")
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    tween1 = tweenService:Create(Object, info, { CFrame = Pos })
    tween1:Play()
end

GetMobPosition = function(EnemiesName)
    local pos = Vector3.new(0, 0, 0)
    local count = 0
    for r, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == EnemiesName and v:FindFirstChild("HumanoidRootPart") then
            if not pos then
                pos = v.HumanoidRootPart.Position
            else
                pos = pos + v.HumanoidRootPart.Position
            end
            count = count + 1
        end
    end
    if count > 0 then
        return pos / count
    end
    return nil
end

BringMob = function(value)
    if value then
        local ememe = game.Workspace.Enemies:GetChildren()
        if #ememe > 0 then
            local totalpos = {}
            for i, v in pairs(ememe) do
                if not totalpos[v.Name] then
                    totalpos[v.Name] = GetMobPosition(v.Name)
                end
            end
            for i, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == value.Name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                    if v.Humanoid.MaxHealth > 50000 then continue end
                    if (v.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 350 then
                        for k, f in pairs(totalpos) do
                            if k and v.Name == k and f then
                                Gay = CFrame.new(f.X, f.Y, f.Z)
                                Cac = (v.HumanoidRootPart.Position - Gay.Position).Magnitude
                                if Cac > 3 and Cac <= 280 then
                                    TweenObject(v.HumanoidRootPart, Gay, 300)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid:ChangeState(14)
                                    sethiddenproperty(plr, "SimulationRadius", math.huge)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

Kill = function(gg, thua)
    pcall(function()
        if setsimulationradius then setsimulationradius(50000) end
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 5000)
    end)
    if not gg or typeof(gg) ~= "Instance" or not CheckAlive(gg) then return end
    local mobName = gg.Name
    local function GetTotalHealthNearby()
        local total = 0
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == mobName
                and v:FindFirstChild("Humanoid")
                and v:FindFirstChild("HumanoidRootPart")
                and (v.HumanoidRootPart.Position - hrp.Position).Magnitude <= 100
            then
                total = total + v.Humanoid.Health
            end
        end
        return total
    end
    local lastTotalHealth = GetTotalHealthNearby()
    local lastHealthTime  = os.clock()
    local gg2
    if not gg or not CheckAlive(gg) then return end
    repeat
        if thua and not thua() then break end
        if not CheckAlive(gg) then break end
        task.wait()
        BringMob(gg)
        local currentHealth = GetTotalHealthNearby()
        if currentHealth < lastTotalHealth then
            lastTotalHealth = currentHealth
            lastHealthTime  = os.clock()
        elseif currentHealth > lastTotalHealth then
            lastTotalHealth = currentHealth
        else
            if os.clock() - lastHealthTime >= 15 then
                break
            end
        end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and not hrp:FindFirstChild("KillFloat") then
            gg2 = Instance.new("BodyVelocity")
            gg2.Name = "KillFloat"
            gg2.Parent = hrp
            gg2.MaxForce = Vector3.new(0, 9e9, 0)
            gg2.Velocity  = Vector3.zero
        end
        topos(gg:GetPivot() * CFrame.new(0, 20, 0))
    until not gg or not gg.Parent or not CheckAlive(gg) or not (thua and thua())
    if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
        plr.Character.HumanoidRootPart.BodyClip:Destroy()
    end
end

_G.ShouldSendData = false
local issobusy = false
spawn(function ()
    while wait() do
    local checktempledoor = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CheckTempleDoor")
        if not checktempledoor then
            status("Lever chưa pull")
        else
            _G.ShouldSendData = false
            local ab,AB = trialable()
            if not ab then
                status("Training")
                if AB == "raiding" then
                    local boss = workspace.Enemies:FindFirstChild("Cake Prince") or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or workspace.Enemies:FindFirstChild("Dough King") or game:GetService("ReplicatedStorage"):FindFirstChild("Dough King")
                    if boss then
                        repeat
                            wait()
                            pcall(function ()
                                topos(boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                            end)
                            module:eq()
                            module:haki()
                        until not checkmob_(boss)
                    end
                    status("Raiding for fragment")
                else
                    pcall(function ()
                        if game.Players.LocalPlayer.Character.RaceEnergy.Value == 1 then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
		                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                        end
                    end)
                    local pos__ = CFrame.new(214.688675, 126.626984, -12600.2236, -0.180400655, -1.09679892e-08, 0.983593225, 1.94620693e-08, 1, 1.47204746e-08, -0.983593225, 2.17983427e-08, -0.180400655)
                    if getdis(pos__) < 1500 then
                        local mobs = getmob1(pos__)
                        for i, v in pairs(mobs) do
                            repeat
                                wait()
                                module:eq()
                                module:haki()
                                pcall(function ()
                                    if game.Players.LocalPlayer.Character.RaceTransformed.Value then
                                        status("Training (Wait for end V4)")
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 150, 0))
                                    else
                                        status("Training (Kill Mobs)")
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                    end
                                end)
                                spawn(function ()
                                    pcall(function ()
                                        if game.Players.LocalPlayer.Character.RaceEnergy.Value == 1 then
                                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                                        end
                                    end)
                                end)
                            until not checkmob_(v)
                        end
                    else
                        topos(pos__)
                    end
                end
            elseif isnight() and isfullmoon() or issobusy then
                if not followMainAccount() then
                else
                if isaccmain[game.Players.LocalPlayer.Name] and getgenv().Config["Hop Server FullMoon"] then
                    local isInFullmoonServer = isfullmoon()
                    if not isInFullmoonServer then
                        HopToServerByAPI("Fullmoon", 12, 2)
                    end
                end
                spawn(checkgear)
                _G.ShouldSendData = true
                if not workspace.Map:FindFirstChild("Temple of Time") then
                    if game:GetService("ReplicatedStorage").MapStash:FindFirstChild("Temple of Time") then
                        local templeconcac = game:GetService("ReplicatedStorage").MapStash:FindFirstChild("Temple of Time")
                        templeconcac.Parent = workspace.Map
                    end
                elseif workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0 then
                    if true then
                        status("Kill Players After Trial")
                        for plr, i in pairs(getplayers()) do
                            if plr then
                                repeat
                                    wait()
                                    pcall(function ()
                                        topos(plr.HumanoidRootPart.CFrame * CFrame.new((function ()
                                            local x,y,z = 0,3,0
                                            x = math.random(1, 4)
                                            z = math.random(1, 4)
                                            if math.random(1,2) == 1 then
                                                x = x * -1
                                            end
                                            if math.random(1,2) == 1 then
                                                z = z * -1
                                            end
                                            
                                            return x,y,z
                                        end)()))
                                    end)
                                until not plr or not plr.Parent or not plr:FindFirstChild("Humanoid") or not plr:FindFirstChild("HumanoidRootPart") or plr.Humanoid.Health <= 0 or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 1
                            end
                        end
                        if #getplayers() <= 0 then
                            if not isaccmain[game.Players.LocalPlayer.Name] and getgenv().Config["Reset After Trial"] then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            end
                        end
                    end
                else
                    local race_trial_place
                    if races_trial_place[game:GetService("Players").LocalPlayer.Data.Race.Value] then
                        race_trial_place = races_trial_place[game:GetService("Players").LocalPlayer.Data.Race.Value]
                    end
                    if race_trial_place and getdis(race_trial_place.CFrame) < 1500 then
                        status("Doing trial")
                        local myrace = game.Players.LocalPlayer.Data.Race.Value
                        if myrace == "Mink" then
                            pcall(function ()
                                topos(workspace.Map.MinkTrial.Ceiling.CFrame)
                            end)
                        elseif myrace == "Skypiea" then
                            pcall(function ()
                                topos(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
                            end)
                        elseif myrace == "Cyborg" then
                            pcall(function ()
                                topos(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
                            end)
                        elseif myrace == "Human" or myrace == "Ghoul" then
                            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    if getdis(v.HumanoidRootPart.CFrame, race_trial_place.CFrame) < 1500 then
                                        repeat
                                            wait()
                                            module:eq()
                                            module:haki()
                                            pcall(function ()
                                                topos(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 30, 0))
                                            end)
                                        until not v or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0
                                    end
                                end
                            end
                        elseif myrace == "Fishman" then
                            for i,v in pairs(workspace.SeaBeasts:GetChildren()) do
                                pcall(function ()
                                    if v:FindFirstChild('Health') and v.Health.Value > 0 and v:FindFirstChild("HumanoidRootPart") and getdis(v.HumanoidRootPart.CFrame, race_trial_place) < 1500 then
                                        repeat
                                            wait()
                                            if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") then
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                                            end
                                            topos(v.HumanoidRootPart.CFrame*CFrame.new(0,500,0))
                                            _G.SHOULDSPAMSKILLS = true
                                        until not v or not v:FindFirstChild('Health') or v.Health.Value <= 0 or not v:FindFirstChild("HumanoidRootPart")
                                        _G.SHOULDSPAMSKILLS = false
                                    end
                                end)
                            end
                        end
                    else
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Timer.Visible == false then
                            local khang
                            repeat wait()
                                khang = getdoor()
                            until khang ~= nil
                            if getdis(khang.CFrame) < 1500 then
                                topos(khang.CFrame)
                                status("Ready for trialing")
                                if isshouldturnonability() then
                                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                                end
                            else
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741, - 0.469690144, - 2.85620132e-08, - 0.882831335, - 3.23509219e-08, 1, - 1.51411736e-08, 0.882831335, 2.14487486e-08, - 0.469690144))
                            end
                        end
                    end
                end
                end
            else
                if not isaccmain[game.Players.LocalPlayer.Name] then
                    status("Following main")
                    followMainAccount()
                else
                    status("Waiting fullmoon")
                    if getgenv().Config["Hop Server FullMoon"] then
                        print("hop")
                        HopToServerByAPI("Fullmoon", 12, 2)
                    end
                end
            end
        end
    end
end)

local fruits = {
	['Buddha-Buddha'] = true,
	['T-Rex-T-Rex'] = true,
	['Dragon-Dragon'] = true,
	['Yeti-Yeti'] = true,
	['Leopard-Leopard'] = true,
	['Venom-Venom'] = true,
	['Phoenix-Phoenix'] = true,
	['Kitsune-Kitsune'] = true,
	['Mammoth-Mammoth'] = true,
	['Gas-Gas'] = true,
    ["Portal-Portal"] = true,
}

local isvalidtooltip = {
    ["Melee"] = true,
    ["Blox Fruit"] = true,
    ["Sword"] = true,
    ["Gun"] = true
}
local isvalidnameui = {
    ["Z"]=true,["X"]=true,["C"]=true,["V"]=true,["F"]=true
}

function getallweapon()
    local weapon = {}
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and isvalidtooltip[v.ToolTip] then
            table.insert(weapon, v)
        end
    end
    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and isvalidtooltip[v.ToolTip] then
            table.insert(weapon, v)
        end
    end
    return weapon
end
function EquipTool(v)
	local thua = game.Players.LocalPlayer.Backpack:FindFirstChild(v)
	if thua then
		game.Players.LocalPlayer.Character.Humanoid:EquipTool(thua)
	end
end

spawn(function ()
    while wait() do
        if _G.SHOULDSPAMSKILLS then
            local weapon = getallweapon()
            for i, v in pairs(weapon) do
                if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(v.Name) then
                    EquipTool(v.Name)
                end
            end
            for i, v in pairs(weapon) do
                if v.Parent ~= game.Players.LocalPlayer.Character then
                    EquipTool(v.Name)
                end
                local ui_ = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(v.Name)
                if ui_ then
                    for _, vl in pairs(ui_:GetChildren()) do
                        if isvalidnameui[vl.Name] then
                            local cooldown_frame,title_frame = vl:WaitForChild("Cooldown"), vl:WaitForChild("Title")
                            if title_frame.TextColor3 == Color3.new(1,1,1) or title_frame.TextColor3 == Color3.fromRGB(255,255,255) then
                                if cooldown_frame.Size == UDim2.new(0, 0, 1, -1) then
                                    if vl.Name == "V" then
                                        if not fruits[ui_.Name] then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
                                            wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
                                            wait(1.5)
                                        end
                                    else
                                        game:service('VirtualInputManager'):SendKeyEvent(true, vl.Name, false, game)
                                        wait(0.1)
                                        game:service('VirtualInputManager'):SendKeyEvent(false, vl.Name, false, game)
                                        wait(1.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local Ec = game["Players"]["LocalPlayer"]
local function Bc(x)
	if not x then
		return false
	end
	local L = x:FindFirstChild("Humanoid")
	return L and L["Health"] > 0
end
local function Pc(x, L)
	local a2 = (game:GetService("Workspace"))["Enemies"]:GetChildren()
	local V = (game:GetService("Players")):GetPlayers()
	local H = {}
	local r = (x:GetPivot())["Position"]
    local leader = nil
	for x, a in ipairs(V) do
		if a ~= Ec and not isaccmain[a.Name] and a["Character"] and noideaforname(a) then
			local x = a["Character"]:FindFirstChild("HumanoidRootPart")
			if x and Bc(a["Character"]) then
				local V = (x["Position"] - r)["Magnitude"]
				if V <= L then
					table["insert"](H, a["Character"])
				end
			end
		end
	end
    for x, a in ipairs((game:GetService("Workspace"))["Enemies"]:GetChildren()) do
		local x = a:FindFirstChild("HumanoidRootPart")
			if x and Bc(a) then
				local V = (x["Position"] - r)["Magnitude"]
				if V <= L then
					table["insert"](H, a)
				end
			end
	end
	return H
end
loadstring(game:HttpGet("https://pastefy.app/X6xLHpIv/raw?part=attack.lua"))()
CameraShakerR = require(game["ReplicatedStorage"]["Util"]["CameraShaker"])
CameraShakerR:Stop()

spawn(function()
	while wait() do
        module:haki()
	end
end)
function gettimeserver()
    return tonumber(game:HttpGet("http://fi6.bot-hosting.net:21934/timeserver"))
end

spawn(function()
    while wait(1) do
        if isaccmain[game.Players.LocalPlayer.Name] then
            pcall(function()
                local response = (http_request or http and http.request or request)({
                    ["Url"] = "https://meyyhub.xyz/api/mainaccount/" .. game.Players.LocalPlayer.Name,
                    ["Method"] = "POST",
                    ["Headers"] = {
                        ["Content-Type"] = "application/json"
                    },
                    ["Body"] = game.HttpService:JSONEncode({ ["jobid"] = game.JobId }),
                })
            end)
        end
    end
end)

_G[game.Players.LocalPlayer.Name] = true
getgenv().UseSeaUi = true

---------
local PREFIX = "MeyyHub-"
local KEY = {0x4D,0x65,0x79,0x79,0x48,0x75,0x62}
local ALPHA = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_!"
local ALPHA_MAP = {}
for i = 1, #ALPHA do ALPHA_MAP[ALPHA:sub(i,i)] = i-1 end
local bxor = bit32.bxor
local function rshift(n,b) return math.floor(n/(2^b)) end

local function decode(encoded)
    local code = encoded
    if code:sub(1,#PREFIX) == PREFIX then code = code:sub(#PREFIX+1) end
    if #code < 2 then return nil end
    local indices = {}
    for i = 1,#code do
        local idx = ALPHA_MAP[code:sub(i,i)]
        if not idx then return nil end
        indices[#indices+1] = idx
    end
    local checkIdx = indices[#indices]
    indices[#indices] = nil
    local buf,bits,xored = 0,0,{}
    for _,idx in ipairs(indices) do
        buf = buf*64+idx
        bits = bits+6
        if bits >= 8 then
            bits = bits-8
            xored[#xored+1] = rshift(buf,bits)%256
            buf = buf%(2^bits)
        end
    end
    local checksum = 0
    for _,b in ipairs(xored) do checksum = (checksum+b)%256 end
    if checksum%64 ~= checkIdx then return nil end
    local chars = {}
    for i,b in ipairs(xored) do
        chars[#chars+1] = string.char(bxor(b, KEY[((i-1)%#KEY)+1]))
    end
    return table.concat(chars)
end
---------
if getgenv().Config.BetaUi then
    ---------
    local CoreGui, Players, RunService, TweenService, LocalPlayer = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("Players").LocalPlayer
    local ContentProvider = game:GetService("ContentProvider")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")

    local g = Instance.new("ScreenGui")
    g.Name = "meyyy_hub_kaitun_v4_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    getgenv().MainUI = g

    local m = Instance.new("Frame", g)
    m.Name = "MainFrame"
    m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    m.BackgroundTransparency = 0.15
    m.Size = UDim2.new(0, 800, 0, 550)
    m.Position = UDim2.new(0.5, 0, 0.43, 0)
    m.AnchorPoint = Vector2.new(0.5, 0.5)

    ---------
    local uiScale = Instance.new("UIScale", m)
    local function updateScale()
        local screenSize = workspace.CurrentCamera.ViewportSize
        local targetWidth, targetHeight = 840, 590
        local scaleX = screenSize.X / targetWidth
        local scaleY = screenSize.Y / targetHeight
        local finalScale = math.min(1, scaleX, scaleY)
        uiScale.Scale = finalScale
    end
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    ---------

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 30)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 4
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)

    local bgGradient = Instance.new("UIGradient", m)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 245, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })

    local RotateGradients = {e}

    local cte = Instance.new("ImageLabel", m) 
    cte.Name = "FloatingCloud"
    cte.Size = UDim2.new(0, 220, 0, 220) 
    cte.Position = UDim2.new(1, -160, 0, 210) 
    cte.AnchorPoint = Vector2.new(0.5, 0.5)
    cte.BackgroundTransparency = 1 
    cte.Image = "rbxthumb://type=Asset&id=127594918515956&w=420&h=420" 
    cte.ScaleType = Enum.ScaleType.Fit
    cte.ZIndex = 5 

    local snow = Instance.new("ImageLabel", m)
    snow.Name = "FloatingSnow"
    snow.Size = UDim2.new(0, 220, 0, 220)
    snow.Position = UDim2.new(0, 160, 0, 210) 
    snow.AnchorPoint = Vector2.new(0.5, 0.5)
    snow.BackgroundTransparency = 1
    snow.Image = "rbxthumb://type=Asset&id=137906289429512&w=420&h=420"
    snow.ScaleType = Enum.ScaleType.Fit
    snow.ZIndex = 5

    task.spawn(function()
        ContentProvider:PreloadAsync({cte, snow})
    end)

    local function ApplyButtonEffects(btn, text)
        local originalSize = btn.Size
        btn.ClipsDescendants = true 
        
        btn.Text = "" 
        
        local label = Instance.new("TextLabel", btn)
        label.Name = "ButtonText"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = 20
        label.TextColor3 = Color3.new(1, 1, 1)
        label.ZIndex = btn.ZIndex + 1
        
        local ts = Instance.new("UIStroke", label)
        ts.Thickness = 1.5
        ts.Color = Color3.fromRGB(160, 210, 230)
        
        local tg = Instance.new("UIGradient", label)
        table.insert(RotateGradients, tg)

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 4)
                }):Play()
                local ripple = Instance.new("Frame", btn)
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.5
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                ripple.Position = UDim2.new(0, input.Position.X - btn.AbsolutePosition.X, 0, input.Position.Y - btn.AbsolutePosition.Y)
                Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
                local targetSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.5
                local t = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetSize, 0, targetSize), BackgroundTransparency = 1})
                t:Play() t.Completed:Connect(function() ripple:Destroy() end)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = originalSize}):Play()
            end
        end)
        
        return label 
    end

    local statusGradients = {}
    local function CreateLabel(name, parent, pos, size, text, textSize, align)
        local l = Instance.new("TextLabel", parent)
        l.Name = name
        l.Size = size
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = text
        l.TextSize = textSize
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextXAlignment = align or Enum.TextXAlignment.Center
        local ts = Instance.new("UIStroke", l)
        ts.Thickness = 2
        ts.Color = Color3.fromRGB(160, 210, 230)
        local tg = Instance.new("UIGradient", l)
        table.insert(statusGradients, tg)
        return l
    end

    local Title = CreateLabel("Title", m, UDim2.new(0, 0, 0, 30), UDim2.new(1, 0, 0, 50), "Meyy Hub - Kaitun V4", 40, Enum.TextXAlignment.Center)

    local InfoContainer = Instance.new("Frame", m)
    InfoContainer.Size = UDim2.new(1, -80, 0, 220)
    InfoContainer.Position = UDim2.new(0, 40, 0, 110)
    InfoContainer.BackgroundTransparency = 1

    local RaceLabel = CreateLabel("Race", InfoContainer, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), "Current Race: Checking...", 26, Enum.TextXAlignment.Center)
    local VersionLabel = CreateLabel("Version", InfoContainer, UDim2.new(0, 0, 0, 55), UDim2.new(1, 0, 0, 40), "Race Version: V0", 26, Enum.TextXAlignment.Center)
    local TierLabel = CreateLabel("Tier", InfoContainer, UDim2.new(0, 0, 0, 110), UDim2.new(1, 0, 0, 40), "Race Tier: 0", 26, Enum.TextXAlignment.Center)

    local StatusLabel = CreateLabel("StatusLabel", InfoContainer, UDim2.new(0, 0, 0, 165), UDim2.new(1, 0, 0, 35), "Status: Initializing...", 22, Enum.TextXAlignment.Center)

    ---------
    _G.updateStatus = function(text)
        pcall(function()
            if StatusLabel then
                StatusLabel.Text = "Status: " .. tostring(text)
            end
        end)
    end
    ---------

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local CommF_ = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
                local raceRaw = LocalPlayer.Data.Race.Value
                local raceMap = {Fishman="Shark", Skypiea="Angel", Mink="Rabbit"}
                RaceLabel.Text = "Current Race: " .. (raceMap[raceRaw] or raceRaw)
                VersionLabel.Text = "Race Version: V" .. tostring(CommF_:InvokeServer("getRaceLevel"))
                TierLabel.Text = "Race Tier: " .. tostring(LocalPlayer.Data.Race.C.Value)
            end)
        end
    end)

    local ActionContainer = Instance.new("Frame", m)
    ActionContainer.Size = UDim2.new(1, -80, 0, 200)
    ActionContainer.Position = UDim2.new(0, 40, 0, 350) 
    ActionContainer.BackgroundTransparency = 1

    local JobInput = Instance.new("TextBox", ActionContainer)
    JobInput.Size = UDim2.new(0, 430, 0, 55)
    JobInput.Position = UDim2.new(0, 0, 0, 0)
    JobInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    JobInput.BackgroundTransparency = 0.5
    JobInput.Font = Enum.Font.Gotham
    JobInput.PlaceholderText = "Enter Job ID here..."
    JobInput.Text = ""
    JobInput.TextColor3 = Color3.fromRGB(50, 50, 50)
    JobInput.TextSize = 18
    Instance.new("UICorner", JobInput).CornerRadius = UDim.new(0, 12)

    local JobInputStroke = Instance.new("UIStroke", JobInput)
    JobInputStroke.Thickness = 2.5
    JobInputStroke.Color = Color3.new(1, 1, 1)
    JobInputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local JobInputGrad = Instance.new("UIGradient", JobInputStroke)
    table.insert(RotateGradients, JobInputGrad)

    local JoinBtn = Instance.new("TextButton", ActionContainer)
    JoinBtn.Size = UDim2.new(0, 135, 0, 55)
    JoinBtn.Position = UDim2.new(0, 440, 0, 0)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.BackgroundTransparency = 0.3
    JoinBtn.AutoButtonColor = false
    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 12)
    local JoinBtnStroke = Instance.new("UIStroke", JoinBtn)
    JoinBtnStroke.Thickness = 2.5
    JoinBtnStroke.Color = Color3.new(1, 1, 1)
    JoinBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RotateGradients, Instance.new("UIGradient", JoinBtnStroke))
    local JoinLabel = ApplyButtonEffects(JoinBtn, "Join Job")

    local CopyBtn = Instance.new("TextButton", ActionContainer)
    CopyBtn.Size = UDim2.new(0, 135, 0, 55)
    CopyBtn.Position = UDim2.new(0, 585, 0, 0)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.BackgroundTransparency = 0.3
    CopyBtn.AutoButtonColor = false
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 12)
    local CopyBtnStroke = Instance.new("UIStroke", CopyBtn)
    CopyBtnStroke.Thickness = 2.5
    CopyBtnStroke.Color = Color3.new(1, 1, 1)
    CopyBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RotateGradients, Instance.new("UIGradient", CopyBtnStroke))
    local CopyLabel = ApplyButtonEffects(CopyBtn, "Copy ID")

    local HopBtn = Instance.new("TextButton", ActionContainer)
    HopBtn.Size = UDim2.new(0, 720, 0, 55)
    HopBtn.Position = UDim2.new(0, 0, 0, 70) 
    HopBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HopBtn.BackgroundTransparency = 0.3
    HopBtn.AutoButtonColor = false
    Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 12)
    local HopBtnStroke = Instance.new("UIStroke", HopBtn)
    HopBtnStroke.Thickness = 2.5
    HopBtnStroke.Color = Color3.new(1, 1, 1)
    HopBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RotateGradients, Instance.new("UIGradient", HopBtnStroke))
    local HopLabel = ApplyButtonEffects(HopBtn, "Server Hop")

    JoinBtn.MouseButton1Click:Connect(function()
        local idToJoin = string.gsub(JobInput.Text or "", "^%s*(.-)%s*$", "%1")
        if idToJoin:sub(1, #PREFIX) == PREFIX then
            idToJoin = decode(idToJoin)
        end
        if idToJoin and #idToJoin == 36 and string.find(idToJoin, "-") then 
            JoinLabel.Text = "Joining..."
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, idToJoin, LocalPlayer) end)
            task.wait(2) JoinLabel.Text = "Join Job"
        else
            JoinLabel.Text = "Invalid ID!"
            task.wait(2) JoinLabel.Text = "Join Job"
        end
    end)

    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(tostring(game.JobId)) end)
        CopyLabel.Text = "Copied!"
        task.wait(2)
        CopyLabel.Text = "Copy ID"
    end)

    HopBtn.MouseButton1Click:Connect(function()
        HopLabel.Text = "Hopping..."
        pcall(function()
            HopToServerByAPI("Fullmoon", 12, 2)
        end)
        task.wait(2) HopLabel.Text = "Server Hop"
    end)

    local r = 0
    RunService.RenderStepped:Connect(function()
        r = (r + 1.5) % 360
        local colorSeq = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 230, 255)), ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 230, 255))})
        for _, grad in ipairs(RotateGradients) do grad.Rotation = r grad.Color = colorSeq end
        for _, grad in ipairs(statusGradients) do grad.Rotation = r grad.Color = colorSeq end
        local floatValue = math.sin(tick() * 2) * 15 
        cte.Position = UDim2.new(1, -160, 0, 210 + floatValue) 
        snow.Position = UDim2.new(0, 160, 0, 210 - floatValue) 
        bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.1, 0)
    end)
	m.ClipsDescendants = true
    m.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(m, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 800, 0, 550)}):Play()

    local isUiVisible = true
    local toggleBtn = Instance.new("TextButton", g)
    toggleBtn.Name = "ToggleMenu"
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(1, -45, 0, 15)
    toggleBtn.AnchorPoint = Vector2.new(1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Text = "♡♡"
    toggleBtn.TextColor3 = Color3.fromRGB(150, 200, 220)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.AutoButtonColor = false

    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(1, 0)

    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Thickness = 2.5
    toggleStroke.Color = Color3.new(1, 1, 1)

    local toggleGrad = Instance.new("UIGradient", toggleStroke)
    table.insert(RotateGradients, toggleGrad)

    local btnScale = Instance.new("UIScale", toggleBtn)

    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(btnScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
        end
    end)

    toggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local bounce = TweenService:Create(btnScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1.3})
            bounce:Play()
            bounce.Completed:Connect(function()
                TweenService:Create(btnScale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)

            isUiVisible = not isUiVisible
            if isUiVisible then
                TweenService:Create(m, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 800, 0, 550)}):Play()
            else
                TweenService:Create(m, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            end
        end
    end)
    local g_notif = Instance.new("ScreenGui")
    g_notif.Name = "Naa_UI_Cloud_Theme_Clean_" .. math.random(100, 999)
    g_notif.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g_notif.Parent = CoreGui end)
    if not g_notif.Parent then g_notif.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local m_notif = Instance.new("Frame", g_notif)
    m_notif.Name = "Main"
    m_notif.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    m_notif.BackgroundTransparency = 0.3
    m_notif.Position = UDim2.new(1, 50, 1, -120) 
    m_notif.Size = UDim2.new(0, 260, 0, 80)
    m_notif.AnchorPoint = Vector2.new(1, 1)

    local mainCorner_notif = Instance.new("UICorner", m_notif)
    mainCorner_notif.CornerRadius = UDim.new(0, 10)

    local u_notif = Instance.new("UIStroke", m_notif)
    u_notif.Thickness = 2.5
    u_notif.Color = Color3.new(1, 1, 1)
    local e_notif = Instance.new("UIGradient", u_notif)

    local bgGradient_notif = Instance.new("UIGradient", m_notif)
    bgGradient_notif.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
    })

    local statusGradients_notif = {}
    local function CreateStatusLabel(name, pos, text, size)
        local label = Instance.new("TextLabel", m_notif)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = size or 12
        label.TextColor3 = Color3.new(1, 1, 1)
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 1.2
        txtStroke.Color = Color3.fromRGB(150, 200, 220)
        
        local txtGradient = Instance.new("UIGradient", label)
        table.insert(statusGradients_notif, txtGradient)
        return label
    end

    local titleLabel = CreateStatusLabel("Title", 12, "Meyy Hub", 20)
    local subLabel = CreateStatusLabel("Subtitle", 40, "Script Activated", 12)

    local r_notif = 0
    local renderSteppedConn
    renderSteppedConn = RunService.RenderStepped:Connect(function()
        r_notif = (r_notif + 1.5) % 360
        e_notif.Rotation = r_notif
        
        local c1, c2 = Color3.fromRGB(180, 220, 255), Color3.new(1, 1, 1)
        local colorSeq = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c1)})
        e_notif.Color = colorSeq
        
        for _, grad in ipairs(statusGradients_notif) do
            grad.Rotation = r_notif
            grad.Color = colorSeq
        end
        
        bgGradient_notif.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
    end)

    local showTween = TweenService:Create(m_notif, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -20)})
    showTween:Play()

    task.delay(3, function()
        local hideTween = TweenService:Create(m_notif, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -20)})
        hideTween:Play()
        
        hideTween.Completed:Connect(function()
            if renderSteppedConn then renderSteppedConn:Disconnect() end
            g_notif:Destroy()
        end)
    end)
    ---------
else
    ---------
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Library.lua"))()

    local Window = Library:CreateWindow({
        Title = "Meyy Hub Premium"
    })

    local MainTab = Window:CreateTab("Main", true, "rbxassetid://6031090990")
    local AccountTab = Window:CreateTab("Account", false, "rbxassetid://6031795301")

    MainTab:CreatePageTitle("System Status")
    local StatusUI = MainTab:CreateParagraph("Status Log", "Initializing...")

    _G.updateStatus = function(text)
        pcall(function()
            StatusUI:SetDesc("Status: " .. tostring(text))
        end)
    end

    MainTab:CreatePageTitle("Server Management")

    _G.JobIdInput = ""
    MainTab:CreateInput(
        "Job ID",
        "Enter Job ID here...",
        function(Value)
            _G.JobIdInput = Value
        end
    )

    MainTab:CreateButton(
        "Teleport",
        "Join the specified Job ID",
        function()
            local realJobId = _G.JobIdInput
            if realJobId:sub(1, #PREFIX) == PREFIX then
                realJobId = decode(realJobId)
            end
            if realJobId and realJobId ~= "" then
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", realJobId)
            end
        end
    )

    MainTab:CreateButton(
        "Copy Job ID",
        "Copy current server ID to clipboard",
        function()
            setclipboard(tostring(game.JobId))
        end
    )

    MainTab:CreateButton(
        "Server Hop",
        "Hop to another public server",
        function()
            HopToServerByAPI("Fullmoon", 12, 2)
        end
    )

    AccountTab:CreatePageTitle("Global Configuration")

    local allPlayers = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        table.insert(allPlayers, v.Name)
    end

    AccountTab:CreateMultiDropdown(
        "Select Help Trial Accounts",
        getgenv().Config["Allies Account"] or {},
        allPlayers,
        "Select accounts to assist in trial",
        function(selectedItems)
            getgenv().Config["Allies Account"] = selectedItems
            isallies = {}
            for i, v in pairs(selectedItems) do 
                isallies[v] = true 
            end
        end
    )

    local currentMain = "None"
    if getgenv().Config["Main Account"] and getgenv().Config["Main Account"][1] then
        currentMain = getgenv().Config["Main Account"][1]
    end

    AccountTab:CreateDropdown(
        "Select Main Account",
        currentMain,
        allPlayers,
        "Select the primary account to follow",
        function(selected)
            getgenv().Config["Main Account"] = {selected}
            isaccmain = {}
            isaccmain[selected] = true
        end
    )

    AccountTab:CreateDropdown(
        "Select Gear Upgrade",
        (getgenv().Config["Gear"] ~= "" and getgenv().Config["Gear"]) or "Red-Blue-Red",
        {"Red-Blue-Red", "Blue-Red-Blue"},
        "Choose your preferred gear upgrade path",
        function(selectedValue)
            getgenv().Config["Gear"] = selectedValue
        end
    )

    AccountTab:CreateSwitch(
        "Reset After Trial",
        getgenv().Config["Reset After Trial"],
        "Automatically reset character when trial finishes",
        function(state)
            getgenv().Config["Reset After Trial"] = state
        end
    )

    AccountTab:CreateSwitch(
        "Kick Moon",
        getgenv().Config["KickMoon"],
        "Disconnect if moon conditions are met",
        function(state)
            getgenv().Config["KickMoon"] = state
        end
    )

    AccountTab:CreateSwitch(
        "Auto Hop FullMoon",
        true,
        "Hop automatically to find full moon",
        function(state)
            getgenv().Config["Hop Server FullMoon"] = state
        end
    )

    AccountTab:CreatePageTitle("Allies Connection Status")

    spawn(function()
        local allyParagraphs = {}
        while task.wait(5) do
            pcall(function()
                for _, allyName in pairs(getgenv().Config["Allies Account"]) do
                    if not allyParagraphs[allyName] then
                        allyParagraphs[allyName] = AccountTab:CreateParagraph("Ally: " .. allyName, "Waiting for data...")
                        AccountTab:CreateButton("Join " .. allyName, "Teleport to this ally's server", function()
                            local jobidnow = allyParagraphs[allyName].JobIdStr
                            if jobidnow then
                                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", jobidnow)
                            end
                        end)
                    end
                    
                    local dataplr = game.HttpService:JSONDecode(game:HttpGet("https://meyyhub.xyz/api/mainaccount/" .. allyName))
                    if dataplr and dataplr["data"] then
                        local jobid, time = dataplr["data"]["jobid"], dataplr["data"]["time"]
                        local t = gettimeserver()
                        allyParagraphs[allyName]:SetDesc(jobid .. " | " .. tostring(t-time) .. "s ago")
                        allyParagraphs[allyName].JobIdStr = jobid
                    end
                end
            end)
        end
    end)
    ---------
end
