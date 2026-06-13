
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local place_check = game.PlaceId
local sea1 = (place_check == 2753915549 or place_check == 85211729168715)
local sea2 = (place_check == 4442272183 or place_check == 79091703265657)
local sea3 = (place_check == 7449423635 or place_check == 100117331123089)
local newsea = (place_check == 73902483975735)

if not (sea1 or sea2 or sea3 or newsea) then
    LocalPlayer:Kick("You are not in the correct game!")
end

local SeaIndex = sea3 and 3 or sea2 and 2 or sea1 and 1 or newsea and 4

---------
-- BIẾN HỖ TRỢ VÀ TỌA ĐỘ
---------
local newdao = CFrame.new(10641.09, -1953.92, 9825.07)
local cframenpc = CFrame.new(-16271.12, 25.58, 1371.98)

local currentTweenId = 0
local TPLoop = nil
local NoclipLoop = nil
local TP_Speed = 325 

_G.Config_ = _G.Config_ or {}

---------
-- HÀM TIỆN ÍCH (UTILITIES)
---------
local function GetTargetCFrame(Target)
    if typeof(Target) == "CFrame" then
        return Target
    elseif typeof(Target) == "Vector3" then
        return CFrame.new(Target)
    elseif typeof(Target) == "Instance" then
        if Target:IsA("BasePart") then
            return Target.CFrame
        elseif Target:IsA("Model") and Target.PrimaryPart then
            return Target.PrimaryPart.CFrame
        elseif Target:IsA("Player") and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            return Target.Character.HumanoidRootPart.CFrame
        end
    end
    return nil
end

local function GetDistance(Target, IgnoreY)
    local targetPos = GetTargetCFrame(Target)
    if not targetPos then return math.huge end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    
    if IgnoreY then
        return (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(targetPos.Position.X, 0, targetPos.Position.Z)).Magnitude
    end
    return (hrp.Position - targetPos.Position).Magnitude
end

local function WaitForHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then return humanoid end
    
    local timeout = tick() + 5
    while tick() < timeout do
        humanoid = character:FindFirstChild("Humanoid")
        if humanoid then return humanoid end
        task.wait(0.1)
    end
    return nil
end

local function CheckItem(ITEM_NAME)
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA('Tool') and string.find(v.Name, ITEM_NAME) then return v end
    end
    local character = LocalPlayer.Character
    if character then
        for _, v in pairs(character:GetChildren()) do
            if v:IsA('Tool') and string.find(v.Name, ITEM_NAME) then return v end
        end
    end
    return nil
end

local function CheckLegendaryItems()
    local items = {"God's Chalice", "Fist of Darkness", "Sweet Chalice", "Hallow Essence", "Flower1"}
    for _, item in ipairs(items) do
        if CheckItem(item) then return true end
    end
    return false
end

local function InArea(POS)
    local targetCFrame = GetTargetCFrame(POS)
    if not targetCFrame then return {Name = ""} end
    
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin or not WorldOrigin:FindFirstChild("Locations") then return {Name = ""} end
    
    for _, v in pairs(WorldOrigin.Locations:GetChildren()) do
        if v:FindFirstChild("Mesh") and (targetCFrame.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

---------
-- XỬ LÝ BYPASS TELEPORT & ENTRANCE
---------
local function GetSpawnPoint(x)
    local origin = workspace:FindFirstChild("_WorldOrigin")
    if not origin then return nil end
    local spawns = origin:FindFirstChild("PlayerSpawns") and origin.PlayerSpawns:FindFirstChild("Pirates")
    if not spawns then return nil end
    
    for _, v in pairs(spawns:GetChildren()) do
        if (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
    return nil
end

local function CanBypassTeleport(targetPos)
    local AreaName = InArea(targetPos).Name
    if AreaName == "" then return false end
    if AreaName:find("Dimension") or AreaName:find("Submerged") or AreaName == "Sealed Cavern" or AreaName:lower():find("under") then return false end
    if CheckLegendaryItems() then return false end
    
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("LastSpawnPoint") and data.LastSpawnPoint.Value == "SubmergedIsland" then return false end
    if GetDistance(targetPos) <= 3500 then return false end
    
    return true
end

local function GetBypassCFrame(targetPos)
    local Max = math.huge
    local Pos = nil
    local origin = workspace:FindFirstChild("_WorldOrigin")
    if not origin then return nil end
    
    local spawns = origin:FindFirstChild("PlayerSpawns") and origin.PlayerSpawns:FindFirstChild("Pirates")
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not spawns or not hrp then return nil end
    
    for _, v in pairs(spawns:GetChildren()) do
        if (targetPos.Position - hrp.Position).Magnitude >= 3000 
        and GetSpawnPoint(v.Part) ~= GetSpawnPoint(hrp) 
        and (v.Part.Position - hrp.Position).Magnitude <= 10000 
        and (v.Part.Position - targetPos.Position).Magnitude <= Max then
            Max = (v.Part.Position - targetPos.Position).Magnitude
            Pos = v
        end
    end
    return Pos
end

local function BypassTP(Target)
    local targetPos = GetTargetCFrame(Target)
    if not targetPos then return end
    
    local humanoid = WaitForHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end
    
    local bypassNode = GetBypassCFrame(targetPos)
    if CanBypassTeleport(targetPos) and bypassNode then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("LastSpawnPoint") then
            character.LastSpawnPoint.Disabled = true
        end
        CommF_:InvokeServer("SetLastSpawnPoint", bypassNode.Name)
        CommF_:InvokeServer("SetSpawnPoint")
        character:PivotTo(bypassNode.Part.CFrame)
        humanoid:ChangeState(15)
        
        repeat task.wait() until LocalPlayer.Character and WaitForHumanoid() and WaitForHumanoid().Health > 0
    end
end

local function RequestEntrance(targetPos)
    local targetCFrame = GetTargetCFrame(targetPos)
    if not targetCFrame then return end
    
    local tpPoints = {}
    if SeaIndex == 1 then
        tpPoints = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif SeaIndex == 2 then
        tpPoints = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif SeaIndex == 3 then
        tpPoints = {
            ["Hydra Island"] = Vector3.new(5657.88, 1013.07, -335.49),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.17, 2280.69, -7325.12)
        }
    end
    
    local closestPoint, minDistance = nil, math.huge
    for _, pos in pairs(tpPoints) do
        local dist = (pos - targetCFrame.Position).Magnitude
        if dist < minDistance then
            minDistance = dist
            closestPoint = pos
        end
    end
    
    if closestPoint and minDistance < GetDistance(targetCFrame) then
        CollectionService:AddTag(LocalPlayer, "Teleporting")
        CommF_:InvokeServer("requestEntrance", closestPoint)
        task.wait(1)
        CollectionService:RemoveTag(LocalPlayer, "Teleporting")
    end
end

---------
-- HỆ THỐNG NOCLIP & DI CHUYỂN CHÍNH (OLD_TP TỐI ƯU)
---------
local function EnableNoclip(hrp)
    if not hrp:FindFirstChild("TP_BodyVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "TP_BodyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
    end
    
    if not NoclipLoop then
        NoclipLoop = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function DisableNoclip(hrp)
    if hrp and hrp:FindFirstChild("TP_BodyVelocity") then
        hrp.TP_BodyVelocity:Destroy()
    end
    if NoclipLoop then
        NoclipLoop:Disconnect()
        NoclipLoop = nil
    end
end

function old_tp(TargetInput)
    local targetCFrame = GetTargetCFrame(TargetInput)
    if not targetCFrame then return end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    currentTweenId = currentTweenId + 1
    local thisTween = currentTweenId
    
    if TPLoop then TPLoop:Disconnect() end

    EnableNoclip(hrp)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    
    TPLoop = RunService.Heartbeat:Connect(function(deltaTime)
        if currentTweenId ~= thisTween then
            if TPLoop then TPLoop:Disconnect() end
            return
        end
        
        local currentTarget = GetTargetCFrame(TargetInput)
        if not currentTarget or humanoid.Health <= 0 then
            DisableNoclip(hrp)
            if TPLoop then TPLoop:Disconnect() end
            return
        end

        local distance = (hrp.Position - currentTarget.Position).Magnitude
        
        
        
        local targetPosition = currentTarget.Position
        local moveDir = (targetPosition - hrp.Position).Unit
        
        local moveDistance = TP_Speed * deltaTime
        if distance < moveDistance then
            hrp.CFrame = currentTarget
        else
            hrp.CFrame = hrp.CFrame + (moveDir * moveDistance)
        end
    end)
    
    return thisTween
end


local function checkInCombat()
    local inCombat = false
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            for _, v in pairs(mainGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and string.find(string.lower(v.Text), "combat") then
                    inCombat = true
                    break
                end
            end
        end
    end)
    return inCombat
end

---------
-- HÀM GỌI TỔNG HỢP VÀ ANTI-AFK
---------
getgenv().TP = function(TargetInput, ...)
    local targetCFrame = GetTargetCFrame(TargetInput)
    if not targetCFrame then return end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local currentArea = InArea(hrp.Position).Name
    local targetArea = InArea(targetCFrame).Name

    local isRisk = false
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            for _, v in pairs(mainGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and string.find(string.lower(v.Text), "risk") then
                    isRisk = true
                    break
                end
            end
        end
    end)

    if currentArea ~= targetArea or targetArea == "" then
        if not checkInCombat() then
            RequestEntrance(targetCFrame)
        end
        hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local newArea = InArea(hrp.Position).Name
            if newArea ~= targetArea and not isRisk and CanBypassTeleport(targetCFrame) then
                BypassTP(targetCFrame)
                task.wait(0.5)
            end
        end
    end
    
    if SeaIndex == 3 and GetDistance(newdao.Position) < 2000 then
        hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and math.abs(newdao.Position.Y - hrp.CFrame.Y) > 1000 then
            repeat
                task.wait()
                old_tp(cframenpc)
                if GetDistance(cframenpc) < 10 then
                    local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
                    if net then
                        net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
                        task.wait(0.5)
                        net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                    end
                end
            until GetDistance(targetCFrame) < 2000
            task.wait(0.6)
            if hrp:FindFirstChild("TP_BodyVelocity") then
                hrp.TP_BodyVelocity:Destroy()
            end
        end
    end
    
    return old_tp(TargetInput, ...)
end



---------


getgenv().stoptp = function()
    currentTweenId = currentTweenId + 1 
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    DisableNoclip(hrp)
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Tp Engine Optimized - Loaded successfully!")
