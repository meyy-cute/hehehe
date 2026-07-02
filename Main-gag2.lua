-----------------------------------------------------------------------------------------
-- CONFIGURATION STATE (REPLACING GETGENV)
-----------------------------------------------------------------------------------------
local Config = {
    ["Max Plant Fruit"] = 200,
    ["Buy Expand Plot"] = false,
    ["Buy Slot Pet"] = false,
    ["Pet"] = {
        ["Auto Buy"] = {
            ["Enable"] = false,
            ["Pet"] = {},
        },
    },
    ["Plant Seed"] = {
        ["Enable"] = false,
        ["Mode"]   = "Random In Plot", 
        ["Seed"] = {},
    },
    ["Harvest"] = {
        ["Enable"] = false,
        ["All"]    = true,
        ["Fruit"]  = {}, 
        ["Only Mutation"]   = false,
        ["Ignore Mutation"] = false,
        ["Select Mutation Harvest"] = {},
        ["Select Mutation Ignore"]  = {},
        ["Weather Filter"]         = false,
        ["Only During Weather"]    = false,
        ["Select Weather"]         = {},
    },
    ["Sell"] = {
        ["Enable"]    = false,
        ["When Full"] = false,
    },
    ["Buy Seed"] = {
        ["Enable"] = false,
        ["Seed"] = {},
    },
    ["Buy Gear"] = {
        ["Enable"] = false,
        ["Gear"] = {},
    },
    ["Buy Crate"] = {
        ["Enable"] = false,
        ["Crate"] = {},
    },
    ["Destroy Plant"] = {
        ["By Name"]   = false,
        ["By Rarity"] = false,
        ["Name"]   = {},
        ["Rarity"] = {},
    },
    ["Seed Pack"] = {
        ["Enable"] = false,
    },
    ["Pet Spawn"] = {
        ["Enable"] = false,
    },
    ["Anti Steal"] = {
        ["Enable"] = false,
        ["Height"] = 3,
        ["Interval"] = 2,
    },
    ["Settings"] = {
        ["Move Mode"]    = "TP",
        ["Tween Speed"]  = 350,
        ["Anti AFK"]     = true,
        ["Plant Delay"]  = 0.2,
        ["Harvest Delay"]= 0.05,
        ["Sell Delay"]   = 0.2,
        ["Shovel Delay"] = 0.2,
    },
}

local EnableLog = true

local function logAction(mainAction, subAction)
    if not EnableLog then return end
    local msg = subAction and ("[Log] " .. mainAction .. " | " .. subAction) or ("[Log] " .. mainAction)
    print(msg)
end

local function updateBoolMap(targetTable, selectedArray)
    for k, _ in pairs(targetTable) do targetTable[k] = false end
    for _, v in ipairs(selectedArray) do targetTable[v] = true end
end

-----------------------------------------------------------------------------------------
-- CORE VARIABLES
-----------------------------------------------------------------------------------------
local Modules = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local PPS = game:GetService("ProximityPromptService")
PPS.MaxPromptsVisible = 100

local Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
local Packet = RS.SharedModules.Packet.RemoteEvent
local hide = LP:FindFirstChild("HideCollectProximityPrompts")
local rarityMap = {}

local successRarity = pcall(function()
    local SD = require(RS:WaitForChild("SharedModules"):WaitForChild("SeedData"))
    for _, data in ipairs(SD) do
        if data.SeedName and data.Rarity then rarityMap[data.SeedName] = data.Rarity end
    end
end)

if not successRarity or next(rarityMap) == nil then
    rarityMap = {
        Carrot="Common",Strawberry="Common",Blueberry="Common",Tulip="Uncommon",Tomato="Uncommon",
        Apple="Uncommon",Bamboo="Rare",Corn="Rare",Cactus="Rare",Pineapple="Rare",Mushroom="Epic",
        ["Green Bean"]="Epic",Banana="Epic",Grape="Epic",Coconut="Epic",Mango="Epic",
        ["Dragon Fruit"]="Legendary",Acorn="Legendary",Cherry="Legendary",Sunflower="Legendary",
        ["Venus Fly Trap"]="Mythic",Pomegranate="Mythic",["Poison Apple"]="Mythic",
        ["Moon Bloom"]="Super",["Dragon's Breath"]="Super",["Ghost Pepper"]="Mythic",
        ["Poison Ivy"]="Legendary",["Baby Cactus"]="Rare",["Glow Mushroom"]="Epic",
        Romanesco="Mythic",["Horned Melon"]="Rare",Gold="Legendary",Rainbow="Mythic"
    }
end

-----------------------------------------------------------------------------------------
-- MODULES LOGIC
-----------------------------------------------------------------------------------------
function Modules.FirePrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputHoldBegin()
        task.wait(0.01)
        prompt:InputHoldEnd()
    end
end

function Modules.getModel(instance)
    if not instance then return nil end
    return instance:FindFirstAncestorOfClass("Model")
end

function Modules.isWeatherActive(name)
    local obj = RS:FindFirstChild(name)
    if obj and obj:IsA("BoolValue") then return obj.Value == true end
    return false
end

function Modules.modelHasMutation(model, mutationTable)
    local mutation = model:GetAttribute("Mutation")
    if not mutation then return false end
    for name, selected in pairs(mutationTable) do
        if selected and mutation == name then return true end
    end
    return false
end

function Modules.tweenTo(position)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Config.Settings["Tween Speed"] or 350
    local dist = (hrp.Position - position).Magnitude
    local duration = math.max(dist / speed, 0.05)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero; bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Parent = hrp
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
    tween:Play(); tween.Completed:Wait(); bv:Destroy()
end

function Modules.teleportTo(position)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(position)
end

function Modules.moveTo(position)
    if Config.Settings["Move Mode"] == "Tween" then
        Modules.tweenTo(position)
    else
        Modules.teleportTo(position)
    end
end

function Modules.returnToHomePlot()
    local plotId = LP:GetAttribute("PlotId")
    if plotId then
        local plot = workspace.Gardens and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
        if plot then
            local ref = plot:FindFirstChild("PlotSizeReference")
            if ref then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(ref.Position + Vector3.new(0,5,0)); return end
            end
            Modules.moveTo(plot:GetPivot().Position + Vector3.new(0,5,0))
            return
        end
    end
    Modules.moveTo(Vector3.new(0,10,0))
end

function Modules.shouldHarvestModel(model)
    local cfg = Config.Harvest
    if cfg["Only Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Harvest"]) do if v then anySelected = true break end end
        if not anySelected then return false end
        if not Modules.modelHasMutation(model, cfg["Select Mutation Harvest"]) then return false end
    end

    if cfg["Ignore Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Ignore"]) do if v then anySelected = true break end end
        if anySelected then
            if Modules.modelHasMutation(model, cfg["Select Mutation Ignore"]) then return false end
        end
    end

    if cfg["Weather Filter"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Weather"]) do if v then anySelected = true break end end
        if anySelected then
            for name, selected in pairs(cfg["Select Weather"]) do
                if selected and Modules.isWeatherActive(name) then return false end
            end
        end
    end

    if cfg["Only During Weather"] then
        local anySelected, anyActive = false, false
        for name, selected in pairs(cfg["Select Weather"]) do
            if selected then
                anySelected = true
                if Modules.isWeatherActive(name) then anyActive = true end
            end
        end
        if anySelected and not anyActive then return false end
    end
    return true
end

local processingPrompts = {}
function Modules.harvestPrompt(prompt)
    if processingPrompts[prompt] then return end
    local model = Modules.getModel(prompt)
    if not model then return end
    local plantId = model:GetAttribute("PlantId")
    local fruitId = model:GetAttribute("FruitId") or ""
    local plantName = model:GetAttribute("CorePartName") or model:GetAttribute("SeedName") or fruitId

    local shouldHarvest = false
    if Config.Harvest.All then
        shouldHarvest = true
    elseif Config.Harvest.Fruit[plantName] then
        shouldHarvest = true
    end

    if shouldHarvest then shouldHarvest = Modules.shouldHarvestModel(model) end

    if plantId and shouldHarvest then
        processingPrompts[prompt] = true
        task.spawn(function()
            local oldDist = prompt.MaxActivationDistance
            prompt.MaxActivationDistance = math.huge
            prompt:InputHoldBegin()
            task.wait(0.01)
            prompt:InputHoldEnd()
            Networking.Garden.CollectFruit:Fire(plantId, fruitId)
            prompt.MaxActivationDistance = oldDist
            task.wait(0.2)
            processingPrompts[prompt] = nil
        end)
    end
end

function Modules.harvestLoop()
    while true do
        if Config.Harvest.Enable and (not hide or not hide.Value) then
            for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    task.spawn(Modules.harvestPrompt, prompt)
                end
            end
        end
        task.wait(Config.Settings["Harvest Delay"] or 0.05)
    end
end

function Modules.sellLoop()
    while true do
        if Config.Sell.Enable then
            logAction("Auto Sell", "Sold all")
            Networking.NPCS.SellAll:Fire()
        end
        task.wait(Config.Settings["Sell Delay"] or 0.2)
    end
end

function Modules.sellFullLoop()
    while true do
        if Config.Sell["When Full"] then
            local ok, result = pcall(function()
                return LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
            end)
            if ok and result then
                local current, max = result:match("(%d+)/(%d+)")
                if current and max and tonumber(current) >= tonumber(max) then
                    logAction("Auto Sell Full", "Backpack full")
                    Networking.NPCS.SellAll:Fire()
                end
            end
        end
        task.wait(Config.Settings["Sell Delay"] or 0.2)
    end
end

function Modules.shopLoop()
    while true do
        if Config["Buy Seed"].Enable then
            for name, enabled in pairs(Config["Buy Seed"].Seed) do
                if enabled then
                    logAction("Buy Seed", name)
                    Packet:FireServer(103, name)
                    task.wait(0.2)
                end
            end
        end
        if Config["Buy Gear"].Enable then
            for name, enabled in pairs(Config["Buy Gear"].Gear) do
                if enabled then
                    logAction("Buy Gear", name)
                    Packet:FireServer(107, name)
                    task.wait(0.2)
                end
            end
        end
        if Config["Buy Crate"].Enable then
            for name, enabled in pairs(Config["Buy Crate"].Crate) do
                if enabled then
                    logAction("Buy Crate", name)
                    Packet:FireServer(103, name)
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.2)
    end
end

function Modules.getPlantAreaGround(position)
    local rayOrigin = position + Vector3.new(0,5,0)
    local rayDirection = Vector3.new(0,-20,0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {workspace.Gardens}
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then return result.Position + Vector3.new(0,0.1,0) end
    return nil
end

function Modules.plantSeedAtPosition(position)
    if not Config["Plant Seed"].Enable then return false end
    local selectedSeeds = {}
    for name, enabled in pairs(Config["Plant Seed"].Seed) do
        if enabled then table.insert(selectedSeeds, name) end
    end
    if #selectedSeeds == 0 then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return false end

    local seedTool = nil
    for _, name in ipairs(selectedSeeds) do
        for _, tool in backpack:GetChildren() do
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then
                seedTool = tool
                break
            end
        end
        if seedTool then break end
    end

    if not seedTool then return false end
    logAction("Auto Plant", seedTool.Name)
    Networking.Plant.PlantSeed:Fire(position, seedTool:GetAttribute("SeedTool"), seedTool)
    return true
end

function Modules.autoPlantLoop()
    while true do
        if Config["Plant Seed"].Enable then
            local plotId = LP:GetAttribute("PlotId")
            local plot = plotId and workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. plotId)
            if plot then
                local targetPos
                local mode = Config["Plant Seed"].Mode or "Random In Plot"

                if mode == "Under Player" then
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local groundPos = Modules.getPlantAreaGround(hrp.Position)
                        if groundPos then targetPos = groundPos end
                    end
                else
                    local plantAreas = CollectionService:GetTagged("PlantArea")
                    local plotPlantAreas = {}
                    for _, area in ipairs(plantAreas) do
                        if area:IsDescendantOf(plot) then table.insert(plotPlantAreas, area) end
                    end
                    if #plotPlantAreas > 0 then
                        local area = plotPlantAreas[math.random(1, #plotPlantAreas)]
                        local pos = area.Position
                        local size = area.Size
                        targetPos = Vector3.new(
                            pos.X + (math.random()-0.5)*size.X,
                            pos.Y + size.Y/2 + 0.1,
                            pos.Z + (math.random()-0.5)*size.Z
                        )
                    end
                end

                if targetPos then Modules.plantSeedAtPosition(targetPos) end
            end
        end
        task.wait(Config.Settings["Plant Delay"] or 0.2)
    end
end

function Modules.equipShovel()
    local char = LP.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local alreadyEquipped = char:FindFirstChild("Shovel")
    if alreadyEquipped and alreadyEquipped:IsA("Tool") and alreadyEquipped:GetAttribute("Shovel") then
        return alreadyEquipped
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return nil end
    for _, tool in backpack:GetChildren() do
        if tool:IsA("Tool") and tool.Name == "Shovel" and tool:GetAttribute("Shovel") then
            humanoid:EquipTool(tool)
            task.wait(0.1)
            return tool
        end
    end
    return nil
end

function Modules.plantMatchesDestroy(seedName)
    local cfg = Config["Destroy Plant"]
    local matchName = false
    local matchRarity = false

    if cfg["By Name"] then
        local anySelected = false
        for _, v in pairs(cfg.Name) do if v then anySelected = true break end end
        if anySelected then
            if cfg.Name["All"] then matchName = true
            elseif cfg.Name[seedName] then matchName = true end
        end
    end

    if cfg["By Rarity"] then
        local anySelected = false
        for _, v in pairs(cfg.Rarity) do if v then anySelected = true break end end
        if anySelected then
            local plantRarity = rarityMap[seedName] or "Common"
            if cfg.Rarity["All"] then matchRarity = true
            elseif cfg.Rarity[plantRarity] then matchRarity = true end
        end
    end

    return matchName or matchRarity
end

function Modules.autoShovelLoop()
    while true do
        local cfg = Config["Destroy Plant"]
        if cfg["By Name"] or cfg["By Rarity"] then
            local plotId = LP:GetAttribute("PlotId")
            if plotId then
                local gardens = workspace:FindFirstChild("Gardens")
                local plot = gardens and gardens:FindFirstChild("Plot" .. tostring(plotId))
                if plot then
                    local plantsFolder = plot:FindFirstChild("Plants")
                    if plantsFolder then
                        local candidates = {}
                        for _, plant in ipairs(plantsFolder:GetChildren()) do
                            if plant:IsA("Model") then
                                local seedName = plant:GetAttribute("SeedName")
                                if seedName and Modules.plantMatchesDestroy(seedName) then
                                    table.insert(candidates, plant)
                                end
                            end
                        end
                        if #candidates > 0 then
                            local shovelTool = Modules.equipShovel()
                            if shovelTool then
                                local shovelType = shovelTool:GetAttribute("Shovel")
                                for _, plant in ipairs(candidates) do
                                    if not cfg["By Name"] and not cfg["By Rarity"] then break end
                                    if not plant or not plant.Parent then
                                        task.wait(Config.Settings["Shovel Delay"] or 0.2)
                                        continue
                                    end
                                    local plantId = plant:GetAttribute("PlantId")
                                    local seedName = plant:GetAttribute("SeedName") or "plant"
                                    if plantId and shovelType then
                                        pcall(function() Networking.Shovel.UseShovel:Fire(plantId, "", shovelType, shovelTool) end)
                                        logAction("Auto Destroy", seedName)
                                    end
                                    task.wait(Config.Settings["Shovel Delay"] or 0.2)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end

local function getSeedLocations()
    local seeds = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local serverLocs = map:FindFirstChild("SeedPackSpawnServerLocations")
        if serverLocs then
            for _, part in ipairs(serverLocs:GetChildren()) do
                if part:IsA("BasePart") then
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        table.insert(seeds, {model=part, pos=part.Position + Vector3.new(0, part.Size.Y/2+3, 0)})
                    end
                end
            end
        end
    end
    if #seeds == 0 then
        for _, tag in ipairs({"SeedPrompt","CollectSeed","SeedPackPrompt"}) do
            for _, prompt in ipairs(CollectionService:GetTagged(tag)) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local parent = prompt.Parent
                    if parent:IsA("BasePart") then
                        table.insert(seeds, {model=parent, pos=parent.Position + Vector3.new(0, parent.Size.Y/2+3, 0)})
                    end
                end
            end
        end
    end
    if #seeds == 0 then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled and
                (obj.Name:lower():find("seed") or obj.Name:lower():find("pickup")) then
                local parent = obj.Parent
                if parent:IsA("BasePart") then
                    table.insert(seeds, {model=parent, pos=parent.Position + Vector3.new(0, parent.Size.Y/2+3, 0)})
                end
            end
        end
    end
    return seeds
end

local function tpAndFireSeedPrompt(seed)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(seed.pos)
    task.wait(0.15)
    local prompt = seed.model:FindFirstChildWhichIsA("ProximityPrompt")
    if not prompt then return end
    local old = prompt.MaxActivationDistance
    prompt.MaxActivationDistance = 100
    Modules.FirePrompt(prompt)
    prompt.MaxActivationDistance = old
end

function Modules.autoCollectSeedPacksLoop()
    while true do
        if Config["Seed Pack"].Enable then
            local seeds = getSeedLocations()
            if #seeds > 0 then
                for _, seed in ipairs(seeds) do
                    if not Config["Seed Pack"].Enable then break end
                    tpAndFireSeedPrompt(seed)
                    logAction("Seed Pack", "Collected")
                    task.wait(0.3)
                end
                Modules.returnToHomePlot()
            end
        end
        task.wait(1)
    end
end

function Modules.autoBuyPetSpawnLoop()
    while true do
        if Config["Pet Spawn"].Enable then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local wildPetSpawns = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetSpawns")
                if wildPetSpawns then
                    for _, spawnObj in ipairs(wildPetSpawns:GetChildren()) do
                        if not Config["Pet Spawn"].Enable then break end
                        local spawnPos
                        if spawnObj:IsA("BasePart") then
                            spawnPos = spawnObj.Position + Vector3.new(0,3,0)
                        elseif spawnObj:IsA("Model") then
                            spawnPos = spawnObj:GetPivot().Position + Vector3.new(0,3,0)
                        end
                        if not spawnPos then continue end
                        hrp.CFrame = CFrame.new(spawnPos)
                        task.wait(0.15)
                        local bestPrompt, bestDist = nil, math.huge
                        local checkPos = hrp.Position
                        for _, desc in ipairs(spawnObj:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") and desc.Enabled then
                                local part = desc.Parent
                                if part and part:IsA("BasePart") then
                                    local d = (part.Position - checkPos).Magnitude
                                    if d < bestDist then bestDist = d; bestPrompt = desc end
                                end
                            end
                        end
                        if not bestPrompt then
                            for _, desc in ipairs(wildPetSpawns:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") and desc.Enabled then
                                    local part = desc.Parent
                                    if part and part:IsA("BasePart") then
                                        local d = (part.Position - checkPos).Magnitude
                                        if d < bestDist then bestDist = d; bestPrompt = desc end
                                    end
                                end
                            end
                        end
                        if bestPrompt then
                            local old = bestPrompt.MaxActivationDistance
                            bestPrompt.MaxActivationDistance = 100
                            Modules.FirePrompt(bestPrompt)
                            bestPrompt.MaxActivationDistance = old
                            logAction("Pet Spawn", spawnObj.Name)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end

function Modules.antiAfkLoop()
    while true do
        if Config.Settings["Anti AFK"] then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end
        task.wait(300)
    end
end

function Modules.getPlotCenter()
    local plotId = LP:GetAttribute("PlotId")
    if not plotId then return nil end
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return nil end
    local plot = gardens:FindFirstChild("Plot" .. tostring(plotId))
    if not plot then return nil end

    local ref = plot:FindFirstChild("PlotSizeReference")
    if ref and ref:IsA("BasePart") then
        return ref.Position + Vector3.new(0, Config["Anti Steal"].Height or 3, 0)
    end
    local plantAreas = CollectionService:GetTagged("PlantArea")
    local sumX, sumY, sumZ, count = 0, 0, 0, 0
    for _, area in ipairs(plantAreas) do
        if area:IsDescendantOf(plot) and area:IsA("BasePart") then
            sumX += area.Position.X
            sumY += area.Position.Y
            sumZ += area.Position.Z
            count += 1
        end
    end
    if count > 0 then
        return Vector3.new(sumX/count, sumY/count + (Config["Anti Steal"].Height or 3), sumZ/count)
    end

    local ok, pivot = pcall(function() return plot:GetPivot() end)
    if ok and pivot then
        return pivot.Position + Vector3.new(0, Config["Anti Steal"].Height or 3, 0)
    end
    return nil
end

function Modules.antiStealLoop()
    while true do
        if Config["Anti Steal"].Enable then
            local center = Modules.getPlotCenter()
            if center then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - center).Magnitude > 2 then
                    hrp.CFrame = CFrame.new(center)
                    logAction("Anti Steal", "Moved to plot center")
                end
            end
        end
        task.wait(Config["Anti Steal"].Interval or 2)
    end
end

-----------------------------------------------------------------------------------------
-- MEYY HUB UI INTEGRATION
-----------------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/library.lua"))()

local Window = Library:CreateWindow({
    Title = "Meyy Hub Kaitun"
})

-- TABS
local FarmTab    = Window:CreateTab("Farming", true, "0")
local ShopTab    = Window:CreateTab("Auto Shop", false, "0")
local MiscTab    = Window:CreateTab("Miscellaneous", false, "0")
local ConfigTab  = Window:CreateTab("Settings", false, "0")

-- LIST DATA
local allSeedsList = {
    "Carrot", "Strawberry", "Bamboo", "Blueberry", "Tulip", "Apple", "Tomato", 
    "Banana", "Sunflower", "Corn", "Mushroom", "Cherry", "Mango", "Grape", 
    "Coconut", "Cactus", "Baby Cactus", "Pomegranate", "Pineapple", "Dragon Fruit", 
    "Poison Apple", "Moon Bloom", "Poison Ivy", "Ghost Pepper", "Venus Fly Trap", "Dragon's Breath"
}
local allGearList = {
    "Common Watering Can", "Super Watering Can", "Common Sprinkler", "Uncommon Sprinkler", 
    "Rare Sprinkler", "Legendary Sprinkler", "Super Sprinkler"
}
local allCratesList = {"Ladder Crate", "Bench Crate"}
local allPetsList = {
    "IceSerpent", "Raccoon", "Unicorn", "GoldenDragonfly", "BlackDragon", "Monkey", 
    "Bee", "Robin", "Deer", "Owl", "Bunny", "Frog"
}
local allRarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super", "Divine", "Prismatic"}

-- 1. FARMING TAB
FarmTab:CreatePageTitle("Auto Plant")

FarmTab:CreateSwitch("Enable Auto Plant", false, "Automatically plant selected seeds", function(state)
    Config["Plant Seed"].Enable = state
end)

FarmTab:CreateDropdown("Plant Mode", "Random In Plot", {"Random In Plot", "Under Player"}, "Select planting behavior", function(selected)
    Config["Plant Seed"].Mode = selected
end)

FarmTab:CreateMultiDropdown("Select Seeds to Plant", {}, allSeedsList, "Choose which seeds to plant", function(selectedItems)
    updateBoolMap(Config["Plant Seed"].Seed, selectedItems)
end)

FarmTab:CreatePageTitle("Auto Harvest")

FarmTab:CreateSwitch("Enable Auto Harvest", false, "Automatically harvest ready fruits", function(state)
    Config.Harvest.Enable = state
end)

FarmTab:CreateSwitch("Harvest All Types", true, "Harvest everything or specific fruits", function(state)
    Config.Harvest.All = state
end)

FarmTab:CreateMultiDropdown("Select Specific Fruits", {}, allSeedsList, "Only used if Harvest All Types is OFF", function(selectedItems)
    updateBoolMap(Config.Harvest.Fruit, selectedItems)
end)

FarmTab:CreatePageSubTitle("Mutation Settings")

FarmTab:CreateSwitch("Only Harvest Mutations", false, "Ignore normal fruits", function(state)
    Config.Harvest["Only Mutation"] = state
end)

FarmTab:CreateMultiDropdown("Select Harvest Mutations", {}, {"Gold", "Rainbow"}, "Which mutations to harvest", function(selectedItems)
    updateBoolMap(Config.Harvest["Select Mutation Harvest"], selectedItems)
end)

FarmTab:CreateSwitch("Ignore Mutations", false, "Do not harvest specific mutations", function(state)
    Config.Harvest["Ignore Mutation"] = state
end)

FarmTab:CreateMultiDropdown("Select Ignore Mutations", {}, {"Gold", "Rainbow"}, "Which mutations to ignore", function(selectedItems)
    updateBoolMap(Config.Harvest["Select Mutation Ignore"], selectedItems)
end)

-- 2. SHOP TAB
ShopTab:CreatePageTitle("Auto Buy Seed")

ShopTab:CreateSwitch("Enable Auto Buy Seed", false, "Buy seeds automatically", function(state)
    Config["Buy Seed"].Enable = state
end)

ShopTab:CreateMultiDropdown("Select Buy Seeds", {}, allSeedsList, "Choose seeds to purchase", function(selectedItems)
    updateBoolMap(Config["Buy Seed"].Seed, selectedItems)
end)

ShopTab:CreatePageTitle("Auto Buy Gear")

ShopTab:CreateSwitch("Enable Auto Buy Gear", false, "Buy gears automatically", function(state)
    Config["Buy Gear"].Enable = state
end)

ShopTab:CreateMultiDropdown("Select Buy Gears", {}, allGearList, "Choose gears to purchase", function(selectedItems)
    updateBoolMap(Config["Buy Gear"].Gear, selectedItems)
end)

ShopTab:CreatePageTitle("Auto Buy Crate")

ShopTab:CreateSwitch("Enable Auto Buy Crate", false, "Buy crates automatically", function(state)
    Config["Buy Crate"].Enable = state
end)

ShopTab:CreateMultiDropdown("Select Buy Crates", {}, allCratesList, "Choose crates to purchase", function(selectedItems)
    updateBoolMap(Config["Buy Crate"].Crate, selectedItems)
end)

ShopTab:CreatePageTitle("Auto Buy Pet")

ShopTab:CreateSwitch("Enable Auto Buy Pet", false, "Buy pets automatically", function(state)
    Config.Pet["Auto Buy"].Enable = state
end)

ShopTab:CreateMultiDropdown("Select Buy Pets", {}, allPetsList, "Choose pets to purchase", function(selectedItems)
    updateBoolMap(Config.Pet["Auto Buy"].Pet, selectedItems)
end)

-- 3. MISC TAB
MiscTab:CreatePageTitle("Selling")

MiscTab:CreateSwitch("Auto Sell Continuous", false, "Sell continuously", function(state)
    Config.Sell.Enable = state
end)

MiscTab:CreateSwitch("Auto Sell When Full", false, "Sell only when backpack is full", function(state)
    Config.Sell["When Full"] = state
end)

MiscTab:CreatePageTitle("Auto Destroy (Shovel)")

MiscTab:CreateSwitch("Destroy By Name", false, "Enable filtering by name", function(state)
    Config["Destroy Plant"]["By Name"] = state
end)

local shovelNameList = {"All"}
for _, v in ipairs(allSeedsList) do table.insert(shovelNameList, v) end
MiscTab:CreateMultiDropdown("Destroy Name Filter", {}, shovelNameList, "Select names to destroy", function(selectedItems)
    updateBoolMap(Config["Destroy Plant"].Name, selectedItems)
end)

MiscTab:CreateSwitch("Destroy By Rarity", false, "Enable filtering by rarity", function(state)
    Config["Destroy Plant"]["By Rarity"] = state
end)

local shovelRarityList = {"All"}
for _, v in ipairs(allRarityList) do table.insert(shovelRarityList, v) end
MiscTab:CreateMultiDropdown("Destroy Rarity Filter", {}, shovelRarityList, "Select rarities to destroy", function(selectedItems)
    updateBoolMap(Config["Destroy Plant"].Rarity, selectedItems)
end)

MiscTab:CreatePageTitle("World Events")

MiscTab:CreateSwitch("Auto Collect Seed Packs", false, "Teleport and collect packs", function(state)
    Config["Seed Pack"].Enable = state
end)

MiscTab:CreateSwitch("Auto Pet Spawn", false, "Teleport to wild pets", function(state)
    Config["Pet Spawn"].Enable = state
end)

MiscTab:CreateSwitch("Anti Steal", false, "Return to center if moved", function(state)
    Config["Anti Steal"].Enable = state
end)

-- 4. CONFIG/SETTINGS TAB
ConfigTab:CreatePageTitle("System Settings")

ConfigTab:CreateDropdown("Theme Color", "Dream", {"Ocean", "Dream", "Dark"}, "Change UI colors", function(selected)
    Window:ApplyTheme(selected)
end)

ConfigTab:CreateSwitch("Anti AFK", true, "Prevent disconnection", function(state)
    Config.Settings["Anti AFK"] = state
end)

ConfigTab:CreateDropdown("Move Mode", "TP", {"TP", "Tween"}, "Teleport or Walk/Tween", function(selected)
    Config.Settings["Move Mode"] = selected
end)

ConfigTab:CreatePageSubTitle("Delays (Advanced)")

ConfigTab:CreateSlider("Plant Delay (ms)", 10, 2000, 200, "Delay between plants", function(value)
    Config.Settings["Plant Delay"] = value / 1000
end)

ConfigTab:CreateSlider("Harvest Delay (ms)", 10, 1000, 50, "Delay between harvests", function(value)
    Config.Settings["Harvest Delay"] = value / 1000
end)

ConfigTab:CreateSlider("Sell Delay (ms)", 50, 2000, 200, "Delay between sells", function(value)
    Config.Settings["Sell Delay"] = value / 1000
end)

ConfigTab:CreateSlider("Shovel Delay (ms)", 50, 2000, 200, "Delay between destroys", function(value)
    Config.Settings["Shovel Delay"] = value / 1000
end)

-----------------------------------------------------------------------------------------
-- INITIALIZE BACKGROUND TASKS
-----------------------------------------------------------------------------------------
task.spawn(Modules.harvestLoop)
task.spawn(Modules.sellLoop)
task.spawn(Modules.sellFullLoop)
task.spawn(Modules.shopLoop)
task.spawn(Modules.autoPlantLoop)
task.spawn(Modules.autoShovelLoop)
task.spawn(Modules.autoCollectSeedPacksLoop)
task.spawn(Modules.autoBuyPetSpawnLoop)
task.spawn(Modules.antiAfkLoop)
task.spawn(Modules.antiStealLoop)

Library:SendNotification("Meyy Hub", "Loaded successfully! GLHF~")
