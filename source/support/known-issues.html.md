---
title: "Known issues"
---

This page contains a list of publicly documented known issues for AppSignal integrations. If you're experiencing any of the listed issues, please follow the described fixes or workarounds. If none are documented, please contact us at [support@appsignal.com](mailto:support@appsignal.com).

Not all known issues are documented here. Only those that are taking some time to get fixed, remain an issue in some way after they have been fixed or benefit from a separate support page.

See also the GitHub issue tracker for our integrations for other known issues:

- [Ruby gem issue tracker](https://github.com/appsignal/appsignal-ruby/issues)
- [Elixir package issue tracker](https://github.com/appsignal/appsignal-elixir/issues)
- [JavaScript for Front-end issue tracker](https://github.com/appsignal/appsignal-javascript/issues)

## List of known issues

- [Extension not installing on Ruby 2.6](known-issues/ruby-2-6-extension-not-installing.html)
  - Symptom: No data is reported to AppSignal on the affected package versions.
  - Affected components:
      - AppSignal for Ruby package versions: `v2.8.0` and earlier.
    - Systems:
      - [Linux](/support/operating-systems.html#linux) musl builds.
      - [Linux](/support/operating-systems.html#linux) libc builds.
- [Extension compilation system dependencies are required at runtime](known-issues/compilation-dependencies-required-at-runtime.html)
  - Symptom: No data is reported to AppSignal on the affected package versions.
  - Affected components:
      - AppSignal for Elixir package versions: Only `v1.8.0`.
          - Linux builds fixed in `v1.8.1`.
      - AppSignal for Ruby package versions: `v2.7.0` and `v2.7.1`, but less likely to occur.
          - Linux builds fixed in `v2.7.2`.
    - Systems:
      - [Linux](/support/operating-systems.html#linux) musl builds.
      - [Linux](/support/operating-systems.html#linux) libc builds. (Less common.)
      - [FreeBSD](/support/operating-systems.html#freebsd) builds. (Less common.)
- [Shutdown of AppSignal Push API version 1](known-issues/shutdown-of-push-api-version-1.html)
  - Symptom: No data is being reported to AppSignal after the 30th of August 2018.
  - Affected components:
      - AppSignal for Ruby package versions: `v0.11.x` and earlier
- [Apps on Elixir OTP 21 don't report data](known-issues/elixir-otp-21.html)
  - Symptom: No data is reported to AppSignal after upgrading to OTP 21.
  - Affected components:
      - AppSignal for Elixir package versions: `v1.6.5` and earlier
      - Apps running OTP 21 or higher
- [No errors are reported to AppSignal for Rails 5.1](known-issues/rails-5-1-missing-errors.html)
  - Symptom: No errors are reported to AppSignal after upgrading to Rails 5.1.
  - Affected components:
      - AppSignal Ruby package versions: `v2.2.1` and earlier
      - Apps running Rails 5.1 or higher
- [Plug actions registered as "unknown"](known-issues/plug-actions-registered-as-unknown.html)
  - Symptom: Actions in Plug apps are marked as "unknown" in AppSignal.
  - Affected components:
      - AppSignal Elixir package versions: `v1.5.0-beta.1` - most recent
- [Incorrect container host metrics](known-issues/incorrect-container-host-metrics.html)
  - Symptom: Host metrics reported by AppSignal in the host metrics feature are incorrect, reporting the data for the container's host system instead.
  - Affected components:
      - AppSignal for Ruby gem versions `1.x` - `2.9.11`.
      - AppSignal for Elixir package versions `0.0.x` - `1.10.11`.
      - Systems: Containerized systems such as Docker and Heroku (LXC).
- [Compile errors on Alpine Linux after upgrading](known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html)
  - Symptom: When upgrading to AppSignal Ruby gem 2.4 or Elixir package 1.4 AppSignal won't compile on Alpine Linux.
  - Affected components:
      - AppSignal Ruby gem versions: `v2.4.x`
      - AppSignal Elixir package versions: `v1.4.x`
      - Systems: Alpine Linux only.
- [DNS timeouts](known-issues/dns-timeouts.html)
  - Symptom: no data is being received by AppSignal.
  - Affected components:
      - AppSignal Ruby gem versions: `v2.1.x` - `v2.3.x`
      - AppSignal Elixir package versions: `v0.10.x` - `v1.3.x`
      - Systems: Linux distributions only - except Alpine Linux.
- [Action names from Sidekiq's delayed extension are incorrect](known-issues/sidekiq-delayed-extension-action-names.html)
  - Symptom: An incident is created per job. The action name of the incident includes job arguments.
  - Affected components:
      - AppSignal for Ruby package versions: `v2.4.1` - `v2.5.2`
      - Integrations: Sidekiq.
- [Compatibility issue with other instrumentation gems](known-issues/gem-instrumentation-compatibility.html)
  - Symptom: Apps produce "SystemStackErrors" when other instrumentation gems are loaded, such as http_logger, bugsnag, datadog and potentially others.
  - Affected components:
      - AppSignal for Ruby package versions: `0.0.x` - most recent
- [Puma phased restart are broken](known-issues/puma-phased-restart.html)
  - Symptom: Puma phased restart are broken.
  - Affected components:
      - AppSignal for Ruby package versions: `v2.9.17`
