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

Our [Ruby agent](/ruby/index.html) ships with a built-in diagnose command-line
tool that outputs information about the configuration of the AppSignal gem and
environment it's running in. All this information can help in finding a
potential cause of a problem.

If you open a support request, we'll usually ask you to run this first.

```bash
appsignal diagnose
```

The diagnose command has to be run in the directory of an application that has
the AppSignal agent installed.

Unless the application is configured with environment variables it's necessary
to provide the diagnose command with an environment. The environment will help
AppSignal load the correct configuration that needs to be diagnosed.

```bash
APPSIGNAL_APP_ENV=production appsignal diagnose
```

### Diagnose information

The diagnose command will output the following data.

- Agent information
  - Ruby gem version
  - Agent version
  - Ruby gem installation path
- Host information
  - Hardware architecture
  - Operating system
  - Ruby version
  - Heroku detection - only on Heroku
  - Container id - only in a Docker/LXC container
- Configuration
  - Environment - Outputs a warning if none is found.
  - See [Ruby configuration](/ruby/configuration/options.html) for all
    available options.
- Push API key validation
  - Tests if the Push API key that's being used is a valid key at AppSignal.com.
- Path information
  - Returns if all the required paths exist and if they are writable.
  - `root_path` - application path. AppSignal will try to find a
    `config/appsignal.yml` file here.
  - `log_path` - path the log file is created. Is empty if no viable path could
    be found.
- Installation information
  - Something could have gone wrong during the installation of the AppSignal
    agent. This section outputs the `install.log` and `mkmf.log` (Makefile log)
    files.

The following options need to be correctly configured for AppSignal to start.
It's the absolute minimum, other configuration can also affect the
instrumentation.

- Configuration `Environment` is set.
- Configuration `name` is set.
- Configuration `push_api_key` is set.
- Configuration `active` is set to `true`.
- The Push API key validates. An internet connection is required for this.

## Configuration

The configuration is key. It's important, because without it the AppSignal
agent won't know which application it's instrumenting and in which environment.

Using the [diagnose](#diagnose) information we see if we can find a problem
with the configuration of the agent.

The AppSignal agents have multiple methods of configuration. For the Ruby agent
we recommend you read the [configuration topic](/ruby/configuration/index.html)
to get started, specifically [minimal required
configuration](/ruby/configuration/#minimal-required-configuration), the
[configuration load order](/ruby/configuration/load-order.html) and the
[configuration options](/ruby/configuration/options.html) if you're
experiencing problems.

## No data appearing

There can be many reasons why an application is not being detected by
AppSignal. Only when the AppSignal servers start receiving data from an
application it is created in the UI on AppSignal.com; if no data is received,
no application is created.

When an integration is broken or not setup correctly it can take a long time to
track the problem down. To rule out the AppSignal agent and its processing we
can send "demo samples".

```bash
appsignal demo --environment=development
```

This command sends a fake web request and error sample to the AppSignal servers
for the application. Once data has been received the AppSignal servers start
processing the data and create an application on AppSignal.com. This process is
also used in the `appsignal install` command-line tool to help with the
installation process.

Note that the "demo" command has to be run in the directory of an application
that has the AppSignal agent installed. The "demo" command was added in Ruby
gem version `2.0.0`.

## Logs

When there's no problem found in the diagnose information, the agent's logs are
the next thing you can look into. The AppSignal agents create log files to
output useful information and problems that were encountered in the agent
itself.

By default the agents log "info"-level logs and higher (warning & error). To
log more data relevant for debugging, enable the [debug
option](http://localhost:4567/ruby/configuration/options.html#code-appsignal_debug-code-code-debug-code).

### Logs contents

The AppSignal log file contains information from three different AppSignal
components. It will prefix every log entry with a time stamp, component name,
process PID, log level indicator and the log message itself.

The available agent components are:

- `process`  
  Language specific implementation (Ruby/Elixir).
- `extension`  
  C-lang extension to the language implementation. Runs in the same process as
  `process`.
- `agent`  
  AppSignal Rust system agent. A separate process.

### Log message breakdown

```
[2016-10-19T11:06:18 (process) #11329][DEBUG] Starting appsignal
 ^                    ^         ^      ^      ^
 |                    |         |      |      Message
 |                    |         |      Log level
 |                    |         Process PID
 |                    Agent component
 Timestamp in UTC
```

### Log location

There are two methods of saving logs from the AppSignal gem. By writing the
logs to a log-file and by printing the logs in the process' STDOUT.  See the
[`log`
configuration](/ruby/configuration/options.html#code-appsignal_log-code-code-log-code)
for more information.

Log written to a log file are not written to your application's log files, but
have their own `appsignal.log` file. Depending on the permissions of a host the
agent will write the logs to a different location.

It will first try to create a log file in an application's root directory. For
Rails applications it will create a log file in the `log/` directory instead.
If it has no luck creating a log file it will fall back on the system's `/tmp`
directory. This is also where other AppSignal agent files are saved.

If it completely fails to find a writable location to save its logs to, it will
output them in the STDOUT of the parent application's process. This can also be
configured. On the [Heroku](http://heroku.com/) hosting platform the agent will
log to STDOUT automatically.

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
- Did the "extension" install correctly?  
  Answer is in the "diagnose" output.
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
