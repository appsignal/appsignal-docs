---
title: "plugin-window-events"
---

The `plugin-window-events` plugin binds to the `window.onerror` and `window.onunhandledrejection` event handlers to catch any errors that are otherwise not caught elsewhere in your code.

```javascript
import { plugin } from `@appsignal/plugin-window-events`
appsignal.use(plugin(options))
```

## `plugin` options

The `plugin`  can be initialized with the following options:

| Param | Type | Description  |
| ------ | ------ | ----- |
|  onerror  |  Boolean  |  (optional) A boolean value representing whether the plugin should bind to the `window.onerror` handler. Defaults to `true`. |
|  onunhandledrejection  |  Boolean  |  (optional) A boolean value representing whether the plugin should bind to the `window.onunhandledrejection` handler. Defaults to `true`. |
