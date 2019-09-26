---
title: "Frontend error catching"
---

To catch an error and report it to AppSignal, add this to your code:

```javascript
try {
  // do something that might throw an error
} catch (error) {
  appsignal.sendError(error)
  // handle the error
}

// You can catch errors asynchronously by listening to Promises...
asyncActionThatReturnsAPromise().catch(error => appsignal.sendError(error))

// ...or by using async/await
async function() {
  try {
    const result = await asyncActionThatReturnsAPromise()
  } catch (error) {
    appsignal.sendError(error)
    // handle the error
  }
}

// ...or in an event handler or callback function
events.on("event", (err) => { appsignal.sendError(err) })
```

### Uncaught exceptions

Uncaught exceptions are **not** captured by default. We made the decision to not include this functionality as part of the core library due to the high amount of noise from browser extensions, ad blockers etc. that generally makes libraries such as this less effective.

We recommend using a relevant [integration](/front-end/integrations/) as a better way to handle exceptions, or, if you *would* prefer capture uncaught exceptions, you can do so by using the [`@appsignal/plugin-window-events`](/front-end/plugins/plugin-window-events.html) package alongside this one.

## Wrapping a block of code

The library provides a convenience method for wrapping a block of code and sending any error thrown within it directly to AppSignal. This is the `appsignal.wrap()` method, an async function that returns a `Promise`. A function should be passed as an argument containing the code you'd like to wrap.

```js
try {
  await appsignal.wrap(() => {
    // catch any error from sync or async code here
  })
} catch (e) {
  // do something else with the error here, the
  // error has already been sent to AppSignal
}

// Alternatave usage
appsignal.wrap(() => {
  // catch any error from sync or async code here
})
.catch((e) => {
  // do something else with the error here, the
  // error has already been sent to AppSignal
})
```

If an error is thrown anywhere in this function, we return a rejected promise with the `Error` passed as an argument to the `catch` handler.
