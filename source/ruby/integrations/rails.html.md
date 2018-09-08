---
title: "Ruby on Rails"
---

[Ruby on Rails](http://rubyonrails.org/) is supported out-of-the-box by AppSignal. To install follow the installation steps in AppSignal, start by clicking 'Add app' on the [accounts screen](https://appsignal.com/accounts).

The AppSignal integration for Rails works by tracking exceptions and performance in requests. When an error occurs in a controller during a request AppSignal will report it. Performance issues will be based on the duration of a request and create a timeline of events detailing which parts of the application took the longest.

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
