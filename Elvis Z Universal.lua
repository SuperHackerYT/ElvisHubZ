local NEVERLOSE = loadstring(game:HttpGet("https://github.com/SuperHackerYT/ElvisHubZ/raw/refs/heads/main/Elvis%20X%20Neverlose.lua"))()
local LOADER = loadstring(game:HttpGet("https://github.com/SuperHackerYT/ElvisHubZ/raw/refs/heads/main/loader.Function.lua"))()

LOADER:Add(function()
local Window = NEVERLOSE:AddWindow("Elvis Z", "Elvis Hub Z")

-- Home
Window:AddTabLabel('Home')

local HomeTab = Window:AddTab('Main','code')

local Home = HomeTab:AddSection('Quick Hacks',"left")

Home:AddSlider('Walkspeed', 1, 100, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

Home:AddSlider('Gravity', 0, 500, 196, function(val)
    workspace.Gravity = val
end)

Home:AddSlider('Jump Height', 0, 200, 50, function(val)
    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = val
    end
end)

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local infJumpEnabled = false
local infJumpConnection

local function enableInfiniteJump()
    if infJumpConnection then infJumpConnection:Disconnect() end
    infJumpConnection = UIS.JumpRequest:Connect(function()
        if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if infJumpEnabled then
        enableInfiniteJump()
    end
end)

Home:AddToggle('Infinite Jump', false, function(val)
    infJumpEnabled = val
    if val then
        enableInfiniteJump()
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local flying = false
local speedMultiplier = 50
local currentSpeed = 0

local torso
if hum.RigType == Enum.HumanoidRigType.R6 then
    torso = char:WaitForChild("Torso")
else
    torso = char:WaitForChild("UpperTorso")
end

local bg, bv

local RunService = game:GetService("RunService")

local function startFly()
    flying = true
    hum.PlatformStand = true
    char.Animate.Disabled = true

    bg = Instance.new("BodyGyro", torso)
    bg.P = 90000
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame

    bv = Instance.new("BodyVelocity", torso)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.velocity = Vector3.new(0,0,0)

    currentSpeed = 0

    RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
        if not flying or hum.Health <= 0 then
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = hum.MoveDirection
        local moveMagnitude = moveDir.Magnitude

        if moveMagnitude > 0 then
            currentSpeed = math.min(currentSpeed + 5, speedMultiplier)
        else
            currentSpeed = math.max(currentSpeed - 5, 0)
        end

        if currentSpeed > 0 then
            local flyVel = cam.CFrame.LookVector.Unit * moveMagnitude * currentSpeed
            bv.velocity = flyVel
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end

        bg.cframe = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    hum.PlatformStand = false
    char.Animate.Disabled = false

    RunService:UnbindFromRenderStep("FlyMovement")

    if bg then
        bg:Destroy()
        bg = nil
    end

    if bv then
        bv:Destroy()
        bv = nil
    end
end

Home:AddToggle('Fly', false, function(val)
    if val then
        startFly()
    else
        stopFly()
    end
end)

Home:AddToggle('Anti-Fling', false, function(val)
    if val then
        _G.AntiFlingConfig = {
            disable_rotation = true,
            limit_velocity = true,
            limit_velocity_sensitivity = 150,
            limit_velocity_slow = 0,
            anti_ragdoll = true,
            anchor = false,
            smart_anchor = true,
            anchor_dist = 30,
            teleport = false,
            smart_teleport = true,
            teleport_dist = 30
        }
        _G.disable = nil 
        loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/rblx/main/extra/better_antifling.lua'))()
    else
        if _G.disable then
            _G.disable()
        end
    end
end)

Home:AddToggle('Anti-Yeet', false, function(val)
    if val then
        -- Config for anti knockback / anti yeet
        _G.AntiYeetConfig = {
            limit_velocity = true,
            limit_velocity_sensitivity = 50, 
            limit_velocity_slow = 0,
            disable_rotation = true,
            anti_ragdoll = true
        }

        -- Script to constantly zero velocity if it spikes from slap force
        _G.AntiYeetLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local lp = game.Players.LocalPlayer
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if _G.AntiYeetConfig.limit_velocity and hrp.Velocity.Magnitude > _G.AntiYeetConfig.limit_velocity_sensitivity then
                    hrp.Velocity = hrp.Velocity.Unit * _G.AntiYeetConfig.limit_velocity_slow
                end
                if _G.AntiYeetConfig.disable_rotation then
                    hrp.RotVelocity = Vector3.new()
                end
            end
        end)

    else
        if _G.AntiYeetLoop then
            _G.AntiYeetLoop:Disconnect()
            _G.AntiYeetLoop = nil
        end
    end
end)

local noclipEnabled = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function createHighlight(character)
    local highlight = character:FindFirstChild("NoclipHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "NoclipHighlight"
        highlight.FillColor = Color3.fromRGB(0, 170, 255) -- Blue
        highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0.4
        highlight.Parent = character
    end
    return highlight
end

local function isInsideObject(part)
    local touchingParts = part:GetTouchingParts()
    for _, p in pairs(touchingParts) do
        if p and p.CanCollide and p.Transparency < 1 and p ~= part then
            return true
        end
    end
    return false
end

local function monitorNoclip(character)
    local highlight = createHighlight(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not noclipEnabled then
            highlight.Enabled = false
            conn:Disconnect()
            return
        end

        if isInsideObject(hrp) then
            highlight.Enabled = true
        else
            highlight.Enabled = false
        end
    end)
end

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        -- Start noclip (disable collisions)
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            monitorNoclip(character)
        end
        LocalPlayer.CharacterAdded:Connect(function(char)
            wait(0.5)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            monitorNoclip(char)
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            local highlight = character:FindFirstChild("NoclipHighlight")
            if highlight then highlight.Enabled = false end
        end
    end
end

Home:AddToggle('Noclip', false, function(val)
    toggleNoclip(val)
end)

local espEnabled = false
local espObjects = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function createESP(plr)
    if espObjects[plr] then return end
    local esp = {}

    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil -- set dynamically
    box.Size = Vector3.new(4, 6, 0.1)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(0, 170, 255) -- Blue
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = workspace

    -- Line 
    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(0, 170, 255)
    line.Thickness = 2
    line.Transparency = 1

    -- Text
    local text = Drawing.new("Text")
    text.Center = true
    text.Color = Color3.fromRGB(0, 170, 255)
    text.Size = 16
    text.Outline = true
    text.OutlineColor = Color3.new(0,0,0)

    esp.box = box
    esp.line = line
    esp.text = text

    espObjects[plr] = esp
end

local function removeESP(plr)
    local esp = espObjects[plr]
    if esp then
        esp.box:Destroy()
        esp.line:Remove()
        esp.text:Remove()
        espObjects[plr] = nil
    end
end

local function updateESP()
    if not espEnabled then return end

    for plr, esp in pairs(espObjects) do
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        if head and head.Parent then
            esp.box.Adornee = head

            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

            if onScreen then
                esp.text.Visible = true
                esp.text.Position = Vector2.new(headPos.X, headPos.Y - 40)
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                esp.text.Text = plr.Name .. " [" .. math.floor(dist) .. "m]"
                esp.line.Visible = false
            else
                esp.text.Visible = false
                esp.line.Visible = true

                local dir = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Unit

                local length = 500
                local startPos = screenCenter
                local endPos = screenCenter + dir * length

                esp.line.From = startPos
                esp.line.To = endPos
            end

            esp.box.Visible = true
        else
            esp.box.Visible = false
            esp.text.Visible = false
            esp.line.Visible = false
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createESP(plr)
                plr.CharacterAdded:Connect(function()
                    wait(0.5)
                    if espEnabled then createESP(plr) end
                end)
            end
        end

        Players.PlayerAdded:Connect(function(plr)
            if plr ~= LocalPlayer and espEnabled then
                createESP(plr)
                plr.CharacterAdded:Connect(function()
                    wait(0.5)
                    if espEnabled then createESP(plr) end
                end)
            end
        end)

        Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
        end)

        RunService.RenderStepped:Connect(updateESP)
    else
        for plr, esp in pairs(espObjects) do
            removeESP(plr)
        end
    end
end

Home:AddToggle('ESP', false, function(val)
    toggleESP(val)
end)

-- Aimbot
Window:AddTabLabel("Aimbot")
local Ragebot = Window:AddTab("Ragebot", "crosshair")
local AntiAim = Window:AddTab("Anti Aim", "retry")
local Legitbot = Window:AddTab("Legitbot", "list")

-- Visuals
Window:AddTabLabel("Visuals")
local Players = Window:AddTab("Players", "user")

local left = Players:AddSection('ESP',"left")
local right = Players:AddSection('Chams',"right")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPObjects = {}
local EnemiesFolder = workspace:FindFirstChild("Enemies")

-- Settings
local settings = {
    ThroughWalls = false
}

-- Clear all ESP
local function ClearESP()
    for _, highlight in pairs(ESPObjects) do
        if highlight and highlight.Destroy then
            highlight:Destroy()
        end
    end
    ESPObjects = {}
end

local function CreateESPForModel(id, model)
    if not model or not model:IsDescendantOf(workspace) then return end

    if ESPObjects[id] then
        ESPObjects[id]:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = settings.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    highlight.Adornee = model
    highlight.Parent = CoreGui

    ESPObjects[id] = highlight
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then return end
    if player.Character then
        CreateESPForModel(player, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ESPEnabled then
            CreateESPForModel(player, char)
        end
    end)
end

local function SetupEnemyESP(npc)
    if npc:IsA("Model") then
        CreateESPForModel(npc, npc)
    end
end

local function ToggleESP(enabled)
    ESPEnabled = enabled
    ClearESP()

    if enabled then

        for _, player in ipairs(Players:GetPlayers()) do
            SetupPlayerESP(player)
        end
        Players.PlayerAdded:Connect(SetupPlayerESP)

        if EnemiesFolder then
            for _, npc in ipairs(EnemiesFolder:GetChildren()) do
                SetupEnemyESP(npc)
            end
            EnemiesFolder.ChildAdded:Connect(function(npc)
                task.wait(1)
                if ESPEnabled then
                    SetupEnemyESP(npc)
                end
            end)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for id, highlight in pairs(ESPObjects) do
            local model
            if typeof(id) == "Player" then
                model = id.Character
            elseif typeof(id) == "Instance" then
                model = id
            end

            if not model or not model:IsDescendantOf(workspace) then
                highlight:Destroy()
                ESPObjects[id] = nil
            else
                highlight.Adornee = model
                highlight.DepthMode = settings.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            end
        end
    end
end)
local espEnabled = false
local espObjects = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function createESP(plr)
    if espObjects[plr] then return end
    local esp = {}

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil -- set dynamically
    box.Size = Vector3.new(4, 6, 0.1)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(0, 170, 255) -- Blue
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = workspace

    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(0, 170, 255)
    line.Thickness = 2
    line.Transparency = 1

    local text = Drawing.new("Text")
    text.Center = true
    text.Color = Color3.fromRGB(0, 170, 255)
    text.Size = 16
    text.Outline = true
    text.OutlineColor = Color3.new(0,0,0)

    esp.box = box
    esp.line = line
    esp.text = text

    espObjects[plr] = esp
end

local function removeESP(plr)
    local esp = espObjects[plr]
    if esp then
        esp.box:Destroy()
        esp.line:Remove()
        esp.text:Remove()
        espObjects[plr] = nil
    end
end

local function updateESP()
    if not espEnabled then return end

    for plr, esp in pairs(espObjects) do
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        if head and head.Parent then
            esp.box.Adornee = head

            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

            if onScreen then
                esp.text.Visible = true
                esp.text.Position = Vector2.new(headPos.X, headPos.Y - 40)
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                esp.text.Text = plr.Name .. " [" .. math.floor(dist) .. "m]"

                esp.line.Visible = false
            else

                esp.text.Visible = false
                esp.line.Visible = true

                local dir = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Unit

                local length = 500
                local startPos = screenCenter
                local endPos = screenCenter + dir * length

                esp.line.From = startPos
                esp.line.To = endPos
            end

            esp.box.Visible = true
        else
            esp.box.Visible = false
            esp.text.Visible = false
            esp.line.Visible = false
        end
    end
end

local function ToggleESP(state)
    espEnabled = state
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createESP(plr)
                plr.CharacterAdded:Connect(function()
                    wait(0.5)
                    if espEnabled then createESP(plr) end
                end)
            end
        end

        Players.PlayerAdded:Connect(function(plr)
            if plr ~= LocalPlayer and espEnabled then
                createESP(plr)
                plr.CharacterAdded:Connect(function()
                    wait(0.5)
                    if espEnabled then createESP(plr) end
                end)
            end
        end)

        Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
        end)

        RunService.RenderStepped:Connect(updateESP)
    else
        for plr, esp in pairs(espObjects) do
            removeESP(plr)
        end
    end
end

left:AddToggle('Enable ESP', false, function(v)
    ToggleESP(v)
end)

left:AddToggle("Through Walls", false, function(v)
    settings.ThroughWalls = v
end)

left:AddDropdown("Bullet Tracer", {"Disabled", "Enabled"}, 1, function(v)
    settings.BulletTracer = (v == "Enabled")
end)

left:AddToggle("Dynamic Boxes", false, function(v)
    settings.DynamicBoxes = v
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local radarGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
radarGui.Name = "RadarGui"
radarGui.Enabled = false

local radarFrame = Instance.new("Frame", radarGui)
radarFrame.Size = UDim2.new(0, 150, 0, 150)
radarFrame.Position = UDim2.new(0, 10, 0, 10)
radarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
radarFrame.BackgroundTransparency = 0.5
radarFrame.BorderSizePixel = 0
radarFrame.AnchorPoint = Vector2.new(0, 0)

local dots = {}

-- Function to create dot for player
local function createDot(player)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- cyan dot for enemies
    dot.BorderSizePixel = 0
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Visible = false
    dot.Parent = radarFrame
    return dot
end

-- Sound ESP (basic example)
local soundConnections = {}

local function onSoundEspEnabled()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local humanoidRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRoot then
                local sounds = humanoidRoot:GetChildren()
                for _, sound in pairs(sounds) do
                    if sound:IsA("Sound") then
                        -- Example: when sound plays, create marker (can customize)
                        sound.Played:Connect(function()
                            print("Sound played by "..plr.Name)
                            -- You can add visual cues here (like a marker)
                        end)
                    end
                end
            end
        end
    end
end

local function onSoundEspDisabled()
    for _, conn in pairs(soundConnections) do
        conn:Disconnect()
    end
    soundConnections = {}
end

-- Update radar dots positions relative to local player
local function updateRadar()
    if not radarGui.Enabled then return end
    local localChar = LocalPlayer.Character
    if not localChar then return end
    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    
    for player, dot in pairs(dots) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local relativePos = (pos - localHRP.Position)
            local x = relativePos.X
            local z = relativePos.Z
            
            -- scale positions to fit radar (adjust scale factor)
            local scale = 0.1
            local radarX = 75 + (x * scale)
            local radarY = 75 + (z * scale)
            
            dot.Position = UDim2.new(0, radarX, 0, radarY)
            dot.Visible = true
        else
            dot.Visible = false
        end
    end
end

-- Hook toggles
left:AddToggle("In-Game radar", false, function(v)
    radarGui.Enabled = v
    
    if v then
        -- Create dots for each player
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not dots[player] then
                dots[player] = createDot(player)
            end
        end
        -- Start updating radar
        RunService.RenderStepped:Connect(updateRadar)
    else
        -- Hide all dots
        for _, dot in pairs(dots) do
            dot.Visible = false
        end
    end
end)

left:AddDropdown("Sound ESP", {"Disabled", "Enabled"}, 1, function(v)
    if v == "Enabled" then
        onSoundEspEnabled()
    else
        onSoundEspDisabled()
    end
end)

-- Update dots list when players join or leave
Players.PlayerAdded:Connect(function(player)
    if radarGui.Enabled and player ~= LocalPlayer and not dots[player] then
        dots[player] = createDot(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if dots[player] then
        dots[player]:Destroy()
        dots[player] = nil
    end
end)

left:AddToggle("Dormant", false, function(v)
    settings.Dormant = v
end)

left:AddToggle("Shared ESP", false, function(v)
    settings.SharedESP = v
end)

left:AddDropdown("Offscreen ESP", {"None", "Blinking Arrows"}, 2, function(v)
    settings.OffscreenESP = v
end)

left:AddToggle("Enable Glow", false, function(v)
    settings.GlowEnabled = v
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- State vars
local chamsEnabled = false
local throughWalls = false
local style = "Glass"

local backtrackEnabled = false
local backtrackStyle = "Textured"

local onShotEnabled = false
local onShotStyle = "Textured"

local ragdollsEnabled = false
local ragdollsStyle = "Glass"

-- Helper to create or update a highlight on a character
local function applyCham(character, enabled, thruWalls, style)
    if not character then return end
    local highlight = character:FindFirstChild("ChamHighlight")
    if enabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ChamHighlight"
            highlight.Parent = character
        end
        highlight.Enabled = true
        highlight.DepthMode = thruWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        
        if style == "Glass" then
            highlight.FillColor = Color3.fromRGB(0, 170, 255) -- bluish glass
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
            highlight.OutlineTransparency = 0.4
        elseif style == "Textured" then
            highlight.FillColor = Color3.fromRGB(0, 170, 255) -- solid blue
            highlight.FillTransparency = 0.2
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
        else
            -- fallback style
            highlight.FillColor = Color3.fromRGB(0, 170, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.3
        end
    else
        if highlight then
            highlight.Enabled = false
        end
    end
end

-- Track players to update highlights dynamically
local function updateAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            applyCham(player.Character, chamsEnabled, throughWalls, style)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        wait(0.5)
        if player ~= LocalPlayer then
            applyCham(char, chamsEnabled, throughWalls, style)
        end
    end)
end)

-- Your toggles hookup:
right:AddToggle("Enable Chams", false, function(v)
    chamsEnabled = v
    updateAllPlayers()
end)

right:AddToggle("Through Walls", false, function(v)
    throughWalls = v
    if chamsEnabled then
        updateAllPlayers()
    end
end)

right:AddDropdown("Style", {"Glass", "Textured"}, 1, function(v)
    style = v
    if chamsEnabled then
        updateAllPlayers()
    end
end)

right:AddToggle("Backtrack", false, function(v)

end)

right:AddDropdown("Style", {"Glass", "Textured"}, 2, function(v)

end)

right:AddToggle("On Shot", false, function(v)

end)

right:AddDropdown("Style", {"Glass", "Textured"}, 2, function(v)
    onShotStyle = v
end)

right:AddToggle("Ragdolls", false, function(v)

end)

right:AddDropdown("Style", {"Glass", "Textured"}, 1, function(v)
    ragdollsStyle = v
end)

local World = Window:AddTab("World", "earth")
local View = Window:AddTab("View", "ads")

-- Miscellaneous
Window:AddTabLabel("Miscellaneous")
local Main = Window:AddTab("Main", "list")
local Inventory = Window:AddTab("Inventory", "sword")
local Scripts = Window:AddTab("Scripts", "code")
-- Create Config Tab
local HttpService = game:GetService("HttpService")

-- Config storage table
local currentConfig = {}

-- ConfigTab + Section
local ConfigTab = Window:AddTab("Config", "gear")
local ConfigSection = ConfigTab:AddSection("Config Controls", "left")

-- Config list dropdown reference
local configDropdown
local selectedConfig = nil

-- Get available config names (JSON files only)
local function GetConfigList()
    local files = listfiles and listfiles("") or {}
    local configFiles = {}
    for _, file in pairs(files) do
        if file:match("%.json$") then
            table.insert(configFiles, file:match("([^/\\]+)%.json$"))
        end
    end
    table.sort(configFiles)
    return configFiles
end

-- Refresh dropdown options
local function RefreshDropdown()
    if configDropdown then
        local newList = GetConfigList()
        configDropdown:Clear()
        for _, name in ipairs(newList) do
            configDropdown:Add(name)
        end
    end
end

-- Create dropdown
configDropdown = ConfigSection:AddDropdown("Select Config", GetConfigList(), nil, function(val)
    selectedConfig = val
end)

-- Save config
ConfigSection:AddButton("💾 Save Config", function()
    if not selectedConfig or selectedConfig == "" then
        Notification:Notify("warning", "Config", "No config selected.")
        return
    end
    writefile(selectedConfig .. ".json", HttpService:JSONEncode(currentConfig))
    Notification:Notify("info", "Config", "Saved: " .. selectedConfig)
    RefreshDropdown()
end)

-- Load config
ConfigSection:AddButton("📂 Load Config", function()
    if not selectedConfig or not isfile(selectedConfig .. ".json") then
        Notification:Notify("error", "Config", "No config file found.")
        return
    end
    local data = readfile(selectedConfig .. ".json")
    local loaded = HttpService:JSONDecode(data)
    for k, v in pairs(loaded) do
        currentConfig[k] = v
    end

    -- Example: apply loaded values to UI
    if AimbotToggle then
        AimbotToggle:Set(currentConfig["Aimbot"] or false)
    end
    -- Add more Set() calls here for other UI elements you track

    Notification:Notify("info", "Config", "Loaded: " .. selectedConfig)
end)

-- Delete config
ConfigSection:AddButton("🗑️ Delete Config", function()
    if not selectedConfig or not isfile(selectedConfig .. ".json") then
        Notification:Notify("error", "Config", "No config to delete.")
        return
    end
    delfile(selectedConfig .. ".json")
    selectedConfig = nil
    Notification:Notify("warning", "Config", "Deleted config.")
    RefreshDropdown()
end)

-- Reset config
ConfigSection:AddButton("🔄 Reset Config", function()
    currentConfig = {}
    Notification:Notify("warning", "Config", "Config reset to default.")
end)

-- Ragebot Tab
local RageMain = Ragebot:AddSection("Main", "left")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Optional NPC Folder
local EnemiesFolder = workspace:FindFirstChild("Enemies")

--// Aimbot Toggle
local AimbotEnabled = false
RageMain:AddToggle("Enable Aimbot", false, function(val)
    AimbotEnabled = val
end)

--// Visibility Check
local function IsVisible(character)
    local origin = Camera.CFrame.Position
    local head = character:FindFirstChild("Head")
    if not head then return false end
    local direction = (head.Position - origin).Unit * (head.Position - origin).Magnitude
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        return result.Instance:IsDescendantOf(character)
    end
    return false
end

--// Target Validation
local function IsTargetValid(model)
    return model
        and model:FindFirstChild("Head")
        and model:FindFirstChild("Humanoid")
        and model.Humanoid.Health > 0
        and IsVisible(model)
end

--// Get Closest Target (Player or NPC)
local function GetClosestVisibleTarget()
    local closest = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    -- Check all players (except LocalPlayer)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsTargetValid(player.Character) then
            local screenPos, onScreen = Camera:WorldToScreenPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = player.Character
                end
            end
        end
    end

    -- Check NPCs if folder exists
    if EnemiesFolder then
        for _, npc in ipairs(EnemiesFolder:GetChildren()) do
            if IsTargetValid(npc) then
                local screenPos, onScreen = Camera:WorldToScreenPoint(npc.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = npc
                    end
                end
            end
        end
    end

    return closest
end

--// Main Aimbot Loop
local currentTarget = nil

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        if not IsTargetValid(currentTarget) then
            currentTarget = GetClosestVisibleTarget()
        end
        if IsTargetValid(currentTarget) then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, currentTarget.Head.Position)
        end
    else
        currentTarget = nil
    end
end)
local RageEnabled = true
local SelectedHitbox = "Head"
local HitchanceThreshold = 90
local MinDamageThreshold = 50
local SilentAimEnabled = true
local AutoShootEnabled = true
local AutoScopeEnabled = false
local ResolverEnabled = true
local AutoStopEnabled = true
local AutoCrouchEnabled = false
local BacktrackTicks = 80
local DynamicFOVEnabled = true
local DynamicFOVRange = 10
local CurrentFOV = 10

RageMain:AddToggle("Enable Ragebot", false, function(value) 
    RageEnabled = value
end)

RageMain:AddDropdown("Hitbox", {"Head","Body","Legs","Arms","All"}, 1, function(value) 
    SelectedHitbox = value
end)

RageMain:AddSlider("Hitchance", 0, 100, 90, function(value) 
    HitchanceThreshold = value
end)

RageMain:AddSlider("Minimum Damage", 0, 100, 50, function(value) 
    MinDamageThreshold = value
end)

RageMain:AddToggle("Silent Aim", false, function(value) 
    SilentAimEnabled = value
end)

RageMain:AddToggle("Auto Shoot", false, function(value) 
    AutoShootEnabled = value
end)

RageMain:AddToggle("Auto Scope", false, function(value) 
    AutoScopeEnabled = value
end)

RageMain:AddToggle("Resolver", false, function(value) 
    ResolverEnabled = value
end)

RageMain:AddButton("Reset Rage Settings", function() 
    RageEnabled = true
    SelectedHitbox = "Head"
    HitchanceThreshold = 90
    MinDamageThreshold = 50
    SilentAimEnabled = true
    AutoShootEnabled = true
    AutoScopeEnabled = false
    ResolverEnabled = true
    AutoStopEnabled = true
    AutoCrouchEnabled = false
    BacktrackTicks = 80
    DynamicFOVEnabled = true
    DynamicFOVRange = 10
    CurrentFOV = 10
    print("[Ragebot] All settings reset.")
end)

local RageAccuracy = Ragebot:AddSection("Accuracy", "right")

RageAccuracy:AddToggle("Auto Stop", false, function(value) 
    AutoStopEnabled = value
end)

RageAccuracy:AddToggle("Auto Crouch", false, function(value) 
    AutoCrouchEnabled = value
end)

RageAccuracy:AddSlider("Backtrack", 0, 200, 80, function(value) 
    BacktrackTicks = value
end)

RageAccuracy:AddToggle("Dynamic FOV", false, function(value) 
    DynamicFOVEnabled = value
end)

RageAccuracy:AddSlider("Dynamic FOV Range", 0, 30, 10, function(value) 
    DynamicFOVRange = value
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if not RageEnabled then return end

    -- FOV Logic
    if DynamicFOVEnabled then
        CurrentFOV = DynamicFOVRange
    end

    local Target = GetClosestTarget(SelectedHitbox, CurrentFOV)

    if Target then
        local Chance = math.random(0,100)
        if Chance <= HitchanceThreshold then
            AimAtTarget(Target, SelectedHitbox)

            if AutoShootEnabled then
                ShootTarget(Target)
            end
        end
    end
end)

function GetClosestTarget(hitbox, fov)
    local PlayerService = game:GetService("Players")
    local CurrentCamera = workspace.CurrentCamera
    local ClosestTarget = nil
    local ClosestDistance = math.huge

    for _, player in pairs(PlayerService:GetPlayers()) do
        if player ~= PlayerService.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local TargetPart = GetHitboxPart(player.Character, hitbox)
            if TargetPart then
                local screenPos, onscreen = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
                if onscreen then
                    local MouseLocation = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
                    local Distance = (MouseLocation - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if Distance < ClosestDistance and Distance <= fov then
                        ClosestDistance = Distance
                        ClosestTarget = player
                    end
                end
            end
        end
    end
    return ClosestTarget
end

function GetHitboxPart(character, hitbox)
    if hitbox == "All" then
        -- Returns the first available part
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                return part
            end
        end
    else
        return character:FindFirstChild(hitbox) or character:FindFirstChild("Head") 
    end
end

function AimAtTarget(target, hitbox)
    -- Placeholder for actual aim logic
    print("[Ragebot] Aiming at:", target.Name, "Hitbox:", hitbox, "Hitchance:", HitchanceThreshold .. "%", "FOV:", CurrentFOV)
end

function ShootTarget(target)
    -- Placeholder for actual shooting logic
    print("[Ragebot] Shooting at:", target.Name)
end

local hub = Scripts:AddSection('Hubs',"left")

hub:AddButton("Elvis's FE Scripts Collection", function()
loadstring(game:HttpGet("https://pastebin.com/raw/A0hBRbv6"))()
end)

hub:AddButton("c00lgui v2", function()
loadstring(game:HttpGet("https://pastebin.com/raw/14EU4i8n",true))()
end)

hub:AddButton("Ghost Hub", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
end)

hub:AddButton("c00lgui", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/SuperHackerYT/skibidi/refs/heads/main/Diddyfucker.lua'))()
end)

-- Anti Aim Tab
local AASettings = AntiAim:AddSection("Settings", "left")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI Settings (from toggles/dropdowns/sliders)
local AntiAimEnabled = false
local PitchSetting = "Up"
local YawSetting = "Sideways"
local YawModifierSetting = "Jitter"
local DesyncAmount = 60
local FakeLag = 10
local FakeFlickKey = Enum.KeyCode.F
local FakeFlickActive = false

-- Connect UI controls
AASettings:AddToggle("Enable Anti Aim", false, function(value)
    AntiAimEnabled = value
end)

AASettings:AddDropdown("Pitch", {"Up","Down","Jitter","None"}, 1, function(value)
    PitchSetting = value
end)

AASettings:AddDropdown("Yaw", {"Sideways","Spin","Backwards"}, 2, function(value)
    YawSetting = value
end)

AASettings:AddDropdown("Yaw Modifier", {"Jitter","Static"}, 1, function(value)
    YawModifierSetting = value
end)

AASettings:AddSlider("Desync Amount", 0, 100, 60, function(value)
    DesyncAmount = value
end)

AASettings:AddSlider("Fake Lag", 0, 20, 10, function(value)
    FakeLag = value
end)

AASettings:AddKeybind("Fake Flick Key", Enum.KeyCode.F, function(key)
    FakeFlickKey = key
end)

-- Fake Flick Activation
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == FakeFlickKey then
        FakeFlickActive = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == FakeFlickKey then
        FakeFlickActive = false
    end
end)

-- Anti-Aim Loop
RunService.RenderStepped:Connect(function(delta)
    if not AntiAimEnabled or not Character or not HumanoidRootPart then return end

    -- Pitch control
    local pitch = 0
    if PitchSetting == "Up" then
        pitch = -80
    elseif PitchSetting == "Down" then
        pitch = 80
    elseif PitchSetting == "Jitter" then
        pitch = math.random(-80, 80)
    end

    -- Yaw control
    local yaw = 0
    if YawSetting == "Sideways" then
        yaw = 90
    elseif YawSetting == "Backwards" then
        yaw = 180
    elseif YawSetting == "Spin" then
        yaw = tick() * 500 % 360
    end

    -- Yaw Modifier
    if YawModifierSetting == "Jitter" then
        yaw = yaw + math.random(-30, 30)
    end

    -- Fake Flick
    if FakeFlickActive then
        yaw = yaw + math.random(100, 200)
    end

    -- Desync logic (visual only in Roblox, not real networking)
    local desyncOffset = math.sin(tick() * 8) * (DesyncAmount / 100) * 10
    HumanoidRootPart.Rotation = Vector3.new(pitch, yaw + desyncOffset, 0)

    -- Fake Lag (basic)
    if math.floor(tick() * 1000) % FakeLag == 0 then
        -- Skip update simulating lag
        return
    end
end)

local AAMisc = AntiAim:AddSection("Misc", "right")
AAMisc:AddToggle("Edge AA", false, function() end)
AAMisc:AddToggle("Slow Walk", false, function() end)
AAMisc:AddSlider("Slow Walk Speed", 0, 50, 30, function() end)
AAMisc:AddToggle("Jitter Desync", true, function() end)

-- Legitbot Tab
local LegitMain = Legitbot:AddSection("Main", "left")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Settings
local legitSettings = {
    Enabled = false,
    Smoothness = 50,
    FOV = 5,
    RecoilControl = false,
    RecoilStrength = 80,
}

-- Helpers
local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < legitSettings.FOV * 10 and dist < shortestDistance then
                    shortestDistance = dist
                    closest = hrp
                end
            end
        end
    end
    return closest
end

-- Aimbot logic
local function aimAt(target)
    if not target then return end
    local targetPos = target.Position
    local camPos = Camera.CFrame.Position
    local direction = (targetPos - camPos).Unit
    local currentLook = Camera.CFrame.LookVector
    local smooth = math.clamp(legitSettings.Smoothness / 100, 0.01, 1)

    local lerpedDirection = currentLook:Lerp(direction, smooth)
    Camera.CFrame = CFrame.new(camPos, camPos + lerpedDirection)
end

-- Recoil control stub (expand depending on the game’s gun system)
local function applyRecoilControl()
    if legitSettings.RecoilControl then
        -- You'd hook into gun recoil system here (stub only)
        -- Example: Reduce camera recoil angle or modify recoil variables
    end
end

-- Main loop
RunService.RenderStepped:Connect(function()
    if legitSettings.Enabled then
        local target = getClosestTarget()
        aimAt(target)
        applyRecoilControl()
    end
end)

-- UI bindings
LegitMain:AddToggle("Enable Legitbot", false, function(v)
    legitSettings.Enabled = v
end)

LegitMain:AddSlider("Smoothness", 0, 100, 50, function(v)
    legitSettings.Smoothness = v
end)

LegitMain:AddSlider("FOV", 0, 30, 5, function(v)
    legitSettings.FOV = v
end)

LegitMain:AddToggle("Recoil Control", false, function(v)
    legitSettings.RecoilControl = v
end)

LegitMain:AddSlider("Recoil Strength", 0, 100, 80, function(v)
    legitSettings.RecoilStrength = v
end)

local LegitTrigger = Legitbot:AddSection("Triggerbot", "right")
LegitTrigger:AddToggle("Enable Triggerbot", false, function() end)
LegitTrigger:AddSlider("Trigger Delay", 0, 500, 150, function() end)
LegitTrigger:AddSlider("Burst Shots", 1, 5, 2, function() end)
LegitTrigger:AddKeybind("Trigger Key", Enum.KeyCode.X, function() end)

-- World Visuals
local WorldVisual = World:AddSection("World", "left")
-- Services
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer

-- INITIAL SETTINGS
local originalClockTime = lighting.ClockTime
local originalFogEnd = lighting.FogEnd
local originalFogStart = lighting.FogStart
local originalFogColor = lighting.FogColor

-- FUNCTION IMPLEMENTATION
local nightModeEnabled = false
local removeFogEnabled = false
local removeSmokeEnabled = false
local removeFlashbangEnabled = false

-- Night Mode
local function applyNightMode(enabled)
    if enabled then
        lighting.ClockTime = 2 -- Darker night setting
    else
        lighting.ClockTime = originalClockTime
    end
end

-- Remove Fog
local function applyRemoveFog(enabled)
    if enabled then
        lighting.FogEnd = 100000
        lighting.FogStart = 100000
        lighting.FogColor = Color3.fromRGB(255, 255, 255)
    else
        lighting.FogEnd = originalFogEnd
        lighting.FogStart = originalFogStart
        lighting.FogColor = originalFogColor
    end
end

-- Remove Smoke
local function applyRemoveSmoke(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") and v.Name:lower():find("smoke") then
            v.Enabled = not enabled
        end
    end
end

-- Remove Flashbang
local function applyRemoveFlashbang(enabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Light") and v.Name:lower():find("flash") then
            v.Enabled = not enabled
        end
    end
end

local xRayEnabled = false
local originalTransparency = {}

local function setXRay(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
                originalTransparency[obj] = obj.Transparency
                obj.Transparency = 0.7 -- see-through but still visible
            end
        end
    else
        for obj, trans in pairs(originalTransparency) do
            if obj and obj.Parent then
                obj.Transparency = trans
            end
        end
        originalTransparency = {}
    end
end

WorldVisual:AddToggle("X-Ray", false, function(value)
    xRayEnabled = value
    setXRay(value)
end)

workspace.DescendantAdded:Connect(function(obj)
    if xRayEnabled and obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
        originalTransparency[obj] = obj.Transparency
        obj.Transparency = 0.7
    end
end)

WorldVisual:AddToggle("Night Mode", false, function(value)
    nightModeEnabled = value
    applyNightMode(value)
end)

WorldVisual:AddToggle("Remove Fog", false, function(value)
    removeFogEnabled = value
    applyRemoveFog(value)
end)

WorldVisual:AddToggle("Remove Smoke", false, function(value)
    removeSmokeEnabled = value
    applyRemoveSmoke(value)
end)

WorldVisual:AddToggle("Remove Flashbang", false, function(value)
    removeFlashbangEnabled = value
    applyRemoveFlashbang(value)
end)

-- OPTIONAL: Maintain settings for new instances
runService.RenderStepped:Connect(function()
    if removeSmokeEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") and v.Name:lower():find("smoke") and v.Enabled then
                v.Enabled = false
            end
        end
    end
    if removeFlashbangEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Light") and v.Name:lower():find("flash") and v.Enabled then
                v.Enabled = false
            end
        end
    end
end)

-- View Tab
local ViewTab = View:AddSection("View", "left")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Your ViewModel, example: gun model or first-person arms
local ViewModel = workspace:FindFirstChild("Viewmodel") -- replace with actual viewmodel path

-- Default values
local viewmodelOffset = Vector3.new(0, 0, 0)

-- FOV SLIDER
ViewTab:AddSlider("FOV", 60, 140, 90, function(val)
	Camera.FieldOfView = val
end)

-- Viewmodel position sliders
ViewTab:AddSlider("Viewmodel X", -20, 20, 0, function(val)
	viewmodelOffset = Vector3.new(val, viewmodelOffset.Y, viewmodelOffset.Z)
end)

ViewTab:AddSlider("Viewmodel Y", -20, 20, 0, function(val)
	viewmodelOffset = Vector3.new(viewmodelOffset.X, val, viewmodelOffset.Z)
end)

ViewTab:AddSlider("Viewmodel Z", -20, 20, 0, function(val)
	viewmodelOffset = Vector3.new(viewmodelOffset.X, viewmodelOffset.Y, val)
end)

-- Update loop for viewmodel
RunService.RenderStepped:Connect(function()
	if ViewModel and ViewModel:IsA("Model") then
		local primary = ViewModel.PrimaryPart or ViewModel:FindFirstChildWhichIsA("BasePart")
		if primary then
			-- Offset viewmodel from camera
			ViewModel:SetPrimaryPartCFrame(Camera.CFrame * CFrame.new(viewmodelOffset))
		end
	end
end)

-- Main Tab (MISC like your image)
local Movement = Main:AddSection("Movement", "left")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local autoJump = false
local autoStrafe = false
local strafeSmoothness = 28
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Update character on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

Movement:AddToggle("Auto Jump", false, function(enabled)
    autoJump = enabled
end)

Movement:AddToggle("Auto Strafe", false, function(enabled) 
    autoStrafe = enabled
end)

Movement:AddSlider("Strafe Smoothing", 0, 100, 28, function(val)
    strafeSmoothness = val
end)

-- Movement loop
RunService.RenderStepped:Connect(function(dt)
    if not Character then return end

    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera

    if not humanoid or humanoid.Health <= 0 or not hrp or not cam then return end

    -- Auto Jump: only jump when touching ground (Running or Walking)
    if autoJump then
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Walking then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- Auto Strafe: apply lateral velocity based on camera right vector
    if autoStrafe then
        local camRight = cam.CFrame.RightVector
        local strafeForce = camRight * (strafeSmoothness / 5) -- tunable factor
        hrp.Velocity = Vector3.new(
            hrp.Velocity.X + strafeForce.X * dt * 60,
            hrp.Velocity.Y,
            hrp.Velocity.Z + strafeForce.Z * dt * 60
        )
    end
end)

Movement:AddToggle("WASD Strafe", false, function() end)
Movement:AddToggle("Circle Strafe", false, function() end)
Movement:AddToggle("Quick Stop", false, function() end)
Movement:AddToggle("Auto Peek", false, function() end)
Movement:AddToggle("Infinity Duck", false, function() end)

local Other = Main:AddSection("Other", "right")
Other:AddToggle("Anti Untrusted", false, function() end)
Other:AddDropdown("Event Log", {"Damage","Hurt","Spread","Miss"}, 1, function() end)
Other:AddDropdown("Windows", {"PlayerGui","Error"}, 1, function() end)
Other:AddToggle("Filter Ads", false, function() end)
Other:AddToggle("Unlock CVars", false, function() end)
Other:AddSlider("Fake Ping", 0, 1000, 45, function(val) end)

-- Inventory Tab
local InventorySection = Inventory:AddSection("Weapon Skins Changer", "left")
InventorySection:AddToggle("Enable Skin Changer", false, function() end)
InventorySection:AddButton("Weapons/Tools Giver",function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Game-tool-giver-12133"))()
end)
InventorySection:AddDropdown("Weapon", {"Not Found","Not Found","Not Found"}, 1, function() end)
InventorySection:AddDropdown("Skin", {"Not Found","Not Found","Not Found"}, 1, function() end)
	end)
