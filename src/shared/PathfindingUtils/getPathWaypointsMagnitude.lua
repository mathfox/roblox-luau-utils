export type PathWaypoints = { PathWaypoint }

-- returns a total magnitude between waypoints, returns math.huge if waypoins table is empty
local function getPathWaypointsMagnitude(waypoints: PathWaypoints): number
	local magnitude: number = 0

	local firstWaypoint: PathWaypoint? = waypoints[1]
	if not firstWaypoint then
		return math.huge
	end

	local previousPosition: Vector3 = firstWaypoint.Position

	-- skip initial waypoint as its magnitude will always be 0
	for index = 2, #waypoints do
		local waypointPosition: Vector3 = waypoints[index].Position

		-- increment total path waypoints length (magnitude)
		magnitude += (previousPosition - waypointPosition).Magnitude

		previousPosition = waypointPosition
	end

	return magnitude
end

return getPathWaypointsMagnitude
