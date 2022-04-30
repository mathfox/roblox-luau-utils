return function()
	local ElementKind = require(script.Parent.Parent.ElementKind)
	local Type = require(script.Parent.Parent.Type)

	local createFragment = require(script.Parent)

	it("should create new primitive elements", function()
		local fragment = createFragment({})

		expect(fragment).to.be.ok()
		expect(Type.of(fragment)).to.equal(Type.Element)
		expect(ElementKind.of(fragment)).to.equal(ElementKind.Fragment)
	end)

	it("should accept children", function()
		local subFragment = createFragment({})
		local fragment = createFragment({ key = subFragment })

		expect(fragment.elements.key).to.equal(subFragment)
	end)
end
