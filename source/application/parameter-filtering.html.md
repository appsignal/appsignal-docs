---
title: "Parameter parameters"
---

For every request made on a web app, AppSignal collects the parameters that were sent with the request. This includes form data (POST), query parameters and keys in routes, e.g. `/user/:id/` in some frameworks.

Data sent to applications that is sensitive or personally identifiable information should not leave the application. To prevent AppSignal from storing this data the integrations need to be configured to not send this data at all or filter out specific values.

Parameter filtering ensures that no passwords, email addresses, two-factor authentication token, API tokens, sent to your application are stored in AppSignal.

!> ⚠️ Do not send personal data to AppSignal. If request parameters contain personal data, please use filtering to avoid sending this data to AppSignal.

## Integration parameter filtering

All AppSignal integrations have a parameter filtering system. A list of parameter keys can be configured to be filtered out, e.g. email, password, two factor authentication API tokens, etc. This way the data is filtered out before it's sent to the AppSignal servers.

Any parameter values that are filtered out by these systems will be replaced with a `[FILTERED]` value. This way the list of parameters in the app data on AppSignal.com still includes the parameter key, but not the value. Making it easier to see that a value was sent, but the potentially sensitive data was filtered out.

-> 📖 Read our guide about [setting up parameter filtering](/guides/filter-parameters.html) for your app.

### Filter all parameters

To filter all parameters without individual parameter filtering, set "send parameters" config option to "false" in the integration configuration.

- [Ruby `send_params` config option documentation](/ruby/configuration/options.html#option-send_params)
- [Elixir `send_params` config option documentation](/elixir/configuration/options.html#option-send_params)

## Processor parameter filtering

When some sensitive parameters are still sent by your app to AppSignal, we will filter these out during processing. This means the data was sent to our servers, where we received and temporarily store this "pre-processing data".

AppSignal filters out [a list of keys](#processor-filtered-keys) from the parameters during processing. These keys are not customizable. These filtered values are replaced with `[REMOVED]` (rather than `[FILTERED]`) to indicate these values were filtered in our processors rather than in your app. Only after this processing, your data is viewable on AppSignal.com. Before that, none of the potentially sent sensitive data is visible to any member of your organization on AppSignal.com. The pre-processing data is removed shortly after processing.

This step should __not__ be relied upon. If a parameter value is shown as `[REMOVED]` on AppSignal.com, the app's config should be updated to filter out the parameter instead. This way sensitive data does not leave your app.

_We always use SSL to encrypt data being sent between your apps and our servers. Any app data containing values that are removed by the processor is deleted shortly after processing._

### Processor filtered keys

The current list of filtered parameter keys by the processor:

- `password`
- `password_confirmation`

## Recommended keys to filter

A non-exhaustive list of parameter keys that may be used by an application. Pick those keys that are relevant for your applications.

- Names
  - `name`
  - `full_name`
  - `first_name`
  - `last_name`
- Email addresses
  - `email`
  - `email_address`
- Passwords
  - `password`
  - `password_confirmation`
  - `confirm_password`
- (API) tokens
  - `token`
  - `api_token`
- Addresses
  - `street`
  - `city`
  - `country`
  - `post_code`
- User information
  - `phone_number`
