local findFirstDescendantWhichIsA = require(script.Parent.findFirstDescendantWhichIsA)

local function waitForDescendantWhichIsA(parent: Instance, className: string, timeOut: number?)
	local descendant = findFirstDescendantWhichIsA(parent, className)

	if descendant then
		return descendant
	elseif not timeOut then
		repeat
			descendant = parent.DescendantAdded:Wait()
		until descendant and descendant:IsA(className)

		return descendant
	end

	local waitingCoroutine = coroutine.running()
	local descendantAddedConnection: RBXScriptConnection = nil

	local function resumeWaitingCoroutine(descendant: Instance?)
		descendantAddedConnection:Disconnect()

		task.spawn(waitingCoroutine, descendant)
	end

	descendantAddedConnection = parent.DescendantAdded:Connect(function(descendant)
		if descendant:IsA(className) then
			resumeWaitingCoroutine(descendant)
		end
	end)

	-- resume waiting coroutine with nil
	task.delay(timeOut, resumeWaitingCoroutine, nil)

	return coroutine.yield()
end

return waitForDescendantWhichIsA
