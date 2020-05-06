---
title: "Tagging and Sample Data"
---

Use the [`Appsignal.Transaction.set_sample_data`](https://hexdocs.pm/appsignal/Appsignal.Transaction.html#set_sample_data/2) function to supply extra context on errors and
performance issues. This can help to add information that is not already part of
the request, session or environment parameters.

```elixir
Appsignal.Transaction.set_sample_data("tags", %{locale: "en"})
```

!> **Warning**: Do not use tagging to send personal data such as names or email
   addresses to AppSignal. If you want to identify a person, consider using a
   user ID, hash or pseudonymized identifier instead. You can use
   [link templates](/application/link-templates.html) to link them to your own
   system.

## Tags

Using tags you can easily add more information to errors and performance issues
tracked by AppSignal. There are a few limitations on tagging though.

- The tag key must be a `String` or `Atom`.
- The tagged value must be a `String`, `Atom` or `Integer`.

Tags that do not meet these limitations are dropped without warning.

`set_sample_data` can be called multiple times, the given data will be merged, for example:

```elixir
Appsignal.Transaction.set_sample_data("tags", %{locale: "en"})
Appsignal.Transaction.set_sample_data("tags", %{user: "bob"})
Appsignal.Transaction.set_sample_data("tags", %{locale: "de"})
```
will result in the following data:

```elixir
%{
  user: "bob",
  locale: "de"
}
```

### Link templates

Tags can also be used to create link templates. Read more about link templates
in our [link templates guide](/application/link-templates.html).


## Sample Data

Besides tags you can add more metadata to a transaction (or override default metadata from integrations such as Phoenix), below is a list of valid keys that can be given to `set_sample_data` and the format of the value.


### `session_data`

Filled with session/cookie data by default, but can be overridden with the following call:

```
Appsignal.Transaction.set_sample_data("session_data", %{_csrf_token: "Z11CWRVG+I2egpmiZzuIx/qbFb/60FZssui5eGA8a3g="})
```

This key accepts nested objects that will be rendered as JSON on a Incident Sample page for both Exception and Performance samples.

![session_data](/assets/images/screenshots/sample_data/session_data.png)



### `params`
Filled with framework (such as Phoenix) parameters by default, but can be overridden or filled with the following call:

```
Appsignal.Transaction.set_sample_data("params", %{action: "show", controller: "homepage"})
```

This key accepts nested objects and will show up as follows on a Incident Sample page for both Exception and Performance samples, formatted as JSON.

![params](/assets/images/screenshots/sample_data/params.png)



### `environment`
Environment variables from a request/background job, filled by the Phoenix integration, but can be filled/overriden with the following call:

```
Appsignal.Transaction.set_sample_data("environment", %{CONTENT_LENGTH: "0"})
```

This call only accepts a one-level key/value object, nested values will be ignored.
This will result the following block on a Incident Sample page for both Exception and Performance samples.

![environment](/assets/images/screenshots/sample_data/environment.png)



### `custom_data`
Custom data is not set by default, but can be used to add additional debugging data to solve a performance issue or exception.

```
Appsignal.Transaction.set_sample_data("custom_data", %{foo: "bar"})
```
This key accepts nested objects and will result in the following block on a Incident Sample page for both Exception and Performance samples formatted as JSON.

![custom_data](/assets/images/screenshots/sample_data/custom_data.png)
