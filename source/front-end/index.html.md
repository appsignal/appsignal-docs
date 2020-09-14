---
title: "AppSignal for JavaScript"
---

AppSignal has amazing support for catching errors from front-end JavaScript applications and sending them to AppSignal. An `npm` library for catching JavaScript errors is available for that.

!> **NOTE:** Uncaught exceptions are **not** captured by default. [Read this section to find out why](/front-end/error-handling.html#uncaught-exceptions). You can enable this functionality by enabling the [`plugin-window-events`](/front-end/plugins/plugin-window-events.html) plugin.

## Creating a Push API Key

Before you begin, you'll need to locate your Push API key. Finding this is easy - look for the ["Push and deploy" section](https://appsignal.com/redirect-to/app?to=info) of your App settings page. You'll be able to find your API key under the "Front-end error monitoring". Once you have your key, follow the instructions under the [Installation](/front-end/installation.html) section to use it in your application.

## About the Retry Queue

If, for any reason, pushing an error to the API fails (e.g. if the network connection is not working), the `Span` object that it belongs to is placed in the retry queue. By default, requests are retried **5 times** with exponential backoff. If the request succeeds, the corresponding `Span` is removed from the queue. Once the retry limit has been reached, any `Span`s left in the queue are discarded.

!> No caching is currently implemented for the retry queue, meaning that if a `Span` is in the queue when the user navigates away from your aplication, that `Span` will also be discarded.
