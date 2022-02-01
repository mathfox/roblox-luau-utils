local function waitForChildOfClass(parent: Instance, className: string, timeOut: number?): Instance?
	local child = parent:FindFirstChildOfClass(className)

	if child then
		return child
	elseif not timeOut then
		while not child or child.ClassName ~= className do
			child = parent.ChildAdded:Wait()
		end

		return child
	end

	local waitingCoroutine = coroutine.running()
	local childAddedConnection: RBXScriptConnection = nil

	local function resumeWaitingCoroutine(child: Instance)
		childAddedConnection:Disconnect()

		task.spawn(waitingCoroutine, child)
	end

	local function onChildAdded(child: Instance)
		if child.ClassName == className then
			resumeWaitingCoroutine(child)
		end
	end

	childAddedConnection = parent.ChildAdded:Connect(onChildAdded)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForChildOfClass
