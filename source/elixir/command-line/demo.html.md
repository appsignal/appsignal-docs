---
title: "AppSignal for Elixir: Demonstration tool"
---

The AppSignal for Elixir package ships with a command line tool used to send demonstration samples to AppSignal. Upon running it, it sends an error and performance sample to AppSignal from the user's machine.

This command line tool is useful when testing AppSignal on a system and validating the local configuration. It tests if the installation of AppSignal has succeeded and if the AppSignal agent is able to run on the machine's architecture and communicate with the AppSignal servers. The same test is also run during installation using [mix appsignal.install](/elixir/command-line/install.html).

Read more about how to use the demonstration command on the [Debugging][debugging] page.

This tool is available since version 0.11.0 of the AppSignal for Elixir package.

## Usage

On the command line in your project run:

```bash
mix appsignal.demo
```

### With a specific environment

```bash
MIX_ENV=prod mix appsignal.demo
```

### With a release binary

```bash
bin/your_app command appsignal_tasks demo
```

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.

[debugging]: /support/debugging.html
