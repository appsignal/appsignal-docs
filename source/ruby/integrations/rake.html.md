---
title: "Rake task monitoring"
---

The AppSignal gem version supports [Rake][rake] since version `0.11.13` of the gem.

Every exception recorded in a Rake task will be sent to AppSignal and filed under the "Background" [namespace](/application/namespaces.html). Note that we only track exceptions in Rake tasks. There is no performance monitoring for Rake tasks.

(To manually integrate performance monitoring in select Rake tasks please see our [integration guide][integration] and [custom instrumentation guide][custom-instrumentation].)

Depending on what version of the AppSignal gem you use and in what context some manual steps are required.

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

Some scenarios require `Appsignal.stop` to be called to report the AppSignal data from in Rake tasks. `Appsignal.stop` flushes all data from the application to the AppSignal agent and sends it to the AppSignal servers.

This method is called for you when an error is raised in a task.

```ruby
# Rakefile
task :foo do
  # Is automatically sent to AppSignal
  raise "My error"
end
```

Tasks that do not raise an error, but call [`Appsignal.send_error`](/ruby/instrumentation/exception-handling.html#appsignal-send_error) or any of the [custom metrics](/metrics/custom.html) helper methods, need to call `Appsignal.stop` after the task is finished.

```ruby
# Rakefile
task :foo do
  # Helper methods that require an `Appsignal.stop` call if no error is raised
  Appsignal.send_error StandardError.new("bar")
  # Custom metrics helpers: https://docs.appsignal.com/metrics/custom.html
  Appsignal.increment_counter "my_custom_counter"

  # Called as the very last thing in the task
  # The argument "rake" is the name of the parent process name which is being
  # stopped and logs it as the reason why AppSignal is stopping.
  Appsignal.stop "rake"
end
```

For short lived hosts, such as containers and Heroku schedulers, an additional step needs to be taken to ensure the AppSignal agent has time to send the data before the host is shut down. Read on in the next section.

## Rake tasks and containers

When running a single Rake task on a one-off host (e.g. with Docker containers, Kubernetes or Heroku schedulers) there are three requirements. This guarantees that the app AppSignal extension has time to flush the data to the agent and the agent has time to send the data to our API before shutting (the container) down.

* [`Appsignal.stop`](#appsignal-stop-requirement) must be called in the Rake task
* [`running_in_container`](/ruby/configuration/options.html#option-running_in_container) must be set to true in the config.
  * For some containers `running_in_container` is automatically set to true when detected, for others manual configuration is required.
* A sleep of e.g. 5 seconds to give AppSignal agent time to sent the data

An example of how Appsignal.stop is called in the Rakefile:

```ruby
# Rakefile
# One-off host example task
task :foo do
  # Tracking data with AppSignal
  Appsignal.increment_counter "my_custom_counter"

  # Called as the very last thing in the task
  # The argument "rake" is the name of the parent process name which is being
  # stopped and logs it as the reason why AppSignal is stopping.
  Appsignal.stop "rake"
  sleep 5 # For one-off hosts, give the AppSignal agent time to send the data
end
```

**Note**: A sleep of 5 seconds was added to the end of the Rake task example in the example above. This is required for tasks that are run on one-off hosts. When the task completes, the process stops. The `Appsignal.stop` call flushes all the transaction data currently in the AppSignal extension to our agent. It then sleeps for 5 seconds to allow the agent to send the data before shutting down.

## Examples

### Rake application

See our example repository for a [Ruby + Rake + AppSignal][ruby-rake-example] example application.

[rake]: https://github.com/ruby/rake
[integration]: /ruby/instrumentation/integrating-appsignal.html
[custom-instrumentation]: /ruby/instrumentation/instrumentation.html
[ruby-rake-example]: https://github.com/appsignal/appsignal-examples/tree/ruby-rake
