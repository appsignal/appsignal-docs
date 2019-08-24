---
title: "plugin-path-decorator"
---

The `plugin-path-decorator` is a plugin that decorates all outgoing `Span`s with the current path. This is computed by reading from `window.location.pathname`.

```javascript
import { plugin } from `@appsignal/plugin-path-decorator`
appsignal.use(plugin(options))
```

## `plugin` options

The plugin currently takes no options as parameters.
