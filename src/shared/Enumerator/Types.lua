export type EnumeratorItem<V> = { name: string, type: Enumerator<V>, value: V }

export type Enumerator<V> = {
	fromRawValue: (rawValue: V) -> EnumeratorItem<V>?,
	isEnumeratorItem: (value: any) -> boolean,
	getEnumeratorItems: () -> { EnumeratorItem<V> },
}

return nil
