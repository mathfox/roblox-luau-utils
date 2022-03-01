local SignalTypes = require(script.Parent.Parent.Signal.Types)

export type Caster = {
	worldRoot: WorldRoot,
	LengthChanged: SignalTypes.Signal,
	RayHit: SignalTypes.Signal,
	RayPierced: SignalTypes.Signal,
	RayOutranged: SignalTypes.Signal,
	CastTerminating: SignalTypes.Signal,
	fire: (Vector3, Vector3, Vector3 | number, CasterBehavior) -> (),
}

export type CasterBehavior = {
	raycastParams: RaycastParams?,
	maxDistance: number,
	acceleration: Vector3,
	highFidelityBehavior: number,
	highFidelitySegmentSize: number,
	cosmeticBulletTemplate: Instance?,
	cosmeticBulletProvider: any,
	cosmeticBulletContainer: Instance?,
	canPierceFunction: (Cast, RaycastResult, Vector3) -> boolean,
}

export type CastTrajectory = {
	startTime: number,
	endTime: number,
	origin: Vector3,
	initialVelocity: Vector3,
	acceleration: Vector3,
}

export type CastStateInfo = {
	updateConnection: RBXScriptConnection,
	highFidelityBehavior: number,
	highFidelitySegmentSize: number,
	paused: boolean,
	totalRuntime: number,
	distanceCovered: number,
	isActivelySimulatingPierce: boolean,
	isActivelyResimulating: boolean,
	cancelHighResCast: boolean,
	trajectories: { CastTrajectory },
	latestTrajectory: CastTrajectory,
}

export type CastRayInfo = {
	raycastParams: RaycastParams,
	worldRoot: WorldRoot,
	maxDistance: number,
	cosmeticBulletObject: Instance?,
}

export type Cast = {
	caster: Caster,
	stateInfo: CastStateInfo,
	rayInfo: CastRayInfo,
	behavior: CasterBehavior,
	userData: { [any]: any },
}

return {}
