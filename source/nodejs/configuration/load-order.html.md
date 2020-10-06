---
title: "AppSignal for Node.js load order"
---

AppSignal for Node.js can be configured in a couple of different ways - through the `Appsignal` constructor or environment variables.

The configuration is loaded in a four-step process, starting with the package defaults and ending with reading environment variables. The configuration options can be mixed without losing configuration from a different option.

## Load orders

- 1. [Package defaults - `default`](#default)
- 2. [System detected settings - `system`](#system)
- 3. [Environment variables - `env`](#env)
- 4. [`Appsignal` constructor - `initial`](#initial)

##=default 1. Module defaults

The AppSignal module starts with loading its default configuration, setting paths and enabling certain features.

The agent defaults can be found in the [module source](https://github.com/appsignal/appsignal-nodejs/blob/main/packages/nodejs/src/config.ts).

##=system 2. System detected settings

The gem detects what kind of system it's running on and configures itself accordingly.

For example, when it's running inside a container-based system (such as Docker and Heroku) it sets the configuration option `runningInContainer` to `true`.

##=env 3. Environment variables

AppSignal will look for its configuration in environment variables. When found these will override all given configuration options from previous steps.

```bash
export APPSIGNAL_APP_NAME="my custom app name"
# start your app here
```

##=initial 4. Initial configuration given to `Appsignal` constructor

When initializing the `Appsignal` object, you can pass in the initial configuration you want to apply. This is an `object` of any of the options described below.

```js
const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>",
});
```

This step will override all given options from the defaults or system detected configuration.
