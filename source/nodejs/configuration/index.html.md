---
title: "AppSignal for Node.js configuration"
---

In this section, we'll explain how to configure AppSignal, what can be configured in the Node.js package, and what the minimal configuration needed is.

## Table of Contents

- [Minimal required configuration](#minimal-required-configuration)
- [Configuration options](/nodejs/configuration/options.html)
- [Application environments](#application-environments)
  - [Disable AppSignal for tests](#disable-appsignal-for-tests)

## Minimal required configuration

The minimal required configuration needed by AppSignal for Node.js are the following items. If they are not present, AppSignal will not send any data to AppSignal.com.

- A valid Push API Key
- An application name
- An application environment (`development`/`production`/`test` by setting `NODE_ENV`)
- The application environment to be set to `active: true`

The integration supports loading configuration via options passed to the `Appsignal` constructor.

```js
const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>"
})
```

Alternatively, you can configure the agent using system environment variables. AppSignal will automatically become active if the `APPSIGNAL_PUSH_API_KEY` environment variable is set.

```bash
export APPSIGNAL_PUSH_API_KEY="<YOUR API KEY>"
export APPSIGNAL_APP_NAME="<YOUR APPLICATION NAME>"
export APPSIGNAL_APP_ENV="production"
```

## Configuration options

Read about all the configuration options on the [options page](/nodejs/configuration/options.html).

## Application environments

An application can have multiple environments such as "development", "test", "staging" and "production".

To separate the errors and performance issues that occur in the "development" environment and those in "production", it's possible to set the environment in which the application is running with the `NODE_ENV` environment variable.

If you activate AppSignal per environment, you can set the `active` property of the options you pass into the constructor conditionally:

```js
const appsignal = new Appsignal({
  active: process.env.NODE_ENV !== "development",
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>"
})
```

### Disable AppSignal for tests

Make sure to put `active: false` in your test configuration unless you want to submit all your test results. You can do this in the same way:

```js
const appsignal = new Appsignal({
  active: process.env.NODE_ENV === "production", // ignored in all envs except production
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>"
})
```
