---
title: "Handle exceptions"
---

When you use AppSignal you can customize which exceptions get tracked and
you can handle exceptions in tasks or workers in addition to exceptions
in web actions that get tracked by default.

## Exceptions that you don't want to track

In most applications some errors will get triggered that aren't related
to possible bugs in your code, they just happen when your app gets into
contact with the real world. Bots might drop by and try to automatically
post forms, outdated links might direct visitors to content that doesn't
exist anymore and so on.

Rails provides a mechanism to handle such errors. You define a method
that handles the response to for that error and use `rescue_from` to
inform Rails which errors should be handled:

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end
end
```

There's a couple of scenario's that you're probably going to want to handle
like this.

### [Handling 404's](#404)

If a visitor hits a url that cannot be handled by your routing or
controller an `ActionController::RoutingError` or
`AbstractController::ActionNotFound` will be raised. It's usually a
good idea to handle these with a 404 response.

If you have controllers where a find is done based on a parameter for
the url you might want to handle `ActiveRecord::RecordNotFound` (or the
equivalent in your ORM of choice) the same way. This can hide real bugs
though, so it should be done with care.

### [Handling invalid authenticity tokens](#invalid_authenticity_tokens)

Rails has a mechanism that protects your forms from being filled out by
bots too easily. Any time a form is posted without a correct authenticity
token a `ActionController::InvalidAuthenticityToken` will be raised.

Sometimes legitimate users can run into these errors, so it's a good
idea to have a separate error page explaining what went wrong. We advise
to return this page with a status code of 422 (Unprocessable Entity).

### [Handling hacking attempts](#hacking-attempts)

You might get errors because bots or hackers are trying to exploit
security issues such as the notorious YAML exploit. Newer versions of
Rails will throw a `Hash::DisallowedType` if this happens. A RangeError is
also often a result of a hacking attempt. You could rescue these type of
errors and return a 403 (Forbidden) response.

Some further information about rescue from can be found in the Rails
guide about
[ActionController](http://guides.rubyonrails.org/action_controller_overview.html#rescue_from)

### [Don't want to use rescue_from?](#ignore-exceptions)

If you don't want to handle an exception with rescue_from you can add
exceptions that you want to ignore to the list of ignored exceptions in
config/appsignal.yml:

````
production:
  api_key: <%= ENV['APPSIGNAL_API_KEY'] %>
  active: true
  ignore_exceptions:
    - ActiveRecord::RecordNotFound
    - ActionController::RoutingError
`````

Any exceptions defined here will not be sent to AppSignal and will thus
not trigger notifications.

## [Tracking exceptions that you're rescuing](#tracking-when-handling)

If you want to handle certain exceptions in a custom way you can use
`Appsignal.add_exception` to add the exception to the current request.

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def record_not_found(exception)
    Appsignal.add_exception(exception)
    render :text => "404 Not Found", :status => 404
  end
end
```

The exception will be tracked in AppSignal like any other exception, but
you will be able to provide custom error handling for your user.

## [Tagging requests](#tagging-requests)

You can use the `Appsignal.tag_request` method to supply extra context on an error. 
This can help to add information that is not already part of the request, session or environment parameters.
Be careful not to include any personally identifyable information or sensitive information like authentication tokens.
This information will then be visible in AppSignal.
`Appsignal.tag_request` was introduced in version 0.6.3 of the gem.

You can use `Appsignal.tag_request` wherever the current request is accessible, we
recommend calling it in a `before_action`.

```ruby
Appsignal.tag_request(
   :locale => I18n.locale
)
```

There are a few limitations on tagging:

* The key must be a string or symbol
* The value must be a string, symbol or integer
* The length of the key and value must be less than 100 characters

```ruby
# Good, I18n.locale/default_locale returns a symbol
Appsignal.tag_request(
  locale: I18n.locale 
  default_locale: I18n.default_locale
)

# Bad, hash type is not supported
Appsignal.tag_request(
  i18n: {
    locale: I18n.locale 
    default_locale: I18n.default_locale
  }
)

# Bad, leaks personally identifyable information
Appsignal.tag_request(
  user_email: 'John.doe@example.com'
)
```

Tags that do not meet the limitations will be dropped without warning.
Request tagging currently only works for errors.

## [Track exceptions in cron jobs or scripts](#cron-jobs-scripts)

AppSignal provides a mechanism to track exceptions that occur in code
that's not in a web or background job context such as Rake tasks that get triggered by
cron jobs or scripts that run in the background. This was introduced in
version 0.6.0 of the gem.

You can use the `send_exception` method to directly send an exception to
AppSignal from any piece of your code.

````ruby
rescue Exception => e
Appsignal.send_exception(e)
````

An alternative way is to wrap code that might throw an exception you
want to track in a `listen_for_exception` block. If an exception gets
raised it's tracked in AppSignal and re-raised so you can add your own
error handling as well.

````ruby
require "rake"
require "appsignal"

task :fail do
  Appsignal.listen_for_exception do
    raise "I am an exception in a Rake task"
  end
end
````
