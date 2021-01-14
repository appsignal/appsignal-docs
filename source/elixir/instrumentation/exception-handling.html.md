---
title: "Exception handling"
---

In most applications some errors will get raised that aren't related to
possible bugs in your code, they just happen when your app gets into contact
with the real world. Bots might drop by and try to automatically post forms,
outdated links might direct visitors to content that doesn't exist anymore and
so on.

To avoid these errors from being raised as problems in AppSignal it's possible
to add exception handling to your code or even let AppSignal completely ignore
certain errors.

## Ignore errors

The AppSignal configuration makes it possible to [ignore
errors](/elixir/configuration/ignore-errors.html). By providing a list of
specific errors AppSignal will not send alerts when these errors are raised.

## Appsignal.set_error/3

If you want to rescue exceptions in your application to prevent crashes, but
still want to track the occurrence you can use
[`Appsignal.set_error/2`][hexdocs-set_error-2] to add the exception to the
current AppSignal transaction:

```elixir
try do
  raise "Exception!"
rescue
  exception -> Appsignal.set_error(exception, __STACKTRACE__)
end
```

!> **NOTE:** `Appsignal.set_error/2` was added in Appsignal for Elixir 2.1.0. If you're on a lower version, use `Appsignal.set_error/3` instead.

On versions before 2.1.0, use `catch` and `Appsignal.send_error/3`:

```elixir
try do
  raise "Exception!"
catch
  kind, reason ->
    Appsignal.set_error(kind, reason, __STACKTRACE__)
end
```

The exception will be tracked by AppSignal like any other error, and it allows
you to provide custom error handling and fallbacks.

**Note:** This function only works when there is an AppSignal transaction active.
Otherwise the error will be ignored.

Please see
[`Appsignal.send_error/3`](#appsignal-send_error-3) for sending errors
without an AppSignal transaction.

## Appsignal.send_error/3

AppSignal provides a mechanism to track errors that occur in code that's not in
a web or background job context, such as Mix tasks. This is useful for
instrumentation that doesn't automatically create AppSignal transactions to
profile.

You can use the [`Appsignal.send_error/3`][hexdocs-send_error] function to
directly send an exception to AppSignal from any place in your code without
starting an AppSignal transaction first.

```elixir
try do
  raise "Exception!"
catch
  kind, reason ->
    Appsignal.send_error(kind, reason, __STACKTRACE__)
end
```

To add metadata to the sent error, pass a function as the fourth argument to
`Appsignal.send_errror/4`:

```elixir
try do
  raise "Exception!"
catch
  kind, reason ->
    Appsignal.send_error(kind, reason, __STACKTRACE__, fn span ->
      Appsignal.Span.set_attribute(span, "key", "value")
    end)
end
```

!> **NOTE:** `Appsignal.send_error/4` was added in Appsignal for Elixir 2.1.0.

[hexdocs-set_error-2]: https://hexdocs.pm/appsignal/Appsignal.Instrumentation.html#set_error/2
[hexdocs-send_error]: https://hexdocs.pm/appsignal/Appsignal.Instrumentation.html#send_error/3
