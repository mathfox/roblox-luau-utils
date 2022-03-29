export type EnumeratorItem<V, K> = { name: K, type: Enumerator<V, K>, value: V }

export type Enumerator<V, K> = {
	fromRawValue: (rawValue: V) -> EnumeratorItem<V, K>?,
	isEnumeratorItem: (value: any) -> boolean,
	getEnumeratorItems: () -> { EnumeratorItem<V, K> },
}

return nil
