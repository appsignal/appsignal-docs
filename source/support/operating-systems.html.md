---
title: "Supported Operating Systems"
---

## Linux and macOS

The AppSignal integrations for Ruby and Elixir contains native extensions and a
separate light-weight agent process. These native extensions are supported on
most Linux distributions and macOS.

### Alpine Linux

[Alpine Linux] support was added in version `2.1.0` of the AppSignal gem. Our
Elixir package supports Alpine Linux since version `0.10.0`.

Alpine Linux was originally not supported because our agent, which is written in
[Rust], does not fully support Alpine Linux's [musl] C standard library yet.
This has been reported upstream to the Rust team and they are working to improve
support for Alpine Linux.

#### Ruby

For the Ruby gem add this to your `Gemfile`:

```ruby
gem "appsignal", ">= 2.1.0" # or a newer version
```

For the latest available version see the full list on
[RubyGems.org](https://rubygems.org/gems/appsignal/versions) and if you run
into any problems please [let us know](mailto:support@appsignal.com).

#### Elixir

If you're using Elixir, add this to your `mix.exs` file:

```elixir
{:appsignal, ">= 1.0.0"} # or a newer version
```

For the latest available version see the full list on
[Hex.pm](https://hex.pm/packages/appsignal) and if you run
into any problems please [let us know](mailto:support@appsignal.com).

## Microsoft Windows

We are undecided on supporting Windows. If you use Windows in your production
environment and would like us to support it, [send us an
e-mail](mailto:support@appsignal.com).

[Alpine Linux]: https://alpinelinux.org/
[musl]: https://www.musl-libc.org/
[Rust]: https://www.rust-lang.org/en-US/
