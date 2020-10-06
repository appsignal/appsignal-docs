---
title: "Ignoring errors"
---

Sometimes an error is raised which AppSignal shouldn't send an alert about. It's not desired to capture an exception with a `try`/`catch` block just to prevent AppSignal from alerting you. Instead, the exception should be handled by the framework the application is using.

To prevent AppSignal from picking up these errors and alerting you, you can add exceptions that you want to ignore to the list of ignored errors in your configuration.

More information about the [`ignoreErrors`](/nodejs/configuration/options.html#option-ignore_errors) configuration option.

```js
const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>",
  ignoreErrors: ["TypeError", "AnotherError"]
});
```

**Note:** Names set in `ignoreErrors` will be matched on the `Error` objects `name` property only, and will not honour any class inheritance. If you want to match subclasses of `Error`, each subclass has to be listed separately.

You can also configure ignore exceptions via an environment variable.

```bash
export APPSIGNAL_IGNORE_ERRORS="TypeError,AnotherError"
```

Any exceptions defined here will not be sent to AppSignal and will not trigger a notification.

Read more about [Exception handling with AppSignal](/nodejs/instrumentation/exception-handling.html).
