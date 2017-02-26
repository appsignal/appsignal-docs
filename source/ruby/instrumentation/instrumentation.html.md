---
title: "Custom instrumentation for Ruby"
---

- [Custom instrumentation](#custom-instrumentation)
- [Nesting instrumentation](#nesting-instrumentation)
- [Collecting more data per event](#collecting-more-data-per-event)
- [Instrumenting with ActiveSupport::Notifications](#activesupport-notifications)

## Custom instrumentation

In order to find out what specific pieces of code are causing performance
problems it's useful to add custom instrumentation to your application. This
allows us to create better breakdowns of which code runs slowest and what type
of action was the most time spent on.

When you view saved samples of slow requests in AppSignal you'll be able
to see all instrumentations Rails uses internally.
Template renders, `ActiveRecord` queries and caching are instrumented and
will be shown in the sample:

![Default event tree](/images/screenshots/app_performance_sample_timeline_1.png)

That's already very useful, but wouldn't it be great if we could see
measurements of specific pieces of code you suspect might influence your
performance? Well, you can!

When you add custom instrumentation to your code you'll be able to receive even
more insights into your application. For example, you have to work with an
external API that fetches articles for your homepage:

```ruby
class ArticleFetcher
  def self.fetch(category)
    Appsignal.instrument('fetch.article_fetcher') do
      # Download and process the articles
    end
  end
end

ArticleFetcher.fetch('Latest news')
```

Once you add custom instruments like this AppSignal will start picking them up
and will show you how much time both an event group (`article_fetcher` in this
case) and individual events took.

![Event tree with fetcher](/images/screenshots/app_performance_sample_timeline_2.png)

In this case you'll notice that this API call is a huge influence on the
performance of our homepage, which was hidden before. We might want to consider
caching the articles.

## Instrumentation nesting

You can use as many instruments in any combination you like. You can
nest instrument calls and AppSignal will handle the nesting and aggregates of
the measurements nicely. You just have to keep the final segment (after the last
dot) of the key consistent. [Read more on event naming](/api/event-names.html).

```ruby
Appsignal.instrument('fetch.article_fetcher') do
  10.times do
    Appsignal.instrument('fetch_single_article.article_fetcher') do
      # Fetch single article
    end
  end
end
```

## Collecting more data per event

By default AppSignal will collect the duration of an event and send it to our
servers. Since custom instrumentation is not hooked up to any framework
internals you might need to pass along more data if you want event details to
show up in AppSignal. This can be a descriptive title, or more specific
information like the query from a database call. We already do this for
ActiveRecord, Sequel, Redis, MongoDB, Sinatra, Grape,
[and more](/getting-started/supported-frameworks.html).

There are two helpers to allow you to instrument your code with AppSignal.

```ruby
Appsignal.instrument(name, title = nil, body = nil, body_format = Appsignal::EventFormatter::DEFAULT, &block)
# and
Appsignal.instrument_sql(name, title = nil, body = nil, &block)
```

### `name` argument

The name of the event that will appear in the event tree in AppSignal.
[Read more on key naming](/api/event-names.html).

### `title` argument

A more descriptive title of an event, such as `"Fetch current user"` or `"Fetch
blog post comments"`. It will appear next to the event name in the event tree
on the performance sample page to provide a little more context on what's
happening.

```ruby
Appsignal.instrument('fetch.custom_database', 'Fetch current user') do
  # ...
end
```

### `body` argument

More details such as a database query that was used by the event.

```ruby
sql = 'SELECT * FROM posts ORDER BY created_at DESC LIMIT 1'
Appsignal.instrument('fetch.custom_database', 'Fetch latest post', sql) do
  # ...
end
```

Please make sure that all sensitive data is scrubbed from this data because it
will be send to the AppSignal servers and made visible on the performance
sample pages. When passing in an SQL query, you can use `body_format =
Appsignal::EventFormatter::SQL_BODY_FORMAT` to do so.

### `body_format` argument

Body format supports formatters to scrub the given data in the `body` argument
to remove any sensitive data from the value. There are currently two supported
values for the `body_format` argument.

#### `Appsignal::EventFormatter::DEFAULT` value

This is the default value of this argument. By default AppSignal will leave the
value intact and not scrub any data from it.

#### `Appsignal::EventFormatter::SQL_BODY_FORMAT` value

The `SQL_BODY_FORMAT` value will run your data through the SQL sanitizer and
scrub any values in SQL queries.

We recommend you use the `Appsignal.instrument_sql` helper for this instead.

```sql
SELECT * FROM users WHERE email = 'hector@appsignal.com' AND password = 'iamabot'
-- becomes
SELECT * FROM users WHERE email = ? AND password = ?
```

## ActiveSupport::Notifications

If you're using an older gem version than version `1.3` and you're using Rails
(more specifically ActiveSupport) you can use the built-in
`ActiveSupport::Notifications` to instrument your code instead.

The method for instrumenting your code using `ActiveSupport::Notifications`
is very similar to how AppSignal does it. Using the article fetcher example
again you can see the differences are quite small.

```ruby
class ArticleFetcher
  def self.fetch(category)
    ActiveSupport::Notifications.instrument('fetch.article_fetcher') do
      # Download and process the articles
    end
  end
end

ArticleFetcher.fetch('Latest news')
```

It works for nested instrumentation calls as well.

```ruby
ActiveSupport::Notifications.instrument('fetch.article_fetcher') do
  10.times do
    ActiveSupport::Notifications.instrument('fetch_single_article.article_fetcher') do
      # Fetch single article
    end
  end
end
```

`ActiveSupport::Notifications` is highly flexible, you can instrument your code
any way you like. More information about `ActiveSupport::Notifications` can be
found in the
[Rails API docs](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html).
