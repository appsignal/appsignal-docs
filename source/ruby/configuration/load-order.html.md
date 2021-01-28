---
title: "AppSignal for Ruby load order"
---

The AppSignal Ruby gem can be configured in a couple different ways. Through an
initializer, with a configuration file or through environment variables.

!> In Ruby gem version 2.0 the load order changed! Step 4 and 5 were swapped,
   making sure that environment variables are loaded after the `appsignal.yml`
   configuration file. Read more about it in the [Pull Request on
   GitHub](https://github.com/appsignal/appsignal-ruby/pull/180).

The configuration is loaded in a five step process. Starting with the gem
defaults and ending with reading environment variables. The configuration
options can be mixed without losing configuration from a different option.
Using an initializer, a configuration file and environment variables together
will work.

## Load orders

- 1. [Gem defaults - `default`](#default)
- 2. [System detected settings - `system`](#system)
- 3. [Initial configuration - `initial`](#initial)
- 4. [`appsignal.yml` config file - `file`](#file)
- 5. [Environment variables - `env`](#env)

##=default 1. Gem defaults

The AppSignal gem starts with loading its default configuration, setting paths
and enabling certain features.

The agent defaults can be found in the [gem source]
(https://github.com/appsignal/appsignal-ruby/blob/main/lib/appsignal/config.rb)
as `Appsignal::Config::DEFAULT_CONFIG`.

This source is listed as `default` in the [diagnose](/ruby/command-line/diagnose.html) output.

##=system 2. System detected settings

The gem detects what kind of system it's running on and configures itself
accordingly.

For example, when it's running inside a container based system (such as Docker
and Heroku) it sets the configuration option `:running_in_container` to `true`.

This source is listed as `system` in the [diagnose](/ruby/command-line/diagnose.html) output.

##=initial 3. Initial configuration given to `Config` initializer

When manually creating a `Appsignal::Config` class you can pass in the
initial configuration you want to apply. This is a hash of any of the
options described below.

```ruby
Appsignal.config = Appsignal::Config.new(Dir.pwd, "production", {
  active: true,
  name: "My app!",
  push_api_key: "e55f8e96-62df-4817-b672-d10c8d924065"
})
```

This step will override all given options from the defaults or system
detected configuration.

This source is listed as `initial` in the [diagnose](/ruby/command-line/diagnose.html) output.

##=file 4. `appsignal.yml` config file

The most common way to configure your application is using the `appsignal.yml`
file. When you use the `appsignal install` command the gem will create one for
you.

The path of this configuration file is `{project_root}/config/appsignal.yml`.

This step will override all given options from the defaults, system
detected and initializer configuration.

This source is listed as `file` in the [diagnose](/ruby/command-line/diagnose.html) output.

##=env 5. Environment variables

Lastly AppSignal will look for its configuration in environment variables.
When found these will override all given configuration options from
previous steps.

```bash
export APPSIGNAL_APP_NAME="my custom app name"
# start your app here
```

This source is listed as `env` in the [diagnose](/ruby/command-line/diagnose.html) output.
