---
title: "Event formatters"
---

Event formatters are helpers classes to format event metadata for AppSignal transactions. In the AppSignal gem, event formatters are used to format event metadata from [ActiveSupport::Notifications instrumentation][as_instrumentation] events to AppSignal event metadata.

When a block of code is instrumented by ActiveSupport::Notifications, AppSignal will record the event on the transactions, just like it would for the [`Appsignal.instrument` helper][instrument_helper]. Event formatters allow the data to be passed to the `ActiveSupport::Notifications.instrument` method call to be formatted for AppSignal events.

The metadata for the events formatted by the event formatters will be visible on performance incidents detail pages in the event timeline. Hover over a specific event and the on mouse hover pop-up will show details like the exact database being queried or the query that was executed.

-> **Note**: If there are no other reasons to use [`ActiveSupport::Notifications`][as_instrumentation] instrumentation than AppSignal instrumentation, we recommend using the [`Appsignal.instrument` helper][instrument_helper] for instrumentation. Using `ActiveSupport::Notifications` adds more overhead than directly calling `AppSignal.instrument`. No event formatter will be needed either, as `AppSignal.instrument` accepts the metadata to be set directly.

## Creating an event formatter

An AppSignal event formatter is a class with one instance method, `format`. This format method receives the event payload Hash and needs to return an Array with three values.

It's possible to add event formatter for libraries that use ActiveSupport::Notifications instrumentation, but look out that there's not already an event formatter registered for it.

It's also possible to create an event formatter for your own events. When adding your own event names, please mind the [event naming](/api/event-names.html) guidelines.

Each event formatter receives an event metadata "payload" Hash from which the event formatter can format the metadata for the event in AppSignal. This AppSignal event metadata needs to be returned by the event formatter in this order in an Array:

```ruby
def format(payload)
  [
    "event title",
    "event body",
    Appsignal::EventFormatter::DEFAULT
  ]
end
```

1. An event title (`String`)
   - A more descriptive title of an event, such as `"Fetch current user"` or `"Fetch blog post comments"`. It will appear next to the event name in the event tree on the performance sample page to provide a little more context on what's happening.
2. An event body (`String`)
   - More details such as the database query that was used by the event.
3. An event body format (`Integer`)
   - Body format supports formatters to scrub the given data in the `body` argument to remove any sensitive data from the value. There are currently two supported values for the `body_format` argument.
      - `Appsignal::EventFormatter::DEFAULT`
          - This default value will indicate to AppSignal to leave the value intact and not scrub any data from it.
      - `Appsignal::EventFormatter::SQL_BODY_FORMAT`
          - The `SQL_BODY_FORMAT` value will indicate to AppSignal to run your data through the SQL sanitizer and scrub any values in SQL queries.

```sql
-- An event body with the value of:
SELECT * FROM users WHERE email = 'hector@appsignal.com' AND password = 'iamabot'
-- becomes
SELECT * FROM users WHERE email = ? AND password = ?
```

!> __Warning__: the event formatter has no exception handling wrapped around it. If the custom event formatter raises an error, it will crash the web request or background job.

## Example event formatter

```ruby
# A custom event formatter class
class MyCustomEventFormatter
  def format(payload)
    [
      payload[:title],
      payload[:body],
      Appsignal::EventFormatter::DEFAULT
    ]
  end
end

# Register the custom event formatter class for a specific event
Appsignal::EventFormatter.register("event.custom", MyCustomEventFormatter)
# Can be registerd multiple times for other event names
Appsignal::EventFormatter.register("other_event.custom", MyCustomEventFormatter)
```

Then when instrumenting a block of code, use the event name that's registered for your custom event formatter.

```ruby
ActiveSupport::Notifications.instrument(
  "event.custom", # Use the registered event name
  { # Pass along event metadata
    :title => "some event name",
    :body => "some event body"
  }
) do
  sleep 2
end
```

## Changes in gem 2.5

In AppSignal for Ruby gem version `2.5.2` some changes were made in how event formatters are registered. The old method of registering event formatters was deprecated in this release and will be removed in version `3.0` of the Ruby gem.

The new method of registering EventFormatters will allow custom formatters to be registered after AppSignal has loaded. This allows EventFormatters to be registered in [Rails initializers](http://guides.rubyonrails.org/configuring.html#using-initializer-files).

In gem version `2.5.1` and older, it is possible to register an event formatter like the following example, calling the `register` method in the class itself.

```ruby
# Pre 2.5.2 method of registering event formatters
# This method is now deprecated
class MyCustomEventFormatter < Appsignal::EventFormatter
  register "event.custom"

  def format(payload)
    [payload[:title], payload[:body], Appsignal::EventFormatter::DEFAULT]
  end
end
```

With the new setup the register call was extracted from the class itself, so it can instead be registered directly on the EventFormatter class.

```ruby
class MyCustomEventFormatter
  def format(payload)
    [payload[:title], payload[:body], Appsignal::EventFormatter::DEFAULT]
  end
end

Appsignal::EventFormatter.register("event.custom", MyCustomEventFormatter)
```

This also means your EventFormatters no longer need to be a subclass of the `Appsignal::EventFormatter` class.

[as_instrumentation]: /ruby/instrumentation/instrumentation.html#activesupport-notifications
[instrument_helper]: /ruby/instrumentation/instrumentation.html#appsignal-instrumentation-helpers
