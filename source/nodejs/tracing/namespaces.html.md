---
title: "Custom namespaces for Node.js apps"
---

For more information about what namespaces are, please see our [namespaces](/application/namespaces.html) documentation.

## Configuring a namespace

AppSignal for Node.js differs from the other integrations in that namespace can only be set when the `RootSpan` is created. The default namespace for a `RootSpan` is `web` and this is always set on any `RootSpan` created by the `http` integration. Once set, the namespace of a `RootSpan` is immutable.

In a scenario where the `http` integration is not used and you need to create your own `RootSpan` (for example, in a worker or CLI tool), a `RootSpan` can be given a custom namespace like this:

```js
const span = tracer.createSpan({ namespace: "my_custom_namespace" });
```

Any children of this `Span` will inherit the namespace of the parent.

Once the namespace is set and the application is sending data to the AppSignal servers, the new namespace will appear in the app navigation on AppSignal.com. Note: Data previously reported for the same action is not moved to the new namespace.

-> Note: When setting custom namespace we only accept letters and underscored for namespace names.

## Ignore by namespace

To ignore all actions in a namespace you can configure AppSignal to ignore one or more namespaces in your app's configuration. It's also possible to only [ignore one or more specific actions](/nodejs/configuration/ignore-actions.html).

Ignoring actions or namespaces will **ignore all Span data** from this action or namespace. No errors and performance issues will be reported. [Custom metrics data](/metrics/custom.html) recorded in an action will still be reported.

```js
const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>",
  ignoreNamespaces: ["admin", "private"]
});
```

You can also configure ignore namespaces using an environment variable.

```bash
export APPSIGNAL_IGNORE_NAMESPACES="admin,private"
```

For more information about this config option, see the [`ignoreNamespaces` config option](/nodejs/configuration/options.html#option-ignore_namespaces) documentation.
