---
title: "Minutely probes"
---

Minutely probes are a mechanism to periodically send custom metrics to AppSignal. In minutely intervals from when the probe was first created, a user-defined function can be called in which you can capture metrics to send them to AppSignal. As minutely probes are instances of `EventEmitter`s, they are asynchronous.

No minutely probes are configured by `@appsignal/nodejs` by default.

## Creating probes

If you need to track custom metrics from your app, you can add your own probe(s). Using a probe will be familiar to you if you have used an `EventEmitter` before; the `probes.register()` method takes two arguments: a probe name and an anonymous function to be called once every minute.

```js
const meter = appsignal.metrics();
const probes = meter.probes();

// the callback is fired once every minute from when
// `register` is called
probes.register("database", () => {
  meter.setGauge("database_size", 10);
});
```

As with most, if not all, usages of an `EventEmitter`, it is crucial not to block the event loop for long periods inside a minutely probe callback.
