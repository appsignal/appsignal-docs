---
title: "Tagging and Sample Data"
---

Use the `Appsignal.tag_request` method to supply extra context on errors and
performance issues. This can help to add information that is not already part of
the request, session or environment parameters.

You can use `Appsignal.tag_request` wherever the current request is accessible,
we recommend calling it before you application code runs in the request, such
as in a `before_action` using Rails.

```ruby
Appsignal.tag_request(
  :locale => I18n.locale
)
```

!> **Warning**: Do not use tagging to send personal data such as names or email
   addresses to AppSignal. If you want to identify a person, consider using a
   user ID, hash or pseudonymized identifier instead. You can use
   [link templates](/application/link-templates.html) to link them to your own
   system.

## Tags

Using tags you can easily add more information to errors and performance issues
tracked by AppSignal. There are a few limitations on tagging though.

- The tag key must be a `String` or `Symbol`.
- The tagged value must be a `String`, `Symbol` or `Integer`.
- The length of the tag key and tagged value must be less than 100 characters.

Tags that do not meet these limitations are dropped without warning.

```ruby
# Good, I18n.locale/default_locale returns a symbol
Appsignal.tag_request(
  user: current_user.id,
  locale: I18n.locale,
  default_locale: I18n.default_locale
)

# Bad, hash type is not supported
Appsignal.tag_request(
  i18n: {
    locale: I18n.locale,
    default_locale: I18n.default_locale
  }
)
```

### Link templates

Tags can also be used to create link templates. Read more about link templates
in our [link templates guide](/application/link-templates.html).


## Sample Data

Besides tags you can add more metadata to a transaction (or override default metadata from integrations such as Phoenix), below is a list of valid keys that can be given to `set_sample_data` and the format of the value.

### `custom_data`
Custom data is not set by default, but can be used to add additional debugging data to solve a performance issue or exception.

```
Appsignal::Transaction.current.set_sample_data("custom_data", {foo: "bar"})
```

This key accepts nested objects and will result in the following block on a Incident Sample page for both Exception and Performance samples formatted as JSON.

![custom_data](/assets/images/screenshots/sample_data/custom_data.png)
