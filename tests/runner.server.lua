local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.TestEZ).TestBootstrap:run({
	game:GetService("StarterPlayer"),
	ReplicatedStorage,
	game:GetService("ServerStorage"),
})
