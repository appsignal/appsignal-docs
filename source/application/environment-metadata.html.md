---
title: "Environment metadata"
---

The AppSignal integrations and agent collect metadata about the host and app it is integrating with. The specifics about which metadata is collected is listed below.

This metadata is used to:

- enrich the data available on AppSignal.com (to provide a more complete picture of the host and app),
- provide additional information for debugging purposes as a supplement to the diagnose command,
- product improvement as part of an anonymous aggregated dataset.

This feature was added to AppSignal for Ruby 2.11.0. To disable this feature, set the `send_environment_metadata` config option to `false` ([Ruby](/ruby/configuration/options.html#option-send_environment_metadata)).

## AppSignal metadata

- AppSignal integration version
    - What package and version of AppSignal is installed. This is either the Ruby gem, Elixir package or the Node.js package.
- AppSignal agent version
    - What version of the AppSignal agent is installed. This is used to recognize the version when [standalone mode] is used.
- Agent release
    - Reports which architecture was installed, 32 or 64-bit. The AppSignal extension and agent are built for each architecture separately.
    - Reports whether the [musl build](/support/operating-systems.html#supported-versions) was installed.
- Agent standalone mode enabled
    - If the agent is running in [standalone mode]. This is used for hosts that run systems such as databases, that still want to report host metrics for it.
- Agent StatsD mode enabled
    - If the agent has [StatsD mode] enabled.
- Optional enabled features
    - AppSignal integrations have some optional features that can be enabled, usually prefixed with the `enable_` name in the config options. It is reported only when they are enabled.

## App metadata

- Integration language
    - What the integration language is (Ruby/Elixir/Node.js) and what version.
- Integration language implementation
    - What the language implementation is, if any (MRI or JRuby), and what version.
- Integration supported libraries
    - A list of which AppSignal supported libraries integrations are loaded and what version, e.g. Rails, Phoenix, Express. Only information of officially supported AppSignal packages is sent, but not any unsupported or private packages.

## Host metadata

The host data is available for hosts in the [host metrics] feature, adding details to hosts in the overview.

- Architecture
    - Whether the system is 32 or 64-bit architecture.
- Operating System
    - Operating System, either Linux, macOS or Windows.
    - Operating System Distribution, for Linux this reports Ubuntu, Fedora, etc.
    - Operating System version, the version of the Operating System.
    - Kernel version, for Linux this reports the installed kernel version.
- Containerized system
    - Is the host part of a container system such as Docker. On container system such as Docker the AppSignal agent is using a different method with which host metrics are reported.
- Platform
    - If Heroku is detected as platform. Our integrations and agent use different settings on Heroku.

[standalone mode]: /standalone-agent/installation.html
[statsd mode]: /standalone-agent/statsd.html
[host metrics]: /metrics/host.html
