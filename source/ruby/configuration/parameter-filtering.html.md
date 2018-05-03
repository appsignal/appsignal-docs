---
title: "Configure parameter filtering"
---

In most apps at least some of the data that might be posted to the app
is sensitive information that should not leave the network.

We support two methods of parameter filtering. If you use Rails, you can use
[Rails' configuration directly](#rails-parameter-filtering) and we will listen
to it. If you use another framework, like Sinatra or Padrino, you can use
AppSignal's own built-in filtering instead.

## AppSignal parameter filtering (since gem 1.3)

We support basic parameters filtering directly in the Ruby gem using a blacklist. This parameter filtering is applied to any query parameters in an HTTP request and any argument for background jobs (since Ruby gem 2.3.0).

This filtering supports key based filtering for hashes, the values of which will be replaced with the `[FILTERED]` value. There's support for nested hashes and nested hashes in arrays. Any hash we encounter in your parameters will be filtered.

To use this filtering, add the following to your `config/appsignal.yml` file in the environment group you want it to apply. The `filter_parameters` value is an Array of strings.

```yml
# config/appsignal.yml
production:
  filter_parameters:
    - password
    - confirm_password
```

It's also possible to set this filter_parameters value using [an environment variable](/ruby/configuration/options.html#filter_parameters).

## Rails parameter filtering

Luckily Rails provides a parameter filtering mechanism to scrub this data from
log files.

AppSignal leverages this mechanism so you can centralize this
configuration. Both your logs and the data sent to AppSignal will be
filtered with a single piece of configuration.

### Filtering specific keys - Blacklisting

There are two ways to determine which keys get filtered. The first one
is blacklisting specific keys. In this example the value of `:secret`
in any post in the app will  be replaced with `[FILTERED]`.

```ruby
# config/application.rb
module Blog
  class Application < Rails::Application
    config.filter_parameters << :secrets
  end
end
```

The downside of this approach is that it becomes more difficult when dealing
with larger, more complex applications. Especially when using features
like `accepts_nested_attributes_for`. If we forget to explicitly add
keys they will not be filtered.

### Allowing specific keys - Whitelisting

If you use a lambda instead of a list of keys you get a lot of
flexibility. In the following example we use a lambda to setup a
whitelist instead of a blacklist.

```ruby
# config/initializers/parameter_whitelisting.rb
WHITELISTED_KEYS_MATCHER = /((^|_)ids?|action|controller|code$)/.freeze
SANITIZED_VALUE = '[FILTERED]'.freeze

config.filter_parameters << lambda do |key, value|
  unless key.match(WHITELISTED_KEYS_MATCHER)
    value.replace(SANITIZED_VALUE)
  end
end
```

You can of course let the lambda do anything you'd like, so you can come
up with your own way of determining what needs to be filtered.

Some further information about filtering parameters can be found in the Rails
guide about
[ActionController](http://guides.rubyonrails.org/action_controller_overview.html#parameters-filtering).

## Filter all parameters

To filter all parameters without using the ActionController filtering, set
`send_params` to false in your `appsignal.yml`:

```yaml
send_params: false
```

## Skip sending session data

If you don't want to send your session data to AppSignal you can add this to the
config in `appsignal.yml`:

```yaml
skip_session_data: true
```

!> **Note**: Do not send personal data to AppSignal. If your parameters contain
   personal data, please use filtering. If your session data contains personal
   data, please skip sending it to AppSignal _until we add filtering to session
   data too (soon!)_.
