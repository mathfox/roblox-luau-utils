local function waitForChildWhichIsA(parent: Instance, className: string, timeOut: number?): Instance?
	local child = parent:FindFirstChildWhichIsA(className)

	if child then
		return child
	elseif not timeOut then
		while not child or not child:IsA(className) do
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
		if child:IsA(className) then
			resumeWaitingCoroutine(child)
		end
	end

	childAddedConnection = parent.ChildAdded:Connect(onChildAdded)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForChildWhichIsA
