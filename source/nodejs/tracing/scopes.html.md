---
title: "Async tracing and Scopes"
---

Another concept unique to the Node.js integration is the concept of Scopes, which allow `Span`s to be recalled across ansychronous code paths that may not be linked to each other by being on the same direct code path.

As mentioned in the `Span` documentation, the current active `Span` can be recalled by calling `tracer.currentSpan()` in order to add data to it or create `ChildSpan`s from it.

```js
const span = tracer.currentSpan()
```

Before it can be recalled again, the `Span` must be given a Scope. A Scope is a wrapper for a `Span` that allows it to be recalled across ansychronous code paths that may not directly be directly linked to each other (in an `EventEmitter` or a timer, for example, or even in a completely different file or function scope). This wrapper is invisible to you and is managed internally via the the `Tracer` objects `ScopeManager` and the internal `async_hooks` module. These Scopes are stored in a stack, meaning that the most recent `Span` to be given a scope will be the next `Span` returned by `tracer.currentSpan()`.

A `Span` can be given a Scope like this:

```js
const tracer = appsignal.tracer()

tracer.withSpan(tracer.createSpan(), span => {
  // the `rootSpan` now has a Scope and will be the next `Span` to be returned
  // by `tracer.currentSpan()`
})
```

In a different file or function scope...

```js
const tracer = appsignal.tracer()
const rootSpan = tracer.currentSpan() // this is the same span passed to `withSpan` above!

tracer.withSpan(rootSpan.child(), span => {
  // the `ChildSpan` returned by rootSpan.child() now has a Scope and will 
  // be the next `Span` to be returned by `tracer.currentSpan()`
})
```
