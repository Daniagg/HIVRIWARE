local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local ASTOLFO_THEME = {
    MainBackground = Color3.fromRGB(255, 215, 238),  
    SecondaryBackground = Color3.fromRGB(215, 238, 255),  
    TextColor = Color3.fromRGB(80, 60, 110),  
    AccentColor = Color3.fromRGB(255, 175, 215),
    HighlightColor = Color3.fromRGB(185, 220, 255),
    ScrollBarColor = Color3.fromRGB(255, 195, 225)  
}

local function applyAstolfoTheme(object)
    if object:IsA("Frame") or object:IsA("ScrollingFrame") then
        object.BackgroundColor3 = ASTOLFO_THEME.MainBackground

        
        TweenService:Create(object, TweenInfo.new(0.5), {
            BackgroundColor3 = ASTOLFO_THEME.MainBackground,
        }):Play()
        
    elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        object.TextColor3 = ASTOLFO_THEME.TextColor
        object.BackgroundColor3 = ASTOLFO_THEME.SecondaryBackground
        object.BackgroundTransparency = 1
        
    elseif object:IsA("ImageButton") then
        object.BackgroundColor3 = ASTOLFO_THEME.AccentColor
        object.BackgroundTransparency = 1
        
    elseif object:IsA("UIStroke") then
        object.Color = ASTOLFO_THEME.HighlightColor
        
    elseif object:IsA("UIGradient") then
        object.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 230)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 230, 255))
        })
        object.Transparency = NumberSequence.new(1)
    end
end

local function themeDescendants(parent)
    for _, child in ipairs(parent:GetDescendants()) do
        applyAstolfoTheme(child)
    end
end

for _, guiObject in ipairs(CoreGui:GetChildren()) do
    themeDescendants(guiObject)
end

CoreGui.ChildAdded:Connect(function(newChild)
    task.wait(0.1)
    themeDescendants(newChild)
end)

local sampleFrame = Instance.new("Frame")
sampleFrame.Size = UDim2.new(0, 200, 0, 100)
sampleFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
sampleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
sampleFrame.Parent = CoreGui

local sampleText = Instance.new("TextLabel")
sampleText.Text = "Astolfo Theme!"
sampleText.Size = UDim2.new(1, 0, 1, 0)
sampleText.BackgroundTransparency = 0.9
sampleText.Parent = sampleFrame
