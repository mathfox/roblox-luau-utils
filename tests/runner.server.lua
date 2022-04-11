local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ"))

TestEZ.TestBootstrap:run({ game:GetService("StarterPlayer"), ReplicatedStorage, game:GetService("ServerStorage") })
