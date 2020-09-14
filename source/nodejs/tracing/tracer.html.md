---
title: "The Tracer object"
---

AppSignal for Node.js contains a new concept that is different to the current Ruby implementation - the `Tracer` object. The `Tracer` object contains various methods that you might use when creating your own custom instrumentation.

The Tracer is responsible for tracking the currently active `Span`, and exposes functions for creating and activating new `Span`s.

## Retrieving the `Tracer`

```js
const tracer = appsignal.tracer();
```

If the agent is currently inactive (you must actively set it as such by setting `active: true`), then the AppSignal client will return an instance of `NoopTracer`, which is safe to call within your code as if the agent were currently active, but does not record any data.

## Retrieving the current `Span`

In most cases, a `Span` will be created by one of our automatic instrumentations, e.g. the `http` module integration. In order to add any custom instrumentation to your trace, you'll need to retrieve that `Span` using the `Tracer` instance.

```js
const span = tracer.currentSpan();
```

Once you have the current `Span`, you'll be able to add data to it and create `ChildSpan`s from it. If a current `Span` is not available, then `tracer.currentSpan()` will return a `NoopSpan`.

## Creating a new `Span`

A `Span` can be created by calling `tracer.createSpan()`, which initializes a new `Span` object.

```js
const span = tracer.createSpan();
```

A `ChildSpan`, a `Span` that is the child of another `Span`, can also be created by passing an optional second argument to `tracer.createSpan()`.

```js
const childSpan = tracer.createSpan(undefined, span);
```
