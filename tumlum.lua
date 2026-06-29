getgenv().Config = {
    ["Max Plant Fruit"] = 200,
    ["Buy Expand Plot"] = true,
    ["Buy Slot Pet"] = true,
    ["Pet"] = {
        ["Auto Buy"] = {
            ["Enable"] = true,
            ["Pet"] = {
                ["IceSerpent"]      = true,
                ["Raccoon"]         = true,
                ["Unicorn"]         = true,
                ["GoldenDragonfly"] = true,
                ["BlackDragon"]     = true,
                ["Monkey"]          = true,
                ["Bee"]             = true,
                ["Robin"]           = true,
                ["Deer"]            = false,
                ["Owl"]             = false,
                ["Bunny"]           = false,
                ["Frog"]            = false,
            },
        },
    },
    ["Mail"] = {
        ["Enable"]      = false,
        ["Username"]    = "",
        ["Note"]        = "auto-shipped from main",
        ["IntervalSec"] = 30,
        ["Pet"] = {
            ["IceSerpent"]      = false,
            ["Raccoon"]         = false,
            ["Unicorn"]         = false,
            ["GoldenDragonfly"] = false,
            ["BlackDragon"]     = false,
            ["Monkey"]          = false,
            ["Bee"]             = false,
            ["Robin"]           = false,
            ["Deer"]            = false,
            ["Owl"]             = false,
            ["Bunny"]           = false,
            ["Frog"]            = false,
        },
        ["Seed"] = {
            ["Rainbow"] = false,
            ["Gold"]    = false,
        },
    },
    ["Plant Seed"] = {
        ["Enable"] = true,
        ["Mode"]   = "Random In Plot", -- "Random In Plot" hoặc "Under Player"
        ["Seed"] = {
            ["Carrot"]          = true,
            ["Strawberry"]      = true,
            ["Bamboo"]          = true,
            ["Blueberry"]       = true,
            ["Tulip"]           = true,
            ["Apple"]           = true,
            ["Tomato"]          = true,
            ["Banana"]          = true,
            ["Sunflower"]       = true,
            ["Corn"]            = true,
            ["Mushroom"]        = true,
            ["Cherry"]          = true,
            ["Mango"]           = true,
            ["Grape"]           = true,
            ["Coconut"]         = true,
            ["Cactus"]          = true,
            ["Baby Cactus"]     = true,
            ["Pomegranate"]     = true,
            ["Pineapple"]       = true,
            ["Dragon Fruit"]    = true,
            ["Poison Apple"]    = true,
            ["Moon Bloom"]      = true,
            ["Poison Ivy"]      = true,
            ["Ghost Pepper"]    = true,
            ["Venus Fly Trap"]  = true,
            ["Dragon's Breath"] = true,
        },
    },
    ["Harvest"] = {
        ["Enable"] = true,
        ["All"]    = true,  -- true = thu hoạch tất cả, false = chỉ thu theo danh sách Fruit
        ["Fruit"]  = {},    -- ví dụ: {["Apple"] = true, ["Grape"] = true}
        ["Only Mutation"]   = false,
        ["Ignore Mutation"] = false,
        ["Select Mutation Harvest"] = {},  -- ví dụ: {["Gold"] = true}
        ["Select Mutation Ignore"]  = {},
        ["Weather Filter"]         = false,
        ["Only During Weather"]    = false,
        ["Select Weather"]         = {},   -- ví dụ: {["Night"] = true}
    },
    ["Sell"] = {
        ["Enable"]    = false,
        ["When Full"] = true,
    },
    ["Buy Seed"] = {
        ["Enable"] = true,
        ["Seed"] = {
            ["Carrot"]          = true,
            ["Strawberry"]      = true,
            ["Bamboo"]          = true,
            ["Blueberry"]       = true,
            ["Tulip"]           = true,
            ["Apple"]           = true,
            ["Tomato"]          = true,
            ["Banana"]          = true,
            ["Sunflower"]       = true,
            ["Corn"]            = true,
            ["Mushroom"]        = true,
            ["Cherry"]          = true,
            ["Mango"]           = true,
            ["Grape"]           = true,
            ["Coconut"]         = true,
            ["Cactus"]          = true,
            ["Baby Cactus"]     = true,
            ["Pomegranate"]     = true,
            ["Pineapple"]       = true,
            ["Dragon Fruit"]    = true,
            ["Poison Apple"]    = true,
            ["Moon Bloom"]      = true,
            ["Poison Ivy"]      = true,
            ["Ghost Pepper"]    = true,
            ["Venus Fly Trap"]  = true,
            ["Dragon's Breath"] = true,
        },
    },
    ["Buy Gear"] = {
        ["Enable"] = false,
        ["Gear"] = {
            ["Common Watering Can"]  = true,
            ["Super Watering Can"]   = true,
            ["Common Sprinkler"]     = true,
            ["Uncommon Sprinkler"]   = true,
            ["Rare Sprinkler"]       = true,
            ["Legendary Sprinkler"]  = true,
            ["Super Sprinkler"]      = true,
        },
    },
    ["Buy Crate"] = {
        ["Enable"] = false,
        ["Crate"] = {
            ["Ladder Crate"] = false,
            ["Bench Crate"]  = false,
        },
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
    ["Webhook"] = {
        ["Enable"]   = false,
        ["URL"]      = "",
        ["Username"] = "Test kaitun",
        ["OnRarePet"]  = true,
        ["OnRareSeed"] = true,
        ["PetMinPrice"] = 0,
        ["PetRarity"] = {
            ["Common"]    = false,
            ["Uncommon"]  = false,
            ["Rare"]      = false,
            ["Legendary"] = true,
            ["Mythic"]    = true,
            ["Super"]     = true,
            ["Divine"]    = true,
            ["Prismatic"] = true,
        },
    },
    ["Anti Steal"] = {
        ["Enable"] = true,
        ["Height"] = 3,
        ["Interval"] = 2,
    },
    ["Settings"] = {
        ["Move Mode"]    = "TP",      -- "TP" hoặc "Tween"
        ["Tween Speed"]  = 350,
        ["Anti AFK"]     = true,
        ["Plant Delay"]  = 0.2,
        ["Harvest Delay"]= 0.05,
        ["Sell Delay"]   = 0.2,
        ["Shovel Delay"] = 0.2,
    },
}
local Config = getgenv().Config
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
getgenv().EnableLog = true
local _logNotifCooldown = {}
function logAction(mainAction, subAction)
    local msg = subAction and ("[Log] " .. mainAction .. " | " .. subAction) or ("[Log] " .. mainAction)
    print(msg)
end
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

    -- Lọc mutation chỉ thu hoạch
    if cfg["Only Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Harvest"]) do if v then anySelected = true break end end
        if not anySelected then return false end
        if not Modules.modelHasMutation(model, cfg["Select Mutation Harvest"]) then return false end
    end

    -- Lọc mutation bỏ qua
    if cfg["Ignore Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Ignore"]) do if v then anySelected = true break end end
        if anySelected then
            if Modules.modelHasMutation(model, cfg["Select Mutation Ignore"]) then return false end
        end
    end

    -- Lọc không thu hoạch khi thời tiết
    if cfg["Weather Filter"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Weather"]) do if v then anySelected = true break end end
        if anySelected then
            for name, selected in pairs(cfg["Select Weather"]) do
                if selected and Modules.isWeatherActive(name) then return false end
            end
        end
    end

    -- Lọc chỉ thu hoạch khi thời tiết
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
            -- Remote đúng từ GaG2
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
        -- Mua Seed: Packet 103
        if Config["Buy Seed"].Enable then
            for name, enabled in pairs(Config["Buy Seed"].Seed) do
                if enabled then
                    logAction("Buy Seed", name)
                    Packet:FireServer(103, name)
                    task.wait(0.2)
                end
            end
        end
        -- Mua Gear: Packet 107
        if Config["Buy Gear"].Enable then
            for name, enabled in pairs(Config["Buy Gear"].Gear) do
                if enabled then
                    logAction("Buy Gear", name)
                    Packet:FireServer(107, name)
                    task.wait(0.2)
                end
            end
        end
        -- Mua Crate: Packet 103
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

    -- Lấy danh sách seed đã bật trong Config
    local selectedSeeds = {}
    for name, enabled in pairs(Config["Plant Seed"].Seed) do
        if enabled then table.insert(selectedSeeds, name) end
    end
    if #selectedSeeds == 0 then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return false end

    -- Tìm tool trong backpack khớp với seed đã chọn (từ GaG2)
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
    -- Remote đúng từ GaG2
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
                    -- Random In Plot (từ GaG2)
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
                                        -- Remote đúng từ GaG2
                                        pcall(function() Networking.Shovel.UseShovel:Fire(plantId, "", shovelType, shovelTool) end)
                                        logAction("Auto Destroy", seedName)
                                    end
                                    task.wait(Config.Settings["Shovel Delay"] or 0.2)
                                end
                            else
                                print("Shovel not found in backpack!")
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
local function sendWebhook(content)
    if not Config.Webhook.Enable or Config.Webhook.URL == "" then return end
    local httpFn = syn and syn.request or http_request or request
    pcall(function()
        httpFn({
            Url = Config.Webhook.URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = content,
                username = Config.Webhook.Username or "Meyy Hub",
            })
        })
    end)
end
function Modules.antiAfkLoop()
    while true do
        if Config.Settings["Anti AFK"] then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
            logAction("Anti AFK", "OK")
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

    -- Ưu tiên 3: dùng pivot của plot
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
                -- Chỉ teleport nếu đã lệch khỏi trung tâm quá 2 studs
                if hrp and (hrp.Position - center).Magnitude > 2 then
                    hrp.CFrame = CFrame.new(center)
                    logAction("Anti Steal", "Moved to plot center")
                end
            end
        end
        task.wait(Config["Anti Steal"].Interval or 2)
    end
end

-- ============================================================
-- UI - SIGMA HUB PANEL
-- ============================================================
local TweenService2 = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "MeyyHubUI"
ScreenGui.Parent         = game:GetService("CoreGui")
ScreenGui.Enabled        = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Nút toggle
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Name                   = "ToggleContainer"
ToggleFrame.Parent                 = ScreenGui
ToggleFrame.AnchorPoint            = Vector2.new(1, 0)
ToggleFrame.Position               = UDim2.new(1, -10, 0, 10)
ToggleFrame.Size                   = UDim2.new(0, 44, 0, 44)
ToggleFrame.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
ToggleFrame.BackgroundTransparency = 0.1
ToggleFrame.BorderSizePixel        = 0
ToggleFrame.ClipsDescendants       = true
ToggleFrame.ZIndex                 = 10
local _tc = Instance.new("UICorner")
_tc.CornerRadius = UDim.new(1, 0)
_tc.Parent = ToggleFrame
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent    = ToggleFrame
ToggleStroke.Color     = Color3.fromRGB(9, 255, 248)
ToggleStroke.Thickness = 2

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent               = ToggleFrame
ToggleButton.AnchorPoint          = Vector2.new(0.5, 0.5)
ToggleButton.Position             = UDim2.new(0.5, 0, 0.5, 0)
ToggleButton.Size                 = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.ZIndex               = 11

local ToggleIcon = Instance.new("TextLabel")
ToggleIcon.Parent               = ToggleFrame
ToggleIcon.AnchorPoint          = Vector2.new(0.5, 0.5)
ToggleIcon.Position             = UDim2.new(0.5, 0, 0.5, 0)
ToggleIcon.Size                 = UDim2.new(0.8, 0, 0.8, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Font                 = Enum.Font.GothamBold
ToggleIcon.Text                 = "☰"
ToggleIcon.TextColor3           = Color3.fromRGB(9, 255, 248)
ToggleIcon.TextScaled           = true
ToggleIcon.ZIndex               = 12

-- Main panel
local Panel = Instance.new("Frame")
Panel.Name                   = "MainPanel"
Panel.Parent                 = ScreenGui
Panel.AnchorPoint            = Vector2.new(0, 0)
Panel.Position               = UDim2.new(0, -200, 0, 0)
Panel.Size                   = UDim2.new(0, 200, 1, 0)
Panel.BackgroundColor3       = Color3.fromRGB(10, 10, 10)
Panel.BackgroundTransparency = 0.05
Panel.BorderSizePixel        = 0
Panel.ClipsDescendants       = true
Panel.ZIndex                 = 5

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Parent    = Panel
PanelStroke.Color     = Color3.fromRGB(9, 255, 248)
PanelStroke.Thickness = 1

local PanelHeader = Instance.new("Frame")
PanelHeader.Parent           = Panel
PanelHeader.Size             = UDim2.new(1, 0, 0, 44)
PanelHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PanelHeader.BorderSizePixel  = 0
PanelHeader.ZIndex           = 6

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent               = PanelHeader
TitleLabel.AnchorPoint          = Vector2.new(0.5, 0.5)
TitleLabel.Position             = UDim2.new(0.5, 0, 0.5, 0)
TitleLabel.Size                 = UDim2.new(1, -10, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font                 = Enum.Font.FredokaOne
TitleLabel.Text                 = "Meyy Hub"
TitleLabel.TextColor3           = Color3.fromRGB(170, 85, 255)
TitleLabel.TextSize             = 20
TitleLabel.ZIndex               = 7
local _ts = Instance.new("UIStroke")
_ts.Parent    = TitleLabel
_ts.Color     = Color3.fromRGB(0, 0, 0)
_ts.Thickness = 0.8

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent                 = Panel
Scroll.Position               = UDim2.new(0, 0, 0, 44)
Scroll.Size                   = UDim2.new(1, 0, 1, -44)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel        = 0
Scroll.ScrollBarThickness     = 2
Scroll.ScrollBarImageColor3   = Color3.fromRGB(9, 255, 248)
Scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
Scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
Scroll.ZIndex                 = 6

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent    = Scroll
ListLayout.Padding   = UDim.new(0, 1)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Pad = Instance.new("UIPadding")
Pad.Parent        = Scroll
Pad.PaddingLeft   = UDim.new(0, 6)
Pad.PaddingRight  = UDim.new(0, 4)
Pad.PaddingTop    = UDim.new(0, 4)
Pad.PaddingBottom = UDim.new(0, 6)

-- ========== UI HELPERS ==========
local LabelMap = {}

local function MakeHeader(text, order)
    local f = Instance.new("Frame")
    f.Parent               = Scroll
    f.Size                 = UDim2.new(1, 0, 0, 20)
    f.BackgroundTransparency = 1
    f.LayoutOrder          = order
    f.ZIndex               = 6
    local lbl = Instance.new("TextLabel")
    lbl.Parent               = f
    lbl.Size                 = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font                 = Enum.Font.GothamBold
    lbl.Text                 = "— " .. text .. " —"
    lbl.TextColor3           = Color3.fromRGB(0, 220, 130)
    lbl.TextSize             = 11
    lbl.TextXAlignment       = Enum.TextXAlignment.Center
    lbl.ZIndex               = 7
end

local function MakeRow(key, default, order, isSub)
    local f = Instance.new("Frame")
    f.Parent               = Scroll
    f.Size                 = UDim2.new(1, 0, 0, 18)
    f.BackgroundTransparency = 1
    f.LayoutOrder          = order
    f.ZIndex               = 6
    local lbl = Instance.new("TextLabel")
    lbl.Parent               = f
    lbl.Size                 = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font                 = Enum.Font.Gotham
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.TextSize             = 11
    lbl.RichText             = true
    lbl.ZIndex               = 7
    local prefix = isSub
        and "  <font color='#80ffb0'>· " .. key .. ":</font> "
        or  "<font color='#aaaaaa'>" .. key .. ":</font> "
    lbl.Text = prefix .. "<font color='#ffffff'>" .. tostring(default) .. "</font>"
    LabelMap[key] = { lbl = lbl, prefix = prefix }
end

local function SetValue(key, value)
    local entry = LabelMap[key]
    if not entry then return end
    local lbl     = entry.lbl
    local newText = entry.prefix .. "<font color='#ffffff'>" .. tostring(value) .. "</font>"
    if lbl.Text == newText then return end
    local t1 = TweenService2:Create(lbl, TweenInfo.new(0.1), {TextTransparency = 1})
    t1:Play(); t1.Completed:Wait()
    lbl.Text = newText
    TweenService2:Create(lbl, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
end

-- ========== LAYOUT ==========
MakeHeader("PLAYER",         1)
MakeRow("Sheckles",  "$0",   2)
MakeRow("Fruit",  "0/100",   3)
MakeRow("Pets",   "0/0",     4)
MakeRow("Seeds",  "0 total", 5)

-- Seeds per loại
local SEED_NAMES = {
    "Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple",
    "Bamboo","Corn","Cactus","Pineapple","Mushroom","Green Bean",
    "Banana","Grape","Coconut","Mango","Dragon Fruit","Acorn",
    "Cherry","Sunflower","Venus Fly Trap","Pomegranate","Poison Apple",
    "Moon Bloom","Dragon's Breath","Ghost Pepper","Poison Ivy",
    "Baby Cactus","Glow Mushroom","Romanesco","Horned Melon",
}
-- map tên tool seed → tên hiển thị
local SEED_TOOL_MAP = {}
for _, name in ipairs(SEED_NAMES) do
    SEED_TOOL_MAP[name .. " Seed"] = name
    SEED_TOOL_MAP[name]            = name  -- phòng trường hợp tool không có hậu tố
end

for i, name in ipairs(SEED_NAMES) do
    MakeRow(name, "0", 5 + i, true)
end

MakeRow("Plot",     "N/A",    37)

MakeHeader("GARDEN",          38)
MakeRow("Plants",  "0/200",   39)
MakeRow("Sprinklers", "0",    40)
MakeRow("Decaying",   "0",    41)

MakeHeader("SESSION",         42)
MakeRow("Uptime",  "00:00:00",43)
MakeRow("Earned",     "$0",   44)
MakeRow("Rate",      "$0/s",  45)
MakeRow("Harvested",   "0",   46)
MakeRow("Planted",     "0",   47)
MakeRow("Sold",   "0 times",  48)
MakeRow("Shovels",     "0",   49)
MakeRow("Seed Packs",  "0",   50)

MakeHeader("STATUS",          51)
MakeRow("Anti Steal", "OFF",52)
MakeRow("Last",       "N/A",  53)

-- ========== TOGGLE PANEL ==========
local PanelOpen = false
local function TogglePanel()
    PanelOpen = not PanelOpen
    local targetX     = PanelOpen and 0 or -200
    local targetIcon  = PanelOpen and "✕" or "☰"
    local targetColor = PanelOpen and Color3.fromRGB(255,80,80) or Color3.fromRGB(9,255,248)
    TweenService2:Create(Panel,
        TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, targetX, 0, 0)}):Play()
    ToggleIcon.Text       = targetIcon
    ToggleIcon.TextColor3 = targetColor
    TweenService2:Create(ToggleStroke, TweenInfo.new(0.2), {Color = targetColor}):Play()
end

ToggleButton.MouseButton1Click:Connect(TogglePanel)
ToggleButton.MouseEnter:Connect(function()
    TweenService2:Create(ToggleFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,48,0,48)}):Play()
end)
ToggleButton.MouseLeave:Connect(function()
    TweenService2:Create(ToggleFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,44,0,44)}):Play()
end)

-- ============================================================
-- STATS UPDATE - KẾT NỐI UI VỚI DỮ LIỆU THỰC TỪ GAME
-- ============================================================

-- Bộ đếm session
local _sessionStart   = tick()
local _sessionEarned  = 0
local _sessionHarvest = 0
local _sessionPlant   = 0
local _sessionSell    = 0
local _sessionShovel  = 0
local _sessionSeeds   = 0

-- Hook các hàm để đếm session
local _origHarvestPrompt = Modules.harvestPrompt
function Modules.harvestPrompt(prompt)
    local before = _sessionHarvest
    _origHarvestPrompt(prompt)
    -- nếu không bị return sớm thì đã harvest
    _sessionHarvest = _sessionHarvest + 1
    SetValue("Harvested", tostring(_sessionHarvest))
    SetValue("Last", "Harvested")
end

local _origPlantSeed = Modules.plantSeedAtPosition
function Modules.plantSeedAtPosition(pos)
    local result = _origPlantSeed(pos)
    if result then
        _sessionPlant += 1
        SetValue("Planted", tostring(_sessionPlant))
        SetValue("Last", "Planted seed")
    end
    return result
end

local _origShovel = Modules.autoShovelLoop  -- đếm qua log sẽ không chính xác
-- Đếm shovel trực tiếp trong loop, ta patch Networking.Shovel.UseShovel
local _origUseShovel = Networking.Shovel.UseShovel.Fire
Networking.Shovel.UseShovel.Fire = function(self, ...)
    _sessionShovel += 1
    SetValue("Shovels", tostring(_sessionShovel))
    SetValue("Last", "Shoveled plant")
    return _origUseShovel(self, ...)
end

local _origSellAll = Networking.NPCS.SellAll.Fire
Networking.NPCS.SellAll.Fire = function(self, ...)
    _sessionSell += 1
    SetValue("Sold", _sessionSell .. " times")
    SetValue("Last", "Sold fruits")
    return _origSellAll(self, ...)
end

local _origSeedPack = Modules.autoCollectSeedPacksLoop  -- đếm qua biến riêng
local _sessionSeedPacks = 0

-- ========== HÀM ĐỌC DỮ LIỆU GAME ==========
local function fmtMoney(n)
    if n >= 1e9 then return ("$%.1fB"):format(n/1e9)
    elseif n >= 1e6 then return ("$%.1fM"):format(n/1e6)
    elseif n >= 1e3 then return ("$%.1fK"):format(n/1e3)
    else return "$" .. tostring(n) end
end

local function fmtTime(s)
    local h = math.floor(s/3600)
    local m = math.floor((s%3600)/60)
    local sec = math.floor(s%60)
    return ("%02d:%02d:%02d"):format(h, m, sec)
end

local function getPlayerData()
    -- Sheckles / tiền
    local money = 0
    pcall(function()
        money = LP.leaderstats.Sheckles.Value
    end)
    if money == 0 then pcall(function()
        money = LP:FindFirstChild("leaderstats"):FindFirstChild("Sheckles").Value
    end) end

    -- Fruit (backpack)
    local fruitCurrent, fruitMax = 0, 200
    pcall(function()
        local txt = LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
        local c, m = txt:match("(%d+)/(%d+)")
        if c then fruitCurrent = tonumber(c); fruitMax = tonumber(m) end
    end)

    -- Pets
    local petCurrent, petMax = 0, 0
    pcall(function()
        local petFolder = LP:FindFirstChild("Pets") or LP:FindFirstChild("OwnedPets")
        if petFolder then petCurrent = #petFolder:GetChildren() end
        petMax = LP:GetAttribute("MaxPets") or petMax
    end)

    return money, fruitCurrent, fruitMax, petCurrent, petMax
end

local function getSeedCounts()
    local backpack = LP:FindFirstChildOfClass("Backpack")
    local char     = LP.Character
    local counts   = {}
    local total    = 0
    for _, seedName in ipairs(SEED_NAMES) do counts[seedName] = 0 end
    local function scan(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            local display = SEED_TOOL_MAP[item.Name]
            if display and counts[display] ~= nil then
                counts[display] += 1
                total += 1
            end
        end
    end
    scan(backpack)
    scan(char)
    return counts, total
end

local function getGardenData()
    local plantCount, plantMax, sprinklerCount, decayCount = 0, Config["Max Plant Fruit"] or 200, 0, 0
    local plotId = LP:GetAttribute("PlotId")
    if plotId then
        local gardens = workspace:FindFirstChild("Gardens")
        local plot = gardens and gardens:FindFirstChild("Plot" .. tostring(plotId))
        if plot then
            local plantsFolder = plot:FindFirstChild("Plants")
            if plantsFolder then
                for _, plant in ipairs(plantsFolder:GetChildren()) do
                    if plant:IsA("Model") then
                        plantCount += 1
                        if plant:GetAttribute("Decaying") then decayCount += 1 end
                    end
                end
            end
            for _, obj in ipairs(plot:GetDescendants()) do
                if obj:IsA("Tool") and obj:GetAttribute("Sprinkler") then
                    sprinklerCount += 1
                end
            end
        end
    end
    return plantCount, plantMax, sprinklerCount, decayCount
end

-- ========== STATS LOOP ==========
task.spawn(function()
    local prevMoney = nil
    local earnRate  = 0
    local rateHistory = {}

    while true do
        task.wait(2)

        -- Player stats
        local money, fruitC, fruitM, petC, petM = getPlayerData()
        SetValue("Sheckles", fmtMoney(money))
        SetValue("Fruit",    fruitC .. "/" .. fruitM)
        SetValue("Pets",     petC .. "/" .. petM)
        SetValue("Plot",     tostring(LP:GetAttribute("PlotId") or "N/A"))

        -- Tính rate kiếm tiền
        if prevMoney then
            local diff = money - prevMoney
            if diff > 0 then
                table.insert(rateHistory, diff / 2)
                if #rateHistory > 5 then table.remove(rateHistory, 1) end
                local sum = 0
                for _, v in ipairs(rateHistory) do sum += v end
                earnRate = sum / #rateHistory
                _sessionEarned += diff
            end
        end
        prevMoney = money
        SetValue("Earned", fmtMoney(_sessionEarned))
        SetValue("Rate",   fmtMoney(math.floor(earnRate)) .. "/s")

        -- Seeds
        local counts, total = getSeedCounts()
        SetValue("Seeds", total .. " total")
        for seedName, n in pairs(counts) do
            SetValue(seedName, tostring(n))
        end

        -- Garden
        local pC, pM, sC, dC = getGardenData()
        SetValue("Plants",     pC .. "/" .. pM)
        SetValue("Sprinklers", tostring(sC))
        SetValue("Decaying",   tostring(dC))

        -- Session
        local elapsed = tick() - _sessionStart
        SetValue("Uptime", fmtTime(elapsed))

        SetValue("Anti Steal", Config["Anti Steal"].Enable and "ON" or "OFF")
    end
end)

-- Watch backpack changes → cập nhật seed ngay
local function watchContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(item)
        if SEED_TOOL_MAP[item.Name] then
            task.wait(0.05)
            local counts, total = getSeedCounts()
            SetValue("Seeds", total .. " total")
            for k, n in pairs(counts) do SetValue(k, tostring(n)) end
        end
    end)
    container.ChildRemoved:Connect(function(item)
        if SEED_TOOL_MAP[item.Name] then
            task.wait(0.05)
            local counts, total = getSeedCounts()
            SetValue("Seeds", total .. " total")
            for k, n in pairs(counts) do SetValue(k, tostring(n)) end
        end
    end)
end

watchContainer(LP:FindFirstChildOfClass("Backpack"))
LP.CharacterAdded:Connect(function(char)
    watchContainer(char)
    watchContainer(LP:FindFirstChildOfClass("Backpack"))
end)
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
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")
print("DITMEMAY")