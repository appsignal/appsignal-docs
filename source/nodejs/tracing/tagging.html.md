---
title: "Tagging and Sample Data"
---

You can use the `span.set()` and `span.setSampleData()` functions to supply extra context on errors and performance issues. This can help to add information that is not already part of the request, session or environment parameters.

!> **Warning**: Do not use tagging to send personal data such as names or email addresses to AppSignal. If you want to identify a person, consider using a user ID, hash or pseudonymized identifier instead. You can use [link templates](/application/link-templates.html) to link them to your own system.

## Tags

Using tags you can easily add more information to errors and performance issues tracked by AppSignal.

```js
const span = tracer.currentSpan();
span.set("a key", "value"); // sets a tag
```

However, there are a few limitations on tagging:

- The tag key must be a `String`.
- The tagged value must be a `String`, `Number` or `Boolean`.

Tags that do not meet these limitations are dropped without warning.

### Link templates

Tags can also be used to create link templates. Read more about link templates in our [link templates guide](/application/link-templates.html).

## Sample Data

Sample data with the following key/value pairs can be set **on the root span**:

```js
const span = tracer.currentSpan();
span.setSampleData("key", { string: "value", number: 123 }); // sets additional sample data
```

The first argument to `setSampleData` takes a `key`, that can be one of the following:

### `session_data`

Filled with session/cookie data by default, but can be overridden with the following call:

```js
span.setSampleData("session_data", {
  _csrf_token: "Z11CWRVG+I2egpmiZzuIx/qbFb/60FZssui5eGA8a3g=",
});
```

This key accepts nested objects that will be rendered as JSON on a Incident Sample page for both Exception and Performance samples.

![session_data](/assets/images/screenshots/sample_data/session_data.png)

### `params`

Filled with framework (such as Express) parameters by default, but can be overridden or filled with the following call:

```js
span.setSampleData("params", { string: "value", number: 123 });
```

This key accepts nested objects and will show up as follows on a Incident Sample page for both Exception and Performance samples, formatted as JSON.

![params](/assets/images/screenshots/sample_data/params.png)

### `environment`

Environment variables from a request/background job (typically filled by the default `http` integration, but can be further augmented by other integrations), but can be filled/overriden with the following call:

```js
span.setSampleData("environment", { CONTENT_LENGTH: "0" });
```

This call only accepts a one-level key/value object, nested values will be ignored.
This will result the following block on a Incident Sample page for both Exception and Performance samples.

![environment](/assets/images/screenshots/sample_data/environment.png)

### `custom_data`

Custom data is not set by default, but can be used to add additional debugging data to solve a performance issue or exception.

```js
span.setSampleData("custom_data", { foo: "bar" });
```

This key accepts nested objects and will result in the following block on a Incident Sample page for both Exception and Performance samples formatted as JSON.

![custom_data](/assets/images/screenshots/sample_data/custom_data.png)
