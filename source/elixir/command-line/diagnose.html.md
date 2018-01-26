---
title: "AppSignal for Elixir: Diagnose tool"
---

The AppSignal for Elixir package ships with a self diagnostic tool. This tool can be used to debug your AppSignal installation and is one of the first thing our support team asks for when there's an issue.

This command line tool is useful when testing AppSignal on a system and validating the local configuration. It outputs useful information to debug issues and it checks if AppSignal agent is able to run on the machine's architecture and communicate with the AppSignal servers.

This diagnostic tool outputs the following:

- if AppSignal can run on the host system.
- if the configuration is valid and active.
- if the Push API key is present and valid (internet connection required).
- if the required system paths exist and are writable.
- the AppSignal version information.
- the information about the host system and Elixir.
- the last lines from the available log files.

Read more about how to use the diagnose command on the [Debugging][debugging] page.

This tool is available since version 0.12.0 of the AppSignal for Elixir package.

## Usage

### On the command line in your project

```bash
mix appsignal.diagnose
```

### With a specific environment

```bash
MIX_ENV=prod mix appsignal.diagnose
```

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.

[debugging]: /support/debugging.html
