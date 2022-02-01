local findFirstDescendantOfClass = require(script.Parent.findFirstDescendantOfClass)

local function waitForDescendantOfClass(parent: Instance, className: string, timeOut: number?): Instance?
	local descendant = findFirstDescendantOfClass(parent, className)

	if descendant then
		return descendant
	elseif not timeOut then
		while not descendant or descendant.ClassName ~= className do
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
		if descendant.ClassName == className then
			resumeWaitingCoroutine(descendant)
		end
	end

	descendantAddedConnection = parent.DescendantAdded:Connect(onDescendantAdded)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForDescendantOfClass
