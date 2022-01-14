--[[
	Written by Eti the Spirit (18406183)

		The latest patch notes can be located here (and do note, the version at the top of this script might be outdated. I have a thing for forgetting to change it):
		>	https://etithespirit.github.io/FastCastAPIDocs/changelog

	Remember -- A "Caster" represents an entire gun (or whatever is launching your projectiles), *NOT* the individual bullets.
	Make the caster once, then use the caster to fire your bullets. Do not make a caster for each bullet.
--]]

local ActiveCast = require(script.ActiveCast)
local Signal = require(script.Parent.Signal)
local Types = require(script.Types)

local Caster = {}
Caster.Behavior = {}
Caster.__index = Caster

Caster.HighFidelityBehavior = {
	Default = 1,
	Always = 3,
}

-- Tell the ActiveCast factory module what Caster actually *is*
ActiveCast.setCasterReference(Caster)

function Caster.new()
	local self = setmetatable({
		LengthChanged = Signal.new(),
		RayHit = Signal.new(),
		RayPierced = Signal.new(),
		CastTerminating = Signal.new(),
		WorldRoot = workspace,
	}, Caster)

	return self
end

-- Create a new ray info object.
-- This is just a utility alias with some extra type checking.
function Caster.Behavior.new(): Types.CasterBehavior
	return {
		RaycastParams = nil,
		Acceleration = Vector3.zero,
		MaxDistance = 1000,
		CanPierceFunction = nil,
		HighFidelityBehavior = Caster.HighFidelityBehavior.Default,
		HighFidelitySegmentSize = 0.5,
		CosmeticBulletTemplate = nil,
		CosmeticBulletProvider = nil,
		CosmeticBulletContainer = nil,
		AutoIgnoreContainer = true,
	}
end

local DEFAULT_CASTER_BEHAVIOR = Caster.Behavior.new()

function Caster:Fire(
	origin: Vector3,
	direction: Vector3,
	velocity: Vector3 | number,
	casterBehavior: Types.CasterBehavior?
): Types.ActiveCast
	local cast = ActiveCast.new(self, origin, direction, velocity, casterBehavior or DEFAULT_CASTER_BEHAVIOR)

	cast.RayInfo.WorldRoot = self.WorldRoot

	return cast
end

Caster.fire = Caster.Fire

return Caster
