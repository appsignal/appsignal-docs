---
title: "AppSignal for Elixir: Install"
description: "Command line tool to install AppSignal in an Elixir application. Documentation on usage, options and configuration methods."
---

Command line tool to install AppSignal in an Elixir application.

The command line tool is primarily used to help set up the configuration for AppSignal. Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

After the configuration/installation is completed the installer perform the [demonstration](demo.html) command line tool and sends demo data to AppSignal servers to help with the installation wizard.

This tool is available since version 0.13.0 of the AppSignal for Elixir package.

## Configuration methods

There are two configuration methods the installer provides: using a configuration file or using environment variables.

### 1. Configuration file

It's possible to configure AppSignal with the Mix configuration. The AppSignal for Elixir package looks for the configuration loaded by Mix in the. Our installer will write the configuration to `config/appsignal.exs` and add an import to your other configuration file(s).

When this option is chosen the given Push API key is written to the configuration file. We do not recommend checking this key into version control (git/svn/mercurial/etc). Instead, use a `APPSIGNAL_PUSH_API_KEY` environment variable or a secrets management tool for your application.

See the [configuration documentation](/elixir/configuration) for more information.

### 2. Environment variables

It's possible to configure AppSignal using only system environment variables. When this option is selected no configuration is written to the file system. See the [configuration documentation](/elixir/configuration) for more information.

## Usage

On the command line in your project run:

```bash
mix appsignal.install <Push API key>
# For example
mix appsignal.install 1234-1234-1234-1234
```

Where your "Push API key" can be found in the [installation wizard](https://appsignal.com/redirect-to/organization?to=sites/new) for your organization.

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.
