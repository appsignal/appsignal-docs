---
title: "Creating and using a Span"
---

A `Span` is the name of the object that we use to capture data about the performance of your application, any errors and any surrounding context. A `Span` can form a part of a broader **trace**, a hierarchical representation of the flow of data through your application.

Each `Span` contains the following state:

- A name
- A start and finish timestamp
- Tags
- Sample data
- The parent `Span`s ID (if any)
- `SpanContext` identification of a `Span`

It is designed to closely follow the concept of a Span from the [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-specification) standard specification, but there are some minor differences that we'll get into later.

## Creating a new `Span`

A `RootSpan` can be created by calling `tracer.createSpan()`, which initializes a new `RootSpan` object.

```js
const span = tracer.createSpan();
```

A `RootSpan` is a type of `Span` which encapsulates the end-to-end latency for the entire request. As a `Span` is created, its start time is recorded. To give the span an end time, the `Span` must be closed when all the operations that the `Span` is recording are finished. For more information about closing a `Span`, see [this section](#closing-a-span).

When a `Span` is created, it is not bound to any _scope_. This means it cannot be recalled again from a different place in your app without first being given a _scope_. See [this page](scopes.html) for more details.

### Configuring a `Span`

The `tracer.createSpan()` method takes two optional arguments. The first optional argument is an object of options to be passed to the `Span` at creation time. All properties on this object are also optional.

```js
{
  namespace: "custom-namespace", // a custom namespace for this span (defaults to `web`)
  startTime: 1597059277          // a custom start time for this span. defaults to the current time. value must be a valid 64-bit integer representing a valid UNIX time.
}
```

The `tracer.createSpan()` method also takes an optional second argument. If this second argument is supplied, the returned `Span` will be a `ChildSpan`.

```js
const childSpan = tracer.createSpan(undefined, span || spanContext);
```

- If a `Span` is passed as the optional second argument, then the returned `Span` will be a child of that `Span`.
- If a `SpanContext` is passed as the optional second argument, then the returned `Span` will also be a `ChildSpan`.

Let's take a look at `ChildSpan`s in more detail.

## Child spans

A `ChildSpan` can be created to represent a subdivision of the total length of time represented by the `RootSpan`. This is useful for instrumenting blocks of code that are run inside of the lifetime of a `RootSpan`.

```js
const childSpan = rootSpan.child();
```

As mentioned previously, a `ChildSpan` can also be created by passing an optional second argument to `tracer.createSpan()`.

```js
const childSpan = tracer.createSpan(undefined, rootSpan);
```

After a `Span` is created, you can begin adding data to it using methods on the `Span` object. `ChildSpan`s and `RootSpan`s share the same interface, meaning that the documentation below is valid for both types of `Span`.

## Naming a `Span`

A `Span` name is used to identify a certain sample error and performance issues in the relevant tables in our UI. It should concisely identify the work represented by the `Span` (this could be an RPC method name, a function name, or a route name).

```js
const span = tracer.currentSpan();
span.setName("GET /route");
```

The `Span` name should be the most general string that identifies a (statistically) interesting group of `Span`s, rather than individual `Span` instances. These names function as a grouping mechanism. **Under no circumstances should they contain dynamic parameters such as IDs.**

Examples:

```
GET /users/:id
Query.fetchAll
```

## Adding metadata to a `Span`

More information on this is available [here](/nodejs/tracing/tagging.html).

## Adding an error to a `Span`

More information on this is available [here](/nodejs/tracing/exception-handling.html).

## Closing a `Span`

As `Span`s represent a length of time, they must be given a finish time once all the operations that the `Span` is timing have completed. You do this by calling `span.close()`.

```js
const span = tracer.currentSpan();
span.setName("GET /route");

// do stuff...

span.close();
```

If the `RootSpan` is created by the core `http` integration (the most common case), the `RootSpan` is closed automatically by the integration. If any children of this `RootSpan` are left unclosed, then they are dropped from the trace.
