---
title: "Debugging AppSignal"
---

When a support request comes in at support@appsignal.com we have a couple
procedures to debug where a problem might come from.

Since it's good to share, here are a couple of our procedures.

## Table of Contents

- [Diagnose](#diagnose)
  - [Diagnose information](#diagnose-information)
- [Configuration](#configuration)
- [No data appearing](#no-data-appearing)
- [Logs](#logs)
  - [Logs contents](#logs-contents)
  - [Log message breakdown](#log-message-breakdown)
  - [Log location](#log-location)
- [Is the agent running?](#is-the-agent-running)
- [Other questions](#other-questions)
- [Creating a reproducible state](#creating-a-reproducible-state)
- [Contact us](#contact-us)

## Diagnose

Our [Ruby gem](/ruby/index.html) and [Elixir package](/elixir/index.html) ship
with a built-in diagnose command-line tool that outputs information about the
configuration of the AppSignal library and environment it's running in. All
this information can help in finding a potential cause of a problem.

If you open a support request, we'll usually ask you to run this first.

```bash
# Ruby
appsignal diagnose

# Elixir
mix appsignal.diagnose
# Or with the release binary
bin/your_app command appsignal_tasks diagnose
```

The diagnose command has to be run in the directory of an application that has
the AppSignal library installed.

Unless the application is configured with environment variables it's necessary
to provide the diagnose command with an environment. The environment will help
AppSignal load the correct configuration that needs to be diagnosed.

```bash
# Ruby
APPSIGNAL_APP_ENV=production appsignal diagnose
# --environment option support since Ruby gem version 2.0.4
appsignal diagnose --environment=production

# Elixir
MIX_ENV=production mix appsignal.diagnose
# Or with the release binary
bin/your_app command appsignal_tasks diagnose
```

### Diagnose information

The diagnose command will output the following data.

- Agent information
  - Ruby gem / Elixir package version
  - Agent version
  - Ruby gem installation path
  - C-extension / Nif loaded: `yes`/`no`
- Host information
  - Hardware architecture
  - Operating system
  - Ruby / Elixir & OTP version
  - Heroku detection - only visible on Heroku
  - Container detection
  - Current user is `root` user: `yes`/`no`
- [Agent](/appsignal/terminology.html#agent) diagnostics
  - Starts the agent in diagnose mode
  - Agent configuration validation
  - Agent logger initialization
  - Agent lock file path writable check
- Configuration
  - Environment
      - The Ruby gem outputs a warning if none is found.
  - List of configuration options
      - See [Ruby configuration](/ruby/configuration/options.html) and [Elixir
        configuration](/elixir/configuration/options.html) for all
        available options.
- Push API key validation
  - Tests if the Push API key that's being used is a valid key at AppSignal.com.
- Path information
  - Tests all required paths if they are writable. Also outputs ownership of
    the current user.
  - `current_path` - path the diagnose command is run in. Should be a path for
    the application you're trying to debug. Usually the same as `root_path`.
    (Ruby only)
  - `root_path` - application path. AppSignal will try to find a
    `config/appsignal.yml` file here. (Ruby only)
  - `log_dir_path` - path the log file is created in.
  - `log_file_path` - path the log file is created. Is empty if no viable path
    could be found.
- Installation information (Ruby only)
  - Something could have gone wrong during the installation of the AppSignal
    agent. This section outputs the `install.log` and `mkmf.log` (Makefile log)
    files.

The following options need to be correctly configured for AppSignal to start.
It's the absolute minimum, other configuration can also affect the
instrumentation.

- Configuration `Environment` / `env` is set.
- Configuration `name` is set.
- Configuration `push_api_key` is set.
- Configuration `active` is set to `true`.
- The Push API key validates. An internet connection is required for this.

## Configuration

The configuration is key. It's important, because without it the AppSignal
agent won't know which application it's instrumenting and in which environment.

Using the [diagnose](#diagnose) information we see if we can find a problem
with the configuration of the agent.

The AppSignal agents have multiple methods of configuration.

We recommend you read the configuration topic to get started, specifically the
minimal required configuration, configuration load order and the configuration
options pages if you're experiencing problems.

- Configuration overview:
  [Ruby](/ruby/configuration/index.html) /
  [Elixir](/elixir/configuration/index.html)
- Minimal required configuration:
  [Ruby](/ruby/configuration/#minimal-required-configuration) /
  [Elixir](/elixir/configuration/#minimal-required-configuration)
- Configuration load order:
  [Ruby](/ruby/configuration/load-order.html) /
  [Elixir](/elixir/configuration/load-order.html)
- Configuration options:
  [Ruby](/ruby/configuration/options.html) /
  [Elixir](/elixir/configuration/options.html)

## No data appearing

There can be many reasons why an application is not being detected by
AppSignal. Only when the AppSignal servers start receiving data from an
application it is created in the UI on AppSignal.com; if no data is received,
no application is created.

When an integration is broken or not setup correctly it can take a long time to
track the problem down. To rule out the AppSignal agent and its processing we
can send "demo samples".

```bash
# Ruby
appsignal demo --environment=development

# Elixir
MIX_ENV=prod mix appsignal.demo
# Or with the release binary
bin/your_app command appsignal_tasks demo
```

This command sends a fake web request and error sample to the AppSignal servers
for the application. Once data has been received the AppSignal servers start
processing the data and create an application on AppSignal.com.

In the AppSignal Ruby gem this process is also used in the `appsignal install`
command-line tool to help with the installation process.

Note that the "demo" command has to be run in the directory of an application
that has the AppSignal agent installed.

The "demo" command was added in Ruby gem version `2.0.0`.

## Logs

When there's no problem found in the diagnose information, the agent's logs are
the next thing you can look into. The AppSignal agents create log files to
output useful information and problems that were encountered in the agent
itself.

By default the agents log "info"-level logs and higher (warning & error). To
log more data relevant for debugging, enable the [debug
option](/ruby/configuration/options.html#code-appsignal_debug-code-code-debug-code).

### Logs contents

The AppSignal log file contains information from three different AppSignal
components. It will prefix every log entry with a time stamp, component name,
process PID, log level indicator and the log message itself.

The available agent components are:

- `process`  
  Language specific implementation (Ruby / Elixir).
- `extension`  
  C-lang extension to the language implementation. Runs in the same process as
  `process`.
- `agent`  
  AppSignal Rust system agent. A separate process.

### Log message breakdown

#### File logger log message breakdown

```
[2016-10-19T11:06:18 (process) #11329][DEBUG] Starting appsignal
 ^                    ^         ^      ^      ^
 |                    |         |      |      Message
 |                    |         |      Log level
 |                    |         Process PID
 |                    Agent component
 Timestamp in UTC
```

#### STDOUT log message breakdown

For STDOUT loggers the AppSignal Ruby gem prefixes a recognizable "appsignal"
prefix to the message so that specific AppSignal messages can be grepped in the
parent process' log output.

```
[2016-10-19T11:06:18 (process) #11329][DEBUG] appsignal: Starting appsignal
 ^                    ^         ^      ^      ^          ^
 |                    |         |      |      |          Message
 |                    |         |      |      AppSignal prefix
 |                    |         |      Log level
 |                    |         Process PID
 |                    Agent component
 Timestamp in UTC
```

### Log location

There are two methods of saving logs from the AppSignal library. By writing the
logs to a log-file and by printing the logs in the process' STDOUT. See the
[`log`
configuration](/ruby/configuration/options.html#code-appsignal_log-code-code-log-code)
for more information.

Logs written to a log file are not written to your application's log files, but
have their own `appsignal.log` file. Depending on the permissions of a host the
agent will write the logs to a different location.

The Ruby gem will first try to create a log file in an application's directory.
For Ruby on Rails applications it will create a log file in the `log/`
directory instead. If it has no luck creating a log file it will fall back on
the system's `/tmp` directory. This is also where other AppSignal agent files
are saved.

The Elixir package will write the log files to the `/tmp/appsignal.log`
log-file.

If it completely fails to find a writable location to save its logs to, it will
output them in the STDOUT of the parent application's process. This can also be
configured with the `:log` option. On the [Heroku](http://heroku.com/) hosting
platform the agent will log to STDOUT automatically.

To let AppSignal tell you where it will write its logs to, see the output of
the [diagnose](#diagnose) command.

## Is the agent running?

When an application with AppSignal integration starts it boots the AppSignal
system agent. This agent runs as a separate process and communicates with the
application. After processing instrumentation data, it is this agent that sends
the data to the AppSignal servers, not the language specific agent. When the
system agent is not running, no data can be processed or sent to AppSignal.

It's important to know if the system agent is running. You can find it in the
process list under the name `appsignal-agent`.

```bash
ps aux | grep appsignal
```

Run the `ps`-command on the command-line on your host to see if the agent is
running while your application is running AppSignal.

## Other questions

There can be many factors at play when a problem occurs. Things to check when
AppSignal doesn't seem to be working or there are no logs available.

- Since when does the problem occur?
  - Was the agent updated?
  - Were other libraries updated?
- What does the AppSignal agent logs say with log-level "debug"?
- Is the [Operating System](/support/operating-systems.html) supported?
- Did the "extension" install and load correctly?  
  Answers are in the "diagnose" output.
- Is the application running inside a containerized system?

## Creating a reproducible state

If the steps described above haven't shown a cause for the problem, a good next
step is to try to replicate the situation in the most minimal setup possible.

Create a test application with as little configuration as possible, loading
only the minimum required libraries and dependencies.

With this reproducible example application we can start tracking down the cause
of the problem.

## Contact us

Don't hesitate to [contact us](mailto:support@appsignal.com) if you run into
any issues while debugging the AppSignal agents. We're here to help.
