---
title: "Sidekiq"
---

[Sidekiq](http://sidekiq.org) is a simple and efficient background processor
for Ruby. It's also the processor we use to process jobs in AppSignal.

Support for Sidekiq was added in AppSignal Ruby gem version `0.8`.

## Using with Rails

The AppSignal Ruby gem automatically inserts a listener into the Sidekiq server
middleware stack if the `Sidekiq` module is present if you use Rails. No further action is
required.

## Using standalone

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
