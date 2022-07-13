return function()
	local GlobalConfig = require(script.Parent.Parent.Parent.Roact.GlobalConfig)
	local Roact = require(script.Parent.Parent.Parent.Roact)
	local Rodux = require(script.Parent.Parent.Parent.Rodux)

	local StoreProvider = require(script.Parent)

	it("should be instantiable as a component", function()
		local store = Rodux.createStore(function()
			return 0
		end)
		local element = Roact.createElement(StoreProvider, {
			store = store,
		})

		expect(element).to.be.ok()

		local handle = Roact.mount(element, nil, "StoreProvider-test")

		Roact.unmount(handle)
		store:destruct()
	end)

	it("should expect a 'store' prop", function()
		local element = Roact.createElement(StoreProvider)

		GlobalConfig.set({ propValidation = true })

		expect(function()
			Roact.mount(element)
		end).to.throw()
	end)

	it("should accept a single child", function()
		local store = Rodux.createStore(function()
			return 0
		end)

		local folder = Instance.new("Folder")

		local element = Roact.createElement(StoreProvider, {
			store = store,
		}, {
			test1 = Roact.createElement("Frame"),
		})

		expect(element).to.be.ok()

		local handle = Roact.mount(element, folder, "StoreProvider-test")

		local storeProviderChild = folder:FindFirstChild("StoreProvider-test", true)
		expect(storeProviderChild).to.be.ok()
		expect(storeProviderChild:IsA("Frame")).to.equal(true)

		Roact.unmount(handle)
		store:destruct()
	end)
end
