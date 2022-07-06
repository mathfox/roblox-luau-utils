export type RoactRenderer = {
	isHostObject: (target: any) -> boolean,
	mountHostNode: () -> (),
	unmountHostNode: () -> (),
	updateHostNode: () -> (),
}

return nil
