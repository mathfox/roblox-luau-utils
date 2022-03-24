export type Debounce = {
	type: { Once: userdata, Time: userdata },

	Invoke: (self: Debounce, ...any) -> ...any,
	Unbounce: (self: Debounce) -> (),
	Destroy: (self: Debounce) -> (),

	invoke: (self: Debounce, ...any) -> ...any,
	unbounce: (self: Debounce) -> (),
	destroy: (self: Debounce) -> (),
}

return nil
