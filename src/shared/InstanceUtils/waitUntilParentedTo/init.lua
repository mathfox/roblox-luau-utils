-- Returns the `parent` argument in case it was parented to it in time.
local function waitUntilParentedTo(instance: Instance, parent: Instance?, timeout: number?)
	if instance.Parent == parent then
		return parent
	elseif not timeout then
		repeat
			instance.AncestryChanged:Wait()
		until instance.Parent == parent

		return parent
	else
		local waitingCoroutine = coroutine.running()
		local ancestryChangedConnection: RBXScriptConnection = nil

		local function resumeWaitingCoroutine(resultParent: Instance?)
			ancestryChangedConnection:Disconnect()

			task.spawn(waitingCoroutine, resultParent)
		end

		ancestryChangedConnection = instance.AncestryChanged:Connect(function()
			if instance.Parent == parent then
				resumeWaitingCoroutine(parent)
			end
		end)

		task.delay(timeout, resumeWaitingCoroutine, nil)

		return coroutine.yield()
	end
end

return waitUntilParentedTo
