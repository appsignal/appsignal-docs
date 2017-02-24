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

## Sending personal data

Please be mindful of sending personal data about your users to AppSignal. You
can choose to send user data, but a better workflow would be to send user
IDs or hashes and use [link
templates](/ruby/instrumentation/link-templates.html) to link them back to your
own system.
