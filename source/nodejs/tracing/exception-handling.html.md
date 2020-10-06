---
title: "Exception handling"
---

In most applications some errors will get raised that aren't related to possible bugs in your code, they just happen when your app gets into contact with the real world. Bots might drop by and try to automatically post forms, outdated links might direct visitors to content that doesn't exist anymore and so on.

To avoid these errors from being raised as problems in AppSignal it's possible to add exception handling to your code or even let AppSignal completely ignore certain errors.

## Ignore errors

The AppSignal configuration makes it possible to [ignore errors](/nodejs/configuration/ignore-errors.html). By providing a list of specific errors AppSignal will not send alerts when these errors are raised.

## `span.addError(error)`

If you want to catch exceptions in your application to prevent crashes, but still want to track the occurrence you can use `span.addError()` to add the exception to the context of the current `Span`:

```js
const span = tracer.currentSpan();

try {
  throw new Error("Oh no!");
} catch (e) {
  span.addError(e);
} finally {
  span.close();
}
```

The exception will be tracked by AppSignal like any other error, and it allows you to provide custom error handling and fallbacks.
