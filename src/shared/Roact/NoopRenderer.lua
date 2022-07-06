--[[
	Reference renderer intended for use in tests as well as for documenting the
	minimum required interface for a Roact renderer.
]]

local NoopRenderer = {}

function NoopRenderer.isHostObject(target)
	-- Attempting to use NoopRenderer to target a Roblox instance is almost
	-- certainly a mistake.
	return target == nil
end

function NoopRenderer.mountHostNode() end

function NoopRenderer.unmountHostNode() end

function NoopRenderer.updateHostNode(_, node)
	return node
end

return NoopRenderer
