---
title: "Creating and Using a Span"
---

A `Span` is the name of the object that we use to capture data about an error and its surrounding context. It is designed to be similar to, but not exactly like, the Span from the [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-specification) standard specification.

## Creating a new `Span`

A `Span` can be created by calling `appsignal.createSpan()`, which initializes a new `Span` object with any default options that you passed when the `Appsignal` object was initialized.

```js
const span = appsignal.createSpan();
```

The `createSpan()` method can also take a function as a parameter, allowing you to define the `Span`'s data as the same time as it is created.

```js
const span = appsignal.createSpan((span) => {
  return span.setTags({
    tag: "value",
  });
});
```

`Span`s cannot be nested, nor can multiple `Span`s be passed to `appsignal.send()` at once. We recommend using `Promise.all` for concurrent `send` operations.

```js
const span1 = appsignal.createSpan();
const span2 = appsignal.createSpan();

Promise.all([appsignal.send(span1), appsignal.send(span2)]);
```

## Updating a `Span`

After a `Span` is created, you can begin adding data to it using methods on the `Span` object:

```js
const span = appsignal.createSpan();
span.setTags({ tag: "value" });

console.log(span.serialize().tags); // { tag: "value" }
```

Each method that modifies the `Span` returns `this`, allowing you to chain methods together:

```js
const span = appsignal.createSpan();

span.setTags({ tag: "value" }).setError(new Error("test error"));

console.log(span.serialize().tags); // { tag: "value" }
console.log(span.serialize().error); // { name: "Error", message: "test error", backtrace: [...] }
```

### `span.setAction(name: string)`

Sets the `action` of the current `Span`. The `action` must never be an empty string - it can be either `undefined` or a non-empty string. An action name is used to identify the location of a certain sample error and performance issues.

### `span.setNamespace(name: string)`

Sets the `namespace` of the current `Span`. Namespaces are a way to group error incidents, performance incidents, and host metrics in your app.

### `span.setError(error: Error | object)`

Sets the `error` of the current `Span`. The `Error` object has a `name`, `message` and `backtrace` property. Make sure to only use something describing the error's type as the `name`. AppSignal groups the errors based on this name. You can put anything you like in the `message`.

When an `Error` object is passed to the `setError` method, the `stack` property is normalised and transformed into an array of strings, with each string representing a line in the stacktrace. For consistency with our other integrations, `stack` is renamed to `backtrace`.

### `span.setTags(tags: object)`

Adds `tags` to the current `Span`. The current `tags` will be merged with the `tags` object passed as a parameter.

### `span.setParams(params: object)`

Adds `params` to the current `Span`. The current `params` will be merged with the `params` object passed as a parameter. The `params` object must not contain any nested objects.

### `span.serialize()`

Returns the contents of a `Span` as an object.

## Sending a `Span` to AppSignal

When you're finished adding data to the `Span`, it can then be passed to `appsignal.send()` to be pushed to our API.

```js
const span = appsignal.createSpan((span) => {
  return span.setError(new Error("test error"));
});

appsignal.send(span);
```

The `send()` method is different to the `sendError()` method as it allows a `Span` to be passed as a parameter, which is either pushed immediately to the API, or in the case of a network error, added to the queue to be retried later.

Once the `Span` is passed to `appsignal.send()`, any [Hooks](/front-end/hooks.html) are applied to the `Span` in the following order:

- Decorators
- Optional `tags` or `namespace` arguments to `appsignal.send()`
- Overrides

### About the Retry Queue

If, for any reason, pushing an error to the API fails (e.g. if the network connection is not working), the `Span` object that it belongs to is placed in the retry queue. By default, requests are retried **5 times** with exponential backoff. If the request succeeds, the corresponding `Span` is removed from the queue. Once the retry limit has been reached, any `Span`s left in the queue are discarded.

!> No caching is currently implemented for the retry queue, meaning that if a `Span` is in the queue when the user navigates away from your aplication, that `Span` will also be discarded.
