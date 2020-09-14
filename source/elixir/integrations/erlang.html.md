---
title: "Erlang"
---

The AppSignal for Elixir package integrates with the Erlang VM to provide metrics not just about your app but the virtual machine it's running in.

## Minutely probe

Since AppSignal Elixir package `1.10.1` and up a [minutely probe](/elixir/instrumentation/minutely-probes.html) is activated by default. Once we detect these metrics we'll add a [magic dashboard](https://blog.appsignal.com/2019/03/27/magic-dashboards.html) to your apps.

This probe will report the following [metrics](/metrics/custom.html) grouped by `hostname` tag:

- `erlang_io` - gauge
  - Tag `type`:
      - `input`
      - `output`
- `erlang_schedulers` - gauge
  - Tag `type`:
      - `total`
      - `online`
- `erlang_processes` - gauge
  - Tag `type`:
      - `limit`
      - `count`
- `erlang_memory` - gauge
  - Tag `type`:
      - `total`
      - `processes`
      - `processes_used`
      - `system`
      - `atom`
      - `atom_used`
      - `binary`
      - `code`
      - `ets`

###^minutely-probe Configuration

This probe listens to the [`hostname` config option](/elixir/configuration/options.html#option-hostname) for the hostname tag added to all its metrics. If none is set it will try to detect it automatically. Use the `hostname` config option to set the hostname if you want to change the detected hostname.
