
local Library = {}
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

---------
local HttpService = game:GetService("HttpService")

local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local writefile = writefile or function() end
local readfile = readfile or function() return "" end
local isfile = isfile or function() return false end

Library.ConfigFolder = "HubPremium_Configs"
Library.ConfigElements = {}



local saveTick = 0
function Library:AutoSave()
    if Library.IsLoading then return end
    saveTick = tick()
    task.delay(0.5, function()
        if tick() - saveTick >= 0.45 then
            Library:SaveConfig("AutoSave", true)
        end
    end)
end
---------

---------
local UI_Elements = {
    AnimatedGradients = {},
    AnimatedStrokes = {},
    RowStrokes = {},
    RowStrokeGradients = {},
    DivGradients = {},
    TabGradients = {},
    Switches = {},
    TextGradients = {},
    RotatingGradients = {},
    Containers = {},
    TabBackgrounds = {},
    PageElements = {},
    Descriptions = {}
}
---------


---------
local CurrentTheme = "Dream"
local Notifications = {}

local exactFruitSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("#B4DCFF")), 
    ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")), 
    ColorSequenceKeypoint.new(1, Color3.fromHex("#B4DCFF"))
})


---------
local Themes = {
    ["Ocean"] = {
        MainBg = Color3.fromHex("#D3D3D3"),
        MainBgTrans = 0.3,
        ContainerBg = Color3.fromHex("#FFFFFF"),
        ContainerTrans = 0.8,
        TextColor = Color3.fromHex("#FFFFFF"),
        DescTextColor = Color3.fromHex("#000000"),
        MainStroke = Color3.fromHex("#FFFFFF"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4DCFF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#B4DCFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
        }),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#E0F0FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#E0F0FF"))
        }),
        TitleStroke = Color3.fromHex("#ADD8E6"),
        TextGrad = exactFruitSeq,
        TabGrad = exactFruitSeq,
        DivGrad = exactFruitSeq,
        RowStroke = Color3.fromHex("#ADD8E6"),
        RowStrokeGrad = exactFruitSeq,
        ToggleActive = Color3.fromHex("#96C8DC"),
        LoopSeq = exactFruitSeq,
        SearchIconColor = Color3.fromHex("#333333")
    },
 
    ["Dream"] = {
        MainBg = Color3.fromHex("#0A1428"),
        MainBgTrans = 0.2,
        ContainerBg = Color3.fromHex("#151C3B"),
        ContainerTrans = 0.5,
        TextColor = Color3.fromHex("#E6FFFF"),
        DescTextColor = Color3.fromHex("#FFFFFF"),
        MainStroke = Color3.fromHex("#D3D3D3"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151C3B")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#151C3B"))
        }),
        TitleStroke = Color3.fromHex("#140A32"),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4FFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#A08CFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151C3B")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#151C3B"))
        }),
        RowStroke = Color3.fromHex("#808080"),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        ToggleActive = Color3.fromHex("#8C64FF"),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        }),
        SearchIconColor = Color3.fromHex("#8C64FF")
    },

    ["Dark"] = {
        MainBg = Color3.fromHex("#000000"),
        MainBgTrans = 0.3,
        ContainerBg = Color3.fromHex("#525252"), 
        ContainerTrans = 0.6,
        TextColor = Color3.fromHex("#FFFFFF"),
        DescTextColor = Color3.fromHex("#FFFFFF"),
        MainStroke = Color3.fromHex("#FFFFFF"), 
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#808080")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#D3D3D3")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
        }),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#0D0D0D")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#1A1A1A")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#0D0D0D"))
        }),
        TitleStroke = Color3.fromHex("#222222"),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8A8A8A")), 
            ColorSequenceKeypoint.new(1, Color3.fromHex("#1A1A1A")) 
        }),
        TabGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#777777")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
        }),
        DivGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#222222")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#888888")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#222222"))
        }),
        RowStroke = Color3.fromHex("#FFFFFF"), 
        RowStrokeGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#555555")), 
            ColorSequenceKeypoint.new(1, Color3.fromHex("#54626F")) 
        }),
        ToggleActive = Color3.fromHex("#888888"),
        LoopSeq = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#AAAAAA")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#222222")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
        }),
        SearchIconColor = Color3.fromHex("#FFFFFF")
    }
}
---------

local function ApplyTextGradient(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.TextColor3 = Themes[CurrentTheme].TextColor
        
        local grad = Instance.new("UIGradient", obj)
        grad.Rotation = 90
        grad.Color = Themes[CurrentTheme].TextContrast
        table.insert(UI_Elements.TextGradients, grad)
        
        local shadow = Instance.new("UIStroke")
        shadow.Color = Themes[CurrentTheme].ToggleActive
        shadow.Thickness = 0.2
        shadow.Transparency = 0
        shadow.Parent = obj
    end
end
---------

Library.IsLoading = false

function Library:SaveConfig(fileName, silent)
    if not isfolder(Library.ConfigFolder) then
        makefolder(Library.ConfigFolder)
    end
    local data = {}
    for flag, element in pairs(Library.ConfigElements) do
        data[flag] = element.Value
    end
    local json = HttpService:JSONEncode(data)
    writefile(Library.ConfigFolder .. "/" .. fileName .. ".json", json)
    if not silent then
        Library:SendNotification("Config System", "Saved " .. fileName)
    end
end

function Library:LoadConfig(fileName, silent)
    local path = Library.ConfigFolder .. "/" .. fileName .. ".json"
    if isfile(path) then
        local json = readfile(path)
        local success, data = pcall(function()
            return HttpService:JSONDecode(json)
        end)
        if success and type(data) == "table" then
            Library.IsLoading = true
            for flag, value in pairs(data) do
                if Library.ConfigElements[flag] then
                    Library.ConfigElements[flag].Set(value)
                end
            end
            Library.IsLoading = false
            if not silent then
                Library:SendNotification("Config System", "Loaded " .. fileName)
            end
        else
            if not silent then
                Library:SendNotification("Config Error", "Failed to parse JSON")
            end
        end
    else
        if not silent then
            Library:SendNotification("Config Error", "File not found")
        end
    end
end
---------

function Library:SendNotification(titleText, descText)
    local g2 = Instance.new("ScreenGui")
    g2.Name = "UI_Cloud_Notification_" .. math.random(100, 999)
    g2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function() g2.Parent = CoreGui end)
    if not g2.Parent then g2.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    local m2 = Instance.new("Frame", g2)
    m2.Name = "Main"
    m2.BackgroundColor3 = Themes[CurrentTheme].MainBg
    m2.BackgroundTransparency = 0.3
    m2.Size = UDim2.new(0, 260, 0, 80)
    m2.AnchorPoint = Vector2.new(1, 1)
    m2.Position = UDim2.new(1, 50, 1, -20)
    Instance.new("UICorner", m2).CornerRadius = UDim.new(0, 10)
    
    local u2 = Instance.new("UIStroke", m2)
    u2.Thickness = 2.5
    u2.Color = Themes[CurrentTheme].MainStroke
    
    local e2 = Instance.new("UIGradient", u2)
    e2.Color = Themes[CurrentTheme].LoopSeq
    table.insert(UI_Elements.RotatingGradients, e2)
    
    local bgGradient = Instance.new("UIGradient", m2)
    bgGradient.Color = Themes[CurrentTheme].Wave
    
    local function CreateStatusLabel(name, pos, text, size)
        local label = Instance.new("TextLabel", m2)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = size or 12
        -------------------------
        ApplyTextGradient(label)
        -------------------------
        return label
    end
    
    local titleLabel = CreateStatusLabel("Title", 12, titleText, 16)
    local subLabel = CreateStatusLabel("Subtitle", 40, descText, 12)
    
    local renderSteppedConn
    renderSteppedConn = RunService.RenderStepped:Connect(function()
        bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
    end)
    
    for i, notif in ipairs(Notifications) do
        if notif and notif.Parent then
            local newY = -20 - (i * 90)
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, newY)}):Play()
        end
    end
    
    table.insert(Notifications, 1, m2)
    if #Notifications > 5 then
        local oldNotif = table.remove(Notifications, 6)
        if oldNotif then
            TweenService:Create(oldNotif, TweenInfo.new(0.3), {Position = UDim2.new(1, 300, 1, oldNotif.Position.Y.Offset)}):Play()
            task.delay(0.3, function() oldNotif.Parent:Destroy() end)
        end
    end
    
    local showTween = TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -20)})
    showTween:Play()
    
    task.delay(3, function()
        for i, notif in ipairs(Notifications) do
            if notif == m2 then
                table.remove(Notifications, i)
                break
            end
        end
        local hideTween = TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, m2.Position.Y.Offset)})
        hideTween:Play()
        hideTween.Completed:Connect(function()
            if renderSteppedConn then renderSteppedConn:Disconnect() end
            g2:Destroy()
            for i, notif in ipairs(Notifications) do
                if notif and notif.Parent then
                    local newY = -20 - ((i - 1) * 90)
                    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, newY)}):Play()
                end
            end
        end)
    end)
end

function Library:CreateWindow(config)
    local Window = {}
    config = config or {}
    local windowTitle = config.Title or "Hub Premium"
    
    if getgenv().MainUI_Library then
        pcall(function() getgenv().MainUI_Library:Destroy() end)
        getgenv().MainUI_Library = nil
    end
    
    local g = Instance.new("ScreenGui")
    g.Name = "Hub_Premium_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.ResetOnSpawn = false
    
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    getgenv().MainUI_Library = g
    
    ---------
    local m = Instance.new("Frame", g)
    m.Name = "MainFrame"
    m.BackgroundColor3 = Themes[CurrentTheme].MainBg
    m.BackgroundTransparency = Themes[CurrentTheme].MainBgTrans
    m.Size = UDim2.new(0, 600, 0, 525) -- Updated Ratio 400:350
    m.Position = UDim2.new(0.5, 0, 0.5, 0)
    m.AnchorPoint = Vector2.new(0.5, 0.5)
    m.ClipsDescendants = true
    Instance.new("UICorner", m).CornerRadius = UDim.new(0, 15)
    ---------
    
    local isMini = false
    local isMax = false

    local EdgeBarHitbox = Instance.new("TextButton", g)
    EdgeBarHitbox.Name = "EdgeBarHitbox"
    EdgeBarHitbox.Size = UDim2.new(0, 30, 0, 140) 
    EdgeBarHitbox.Position = UDim2.new(1, 0, 0.5, 0)
    EdgeBarHitbox.AnchorPoint = Vector2.new(1, 0.5)
    EdgeBarHitbox.BackgroundTransparency = 1 
    EdgeBarHitbox.Visible = false
    EdgeBarHitbox.Text = ""

    local EdgeBarVisual = Instance.new("Frame", EdgeBarHitbox)
    EdgeBarVisual.Size = UDim2.new(0, 4, 0, 120) 
    EdgeBarVisual.Position = UDim2.new(1, -2, 0.5, 0)
    EdgeBarVisual.AnchorPoint = Vector2.new(1, 0.5)
    EdgeBarVisual.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    EdgeBarVisual.BackgroundTransparency = 0.8
    Instance.new("UICorner", EdgeBarVisual).CornerRadius = UDim.new(1, 0)

    local Mini3DIcon = Instance.new("Frame", g)
    Mini3DIcon.Name = "Mini3DIcon"
    Mini3DIcon.Size = UDim2.new(0, 140, 0, 140)
    Mini3DIcon.Position = UDim2.new(1, 150, 0.5, 0)
    Mini3DIcon.AnchorPoint = Vector2.new(1, 0.5)
    Mini3DIcon.BackgroundTransparency = 1
    Mini3DIcon.Visible = false

    local coreLayers = {}
    local baseSizes = {30, 45, 62, 78, 95, 112}    
    local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
    for i = 1, #baseSizes do
        local layer = Instance.new("Frame")
        layer.AnchorPoint = Vector2.new(0.5, 0.5)
        layer.Position = UDim2.new(0.5, 0, 0.5, 0)
        layer.BorderSizePixel = 0
        layer.ZIndex = 3
        Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
        layer.Parent = Mini3DIcon
        table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
    end
    
    local phi = (1 + math.sqrt(5)) / 2
    local vertices = {
        Vector3.new(0, 1, phi), Vector3.new(0, -1, phi),
        Vector3.new(0, 1, -phi), Vector3.new(0, -1, -phi),
        Vector3.new(1, phi, 0), Vector3.new(-1, phi, 0),
        Vector3.new(1, -phi, 0), Vector3.new(-1, -phi, 0),
        Vector3.new(phi, 0, 1), Vector3.new(-phi, 0, 1),
        Vector3.new(phi, 0, -1), Vector3.new(-phi, 0, -1)
    }
    local edges = {}
    for i = 1, #vertices - 1 do
        for j = i + 1, #vertices do
            if math.abs((vertices[i] - vertices[j]).Magnitude - 2) < 0.1 then
                table.insert(edges, {i, j})
            end
        end
    end
    
    local lines, lineGradients = {}, {}
    for i = 1, #edges do
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        line.BorderSizePixel = 0
        line.ZIndex = 3
        local lineGrad = Instance.new("UIGradient", line)
        table.insert(lineGradients, lineGrad)
        local glow = Instance.new("UIStroke", line)
        glow.Thickness = 2
        glow.Transparency = 0.4
        glow.Color = Color3.fromHex("#FFFFFF")
        local glowGrad = Instance.new("UIGradient", glow)
        table.insert(lineGradients, glowGrad)
        line.Parent = Mini3DIcon
        lines[i] = line
    end

    local MiniClickBtn = Instance.new("TextButton", Mini3DIcon)
    MiniClickBtn.Size = UDim2.new(1, 0, 1, 0)
    MiniClickBtn.BackgroundTransparency = 1
    MiniClickBtn.Text = ""
    MiniClickBtn.ZIndex = 10

    local angleX, angleY, r3D = 0, 0, 0
    local scale3D, perspective3D = 45, 150
    local function project3D(v3)
        local x, y, z = v3.X, v3.Y, v3.Z
        local cosY, sinY = math.cos(angleY), math.sin(angleY)
        x, z = x * cosY - z * sinY, x * sinY + z * cosY
        local cosX, sinX = math.cos(angleX), math.sin(angleX)
        y, z = y * cosX - z * sinX, y * sinX + z * cosX
        local factor = perspective3D / (perspective3D + z)
        return Vector2.new(x * factor * scale3D + 70, -y * factor * scale3D + 70), z
    end

    local clickCount = 0
    EdgeBarHitbox.MouseButton1Click:Connect(function()
        clickCount = clickCount + 1
        if clickCount == 1 then
            TweenService:Create(EdgeBarVisual, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, Size = UDim2.new(0, 6, 0, 140)}):Play()
            task.delay(0.6, function() 
                if clickCount == 1 then
                    clickCount = 0 
                    TweenService:Create(EdgeBarVisual, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, Size = UDim2.new(0, 4, 0, 120)}):Play()
                end
            end)
        elseif clickCount == 2 then
            clickCount = 0
            EdgeBarHitbox.Visible = false
            Mini3DIcon.Visible = true
            TweenService:Create(Mini3DIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)}):Play()
        end
    end)

    ---------
    MiniClickBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(Mini3DIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 150, 0.5, 0)})
        tw:Play()
        tw.Completed:Wait()
        Mini3DIcon.Visible = false
        
        m.Visible = true
        m.Size = UDim2.new(0, 0, 0, 0)
        m.Position = UDim2.new(1, 0, 0.5, 0)
        TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 525), -- Updated
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        isMini = false
    end)
    ---------
    
    local SnowContainer = Instance.new("Frame", m)
    SnowContainer.Name = "SnowContainer"
    SnowContainer.Size = UDim2.new(1, -40, 1, -40)
    SnowContainer.Position = UDim2.new(0, 20, 0, 20)
    SnowContainer.BackgroundTransparency = 1
    SnowContainer.ZIndex = 0
    SnowContainer.ClipsDescendants = true
    Instance.new("UICorner", SnowContainer).CornerRadius = UDim.new(0, 15)
    
    task.spawn(function()
        while task.wait(0.15) do
            if not m.Visible or isMini then continue end
            local flake = Instance.new("ImageLabel", SnowContainer)
            flake.BackgroundTransparency = 1
            local iconId = "137906289429512"
            if CurrentTheme == "Dream" then iconId = "88081350809596"
            elseif CurrentTheme == "Dark" then iconId = "97956199432234" end
            
            flake.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
            local randomSize = math.random(13, 20)
            flake.Size = UDim2.new(0, randomSize, 0, randomSize)
            flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
            flake.ImageTransparency = math.random(2, 6) / 10
            
            local fallSpeed = math.random(40, 70) / 10
            local tween = TweenService:Create(flake, TweenInfo.new(fallSpeed, Enum.EasingStyle.Linear), {
                Position = UDim2.new(flake.Position.X.Scale, 0, 1.1, 0),
                Rotation = math.random(-180, 180)
            })
            tween:Play()
            tween.Completed:Connect(function() flake:Destroy() end)
        end
    end)
    
    local ToggleIcon = Instance.new("ImageButton", g)
    ToggleIcon.Name = "ToggleIcon"
    ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
    ToggleIcon.Position = UDim2.new(0, 20, 1, -65)
    ToggleIcon.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    ToggleIcon.Image = "rbxassetid://6031090990"
    ToggleIcon.BackgroundTransparency = 0.5
    Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)
    
    ---------
    ToggleIcon.MouseButton1Click:Connect(function()
        if not m then return end
        if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
            TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            m.Visible = false
        else
            m.Visible = true
            local targetSize = isMini and UDim2.new(0, 600, 0, 525) or (isMax and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 600, 0, 525))
            local targetPos = isMini and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
        end
    end)
    ---------
    
    local u = Instance.new("UIStroke", m)
    u.Thickness = 4.5
    u.Color = Themes[CurrentTheme].MainStroke
    table.insert(UI_Elements.AnimatedStrokes, {Obj = u, Type = "MainStroke"})
    
    local e = Instance.new("UIGradient", u)
    table.insert(UI_Elements.RotatingGradients, e)
    
    local titleBar = Instance.new("Frame", m)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 2
    
    local hubTitle = Instance.new("TextLabel", titleBar)
    hubTitle.Size = UDim2.new(0, 300, 1, 0)
    hubTitle.Position = UDim2.new(0, 20, 0, 0)
    hubTitle.BackgroundTransparency = 1
    hubTitle.Font = Enum.Font.GothamBold
    hubTitle.Text = windowTitle
    -------------------------
    ApplyTextGradient(hubTitle)
    -------------------------
    hubTitle.TextSize = 15
    hubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local function CreateWinBtn(text, pos)
        local btn = Instance.new("TextButton", titleBar)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(1, pos, 0.5, 0)
        btn.AnchorPoint = Vector2.new(0, 0.5)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        -------------------------
        ApplyTextGradient(btn)
        -------------------------
        btn.TextSize = 16
        return btn
    end
    
    local minBtn = CreateWinBtn("~", -105)
    local maxBtn = CreateWinBtn("⬚", -70)
    local closeBtn = CreateWinBtn("x", -35)

    ---------
    minBtn.MouseButton1Click:Connect(function()
        if not isMini then
            isMini = true; isMax = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.wait(0.5)
            m.Visible = false
            EdgeBarHitbox.Visible = true
            EdgeBarVisual.BackgroundTransparency = 0.8
            EdgeBarVisual.Size = UDim2.new(0, 4, 0, 120)
        end
    end)
    
    maxBtn.MouseButton1Click:Connect(function()
        if not isMax then
            isMax = true; isMini = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            if m:FindFirstChild("Sidebar") then m.Sidebar.Visible = true end
            if m:FindFirstChild("LeftDivider") then m.LeftDivider.Visible = true end
            if m:FindFirstChild("TopDivider") then m.TopDivider.Visible = true end
            if m:FindFirstChild("Sidebar") then
                for _, btn in pairs(m.Sidebar:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("ActiveBg") and btn.ActiveBg.BackgroundTransparency < 1 then
                        local pageName = btn.Text:gsub("%s+", "") .. "Page"
                        if m:FindFirstChild(pageName) then m[pageName].Visible = true end
                    end
                end
            end
        else
            isMax = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 525), -- Updated
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end
    end)
    ---------
    
    closeBtn.MouseButton1Click:Connect(function()
        if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
            TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            m.Visible = false
        end
    end)
    
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = m.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local TopDivider = Instance.new("Frame", m)
    TopDivider.Name = "TopDivider"
    TopDivider.Size = UDim2.new(1, -40, 0, 1)
    TopDivider.Position = UDim2.new(0, 20, 0, 55)
    TopDivider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    TopDivider.BorderSizePixel = 0
    TopDivider.ZIndex = 3
    
    local topDivGrad = Instance.new("UIGradient", TopDivider)
    topDivGrad.Color = Themes[CurrentTheme].DivGrad
    topDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    table.insert(UI_Elements.DivGradients, topDivGrad)
    
    ---------
    local LeftDivider = Instance.new("Frame", m)
    LeftDivider.Name = "LeftDivider"
    LeftDivider.Size = UDim2.new(0, 1, 1, -80)
    LeftDivider.Position = UDim2.new(0, 175, 0, 65) -- Adjusted for UI Ratio
    LeftDivider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    LeftDivider.BorderSizePixel = 0
    LeftDivider.ZIndex = 3
    
    local leftDivGrad = Instance.new("UIGradient", LeftDivider)
    leftDivGrad.Rotation = 90
    leftDivGrad.Color = Themes[CurrentTheme].DivGrad
    leftDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    table.insert(UI_Elements.DivGradients, leftDivGrad)
        local Sidebar = Instance.new("ScrollingFrame", m)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 170, 1, -65) -- Adjusted width for 600 UI
    Sidebar.Position = UDim2.new(0, 5, 0, 60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ZIndex = 2
    
    local sideLayout = Instance.new("UIListLayout", Sidebar)
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Ensure layout order respects Logo & Search

    -- Sidebar Logo Area
    local LogoFrame = Instance.new("Frame", Sidebar)
    LogoFrame.Name = "LogoArea"
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.LayoutOrder = 1
    
    LogoFrame.Size = UDim2.new(1, -10, 0, 120)
    local logoIcon = Instance.new("ImageLabel", LogoFrame)
    logoIcon.Size = UDim2.new(1, 0, 1, 0)
    logoIcon.BackgroundTransparency = 1
    logoIcon.ScaleType = Enum.ScaleType.Fit
    
    task.spawn(function()
        while task.wait(0.5) do
            if not LogoFrame.Parent then break end
            local iconId = "121203350952750"
            if CurrentTheme == "Dream" then 
                iconId = "90308084903285"
            elseif CurrentTheme == "Ocean" then 
                iconId = "103281926053314" 
            end
            logoIcon.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
        end
    end)

   -- Sidebar Search Area
    local SearchFrame = Instance.new("Frame", Sidebar)
    SearchFrame.Name = "SearchArea"
    SearchFrame.Size = UDim2.new(1, -20, 0, 32)
    SearchFrame.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
    SearchFrame.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
    SearchFrame.LayoutOrder = 2
    table.insert(UI_Elements.Containers, SearchFrame)
    Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)

    local SearchIconDisplay = Instance.new("ImageLabel", SearchFrame)
    SearchIconDisplay.Size = UDim2.new(0, 25, 0, 25)
SearchIconDisplay.AnchorPoint = Vector2.new(1, 0.5)
    SearchIconDisplay.Position = UDim2.new(1, -10, 0.5, 0)
    SearchIconDisplay.BackgroundTransparency = 1
    SearchIconDisplay.Image = "rbxthumb://type=Asset&id=111352610696552&w=150&h=150"
    
 if Themes[CurrentTheme] and Themes[CurrentTheme].SearchIconColor then
        SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].SearchIconColor
    else
        SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].TextColor
    end
    
    -- Vòng lặp kiểm tra để tự động thay đổi màu khi ann chọn theme khác nhó~
    task.spawn(function()
        while task.wait(0.5) do
            if not SearchIconDisplay.Parent then break end
            if Themes[CurrentTheme] then
                if Themes[CurrentTheme].SearchIconColor then
                    SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].SearchIconColor
                else
                    SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].TextColor
                end
            end
        end
    end)


    local SearchBox = Instance.new("TextBox", SearchFrame)
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Position = UDim2.new(0, 26, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Font = Enum.Font.GothamBold
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search Tab..."
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    ApplyTextGradient(SearchBox)
    ---------
    
    local TabsList = {}
    local PagesList = {}
    
    ---------
    -- Handle Search Filter
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(SearchBox.Text)
        for _, tabData in ipairs(TabsList) do
            if searchText == "" or string.find(string.lower(tabData.Name), searchText) then
                tabData.Btn.Visible = true
            else
                tabData.Btn.Visible = false
            end
        end
    end)
    ---------

    -- [[ TAB SYSTEM ]] --
    function Window:CreateTab(name, isFirstPage, tabIconId)
        local Tab = {}
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, -20, 0, 38)
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamBold
        btn.Text = ""
        btn.LayoutOrder = 3 + #TabsList -- Tab order goes below Logo & Search
        
        ---------
        -- Elegant Tab Background Indicator
        local activeBg = Instance.new("Frame", btn)
        activeBg.Name = "ActiveBg"
        activeBg.Size = UDim2.new(1, 0, 1, 0)
        activeBg.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        activeBg.BackgroundTransparency = isFirstPage and 0.8 or 1
        Instance.new("UICorner", activeBg).CornerRadius = UDim.new(0, 8)
        table.insert(UI_Elements.TabBackgrounds, activeBg)
        
        local activeGlow = Instance.new("Frame", activeBg)
        activeGlow.Size = UDim2.new(0, 4, 1, -10)
        activeGlow.Position = UDim2.new(0, 4, 0.5, 0)
        activeGlow.AnchorPoint = Vector2.new(0, 0.5)
        activeGlow.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        activeGlow.BackgroundTransparency = isFirstPage and 0 or 1
        activeGlow.BorderSizePixel = 0
        Instance.new("UICorner", activeGlow).CornerRadius = UDim.new(1, 0)
        
        local glowGrad = Instance.new("UIGradient", activeGlow)
        glowGrad.Rotation = 90
        glowGrad.Color = Themes[CurrentTheme].DivGrad
        glowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.5),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.85, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        table.insert(UI_Elements.DivGradients, glowGrad)
        ---------
        
        local btnText = Instance.new("TextLabel", btn)
        btnText.Size = UDim2.new(1, -25, 1, 0)
        btnText.Position = UDim2.new(0, 18, 0, 0)
        btnText.BackgroundTransparency = 1
        btnText.Font = Enum.Font.GothamBold
        btnText.Text = name
        -------------------------
        ApplyTextGradient(btnText)
        -------------------------
        btnText.TextSize = 13 -- Slightly scaled down for new UI ratio
        btnText.TextXAlignment = Enum.TextXAlignment.Left

        ---------
        if tabIconId and tabIconId ~= "" then
            local iconDisplay = Instance.new("ImageLabel", btn)
            iconDisplay.Size = UDim2.new(0, 16, 0, 16)
            iconDisplay.Position = UDim2.new(0, 14, 0.5, 0)
            iconDisplay.AnchorPoint = Vector2.new(0, 0.5)
            iconDisplay.BackgroundTransparency = 1
            iconDisplay.Image = tabIconId
            
            btnText.Position = UDim2.new(0, 36, 0, 0)
            btnText.Size = UDim2.new(1, -40, 1, 0)
        end
        ---------
        
        table.insert(TabsList, {Btn = btn, Bg = activeBg, Glow = activeGlow, Name = name})
        
        local page = Instance.new("ScrollingFrame", m)
        page.Name = name .. "Page"
        ---------
        page.Size = UDim2.new(1, -190, 1, -85) -- Adjusted for 600 width
        page.Position = UDim2.new(0, 180, 0, 70)
        ---------
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 0
        page.ZIndex = 2
        page.Visible = isFirstPage
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local pagePadding = Instance.new("UIPadding", page)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 20)
        pagePadding.PaddingTop = UDim.new(0, 5)
        
        local contentLayout = Instance.new("UIListLayout", page)
        contentLayout.Padding = UDim.new(0, 8)
        table.insert(PagesList, page)
        
        ---------
        -- Smooth Tab Transition
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(PagesList) do 
                if p.Visible then
                    TweenService:Create(p, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {ScrollBarImageTransparency = 1}):Play()
                    p.Visible = false 
                end
            end
            for _, t in pairs(TabsList) do 
                TweenService:Create(t.Bg, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Glow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
            end
            
            page.Position = UDim2.new(0, 180, 0, 100) -- Slide up effect
            page.ScrollBarImageTransparency = 1
            page.Visible = true
            
            TweenService:Create(page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 180, 0, 70),
                ScrollBarImageTransparency = 0
            }):Play()
            
            TweenService:Create(activeBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(activeGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            
            Library:SendNotification("Tab Selected", name)
        end)
        ---------

        function Tab:CreatePageTitle(text)
            local titleWrapper = Instance.new("Frame", page)
            titleWrapper.Size = UDim2.new(1, 0, 0, 45)
            titleWrapper.BackgroundTransparency = 1
            
            local title = Instance.new("TextLabel", titleWrapper)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            -------------------------
            ApplyTextGradient(title)
            -------------------------
            title.TextSize = 26
            title.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Tab:CreatePageSubTitle(text)
            local titleWrapper = Instance.new("Frame", page)
            titleWrapper.Size = UDim2.new(1, 0, 0, 35)
            titleWrapper.BackgroundTransparency = 1
            
            local title = Instance.new("TextLabel", titleWrapper)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            -------------------------
            ApplyTextGradient(title)
            -------------------------
            title.TextSize = 20
            title.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        ---------
        function Tab:CreateDropdown(text, default, optionsList, desc, callback)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local containerHeight = (desc and desc ~= "") and 62 or 46

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.Position = UDim2.new(0, 2, 0, 0)
            container.BackgroundTransparency = 1
            container.ClipsDescendants = false
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.Position = UDim2.new(0, 0, 0, 2)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.5, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -150, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                ---------
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------

            
            local dropBtn = Instance.new("TextButton", row)
            dropBtn.Size = UDim2.new(0, 130, 0, 30)
            dropBtn.Position = UDim2.new(1, -145, 0, 6)
            dropBtn.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            dropBtn.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, dropBtn)
            dropBtn.Text = default
            dropBtn.Font = Enum.Font.GothamBold
            -------------------------
            ApplyTextGradient(dropBtn)
            -------------------------
            dropBtn.TextSize = 12.5
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
            
            local arrow = Instance.new("TextLabel", dropBtn)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "​​≡"
            -------------------------
            ApplyTextGradient(arrow)
            -------------------------
            arrow.TextSize = 10
            
            local dropList = Instance.new("ScrollingFrame", container)
            dropList.Size = UDim2.new(1, 0, 1, -containerHeight - 2)
            dropList.Position = UDim2.new(0, 0, 0, containerHeight + 2)
            dropList.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            dropList.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            table.insert(UI_Elements.Containers, dropList)
            dropList.BorderSizePixel = 0
            dropList.ScrollBarThickness = 2
            dropList.Visible = false
            Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)
            
            local listLayout = Instance.new("UIListLayout", dropList)
            listLayout.Padding = UDim.new(0, 5)
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local dropListStroke = Instance.new("UIStroke", dropList)
            dropListStroke.Color = Themes[CurrentTheme].RowStroke
            dropListStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, dropListStroke)
            
            local dropListGrad = Instance.new("UIGradient", dropListStroke)
            dropListGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, dropListGrad)
            table.insert(UI_Elements.AnimatedGradients, dropListGrad)

            
            local flagId = name .. "_" .. text
            local function SetValue(val)
                dropBtn.Text = val
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetValue }
            
            local isDropped = false
            for _, opt in pairs(optionsList) do
                local dummyBtn = Instance.new("TextButton", dropList)
                dummyBtn.Size = UDim2.new(1, -10, 0, 30)
                dummyBtn.BackgroundTransparency = 1
                dummyBtn.Text = opt
                dummyBtn.Font = Enum.Font.GothamBold
                ApplyTextGradient(dummyBtn)
                dummyBtn.TextSize = 12
                
                dummyBtn.MouseButton1Click:Connect(function()
                    isDropped = false
                    
                    local tweenConn
                    local closeTween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, containerHeight)})
                    closeTween:Play()
                    
                    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    
                    tweenConn = closeTween.Completed:Connect(function()
                        if not isDropped then
                            dropList.Visible = false
                        end
                        tweenConn:Disconnect()
                    end)

                    SetValue(opt)
                    Library:SendNotification("Selected Mode", opt)
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local targetHeight = isDropped and 165 or containerHeight
                
                if isDropped then
                    dropList.Visible = true
                    task.spawn(function()
                        while isDropped and container and container.Parent do
                            if container.AbsoluteSize.Y < targetHeight - 2 or container.AbsoluteSize.X < 20 then
                                dropList.Visible = true
                                task.wait(0.05)
                            else
                                break
                            end
                        end
                        if isDropped then
                            dropList.Visible = true
                        end
                    end)
                end
                
                local tween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, targetHeight)})
                tween:Play()
                
                if not isDropped then
                    local tweenConn
                    tweenConn = tween.Completed:Connect(function()
                        if not isDropped then
                            dropList.Visible = false
                        end
                        tweenConn:Disconnect()
                    end)
                end    
                
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
            end)
        end        

        ---------
        function Tab:CreateMultiDropdown(text, defaultSelections, optionsList, desc, callback)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local containerHeight = (desc and desc ~= "") and 62 or 46

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.Position = UDim2.new(0, 2, 0, 0)
            container.BackgroundTransparency = 1
            container.ClipsDescendants = false
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.Position = UDim2.new(0, 0, 0, 2)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.5, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -70, 0, 15)
                descLabel.Position = UDim2.new(0, 12, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------

            
            local dropBtn = Instance.new("TextButton", row)
            dropBtn.Size = UDim2.new(0, 130, 0, 30)
            dropBtn.Position = UDim2.new(1, -145, 0, 6)
            dropBtn.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            dropBtn.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, dropBtn)
            dropBtn.Font = Enum.Font.GothamBold
            -------------------------
            ApplyTextGradient(dropBtn)
            -------------------------
            dropBtn.TextSize = 12.5
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
            
            local arrow = Instance.new("TextLabel", dropBtn)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "​​≡"
            -------------------------
            ApplyTextGradient(arrow)
            -------------------------
            arrow.TextSize = 10
            
            local dropList = Instance.new("ScrollingFrame", container)
            dropList.Size = UDim2.new(1, 0, 1, -containerHeight - 2)
            dropList.Position = UDim2.new(0, 0, 0, containerHeight + 2)
            dropList.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            dropList.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            table.insert(UI_Elements.Containers, dropList)
            dropList.BorderSizePixel = 0
            dropList.ScrollBarThickness = 2
            dropList.Visible = false
            Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)
            
            local listLayout = Instance.new("UIListLayout", dropList)
            listLayout.Padding = UDim.new(0, 5)
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local dropListStroke = Instance.new("UIStroke", dropList)
            dropListStroke.Color = Themes[CurrentTheme].RowStroke
            dropListStroke.Thickness = 1.2 
            table.insert(UI_Elements.RowStrokes, dropListStroke)
            
            local dropListGrad = Instance.new("UIGradient", dropListStroke)
            dropListGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, dropListGrad)
            table.insert(UI_Elements.AnimatedGradients, dropListGrad)

            local isDropped = false
            local selectedItems = {}
            optionsList = optionsList or {"Sample Mode 1", "Sample Mode 2"}
            defaultSelections = defaultSelections or {}
            
            for _, v in pairs(defaultSelections) do
                table.insert(selectedItems, v)
            end
            
            local OptionUpdaters = {}
            local flagId = name .. "_" .. text

            local function UpdateButtonText()
                if #selectedItems == 0 then
                    dropBtn.Text = "None Selected"
                elseif #selectedItems == 1 then
                    dropBtn.Text = selectedItems[1]
                elseif #selectedItems == 2 then
                    dropBtn.Text = selectedItems[1] .. ", " .. selectedItems[2]
                else
                    dropBtn.Text = "Selected (" .. tostring(#selectedItems) .. ")"
                end
            end
            
            local function SetValue(arr)
                selectedItems = {}
                local saveArr = {}
                for _, v in pairs(arr) do
                    table.insert(selectedItems, v)
                    table.insert(saveArr, v)
                end
                UpdateButtonText()
                for _, updater in pairs(OptionUpdaters) do
                    updater()
                end
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = saveArr
                end
                if callback then callback(selectedItems) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = defaultSelections, Set = SetValue }
            UpdateButtonText()
            
            for _, opt in pairs(optionsList) do
                local dummyBtn = Instance.new("TextButton", dropList)
                dummyBtn.Size = UDim2.new(1, -10, 0, 30)
                dummyBtn.BackgroundTransparency = 1
                dummyBtn.Text = opt
                dummyBtn.Font = Enum.Font.GothamBold
                ApplyTextGradient(dummyBtn)
                dummyBtn.TextSize = 12
                Instance.new("UICorner", dummyBtn).CornerRadius = UDim.new(0, 6)
                
                local isSelected = false
                local function UpdateVisuals()
                    if isSelected then
                        dummyBtn.BackgroundTransparency = 0.85
                        dummyBtn.BackgroundColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#00BFFF")
                        local textGrad = dummyBtn:FindFirstChildOfClass("UIGradient")
                        if textGrad then textGrad.Enabled = false end
                        dummyBtn.TextColor3 = Color3.fromHex("#FFFFFF")
                    else
                        dummyBtn.BackgroundTransparency = 1
                        local textGrad = dummyBtn:FindFirstChildOfClass("UIGradient")
                        if textGrad then textGrad.Enabled = true end
                        dummyBtn.TextColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].TextColor or Color3.fromHex("#FFFFFF")
                    end
                end
                
                table.insert(OptionUpdaters, function()
                    isSelected = false
                    for _, v in pairs(selectedItems) do
                        if v == opt then isSelected = true break end
                    end
                    UpdateVisuals()
                end)
                
                for _, v in pairs(selectedItems) do
                    if v == opt then isSelected = true break end
                end
                UpdateVisuals()
                
                dummyBtn.MouseButton1Click:Connect(function()
                    if isSelected then
                        isSelected = false
                        for i, v in ipairs(selectedItems) do
                            if v == opt then table.remove(selectedItems, i) break end
                        end
                    else
                        isSelected = true
                        table.insert(selectedItems, opt)
                    end
                    UpdateVisuals()
                    UpdateButtonText()
                    
                    if Library.ConfigElements[flagId] then
                        local currentSave = {}
                        for _, v in pairs(selectedItems) do table.insert(currentSave, v) end
                        Library.ConfigElements[flagId].Value = currentSave
                    end
                    
                    if callback then callback(selectedItems) end
                    Library:AutoSave()
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local targetHeight = isDropped and 165 or containerHeight
                
                if isDropped then
                    dropList.Visible = true
                    task.spawn(function()
                        while isDropped and container and container.Parent do
                            if container.AbsoluteSize.Y < targetHeight - 2 or container.AbsoluteSize.X < 20 then
                                dropList.Visible = true
                                task.wait(0.05)
                            else
                                break
                            end
                        end
                        if isDropped then
                            dropList.Visible = true
                        end
                    end)
                end
                
                local tween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, targetHeight)})
                tween:Play()
                
                if not isDropped then
                    local tweenConn
                    tweenConn = tween.Completed:Connect(function()
                        if not isDropped then
                            dropList.Visible = false
                        end
                        tweenConn:Disconnect()
                    end)
                end    
                
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
            end)
        end

        ---------
        function Tab:CreateButton(text, desc, callback)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local title = Instance.new("TextLabel", row)
            title.Name = "Title"
            title.Size = UDim2.new(1, -70, 0, 42)
            title.Position = UDim2.new(0, 12, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            ApplyTextGradient(title)
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -70, 0, 15)
                descLabel.Position = UDim2.new(0, 12, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------
            
            local btnContainer = Instance.new("TextButton", row)
            btnContainer.Name = "Button"
            btnContainer.Size = UDim2.new(0, 36, 0, 36)
            btnContainer.Position = UDim2.new(1, -10, 0.5, 0)
            btnContainer.AnchorPoint = Vector2.new(1, 0.5)
            btnContainer.BackgroundTransparency = 1
            btnContainer.Text = ""
            btnContainer.ZIndex = 10
            
            local coreContainer = Instance.new("Frame", btnContainer)
            coreContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            coreContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            coreContainer.Size = UDim2.new(1, 0, 1, 0)
            coreContainer.BackgroundTransparency = 1
            
            local uiScale = Instance.new("UIScale", coreContainer)
            uiScale.Scale = 1
            
            local coreLayers = {}
            local baseSizes = {8, 14, 20, 26, 32, 38} 
            local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
            
            for i = 1, #baseSizes do
                local layer = Instance.new("Frame")
                layer.AnchorPoint = Vector2.new(0.5, 0.5)
                layer.Position = UDim2.new(0.5, 0, 0.5, 0)
                layer.BorderSizePixel = 0
                layer.ZIndex = 3
                
                Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
                layer.Parent = coreContainer
                table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
            end
            
            local r = 0
            local isClicked = false
            local clickTime = 0
            
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not btnContainer.Parent then
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                r = (r + 1.5) % 360
                local t = Themes[CurrentTheme]
                
               local c1, c2
                if isClicked then
                    c1 = t.ToggleActive
                    c2 = t.ToggleActive
                else
                    c1 = Color3.fromRGB(150, 150, 150)
                    c2 = Color3.fromRGB(150, 150, 150)
                end
                
                local pulse = (math.sin(tick() * 3) + 1) / 2
                local coreColor = c1:Lerp(c2, math.abs(math.sin((r / 360) * math.pi)))
                
                for _, data in ipairs(coreLayers) do
                    local sizeOffset = pulse * 4
                    local targetSize = data.baseSize + sizeOffset
                    data.frame.Size = UDim2.new(0, targetSize, 0, targetSize)
                    data.frame.BackgroundColor3 = coreColor
                    data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
                end
                
                if isClicked and tick() - clickTime >= 0.5 then
                    isClicked = false
                    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1}):Play()
                end
            end)
            
            btnContainer.MouseButton1Down:Connect(function()
                TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
            end)
            
            btnContainer.MouseButton1Up:Connect(function()
                if not isClicked then
                    TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
                end
            end)
            
            btnContainer.MouseButton1Click:Connect(function()
                isClicked = true
                clickTime = tick()
                TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
                
                if callback then callback() end
                Library:SendNotification("Button Clicked", text)
            end)
        end

        ---------
        function Tab:CreateSwitch(text, default, desc, callback)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.Position = UDim2.new(0, 2, 0, 0)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.7, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -80, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------
            
            local toggleFrame = Instance.new("TextButton", row)
            toggleFrame.Size = UDim2.new(0, 40, 0, 20)
            toggleFrame.Position = UDim2.new(1, -55, 0.5, 0)
            toggleFrame.AnchorPoint = Vector2.new(0, 0.5)
            toggleFrame.BackgroundColor3 = default and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")
            toggleFrame.Text = ""
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
            
            local ball = Instance.new("Frame", toggleFrame)
            ball.Size = UDim2.new(0, 16, 0, 16)
            ball.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            ball.AnchorPoint = Vector2.new(0, 0.5)
            ball.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
            
            local active = default
            local switchData = {Frame = toggleFrame, Active = active}
            table.insert(UI_Elements.Switches, switchData)
            
            local flagId = name .. "_" .. text
            local function SetState(v)
                active = v
                switchData.Active = active
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = active
                end
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = active and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")}):Play()
                TweenService:Create(ball, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
                if callback then callback(active) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetState }

            toggleFrame.MouseButton1Click:Connect(function()
                SetState(not active)
                local status = active and "Enabled" or "Disabled"
                Library:SendNotification("Switch Toggled", text .. ": " .. status)
            end)
        end

        function Tab:CreateLabel(titleText, descText)
            local row = Instance.new("Frame", page)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Size = UDim2.new(1, -4, 0, 42)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local layout = Instance.new("UIListLayout", row)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 2)
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

            local padding = Instance.new("UIPadding", row)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.PaddingTop = UDim.new(0, 8)
            padding.PaddingBottom = UDim.new(0, 8)

            if titleText and titleText ~= "" then
                local labelTitle = Instance.new("TextLabel", row)
                labelTitle.Name = "Title"
                labelTitle.LayoutOrder = 1
                labelTitle.Size = UDim2.new(1, 0, 0, 20)
                labelTitle.BackgroundTransparency = 1
                labelTitle.Font = Enum.Font.GothamBold
                labelTitle.Text = titleText
                ApplyTextGradient(labelTitle)
                labelTitle.TextSize = 14
                labelTitle.TextXAlignment = Enum.TextXAlignment.Left
                labelTitle.AutomaticSize = Enum.AutomaticSize.Y
            end
            
            if descText and descText ~= "" then
                local labelDesc = Instance.new("TextLabel", row)
                labelDesc.Name = "Description"
                labelDesc.LayoutOrder = 2
                labelDesc.Size = UDim2.new(1, 0, 0, 0)
                labelDesc.BackgroundTransparency = 1
                labelDesc.Font = Enum.Font.GothamBold
                labelDesc.Text = descText
                ApplyTextGradient(labelDesc)
                labelDesc.TextSize = 10
                labelDesc.TextXAlignment = Enum.TextXAlignment.Left
                labelDesc.TextWrapped = true
                labelDesc.AutomaticSize = Enum.AutomaticSize.Y
            end
        end
        
        function Tab:CreateParagraph(titleText, descText)
            local row = Instance.new("Frame", page)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Size = UDim2.new(1, -4, 0, 0)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8) 
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke 
            rowStroke.Thickness = 1.2 
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad 
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local layout = Instance.new("UIListLayout", row)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 4)
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

            local padding = Instance.new("UIPadding", row)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.PaddingTop = UDim.new(0, 10)
            padding.PaddingBottom = UDim.new(0, 10)

            if titleText and titleText ~= "" then
                local labelTitle = Instance.new("TextLabel", row)
                labelTitle.Name = "ParagraphTitle"
                labelTitle.LayoutOrder = 1
                labelTitle.Size = UDim2.new(1, 0, 0, 20)
                labelTitle.BackgroundTransparency = 1
                labelTitle.Font = Enum.Font.GothamBold 
                labelTitle.Text = titleText
                ApplyTextGradient(labelTitle)
                labelTitle.TextSize = 14 
                labelTitle.TextXAlignment = Enum.TextXAlignment.Left 
                labelTitle.AutomaticSize = Enum.AutomaticSize.Y
            end

            if descText and descText ~= "" then
                local labelDesc = Instance.new("TextLabel", row)
                labelDesc.Name = "ParagraphContent"
                labelDesc.LayoutOrder = 2
                labelDesc.Size = UDim2.new(1, 0, 0, 0)
                labelDesc.BackgroundTransparency = 1
                labelDesc.Font = Enum.Font.GothamBold
                labelDesc.Text = descText
                ApplyTextGradient(labelDesc)
                labelDesc.TextSize = 10
                labelDesc.TextXAlignment = Enum.TextXAlignment.Left
                labelDesc.TextWrapped = true
                labelDesc.AutomaticSize = Enum.AutomaticSize.Y
            end
        end

        ---------
        function Tab:CreateSlider(text, min, max, default, desc, callback)
            local rowHeight = (desc and desc ~= "") and 76 or 60
            local containerHeight = (desc and desc ~= "") and 81 or 65

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.BackgroundTransparency = 1
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.6, 0, 0, 30)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -80, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------

            local inputField = Instance.new("TextBox", row)
            inputField.Size = UDim2.new(0, 50, 0, 22)
            inputField.Position = UDim2.new(1, -65, 0, 10)
            inputField.BackgroundColor3 = Color3.fromHex("#000000")
            inputField.BackgroundTransparency = 0.9
            inputField.Font = Enum.Font.GothamBold
            inputField.Text = tostring(default)
            -------------------------
            ApplyTextGradient(inputField)
            -------------------------
            inputField.TextSize = 12
            Instance.new("UICorner", inputField).CornerRadius = UDim.new(0, 5)
            
            ---------
            local sliderBg = Instance.new("Frame", row)
            sliderBg.Size = UDim2.new(1, -30, 0, 6)
            local sliderYPos = (desc and desc ~= "") and 60 or 45
            sliderBg.Position = UDim2.new(0, 15, 0, sliderYPos)
            ---------
            sliderBg.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            sliderBg.BackgroundTransparency = 0.9
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            
            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            sliderFill.BorderSizePixel = 0
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
            
            local fillGrad = Instance.new("UIGradient", sliderFill)
            fillGrad.Color = Themes[CurrentTheme].TextGrad
            table.insert(UI_Elements.AnimatedGradients, fillGrad)

            local circle = Instance.new("Frame", sliderFill)
            circle.Size = UDim2.new(0, 65, 2, 60)
            circle.Position = UDim2.new(1, 0, 0.5, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundTransparency = 1

            local circleVisual = Instance.new("Frame", circle)
            circleVisual.Size = UDim2.new(0, 14, 0, 14)
            circleVisual.Position = UDim2.new(0.5, 0, 0.5, 0)
            circleVisual.AnchorPoint = Vector2.new(0.5, 0.5)
            circleVisual.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            Instance.new("UICorner", circleVisual).CornerRadius = UDim.new(1, 0)

            local flagId = name .. "_" .. text
            local function SetValue(val)
                val = math.clamp(val, min, max)
                sliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                inputField.Text = tostring(val)
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetValue }

            local function move(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                SetValue(value)
            end
            
            local dragging = false
            circle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if dragging then
                        dragging = false
                        Library:AutoSave()
                    end
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
            end)

            inputField.FocusLost:Connect(function()
                local val = tonumber(inputField.Text)
                if not val then val = default end
                val = math.clamp(val, min, max)
                
                inputField.Text = tostring(val)
                TweenService:Create(sliderFill, TweenInfo.new(0.2), {Size = UDim2.new((val - min) / (max - min), 0, 1, 0)}):Play()
                
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
                Library:AutoSave()
            end)
        end

        ---------
        function Tab:CreateCopy(titleText, contentToCopy, descText)
            local rowHeight = (descText and descText ~= "") and 65 or 50
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local title = Instance.new("TextLabel", row)
            title.Size = UDim2.new(1, -50, 0, 30)
            title.Position = UDim2.new(0, 12, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = titleText
            ApplyTextGradient(title)
            title.TextSize = 13.5
            title.TextXAlignment = Enum.TextXAlignment.Left

            if descText and descText ~= "" then
                title.Position = UDim2.new(0, 12, 0, 5)
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -60, 0, 20)
                descLabel.Position = UDim2.new(0, 12, 0, 28)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = descText
                ---------
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------


            -- Create Tiny Button inside the corner
            local copyBtn = Instance.new("TextButton", row)
            copyBtn.Size = UDim2.new(0, 30, 0, 30)
            copyBtn.Position = UDim2.new(1, -5, 0, 5)
            copyBtn.AnchorPoint = Vector2.new(1, 0)
            copyBtn.BackgroundTransparency = 1
            copyBtn.Text = ""
            
            local coreContainer = Instance.new("Frame", copyBtn)
            coreContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            coreContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            coreContainer.Size = UDim2.new(1, 0, 1, 0)
            coreContainer.BackgroundTransparency = 1
            
            local uiScale = Instance.new("UIScale", coreContainer)
            uiScale.Scale = 1
            
            local coreLayers = {}
            local baseSizes = {8, 12, 16, 20, 24, 28} 
            local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
            
            for i = 1, #baseSizes do
                local layer = Instance.new("Frame")
                layer.AnchorPoint = Vector2.new(0.5, 0.5)
                layer.Position = UDim2.new(0.5, 0, 0.5, 0)
                layer.BorderSizePixel = 0
                layer.ZIndex = 3
                Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
                layer.Parent = coreContainer
                table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
            end
            
            local r = 0
            local isClicked = false
            local clickTime = 0
            
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not copyBtn.Parent then
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                r = (r + 1.5) % 360
                local t = Themes[CurrentTheme]
                
               local c1, c2
                if isClicked then
                    c1 = t.ToggleActive
                    c2 = t.ToggleActive
                else
                    c1 = Color3.fromRGB(150, 150, 150)
                    c2 = Color3.fromRGB(150, 150, 150)
                end
                
                local pulse = (math.sin(tick() * 3) + 1) / 2
                local coreColor = c1:Lerp(c2, math.abs(math.sin((r / 360) * math.pi)))
                
                for _, data in ipairs(coreLayers) do
                    local sizeOffset = pulse * 3
                    local targetSize = data.baseSize + sizeOffset
                    data.frame.Size = UDim2.new(0, targetSize, 0, targetSize)
                    data.frame.BackgroundColor3 = coreColor
                    data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
                end
                
                if isClicked and tick() - clickTime >= 0.5 then
                    isClicked = false
                    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1}):Play()
                end
            end)

            copyBtn.MouseButton1Down:Connect(function()
                TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
            end)
            
            copyBtn.MouseButton1Up:Connect(function()
                if not isClicked then TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play() end
            end)
            
            copyBtn.MouseButton1Click:Connect(function()
                isClicked = true
                clickTime = tick()
                TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
                
                local clipboardFunc = setclipboard or toclipboard or function(text) warn("Clipboard: " .. tostring(text)) end
                clipboardFunc(contentToCopy)
                Library:SendNotification("Copied Successfully", titleText)
            end)
        end
        ---------

        return Tab
    end

    function Window:ApplyTheme(name)
        local t = Themes[name]
        if not t then return end
        CurrentTheme = name
        
        if m then 
            TweenService:Create(m, TweenInfo.new(0.3), {BackgroundColor3 = t.MainBg, BackgroundTransparency = t.MainBgTrans}):Play()
        end
        
        for _, bg in pairs(UI_Elements.Containers) do
            if bg and bg.Parent then
                TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundColor3 = t.ContainerBg, BackgroundTransparency = t.ContainerTrans}):Play()
            end
        end
        
        for _, tabBg in pairs(UI_Elements.TabBackgrounds) do
            if tabBg and tabBg.Parent then
                TweenService:Create(tabBg, TweenInfo.new(0.3), {BackgroundColor3 = t.ContainerBg}):Play()
            end
        end
        
        for _, obj in pairs(UI_Elements.TextGradients) do
            if obj and obj.Parent then 
                obj.Color = t.TextContrast 
                if obj.Parent:IsA("TextLabel") or obj.Parent:IsA("TextButton") or obj.Parent:IsA("TextBox") then
                    obj.Parent.TextColor3 = t.TextColor
                end
            end
        end

        for _, item in pairs(UI_Elements.AnimatedStrokes) do
            if item.Obj and item.Obj.Parent then
                TweenService:Create(item.Obj, TweenInfo.new(0.3), {Color = t[item.Type]}):Play()
            end
        end
        
        for _, s in pairs(UI_Elements.RowStrokes) do
            if s and s.Parent then
                TweenService:Create(s, TweenInfo.new(0.3), {Color = t.RowStroke}):Play()
            end
        end
        
        for _, g in pairs(UI_Elements.AnimatedGradients) do
            if g and g.Parent then g.Color = t.TextGrad end
        end
        
        for _, g in pairs(UI_Elements.RowStrokeGradients) do
            if g and g.Parent then g.Color = t.RowStrokeGrad end
        end
        
        for _, g in pairs(UI_Elements.TabGradients) do
            if g and g.Parent then g.Color = t.TabGrad end
        end
        
        for _, d in pairs(UI_Elements.DivGradients) do
            if d and d.Parent then d.Color = t.DivGrad end
        end
        
        ---------
        ---------
        for _, sw in pairs(UI_Elements.Switches) do
            if sw.Active then
                TweenService:Create(sw.Frame, TweenInfo.new(0.3), {BackgroundColor3 = t.ToggleActive}):Play()
            end
        end
        
        for _, desc in pairs(UI_Elements.Descriptions) do
            if desc and desc.Parent then
                TweenService:Create(desc, TweenInfo.new(0.3), {TextColor3 = t.DescTextColor}):Play()
            end
        end
    end
---------

    
    local r = 0
    RunService.RenderStepped:Connect(function(dt)
        r = (r + 1.5) % 360
        e.Rotation = r
        
        for _, rotGrad in pairs(UI_Elements.RotatingGradients) do
            if rotGrad and rotGrad.Parent then 
                rotGrad.Rotation = r 
                rotGrad.Color = Themes[CurrentTheme].LoopSeq
            end
        end
        
        local animatedOffset = Vector2.new(math.sin(tick() * 2) * 0.4, 0)
        for _, grad in pairs(UI_Elements.AnimatedGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        for _, grad in pairs(UI_Elements.RowStrokeGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        for _, grad in pairs(UI_Elements.TabGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        
        if Mini3DIcon.Visible then
            angleY = angleY + dt * 0.6
            angleX = angleX + dt * 0.35
            local pulse = (math.sin(tick() * 3) + 1) / 2
            local tVal = (r / 360)
            
            local c1 = Themes[CurrentTheme].TextGrad.Keypoints[1].Value
            local c2 = Themes[CurrentTheme].ToggleActive
            local coreColor = c1:Lerp(c2, math.abs(math.sin(tVal * math.pi)))
            
            for _, grad in ipairs(lineGradients) do
                grad.Rotation = r
                grad.Color = Themes[CurrentTheme].LoopSeq
            end
            
            for _, data in ipairs(coreLayers) do
                local sizeOffset = pulse * 12
                data.frame.Size = UDim2.new(0, data.baseSize + sizeOffset, 0, data.baseSize + sizeOffset)
                data.frame.BackgroundColor3 = coreColor
                data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
            end
            
            for i, edge in ipairs(edges) do
                local p1, z1 = project3D(vertices[edge[1]])
                local p2, z2 = project3D(vertices[edge[2]])
                local line = lines[i]
                local diff = p2 - p1
                line.Size = UDim2.new(0, diff.Magnitude, 0, 0.1)
                line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
                line.Rotation = math.deg(math.atan2(diff.Y, diff.X))
                local avgZ = (z1 + z2) / 2
                line.BackgroundTransparency = 1 - math.clamp(1 - (avgZ / 2.5), 0.15, 1)
                
                local strk = line:FindFirstChildWhichIsA("UIStroke")
                if avgZ > 0 then
                    line.ZIndex = 2
                    if strk then strk.Transparency = 0.8 end
                else
                    line.ZIndex = 4
                    if strk then strk.Transparency = math.clamp(0.4 - (pulse * 0.2), 0, 1) end
                end
            end
        end
    end)

    ---------
    m.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(m, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 525)}):Play()
    Library:SendNotification("Status", "Hub Initialized!")
    
    task.spawn(function()
        task.wait(1.5)
        Library:LoadConfig("AutoSave", true)
    end)

    return Window
    ---------
end

local Window = Library:CreateWindow({Title = "UI Showcase Hub"})

-- The 3rd parameter is for your tab decal id, e.g. "rbxassetid://12345"
local ElementsPage = Window:CreateTab("UI Elements", true, "")
local SettingsPage = Window:CreateTab("Settings", false, "")

ElementsPage:CreatePageTitle("Basic Elements")
ElementsPage:CreatePageSubTitle("Interactable UI")

ElementsPage:CreateButton("Test Button", "This is an optional description", function()
    print("Button Clicked")
end)

ElementsPage:CreateSwitch("Test Switch", false, "Toggle this setting on or off", function(state)
    print("Switch State:", state)
end)

ElementsPage:CreateSlider("Test Slider", 10, 100, 50, "Slide to adjust value", function(value)
    print("Slider Value:", value)
end)

ElementsPage:CreatePageSubTitle("Special Functions")

-- Example of CreateCopy
ElementsPage:CreateCopy("Discord Server", "discord.gg/meyycutie", "Click the button to copy link")

ElementsPage:CreatePageSubTitle("Dropdowns")

ElementsPage:CreateDropdown("Test Dropdown", "Option 1", {"Option 1", "Option 2", "Option 3"}, "Choose one option", function(selected)
    print("Dropdown Selected:", selected)
end)

ElementsPage:CreateMultiDropdown("Test Multi", {"Apple"}, {"Apple", "Banana", "Orange"}, "Select multiple options", function(selectedItems)
    print("Multi Selected:")
    for i, v in pairs(selectedItems) do
        print(i, v)
    end
end)

SettingsPage:CreatePageTitle("Settings")
SettingsPage:CreatePageSubTitle("Theme Customization")

SettingsPage:CreateDropdown("Select Theme", "Ocean", {"Ocean", "Dream", "Dark"}, "Change UI colors", function(selected)
    Window:ApplyTheme(selected)
end)
-------------------------
return Library
