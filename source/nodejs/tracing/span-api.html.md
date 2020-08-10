---
title: "Span API"
---

A `Span` can be created by calling `tracer.createSpan()`, which initializes a new `Span` object.

```js
const span = tracer.createSpan();
```

When a `Span` is created, it is not bound to any _scope_. This means it cannot be recalled again from a different place in your app without first being given a _scope_. See [this page](scopes.html) for more details.

The `tracer.createSpan()` method takes two optional arguments. The first optional argument is an object of options to be passed to the Span at creation time. All properties on this object are also optional.

```js
{
  namespace: "custom-namespace", // a custom namespace for this span (defaults to `web`)
  startTime: 1597059277          // a custom start time for this span. defaults to the current time. value must be a valid 64-bit integer representing a valid UNIX time.
}
```

The `tracer.createSpan()` method also takes an optional second argument. If a `Span` is passed as the optional second argument, then the returned `Span` will be a `ChildSpan`. If a `SpanContext` is passed as the optional second argument, then the returned `Span` will be a `ChildSpan`.

```js
const span = tracer.currentSpan();

span.set("name", "value").addError(new Error("test error"));
```

Once created, the `Span` object exposes a number of methods:

### `span.set(key: string, value: string | number | boolean)`

Sets arbitrary data on a current `Span`. The data can be a `string`, `number` or `boolean` type.

### `span.setName(name: string)`

Sets the `name` of the current `Span`. Namespaces are a way to group error incidents, performance incidents, and host metrics in your app.

### `span.setCategory(category: string)`

Sets the category for a given Span. The category groups Spans together in the "Slow Events" feature, and in the "Sample breakdown".

### `span.setSQL(value: string)`

Adds sanitized SQL data as a string to a `Span`.

The `value` will be applied to the `Span` as the body of a query made within the lifetime of the `Span`, which will show the sanitized query in your dashboard.

### `span.addError(error: Error)`

Sets the `error` of the current `Span`. When an `Error` object is passed to the `setError` method, the `stack` property is normalised and transformed into an array of strings, with each string representing a line in the stacktrace.

### `span.setSampleData(key: string, data: Array<string | number | boolean> | { [key: string]: string | number | boolean })`

Adds sample data to the current `Span`. The sample data object must not contain any nested objects. This call accepts the following keys, some keys require a specific format.

### `span.close()`

Closes the current `Span`.
