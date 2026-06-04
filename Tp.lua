local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local newdao = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
local cframenpc = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)
local plr = game:GetService("Players").LocalPlayer
local place_check = game.PlaceId
sea1 = (place_check == 2753915549 or place_check == 85211729168715)
sea2 = (place_check == 4442272183 or place_check == 79091703265657)
sea3 = (place_check == 7449423635 or place_check == 100117331123089)
newsea = (place_check == 73902483975735)
if not (sea1 or sea2 or sea3 or newsea) then
    plr:Kick("You are not in the correct game!")
end
module = loadstring(game:HttpGet("https://raw.githubusercontent.com/asher-realrise/project/refs/heads/main/module.lua"))()

local Player = game.Players.LocalPlayer
spawn(function()
    while task.wait() do
        pcall(function()
            local plrChar = Player.Character
            if not plrChar then return end 
            if noclip then
                for _, part in pairs(plrChar:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
                if plrChar:FindFirstChild("Stun") and plrChar.Stun.Value ~= 0 then
                    plrChar.Stun.Value = 0
                end
                if plrChar:FindFirstChild("Busy") and plrChar.Busy.Value then
                    plrChar.Busy.Value = false
                end
            else
                if plrChar:FindFirstChild("HumanoidRootPart") then
                    if plrChar.HumanoidRootPart.CanCollide == false then
                        for _, part in pairs(plrChar:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        end)
    end
end)
local Players = game.Players
Client = Players.LocalPlayer
tweenPause = false
tweenActive = false
function vector3tocframe(pos)
	return CFrame.new(pos.X, pos.y, pos.Z)
end
local currentTween = nil
local noclipConn = nil

function _tp_(targetCFrame)

	local Players_ = game:GetService("Players")
	local player_ = Players_.LocalPlayer
	local char__ = player_.Character or player_.CharacterAdded:Wait()
	local hrp__ = char__:WaitForChild("HumanoidRootPart")
	local distance = (hrp__.Position - targetCFrame.Position).Magnitude
	local speed = distance / 350
	local tweenInfo = TweenInfo.new(
        speed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
	local tween = TweenService:Create(
        hrp__,
        tweenInfo,
        {
		CFrame = targetCFrame
	}
    )
	tween:Play()
	return tween
end
function totopofgreattree()
	if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741, - 0.469690144, - 2.85620132e-08, - 0.882831335, - 3.23509219e-08, 1, - 1.51411736e-08, 0.882831335, 2.14487486e-08, - 0.469690144)) > 1500 then
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741, - 0.469690144, - 2.85620132e-08, - 0.882831335, - 3.23509219e-08, 1, - 1.51411736e-08, 0.882831335, 2.14487486e-08, - 0.469690144))
		wait(0.3)
	end
	_tp_(CFrame.new(28607.5352, 14896.5449, 106.011726, 0.328121185, -1.85622113e-08, -0.94463563, 5.12445304e-08, 1, -1.85023141e-09, 0.94463563, -4.78003095e-08, 0.328121185))
	repeat
		wait()
		-- _tp_(CFrame.new(3028, 2281, -7325))
	until module:getdis(CFrame.new(28607.5352, 14896.5449, 106.011726, 0.328121185, -1.85622113e-08, -0.94463563, 5.12445304e-08, 1, -1.85023141e-09, 0.94463563, -4.78003095e-08, 0.328121185)) <= 5
	wait(0.5)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack");
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack");
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack");
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack");
end
function stt()
	pcall(function()
		currentTween:Cancel()
		currentTween:Cancel()
	end)
end

function checkinventory(v)
	if v then
		for i, vl in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
			if vl.Name == v then
				return true
			end
		end
	end
	return false
end
function requestentrance(pos)
	local tb = {}
	if sea1 then
		tb = {
			["Sky3"] = Vector3.new(-7894, 5547, -380),
			["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
			["UnderWater"] = Vector3.new(61163, 11, 1819),
			["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
			["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
			["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
		}
	elseif sea2 then
		tb = {
			["Swan Mansion"] = Vector3.new(-390, 332, 673),
			["Swan Room"] = Vector3.new(2285, 15, 905),
			["Cursed Ship"] = Vector3.new(923, 126, 32852),
			["Zombie Island"] = Vector3.new(-6509, 83, -133)
		}
	else
		tb = {
			-- ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),      game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5036, 315, -3179))
			["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
			["Mansion"] = Vector3.new(-12462, 375, -7552),
			["Castle"] = Vector3.new(-5036, 315, -3179),
			-- ["Dimensional Shift"] = Vector3.new(-2097.3447265625, 4776.24462890625, -15013.4990234375),
			-- ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
			-- ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768e-08, -1.99111154e-13, -2.14762768e-08, 1, -3.0510602e-08, 1.98455903e-13, 3.0510602e-08, 1),
			["Temple of Time"] = Vector3.new(28286, 14897, 103),
			-- ["Tiki1"] = Vector3.new(-5086.18408203125, 314.5509948730469, -3157.518798828125),
			-- ["Tiki2"] = Vector3.new(-16813.439453125, 58.2912712097168, 304.87396240234375),
			["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793, -0.997071385, 4.84440612e-08, -0.0764761642, 4.10272314e-08, 1, 9.85533504e-08, 0.0764761642, 9.51271204e-08, -0.997071385)
		}
		if not checkinventory("Valkyrie Helm") then
			return
		end
	end
	local x, y = nil, math.huge
	for i, v in pairs(tb) do
		local cframe = vector3tocframe(v)
		if (v - pos.Position).Magnitude < y then
			y = (v - pos.Position).Magnitude
			x = v
		end
	end
	if x and y and y < getdis(pos) then
		pcall(function ()
			_G.TweenCache:Cancel()
			_G.TweenCache:Cancel()
		end)
		if x == Vector3.new(3024.1709, 2280.69434, -7325.12793, -0.997071385, 4.84440612e-08, -0.0764761642, 4.10272314e-08, 1, 9.85533504e-08, 0.0764761642, 9.51271204e-08, -0.997071385) and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2 then
			totopofgreattree()
			wait(1)
		elseif y < getdis(pos) then
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", x)
			wait(1)
		end
	end
end
print("ok")
function getdis(a,b)
    b = b or Player.Character.HumanoidRootPart.CFrame
    local _a = CFrame.new(a.X, b.Y, a.Z)
    local _b = CFrame.new(b.X,b.Y,b.Z)
    return (_a.Position - _b.Position).Magnitude
end

Util = Util or {}
Util.FPSTracker = Util.FPSTracker or { FPS = 60 }
setfpscap = setfpscap or function() end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Settings = {
    ["Tween Speed"] = 350,
    ["Bypass Teleport"] = true,
    ["Up Y"] = false,
    ["Up Y When Low Health"] = false,
    ["Same Y"] = false
}


function WaitForHumanoid()
    local Character = LocalPlayer.Character
    if not Character then return nil end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then return Humanoid end
    
    local timeout = tick() + 5
    while tick() < timeout do
        Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then return Humanoid end
        task.wait(0.1)
    end
    return nil
end

function Convert_CFrame(x)
    if not x then return end
    return (typeof(x) == "Vector3" and CFrame.new(x)) or (typeof(x) == "CFrame" and x) or (typeof(x) == "Model" and x:GetPivot()) or x.CFrame
end

function GetDistance(POS_1, POS_2, NO_Y)
    if POS_1 == nil then return 9e9 end
    
    local Character = LocalPlayer.Character
    if not Character then return 9e9 end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return 9e9
    end
    
    if POS_2 == nil then
        POS_2 = Character:FindFirstChild("HumanoidRootPart")
        if not POS_2 then return 9e9 end
    end
    local pos1 = Convert_CFrame(POS_1)
    local pos2 = Convert_CFrame(POS_2)
    if NO_Y then
        return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
    else
        return (pos1.Position - pos2.Position).Magnitude
    end
end

function InArea(POS)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin then return {Name = ""} end
    
    for i,v in next, WorldOrigin.Locations:GetChildren() do
        if (Convert_CFrame(POS).Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end


function GetSpawnPoint(x)
    local Spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
    if not Spawns then return end
    
    for i,v in next, Spawns:GetChildren() do
        if (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
end

function CanBypassTeleport(x)
    local AreaName = InArea(x).Name
    if AreaName == "" then return false end
    if not Settings["Bypass Teleport"] or AreaName:find("Dimension") or AreaName:find("Submerged") or AreaName == "Sealed Cavern" or AreaName:lower():find("under") or CheckLegendaryItems() then
        return false
    end
    if LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then return false end
    if GetDistance(x.Position) <= 3500 then
        return false
    end
    return true
end

function GetBypassCFrame(x)
    local Max = math.huge
    local Pos
    local Spawns = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
    local HRP = LocalPlayer.Character.HumanoidRootPart    
    for i,v in next, Spawns do
        if (x.Position - HRP.Position).Magnitude >= 3000 
        and GetSpawnPoint(v.Part) ~= GetSpawnPoint(HRP) 
        and (v.Part.Position - HRP.Position).Magnitude <= 10000 
        and (v.Part.Position - x.Position).Magnitude <= Max then
            Max = (v.Part.Position - x.Position).Magnitude
            Pos = v
        end
    end
    return Pos
end

function BypassTP(Target)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = WaitForHumanoid()
    if not Humanoid or Humanoid.Health <= 0 then return end
    
    if CanBypassTeleport(Target) and GetBypassCFrame(Target) then
        local TargetTP = GetBypassCFrame(Target)
        Character.LastSpawnPoint.Disabled = true
        CommF_:InvokeServer("SetLastSpawnPoint", TargetTP.Name)
        CommF_:InvokeServer("SetSpawnPoint")
        Character:PivotTo(TargetTP.Part.CFrame)
        Humanoid:ChangeState(15)
        
        repeat task.wait() until LocalPlayer.Character and WaitForHumanoid() and WaitForHumanoid().Health > 0
    end
end
local getdis = function (...)
	return module:getdis(...)
end
function vector3tocframe(pos)
	return CFrame.new(pos.X, pos.y, pos.Z)
end
function CheckItem(ITEM_NAME)
    for i,v in next, LocalPlayer.Backpack:GetChildren() do
        if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
    end
    for i,v in next, LocalPlayer.Character:GetChildren() do
        if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
    end
end

function CheckLegendaryItems()
    if CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1") then
        return true
    end
    return false
end

local Player = game.Players
local Local_Player = Player.LocalPlayer
local Char = Local_Player.Character
local Root = Char.HumanoidRootPart
Players = game.Players
recentlySpawn = 0
SeaIndex = sea3 and 3 or sea2 and 2 or sea1 and 1 and newsea or Local_Player:Kick("Didn't update this Sea")
CanTeleport = {
    {
        ["Sky3"] = Vector3.new(-7894, 5547, -380),
        ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
        ["UnderWater"] = Vector3.new(61163, 11, 1819),
        ["UnderwaterExit"] = Vector3.new(4050, -1, -1814),
    },
    {
        ["Swan Mansion"] = Vector3.new(-390, 332, 673),
        ["Swan Room"] = Vector3.new(2285, 15, 905),
        ["Cursed Ship"] = Vector3.new(923, 126, 32852),
        ["Zombie Island"] = Vector3.new(-6509, 83, -133),
    },
    {
        ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
        ["Hydra Island"] = Vector3.new(5745, 610, -267),
        ["Mansion"] = Vector3.new(-12462, 375, -7552),
        ["Castle"] = Vector3.new(-5036, 315, -3179),
        ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
        ["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768e-08, -1.99111154e-13, -2.14762768e-08, 1, -3.0510602e-08, 1.98455903e-13, 3.0510602e-08, 1),
        ["Temple of Time"] = Vector3.new(28286, 14897, 103),
    }
} -- i dont remove cuz anti error variable

dist = function(a, b, noHeight)
    local vector_a = Vector3.new(a.X, not noHeight and a.Y or 0, a.Z)

    local success, result = pcall(function()
        if not b then
            while true do
                local Root = Local_Player.Character and Local_Player.Character:FindFirstChild("HumanoidRootPart")
                if Root and Root.Position then
                    b = Root.Position
                    break
                end
                wait(.5) 
            end
        end

        local vector_b = Vector3.new(b.X, not noHeight and b.Y or 0, b.Z)
        return (vector_a - vector_b).magnitude
    end)

    if success then
        return result
    else
        warn("Dist", result)
        return nil
    end
end

InArea = function(Pos,Location)
    local nearest,scale = nil,0
    if Location then
        if dist(Pos,Location.Position,true) <= (Location.Mesh.Scale.X/2)+500 then
            return Location
        end
    end
    for i,v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        if dist(Pos,v.Position,true) <= (v.Mesh.Scale.X/2)+500 then
            if scale < v.Mesh.Scale.X then
                scale = v.Mesh.Scale.X
                nearest = v
            end
        end
    end
    return nearest
end
local network = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/Module/main/network.lua'))()
CollectionService = game:GetService("CollectionService")
Use_Remote = function(...)
    local ARGS = {...}
    local Data = network:Send("CommF_",...)
    if ARGS[1] == "requestEntrance" then
        CollectionService:AddTag(Local_Player,"Teleporting")
        task.delay(3,function()
            CollectionService:RemoveTag(Local_Player,"Teleporting")
        end)
        wait(.25)
    end
    return Data
end
function old_tp(...)
    local function Convert_To_CFrame(value)
        if typeof(value) == "Vector3" then
            return CFrame.new(value)
        elseif typeof(value) == "CFrame" then
            return value
        else
            return nil
        end
    end
    local target = Convert_To_CFrame(...)
    if not Local_Player.Character:FindFirstChild("HumanoidRootPart") then return end
    if tweenPause then return end
    local thisId
    local s, e = pcall(function()
        if tweenActive and lastTweenTarget and (dist(target, lastTweenTarget) < 10 or dist(lastTweenTarget) >= 10) then
            return
        end        
        tweenid = (tweenid or 0) + 1 
        lastTweenTarget = target
        thisId = tweenid
        Util = require(game:GetService("ReplicatedStorage").Util)
        if Util.FPSTracker.FPS > 60 then
            setfpscap(60) 
        end    
        task.spawn(pcall, function()
            lastPos = {tick(), target}
            local RootPart = Local_Player.Character.HumanoidRootPart
            local Humanoid = Local_Player.Character.Humanoid
            local currentDistance = dist(RootPart.Position, target, true)
            local oldDistance = currentDistance
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            if currentDistance > 60 then
                RootPart.CFrame = CFrame.new(RootPart.Position.X, RootPart.Position.Y + 200, RootPart.Position.Z)
            else
                RootPart.CFrame = CFrame.new(target.Position.X, target.Position.Y, target.Position.Z)
            end
            local NoclipLoop
            local NoclipVelocity
            if not RootPart:FindFirstChild("BodyClip") then
                NoclipVelocity = Instance.new("BodyVelocity")
                NoclipVelocity.Name = "BodyClip"
                NoclipVelocity.Parent = RootPart
                NoclipVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                NoclipVelocity.Velocity = Vector3.zero
            end
            NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
                local Character = Local_Player.Character
                if Character then
                    for _, v in pairs(Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end
                end
            end)
            while Local_Player.Character:FindFirstChild("HumanoidRootPart") and currentDistance > 75 and thisId == tweenid and Humanoid.Health > 0 do
                local FPS = math.clamp(Util.FPSTracker.FPS, 1, 60)
                local Percent = (58 / FPS)
                local Speed = 6 * Percent
                local Current = RootPart.Position
                local Dift = Vector3.new(target.X, 0, target.Z) - Vector3.new(Current.X, 0, Current.Z)
                local Sx = (Dift.X < 0 and -1 or 1) * Speed
                local Sz = (Dift.Z < 0 and -1 or 1) * Speed
                local SpeedX = math.abs(Dift.X) < Sx and Dift.X or Sx
                local SpeedZ = math.abs(Dift.Z) < Sz and Dift.Z or Sz
                task.spawn(function()
                    currentDistance = dist(RootPart.Position, target, true)
                    if currentDistance > oldDistance + 10 then
                        tweenid = -1
                        tweenPause = true
                        RootPart.Anchored = true
                        task.wait(1)
                        tweenPause = false
                        RootPart.Anchored = false
                    end
                    oldDistance = currentDistance
                end)           
                RootPart.CFrame = RootPart.CFrame + Vector3.new(
                    math.abs(SpeedZ) < (5 * Percent) and SpeedX or SpeedX / 1.5, 
                    0, 
                    math.abs(SpeedX) < (5 * Percent) and SpeedZ or SpeedZ / 1.5
                )                
                tweenActive = true
                task.wait()
            end
            if NoclipLoop then NoclipLoop:Disconnect() end
            pcall(function()
                if RootPart:FindFirstChild("BodyClip") then
                    RootPart.BodyClip:Destroy()
                end
                local Character = Local_Player.Character
                if Character then
                    for _, part in ipairs(Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)            
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            tweenActive = false         
            if currentDistance <= 100 and thisId == tweenid then
                RootPart.CFrame = target
            end
        end)
    end) 
    if not s then warn("tween bug::", e) end
    return thisId
end

---------
getgenv().TP = function(pos, ...)
	local gg = Convert_CFrame(pos)
	if not gg then return end
	pcall(function()
		if CanBypassTeleport(gg) then
			BypassTP(gg)
			task.wait(0.5)
		end
	end)
	requestentrance(pos)
    if sea3 and getdis(pos, newdao.Position) < 2000 then
        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
        if math.abs(newdao.Position.Y - hrp.CFrame.Y) > 1000 then
            repeat
                task.wait()
                old_tp(cframenpc)
                if getdis(cframenpc) < 10 then
                local net = game:GetService("ReplicatedStorage").Modules.Net
                net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
                task.wait(0.5)
                net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
               end
            until getdis(pos) < 2000
            task.wait(0.6)
            pcall(function()
                hrp.BodyClip:Destroy()
            end)
        end
    end
    return old_tp(gg, ...)
end
---------

getgenv().stoptp = function()
    _G.abcyxzzz = -1
end

VirtualUser = game:GetService("VirtualUser")

Client.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

if not _G.Config_ then
	_G.Config_ = {}
end

