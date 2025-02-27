local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Weapons = ReplicatedStorage.Weapons

for _, Weapon in ipairs(Weapons:GetChildren()) do
    if Weapon:IsA("Folder") and Weapon:FindFirstChild("Spread") then -- Added check for Folder and existence of Spread
        local Spread = Weapon:FindFirstChild("Spread")

        if Spread:IsA("NumberValue") then -- Check if Spread is a NumberValue
            Spread.Value = Spread.Value - 1 -- Decrement Spread value

            for _, SpreadChild in ipairs(Spread:GetChildren()) do -- Iterate over children of Spread
                if SpreadChild:IsA("NumberValue") then -- Check if child is a NumberValue
                    SpreadChild.Value = SpreadChild.Value - 1 -- Decrement child Spread value
                end
            end
        end
    end
end
