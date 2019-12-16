---
title: "Rake task monitoring"
---

The AppSignal gem version supports [Rake][rake] since version `0.11.13` of the gem.

Every exception recorded in a Rake task will be sent to AppSignal and filed under the "Background" [namespace](/application/namespaces.html). Note that we only track exceptions in Rake tasks. There is no performance monitoring for Rake tasks.

(To manually integrate performance monitoring in select Rake tasks please see our [integration guide][integration] and [custom instrumentation guide][custom-instrumentation].)

Depending on what version of the AppSignal gem you use and in what context some manual steps are required.

## Table of Contents

- [Integrations](#integrations)
  - [Rails applications](#rails-applications)
  - [Ruby applications](#ruby-applications)
- [`Appsignal.stop` requirement](#appsignal-stop-requirement)
- [Rake tasks and containers](#rake-tasks-and-containers)
- [Examples](#examples)

## Integrations

### Rails applications

For Rails applications make sure you depend on the `:environment` task. This loads the Rails application into memory and starts AppSignal as part of the application.

```ruby
# lib/tasks/my_task.rb

task :my_task => :environment do
  # do stuff
end
```

#### Rakefile

Your Rails application's `Rakefile` should look something like the example below. This should already be the case, no need to change it.

```ruby
# Rakefile
require File.expand_path("../config/application", __FILE__)

# Only require this file for gem version < 1.0
# require "appsignal/integrations/rake"

Rails.application.load_tasks
```

(For older versions of the AppSignal gem, versions `< 1`, you will need to require the Rake integration manually. It is automatically loaded for version `1.x` and higher.)

### Ruby applications

For pure Ruby applications some extra steps are required to load AppSignal. AppSignal needs to be required, configured and loaded. See also our [integration guide][integration].

```ruby
# Rakefile
require "appsignal"

Appsignal.config = Appsignal::Config.new(Dir.pwd, "development")
Appsignal.start
Appsignal.start_logger

task :foo do
  raise "bar"
end
```

## `Appsignal.stop` requirement

To send data that's collected in your Rake tasks to the AppSignal servers, `Appsignal.stop` needs to be called. This is done for you when an error is raised in a task.

```ruby
# Rakefile
task :foo do
  # Is automatically sent to AppSignal
  raise "My error"
end
```

Tasks that do not raise an error, but do call `Appsignal.send_error` or any of the [custom metrics](/metrics/custom.html) helper methods, need to call `Appsignal.stop` before the task is finished.

```ruby
# Rakefile
task :foo do
  # Helper methods that require an `Appsignal.stop` call if no error is raised
  Appsignal.send_error StandardError.new("bar")
  # Custom metrics helpers: https://docs.appsignal.com/metrics/custom.html
  Appsignal.increment_counter "my_custom_counter"

  # "rake" is the parent process name which is being stopped and the reason why
  # AppSignal is stopping.
  Appsignal.stop "rake"
end
```

## Rake tasks and containers

When running a single Rake task in a container (e.g. with Kubernetes) there are two requirements:

* [`Appsignal.stop`](#appsignal-stop-requirement) must be set in the Rake task
* [`running_in_container`](/ruby/configuration/options.html#option-running_in_container) must be set to true in the config.
  * For some containers `running_in_container` is automatically set to true when detected, for others manual configuration is required.

These two options guarantee that the extension has time to push the data to the agent and the agent has time to send the data to our API before shutting (the container) down.

```ruby
# Rakefile
# One-off container example task
task :foo do
  # Tracking data with AppSignal
  Appsignal.increment_counter "my_custom_counter"

  # "rake" is the parent process name which is being stopped and the reason why
  # AppSignal is stopping.
  Appsignal.stop "rake"
  sleep 35 # For one-off containers
end
```

**Note:** A sleep of 35 seconds was added to the end of the Rake task example. This is recommended for tasks that are run on one-off containers. When the task completes the process stops. The `Appsignal.stop` method call flushes all the transaction data currently in the AppSignal extension to our agent. There it is [transmitted on a 30 second interval](/appsignal/how-appsignal-operates.html#agent). The one-off container may have exited before that time. To ensure the data is still transmitted, it needs to wait for 35 seconds.

## Examples

### Rake application

See our example repository for a [Ruby + Rake + AppSignal][ruby-rake-example] example application.

[rake]: https://github.com/ruby/rake
[integration]: /ruby/instrumentation/integrating-appsignal.html
[custom-instrumentation]: /ruby/instrumentation/instrumentation.html
[ruby-rake-example]: https://github.com/appsignal/appsignal-examples/tree/ruby-rake
