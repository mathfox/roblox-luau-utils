return function()
	local TeamUtils = require(script.Parent)

	describe("areTeamMates", function()
		it("should not count neutral as teammate", function()
			expect(TeamUtils.areTeamMates({
				Neutral = true,
			}, {})).to.be.equal(false)
		end)

		it("should not count players with no team as teammate", function()
			expect(TeamUtils.areTeamMates({
				Neutral = false,
				Team = "Team1",
			}, {
				Neutral = false,
				Team = "Team2",
			})).to.be.equal(false)
		end)

		it("should count not neutral players with the same team:string as teammates", function()
			expect(TeamUtils.areTeamMates({
				Neutral = false,
				Team = "",
			}, {
				Neutral = false,
				Team = "",
			})).to.be.equal(true)
		end)
	end)
end
