---
title: "Minutely probes"
---

Minutely probes are a mechanism to periodically send [custom metrics](/metrics/custom.html) to AppSignal. This is a system that is included in the AppSignal Ruby gem by default. At the start of every minute the minutely probes are triggered one by one to collect metrics and then snoozed until the next minute.

By default the AppSignal Ruby gem enables probes for [libraries](/ruby/integrations) that are detected for your app.

-> **Note**: This feature is turned on by default in AppSignal Ruby gem `2.9.0` and up.

-> **Note**: We recommend using AppSignal Ruby gem `2.9.0` and up when using this feature.

## Table of Contents

- [Usage](#usage)
  - [Multiple instances](#multiple-instances)
- [Configuration](#configuration)
- [Creating probes](#creating-probes)
  - [Lambda probe](#lambda-probe)
  - [Class probe](#class-probe)
  - [Initialized class probe](#initialized-class-probe)
- [Registering probes](#registering-probes)
  - [Deprecated registration method](#deprecated-registration-method)
- [Overriding default probes](#overriding-default-probes)

## Usage

The minutely probes allow the AppSignal Ruby gem to collect [custom metrics](/metrics/custom.html) by default for [integrations](/ruby/integrations) and app-specific metrics by [creating your own probe](#creating-probes).

### Multiple instances

Once activated, the minutely probes system runs on every instance of an app. This means that if a probe report metrics without some kind of differentiating tag, global metrics may be overwritten by instance-level metrics. For example, there's a probe that tracks how large the local background job queue is for an app. The queue database runs locally on the instance and queue sizes may vary wildly. Each instance of an app reports different metric values for the same metric and tags, overwriting the metric value every minute with those of the last reporting instance.

To remedy this, we suggest [tagging](/metrics/custom.html#metric-tags) your metrics with the hostname or something else unique for each instance. For example, the [Sidekiq probe](/ruby/integrations/sidekiq.html#minutely-probe) tags metrics with the Redis hostname by default.

Alternatively you can [disable minutely probes](/ruby/configuration/options.html#option-enable_minutely_probes) for all but one instance, on which the minutely probes process is run. We suggest using the [`APPSIGNAL_ENABLE_MINUTELY_PROBES`](/ruby/configuration/options.html#option-enable_minutely_probes) environment variable to only enable it on the instance of your choosing.

## Configuration

The minutely probes are configured using the [`enable_minutely_probes`](/ruby/configuration/options.html#option-enable_minutely_probes) config option. This is set to `true` by default in Ruby gem `2.9.0` and up.

## Creating probes

If you want to track more [custom metrics](/metrics/custom.html) from your app than our the default probes that ship with our [integrations](/ruby/integrations/), you can add your own probe(s).

An AppSignal minutely probe can be either of three things. Which of the three types to use for your class depends on the use case.

- [Lambda probe](#lambda-probe)
- [Class probe](#class-probe)
- [Initialized class probe](#initialized-class-probe)

### Lambda probe

The simplest probe type to register. If you have no dependencies for your probe this is the preferred method.

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot
Appsignal::Minutely.probes.register :my_probe, lambda do
  Appsignal.set_gauge("database_size", 10)
end
```

### Class probe

A class probe is a lazy initialized probe. It will only be started if the Minutely probes are started. It will be initialized at the start of the minutely probes thread and remain initialized for as long as your app is running.

This method is useful when you do not have [`enable_minutely_probes`](/ruby/configuration/options.html#option-enable_minutely_probes) enabled for every environment and don't want it to be initialized by default.

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot

# Creating a probe using a Ruby class
class BackgroundJobLibraryProbe
  def initialize
    # This is only called when the minutely probe gets initialized
    require "background_job_library"
    @connection = BackgroundJobLibrary.connection
  end

  def call
    stats = @connection.fetch_queue_stats
    Appsignal.set_gauge "background_job_library_queue_length", stats.queue_length
    Appsignal.set_gauge "background_job_library_processed_jobs", stats.processed_jobs
  end
end

# Registering a Class probe
Appsignal::Minutely.probes.register(
  :background_job_library_probe,
  BackgroundJobLibraryProbe
)
```

### Initialized class probe

This method is most useful for [overriding default probes](#overriding-default-probes). The AppSignal Ruby gem ships some probes for [integrations](/ruby/integrations) by default. These default probes register probes as a [class](#class-probe) so they won't be initialized when overridden. When the probe default config does not fit your use case you can [override a default probe](#overriding-default-probes) with your own config.

Note that we do not register a [class as a probe](#class-probe), but an instance of the class using `.new` and pass along a config object, e.g. `BackgroundJobLibraryProbe.new(<config>)`.

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot
require "background_job_library"

# Creating a probe using a Ruby class
class BackgroundJobLibraryProbe
  def initialize(config)
    @connection = BackgroundJobLibrary.connection(config)
  end

  def call
    stats = @connection.fetch_queue_stats
    Appsignal.set_gauge "background_job_library_queue_length", stats.queue_length
    Appsignal.set_gauge "background_job_library_processed_jobs", stats.processed_jobs
  end
end

# Registering an initialized Class probe
Appsignal::Minutely.probes.register(
  :visit_tracking_probe,
  VisitTrackingProbe.new(:database => "redis://localhost:6379")
)
```

## Registering probes

Probes can be registered with the `register` method on the `Appsignal::Minutely.probes` collection.
This method accepts two arguments.

- `key` - This is the key/name of the probe. This will be used to identify the probe in case an error occurs while executing the probe (which will be logged to the [appsignal.log file](/support/debugging.html#logs)) and to [override an existing probe](#overriding-default-probes).
- `probe` - This is one of the [supported probe types](#creating-probes) that should be called every minute to collect metrics.

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot

Appsignal::Minutely.probes.register :my_probe, lambda do
  Appsignal.set_gauge("database_size", 10)
end
```

### Rails apps

AppSignal minutely probes need to be registered while your Rails app boots. We recommend registering probes in an AppSignal initializer: `config/initializers/appsignal.rb`.

### Ruby apps

Register you probe in a file that's called on boot before `Appsignal.start` is called. For pure-Ruby/non-Rails apps probes needs to be registered in a file that's loaded on boot.

See also [Integrating AppSignal](/ruby/instrumentation/integrating-appsignal.html) for instructions how to integrate AppSignal in your app.

### Deprecated registration method

In the AppSignal Ruby gem `2.8.x` and lower the method of registering probes was slightly different. While it wil register your probe and call it every minute, this method of registering probes is deprecated. This method will be removed in the next major version of the Ruby gem.

```ruby
# DEPRECATED REGISTRATION METHOD
Appsignal::Minutely.probes << lambda { puts "hello" }
```

If you use this method, please update the registration method as described in [adding your own probe](#adding-your-own-probe).

## Overriding default probes

AppSignal ships with default probes for certain [integrations](/ruby/integrations/). If for any reason this probe does not function properly or requires some additional configuration for your use case, you can override the default probe by [initializing the probe class](#initialized-class-probe) with your own config.

Example overriding the [Sidekiq probe](/ruby/integrations/sidekiq.html#minutely-probe).

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot

Appsignal::Minutely.probes.register(
  :sidekiq, # Use the same key as the default Sidekiq probe to override it
  Appsignal::Hooks::SidekiqProbe.new(:hostname => ENV["REDIS_URL"])
)
```

(Note that you'll need to set the `REDIS_URL` environment variable yourself.)

Overriding probes will log a debug message in the [appsignal.log file](/support/debugging.html#logs) which can help to detect if a probe is correctly overridden.
