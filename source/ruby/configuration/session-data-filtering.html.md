---
title: "Session data filtering"
---

In most apps, at least some of the data that is sent to the application is sensitive or personally identifiable information that should not leave the network. To prevent AppSignal from storing this data the Ruby gem should be configured to not send this data at all or filter out specific values.

In web applications sessions can be used to store user preferences and other sensitive data without it having to be persisted in the database or sent using [parameters](parameter-filtering.html).

In Rails applications AppSignal automatically stores the contents of the user's session on the AppSignal transaction. This can be disabled or specific values can be filtered out.

!> **Warning**: Do not send personal data to AppSignal. If your parameters or session data contain personal data, please use filtering to avoid sending this data to AppSignal.

-> This feature is available since AppSignal Ruby gem [version 2.6.0](https://blog.appsignal.com/2018/05/08/ruby-gem-2-6.html).

## AppSignal session data filtering

Session data filtering will filter out any values from specified keys in the [`filter_session_data`](/ruby/configuration/options.html#option-filter_session_data) configuration option. Any filtered out value will be replaced with `[FILTERED]` before it leaves your application and is send to the AppSignal servers. This means that AppSignal never receives any of the filtered data.

In the session data filtering, there's support for nested hashes and nested hashes in arrays. Any hash we encounter in your parameters will be filtered.

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

## Skip sending session data

To filter all session data without individual key filtering, set [`skip_session_data`](/ruby/configuration/options.html#option-skip_session_data) to `true`. This means that the session data is set to `nil` and will not be stored for AppSignal transactions.

```yaml
# Example: config/appsignal.yml
production:
  skip_session_data: true
```
