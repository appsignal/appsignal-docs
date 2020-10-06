---
title: "The Metrics object"
---

## Metric types

There are three types of metrics we collect, all with their own purpose.

- [Gauge](#gauge)
- [Measurement](#measurement)
- [Counter](#counter)

### Gauge

A gauge is a metric value at a specific time. If you set more than one gauge with the same key, the latest value for that moment in time is persisted.

Gauges are used for things like tracking sizes of databases, disks, or other absolute values like CPU usage, several items (users, accounts, etc.). Currently, all AppSignal [host metrics](/metrics/host.html) are stored as gauges.

```js
const meter = appsignal.metrics();

// The first argument is a string, the second argument a number
// meter.setGauge(metric_name, value)
meter.setGauge("database_size", 100);
meter.setGauge("database_size", 10);

// Will create the metric "database_size" with the value 10
```

### Measurement

At AppSignal measurements are used for things like response times. We allow you to track a metric with wildly varying values over time and create graphs based on their average value or call count during that time.

By tracking a measurement, the average and count will be persisted for the metric. A measurement metric creates several metric fields:

- `COUNT`, which counts how many times the helper was called
- `MEAN`, the average metric value for the point in time.
- `P90`, the 90th percentile of the metric value for the point in time.
- `P95`, the 95th percentile of the metric value for the point in time.

```js
const meter = appsignal.metrics();

// The first argument is a string, the second argument a number
// meter.addDistributionValue(metric_name, value)
meter.addDistributionValue("memory_usage", 100);
meter.addDistributionValue("memory_usage", 110);

// Will create a metric "memory_usage" with the mean field value 105
// Will create a metric "memory_usage" with the count field value 2
```

### Counter

The counter metric type stores a number value for a given time frame. These counter values are combined into a total count value for the display time frame resolution. This means that when viewing a graph with a minutely resolution it will combine the values of the given minute, and for the hourly resolution combines the values of per hour.

Counters are good to use to track events. With a [gauge](#gauge) you can track how many of something (users, comments, etc.) there is at a certain time, but with counters, you can track how many events occurred at a specific time (users signing in, comments being made, etc.).

When the helper is called multiple times, the total/sum of all calls is persisted.

```js
const meter = appsignal.metrics();

// The first argument is a string, the second argument a number
// meter.incrementCounter(metric_name, value)
meter.incrementCounter("login_count", 1);
meter.incrementCounter("login_count", 1);

// Will create the metric "login_count" with the value 2 for a point in the minutely/hourly resolution
```

## Metric naming

We recommend naming your metrics something easily recognizable and without too many dynamic elements. While you can wildcard parts of the metric name for dashboard creation, we recommend you only use this for small grouping and not use IDs for metric names.

Metric names only support numbers, letters, dots and underscores (`[a-z0-9._]`) as valid characters. Any other characters will be replaced with an underscore by our processor. You can find the list of metrics as processed on the ["Add Dashboard"](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm). This is in the "Metrics" feature, as listed in the AppSignal navigation.

Some examples of good metric names are:

- `database_size`
- `account_count`
- `users.count`
- `notifier.failed`
- `notifier.perform`
- `notifier.success`

By default AppSignal already tracks metrics for your application, such as [host metrics](/metrics/host.html). See the metrics list on the ["Add Dashboard"](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm) page for the metrics that are already available for your app.

## Metric values

Metrics only support numbers as valid values. Any other value will be silently ignored or will raise an error as triggered by the implementation language number parser.

```js
const meter = appsignal.metrics();
meter.incrementCounter("assignment_completed", 0.12);
```

## Metric tags

Custom metrics sometimes need some context what they're about. This context can be added as tags so it doesn't need to be included in the name and you can use the same metric name for different values.

For example, you have databases running in the EU, US and Asia, you could tag your metrics like so:

```js
const meter = appsignal.metrics();
meter.setGauge("database_size", 100, { region: "eu" });
```

Another example is how AppSignal uses [host metrics](/metrics/host.html). Every host metric has a tag with a `hostname` to differentiate between different hosts. Some host metrics even have more tags such as the `state` tag for the `cpu` metric, `mountpoint` tag for the `disk_usage`, `disk` tag for `disk_io_read` and `disk_io_written`, etc.

**Note**: We **do not** recommend adding this context to your metric names like so: `eu.database_size`, `us.database_size` and `asia.database_size`. This creates multiple metrics that serve the same purpose. The same goes for any dynamic string that builds the metric key, e.g. `user_#{user.id}`.
