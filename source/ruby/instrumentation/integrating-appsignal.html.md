---
title: "Integrating AppSignal in Ruby"
---

It's possible that AppSignal does not provide automatic integration for your
framework of choice, or maybe you're using your own application setup.

See our [list of supported integrations](/ruby/integrations/index.html) to see
what frameworks and gems we support with the AppSignal gem.

When AppSignal does not support something using the gem it's still possible to
to instrument applications. AppSignal needs to be configured and started once
at the beginning of a process. It can be
[configured](/ruby/configuration/index.html) through a configuration file or by
using environment variables.

## Configuration

### Environment variables

When using environment variables to configure AppSignal the gem will read the
configuration from the environment once it starts. It's as easy as calling
`Appsignal.start` at the beginning of a process.

```ruby
require "appsignal"
Appsignal.start
```

### Configuration file

When using a configuration file to configure AppSignal, the configuration needs
to be initialized beforehand to tell the gem where to look for its
configuration.

```ruby
require "appsignal"
Appsignal.config = Appsignal::Config.new(
  current_path,
  "production"
)
Appsignal.start
```

AppSignal will look in the path of the first argument for a `config/` directory
containing an `appsignal.yml` file to load the configuration. The second
argument is the environment it will load from the configuration file.

## Monitoring transactions

After setting up the configuration and starting AppSignal, AppSignal is ready
to monitor the process.

```ruby
# in a controller
Appsignal.monitor_transaction(
  "perform_job.processor",
  :class       => "EmailWorker",
  :method      => "perform",
  :metadata    => {},
  :params      => {},
  :queue_start => Time.now
) do
  yield
end
```

If the first argument starts with `perform_job` the transaction will be
recognized as a background job, if it starts with `process_action` it will be
recognized as an HTTP request.

Before your process exits it's necessary to call `Appsignal.stop` to make sure
that all the instrumentation data gets flushed to the AppSignal system agent
and doesn't get lost.

If your process always runs one job and immediately exits afterward you can use
the `Appsignal.monitor_single_transaction` helper instead. This will ensure
that AppSignal stops automatically.

```ruby
Appsignal.monitor_single_transaction(
  "perform_job.ping",
  :class       => "HourlyPing",
  :method      => "perform",
  :queue_start => Time.now
) do
  yield
end
```

## Example app

We have an [example application][example-app] in our examples repository on
GitHub. The example shows how to set up AppSignal with a simple Ruby
application.

[example-app]: https://github.com/appsignal/appsignal-examples/tree/ruby
