local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Weapons = ReplicatedStorage.Weapons

for _, Weapon in ipairs(Weapons:GetChildren()) do
    if Weapon:IsA("Folder") and Weapon:FindFirstChild("Spread") then 
        local Spread = Weapon:FindFirstChild("Spread")

        if Spread:IsA("NumberValue") then 
            Spread.Value = Spread.Value - 1 

            for _, SpreadChild in ipairs(Spread:GetChildren()) do 
                if SpreadChild:IsA("NumberValue") then 
                    SpreadChild.Value = SpreadChild.Value - 1 
                end
            end
        end
    end
end
