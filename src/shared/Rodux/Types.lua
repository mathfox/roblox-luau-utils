export type Store = {
	getState: (self: Store) -> {},
	dispatch: (self: Store, action: any) -> (),
	flush: (self: Store) -> (),
	destruct: (self: Store) -> (),
}

export type Action = { type: string }
export type State = {}

export type Reducer = (state: State, action: Action) -> State

export type ActionCreator = { name: string } & (kek: string) -> number

return nil