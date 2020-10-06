---
title: "The Tracer object"
---

AppSignal for Node.js contains a new concept that is different from the current Ruby implementation - the `Tracer` object. The `Tracer` object contains various methods that you might use when creating your own custom instrumentation.

The Tracer is responsible for tracking the currently active `Span`, and exposes functions for creating and activating new `Span`s.

## Retrieving the `Tracer`

```js
const tracer = appsignal.tracer();
```

If the agent is currently inactive (you must actively set it as such by setting `active: true`), then the AppSignal client will return an instance of `NoopTracer`, which is safe to call within your code as if the agent were currently active but does not record any data.

## Retrieving the current `Span`

In most cases, a `Span` will be created by one of our automatic instrumentations, e.g. the `http` module integration. To add any custom instrumentation to your trace, you'll need to retrieve that `Span` using the `Tracer` instance.

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

## Using an existing `Span`

Instrumenting a block of code, or operation can be done with the help of `tracer.withSpan()`.

Any code executed within the callback passed as the second argument to `tracer.withSpan()` can be said have been executed within the _context_ of the `Span` passed as the first argument. If you consider that a `Span` has a start time and an end time, the _context_ of a `Span` is the empty space between those two points. In this "empty space", you can execute any code that you wish to instrument, as well as create children of the current `Span` in order to create more granular measurements.

This context can later be recreated in a completely different place (such as a different file in your project, or in a different lexical scope) by simply calling `tracer.withSpan()` again with the same `Span` (which can be recalled using `tracer.currentSpan()`).

```js
// the span returned by `tracer.currentSpan()` is passed to the callback as arg1: `span`
// it has a scope and will be the next `Span` to be returned by `tracer.currentSpan()`
tracer.withSpan(tracer.currentSpan(), (span) => {
  // your code goes here...
  someCode();

  // if you want to create a child span, you can call `tracer.withSpan()` with `span.child()`
  // to create context or that span
  tracer.withSpan(span.child(), (child) => {
    someOtherCode();
    child.close();
  });

  span.close(); // don't forget to close the span if you're done with it!
});
```

The callback passed to `tracer.withSpan()` can also be an async function:

```js
tracer.withSpan(tracer.currentSpan(), async (span) => {
  // all your async code goes here...
  await someCode();

  span.close(); // don't forget to close the span if you're done with it!
});
```

If the callback returns a value, it will become the return value of the `tracer.withSpan()` function.

The most recent `Span` passed to `tracer.withSpan()` also now has a scope, which means that it will be `Span` to be returned the next time you call `tracer.currentSpan()`. When the operation you wish to instrument is complete, call `span.close()` to stop the timer. 

For more information on scopes, see the [Async tracing and Scopes page](/nodejs/tracing/scopes.html).
