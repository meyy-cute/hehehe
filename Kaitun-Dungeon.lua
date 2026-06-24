
-------------------------
if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

if game.Workspace then
    repeat task.wait() until game.Workspace:FindFirstChildOfClass("Part") or task.wait(1)
end

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = game.Players.LocalPlayer

local fileName = tostring(player.Name) .. "_DungeonEnergy.json"

local function ShowDarkThemeNotification(title, message)
    local sg = Instance.new("ScreenGui")
    sg.Name = "DungeonStatusUI_" .. tostring(math.random(1000, 9999))
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = player:WaitForChild("PlayerGui") end

    local mainFrame = Instance.new("Frame", sg)
    mainFrame.Size = UDim2.new(0, 280, 0, 70)
    mainFrame.Position = UDim2.new(0.5, -140, 1, 50) 
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = 2
    local strokeGrad = Instance.new("UIGradient", stroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
    })

    local txtTitle = Instance.new("TextLabel", mainFrame)
    txtTitle.Size = UDim2.new(1, -20, 0, 25)
    txtTitle.Position = UDim2.new(0, 10, 0, 5)
    txtTitle.BackgroundTransparency = 1
    txtTitle.Text = title
    txtTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    txtTitle.Font = Enum.Font.GothamBold
    txtTitle.TextSize = 14
    txtTitle.TextXAlignment = Enum.TextXAlignment.Left

    local txtMsg = Instance.new("TextLabel", mainFrame)
    txtMsg.Size = UDim2.new(1, -20, 0, 30)
    txtMsg.Position = UDim2.new(0, 10, 0, 30)
    txtMsg.BackgroundTransparency = 1
    txtMsg.Text = message
    txtMsg.TextColor3 = Color3.fromRGB(180, 180, 180)
    txtMsg.Font = Enum.Font.Gotham
    txtMsg.TextSize = 12
    txtMsg.TextWrapped = true
    txtMsg.TextXAlignment = Enum.TextXAlignment.Left

    local rot = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        rot = (rot + 1.5) % 360
        strokeGrad.Rotation = rot
    end)

    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 1, -100)}):Play()
    
    task.delay(5, function()
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 1, 50)}):Play()
        task.delay(0.6, function()
            if conn then conn:Disconnect() end
            sg:Destroy()
        end)
    end)
end

-------------------------
local function BlockOutsideScripts()
    pcall(function()
        if getgenv and getgenv().loadstring then
            local oldLoadstring = getgenv().loadstring
            
            getgenv().loadstring = function(sourceCode, ...)
                local sourceStr = tostring(sourceCode)
                
                if string.find(sourceStr, "meyy%-cute") or string.find(sourceStr, "Kaitun%-Dungeon") or string.find(sourceStr, "no%-gravity") or string.find(sourceStr, "m1%-attack") or string.find(sourceStr, "Dungeon%-Pad") then
                    return oldLoadstring(sourceCode, ...)
                end
                
                return function() 
                    task.wait(999999) 
                end
            end
        end
    end)
end
-------------------------


local function GetCurrentEnergy()
    local success, result = pcall(function()
        local args = {"GetDungeonEnergy"}
        return ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DungeonNPCNetworkFunction"):InvokeServer(unpack(args))
    end)
    return success and tonumber(result) or 0
end

---------
local currentEnergy = GetCurrentEnergy()
local savedState = "WAITING"
local savedSeaID = 0

local SeaRemotes = {
    [2753915549] = "TravelMain",
    [4442272183] = "TravelDressrosa",
    [7449423635] = "TravelZou"
}

local isMainSea = SeaRemotes[game.PlaceId] ~= nil

if isfile and readfile and isfile(fileName) then
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
    if success and decoded then
        if decoded.State then savedState = decoded.State end
        if decoded.SeaID then savedSeaID = decoded.SeaID end
    end
end

if isMainSea then
    savedSeaID = game.PlaceId
end

local inDungeon = false
if game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Dungeon") then
    inDungeon = true
end

if currentEnergy >= 50 then
    savedState = "RUNNING"
elseif currentEnergy < 10 then
    if inDungeon then
        savedState = "RUNNING"
    else
        savedState = "WAITING"
    end
end

if writefile then
    pcall(function() writefile(fileName, HttpService:JSONEncode({Energy = currentEnergy, State = savedState, SeaID = savedSeaID})) end)
end

if savedState == "WAITING" then
    ShowDarkThemeNotification("Dungeon Suspended", "Energy too low. Returning to sea.")
    if savedSeaID ~= 0 and SeaRemotes[savedSeaID] then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer(SeaRemotes[savedSeaID])
        end)
    end
    return 
else
    ShowDarkThemeNotification("Dungeon Started", "Full energy or in last run. Blocking outside scripts and executing Kaitun.")
    BlockOutsideScripts() 
end
---------


task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/no-gravity2.txt"))()
end)


_G.RaceClickAutov3 = true
_G.RaceClickAutov4 = true
_G.BusoAuto = true
local noclipEnabled = true

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local plr = Players.LocalPlayer

local function Useskills(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, key, false, game)
end
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.RaceClickAutov3 then
            pcall(function()
                replicated.Remotes.CommE:FireServer("ActivateAbility")
            end)
            task.wait(30)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if _G.RaceClickAutov4 then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("RaceEnergy") then
                    if char.RaceEnergy.Value >= 1 then 
                        Useskills("Y")
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.BusoAuto then
            pcall(function()
                if plr.Character and not plr.Character:FindFirstChild("HasBuso") then
                    replicated.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

task.wait(5) 

if Workspace.Map:FindFirstChild("Dungeon") then
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/m1-attack.lua"))()
    end)

    ---------
    
    
    
    local function getMyPriorityList()
        local myName = string.lower(plr.Name)
        local myDisplayName = string.lower(plr.DisplayName)
        
        if getgenv().Config then
            for _, group in pairs(getgenv().Config) do
                if type(group) == "table" and group.Users then
                    for _, user in ipairs(group.Users) do
                        local configUser = string.lower(tostring(user))
                        if configUser == myName or configUser == myDisplayName then
                            if group.CardPriority then
                                return group.CardPriority
                            end
                            
                            local myRole = group.ToolTip or "Blox Fruit"
                            if myRole == "Sword" then
                                return {"HYPER!", "Sword", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Fruit", "Fruit M1 Speed"}
                            elseif myRole == "Melee" then
                                return {"HYPER!", "Melee", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Sword", "Fruit", "Fruit M1 Speed"}
                            else
                                return {"Fruit M1 Speed", "Fruit", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Sword", "HYPER!"}
                            end
                        end
                    end
                end
            end
        end
        return {"Fruit M1 Speed", "Fruit", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Sword", "HYPER!"}
    end

    local function getBestBuff(offeredBuffs)
        local priorityList = getMyPriorityList()
        if not priorityList or #priorityList == 0 then return nil end
        
        for _, targetName in ipairs(priorityList) do
            local targetLower = string.lower(tostring(targetName))
            for _, buff in ipairs(offeredBuffs) do
                local buffName = buff.buffName or buff.Name or buff.key or tostring(buff)
                if string.find(string.lower(buffName), targetLower) then
                    return buffName
                end
            end
        end
        
        if offeredBuffs[1] then
            return offeredBuffs[1].buffName or offeredBuffs[1].Name or offeredBuffs[1].key or tostring(offeredBuffs[1])
        end
        return nil
    end

    getgenv()._ourBuffCallback = function(offeredBuffs)
        local bestBuff = getBestBuff(offeredBuffs)
        if bestBuff then
            return bestBuff
        end
        if getgenv()._originalBuffCallback then
            return getgenv()._originalBuffCallback(offeredBuffs)
        end
    end

    task.spawn(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local success, buffSelector = pcall(function()
            return replicatedStorage:WaitForChild("DungeonShared", math.huge):WaitForChild("BuffSelector", math.huge)
        end)
        
        if success and buffSelector then
            task.spawn(function()
                while task.wait(0.5) do
                    pcall(function()
                        local currentCallback = nil
                        pcall(function()
                            currentCallback = getcallbackvalue(buffSelector, "OnClientInvoke")
                        end)
                        
                        if currentCallback and currentCallback ~= getgenv()._ourBuffCallback then
                            getgenv()._originalBuffCallback = currentCallback
                            buffSelector.OnClientInvoke = getgenv()._ourBuffCallback
                        elseif not currentCallback then
                            buffSelector.OnClientInvoke = getgenv()._ourBuffCallback
                        end
                    end)
                end
            end)
        end
    end)

    ---------


    

    ---------

    local R = RunService
    local P = Players
    local TS = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local p = P.LocalPlayer

    workspace.Gravity = 0
    local EF = "Enemies"
    local IE = { 
        ["Blank Buddy"] = true, 
        ["PropHitboxPlaceholder"] = true,
        ["Raider"] = true
    }
    local PROP_NAME = "PropHitboxPlaceholder" 
    local TD = 0.075
    local GR = 35
    local LS = 200
    local PR = 35
    local mT = 0
    local FLY_SPEED = 350

    ---------
local player = game.Players.LocalPlayer
local hasUnequippedForTransform = false 

local function getCurrentToolTip()
    if not getgenv().Config then return nil end
    local myName = string.lower(player.Name)
    local myDisplayName = string.lower(player.DisplayName)
    for _, data in pairs(getgenv().Config) do
        if type(data) == "table" and data.Users then
            for _, user in pairs(data.Users) do
                local configUser = string.lower(tostring(user))
                if configUser == myName or configUser == myDisplayName then 
                    return data.ToolTip 
                end
            end
        end
    end
    return nil
end

local function startAutoEquip()
    task.spawn(function()
        local lastWeapon = _G.SelectWeapon
        
        while task.wait() do
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            local currentSelection = _G.SelectWeapon
            
            if currentSelection ~= "" and currentSelection ~= nil then
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local toolInHand = character:FindFirstChildOfClass("Tool")
                    
                    if not toolInHand or toolInHand.ToolTip ~= currentSelection then
                        task.wait(4)
                        if _G.SelectWeapon == currentSelection and player.Character == character then
                            if backpack then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == currentSelection then
                                        character.Humanoid:EquipTool(tool)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                lastWeapon = currentSelection
            else
                if character and character:FindFirstChild("Humanoid") then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool and tool.ToolTip == lastWeapon then
                        if backpack then
                            tool.Parent = backpack
                        end
                    end
                end
            end
        end
    end)
end

local function equipToolByRole()
    task.spawn(function()
        while task.wait(0.3) do 
            local character = player.Character
            if not character then continue end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            if _G.IsTransforming then
                if not hasUnequippedForTransform then
                    local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                    if currentlyEquipped then
                        hum:UnequipTools() 
                    end
                    hasUnequippedForTransform = true 
                end
                continue 
            end
            hasUnequippedForTransform = false 

            -- Luon doc ToolTip tu Config, khong phu thuoc getgenv().AutoEquip
            if getgenv().AutoEquip == false then
                local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                if currentlyEquipped then
                    hum:UnequipTools()
                end
            else
                local myToolTip = getCurrentToolTip()
                local backpack = player:FindFirstChild("Backpack")
                
                if myToolTip and backpack then
                    local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                    
                    if not (currentlyEquipped and currentlyEquipped.ToolTip == myToolTip) then
                        for _, item in pairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and item.ToolTip == myToolTip then
                                hum:EquipTool(item) 
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    hasUnequippedForTransform = false
    task.wait(0.5)
end)

-- startAutoEquip() bi tat: dung _G.SelectWeapon (chi duoc set khi clear mob room thuong,
-- khong duoc set khi danh boss) nen conflict voi equipToolByRole() doc thang tu Config.
-- startAutoEquip()
equipToolByRole()
---------

    ---------

    local Themes = {
        BgColor = Color3.fromRGB(15, 15, 15),
        BgTransparency = 0.5,
        TextColor = Color3.fromRGB(255, 255, 255),
        CreditColor = Color3.fromRGB(150, 150, 150)
    }

    local UI_Elements = {}

    local g = Instance.new("ScreenGui")
    g.Name = "Kaitun_UI_" .. tostring(math.random(1000, 9999))
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = p:WaitForChild("PlayerGui") end
    getgenv().kc = g

    local m = Instance.new("Frame", g)
    m.Name = "Main"
    m.BackgroundColor3 = Themes.BgColor
    m.BackgroundTransparency = Themes.BgTransparency
    m.Position = UDim2.new(0.5, 0, 0, -150)
    m.Size = UDim2.new(0, 320, 0, 100)
    m.AnchorPoint = Vector2.new(0.5, 0)
    table.insert(UI_Elements, m)

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.5
    u.Color = Color3.new(1, 1, 1)
    table.insert(UI_Elements, u)

    local strokeGradient = Instance.new("UIGradient", u)
    
    local function createDarkGradient()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        })
    end
    strokeGradient.Color = createDarkGradient()

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
        label.TextSize = 15
        label.TextColor3 = Themes.TextColor
        table.insert(UI_Elements, label)
        
        local txtGradient = Instance.new("UIGradient", label)
        txtGradient.Color = createDarkGradient()
        table.insert(statusGradients, txtGradient)
        return label, txtGradient
    end

    _G.StatusItemLabel, _G.TopInfoGradient = CreateStatusLabel("TopInfo", 10, "Meyy Hub - Kaitun Dungeon")
    _G.StatusFarmLabel, _G.FarmGradient = CreateStatusLabel("StatusFarm", 35, "Status Farm: N/A")
    _G.StatusMobLabel, _G.MobGradient = CreateStatusLabel("StatusMob", 60, "Farm Mob: N/A")

    local creditLabel = Instance.new("TextLabel", m)
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(0, 50, 0, 15)
    creditLabel.Position = UDim2.new(1, -10, 1, -5)
    creditLabel.AnchorPoint = Vector2.new(1, 1)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.Text = "meyy"
    creditLabel.TextSize = 10
    creditLabel.TextColor3 = Themes.CreditColor
    creditLabel.TextXAlignment = Enum.TextXAlignment.Right
    table.insert(UI_Elements, creditLabel)

    local rRot = 0
    task.spawn(function()
        while true do
            local delta = R.RenderStepped:Wait()
            rRot = (rRot + 1.5) % 360
            strokeGradient.Rotation = rRot
            for _, grad in ipairs(statusGradients) do
                grad.Rotation = rRot
            end
        end
    end)

    TS:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    ---------

    local function gH()
        local c = p.Character or p.CharacterAdded:Wait()
        return c:WaitForChild("HumanoidRootPart")
    end

    local function isAlive()
        local c = p.Character
        local u = c and c:FindFirstChildOfClass("Humanoid")
        return u and u.Health > 0
    end

    local function iB()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if dungeon then 
            local mR = 0
            for _, r in ipairs(dungeon:GetChildren()) do 
                local n = tonumber(r.Name)
                if n and n > mR then mR = n end 
            end
            if mR > 0 then 
                return (mR == 5 or mR == 10 or mR == 15 or mR == 20 or mR == 100), mR 
            end 
        end
        return false, 0 
    end
    
local function getActivePlayersConfig()
        local count = 0
        local myIndex = 1
        local validUsers = {}
        
        if getgenv().Config and getgenv().Config["Account Join"] and getgenv().Config["Account Join"].Users then
            for _, v in ipairs(getgenv().Config["Account Join"].Users) do
                if type(v) == "string" and v ~= "" then
                    table.insert(validUsers, string.lower(v))
                end
            end
        end
        
        count = #validUsers > 0 and #validUsers or 1
        local myName = string.lower(p.Name)
        local myDisplayName = string.lower(p.DisplayName)
        
        for i, v in ipairs(validUsers) do
            if v == myName or v == myDisplayName then
                myIndex = i
                break
            end
        end
        
        return count, myIndex
    end
    
    local function fE()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return nil end
        local h = gH()
        local n = nil
        local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local ePart = r:FindFirstChild("ExitTeleporter")
            if ePart then 
                local t = ePart:FindFirstChild("Root")
                if t and t:IsA("BasePart") then 
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; n = t end 
                end 
            end 
        end
        return n 
    end

    local function tpTween(targetPos)
        local h = gH()
        if not h then return end
        h.CFrame = CFrame.new(h.Position.X, targetPos.Y, h.Position.Z)
        local distXZ = (Vector3.new(h.Position.X, 0, h.Position.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude 
        if distXZ < 100 then
            h.CFrame = CFrame.new(targetPos)
        else
            TS:Create(h, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
        end
    end

    local function cP(pos)
        local f = workspace:FindFirstChild("AnnSafePlatform")
        if not f then 
            f = Instance.new("Part"); f.Name = "AnnSafePlatform"; f.Size = Vector3.new(100, 1, 100)
            f.Position = pos; f.Anchored = true; f.CanCollide = true; f.Transparency = 0.5
            f.Color = Color3.fromRGB(138, 43, 226); f.Parent = workspace 
        else f.Position = pos end
        return f 
    end

    local function sM() mT = mT + 1 end

    local function flyToNearestExit(targetPos)
        sM()
        local myToken = mT
        local hrp = gH()
        local startPos = hrp.Position
        local delta = targetPos - startPos
        local distance = delta.Magnitude
        
        if distance < 3 then 
            task.wait(0.5)
            return 
        end 
        
        local direction = delta.Unit
        local duration = distance / FLY_SPEED
        local elapsed = 0
        local connection
        
        connection = R.Heartbeat:Connect(function(dt)
            if myToken ~= mT then 
                connection:Disconnect() 
                return 
            end
            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            hrp.CFrame = CFrame.new(startPos + direction * (distance * alpha))
            if alpha >= 1 then 
                connection:Disconnect() 
            end
        end)
        
        repeat task.wait() until elapsed >= duration or myToken ~= mT
            if myToken == mT then
            task.wait(0.5)
        end
    end

    local function executeFlyToNearestExit()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return end
        local hrp = gH(); local nearestRoot = nil; local minDistance = math.huge
        for _, room in ipairs(dungeon:GetChildren()) do
            local exitPortal = room:FindFirstChild("ExitTeleporter")
            if exitPortal then
                local root = exitPortal:FindFirstChild("Root")
                if root and root:IsA("BasePart") then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < minDistance then minDistance = dist; nearestRoot = root end
                end
            end
        end
        if nearestRoot then flyToNearestExit(nearestRoot.Position + Vector3.new(0, 3, 0)) end
    end

    local function getCurrentRoomNumber()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return 0 end
        local h = gH(); if not h then return 0 end
        local cR = 0; local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local n = tonumber(r.Name)
            if n then
                local ePart = r:FindFirstChild("ExitTeleporter")
                local t = ePart and ePart:FindFirstChild("Root")
                if t then
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; cR = n end
                end
            end
        end
        return cR
    end

    local function getRoomCenter()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return nil end

        local currentRoomNum = getCurrentRoomNumber()
        if currentRoomNum == 0 then return nil end

        local roomModel = dungeon:FindFirstChild(tostring(currentRoomNum))
        if roomModel and roomModel:IsA("Model") then
            local cframe, size = roomModel:GetBoundingBox()
            return cframe.Position
        end
        return nil
    end

    ---------

    _G.dragontorm = false 
    local AimBotSkillPosition = nil 

    pcall(function()
        local gg = getrawmetatable(game);
        local old = gg.__namecall;
        setreadonly(gg, false);

        gg.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod();
            local args = { ... }
            
            if _G.dragontorm and tostring(method) == "FireServer" and tostring(self) == "ShootGunEvent" then
                if AimBotSkillPosition then
                    args[1] = AimBotSkillPosition 
                    return old(self, unpack(args))
                end
            end
            return old(self, ...)
        end);
    end)

    local function FindNearestMob()
        local targetMob = nil
        local minDistance = math.huge
        local playerHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart") 
        if not playerHRP then return nil end
        
        local MobContainer = workspace:FindFirstChild("Enemies") or workspace 
        for _, v in pairs(MobContainer:GetChildren()) do
            local humanoid = v:FindFirstChildOfClass("Humanoid")
            if v and humanoid and v:FindFirstChild("HumanoidRootPart") and humanoid.Health > 0 then
                local dis = (playerHRP.Position - v.HumanoidRootPart.Position).Magnitude
                if dis <= 500 and dis < minDistance then
                    minDistance = dis 
                    targetMob = v
                end
            end
        end
        return targetMob
    end

    task.spawn(function()
        while true do
            if _G.dragontorm then
                local targetMob = FindNearestMob()
                if targetMob then
                    local mobHRP = targetMob:FindFirstChild("HumanoidRootPart") 
                    local mobHead = targetMob:FindFirstChild("Head") 
                    local targetPos = (mobHead and mobHead.Position) or (mobHRP and mobHRP.Position) 
                    
                    if targetPos then
                        AimBotSkillPosition = targetPos 
                        pcall(function()
                            local NetModule = require(game.ReplicatedStorage.Modules.Net)
                            NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos, {mobHead or mobHRP})
                        end)
                    end
                end
            else
                AimBotSkillPosition = nil 
            end
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        while true do
            if _G.dragontorm then
                local Camera = workspace.CurrentCamera
                local centerX = Camera.ViewportSize.X / 2
                local centerY = Camera.ViewportSize.Y / 2
                local Vim = game:GetService("VirtualInputManager")
                task.spawn(function()
                    Vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1) 
                    task.wait(0.05)
                    Vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1) 
                end)
                task.wait(1.95) 
            else
                task.wait(1) 
            end
        end
    end)

    ---------

    local Attack = {}
    Attack.Alive = function(model)
        if not model then return false end
        local Humanoid = model:FindFirstChildOfClass("Humanoid")
        return Humanoid and Humanoid.Health > 0
    end

    local function isModelStillThere(model)
        if not model or not model.Parent then return false end
        return model:FindFirstChild("HumanoidRootPart") ~= nil
    end

    local function getActivePlayersConfig()
        local count = 0
        local myIndex = 1
        local validUsers = {}
        
        if getgenv().Config and getgenv().Config["Account Join"] and getgenv().Config["Account Join"].Users then
            for _, v in ipairs(getgenv().Config["Account Join"].Users) do
                if type(v) == "string" and v ~= "" then
                    table.insert(validUsers, string.lower(v))
                end
            end
        end
        
        count = #validUsers > 0 and #validUsers or 1
        local myName = string.lower(p.Name)
        local myDisplayName = string.lower(p.DisplayName)
        
        for i, v in ipairs(validUsers) do
            if v == myName or v == myDisplayName then
                myIndex = i
                break
            end
        end
        
        return count, myIndex
    end

    ---------

    task.spawn(function()
        local lastFarmText = ""
        local lastMobText = ""
        
        local global_lastRoomCheck = 0
        local global_roomEntryTime = 0 

        local function updateUI(farmMsg, mobMsg)
            task.spawn(function()
                local farmFullText = "Status Farm: " .. tostring(farmMsg)
                local mobFullText = "Farm Mob: " .. tostring(mobMsg)
                
                if farmFullText ~= lastFarmText then
                    lastFarmText = farmFullText
                    if _G.StatusFarmLabel then _G.StatusFarmLabel.Text = farmFullText end
                end
                if mobFullText ~= lastMobText then
                    lastMobText = mobFullText
                    if _G.StatusMobLabel then _G.StatusMobLabel.Text = mobFullText end
                end
            end)
        end

        while true do 
            task.wait() 
            
            local isBoss, rNum = iB()
            local currentRoom = getCurrentRoomNumber()
            
            if currentRoom > 0 and currentRoom ~= global_lastRoomCheck then
                global_lastRoomCheck = currentRoom
                global_roomEntryTime = tick() 
            end
        
            if currentRoom >= getgenv().Config["Room Settings"].MaxRoom then
                updateUI("Room " .. tostring(getgenv().Config["Room Settings"].MaxRoom) .. " Reached", getgenv().Config["Room Settings"].StatusMessage)
                task.wait(2)
                continue
            end
            
            if currentRoom > 0 and currentRoom < rNum then
                updateUI("Tween To Portal " .. rNum, "Moving")
                executeFlyToNearestExit()
                task.wait(0.1)
                continue 
            end

            if tick() - global_roomEntryTime < 0.4 then
                task.wait(0.1)
                continue
            end

            local function getMyBuddhaConfig()
                if not getgenv().Config then return false end
                local myName = string.lower(p.Name)
                local myDisplayName = string.lower(p.DisplayName)
                
                for _, data in pairs(getgenv().Config) do
                    if type(data) == "table" and data.Users then
                        for _, user in pairs(data.Users) do
                            local configUser = string.lower(tostring(user))
                            if configUser == myName or configUser == myDisplayName then 
                                return data.ModeBuddha 
                            end
                        end
                    end
                end
                return false
            end

            local modebuddha = getMyBuddhaConfig()
            if modebuddha then
                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not _G.OriginalSize then _G.OriginalSize = hrp.Size end
                    
                    if hrp.Size.Magnitude <= _G.OriginalSize.Magnitude * 1.2 then
                        if not _G.IsTransforming then
                            _G.IsTransforming = true
                            getgenv().AutoEquip = false 
                            
                            task.spawn(function()
                                local vi = game:GetService("VirtualInputManager")
                                task.wait(0.5)
                                vi:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                                task.wait(0.6)
                                vi:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                task.wait(2) 
                                getgenv().AutoEquip = true 
                                _G.IsTransforming = false
                            end)
                        end
                        updateUI("Activating Buddha", "Waiting...")
                        task.wait(0.1)
                        continue 
                    else
                        local mult = 3
                        local targetMag = _G.OriginalSize.Magnitude * 3 * mult * 0.9
                        if hrp.Size.Magnitude < targetMag then
                            for _, part in pairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Size = part.Size * mult
                                    for _, att in pairs(part:GetChildren()) do 
                                        if att:IsA("Attachment") then att.Position = att.Position * mult end 
                                    end
                                    local mesh = part:FindFirstChildOfClass("SpecialMesh")
                                    if mesh then mesh.Scale = mesh.Scale * mult end
                                elseif part:IsA("Motor6D") then
                                    local c0, c1 = part.C0, part.C1
                                    part.C0 = CFrame.new(c0.Position * mult) * (c0 - c0.Position)
                                    part.C1 = CFrame.new(c1.Position * mult) * (c1 - c1.Position)
                                end
                            end
                        end
                    end
                end
            end

                    ---------

                    ---------
if isBoss and (rNum == 5 or rNum == 10 or rNum == 15 or rNum == 20) then 
    updateUI("Clear Boss Room " .. rNum, "Boss Battle M1")
    local f = workspace:FindFirstChild(EF)
    if f then 
        _G.PromotedRooms = _G.PromotedRooms or {}
        
        local function TweenIsBoss(targetPos)
            local mHRP = gH()
            if not mHRP then return end
            local dist = (mHRP.Position - targetPos).Magnitude
            if dist <= 100 then
                mHRP.CFrame = CFrame.new(targetPos)
            else
                local Speed = 350
                local info = TweenInfo.new(dist / Speed, Enum.EasingStyle.Linear)
                TS:Create(mHRP, info, {CFrame = CFrame.new(targetPos)}):Play()
            end
        end

        while isAlive() do
            Workspace.Gravity = 0 
            local checkStillBoss, currentRNum = iB()
            if not checkStillBoss or currentRNum ~= rNum then 
                break 
            end

            local bossTarget = nil
            local propTarget = nil
            local highestMaxHealth = -1

            for _, e in pairs(f:GetChildren()) do
                local hum = e:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if e.Name == PROP_NAME then
                        propTarget = e
                    elseif not IE[e.Name] then
                        if hum.MaxHealth > highestMaxHealth then
                            highestMaxHealth = hum.MaxHealth
                            bossTarget = e
                        end
                    end
                end
            end

            if (rNum == 10 or rNum == 15 or rNum == 20) and propTarget then
                _G.attackboss = false
                _G.attackprop = true
            elseif bossTarget then
                _G.attackprop = false
                _G.attackboss = true
            else
                _G.attackprop = false
                _G.attackboss = false
            end

            local activeTarget = nil
            if _G.attackprop and propTarget then
                activeTarget = propTarget
            elseif _G.attackboss and bossTarget then
                activeTarget = bossTarget
            end

            if activeTarget then
                pcall(function()
                    local hrp = activeTarget:FindFirstChild("HumanoidRootPart") or activeTarget:FindFirstChild("PrimaryPart") or activeTarget:FindFirstChildOfClass("Part")
                    local mHRP = gH()
                    if hrp and mHRP then
                        local myRole = getCurrentToolTip()
                        local heightOffset = 43
                        if myRole == "Blox Fruit" then
                            heightOffset = 5
                        elseif myRole == "Gun" then
                            heightOffset = 100
                        end
                        if modebuddha then heightOffset = 75 end
                        
                        local targetPos = hrp.Position + Vector3.new(0, heightOffset, 0)
                        TweenIsBoss(targetPos)
                    end
                end)
            else
                local exitPortal = fE()
                if exitPortal then
                    if not _G.PromotedRooms[rNum] then
                        _G.PromotedRooms[rNum] = true
                    end
                    pcall(function()
                        flyToNearestExit(exitPortal.Position + Vector3.new(0, 3, 0))
                    end)
                else
                    break
                end
            end
            task.wait()
        end
    end
    task.wait(0.1)
---------

            ---------
            else
                local f = workspace:FindFirstChild(EF)
                local h = gH()

                if f and h then 
                    local myRole = getCurrentToolTip()

                    if _G.LastToolPrinted ~= myRole then
                        print("Role Tool: " .. tostring(myRole))
                        _G.LastToolPrinted = myRole
                    end

                    _G.SelectWeapon = myRole
                    if myRole == "Gun" then
                        _G.dragontorm = true
                    else
                        _G.dragontorm = false
                    end

                    local yOffset = 33
                    if myRole == "Blox Fruit" then
                        yOffset = 5
                    elseif myRole == "Gun" then
                        yOffset = 100
                    end
                    if modebuddha then yOffset = 75 end

                    local highHpMobs = {}
                    local lowHpMobs = {}
                    local aliveMobsCount = 0
                    
                    for _, e in pairs(f:GetChildren()) do
                        if not IE[e.Name] then
                            local hrpE = e:FindFirstChild("HumanoidRootPart")
                            local humE = e:FindFirstChildOfClass("Humanoid")
                            if hrpE and humE and humE.Health > 0 then
                                aliveMobsCount = aliveMobsCount + 1
                                local maxHp = humE.MaxHealth > 0 and humE.MaxHealth or 100
                                if (humE.Health / maxHp) > 0.25 then
                                    table.insert(highHpMobs, e)
                                else
                                    table.insert(lowHpMobs, e)
                                end
                            end
                        end
                    end

                    local enemiesList = (#highHpMobs > 0) and highHpMobs or lowHpMobs

                    if aliveMobsCount > 0 then
                        updateUI("Clear Room " .. rNum, "Targeting Mobs")
                        local targetedAny = false

                        local totalPlayersConfig, myConfigIndex = getActivePlayersConfig()

                        table.sort(enemiesList, function(a, b)
                            local pA = a:FindFirstChild("HumanoidRootPart")
                            local pB = b:FindFirstChild("HumanoidRootPart")
                            if pA and pB then
                                return pA.Position.X < pB.Position.X 
                            end
                            return false
                        end)

                                                local myAreaMobs = {}
                        local otherAreaMobs = {}
                        local chunkSize = math.ceil(#enemiesList / totalPlayersConfig)
                        local startIdx = ((myConfigIndex - 1) * chunkSize) + 1
                        local endIdx = startIdx + chunkSize - 1

                        ---------
                        if not getgenv().CreateHologramWall then
                            getgenv().CreateHologramWall = function(position, size, color)
                                local TweenService = game:GetService("TweenService")
                                local RunService = game:GetService("RunService")
                                local Wall = Instance.new("Part")
                                Wall.Name = "HologramWall"
                                Wall.Size = size
                                Wall.Position = position
                                Wall.Anchored = true
                                Wall.CanCollide = false
                                Wall.CastShadow = false
                                Wall.Material = Enum.Material.ForceField
                                Wall.Color = color
                                Wall.Transparency = 0.4
                                
                                local UI_Elements = {}
                                local Texture = Instance.new("Texture")
                                Texture.Texture = "rbxassetid://10849912115"
                                Texture.Face = Enum.NormalId.Front
                                Texture.Color3 = color
                                Texture.Transparency = 0.6
                                Texture.StudsPerTileU = 5
                                Texture.StudsPerTileV = 5
                                Texture.Parent = Wall
                                table.insert(UI_Elements, Texture)
                                
                                for _, face in ipairs({Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right, Enum.NormalId.Top}) do
                                    local clone = Texture:Clone()
                                    clone.Face = face
                                    clone.Parent = Wall
                                    table.insert(UI_Elements, clone)
                                end
                                
                                Wall.Transparency = 1
                                Wall.Parent = workspace
                                
                                TweenService:Create(Wall, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.4}):Play()
                                
                                local connection
                                connection = RunService.RenderStepped:Connect(function(deltaTime)
                                    if not Wall or not Wall.Parent then
                                        connection:Disconnect()
                                        return
                                    end
                                    for _, tex in ipairs(UI_Elements) do
                                        tex.OffsetU = tex.OffsetU + (deltaTime * 0.2)
                                        tex.OffsetV = tex.OffsetV + (deltaTime * 0.1)
                                    end
                                end)
                                return Wall
                            end
                        end

                        if _G.HologramWalls then
                            for _, wall in ipairs(_G.HologramWalls) do
                                if wall and wall.Parent then wall:Destroy() end
                            end
                        end
                        _G.HologramWalls = {}
                        ---------

                        for i, mob in ipairs(enemiesList) do
                            if i >= startIdx and i <= endIdx then
                                table.insert(myAreaMobs, mob)
                            else
                                table.insert(otherAreaMobs, mob)
                            end
                        end

                        ---------
                        if totalPlayersConfig > 1 then
                            for i = 1, totalPlayersConfig - 1 do
                                local bIdx = i * chunkSize
                                if enemiesList[bIdx] and enemiesList[bIdx + 1] then
                                    local p1 = enemiesList[bIdx]:FindFirstChild("HumanoidRootPart")
                                    local p2 = enemiesList[bIdx + 1]:FindFirstChild("HumanoidRootPart")
                                    if p1 and p2 then
                                        local midX = (p1.Position.X + p2.Position.X) / 2
                                        local rc = getRoomCenter()
                                        local wallPos = rc and Vector3.new(midX, rc.Y + 20, rc.Z) or Vector3.new(midX, p1.Position.Y + 20, p1.Position.Z)
                                        local wallSize = Vector3.new(0.5, 200, 600)
                                        local color = (i == myConfigIndex or i == myConfigIndex - 1) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                                        local newWall = getgenv().CreateHologramWall(wallPos, wallSize, color)
                                        table.insert(_G.HologramWalls, newWall)
                                    end
                                end
                            end
                        end
                        ---------


                        ---------
                    local currentTargetList = #myAreaMobs > 0 and myAreaMobs or otherAreaMobs

                    if _G.W_Circle == nil then _G.W_Circle = 30 end
                    if _G.LastChange_Circle == nil then _G.LastChange_Circle = tick() end

                    local function RoundVector3Down(Vector)
                        return Vector3.new(math.floor(Vector.X / 10) * 10, math.floor(Vector.Y / 10) * 10, math.floor(Vector.Z / 10) * 10)
                    end

                    local function CaculateCircreDirection(PositionCFrame)
                        if _G.W_Circle > 50000 then _G.W_Circle = 60 end
                        _G.W_Circle = _G.W_Circle + ((tick() - _G.LastChange_Circle) > 0.4 and 80 or 0)
                        if tick() - _G.LastChange_Circle > 0.4 then _G.LastChange_Circle = tick() end
                        local TargetPosition = PositionCFrame.Position + Vector3.new(math.cos(math.rad(_G.W_Circle)) * 40, 0, math.sin(math.rad(_G.W_Circle)) * 40)
                        return CFrame.new(RoundVector3Down(TargetPosition))
                    end

                    for _, e in ipairs(currentTargetList) do
                        if not isAlive() then break end
                        targetedAny = true

                        while e.Parent and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and isAlive() do
                            local hrpE = e:FindFirstChild("HumanoidRootPart")
                            if not hrpE then break end

                            if #highHpMobs > 0 then
                                local humE = e:FindFirstChildOfClass("Humanoid")
                                if humE then
                                    local maxHp = humE.MaxHealth > 0 and humE.MaxHealth or 100
                                    if (humE.Health / maxHp) <= 0.25 then
                                        break
                                    end
                                end
                            end

                            local circlePos = CaculateCircreDirection(hrpE.CFrame).Position
                            tpTween(circlePos + Vector3.new(0, yOffset, 0))
                            task.wait(0.1)
                        end
                    end
---------



                        if not targetedAny and isAlive() then
                            local rc = getRoomCenter()
                            if rc then
                                local pP = rc - Vector3.new(0, 50, 0)
                                task.spawn(function() cP(pP) end)
                                tpTween(pP + Vector3.new(0, 15, 0))
                            end
                        end
                    else
                        updateUI("Tween To Portal", "Clear")
                    end
                end 
                task.wait(0.2)
            end
        end
    end)

    local TweenService = game:GetService("TweenService")

    ---------

    local function TweenObject(Object, Pos, Speed)
        Speed = Speed or 350
        if not Object or not Pos then return end
        local Distance = (Pos.Position - Object.Position).Magnitude
        local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Object, info, {CFrame = Pos})
        tween:Play()
    end

    ---------
                ---------
                
                ---------
local TweenService = game:GetService("TweenService")
_G.BringMobs = true
local ActiveBringMobs = {}
local MobTargetPositions = {}

local IE_Bring = {
    ["Blank Buddy"] = true,
    ["PropHitboxPlaceholder"] = true,
    ["Gas Knight"] = true,
    ["Zeno"] = true,
    ["Kitsune Lord"] = true,
    ["Ancient Beast"] = true
}

local function UpdateMobGroups()
    local mobs = {}
    local ef = workspace:FindFirstChild("Enemies")
    if ef then
        for _, mob in pairs(ef:GetChildren()) do
            if not IE_Bring[mob.Name] then
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    table.insert(mobs, mob)
                end
            end
        end
    end

    local n = #mobs
    if n == 0 then return end

    local unassigned = {}
    for _, m in ipairs(mobs) do table.insert(unassigned, m) end

    local groups = {}

    while #unassigned > 0 do
        if #unassigned == 4 then
            table.insert(groups, {unassigned[1], unassigned[2], unassigned[3], unassigned[4]})
            unassigned = {}
        elseif #unassigned == 2 then
            table.insert(groups, {unassigned[1], unassigned[2]})
            unassigned = {}
        elseif #unassigned == 1 then
            if #groups > 0 then
                table.insert(groups[#groups], unassigned[1])
            else
                table.insert(groups, {unassigned[1]})
            end
            unassigned = {}
        else
            local baseMob = table.remove(unassigned, 1)
            local basePos = baseMob.HumanoidRootPart.Position

            table.sort(unassigned, function(a, b)
                local distA = (a.HumanoidRootPart.Position - basePos).Magnitude
                local distB = (b.HumanoidRootPart.Position - basePos).Magnitude
                return distA < distB
            end)

            local closest1 = table.remove(unassigned, 1)
            local closest2 = table.remove(unassigned, 1)

            table.insert(groups, {baseMob, closest1, closest2})
        end
    end

    for _, grp in ipairs(groups) do
        local sumPos = Vector3.new(0, 0, 0)
        local count = 0
        for _, m in ipairs(grp) do
            if m and m:FindFirstChild("HumanoidRootPart") then
                sumPos = sumPos + m.HumanoidRootPart.Position
                count = count + 1
            end
        end
        if count > 0 then
            local center = sumPos / count
            for _, m in ipairs(grp) do
                MobTargetPositions[m] = center
            end
        end
    end
end

local function StartBringMob(mob)
    local rootQuai = mob:FindFirstChild("HumanoidRootPart")
    local humanoidQuai = mob:FindFirstChild("Humanoid")

    if not rootQuai or not humanoidQuai then return end

    pcall(function()
        plr.SimulationRadius = math.huge
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
                if not _G.BringMobs or not rootQuai or not rootQuai.Parent or humanoidQuai.Health <= 0 then
                    break
                end

                local targetPosition = MobTargetPositions[mob]

                if targetPosition then
                    local currentDistance = (rootQuai.Position - targetPosition).Magnitude

                    if currentDistance > 5 then
                        bodyPosition.P = 2000000000
                        bodyPosition.D = 500000
                        local speed = 300
                        local duration = currentDistance / speed
                        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        local tween = TweenService:Create(rootQuai, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                        tween:Play()
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
                end

                task.wait(0.02)
            end

            if bodyPosition then bodyPosition:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            ActiveBringMobs[mob] = nil
        end)
    end
end

task.spawn(function()
    while true do
        if _G.BringMobs then
            UpdateMobGroups()
            local ef = workspace:FindFirstChild("Enemies")
            if ef then
                for _, mob in pairs(ef:GetChildren()) do
                    if not IE_Bring[mob.Name] then
                        local humanoid = mob:FindFirstChild("Humanoid")
                        local primaryPart = mob:FindFirstChild("HumanoidRootPart")

                        if humanoid and humanoid.Health > 0 and primaryPart then
                            if not ActiveBringMobs[mob] then
                                ActiveBringMobs[mob] = true
                                StartBringMob(mob)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)
---------


                    
else
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/Dungeon-Pad.lua"))()
    end)
end
        
