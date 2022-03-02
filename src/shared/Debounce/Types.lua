export type Debounce = {
	Invoke: (self: Debounce, ...any) -> ...any,
	invoke: (self: Debounce, ...any) -> ...any,
	Unbounce: (self: Debounce) -> (),
	unbounce: (self: Debounce) -> (),
	Destroy: (self: Debounce) -> (),
	destroy: (self: Debounce) -> (),
}

return {}
