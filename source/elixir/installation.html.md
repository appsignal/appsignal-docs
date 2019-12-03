---
title: "Installing AppSignal for Elixir"
---

Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

## Table of Contents

- [Installation](#installation)
  - [Requirements](#requirements)
  - [Configuration](#configuration)
      - [Manual configuration](#manual-configuration)
  - [Run your application!](#run-your-application)
  - [Optional: Add Phoenix instrumentation](#optional-add-phoenix-instrumentation)
  - [Optional: Add custom instrumentation](#optional-add-custom-instrumentation)
- [Uninstall](#uninstall)

## Installation

Installing the AppSignal package in your Elixir application requires a couple manual steps. Currently pure Elixir applications and the Phoenix framework are supported. Both use-cases are described in this guide.

If AppSignal does not support your use-case or if you find a problem with the documentation, don't hesitate to [contact us][support]. You can also create a pull-request on our public [Elixir repository][elixir-repo] or [documentation repository][docs-repo].

### Requirements

Before you can compile the AppSignal gem make sure the build/compilation tools are installed for your system. Please check the [Supported Operating Systems](/support/operating-systems.html) page for any system dependencies that may be required.

### Installing the package

-> **Note**: If you're running an umbrella application, see also our [umbrella installation guide](/elixir/installation/umbrella.html).

1. Start by adding `appsignal` to your list of dependencies in `mix.exs`.
   AppSignal requires you to depend on a JSON encoder. You can pick between
   `jason` and `poison`, our recommendation is to use `jason`.

    ```elixir
    # mix.exs
    def deps do
      [
        {:appsignal, "~> 1.0"},
        {:jason, "~> 1.1"}
      ]
    end
    ```

2. Then run `mix deps.get`.
3. Then run `mix appsignal.install YOUR_PUSH_API_KEY` or follow the [manual configuration guide](#configuration).
4. If you use the [Phoenix framework][phoenix], continue with the [integrating AppSignal into Phoenix](/elixir/integrations/phoenix.html) guide.

After the installation is complete start your application. When the AppSignal
OTP application starts, it looks for a valid configuration (e.g. an AppSignal
Push API key), and start the AppSignal agent.

If it can't find a valid configuration, a warning will be logged. See
the [Configuration](#configuration) section on how to fully configure the
AppSignal agent.

### Configuration

Before the AppSignal package works you need to configure it. To be able to send
data to AppSignal you first need to [create an account on
AppSignal.com](https://appsignal.com/users/sign_up). Or, if you already have an
account, click on the "add app" button on
[AppSignal.com/accounts](https://appsignal.com/accounts).

During the installation process you can run the `mix appsignal.install` command
with the hexadecimal [Push API key](/appsignal/terminology.html#push-api-key)
or manually configure AppSignal using the guide below.

For more information about configuring the AppSignal package for Elixir, please
read our [configuration documentation](/elixir/configuration/index.html).

#### Manual configuration

If you want to manually configure AppSignal you will need to place the
AppSignal Push API key you receive in the installation process in your
application's `config/config.exs` configuration file.

Using the AppSignal configuration you are also able to configure an application
name and environment and more.

```elixir
# config/config.exs
config :appsignal, :config,
  active: true,
  name: "My awesome app",
  push_api_key: "your-push-api-key",
  env: Mix.env
```

Alternatively, you can configure AppSignal using OS environment variables.

```sh
export APPSIGNAL_PUSH_API_KEY="your-push-api-key"
export APPSIGNAL_APP_NAME="My awesome app"
export APPSIGNAL_APP_ENV="prod"
```

For more information about configuring the AppSignal package for Elixir, please
read our [configuration options page](/elixir/configuration/index.html).

### Run your application!

Once you've completed this guide your application is ready to be monitored by
AppSignal!

Start your application up and perform some requests on it. By triggering an
error or two you'll also test the error reporting.

[Contact us][support] if you have questions regarding installation or
encountered any problems during the installation.

### Optional: Add Phoenix instrumentation

Read more about how you can integrate more instrumentation in your Phoenix
application in our [integrating Phoenix
guide](/elixir/integrations/phoenix.html).

### Optional: Add custom instrumentation

Add custom instrumentation to your application to get a more in-depth view of
what's happening in your application. Read more about custom instrumentation in
our [instrumentation documentation](/elixir/instrumentation/index.html).

## Uninstall

Uninstall AppSignal from your app by following the steps below. When these steps are completed your app will no longer send data to the AppSignal servers.

1. In the `mix.exs` of your app, delete the `{:appsignal, "~> 1.0"}` line.
1. Run `mix deps.get` to update your `mix.lock` with the removed packages state.
1. Remove any AppSignal [configuration files](/elixir/configuration/) from your app.
  - Configuration file location: `config/appsignal.exs`
  - And its references in any other files in `config/*.exs`
1. Remove any system environment variables from your development, staging, production, etc. hosts.
  - Environment variables prefixed with `APPSIGNAL_`
  - Environment variable [`APP_REVISION`](/elixir/configuration/options.html#option-revision)
1. Commit, deploy and restart your app.
  - This will make sure the AppSignal servers won't continue to receive data from your app.
1. Optional: Make sure no `appsignal-agent` processes are running in the background.
  - Check the output of `ps aux | grep appsigal-agent` and kill the processes still running.
1. Finally, [remove the app](/application/#removing-an-application) on AppSignal.com

[support]: mailto:support@appsignal.com
[elixir-repo]: https://github.com/appsignal/appsignal-elixir
[docs-repo]: https://github.com/appsignal/appsignal-docs
[phoenix]: http://www.phoenixframework.org/
