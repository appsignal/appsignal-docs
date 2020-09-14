---
title: "Creating and using a Span"
---

A `Span` is the name of the object that we use to capture data about your applications performance, any errors and any surrounding context. A `Span` can form a part of a broader **trace**, a heirarchical representation of the flow of data through your application.

It is designed to closely follow the concept of a Span from the [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-specification) standard specification, but there are some minor differences that we'll get into later.

## Creating a new `Span`

A `Span` can be created by calling `tracer.createSpan()`, which initializes a new `Span` object.

```js
const span = tracer.createSpan();
```

A `ChildSpan` can be created to represent a subdivision of the total length of time represented by the `RootSpan`. This is useful for instrumenting blocks of code that are run inside of the lifetime of a `RootSpan`.

```js
const childSpan = span.child();
```

A `ChildSpan` can also be created by passing an optional second argument to `tracer.createSpan()`.

```js
const childSpan = tracer.createSpan(undefined, rootSpan);
```

See the [Span API page](span-api.html) for more ways to configure and add useful metadata to the `Span`.

## Naming a `Span`

A `Span` name is used to identify a certain sample error and performance issues in the relevant tables in our UI. It should concisely identifiy the work represented by the `Span` (this could be an RPC method name, a function name, or a route name).

```js
const span = tracer.currentSpan();
span.setName("GET /route");
```

The `Span` name should be the most general string that identifies a (statistically) interesting group of `Span`s, rather than individual `Span` instances. These names function as a grouping mechanism. _Under no circumstances should they contain dynamic parameters such as IDs._

Examples:

```
GET /users/:id
Query.fetchAll
```

## Adding metadata to a `Span`

After a `Span` is created, you can begin adding data to it using methods on the `Span` object:

```js
const span = tracer.currentSpan();
span.set("name", "value");
```

Anything you set using this method will appear in the "Tags for sample" table in the Performance sample page.

## Adding sample data to a `Span`

Sample data with the following key/value pairs can be set on the root span:

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
