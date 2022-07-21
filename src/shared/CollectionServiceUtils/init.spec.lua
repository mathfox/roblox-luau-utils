return function()
	local CollectionServiceUtils = require(script.Parent)

	it("should be a table", function()
		expect(CollectionServiceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(CollectionServiceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			CollectionServiceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(CollectionServiceUtils, {})
		end).to.throw()
	end)

	it("should expose only known apis", function()
		local APIS = {
			findFirstAncestorOfTag = "function",
			hasTags = "function",
			removeAllTags = "function",
		}

		for key, value in CollectionServiceUtils do
			assert(APIS[key] ~= nil)
			assert(type(value) == APIS[key])
		end
	end)
end
