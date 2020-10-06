---
title: "AppSignal for Node.js: Install tool"
---

The `@appsignal/cli` package includes a command-line tool to install AppSignal in an existing Node.js application.

## Description

The command-line tool is primarily used to help set up the configuration for AppSignal. Please follow the [installation guide](/application/new-application.html) when adding a new application to AppSignal.

Full integration works automatically for many frameworks. Other frameworks may require some additional setup. Please refer to our documentation pages for [integrations](/nodejs/integrations/) to find out which applies to you.

## Usage

On the command line in your project run:

```bash
npx @appsignal/cli install
```

The tool is fully interactive and should only need to be run once.

## Exit codes

- Exits with status code `0` if the command has completed successfully.
- Exits with status code `1` if the command has completed with an error.
