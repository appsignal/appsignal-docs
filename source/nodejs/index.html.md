---
title: "AppSignal for Node.js"
---

AppSignal now supports [Node.js](https://nodejs.org/)! We're proud to bring the same great performance monitoring and error tracking that we offer Ruby and Elixir customers to the Node.js ecosystem. The package supports pure JavaScript applications and TypeScript applications, and can auto-instrument various frameworks and packages with optional plugins. Other frameworks and packages might require some custom instrumentation.

The new Node.js implementation contains some concepts that vary from the Ruby and Elixir implementations.

!> At the moment, this integration is still in **alpha**, and should be considered work in progress software that is likely to change significantly. We are testing this closely with our partners, and will update this page with any information regarding the next phase of release. Want to know more, or have feeback for us? Email [support@appsignal.com](mailto:support@appsignal.com). 

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Integrations](#integrations)
- [Custom instrumentation](#custom-instrumentation)
- [Supported versions](#supported-versions)

## Installation

First, sign up for an AppSignal account and add the `@appsignal/nodejs` package to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs
npm install --save @appsignal/nodejs
```

You can then import and use the package in your bundle:

```js
const { Appsignal } = require("@appsignal/nodejs")
```

## Configuration

The minimal required configuration needed by AppSignal for Node.js are the following items. If they are not present, AppSignal will not send any data to AppSignal.com.

- A valid Push API Key
- An application name
- An application environment (`dev`/`prod`/`test`)
- The application environment to be set to `active: true`

The integration supports loading configuration via options passed to the `Appsignal` constructor.

```js
const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>"
})
```

Alternatively, you can configure the agent using system environment variables. AppSignal will automatically become active if the `APPSIGNAL_PUSH_API_KEY` environment variable is set.

```bash
export APPSIGNAL_PUSH_API_KEY="your-push-api-key"
export APPSIGNAL_APP_NAME="My awesome app"
export APPSIGNAL_APP_ENV="prod"
```

## Integrations

At this time, we only support integration with Express.js v4+. Express can be instrumented automatically via a middleware plugin.

```bash
yarn add @appsignal/nodejs @appsignal/express
npm install --save @appsignal/nodejs @appsignal/express
```

You can then import and use the package in your app:

```js
const express = require("express")
const { Appsignal } = require("@appsignal/nodejs")
const { expressMiddleware } = require("@appsignal/express")

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>"
})

const app = express()

// ADD THIS BEFORE ANY OTHER EXPRESS MIDDLEWARE!
app.use(expressMiddleware(appsignal))
```

This will automatically instrument all HTTP calls that pass through Express. When you create a new `Span`, it will be child of the `Span` created by the Express middleware.

## Custom instrumentation

Using the new `Span` API, even more insights in your application can be added by adding more instrumentation or tagging the data that appears in the UI at AppSignal.com. 

A `Span` is the name of the object that we use to capture data about your applications performance, any errors and any surrounding context. It is designed to be similar to, but not exactly like, the Span from the [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-specification) standard specification. 

### Creating a new `Span`

A `Span` can be created by calling `tracer.createSpan()`, which initializes a new `Span` object. A `Span` name is used to identify the location of a certain sample error and performance issues.

```js
const span = tracer.createSpan(spanName)
```

### Updating a `Span`

After a `Span` is created, you can begin adding data to it using methods on the `Span` object:

```js
const span = tracer.createSpan()
span.set("name", "value")
```

Each method that modifies the `Span` returns `this`, allowing you to chain methods together:

```js
const span = tracer.createSpan()

span
  .set("name", "value")
  .addError(new Error("test error"))
```

#### `span.set(key: string, value: string | number | boolean)`

Sets arbitary data on a current `Span`. The data can be a `string`, `number` or `boolean` type.

#### `span.setNamespace(name: string)`

Sets the `namespace` of the current `Span`. Namespaces are a way to group error incidents, performance incidents, and host metrics in your app.

#### `span.addError(error: Error | object)`

Sets the `error` of the current `Span`. When an `Error` object is passed to the `setError` method, the `stack` property is normalised and transformed into an array of strings, with each string representing a line in the stacktrace. For consistency with our other integrations, `stack` is renamed to `backtrace`.

#### `span.setSampleData(key: string, data: Array<any> | { [key: string]: any })`

Adds sample data to the current `Span`. The sample data object must not contain any nested objects.

#### `span.close(endTime?: number)`

Closes the current `Span`.

### Example instrumentation

A key benefit of the new API is that it works aynchronously. Here's an example of an instrumented function:

```js
async function () {
  // the `RootSpan` 
  const rootSpan = tracer.createSpan("rootSpanName")

  await tracer.instrument(rootSpan, async span => {
    span
      .set("key", value)
      .setNamespace("namespace")
      .setSampleData("key", value)

    await tracer.instrument(
      tracer.createSpan("childSpan1Name", span),
      async child => {
        // add code to instrument here!
        // `tracer.instrument` will return any value that you return
        // in this callback
      }
    )

    await tracer.instrument(
      tracer.createSpan("childSpan2Name", span),
      async () => {
        // multiple functions can be intrumented at once
      }
    )
  })
}
```

## Supported versions

Our Node.js suppport tracks the active LTS release and above, which is currently [v10](https://github.com/nodejs/Release) and above.
