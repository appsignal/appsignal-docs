---
title: "Minutely probes"
---

Minutely probes are a mechanism to periodically send custom metrics to AppSignal. In minutely intervals from when the probe was first created, a user-defined function can be called in which you can capture metrics in order to send them to AppSignal. As minutely probes are instances of `EventEmitter`s, they are asynchronous.

## Creating probes

If you need to track more custom metrics from your app than our the default probes that ship with our integrations, you can add your own probe(s).

```js
const meter = appsignal.metrics()
const probes = meter.probes()

// the callback is fired once every minute from when 
// `register` is called
probes.register("database", () => {
  meter.setGauge("database_size", 10)
})
```
