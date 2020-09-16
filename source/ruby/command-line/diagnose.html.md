---
title: "AppSignal for Ruby: Diagnose tool"
---

The AppSignal Ruby gem ships with a self diagnostic tool. This tool can be used to debug your AppSignal installation and is one of the first thing our support team asks for when there's an issue.

This tool has been available since version `1.1.0` of the AppSignal Ruby gem.

## The diagnostic report

This command line tool is useful when testing AppSignal on a system and validating the local configuration. It outputs useful information to debug issues and it checks if AppSignal agent is able to run on the machine's architecture and communicate with the AppSignal servers.

This diagnostic tool collects and outputs the following:

- information about the AppSignal gem.
- information about the host system and Ruby.
- if the AppSignal [extension](/appsignal/how-appsignal-operates.html#extension) and [agent](/appsignal/how-appsignal-operates.html#agent) can run on the host system.
- all configured config options (including default values).
- if the configuration is valid and active.
- if the Push API key is present and valid (internet connection required).
- where configuration option values originate from.
- if the required system paths exist, are writable, and which user and group are owners.
- small parts of the tail from the available log files.

Read more about how to use the diagnose command on the [Debugging][debugging] page.

## Submitting the report

Since gem version `2.2.0` you will be prompted to send the report to AppSignal. If accepted the report will be send to our servers and you will receive a support token.

When you [send this support token to us](mailto:support@appsignal.com) we will review the report and help you debug the issue. We've seen that copy-pasting the report output usually loses formatting and makes it harder to read, which is why it's send to our servers in the JSON format.

In gem version `2.8.0` the option was added to view the report yourself on AppSignal.com. A link to the report is printed in the diagnose output. This web view will also show any validation problems and warnings our system detected.

## Usage

On the command line in your project run:

```bash
appsignal diagnose
```

To run the diagnose on your production server, and send the report to AppSignal for support purposes, you can run the following command:

```bash
bundle exec appsignal diagnose --environment=production --send-report
```

## Options

| Option         | Description                            |
| -------------- | -------------------------------------- |
| [`--environment=<environment>`](#environment-option) | Set the environment to use in the command, e.g. `production` or `staging`. |
| [`--[no-]send-report`](#report-submission-option) | Automatically send, or do not send the report. |
| `--[no-]color` | Toggle the colorization of the output. |

### Environment option

Select a specific environment with the CLI.

```bash
appsignal diagnose --environment=production
```

The environment option is useful when there is no default environment (non-Rails apps and apps configured with an [config file](/ruby/configuration/load-order.html#file)) or the default environment is not the one you want to diagnose. The diagnose tool will warn you when no environment is selected.

### Report submission option

The options to [submit the report](#submitting-the-report) immediately, or not, were added to the AppSignal gem version `2.8.0`. Selecting whether or not to send the report with these options will no longer prompt this question, making it easier to use in non-interactive environments.

Submit the report to AppSignal:

```bash
appsignal diagnose --send-report
```

Do not submit the report to AppSignal:

```bash
appsignal diagnose --no-send-report
```

## Configuration output format

### Configuration option values format

The configuration options are printed to the CLI as their inspected values. This means we print them as Ruby would in a console.

- Strings values are printed with double quotes around them, e.g. `"My app name"`.
- Booleans values are printed as their raw values: `true` and `false`.
- Arrays values are printed as a collection of values surrounded by square brackets, e.g. `["HTTP_ACCEPT", "HTTP_ACCEPT_CHARSET"]`.
  - Empty Arrays are printed as two square brackets: `[]`.
- Nil values are printed as `nil`.

### Configuration sources

The configuration section also prints where values from config options come from. This may help by identifying sources that override values from other config sources.

For more on which configuration sources are available and in which order they're loaded and thus their priority, see the [configuration load order](/ruby/configuration/load-order.html) page.

The configuration options are printed as demonstrated below depending on where the configuration option value comes from and how many sources set this option.

```
Configuration
  # Option with a value loaded only from the default source
  send_params: true

  # Option with one source
  # A different source than the default source
  name: "My app name" (Loaded from file)

  # Option with multiple sources
  # Listed in order of priority (highest priority last)
  active: true
    Sources:
      default: false
      file:    false
      env:     true
```

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.

[debugging]: /support/debugging.html
