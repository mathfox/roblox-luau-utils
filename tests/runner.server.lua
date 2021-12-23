local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TestService = game:GetService("TestService")

local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ"))

TestEZ.TestBootstrap:run({ StarterPlayer, ReplicatedStorage, ServerStorage }, {
	report = function(results)
		for _, message in ipairs(results.errors) do
			TestService:Error(message)
			print("")
		end
	end,
})
