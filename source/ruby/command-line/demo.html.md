---
title: "AppSignal for Ruby: Demonstration tool"
---

The AppSignal gem ships with a command line tool used to send demonstration
samples to AppSignal. Upon running it, it sends an error and performance sample
to AppSignal from the user's machine.

This command line tool is useful when testing AppSignal on a system and
validating the local configuration. It tests if the installation of
AppSignal has succeeded and if the AppSignal agent is able to run on the
machine's architecture and communicate with the AppSignal servers.

The same test is also run during installation using [appsignal
install](/ruby/command-line/install.html).

Read more about how to use the demonstration command on the
[Debugging][debugging] page.

This tool is available since version 2.0.0 of the AppSignal Ruby gem.

## Usage

On the command line in your project run:

```bash
appsignal demo
```

To run it with a specific environment, see the [`--environment`](#environment-option) option.

```bash
appsignal demo --environment=production
```

### Standalone run

It's also possible to run `appsignal demo` without having to install AppSignal in an application. Since most of the [config options](/ruby/configuration/options.html) do not have CLI options, you'll need to use environment variables to configure AppSignal.

```bash
gem install appsignal
export APPSIGNAL_APP_NAME="My test app"
export APPSIGNAL_APP_ENV="test"
export APPSIGNAL_PUSH_API_KEY="xxxx-xxxx-xxxx-xxxx"
appsignal demo
```

## Options

| Option | Description |
| ------ | ------------|
| [`--environment=<environment>`](#environment-option) | Set the environment to use in the command, e.g. `production` or `staging`. |

### Environment option

By default no environment is selected. To make sure AppSignal can be started the correct environment needs to selected with the `--environment` option or the [`APPSIGNAL_APP_ENV` environment variable](/ruby/configuration/options.html#option-appsignal_app_env).

```bash
appsignal demo --environment=production
```

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.

[debugging]: /support/debugging.html
