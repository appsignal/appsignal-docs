---
title: "Installing AppSignal for Elixir"
---

Installing the AppSignal package in your Elixir application requires a couple
manual steps. Currently pure Elixir applications and the Phoenix framework are
supported. Both use-cases are described in this guide.

If AppSignal does not support your use-case or if you find a problem with the
documentation, don't hesitate to [contact us][support]. You can also create a
pull-request on our public [Elixir repository][elixir-repo] or [documentation
repository][docs-repo].

## Installation

### Requirements

Before you can compile the AppSignal package make sure the build/compilation
tools are installed for your system.

**Ubuntu / Debian**

```
sudo apt-get update
sudo apt-get install build-essential
```

**Alpine Linux**

```
apk add --update alpine-sdk coreutils
```

**macOS**

```
xcode-select --install
```

### Installing the package

1. Start by adding `appsignal` to your list of dependencies in `mix.exs`.

    ```elixir
    # mix.exs
    def deps do
      [{:appsignal, "~> 0.0"}]
    end
    ```

2. Ensure `appsignal` is started before your application.

    ```elixir
    # mix.exs
    def application do
      [applications: [:appsignal]]
    end
    ```

3. Then run `mix deps.get`

4. If you use the [Phoenix framework][phoenix], continue with the [integrating
   AppSignal into Phoenix](/elixir/integrations/phoenix.html) guide.

After the installation is complete start your application. When the AppSignal
OTP application starts, it looks for a valid configuration (e.g. an AppSignal
Push API key), and start the AppSignal agent.

If it can't find a valid configuration, a warning will be logged. See
the [Configuration](#configuration) section on how to fully configure the
AppSignal agent.

## Configuration

Before the AppSignal package works you need to configure it. To be able to send
data to AppSignal you first need to [create an account on
AppSignal.com](https://appsignal.com/users/sign_up).

During the installation process you will receive a hexadecimal [Push API
key](/appsignal/terminology.html#push-api-key) which you will need to place in
your application's `config.exs`.

```elixir
# config/config.exs
config :appsignal, :config,
  active: true,
  name: :my_first_app,
  push_api_key: "your-hex-appsignal-key"
```

Alternatively, you can configure AppSignal using OS environment variables.

```sh
export APPSIGNAL_APP_NAME="my_first_app"
export APPSIGNAL_PUSH_API_KEY="your-hex-appsignal-key"
```

For more information about configuring the AppSignal package for Elixir, please
read our [configuration documentation](/elixir/configuration/index.html).

## Application environment and version

Running your application you want to let AppSignal know what state your
application is in.

This includes information about the version (revision) of your application and
what environment it's running in.

A typical environment configuration file would contain the following.

```elixir
# config/prod.exs
config :appsignal, :config,
  name: :my_first_app,
  push_api_key: "your-hex-appsignal-key",
  env: :prod,
  revision: Mix.Project.config[:version]
```

## Run your application!

Once you've completed this guide your application is ready to be monitored by
AppSignal!

Start your application up and perform some requests on it. By triggering an
error or two you'll also test the error reporting.

[Contact us][support] if you have questions regarding installation or
encountered any problems during the installation.

## Optional: Activate more instrumentation in your Phoenix app

Read more about how you can integrate more instrumentation in your Phoenix
application in our [integrating Phoenix
guide](/elixir/integrations/phoenix.html).

## Optional: Adding custom instrumentation

Add custom instrumentation to your application. Read more about custom
instrumentation in our [instrumentation
documentation](/elixir/instrumentation/index.html).

[support]: mailto:support@appsignal.com
[elixir-repo]: https://github.com/appsignal/appsignal-elixir
[docs-repo]: https://github.com/appsignal/appsignal-docs
[phoenix]: http://www.phoenixframework.org/
