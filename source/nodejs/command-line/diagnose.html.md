---
title: "AppSignal for Node.js: Diagnose tool"
---

The AppSignal Node.js package ships with a self-diagnostic tool. This tool can be used to debug your AppSignal installation and is one of the first things our support team asks for when there's an issue.

## The diagnostic report

This command-line tool is useful when testing AppSignal on a system and validating the local configuration. It outputs useful information to debug issues and it checks if AppSignal agent can run on the machine's architecture and communicate with the AppSignal servers.

This diagnostic tool collects and outputs the following:

- information about the AppSignal package.
- information about the host system and Node.js.
- if the AppSignal [extension](/appsignal/how-appsignal-operates.html#extension) and [agent](/appsignal/how-appsignal-operates.html#agent) can run on the host system.
- all configured config options (including default values).
- if the configuration is valid and active.
- if the Push API key is present and valid (internet connection required).
- where configuration option values originate from.

Read more about how to use the diagnose command on the [Debugging][debugging] page.

## Submitting the report

Since gem version `1.2.5`, you'll need to pass the `--send-report` option to send the diagnose report to AppSignal. If used, the report will be send to our servers and you will receive a support token.

When you [send this support token to us](mailto:support@appsignal.com) we will review the report and help you debug the issue. We've seen that copy-pasting the report output usually loses formatting and makes it harder to read, which is why it's sent to our servers in the JSON format.

## Usage

On the command line in your project (a directory with a `package.json` and `@appsignal/nodejs` installed) run:

```bash
npx @appsignal/cli diagnose
```

At the very least, the `APPSIGNAL_PUSH_API_KEY` must be set before the diagnose command can be run. If this isn't set in your environment already, you can also set it at runtime with the `--api-key` option:

```bash
npx @appsignal/cli diagnose --api-key="<PUSH API KEY HERE>"
```

You can also set the environment variable at runtime:

```bash
APPSIGNAL_PUSH_API_KEY="<PUSH API KEY HERE>" npx @appsignal/cli diagnose
```

### Environment option

Select a specific environment with the CLI.

```bash
npx @appsignal/cli diagnose --environment="<development || staging || production>"
```

The environment option is useful when the default environment is not the one you want to diagnose. The diagnose tool will warn you when no environment is selected.

## Configuration output format

### Configuration option values format

The configuration options are printed to the CLI as their inspected values. This means we print them as Node.js would in a console.

- Strings values are printed with double quotes around them, e.g. `"My app name"`.
- Booleans values are printed as their raw values: `true` and `false`.
- Arrays values are printed as a collection of values surrounded by square brackets, e.g. `["HTTP_ACCEPT", "HTTP_ACCEPT_CHARSET"]`.
  - Empty Arrays are printed as two square brackets: `[]`.
- Null or undefined values are printed as `null` or `undefined`.

## Options

| Option | Description |
| ------ | ----------- |
| `--environment` | Define which environment to use. |
| `--api-key` | Define which API key to use. |

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.

[debugging]: /support/debugging.html
