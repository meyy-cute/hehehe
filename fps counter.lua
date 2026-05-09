local CoreGui, Players, RunService, TweenService, LocalPlayer = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("Players").LocalPlayer

local fileName = "AnnTimeData_" .. LocalPlayer.UserId .. ".txt"
local function save_to_file(t)
    pcall(function()
        writefile(fileName, tostring(t))
    end)
end

local function read_from_file()
    local success, content = pcall(function() return readfile(fileName) end)
    return success and tonumber(content) or 0
end


local function set_fps(cap)
    local setter = setfpscap or set_fps_cap or setfps or (fluxus and fluxus.set_fps_cap)
    if setter then pcall(function() setter(cap) end) end
end

task.spawn(function()
    while task.wait(1) do
        local cfg = getgenv().Config
        if cfg and cfg.MaxFPS then set_fps(cfg.MaxFPS) end
    end
end)

if getgenv().kc then pcall(function() getgenv().kc:Destroy() end) end


local g = Instance.new("ScreenGui")
g.Name = "Naa_Script_UI_" .. math.random(100, 999)
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() g.Parent = CoreGui 
end)
if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
getgenv().kc = g

local m = Instance.new("Frame", g)
m.BackgroundColor3, m.Position, m.Size, m.AnchorPoint = Color3.new(1, 1, 1), UDim2.new(0.5, 0, 0, -100), UDim2.new(0, 270, 0, 32), Vector2.new(0.5, 0)
Instance.new("UICorner", m).CornerRadius = UDim.new(1, 0)

local function FH(h, def)
    if not h or h == "" then return def end
    h = h:gsub("#","")
  
    local success, res = pcall(function() return Color3.fromRGB(tonumber("0x"..h:sub(1,2)), tonumber("0x"..h:sub(3,4)), tonumber("0x"..h:sub(5,6))) end)
    return success and res or def
end


local bgGradient = Instance.new("UIGradient", m)
local cfg = getgenv().Config or {}
local bgc = cfg.BackgroundColors or {"#FFF0F5", "#FFFFFF"}
-- Áp dụng màu ngay lập tức để không bị trắng lúc mới hiện
local initC1 = FH(bgc[1], Color3.fromRGB(255, 240, 245))
local initC2 = FH(bgc[2], Color3.fromRGB(255, 255, 255))
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, initC1),
    ColorSequenceKeypoint.new(0.5, initC2),
    ColorSequenceKeypoint.new(1, initC1)
})

local u = Instance.new("UIStroke", m)
u.Thickness, u.Color = 2.5, Color3.new(1, 1, 1)

local i = Instance.new("TextLabel", m)
i.Size, i.BackgroundTransparency, i.Font, i.TextSize, i.TextColor3 = UDim2.new(1, 0, 1, 0), 1, Enum.Font.GothamBold, 14, Color3.new(1, 1, 1)
local t = Instance.new("UIStroke", i)
t.Thickness, t.Color = 0.5, Color3.fromRGB(120, 60, 80)

local d, e = Instance.new("UIGradient", i), Instance.new("UIGradient", u)

local function k(id, post, size, rot, anchor)
    local o = Instance.new("ImageLabel", m)
    o.BackgroundTransparency, o.Position, o.Size, o.Image, o.Rotation = 1, post, size, "rbxthumb://type=Asset&id="..id.."&w=420&h=420", rot or 0
    if anchor then o.AnchorPoint = anchor end
    return o
end

local x = k("110573798159093", UDim2.new(0, -5, 0.5, 0), UDim2.new(0, 35, 0, 35), 0, Vector2.new(1, 0.5))
local tai_trai = k("84295531111003", UDim2.new(0, 15, 0, -18), UDim2.new(0, 40, 0, 40), -10)
local tai_phai = k("117246725721218", UDim2.new(1, -55, 0, -18), UDim2.new(0, 40, 0, 40), 10)
local No = k("113168576617719", UDim2.new(1, -5, 1, 2), UDim2.new(0, 35, 0, 35), 15, Vector2.new(0.5, 0.5))

local ids = {"99621050786909","132594641536971","102946999622375","125751906521282"}
local ics = {}
for j, id in ipairs(ids) do 
    local o = k(id, UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 25, 0, 25), 0, Vector2.new(0.5, 0.5))
    o.ZIndex = 0
    table.insert(ics, {obj = o, off = (j/#ids)*(math.pi*2), g = (j%2==0) and 1 or -1, defaultId = id})
end


local totalSavedTime = read_from_file()
local startTime = tick()
local f, l, r = 0, tick(), 0


task.spawn(function()
    while task.wait(15) do
        save_to_file(totalSavedTime + math.floor(tick() - startTime))
    end
end)

RunService.RenderStepped:Connect(function()
    f = f + 1
    local cfg = getgenv().Config or {}
    
    r = (r + (cfg.RotationSpeed or 1.0)) % 360
    d.Rotation, e.Rotation = r, r
    
    bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
    
    local currentBgc = cfg.BackgroundColors or {"#FFF0F5", "#FFFFFF"}
    local cBg1 = FH(currentBgc[1], Color3.fromRGB(255, 240, 245))
    local cBg2 = FH(currentBgc[2], Color3.fromRGB(255, 255, 255))
    
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cBg1),
        ColorSequenceKeypoint.new(0.5, cBg2),
        ColorSequenceKeypoint.new(1, cBg1)
    })

    local bc = cfg.BorderColors or {"#FFB4D2", "#FFFFFF"}
    local c1, c2 = FH(bc[1], Color3.fromRGB(255, 180, 210)), FH(bc[2], Color3.new(1, 1, 1))
    local p = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c1)})
    d.Color, e.Color = p, p
    
    if tick() - l >= 1 then
        local v = totalSavedTime + math.floor(tick() - startTime)
        local H, M, S = math.floor(v/3600), math.floor(v/60)%60, v%60
        i.Text = string.format("FPS: %d | %s | %s", f, H>0 and string.format("%02d:%02d:%02d", H, M, S) or string.format("%02d:%02d", M, S), LocalPlayer.DisplayName)
        f, l = 0, tick()
    end
    
    x.Position = UDim2.new(0, -5, 0.5, math.sin(tick() * 2) * 2)
    No.Rotation = 15 + math.sin(tick() * 2) * 5
    tai_trai.Rotation = -10 + math.sin(tick() * 3) * 5
    tai_phai.Rotation = 10 - math.sin(tick() * 3) * 5
    
    for j, it in ipairs(ics) do
        local isVisible = (cfg.ShowDecals ~= false)
        it.obj.Visible = isVisible
        if isVisible then
            local sz = cfg.DecalSize or 25
            it.obj.Size = UDim2.new(0, sz, 0, sz)
            it.obj.Image = "rbxthumb://type=Asset&id="..(cfg.CustomIcons and cfg.CustomIcons[j] or it.defaultId).."&w=420&h=420"
            local oa, wa = (tick() * (cfg.AuraSpeed or 0.8)) + it.off, (tick() * (cfg.SpiralSpeed or 1.0))
            it.obj.Position = UDim2.new(0.5, math.cos(oa)*(cfg.Radius or 155), 0.5, (math.sin(oa)*30)+(math.sin(wa)*25*it.g))
        end
    end
end)

---------
local UIS = game:GetService("UserInputService")
local posFileName = "AnnUIPos_" .. LocalPlayer.UserId .. ".txt"

local function save_pos()
    pcall(function()
        local pos = m.Position
        local data = tostring(pos.X.Scale)..","..tostring(pos.X.Offset)..","..tostring(pos.Y.Scale)..","..tostring(pos.Y.Offset)
        writefile(posFileName, data)
    end)
end

local function load_pos()
    local success, content = pcall(function() return readfile(posFileName) end)
    if success and content then
        local p = string.split(content, ",")
        if #p == 4 then
            return UDim2.new(tonumber(p[1]), tonumber(p[2]), tonumber(p[3]), tonumber(p[4]))
        end
    end
    return UDim2.new(0.5, 0, 0, -25)
end

local targetPos = load_pos()

local dragToggle = nil
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local Delta = input.Position - dragStart
    local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
    TweenService:Create(m, TweenInfo.new(0.1), {Position = Position}):Play()
end

m.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = m.Position
        input.Changed:Connect(function()
            if (input.UserInputState == Enum.UserInputState.End) then
                dragToggle = false
                save_pos()
            end
        end)
    end
end)

m.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if (input == dragInput and dragToggle) then
        updateInput(input)
    end
end)

TweenService:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
---------

---------------------------------------------------------

local cfg = getgenv().Config or {}

if cfg.DeleteMap == true then
    for i,v in next, workspace:GetDescendants() do
        pcall(function()
            v.Transparency = 1
        end)
    end
    for i,v in next, getnilinstances() do
        pcall(function()
            v.Transparency = 1
            for i1,v1 in next, v:GetDescendants() do
                v1.Transparency = 1
            end
        end)
    end
    a = workspace
    a.DescendantAdded:Connect(function(v)
        pcall(function()
            v.Transparency = 1
        end)
    end)
end
