-- ---------
-- GaG2 Main Hub UI - Converted by meyy~
-- ---------

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/meyy-cute/meyy-hub/refs/heads/main/library.lua"))()

local Window = Library:CreateWindow({
    Title = "GaG2 Premium Hub"
})

-- ---------
-- CORE CONFIGURATION STATE
-- ---------
local Config = {
    Harvest = {
        Enable = false,
        All = true,
        Fruit = {},
        OnlyMutation = false,
        IgnoreMutation = false,
        WeatherFilter = false
    },
    Sell = {
        Enable = false,
        WhenFull = false
    },
    Plant = {
        Enable = false,
        Mode = "Random In Plot",
        Seeds = {}
    },
    Destroy = {
        ByName = false,
        ByRarity = false,
        Names = {},
        Rarities = {}
    },
    Shop = {
        EnableSeeds = false,
        Seeds = {},
        EnableGears = false,
        Gears = {},
        EnableCrates = false,
        Crates = {}
    },
    Pets = {
        Spawn = false,
        AutoBuy = false,
        Selected = {}
    },
    Settings = {
        MoveMode = "TP",
        TweenSpeed = 350,
        AntiAFK = true,
        PlantDelay = 0.2,
        HarvestDelay = 0.05,
        SellDelay = 0.2,
        ShovelDelay = 0.2
    },
    Misc = {
        SeedPack = false,
        AntiSteal = false,
        AntiStealHeight = 3,
        AntiStealInterval = 2
    }
}

-- ---------
-- GAME SERVICES & VARIABLES
-- ---------
local Modules = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local PPS = game:GetService("ProximityPromptService")
PPS.MaxPromptsVisible = 100

local Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
local Packet = RS.SharedModules.Packet.RemoteEvent
local hide = LP:FindFirstChild("HideCollectProximityPrompts")

local rarityMap = {
    Carrot="Common", Strawberry="Common", Blueberry="Common", Tulip="Uncommon", Tomato="Uncommon",
    Apple="Uncommon", Bamboo="Rare", Corn="Rare", Cactus="Rare", Pineapple="Rare", Mushroom="Epic",
    ["Green Bean"]="Epic", Banana="Epic", Grape="Epic", Coconut="Epic", Mango="Epic",
    ["Dragon Fruit"]="Legendary", Acorn="Legendary", Cherry="Legendary", Sunflower="Legendary",
    ["Venus Fly Trap"]="Mythic", Pomegranate="Mythic", ["Poison Apple"]="Mythic",
    ["Moon Bloom"]="Super", ["Dragon's Breath"]="Super", ["Ghost Pepper"]="Mythic",
    ["Poison Ivy"]="Legendary", ["Baby Cactus"]="Rare", ["Glow Mushroom"]="Epic",
    Romanesco="Mythic", ["Horned Melon"]="Rare", Gold="Legendary", Rainbow="Mythic"
}

-- Lists for UI
local SEED_LIST = {"Carrot", "Strawberry", "Bamboo", "Blueberry", "Tulip", "Apple", "Tomato", "Banana", "Sunflower", "Corn", "Mushroom", "Cherry", "Mango", "Grape", "Coconut", "Cactus", "Baby Cactus", "Pomegranate", "Pineapple", "Dragon Fruit", "Poison Apple", "Moon Bloom", "Poison Ivy", "Ghost Pepper", "Venus Fly Trap", "Dragon's Breath"}
local GEAR_LIST = {"Common Watering Can", "Super Watering Can", "Common Sprinkler", "Uncommon Sprinkler", "Rare Sprinkler", "Legendary Sprinkler", "Super Sprinkler"}
local CRATE_LIST = {"Ladder Crate", "Bench Crate"}
local PET_LIST = {"IceSerpent", "Raccoon", "Unicorn", "GoldenDragonfly", "BlackDragon", "Monkey", "Bee", "Robin", "Deer", "Owl", "Bunny", "Frog"}
local RARITY_LIST = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super", "Divine", "Prismatic"}

-- ---------
-- CORE LOGIC FUNCTIONS
-- ---------
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

function Modules.tweenTo(position)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Config.Settings.TweenSpeed
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
    if Config.Settings.MoveMode == "Tween" then
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

-- HARVEST LOGIC
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
    else
        for _, name in pairs(Config.Harvest.Fruit) do
            if name == plantName then shouldHarvest = true break end
        end
    end

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
        task.wait(Config.Settings.HarvestDelay)
    end
end

-- SELL LOGIC
function Modules.sellLoop()
    while true do
        if Config.Sell.Enable then
            Networking.NPCS.SellAll:Fire()
        end
        task.wait(Config.Settings.SellDelay)
    end
end

function Modules.sellFullLoop()
    while true do
        if Config.Sell.WhenFull then
            local ok, result = pcall(function()
                return LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
            end)
            if ok and result then
                local current, max = result:match("(%d+)/(%d+)")
                if current and max and tonumber(current) >= tonumber(max) then
                    Networking.NPCS.SellAll:Fire()
                end
            end
        end
        task.wait(Config.Settings.SellDelay)
    end
end

-- SHOP LOGIC
function Modules.shopLoop()
    while true do
        if Config.Shop.EnableSeeds then
            for _, name in pairs(Config.Shop.Seeds) do
                Packet:FireServer(103, name)
                task.wait(0.2)
            end
        end
        if Config.Shop.EnableGears then
            for _, name in pairs(Config.Shop.Gears) do
                Packet:FireServer(107, name)
                task.wait(0.2)
            end
        end
        if Config.Shop.EnableCrates then
            for _, name in pairs(Config.Shop.Crates) do
                Packet:FireServer(103, name)
                task.wait(0.2)
            end
        end
        task.wait(1)
    end
end

-- PLANT LOGIC
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
    if not Config.Plant.Enable or #Config.Plant.Seeds == 0 then return false end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return false end

    local seedTool = nil
    for _, name in ipairs(Config.Plant.Seeds) do
        for _, tool in backpack:GetChildren() do
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then
                seedTool = tool
                break
            end
        end
        if seedTool then break end
    end

    if not seedTool then return false end
    Networking.Plant.PlantSeed:Fire(position, seedTool:GetAttribute("SeedTool"), seedTool)
    return true
end

function Modules.autoPlantLoop()
    while true do
        if Config.Plant.Enable then
            local plotId = LP:GetAttribute("PlotId")
            local plot = plotId and workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. plotId)
            if plot then
                local targetPos
                if Config.Plant.Mode == "Under Player" then
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
        task.wait(Config.Settings.PlantDelay)
    end
end

-- SHOVEL LOGIC
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
    local matchName = false
    local matchRarity = false

    if Config.Destroy.ByName then
        for _, n in pairs(Config.Destroy.Names) do
            if n == seedName then matchName = true break end
        end
    end

    if Config.Destroy.ByRarity then
        local plantRarity = rarityMap[seedName] or "Common"
        for _, r in pairs(Config.Destroy.Rarities) do
            if r == plantRarity then matchRarity = true break end
        end
    end

    return matchName or matchRarity
end

function Modules.autoShovelLoop()
    while true do
        if Config.Destroy.ByName or Config.Destroy.ByRarity then
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
                                    if not Config.Destroy.ByName and not Config.Destroy.ByRarity then break end
                                    if not plant or not plant.Parent then
                                        task.wait(Config.Settings.ShovelDelay)
                                        continue
                                    end
                                    local plantId = plant:GetAttribute("PlantId")
                                    if plantId and shovelType then
                                        pcall(function() Networking.Shovel.UseShovel:Fire(plantId, "", shovelType, shovelTool) end)
                                    end
                                    task.wait(Config.Settings.ShovelDelay)
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

-- SEED PACK LOGIC
function Modules.autoCollectSeedPacksLoop()
    while true do
        if Config.Misc.SeedPack then
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
            if #seeds > 0 then
                for _, seed in ipairs(seeds) do
                    if not Config.Misc.SeedPack then break end
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(seed.pos) end
                    task.wait(0.15)
                    local prompt = seed.model:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        local old = prompt.MaxActivationDistance
                        prompt.MaxActivationDistance = 100
                        Modules.FirePrompt(prompt)
                        prompt.MaxActivationDistance = old
                    end
                    task.wait(0.3)
                end
                Modules.returnToHomePlot()
            end
        end
        task.wait(1)
    end
end

-- PET SPAWN LOGIC
function Modules.autoBuyPetSpawnLoop()
    while true do
        if Config.Pets.Spawn then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local wildPetSpawns = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetSpawns")
                if wildPetSpawns then
                    for _, spawnObj in ipairs(wildPetSpawns:GetChildren()) do
                        if not Config.Pets.Spawn then break end
                        local spawnPos
                        if spawnObj:IsA("BasePart") then spawnPos = spawnObj.Position + Vector3.new(0,3,0)
                        elseif spawnObj:IsA("Model") then spawnPos = spawnObj:GetPivot().Position + Vector3.new(0,3,0) end
                        
                        if spawnPos then
                            hrp.CFrame = CFrame.new(spawnPos)
                            task.wait(0.15)
                            for _, desc in ipairs(spawnObj:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") and desc.Enabled then
                                    local old = desc.MaxActivationDistance
                                    desc.MaxActivationDistance = 100
                                    Modules.FirePrompt(desc)
                                    desc.MaxActivationDistance = old
                                    task.wait(0.3)
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

-- ANTI AFK & ANTI STEAL
function Modules.antiAfkLoop()
    while true do
        if Config.Settings.AntiAFK then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end
        task.wait(300)
    end
end

function Modules.antiStealLoop()
    while true do
        if Config.Misc.AntiSteal then
            local plotId = LP:GetAttribute("PlotId")
            if plotId then
                local plot = workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
                if plot then
                    local ref = plot:FindFirstChild("PlotSizeReference")
                    if ref and ref:IsA("BasePart") then
                        local center = ref.Position + Vector3.new(0, Config.Misc.AntiStealHeight, 0)
                        local char = LP.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - center).Magnitude > 2 then
                            hrp.CFrame = CFrame.new(center)
                        end
                    end
                end
            end
        end
        task.wait(Config.Misc.AntiStealInterval)
    end
end

-- ---------
-- UI CREATION
-- ---------

-- 1. FARMING TAB
local FarmTab = Window:CreateTab("Farming", true, "0")
FarmTab:CreatePageTitle("Auto Harvest")

FarmTab:CreateSwitch("Enable Auto Harvest", false, "Continuously harvest ready plants", function(state)
    Config.Harvest.Enable = state
end)

FarmTab:CreateSwitch("Harvest All Fruits", true, "Harvest everything regardless of type", function(state)
    Config.Harvest.All = state
end)

FarmTab:CreateMultiDropdown("Select Fruits to Harvest", {}, SEED_LIST, "Only works if Harvest All is OFF", function(selected)
    Config.Harvest.Fruit = selected
end)

FarmTab:CreatePageTitle("Auto Sell")
FarmTab:CreateSwitch("Auto Sell Continuous", false, "Continuously sell fruits", function(state)
    Config.Sell.Enable = state
end)

FarmTab:CreateSwitch("Sell When Full", false, "Only sell when backpack is maxed", function(state)
    Config.Sell.WhenFull = state
end)

-- 2. PLANTING TAB
local PlantTab = Window:CreateTab("Plant & Destroy", false, "0")
PlantTab:CreatePageTitle("Auto Planting")

PlantTab:CreateSwitch("Enable Auto Plant", false, "Automatically plant selected seeds", function(state)
    Config.Plant.Enable = state
end)

PlantTab:CreateDropdown("Planting Mode", "Random In Plot", {"Random In Plot", "Under Player"}, "Select where to plant", function(mode)
    Config.Plant.Mode = mode
end)

PlantTab:CreateMultiDropdown("Seeds to Plant", {}, SEED_LIST, "Select multiple seeds to plant", function(selected)
    Config.Plant.Seeds = selected
end)

PlantTab:CreatePageTitle("Auto Destroy (Shovel)")

PlantTab:CreateSwitch("Destroy By Name", false, "Destroy specific plants", function(state)
    Config.Destroy.ByName = state
end)

PlantTab:CreateMultiDropdown("Select Plant Names", {}, SEED_LIST, "Select plants to shovel", function(selected)
    Config.Destroy.Names = selected
end)

PlantTab:CreateSwitch("Destroy By Rarity", false, "Destroy plants based on rarity", function(state)
    Config.Destroy.ByRarity = state
end)

PlantTab:CreateMultiDropdown("Select Rarities", {}, RARITY_LIST, "Select rarity to shovel", function(selected)
    Config.Destroy.Rarities = selected
end)

-- 3. SHOP & PETS TAB
local ShopTab = Window:CreateTab("Shop & Pets", false, "0")
ShopTab:CreatePageTitle("Auto Buy Items")

ShopTab:CreateSwitch("Auto Buy Seeds", false, "Automatically purchase seeds", function(state)
    Config.Shop.EnableSeeds = state
end)

ShopTab:CreateMultiDropdown("Select Buy Seeds", {}, SEED_LIST, "Seeds to purchase", function(selected)
    Config.Shop.Seeds = selected
end)

ShopTab:CreateSwitch("Auto Buy Gears", false, "Automatically purchase gears", function(state)
    Config.Shop.EnableGears = state
end)

ShopTab:CreateMultiDropdown("Select Buy Gears", {}, GEAR_LIST, "Gears to purchase", function(selected)
    Config.Shop.Gears = selected
end)

ShopTab:CreateSwitch("Auto Buy Crates", false, "Automatically purchase crates", function(state)
    Config.Shop.EnableCrates = state
end)

ShopTab:CreateMultiDropdown("Select Buy Crates", {}, CRATE_LIST, "Crates to purchase", function(selected)
    Config.Shop.Crates = selected
end)

ShopTab:CreatePageTitle("Pet Automation")
ShopTab:CreateSwitch("Auto Catch Wild Pets", false, "TP and catch wild spawns", function(state)
    Config.Pets.Spawn = state
end)

-- 4. SETTINGS & MISC TAB
local SettingsTab = Window:CreateTab("Settings", false, "0")
SettingsTab:CreatePageTitle("Movement Configuration")

SettingsTab:CreateDropdown("Movement Mode", "TP", {"TP", "Tween"}, "Teleport or Tween smoothly", function(mode)
    Config.Settings.MoveMode = mode
end)

SettingsTab:CreateSlider("Tween Speed", 100, 1000, 350, "Speed for tween movement", function(val)
    Config.Settings.TweenSpeed = val
end)

SettingsTab:CreatePageTitle("Miscellaneous")

SettingsTab:CreateSwitch("Anti AFK", true, "Prevent Roblox disconnection", function(state)
    Config.Settings.AntiAFK = state
end)

SettingsTab:CreateSwitch("Auto Collect Seed Packs", false, "Collect random seed packs on map", function(state)
    Config.Misc.SeedPack = state
end)

SettingsTab:CreateSwitch("Anti Steal", false, "Protect your plot from others", function(state)
    Config.Misc.AntiSteal = state
end)

SettingsTab:CreateSlider("Anti Steal Height", 1, 10, 3, "Height offset for Anti Steal", function(val)
    Config.Misc.AntiStealHeight = val
end)

SettingsTab:CreatePageTitle("Delays (Seconds)")
SettingsTab:CreateSlider("Plant Delay", 0, 2, 0.2, "Delay between plants", function(val) Config.Settings.PlantDelay = val end)
SettingsTab:CreateSlider("Harvest Delay", 0, 2, 0.05, "Delay between harvests", function(val) Config.Settings.HarvestDelay = val end)
SettingsTab:CreateSlider("Sell Delay", 0, 2, 0.2, "Delay between sells", function(val) Config.Settings.SellDelay = val end)
SettingsTab:CreateSlider("Shovel Delay", 0, 2, 0.2, "Delay between destroys", function(val) Config.Settings.ShovelDelay = val end)

-- ---------
-- INITIALIZE LOOPS
-- ---------
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

Library:SendNotification("GaG2 Hub", "Loaded Successfully!")
