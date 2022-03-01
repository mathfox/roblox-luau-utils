export type Option = {
	match: (self: Option, matches: OptionMatches) -> any,
	isSome: (self: Option) -> boolean,
	isNone: (self: Option) -> boolean,
	expect: (self: Option, createMessage: () -> string) -> any,
	expectNone: (self: Option, createMessage: () -> string) -> (),
	unwrap: (self: Option, default: any | () -> any) -> any,
	intersect: (self: Option, option: Option) -> Option,
	union: (self: Option, option: Option) -> Option,
	extend: (self: Option, modifier: (any) -> Option) -> Option,
	filter: (self: Option, predicate: (any) -> boolean) -> Option,
	contains: (self: Option, value: any) -> boolean,
}

export type OptionMatches = { onSome: (v: any) -> (), onNone: () -> () }

return {}
