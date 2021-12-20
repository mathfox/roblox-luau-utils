return function()
	local CharacterUtils = require(script.Parent)
	local Signal = require(script.Parent.Parent.Signal)

	local player = {
		Character = Instance.new("Model"),
	}
	local humanoid = Instance.new("Humanoid", player.Character)

	beforeEach(function()
		humanoid.Health = humanoid.MaxHealth
	end)

	describe("getPlayerHumanoid", function()
		local getPlayerHumanoid = CharacterUtils.getPlayerHumanoid

		it("should return player humanoid", function()
			expect(getPlayerHumanoid(player)).to.be.equal(humanoid)
		end)

		it("should return nil when wrong type of value provided", function()
			expect(getPlayerHumanoid({})).to.be.equal(nil)
		end)

		it("should error when no table or Player objects provided", function()
			expect(function()
				getPlayerHumanoid()
			end).to.throw()
		end)
	end)

	describe("getAlivePlayerHumanoid", function()
		local getAlivePlayerHumanoid = CharacterUtils.getAlivePlayerHumanoid

		it("should return alive humanoid", function()
			expect(getAlivePlayerHumanoid(player)).to.be.equal(humanoid)
		end)

		it("should not return dead humanoid", function()
			humanoid.Health = 0
			expect(getAlivePlayerHumanoid(player)).to.be.equal(nil)
		end)

		it("should error when no .Character field provided", function()
			expect(function()
				getAlivePlayerHumanoid(math.huge)
			end).to.throw()
		end)
	end)

	local rootPart = Instance.new("Part", player.Character)
	rootPart.Name = "HumanoidRootPart"

	describe("getPlayerRootPart", function()
		local getPlayerRootPart = CharacterUtils.getPlayerRootPart

		it("should return valid root part", function()
			expect(getPlayerRootPart(player)).to.be.equal(rootPart)
		end)

		it("should error when no .Character field provided", function()
			expect(function()
				getPlayerRootPart(math.huge)
			end).to.throw()
		end)
	end)

	describe("getAlivePlayerRootPart", function()
		local getAlivePlayerRootPart = CharacterUtils.getAlivePlayerRootPart

		it("should return root part of alive humanoid", function()
			expect(getAlivePlayerRootPart(player)).to.be.equal(rootPart)
		end)

		it("should not return root part of dead humanoid", function()
			humanoid.Health = 0
			expect(getAlivePlayerRootPart(player)).to.be.equal(nil)
		end)

		it("should error when no .Character field provided", function()
			expect(function()
				getAlivePlayerRootPart(math.huge)
			end).to.throw()
		end)
	end)

	describe("waitForPlayerCharacter", function()
		local waitForPlayerCharacter = CharacterUtils.waitForPlayerCharacter

		it("should return existing character", function()
			expect(waitForPlayerCharacter(player)).to.be.equal(player.Character)
		end)

		local player = {
			CharacterAdded = Signal.new(),
		}

		it("should wait for new character", function()
			task.defer(player.CharacterAdded.Fire, player.CharacterAdded, "char")
			expect(waitForPlayerCharacter(player)).to.be.equal("char")
		end)
	end)
end
