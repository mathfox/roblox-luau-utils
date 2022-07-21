return function()
	local CollectionService = game:GetService("CollectionService")

	local findFirstAncestorOfTag = require(script.Parent)

	it("should be a function", function()
		expect(findFirstAncestorOfTag).to.be.a("function")
	end)

	it("should return proper ancestor containing passed tag", function()
		local tag = "__testing_tag_name"
		local folder_1 = Instance.new("Folder")

		CollectionService:AddTag(folder_1, tag)

		local folder_2 = Instance.new("Folder", folder_1)

		expect(findFirstAncestorOfTag(folder_2, tag)).to.equal(folder_1)

		local folder_3 = Instance.new("Folder", folder_2)

		expect(findFirstAncestorOfTag(folder_3, tag)).to.equal(folder_1)

		CollectionService:RemoveTag(folder_1, tag)

		expect(findFirstAncestorOfTag(folder_2, tag)).to.equal(nil)
		expect(findFirstAncestorOfTag(folder_3, tag)).to.equal(nil)

		folder_1:Destroy()
	end)
end
