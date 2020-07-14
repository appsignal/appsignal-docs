---
title: "Ruby on Rails"
---

[Ruby on Rails](http://rubyonrails.org/) is supported out-of-the-box by AppSignal. To install follow the installation steps in AppSignal, start by clicking 'Add app' on the [accounts screen](https://appsignal.com/accounts).

The AppSignal integration for Rails works by tracking exceptions and performance in requests. When an error occurs in a controller during a request AppSignal will report it. Performance issues will be based on the duration of a request and create a timeline of events detailing which parts of the application took the longest.

## Active Job

Support for Active Job for all adapters is available in Ruby gem 2.11.0 and newer.

See our [Active Job page](active-job.html) for more information.

## Error reporting during start-up

By default AppSignal does not report errors that occur during the start/boot of your application. To do get notified when these errors occur, adding the following to your `config.ru` file, around the line that requires the `environment.rb` file.

```ruby
# config.ru
begin
  require ::File.expand_path("../config/environment",  __FILE__)
rescue Exception => error
  Appsignal.send_error(error)
  raise
end
```

The errors that occur here will not be grouped under an incident with an action name.

## Background jobs

AppSignal supports ActiveJob for several background job libraries, such as Sidekiq. Please see the full list of Ruby [library integrations](/ruby/integrations) for more details.

## Backtrace cleaner

With the Rails integration, AppSignal will run the backtrace of each exception through the [Rails backtrace cleaner][backtrace cleaner docs]. This cleaner gives you the option to modify or filter out unwanted backtrace lines, removing clutter and noise from the backtrace.

You can add or remove filters and silencers to the default configuration.

**Filters** will mutate the given line. An example would be to remove the `Rails.root` prefix.

**Silencers** will remove the line from the backtrace, if the given expression returns `true`. You can add these additional backtrace cleaner rules in an initialize.

For example:

```ruby
# config/initializers/backtrace_cleaner.rb
bc = Rails.backtrace_cleaner
bc.add_filter { |line| line.gsub(Rails.root.to_s, '<root>') }
bc.add_silencer { |line| line.index('<root>').nil? and line.index('/') == 0 }
bc.add_silencer { |line| line.index('<root>/vendor/') == 0 }
```

For more information about the backtrace cleaner, see the [Rails BacktraceCleaner documentation][backtrace cleaner docs].

[backtrace cleaner docs]: https://api.rubyonrails.org/classes/ActiveSupport/BacktraceCleaner.html
