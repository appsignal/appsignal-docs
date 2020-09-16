---
title: "Resque"
---

[Resque](https://github.com/resque/resque) is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later.

-> Support for Resque instrumentation was added in AppSignal for Ruby gem version `0.8`.  
-> Support for automatic Resque instrumentation was added in AppSignal for Ruby gem version `2.11`.

## Integration

Since AppSignal Ruby gem 2.11 and newer Resque integration is automatic. If you have previously included or extended modules in your Resque job classes, they can now be removed.

### Older integration

In older versions of the AppSignal Ruby gem (2.10 and older) the following steps were needed to instrument Resque jobs. If you have upgraded to the latest version of the Ruby gem, these steps are no longer needed and will result in a deprecation warning being logged and printed.

It was needed to add an instrumentation module to Resque jobs classes.

```ruby
class MyWorker
  # Add the following line for older AppSignal Ruby gem versions
  extend Appsignal::Integrations::ResquePlugin

  def self.perform(*args)
    # ...
  end
end
```

## Active Job support

The Resque integration is compatible with [Active Job](active-job.html).

Upgrade to version 2.11.0 of the Ruby gem or newer for improved support.

### Older Active Job support

In older versions of the AppSignal Ruby gem (2.10 and older) the following steps were needed to instrument Resque jobs. If you have upgraded to the latest version of the Ruby gem, these steps are no longer needed and will result in a deprecation warning being logged and printed.

When using ActiveJob, it was needed to include `Appsignal::Integrations::ResqueActiveJobPlugin`.

```ruby
class MyActiveJobWorker < ApplicationJob
  # Add the following line for older AppSignal Ruby gem versions
  include Appsignal::Integrations::ResqueActiveJobPlugin

  queue_as :default

  def perform(*args)
    # ...
  end
end
```

## Example apps

We've added a Rails 5 + Resque [example app](https://github.com/appsignal/appsignal-examples/tree/rails-5+resque) to our [examples repository](https://github.com/appsignal/appsignal-examples). Please take a look if you're having trouble getting AppSignal for Resque configured.
