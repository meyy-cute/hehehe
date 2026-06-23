local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local workspace = game:GetService("Workspace")

_G.BringMobs = true -- Tắt/Bật gom quái

local activeGomQuai = {}
local GOM_QUAI_RADIUS = 275

---------
local function layGocNhanVat()
    local character = localPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

---------
local function batDauGomQuai(quaiVat)
    local rootQuai = quaiVat:FindFirstChild("HumanoidRootPart")
    local humanoidQuai = quaiVat:FindFirstChild("Humanoid")
    
    if not rootQuai or not humanoidQuai then return end
    
    pcall(function()
        localPlayer.SimulationRadius = math.huge
    end)
    
    if not rootQuai:FindFirstChild("BringBody") then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Name = "BringBody"
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Parent = rootQuai
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "BringGyro"
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.Parent = rootQuai
        
        task.spawn(function()
            while true do
                local rootNhanVat = layGocNhanVat()
                local executionValid = rootQuai and rootQuai.Parent and (humanoidQuai.Health > 0) and (_G.BringMobs and rootNhanVat)
                
                if not executionValid then
                    break
                end
                
                local targetPosition = rootNhanVat.Position
                local currentDistance = (rootQuai.Position - targetPosition).Magnitude
                
                if currentDistance > GOM_QUAI_RADIUS then
                    break
                end
                
                if currentDistance > 5 then
                    bodyPosition.P = 2000000000
                    bodyPosition.D = 500000
                    rootQuai.CFrame = CFrame.new(targetPosition)
                else
                    bodyPosition.P = 500000000
                    bodyPosition.D = 1000000
                end
                
                bodyPosition.Position = targetPosition
                bodyGyro.CFrame = CFrame.new(targetPosition)
                
                rootQuai.AssemblyLinearVelocity = Vector3.zero
                rootQuai.AssemblyAngularVelocity = Vector3.zero
                rootQuai.Velocity = Vector3.zero
                rootQuai.RotVelocity = Vector3.zero
                rootQuai.CanCollide = false
                
                task.wait(0.02)
            end
            
            if bodyPosition then bodyPosition:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end)
    end
end

---------
local function quetVaGomQuai()
    if not _G.BringMobs then return end
    
    local rootNhanVat = layGocNhanVat()
    if not rootNhanVat then return end
    
    local viTriNhanVat = rootNhanVat.Position
    local danhSachQuai = workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren()
    
    if not danhSachQuai then return end
    
    for _, quaiVat in ipairs(danhSachQuai) do
        local humanoid = quaiVat:FindFirstChild("Humanoid")
        local primaryPart = quaiVat.PrimaryPart
        
        if humanoid and humanoid.Health > 0 and primaryPart then
            local khoangCach = (primaryPart.Position - viTriNhanVat).Magnitude
            if khoangCach <= GOM_QUAI_RADIUS and not activeGomQuai[quaiVat] then
                activeGomQuai[quaiVat] = true
                
                task.spawn(function()
                    batDauGomQuai(quaiVat)
                    task.wait(9)
                    activeGomQuai[quaiVat] = nil
                end)
            end
        end
    end
end

---------
task.spawn(function()
    while true do
        if _G.BringMobs then
            quetVaGomQuai()
        end
        task.wait(1) -- Loop chuẩn 1 giây cho ann nhó waa~
    end
end)
