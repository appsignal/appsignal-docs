---
title: "Puma"
---

[Puma](http://puma.io/) was built for speed and parallelism. Puma is a small library that provides a very fast and concurrent HTTP 1.1 server for Ruby web applications.

Support for Puma was added in AppSignal Ruby gem version `1.0`.

## Usage

The AppSignal Ruby gem automatically inserts a listener into the Puma server. No further action is required.

## Minutely probe

-> **Note**: Puma 3.11.4 or higher required.

-> **Note**: Please upgrade to AppSignal gem 2.9.17 or higher for Puma clustered mode support. See [the configuration section](#minutely-probe-clustered-mode-configuration) for additional steps that may be required.

Since AppSignal Ruby gem `2.9.0` and up a [minutely probe](/ruby/instrumentation/minutely-probes.html) is activated by default. Once we detect these metrics we'll add a [magic dashboard](https://blog.appsignal.com/2019/03/27/magic-dashboards.html) to your apps.

To enable the minutely probe, add the AppSignal plugin to your Puma configuration. This plugin will ensure AppSignal is started in Puma's main process. Which allows us to track Puma metrics in its single and [clustered mode][clustered mode].

```ruby
# puma.rb
plugin :appsignal # Available Ruby gem 2.9.17 and higher
```

Your app may require [additional configuration](#minutely-probe-configuration) for AppSignal to start in the Puma main process to collect [metrics](#minutely-probe-metrics).

###^minutely-probe Metrics

This probe will report the following [metrics](/metrics/custom.html) grouped by `hostname` tag:

- `puma_workers` - [gauge](/metrics/custom.html#gauge)
  - Tag `type`:
      - `count`: number of currently running threads for this server.
      - `booted`: the total number of currently booted workers for this server.
      - `old`: the number of workers running the previous configuration/code of the server at the moment in time. These will be phased out by Puma as new workers start.
- `puma_threads` - [gauge](/metrics/custom.html#gauge)
  - Tag `type`:
      - `running`: number of currently running threads for this server.
      - `max`: maximum number of configured threads for this server.
- `puma_connection_backlog` - [gauge](/metrics/custom.html#gauge)
  - The number of established but unaccepted connections that are in the server backlog queue and still need to be processed.
- `puma_pool_capacity` - [gauge](/metrics/custom.html#gauge)
  - The total thread pool capacity of the Puma server, including the number of threads that are waiting to be booted.

###^minutely-probe Configuration

By default the Puma main process doesn't start your app. This means AppSignal isn't loaded by default either. To remedy this, add the AppSignal Puma plugin to your Puma config.

```ruby
# puma.rb
plugin :appsignal
```

If you do not load this plugin AppSignal will still attempt to load automatically on boot, which only works in [thread pool mode][thread pool] and [clustered mode][clustered mode] when calling `preload_app!` in your `puma.rb` configuration file.

Additional configuration may be required to load your app config and/or [secrets](#minutely-probe-configuration-secrets) as well in order to load the AppSignal config.

####^minutely-probe-configuration Secrets

If you use a library such as [Rails](https://guides.rubyonrails.org/security.html#custom-credentials) or [dotenv](https://github.com/bkeepers/dotenv) to manage your app's secrets and configure AppSignal, you will need to load these in your Puma configuration.

Using the Puma plugin AppSignal loads a minutely probe in Puma's main process. The rest of your app is not loaded by default in Puma's main process (unless you use `preload_app!`, which may not be suitable for your app). Without additional configuration the AppSignal config will fail to load and AppSignal will not start.

There are no hooks "on boot"-hook available in Puma to load your extra config in the main process. To load your additional config add it to the root of your `puma.rb` configuration file like in the example below.

```ruby
# puma.rb / config/puma.rb
plugin :appsignal # Add this plugin

# Rails secrets
# Add this line when using Rails secrets in your `config/appsignal.yml` file.
require "rails"

# Dotenv
# Add this section when using dotenv for secrets management
require "dotenv"
Dotenv.load
# or for Rails apps
require "dotenv/rails-now"

# Rest of your Puma config...
```

####^minutely-probe-configuration Hostname

This probe listens to the [`hostname` config option](/ruby/configuration/options.html#option-hostname) for the hostname tag added to all its metrics. If none is set it will try to detect it automatically. Use the `hostname` config option to set the hostname if you want to change the detected hostname.

###^minutely-probe Phased restart

Puma [phased restarts](https://github.com/puma/puma/blob/master/docs/restart.md) don't restart the main Puma process. This means that the AppSignal minutely probe does not get restarted either on a phased restart. If you have made changes to the AppSignal config, you will need to do a full restart of your Puma app afterward to have the configuration change take effect.

```sh
# Change AppSignal config, restart once using:
pumactl restart
# instead of
pumactl phased-restart
```

[thread pool]: https://github.com/puma/puma/#thread-pool
[clustered mode]: https://github.com/puma/puma/#clustered-mode
