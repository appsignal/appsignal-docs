---
title: "Span API"
---

Each method that modifies the `Span` returns `this`, allowing you to chain methods together:

```js
const span = tracer.currentSpan()

span
  .set("name", "value")
  .addError(new Error("test error"))
```

### `span.set(key: string, value: string | number | boolean)`

Sets arbitary data on a current `Span`. The data can be a `string`, `number` or `boolean` type.

### `span.setName(name: string)`

Sets the `name` of the current `Span`. Namespaces are a way to group error incidents, performance incidents, and host metrics in your app.

### `span.setSQL(value: string)`

Adds sanitized SQL data as a string to a `Span`.

he `value` will be applied to the `Span` as the body of a query made within the lifetime of the `Span`, which will show the sanitized query in your dashboard.

### `span.setCategory(category: string)`

Sets the category for a the `Span`. The category groups `Span`s together in the "Slow Events" feature, and in the "Sample breakdown".

### `span.addError(error: Error)`

Sets the `error` of the current `Span`. When an `Error` object is passed to the `setError` method, the `stack` property is normalised and transformed into an array of strings, with each string representing a line in the stacktrace.

### `span.setSampleData(key: string, data: Array<string | number | boolean> | { [key: string]: string | number | boolean })`

Adds sample data to the current `Span`. The sample data object must not contain any nested objects. This call accepts the following keys, some keys require a specific format.

### `span.close(endTime?: number)`

Closes the current `Span`.
