---
title: "Async tracing and Scopes"
---

Another concept unique to the Node.js integration is the concept of Scopes, which allow `Span`s to be recalled across asynchronous code paths that may not be linked to each other by being on the same direct code path.

## What is a "Scope"?

As mentioned in the [`Span` documentation](/nodejs/tracing/span.html), the currently active `Span` can be recalled by calling `tracer.currentSpan()` to add data to it or create `ChildSpan`s from it.

```js
const span = tracer.currentSpan();
```

Before it can be recalled again from elsewhere in your application (for example, in a completely different file), the `Span` must be given a Scope. This is not to be confused with "lexical scope", which is a language construct - it is a separate, but not unrelated, concept.

A Scope is a wrapper for a `Span` that allows it to be recalled across asynchronous code paths that may not be directly linked to each other (in an `EventEmitter` or a timer, for example, or even in a completely different file or function scope). This wrapper is invisible to you and is managed internally via the `Tracer` objects `ScopeManager` and the internal [`async_hooks` module](https://blog.appsignal.com/2020/09/30/exploring-nodejs-async-hooks.html).

These Scopes are stored in a stack, meaning that the most recent `Span` to be given a scope will be the next `Span` returned by `tracer.currentSpan()`.

## Assigning a Scope to a `Span`

A `Span` can be given a Scope like this:

```js
const tracer = appsignal.tracer();

tracer.withSpan(tracer.createSpan(), (span) => {
  // the span returned by `tracer.createSpan()` now has a Scope
  // it and will be the next span to be returned by `tracer.currentSpan()`!
});
```

Once assigned to a Scope, the `Span` passed to `tracer.withSpan()` can be recalled using `tracer.currentSpan()` in a different file or lexical scope.

```js
tracer.withSpan(tracer.currentSpan(), (span) => {
  // `span` is the same span created by `tracer.createSpan()` in the example above!
  // http://gph.is/1KjihQe
});
```
