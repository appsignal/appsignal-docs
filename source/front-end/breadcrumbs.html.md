---
title: "Breadcrumbs"
---

When debugging an issue in a UI, it can be useful to know what events occurred in the build up to the error being thrown. Breadcrumbs are a time-ordered list of events in your application, that is filled as a user traverses your application, and is sent along with a `Span` whenever an error is caught by the library. This allows you to gather information that is useful for reproducing tricky-to-debug errors by re-tracing a user's path through your application.

## Table of Contents

- [Usage](#usage)
- [Plugins](#plugins)

![Breadcrumbs](/images/screenshots/frontend/breadcrumbs.svg)

## Usage

By default, no breadcrumbs are tracked, but it's really easy to track your own. Alternatively, you can use one of our [breadcrumb plugins](#plugins) to automatically collect some types of breadcrumbs.

Wherever an interesting event, operation or state change occurs in your app, you can leave a breadcrumb like so:

```js
import Appsignal from "@appsignal/javascript"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

appsignal.addBreadcrumb({
  category: "", // e.g. "UI", "Network", "Navigation", "Console"
  action: "", // e.g "The user clicked a button", "HTTP 500 from http://blablabla.com"
  metadata: {} // key/value metadata in <string, string> format
})
```

When an error is thrown and caught by the AppSignal library, or a `Span` is passed to `appsignal.send()`, the current list of breadcrumbs is added to the current `Span` and sent to the server. The list of breadcrumbs is then emptied.

## Breadcrumb Options

| Option | Type | Description  |
| ------ | ------ | ----- |
|  category  |  String  |  Category to label the event under  |
|  action  |  String  |  Contextual information related to the event  |
|  message  |  String  |  (optional) A log message or other string to send to AppSignal  |
|  metadata  |  Object<string, string>  |  (optional) An object of metadata related to the event  |

## Plugins

There are a number of [plugins](#plugins) available to enable automatic collection of breadcrumbs, and more will be added as time goes on:

- [`@appsignal/plugin-breadcrumbs-console`](https://github.com/appsignal/appsignal-javascript/tree/develop/packages/plugin-breadcrumbs-console)
- [`@appsignal/plugin-breadcrumbs-network`](https://github.com/appsignal/appsignal-javascript/tree/develop/packages/plugin-breadcrumbs-network)

Have a good idea for a breadcrumbs plugin?
