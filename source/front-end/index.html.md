---
title: "AppSignal for JavaScript"
---

AppSignal has amazing support for catching errors from front-end JavaScript applications and sending them to AppSignal. An `npm` library for catching JavaScript errors is available for that.

!> **NOTE:** Uncaught exceptions are **not** captured by default. [Read this section to find out why](/front-end/error-handling.html#uncaught-exceptions). You can enable this functionality by enabling the [`plugin-window-events`](/front-end/plugins/plugin-window-events.html) plugin.

## Supported browsers

This package can be used in any ECMAScript 5 compatible browser. We aim for compatibility down to Internet Explorer 9 [(roughly 0.22% of all browsers used today)](https://www.w3counter.com/globalstats.php). All browsers older than this can only supported on a “best effort” basis, and full functionality cannot be guaranteed.

When developing, don’t forget to check browser support on [Can I Use?](https://caniuse.com/) and the [ES6 Compatibility Table](https://kangax.github.io/compat-table/es6/), and provide the appropriate polyfills or fallbacks. **In a small percentage of browsers, a `Promise` polyfill may be required to use this library.**

## Other supported environments

`@appsignal/javascript` is more than just a front-end library! It's also designed to work in a variety of other JavaScript runtimes and use-cases where the `@appsignal/nodejs` library may not be a viable choice. `@appsignal/javascript` supports:

- ✅ **Electron apps**
- ✅ **Short-lived processes**
- ✅ **Serverless functions**
- ✅ **Statically generated apps**
- ✅ **React Native/Expo apps**
