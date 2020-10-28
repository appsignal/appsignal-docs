---
title: "Configuring applications"
---

In this guide we'll explain how to configure AppSignal. We'll choose a config option and guide you through the process of adding or changing this configuration in the AppSignal config in an app.

## Choose a configuration option

You may have arrived at this guide from another page to help you configure AppSignal. If so, great, you already know what config option you want to configure. In this guide we'll configure the config option below for the listed integrations as an example.

- Debug (`debug`) option documentation for integrations:
  - [Ruby `debug` config option](/ruby/configuration/options.html#option-debug)
  - [Elixir `debug` config option](/elixir/configuration/options.html#option-debug)
  - [Node.js `debug` config option](/nodejs/configuration/options.html#option-debug)
- Namespace (`namespace`) option documentation for integrations:
  - [Front-end JavaScript `namespace` config option](/front-end/configuration.html)

## Choose a configuration method

There are multiple ways to configure an AppSignal integration in an app. There may be some differences between the specific integrations, but in general they all have these configuration methods.

- [File based configuration](#file-based-configuration)
  - A config file where the AppSignal configuration read from by the AppSignal integration.
- [System environment variable configuration][env]
  - Environment variables set on the host system (server), on the parent process the app is started by.
  - **Note**: This method is not available for front-end JavaScript.

## File based configuration

The file based configuration method is the easiest to get started. Some integrations create a config file during the installation of AppSignal in the app. In these config files (location differs per integration), one or multiple environments of the app can be configured, each with their own configuration.

-> 💡 When using file based configuration, make sure to use the "Config file key" value from the config options table as the config key. This key is either a lowercased String that uses underscores between words, or is a camelCased String.

!> ⚠️ Make sure to not check-in any sensitive configuration values, such as the Push API key into a source-control management system like Git, unless encrypted. This information does not always need to be available to everyone with access to the source code, such as for an app with a public source code.

### Ruby

Upon installation, the Ruby integration gem creates a `config/appsignal.yml` (default location) file with basic configuration. If this file is not present but the app is reporting data to AppSignal, it is most likely using [system environment variables][env] as a configuration method instead.

-> 🔍 The `config/appsignal.yml` file is a <abbr title="Yet Another Markup Language">[YAML](https://en.wikipedia.org/wiki/YAML)</abbr> file. For more details about how the YAML configuration works, please see the [Ruby configuration section][ruby config].

Add the config option you want to add to one of the root-level app environment keys, indented by two spaces. In the example below we will add the `debug` option only to the `development` app environment.

```yml
# Example: config/appsignal.yml
default: &defaults # Shared configuration options for all environments
  active: true
  name: "My awesome app"
  push_api_key: "<YOUR PUSH API KEY>"
  # Other AppSignal config...

development: # Development app environment
  <<: *defaults
  debug: true # This enables debug mode for only the development environment
  # Other AppSignal config...

production: # Production app environment
  <<: *defaults
  # Other AppSignal config...
```

If you want the config option to apply to all app environments, add the config option below the `default` key like so:

```yml
# Example: config/appsignal.yml
default: &defaults
  active: true
  name: "My awesome app"
  push_api_key: "<YOUR PUSH API KEY>"
  debug: true # This enables debug mode for all environments
  # Other AppSignal config...

development: # Development app environment
  <<: *defaults
  # Other AppSignal config...

production: # Production app environment
  <<: *defaults
  # Other AppSignal config...
```

####^ruby Read more

- [Ruby integration configuration topic][ruby config]
- [Ruby integration configuration load order details](/ruby/configuration/load-order.html)

[ruby config]: /ruby/configuration/

### Elixir

Upon installation, the Elixir integration creates a `config/appsignal.exs` (default location) file with basic configuration. If this file is not present but the app is reporting data to AppSignal, check any of the other `.exs` files in the `config/` directory of your Elixir app. If no AppSignal configuration is present in any of the files, it is most likely using [system environment variables][env] as a configuration method instead.

To add a configuration option and have it apply to all app environments, add the config option to the `config/appsignal.exs` file like so:

```elixir
# Example: config/config.exs
config :appsignal, :config,
  active: true,
  name: "My awesome app",
  push_api_key: "<YOUR PUSH API KEY>",
  env: Mix.env,
  debug: true # This enables debug mode for all environments
```

To only have the config option apply to one environment, add the AppSignal configuration to the environment config file in the `config/` directory. We'll add the debug option to the development (or "dev") environment in example below.

```elixir
# Example: config/dev.exs
config :appsignal, :config,
  debug: true # This enables debug mode only for the "dev" environment
```

####^elixir Read more

- [Elixir integration configuration topic][elixir config]
- [Elixir integration configuration load order details](/elixir/configuration/load-order.html)

[elixir config]: /elixir/configuration/

### Node.js

After installation a JavaScript file with AppSignal config can be created to configure AppSignal. If no file with AppSignal configuration is present, it is most likely using [system environment variables][env] as a configuration method instead.

For Node.js apps the AppSignal config or a file with AppSignal config, can be placed in any custom location, as long as it's required/imported by the app's code __before any other packages are required/imported__.

In the example below there is an `appsignal.js` file in the root of the app directory. In this file we'll add the `debug` config option.

```js
// Example: appsignal.js
const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>",
  debug: true // Enables debug mode for the Node.js environment
});
```

The config in the example above applies to environment Node.js is running in (`NODE_ENV`, defaults to "development").

#### Read more

- [Node.js integration configuration topic][nodejs config]
- [Node.js integration configuration load order details](/nodejs/configuration/load-order.html)

[nodejs config]: /nodejs/configuration/

### Front-end JavaScript

Configuration for AppSignal for front-end JavaScript can be placed in any JavaScript file or a separate `appsignal.js` file, that is then imported in the app's main JavaScript file.

In the example below there is an `appsignal.js` file in the root of the app directory. In this file we'll add the `namespace` config option.

```js
// Example: appsignal.js
import Appsignal from "@appsignal/javascript" // For ES Module
const Appsignal = require("@appsignal/javascript").default // For CommonJS module

const appsignal = new Appsignal({
  key: "<YOUR FRONTEND API KEY>",
  namespace: "front_end" // Configure the AppSignal namespace for front-end errors in this app
})
```

#### Read more

- [Front-end JavaScript integration configuration topic][frontend config]

[frontend config]: /front-end/configuration/

## System environment variable configuration

System environment variables, or "environment variables" for short, are variables that are accessible by all apps started by a certain parent process. Instead of using a [configuration file][file] for configuration, it's possible to configure AppSignal using only these environment variables. Alternatively, it's possible to only set config keys that contain sensitive data such as the Push API key this way, and use [config files][file] for the rest of the config.

This configuration method works for all integrations the same way and is leading for integrations: If a system environment variable is detected as AppSignal config option it overwrites the previous set config option value.

In the example below we've configured two environment variables, using the environment variables key format. After (re)starting the app process in a shell that has these environment variables set, AppSignal will load the values of these environment variables as its config. Config options set via environment variables apply to all app environments.

```sh
# Bash shell example
export APPSIGNAL_PUSH_API_KEY=<YOUR PUSH API KEY>
export APPSIGNAL_DEBUG=true # Enables debug mode for all environments.
```

There are several possible locations for files with environment variables configuration. Choose the option that suits your app the best. Make sure to reload your terminal shell to see any updates to those files reflected in your shell.

- `~/.profile` or `~/.bash_profile` - User specific settings. Use this location to configure environment variables per user.
- `/etc/profile` - System-wide settings. Do not use this location if multiple users or apps use the same host machine.

Platform As A Service (PaaS) hosting providers like Heroku, do not provide a system for configuring environment variables in the shell directly. Instead, use their web interface or CLI instead to configure these environment variables.

-> 💡 When using system environment variable based configuration, make sure to use the "System environment key" value from the config options table as the config key. This key is always completely capitalized and uses underscores between words.

!> ⚠️ This configuration method is not available for front-end JavaScript.

## Deploy and restart

After changing any configuration, the app needs to be restarted or deployed for the configuration changes to be picked up by AppSignal.

Are configuration changes not being picked up? [Contact us][contact] and we will help you out! To help us debug your issue quicker, also send us a [diagnose report](/support/debugging.html#diagnose) from your app host.

## Next steps

- [Reporting deploys to track improvements](/guides/deploy-markers.html) - next guide

---

- [Add a new application](/guides/new-application.html) - previous guide
- [Getting started guides](/guides/) - Guides overview

[file]: #file-based-configuration
[env]: #system-environment-variable-configuration
[contact]: mailto:support@appsignal.com
