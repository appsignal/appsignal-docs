---
title: "Sidekiq"
---

[Sidekiq](http://sidekiq.org) is a simple and efficient background processor for Ruby. It's also the processor we use to process jobs in AppSignal.

Support for Sidekiq was added in AppSignal Ruby gem version `0.8`.

## Table of Contents

- [Job naming](#job-naming)
- [Usage](#usage)
  - [Using with Rails](#usage-with-rails)
  - [Using with Active Job](#usage-with-active-job)
  - [Using standalone](#usage-standalone)
- [Metrics](#metrics)
- [Minutely probe](#minutely-probe)
  - [Configuration](#minutely-probe-configuration)

## Job naming

Job names are automatically detected based on the Sidekiq worker class name and are suffixed with the `perform` method name, resulting in something like: `MyWorker#perform`.

If your app is using the Sidekiq [delayed extensions](https://github.com/mperham/sidekiq/wiki/Delayed-extensions), please upgrade to AppSignal Ruby gem version `2.4.1` or higher as support for this extension was improved.

You can recognize events from Sidekiq with the name `perform_job.sidekiq` in the event timeline on the performance incident detail page.

## Usage

### Using with Rails

The AppSignal Ruby gem automatically inserts a listener into the Sidekiq server middleware stack if the `Sidekiq` module is present if you use Rails. No further action is required.

### Using with Active Job

The Sidekiq integration is compatible with [Active Job](active-job.html).

Upgrade to version 2.11.0 of the Ruby gem or newer for improved support.

### Using standalone

If you use Sidekiq without Rails some additional setup is required. Add this snippet to your Sidekiq config with the right environment and name:

```ruby
require 'appsignal'

Sidekiq.on(:startup) do
  # Load config
  Appsignal.config = Appsignal::Config.new(
    Dir.pwd,
    ENV['APPSIGNAL_APP_ENV'],        # Set environment here
    :name   => 'Sidekiq standalone', # Set app name here
  )

  # Start Appsignal
  Appsignal.start
  # Initialize the logger
  Appsignal.start_logger
end

Sidekiq.on(:shutdown) do
  # Stop the agent
  Appsignal.stop('Sidekiq shutdown')
end
```

## Metrics

The Sidekiq integration will report the following [metrics](/metrics/custom.html) for every processed job.

- `sidekiq_queue_job_count` - [counter](/metrics/custom.html#counter)
  - Counter is incremented for every processed job.
  - Tags:
      - Tag `queue`: Name of the queue, e.g. `default` or `critical`. Will fall back on `unknown` if it cannot be detected.
      - Tag `status`:
          - `processed` - every job that's been processed, includes `failed` jobs.
          - `failed` - every job that's failed while being processed.

## Minutely probe

-> **Note**: Requires [Redis gem](https://rubygems.org/gems/redis/) 3.3.5 or higher.  
-> **Note**: AppSignal Ruby gem 2.9.5 is recommended.

Since AppSignal Ruby gem `2.9.0` and up a [minutely probe](/ruby/instrumentation/minutely-probes.html) is activated by default. Once we detect these metrics we'll add a [magic dashboard](https://blog.appsignal.com/2019/03/27/magic-dashboards.html) to your apps.

This probe will report the following [metrics](/metrics/custom.html) grouped by `hostname` tag:

- `sidekiq_worker_count` - [gauge](/metrics/custom.html#gauge)
  - The total number of works active for the Sidekiq processes.
- `sidekiq_process_count` - [gauge](/metrics/custom.html#gauge)
  - The Sidekiq processes that are active.
- `sidekiq_connection_count` - [gauge](/metrics/custom.html#gauge)
  - How many connections were open to the Redis database.
- `sidekiq_memory_usage` - [gauge](/metrics/custom.html#gauge)
  - The Virtual Memory Size memory usage of Sidekiq itself.
- `sidekiq_memory_usage_rss` - [gauge](/metrics/custom.html#gauge)
  - The Resident Set Size memory usage of Sidekiq itself.
- `sidekiq_job_count` - [gauge](/metrics/custom.html#gauge)
  - Tag `status`:
      - `processed`: all processed jobs in this minute, this includes failed jobs.
      - `failed`: number of failed jobs in this minute.
      - `retry_queue`: number of jobs that were in the retry queue in this minute. These jobs have failed before and were scheduled by Sidekiq to be retried.
      - `died`: number of jobs that died in this minute. They have been retried the maximum amount of times and Sidekiq will stop retrying them.
      - `scheduled`: number of jobs that were in the "scheduled" queue. They have not been processed yet.
      - `enqueued`: number of jobs that were in the queue to be processed.
- `sidekiq_queue_length` - [gauge](/metrics/custom.html#gauge)
  - The queue length at the time of measurement.
  - Tag `queue`: Name of the queue, e.g. `default` or `critical`.
- `sidekiq_queue_latency` - [gauge](/metrics/custom.html#gauge)
  - The latency the queue experienced at the time of measurement. [Sidekiq calculates this](https://github.com/mperham/sidekiq/wiki/API) by subtracting the time the last job was enqueued from the time of measurement. This value is reported as milliseconds.
  - **Note**: Please upgrade to AppSignal Ruby gem 2.9.4 for accurate reporting for this metric.
  - Tag `queue`: Name of the queue, e.g. `default` or `critical`.

###^minutely-probe Configuration

This probe does its best to detect the hostname of the Redis instance your Sidekiq instance uses to store its queues. If the detection is not accurate ([let us know](mailto:support@appsignal.com)), it's possible to customize the hostname config by overriding the default Sidekiq probe.

First you'll need to [override the default sidekiq probe](/ruby/instrumentation/minutely-probes.html#overriding-default-probes) by registering a new probe with the same name (`:sidekiq`). This probe will need a configuration hash including the `:hostname` key, with the new hostname value. By specifying the `:hostname` config option the Sidekiq minutely probe, the metrics will be tagged with the given hostname value. The `:hostname` config option value is not used to establish a Redis or Sidekiq connection.

An example is listed below.

```ruby
# config/initializers/appsignal.rb or a file that's loaded on boot

# Ruby gem 2.11.0 and newer
Appsignal::Minutely.probes.register(
  :sidekiq, # Use the same key as the default Sidekiq probe to override it
  Appsignal::Probes::SidekiqProbe.new(:hostname => "my_sidekiq_hostname")
)

# Ruby gem 2.10.x and older
Appsignal::Minutely.probes.register(
  :sidekiq, # Use the same key as the default Sidekiq probe to override it
  Appsignal::Hooks::SidekiqProbe.new(:hostname => "my_sidekiq_hostname")
)
```

In version 2.11.0 of the Ruby gem the `SidekiqProbe` constant was moved to its own module. Upon calling the constant a warning will be printed and logged. Update to the new constant name `Appsignal::Probes::SidekiqProbe` to remove the warning.
