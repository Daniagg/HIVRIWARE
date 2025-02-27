

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Weapons = ReplicatedStorage.Weapons

for _, Weapon in ipairs(Weapons:GetChildren()) do
                    if Weapon:FindFirstChild("Spread") then
                        Weapon:FindFirstChild("Spread").Value -= 1
                        for _, Spread in ipairs(Weapon:FindFirstChild("Spread"):GetChildren()) do
                            Spread.Value -= 1
                        end
                    end 
                end
