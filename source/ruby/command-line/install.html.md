---
title: "AppSignal for Ruby: Install"
description: "Command line tool to install AppSignal in a Ruby application. Documentation on usage, options and configuration methods."
---

Command line tool to install AppSignal in a Ruby application.

## Description

The command line tool is primarily used to help set up the configuration for AppSignal. Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

Full integration works automatically for Rails. Other frameworks get referred to
our documentation pages for [integrations](/ruby/integrations/).

Integration with application using non-Rails frameworks is complicated to do automatically because our installer doesn't know exactly how an application is set up.

After the configuration/installation is completed the installer perform the [demonstration](demo.html) command line tool and sends demo data to AppSignal servers to help with the installation wizard.

## Configuration methods

There are two configuration methods the installer provides: using a configuration file or using environment variables.

### 1. An `config/appsignal.yml` configuration file

It's possible to configure AppSignal with a configuration file. The AppSignal gem looks for this file at `config/appsignal.yml`, which is where our installer will write the configuration to.

When this option is chosen the given Push API key is written to the configuration file. We do not recommend checking this key into version control (git/svn/mercurial/etc). Instead, use the `APPSIGNAL_PUSH_API_KEY` environment variable as described in the generated `appsignal.yml` file.

See the [configuration documentation](/ruby/configuration) for more information.

### 2. Environment variables

It's possible to configure AppSignal using only system environment variables. When this option is selected no configuration is written to the file system. See the [configuration documentation](/ruby/configuration) for more information.

## Usage

On the command line in your project run:

```bash
appsignal install <Push API key>
# For example
appsignal install 1234-1234-1234-1234
```

Where your "Push API key" can be found in the [installation wizard](https://appsignal.com/redirect-to/organization?to=sites/new) for your organization.

## Options

| Option | Description |
| ------ | ----------- |
| `--[no-]color` | Toggle the colorization of the output. |

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.
