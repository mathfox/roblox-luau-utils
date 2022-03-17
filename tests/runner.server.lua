local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ"))

TestEZ.TestBootstrap:run({ game:GetService("StarterPlayer"), ReplicatedStorage, game:GetService("ServerStorage") }, {
	report = function(results)
		for _, message in ipairs(results.errors) do
			TestService:Error(message)
			print("")
		end
	end,
})
