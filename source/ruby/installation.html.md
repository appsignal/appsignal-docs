---
title: "Installing AppSignal for Ruby"
---

Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

## Table of Contents

- [Installation](#installation)
  - [Requirements](#requirements)
  - [Installing the gem](#installing-the-gem)
- [Uninstall](#uninstall)

## Installation

Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

### Requirements

Before you can compile the AppSignal gem make sure the build/compilation tools are installed for your system. Please check the [Supported Operating Systems](/support/operating-systems.html) page for any system dependencies that may be required.

### Installing the gem

We recommend you install and manage the AppSignal gem dependency with
[Bundler](http://bundler.io/).

Add the following line to your `Gemfile`.

```ruby
# Gemfile
source "https://rubygems.org"

gem "appsignal"
```

Then run `bundle install` to install the gem.

To install AppSignal in your application we recommend you run the `appsignal install` command. Please provide it with your [Push API key](/appsignal/terminology.html#push-api-key) to configure it properly.

```sh
bundle exec appsignal install YOUR_PUSH_API_KEY
```

This will present you with an installation script that can integrate automatically in some frameworks and gems and will allow you to configure AppSignal.

For more information on how to integrate AppSignal into your application see the [integrations documentation](/ruby/integrations/index.html) to see what steps are necessary.

## Uninstall

Uninstall AppSignal from your app by following the steps below. When these steps are completed your app will no longer send data to the AppSignal servers.

1. In the `Gemfile` of your app, delete the `gem "appsignal"` line.
1. Run `bundle install` to update your `Gemfile.lock` with the removed gem state.
1. Remove any AppSignal [configuration files](/ruby/configuration/) from your app.
  - Configuration file location: `config/appsignal.yml`
1. Remove any system environment variables from your development, staging, production, etc. hosts.
  - Environment variables prefixed with `APPSIGNAL_`
  - Environment variable [`APP_REVISION`](/ruby/configuration/options.html#option-revision)
1. Commit, deploy and restart your app.
  - This will make sure the AppSignal servers won't continue to receive data from your app.
1. Optional: Make sure no `appsignal-agent` processes are running in the background.
  - Check the output of `ps aux | grep appsigal-agent` and kill the processes still running.
1. Finally, [remove the app](/application/#removing-an-application) on AppSignal.com
