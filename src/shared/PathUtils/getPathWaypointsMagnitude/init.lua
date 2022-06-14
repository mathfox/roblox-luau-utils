local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

-- Returns a total magnitude between waypoints.
local function getPathWaypointsMagnitude(waypoints: Array<PathWaypoint>)
	local previousPosition, magnitude = waypoints[1].Position, 0

	-- skip initial waypoint as its magnitude will always be 0
	for index = 2, #waypoints do
		local waypointPosition = waypoints[index].Position

		-- increment total path waypoints length (magnitude)
		magnitude += (previousPosition - waypointPosition).Magnitude

		previousPosition = waypointPosition
	end

	return magnitude
end

return getPathWaypointsMagnitude
