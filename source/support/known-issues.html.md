---
title: "Known issues"
---

This page contains a list of publicly documented known issues for AppSignal integrations. If you're experiencing any of the listed issues, please follow the described fixes or workarounds. If none are documented, please contact us at [support@appsignal.com](mailto:support@appsignal.com).

See also the GitHub issue tracker for our [Ruby gem](https://github.com/appsignal/appsignal-ruby/issues) and [Elixir package](https://github.com/appsignal/appsignal-elixir/issues) for other known issues.

## List of known issues

- [DNS timeouts](known-issues/dns-timeouts.html)
  - Symptom: no data is being received by AppSignal.
  - Affected components:
      - AppSignal Ruby gem versions: `v2.1.x` - `v2.3.x`
      - AppSignal Elixir package versions: `v0.10.x` - `v1.3.x`
      - Systems: Linux distributions only - except Alpine Linux.
- [Compile errors on Alpine Linux after upgrading](known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html)
  - Symptom: When upgrading to AppSignal Ruby gem 2.4 or Elixir package 1.4 AppSignal won't compile on Alpine Linux.
  - Affected components:
      - AppSignal Ruby gem versions: `v2.4.x`
      - AppSignal Elixir package versions: `v1.4.x`
      - Systems: Alpine Linux only.
- [Incorrect container host metrics](known-issues/incorrect-container-host-metrics.html)
  - Symptom: Host metrics reported by AppSignal in the host metrics feature are incorrect, reporting the data for the container's host system instead.
  - Affected components:
      - AppSignal Ruby gem versions: `v1.x` - most recent
      - AppSignal Elixir package versions: `v0.0.x` - most recent
      - Systems: Containerized systems such as Docker and Heroku (LXC).
- [Plug actions registered as "unknown"](known-issues/plug-actions-registered-as-unknown.html)
  - Symptom: Actions in Plug apps are marked as "unknown" in AppSignal.
  - Affected components:
      - AppSignal Elixir package versions: `v1.5.0-beta.1` - most recent
- [No errors are reported to AppSignal for Rails 5.1](known-issues/rails-5-1-missing-errors.html)
  - Symptom: No errors are reported to AppSignal after upgrading to Rails 5.1.
  - Affected components:
      - AppSignal Ruby package versions: `v2.2.1` and earlier
      - Apps running Rails 5.1 or higher
- [Apps on Elixir OTP 21 don't report data](known-issues/elixir-otp-21.html)
  - Symptom: No data is reported to AppSignal after upgrading to OTP 21.
  - Affected components:
      - AppSignal for Elixir package versions: `v1.6.5` and earlier
      - Apps running OTP 21 or higher
- [Shutdown of AppSignal Push API version 1](known-issues/shutdown-of-push-api-version-1.html)
  - Symptom: No data is being reported to AppSignal after the 30th of August 2018.
  - Affected components:
    - AppSignal for Ruby package versions: `v0.11.x` and earlier
