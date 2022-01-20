local findFirstDescendantWhichIsA = require(script.Parent.findFirstDescendantWhichIsA)

local function waitForDescendantWhichIsA(parent: Instance, className: string, timeOut: number?): Instance?
	if not timeOut then
		local descendant = findFirstDescendantWhichIsA(parent, className)

		while not descendant or not descendant:IsA(className) do
			descendant = parent.DescendantAdded:Wait()
		end

		return descendant
	end

	local waitingCoroutine = coroutine.running()
	local descendantAddedConnection: RBXScriptConnection = nil

	local function resumeWaitingCoroutine(descendant: Instance)
		descendantAddedConnection:Disconnect()

		task.spawn(waitingCoroutine, descendant)
	end

	local function onDescendantAdded(descendant: Instance)
		if descendant:IsA(className) then
			resumeWaitingCoroutine(descendant)
		end
	end

	descendantAddedConnection = parent.DescendantAdded:Connect(onDescendantAdded)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForDescendantWhichIsA