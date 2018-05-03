---
title: "Tagging"
---

Use the [`Appsignal.Transaction.set_sample_data`](https://hexdocs.pm/appsignal/Appsignal.Transaction.html#set_sample_data/2) function to supply extra context on errors and
performance issues. This can help to add information that is not already part of
the request, session or environment parameters.

```elixir
Appsignal.Transaction.set_sample_data("tags", %{locale: "en"})
```

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

!> **Note**: Do not use tagging to send personal data such as names or email
   addresses to AppSignal. If you want to identify a person, consider using a
   user ID, hash or pseudonymized identifier instead. You can use
   [link templates](/application/link-templates.html) to link them to your own
   system.

## Link templates

Tags can also be used to create link templates. Read more about link templates
in our [link templates guide](/application/link-templates.html).
