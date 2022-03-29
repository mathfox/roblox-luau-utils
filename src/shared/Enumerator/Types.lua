export type EnumeratorItem<V, K> = { name: K, type: Enumerator<V, K>, value: V }

export type Enumerator<V, K> = {
	fromRawValue: (rawValue: V) -> EnumeratorItem<V, K>?,
	isEnumValue: (value: any) -> boolean,
	cast: (value: any) -> (EnumeratorItem<V, K> | boolean, string?),
	getEnumeratorItems: () -> { EnumeratorItem<V, K> },
}

return nil
