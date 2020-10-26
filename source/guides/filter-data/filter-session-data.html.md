---
title: "Filter session data"
---

Every time a request is made on a web app, AppSignal collects the session data that were sent with the request for supported frameworks. Sessions contain data specific to your application, but some dependencies an app uses may store data here as well. For example: when a user signs in, some data of the user who is signed in is stored in a session.

Sessions can contain sensitive or personally identifiable information that should not leave the app. Make sure this data is filtered out before it is sent to the AppSignal servers, this way the app doesn't leak any sensitive data.

-> 🔍 Read more about session data filtering and what types of session data to set up filtering for in our [session data filtering topic][session data filtering].

!> ⚠️ Do not send personal data to AppSignal. If request session data contain personal data, please use filtering to avoid sending this data to AppSignal. Follow this step and the next steps to set up this filtering.

## Session data filtering

Basic session data filtering in the AppSignal integrations works with a denylist, a list of keys to filter out and to not send. In the integrations it's possible to set a "filter session data" option in the AppSignal configuration with a list of parameters keys to filter.

Any session data values that are filtered out by these systems will be replaced with a `[FILTERED]` value. This way the list of session data in the app data on AppSignal.com still includes the session data key, but not the value. Making it easier to see that a value was sent, but the potentially sensitive data was filtered out.

### Example

For example, an application with this AppSignal config:

```yaml
filter_session_data: ["password"]
```

Results in this view for the parameters of a web request on AppSignal.com:

```json
{
  "password": "[FILTERED]"
}
```

## Ruby

In the Ruby integration, AppSignal automatically stores the contents of the user's session for Rails apps and other frameworks. Specific values can be filtered out or it can be [disabled entirely].

In session data filtering, there's support for nested hashes and nested hashes in arrays. Any hash we encounter in your parameters will be filtered.

To use this filtering, add the following to your `config/appsignal.yml` file in the environment group you want it to apply. The [`filter_session_data`](/ruby/configuration/options.html#option-filter_session_data) value is an Array of Strings.

```yml
# Example: config/appsignal.yml
production:
  filter_session_data:
    - name
    - email
    - api_token
    - token
```

## Elixir

In the Elixir integration, AppSignal automatically stores the contents of the user's session for Phoenix apps. Specific values can be filtered out or it can be [disabled entirely].

In the session data filtering, there's support for nested hashes and nested hashes in arrays. Any hash we encounter in your parameters will be filtered.

To use this filtering, add the following to your `config/appsignal.yml` file. The [`filter_session_data`](/elixir/configuration/options.html#option-filter_session_data) value is an Array of Strings.

```elixir
# Example: config/appsignal.exs
config :appsignal, :config,
  filter_session_data: ["name", "email", "api_token", "token"]
```

## Node.js

In the Node.js integration, AppSignal automatically stores the contents of the user's session for certain integrations. Specific values can be filtered out or it can be [disabled entirely].

To use this filtering, add the following to your AppSignal configuration file. The [`filterSessionData`](/nodejs/configuration/options.html#option-filterSessionData) value is an Array of Strings.

```js
# Example: appsignal.js
const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  # Other config
  filterSessionData: ["name", "email", "api_token", "token"]
});
```

## Next steps

- [Filtering parameters](/guides/filter-data/filter-parameters.html) - the previous step in this guide
- [Filtering app data](/guides/filter-data/) - the start of this guide
- [Getting started guides](/guides/) - Guides overview

[session data filtering]: /application/session-data-filtering.html
[disabled entirely]: /application/session-data-filtering.html#filter-all-session-data
