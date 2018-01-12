---
title: "Exception handling"
---

By default AppSignal tries to record as many exceptions as possible. With [our
integrations](/ruby/integrations/index.html) for many frameworks and background
job gems, not a lot of exceptions will slip past.

In most applications, some errors will get raised that aren't related to
possible bugs in your code--they just happen when your app gets into contact
with the real world. Bots might drop by and try to automatically post forms,
outdated links might direct visitors to content that doesn't exist anymore and
so on.

To avoid these errors from being raised as problems in AppSignal it's possible
to add exception handling to your code or even let AppSignal completely ignore
certain errors.

## Table of Contents

- [Ignore errors](#ignore-errors)
- [Exception handling](#exception-handling)
  - [Rails rescue_from](#rails-rescue_from)
  - [Handle 404s](#handle-404s)
  - [Handle invalid authenticity tokens](#handle-invalid-authenticity-tokens)
  - [Handle hacking attempts](#handle-hacking-attempts)
- [Appsignal.set_error](#appsignal-set_error)
  - [Tagging](#appsignal-set_error-tagging)
  - [Namespaces](#appsignal-set_error-namespaces)
- [Appsignal.send_error](#appsignal-send_error)
  - [Tagging](#appsignal-send_error-tagging)
  - [Namespaces](#appsignal-send_error-namespaces)
- [Appsignal.listen_for_error](#appsignal-listen_for_error)

## Ignore errors

The AppSignal configuration makes it possible to [ignore
errors](/ruby/configuration/ignore-errors.html). By providing a list of
specific errors AppSignal will not send alerts when these errors are raised.

## Exception handling

Simply ignoring an error will silence notifications, but could potentially hide
a bigger problem. For this reason we recommend you add exception handling with
`begin .. rescue` blocks to your application.

Using `begin .. rescue` you can catch specific exceptions and add an
alternative code path for when an exception occurs, such as rendering 404 pages
or providing the user with more detailed error messages about what went wrong.

```ruby
begin
  user = Post.find(1)
rescue RecordNotFound => e
  render :text => "Could not find post", :status => 404
end
```

There's a couple of scenarios that should be handled like this to provide
proper HTTP responses when resources don't exist or when a form submission
fails.

Read our primer on [Exception
handling](http://blog.appsignal.com/blog/2016/10/18/ruby-magic-exceptions-primer.html)
for more information on how it works and how to implement it correctly.

### Rails rescue_from

Rails provides a mechanism to handle exceptions on controller-level. By
defining a `rescue_from` statement for a specific error it's possible to create
an alternative code path for when that exception is raised. Because this can be
defined on any controller level this makes it possible to add application-level
exception handling.

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def record_not_found
    render :text => "404: Resource not found", :status => 404
  end
end
```

More information about `rescue_from` can be found in the Rails guide about
[ActionController](http://guides.rubyonrails.org/action_controller_overview.html#rescue-from).

### Handle 404s

If a visitor hits a URL that cannot be handled by your routing or controller
Rack and other frameworks will raise an exception. It's usually a good idea to
handle these exceptions with a 404 response for your users.

In controllers where a `find` operation is performed based on a parameter from
an URL, it's recommended you handle `ActiveRecord::RecordNotFound` (or the
equivalent in your ORM of choice) to show a 404 response as well. This can hide
real bugs though, so it should be done with care.

### Handle invalid authenticity tokens

Rails has a mechanism that protects your forms from being filled out by
bots too easily. Any time a form is posted without a correct authenticity
token a `ActionController::InvalidAuthenticityToken` will be raised.

Sometimes legitimate users can run into these errors as well, so it's a good
idea to have a separate error page explaining what went wrong. We advise to
return this page with a 422 (Unprocessable Entity) response.

### Handle hacking attempts

You might get errors because bots or hackers are trying to exploit security
issues such as the notorious YAML exploit. Newer versions of Rails will throw a
`Hash::DisallowedType` when this happens. A `RangeError` is also often a result
of a hacking attempt. You could rescue these type of errors and return a 403
(Forbidden) response.

## Appsignal.set_error

-> **Note:** This feature was introduced in version `0.6.6` of the Ruby gem.

There are scenarios where you have your own exception handling and don't want to crash the Ruby process. By adding your own exception handling the error is no longer bubbled up to the AppSignal integration and thus not recorded automatically.

If you still want to track the error you can use `Appsignal.set_error` to add the exception to the current AppSignal transaction. The error will be recorded in AppSignal, but your process will not crash.

```ruby
require "yaml"
begin
  YAML.load(File.read("config.yml"))
rescue SystemCallError => exception
  Appsignal.set_error(exception)
  puts "No config file found. Using defaults."
end
```

The exception will be tracked by AppSignal like any other error, and it allows you to provide custom error handling and fallbacks.

```ruby
require "yaml"
Appsignal.monitor_transaction "process_action" do
  begin
    YAML.load(File.read("config.yml"))
  rescue SystemCallError => exception
    Appsignal.set_error(exception)
    puts "No config file found. Using defaults."
  end
end
```

-> **Note:** This method only works when there is an AppSignal transaction active. Otherwise the error will be ignored. This is true in most automatically supported integrations and when using `Appsignal.monitor_transaction`. Please see [`Appsignal.send_error`](#appsignal-send_error) for sending errors
without an AppSignal transaction.

###^appsignal-set_error Tagging

Optionally you can can pass in a hash with tags as the second argument.

See our [Tagging guide](tagging.html) for more information about the tagging parameter data structure.

```ruby
begin
  # some code
rescue => e
  Appsignal.set_error(e, :key => 'value')
end
```

-> **Note**: Tagging argument is available since version 2.3.0 of the AppSignal for Ruby gem.

###^appsignal-set_error Namespaces

Optionally you can can pass in custom namespace name as the third argument. This error will then be reported under the specified namespace rather than the default namespace.

See our [Namespaces](/application/namespaces.html) page for more information about using namespaces.

```ruby
begin
  # some code
rescue => e
  Appsignal.set_error(e, {}, "admin")
end
```

-> **Note**: Namespaces argument is available since version 2.3.0 of the AppSignal for Ruby gem.

## Appsignal.send_error

-> **Note:** This feature was introduced in version `0.6.0` of the Ruby gem.

AppSignal provides a mechanism to track errors that occur in code that's not in a web or background job context, such as separate Ruby tasks.

This is useful for instrumentation that doesn't automatically create AppSignal transactions to profile, such as our [integrations](/ruby/integrations).

You can use the `Appsignal.send_error` method to directly send an exception to AppSignal from any place in your code without starting an AppSignal transaction with `Appsignal.monitor_transaction` first.

```ruby
begin
  # some code
rescue => e
  Appsignal.send_error(e)
end
```

Exceptions sent with `Appsignal.send_error` will not have an extended context including the action name or Rake task name included in the error incident. This context can currently only be set in an [integration](/ruby/integrations) and all errors will be reported to the `web` namespace by default. See the [namespaces](#appsignal-send_error-namespaces) section for more information on how to customize this.

### Short-lived Ruby processes

The previous example is only useful in a long-living Ruby process, such as a web server or background job worker process.

If your Ruby process is short-lived, such as a Rake task or cron job, you will need to explicitly tell AppSignal the process will be stopped. This will allow AppSignal to flush all of its data from memory to our [agent](/appsignal/terminology.html#agent) and send it to our servers.

```ruby
begin
  # some code
rescue => e
  Appsignal.send_error(e)
  # "task" is the parent process name which is being stopped and the reason why
  # AppSignal is stopping.
  Appsignal.stop("task")
end
```

For another example of `Appsignal.send_error` in such a context see our [Rake integration page](/ruby/integrations/rake.html#ruby-applications).

###^appsignal-send_error Tagging

Optionally you can can pass in a hash with tags as the second argument.

See our [Tagging guide](tagging.html) for more information about the tagging parameter data structure.

```ruby
begin
  # some code
rescue => e
  Appsignal.send_error(e, :key => 'value')
end
```

###^appsignal-send_error Namespaces

Optionally you can can pass in custom namespace name as the third argument. This error will then be reported under the specified namespace rather than the default namespace.

See our [Namespaces](/application/namespaces.html) page for more information about using namespaces.

```ruby
begin
  # some code
rescue => e
  Appsignal.send_error(e, {}, "admin")
end
```

## Appsignal.listen_for_error

An alternative way to track errors with AppSignal is to wrap code that might
raise an exception in a `listen_for_error` block. If an exception gets raised
within that block it's automatically tracked by AppSignal and re-raised. This
allows the application and frameworks to handle exception as normal.

```ruby
require "rake"
require "appsignal"

task :fail do
  Appsignal.listen_for_error do
    raise "I am an exception in a Rake task"
  end
end
```
