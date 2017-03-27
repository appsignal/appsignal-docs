---
title: "Supported Operating Systems"
---

## Linux and macOS

The AppSignal integrations for Ruby and Elixir contains native extensions and a
separate light-weight agent process. These native extensions are supported on
most Linux distributions and macOS.

### Alpine Linux

Alpine Linux support is currently in Alpha. You can try our Alpine
Linux support by installing the `2.1.0.alpha.x` versions of the AppSignal gem.

```
gem "appsignal", "2.1.0.alpha.2"
```

For the latest available alpha version see the full list on
[Rubygems.org](https://rubygems.org/gems/appsignal/versions).

Please [let us know](mailto:support@appsignal.com) if you run into any problems
in our alpha version.

Alpine Linux was originally not supported because our agent, which is written in
Rust, does not fully support Alpine Linux's musl C standard library yet. This
has been reported upstream to the Rust team and they are working to improve
support for Alpine Linux.

## Microsoft Windows

We are undecided on supporting Windows. If you use Windows in your production
environment and would like us to support it, [send us an
e-mail](mailto:support@appsignal.com).
