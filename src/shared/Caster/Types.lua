export type CanPierceFunction = (ActiveCast, RaycastResult, Vector3) -> boolean
export type Caster = {
	worldRoot: WorldRoot,
	LengthChanged: RBXScriptSignal,
	RayHit: RBXScriptSignal,
	RayPierced: RBXScriptSignal,
	CastTerminating: RBXScriptSignal,
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
	autoIgnoreContainer: boolean,
	canPierceFunction: CanPierceFunction,
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
}
export type CastRayInfo = {
	raycastParams: RaycastParams,
	worldRoot: WorldRoot,
	maxDistance: number,
	cosmeticBulletObject: Instance?,
	canPierceCallback: CanPierceFunction,
}
export type ActiveCast = {
	caster: Caster,
	stateInfo: CastStateInfo,
	rayInfo: CastRayInfo,
	userData: { [any]: any },
}

return {}
