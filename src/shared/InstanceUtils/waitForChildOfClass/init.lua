local function waitForChildOfClass(parent: Instance, className: string, timeOut: number?)
	local child = parent:FindFirstChildOfClass(className)

	if child then
		return child
	elseif not timeOut then
		repeat
			child = parent.ChildAdded:Wait()
		until child.ClassName == className

		return child
	end

	local waitingCoroutine = coroutine.running()
	local childAddedConnection: RBXScriptConnection = nil

	local function resumeWaitingCoroutine(child: Instance?)
		childAddedConnection:Disconnect()

		task.spawn(waitingCoroutine, child)
	end

	childAddedConnection = parent.ChildAdded:Connect(function(child)
		if child.ClassName == className then
			resumeWaitingCoroutine(child)
		end
	end)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForChildOfClass
