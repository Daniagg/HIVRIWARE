local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanIndicatorsUI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local LEFT_INDICATOR_STYLE = {
    Size = UDim2.new(0.067, 0, 0.033, 0),
    PositionX = 0.015,
    PositionY = {0.05, 0.09, 0.13},
    BGColor = Color3.fromRGB(28, 28, 38),
    BGTransparency = 0.35,
    TextColor = Color3.fromRGB(220, 220, 255),
    Font = Enum.Font.GothamSemibold,
    TextSize = 17,
    CornerRadius = 0.35,
    StrokeColor = Color3.fromRGB(60, 60, 80),
    StrokeThickness = 1
}

local RIGHT_INDICATOR_STYLE = {
    Size = UDim2.new(0.09, 0, 0.038, 0),
    PositionX = 0.5,
    PositionY = {0.88, 0.923},
    BGColor = Color3.fromRGB(28, 28, 38),
    BGTransparency = 0.35,
    TextColor = Color3.fromRGB(220, 220, 255),
    Font = Enum.Font.GothamSemibold,
    TextSize = 17,
    CornerRadius = 0.35,
    StrokeColor = Color3.fromRGB(60, 60, 80),
    StrokeThickness = 1
}

local function createIndicator(name, positionIndex, isLeft)
    local style = isLeft and LEFT_INDICATOR_STYLE or RIGHT_INDICATOR_STYLE
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = style.Size
    frame.Position = UDim2.new(style.PositionX, 0, style.PositionY[positionIndex], 0)
    frame.AnchorPoint = Vector2.new(isLeft and 0 or 0.5, 0)
    frame.BackgroundColor3 = style.BGColor
    frame.BackgroundTransparency = style.BGTransparency
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(style.CornerRadius, 0)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = style.StrokeColor
    stroke.Thickness = style.StrokeThickness
    stroke.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name .. ": 0"
    textLabel.TextColor3 = style.TextColor
    textLabel.Font = style.Font
    textLabel.TextSize = style.TextSize
    textLabel.TextXAlignment = isLeft and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame

    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    return textLabel
end

local indicators = {
    FPS = createIndicator("FPS", 1, true),
    Ping = createIndicator("PING", 2, true),
    Time = createIndicator("TIME", 3, true),
    Speed = createIndicator("SPEED", 1, false),
    Health = createIndicator("HEALTH", 2, false)
}

local character, humanoid
local function setupCharacter(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    humanoid.HealthChanged:Connect(function()
        if humanoid.Health > 0 then
            indicators.Health.Text = "HEALTH: "..math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
        else
            indicators.Health.Text = "HEALTH: DEAD"
        end
    end)
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

local lastSpeedUpdate = 0
local function updateSpeed()
    if not character or not humanoid or not humanoid.RootPart then 
        indicators.Speed.Text = "SPEED: 0 stud/s"
        return 
    end
    
    local now = tick()
    if now - lastSpeedUpdate < 0.1 then return end
    lastSpeedUpdate = now
    
    local velocity = humanoid.RootPart.Velocity
    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    indicators.Speed.Text = "SPEED: "..math.floor(speed).." stud/s"
end

local lastFPSUpdate = 0
local frameCount = 0
local function updateFPS()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastFPSUpdate >= 0.5 then
        local fps = math.floor(frameCount / (now - lastFPSUpdate))
        frameCount = 0
        lastFPSUpdate = now
        indicators.FPS.Text = "FPS: "..fps
    end
end

local lastPingUpdate = 0
local function updatePing()
    local now = tick()
    if now - lastPingUpdate < 1 then return end
    lastPingUpdate = now
    
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    indicators.Ping.Text = "PING: "..ping.."ms"
end

local function updateTime()
    local minutes = math.floor(workspace.DistributedGameTime/60)
    local seconds = math.floor(workspace.DistributedGameTime%60)
    indicators.Time.Text = "PLAYTIME: "..string.format("%02d:%02d", minutes, seconds)
end

RunService.Heartbeat:Connect(function()
    updateSpeed()
    updateFPS()
    updatePing()
    updateTime()
end)


for _, indicator in pairs(screenGui:GetChildren()) do
    if indicator:IsA("Frame") then
        local originalBgTrans = indicator.BackgroundTransparency
        local originalStrokeTrans = indicator.UIStroke.Transparency
        
        indicator.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                indicator,
                TweenInfo.new(0.25),
                {BackgroundTransparency = originalBgTrans - 0.15}
            ):Play()
            game:GetService("TweenService"):Create(
                indicator.UIStroke,
                TweenInfo.new(0.25),
                {Transparency = 0}
            ):Play()
        end)
        
        indicator.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                indicator,
                TweenInfo.new(0.25),
                {BackgroundTransparency = originalBgTrans}
            ):Play()
            game:GetService("TweenService"):Create(
                indicator.UIStroke,
                TweenInfo.new(0.25),
                {Transparency = originalStrokeTrans}
            ):Play()
        end)
    end
end
