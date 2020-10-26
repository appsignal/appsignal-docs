---
title: "Filter request parameters"
---

Every time a request is made on a web app, AppSignal collects the parameters that were sent with the request. This includes form data (POST), query parameters and keys in routes, e.g. `/user/:id/` in some frameworks.

This data can contain user identifiable information like names, email addresses, passwords, two factor authentication codes, API tokens, etc. We need to make sure this data is filtered out before it is sent to the AppSignal servers, this way the app doesn't leak any sensitive data.

-> 🔍 Read more about parameter filtering, processor parameter filtering and what types of parameters to set up filtering for in our [parameter filtering topic][parameter filtering].

## Parameter filtering

Basic parameter filtering in the AppSignal integrations works with a _denylist_, a list of keys to filter out and to not send. In the integrations it's possible to set a "filter parameters" option in the AppSignal configuration with a list of parameters keys to filter.

Any parameter values that are filtered out by these systems will be replaced with a `[FILTERED]` value. This way the list of parameters in the app data on AppSignal.com still includes the parameter key, but not the value. Making it easier to see that a value was sent, but the potentially sensitive data was filtered out.

-> 🔍 Some [parameter keys are also removed by our processor](/application/parameter-filtering.html#processor-parameter-filtering) on our servers.

!> ⚠️ Do not send personal data to AppSignal. If request parameters, request headers or session data contain personal data, please use filtering to avoid sending this data to AppSignal. Follow this step and the next steps to set up this filtering.

### Example

For example, an application with this AppSignal config:

```yaml
filter_parameters: ["password"]
```

Results in this view for the parameters of a web request on AppSignal.com:

```json
{
  "password": "[FILTERED]"
}
```

The config method and keys may be different for integrations, see the page below for more information per integration.

## Ruby

In the AppSignal Ruby gem there are two methods of parameter filtering. If your app uses Rails, you can use [Rails' configuration directly](#rails-parameter-filtering) and AppSignal will listen to it. If your app use another framework, like Sinatra or Padrino, you can use AppSignal's own built-in filtering instead.

###^ruby AppSignal parameter filtering

Use the denylist for basic parameters filtering. This parameter filtering is applied to any query parameters in an HTTP request and any argument for background jobs.

This filtering supports key based filtering for hashes, the values of which will be replaced with the `[FILTERED]` value. There's support for nested hashes and nested hashes in arrays. Any hash we encounter in your parameters will be filtered.

To use this filtering, add the following to your `config/appsignal.yml` file in the environment group you want it to apply. The [`filter_parameters`](/ruby/configuration/options.html#option-filter_parameters) value is an Array of Strings.

```yml
# Example: config/appsignal.yml
production:
  filter_parameters:
    - password
    - confirm_password
```

### Rails parameter filtering

Luckily Rails provides a parameter filtering mechanism to scrub this data from
log files.

AppSignal leverages this mechanism so you can centralize this
configuration. Both your logs and the data sent to AppSignal will be
filtered with a single piece of configuration.

#### Filtering specific keys - Denylist

There are two ways to determine which keys get filtered. The first one is adding specific keys to the denylist. In this example the value of `:secret` in any post in the app will  be replaced with `[FILTERED]`.

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

#### Allowing specific keys - Allowlist

If you use a lambda instead of a list of keys you get a lot of flexibility. In the following example we use a lambda to setup an allowlist instead of a denylist.

```ruby
# config/initializers/parameter_filtering.rb
ALLOWED_KEYS_MATCHER = /((^|_)ids?|action|controller|code$)/.freeze
SANITIZED_VALUE = '[FILTERED]'.freeze

Rails.application.config.filter_parameters << lambda do |key, value|
  unless key.match(ALLOWED_KEYS_MATCHER)
    value.replace(SANITIZED_VALUE) if value.is_a?(String)
  end
end
```

You can have the lambda check against anything you'd like, so you can come up with your own way of determining what needs to be filtered.

Some further information about filtering parameters can be found in the Rails guides about [ActionController](http://guides.rubyonrails.org/action_controller_overview.html#parameters-filtering).

## Elixir

If your app uses Phoenix, you can use the [Phoenix parameter filtering](#phoenix-filter_parameters-configuration) and AppSignal will listen to it. If your app uses another framework, you can use AppSignal's own built-in filtering instead.

###^elixir AppSignal parameter filtering

Use the denylist for basic parameters filtering. This parameter filtering is applied to any query parameters in an HTTP request.

Set up parameter filtering using the [`filter_parameters` config option](/elixir/configuration/options.html#option-filter_parameters). The `filter_parameters` value is a List of Strings.

```elixir
# Example: config/appsignal.exs
config :appsignal, :config,
  filter_parameters: ["password", "secret"]
```

### Phoenix filter_parameters configuration

Use Phoenix's parameter filtering to centralize your config, which is used to keep sensitive information from the logs. AppSignal will follow these filtering rules.

```elixir
# Example: config/config.exs
config :phoenix,
  :filter_parameters, ["password", "secret"]
```

If the `filter_parameters` config option is not set, Phoenix will default to `["password"]` as a config. This means that a Phoenix app will not send any passwords to AppSignal without any configuration.

## Next steps

- [Filter session data](/guides/filter-data/filter-session-data.html) - future next step in this guide

---

- [Filtering app data](/guides/filter-data/) - the start of this guide
- [Getting started guides](/guides/) - Guides overview

[parameter filtering]: /application/parameter-filtering.html
