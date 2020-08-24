---
title: "Custom metrics"
---

With AppSignal for Ruby, Elixir and Node.js, it's possible to add custom instrumentation to [transactions](/appsignal/terminology.html#transactions) ([Ruby](/ruby/instrumentation/index.html) / [Elixir](/elixir/instrumentation/index.html)) to get more details about your application's performance. This instrumentation is per sample and don't give a complete picture of your application. Instead, you can use custom metrics for application-wide metrics.

To track application-wide metrics, you can send custom metrics to AppSignal. These metrics enable you to track anything in your application, from newly registered users to database disk usage. These are not replacements for custom instrumentation, but provide an additional way to make certain data in your code more accessible and measurable over time.

With different [types of metrics](#metric-types) (gauges, counters and measurements) you can track any kind of data from your apps and [tag](#metric-tags) them with metadata to easily spot the differences between different tag values.

For more information about how dashboards and graphs use metrics data, see our [dashboards page](/metrics/custom-metrics/dashboards.html)

![Custom metrics demo dashboard](/assets/images/screenshots/custom_metrics_dashboard.png)

-> **Note**: This feature was introduced with the `1.0` version of the AppSignal for Ruby gem. It is also available in other AppSignal integrations such as Elixir and Node.js.

## Table of Contents

- [Metric types](#metric-types)
  - [Gauge](#gauge)
  - [Measurement](#measurement)
  - [Counter](#counter)
- [Metric naming](#metric-naming)
- [Metric values](#metric-values)
    - [Value formatting](#metric-values-value-formatting)
        - [File size](#metric-values-file-size)
- [Metric tags](#metric-tags)

## Metric types

There are three types of metrics we collect, each with their own purpose.

- [Gauge](#gauge)
- [Measurement](#measurement)
- [Counter](#counter)

### Gauge

A gauge is a metric value at a specific time. If you set more than one gauge with the same key, the last reported value for that moment in time is persisted.

Gauges are used for things like tracking sizes of databases, disks, or other absolute values like CPU usage, a numbers of items (users, accounts, etc.). Currently all AppSignal [host metrics](host.html) are stored as gauges.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.set_gauge(metric_name, value)
Appsignal.set_gauge("database_size", 100)
Appsignal.set_gauge("database_size", 10)

# Will create the metric "database_size" with the value 10
```

### Measurement

At AppSignal measurements are used for things like response times and background job durations. We allow you to track a metric with wildly varying values over time and create graphs based on their average value or call count during that time.

By tracking a measurement, the average and count will be persisted for the metric. A measurement metric creates several metric fields:

- Count: which counts how many times the helper was called. Used for metrics such as throughput.
- Mean: the average metric value for the point in time.
- 90th percentile: the 90th percentile of the metric value for the point in time.
- 95th percentile: the 95th percentile of the metric value for the point in time.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.add_distribution_value(metric_name, value)
Appsignal.add_distribution_value("memory_usage", 100)
Appsignal.add_distribution_value("memory_usage", 110)

# Will create a metric "memory_usage" with the mean field value 105
# Will create a metric "memory_usage" with the count field value 2
```

### Counter

The counter metric type stores a number value for a given time frame. These counter values are combined into a total count value for the display time frame resolution. This means that when viewing a graph with a minutely resolution it will combine the values of the given minute, and for the hourly resolution combines the values of per hour.

Counters are good to use to track events. With a [gauge](#gauge) you can track how many of something (users, comments, etc.) there is at a certain time, but with counters you can track how many events occurred at a specific time (users signing in, comments being made, etc.).

When the helper is called multiple times, the total/sum of all calls is persisted.

```ruby
# The first argument is a string, the second argument a number
# Appsignal.increment_counter(metric_name, value)
Appsignal.increment_counter("login_count", 1)
Appsignal.increment_counter("login_count", 1)

# Will create the metric "login_count" with the value 2 for a point in the minutely/hourly resolution
```

## Metric naming

We recommend naming your metrics something easily recognizable. While you can wildcard parts of the metric name for dashboard creation, we recommend you only use this for small grouping and not use IDs in metric names.

Metric names only support numbers, letters, dots and underscores (`[a-z0-9._]`) as valid characters. Any other characters will be replaced with an underscore by our processor. You can find the list of metrics as processed on the ["Add Dashboard"](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm).

Some examples of good metric names are:

- `database_size`
- `account_count`
- `users.count`
- `notifier.failed`
- `notifier.perform`
- `notifier.success`

By default AppSignal already tracks metrics for your application, such as [host metrics](host.html). See the metrics list on the ["Add Dashboard"](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm) page for the metrics that are already available for your app.

!> **Note**: We __do not__ recommend adding dynamic values to your metric names like so: `eu.database_size`, `us.database_size` and `asia.database_size`. This creates multiple metrics that serve the same purpose. Instead we recommend using [metric tags](#metric-tags) for this.

## Metric values

Metrics only support numbers as valid values. Any other value will be silently ignored or will raise an error as triggered by the implementation language number parser. For Ruby and Elixir we support a [double](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) and [integer](https://en.wikipedia.org/wiki/Integer) as valid values.

```ruby
# Integer
Appsignal.increment_counter("login_count", 1)
# Double
Appsignal.increment_counter("assignment_completed", 0.12)
```

###^metric-values Value formatting

AppSignal graphs have several display formats, such as numbers, file sizes, durations, etc. These formats help in presenting the metric values in a human readable way.

Selecting a value formatter input does not affect the data stored in our systems, only how it's displayed.

To show metric values correctly using these formatters, please check the table below how the value should be reported.

| Formatter | Reported value | Description |
| --- | --- | --- |
| Number | Display value | A human readable formatted number. The values should be reported on the same scale as they are displayed. The value `1` is displayed as "`1`", `10_000` as "`10 K`" and `1_000_000` is displayed as "`1 M`" . |
| Percentage | Display value | A metric value formatted as percentage. The values should be reported on the same scale as they are displayed. The value `40` is displayed as "`40 %`". |
| Throughput | Display value | A metric value formatted as requests per minute/hour. The values should be reported on the same scale as they are displayed. It will display the throughput formatted as a number for both the minute and the hour. The value `10_000` is displayed "`10k / hour 166 / min`". Commonly used for [`counter`](#counter) metrics. |
| Duration | Milliseconds | A duration of time. The values should be reported as milliseconds. The value `100` is displayed as "`100 ms`" and 60_000 as "`60 sec`". Commonly used for [`measurement`](/metrics/custom.html#measurement) metric. |
| File size | [Customizable](#metric-values-file-size) | A file size formatted as megabytes by default. `1.0` megabytes is displayed as `1Mb`. What file size unit the reported metric value is read as can be customized in the graph builder. |

####^metric-values File size

Metric values that represent a file size can use the file size formatter. To specify which unit of size the reported value is the file size formatter allows for several input values.

The available options are:

- `Size in Bit`
- `Size in Bytes`
- `Size in Kilobits`
- `Size in Kilobytes`
- `Size in Megabytes`

When sending a metric with the following value:

```ruby
Appsignal.set_gauge("database_size", 1024)
```

The graph will render the following display value for the specified file size formatter:

- `Size in Bit` will render "128 Bytes"
- `Size in Bytes` will render "1 KB"
- `Size in Kilobits` will render "128 KB"
- `Size in Kilobytes` will render "1 MB"
- `Size in Megabytes` will render "1 GB"

## Metric tags

-> **Note**: Tags for custom metrics are supported since AppSignal for Ruby gem version `2.6.0` and Elixir package `1.6.0`.

The same metric can be about different groups of data. These groups can be added as tags to the metric. By default, every tag and value combination will result in a line being drawn in an AppSignal graph.

Metrics supports none or multiple tags. By default, no tags are set on a custom metric by the AppSignal metric helpers.

How tags can be used in AppSignal graphs:

- Tag can be used to "label" the line in the graph legend, which makes it easier to determine which lines mean what in a graph on mouse hover.
- The same metric can be used to create different views of the same metric in different graphs, by filtering by tags.

Some general guidelines for tags:

- A metric either has tags or no tags.
  - We recommend that when reporting a metric, it always has tags or not tags. Not a combination of tags and no tags. This will make graphing the metric easier.
- A metric always has the same tags.
  - We recommend that every location a metric is reported always uses the same tag combination. The same metric should not use a dynamic set of tags, e.g. tag A and B in one location and only tag B in another location. It should then always report tag A and B. This will make graphing the metric easier.
- A metric's tag has a limited set of values
  - We do not recommend setting a lot of different values for one tag. Creating a metric per user or request creates many different tag combinations for the metric, which results in many lines being drawn for a graph using this metric. This will make the graph unusable as too many lines will be drawn.

An example: an app has app subscriptions in different regions (EU, US and Asia). These regions can be added to the metric as tags. This creates one metric with different tag values that can be used to draw a graph with a line per tag combinations.

```ruby
# Ruby
Appsignal.set_gauge("database_size", 100, :region => "eu")
Appsignal.set_gauge("database_size",  50, :region => "us")
Appsignal.set_gauge("database_size", 200, :region => "asia")
```

```elixir
# Elixir
Appsignal.set_gauge("database_size", 100, %{region: "eu"})
Appsignal.set_gauge("database_size",  50, %{region: "us"})
Appsignal.set_gauge("database_size", 200, %{region: "asia"})
```

It's also possible to add multiple tags to a metric. Every tag combination will be drawn as a separate line for graphs on a dashboard.

```ruby
# Ruby
Appsignal.set_gauge("my_metric_name", 100, :tag_a => "a", :tag_b => "b")
Appsignal.set_gauge("my_metric_name", 10, :tag_a => "a", :tag_b => "b")
Appsignal.set_gauge("my_metric_name", 200, :tag_a => "b", :tag_b => "c")
```

```elixir
# Elixir
Appsignal.set_gauge("my_metric_name", 100, %{tag_a: "a", tag_b: "b"})
Appsignal.set_gauge("my_metric_name", 10, %{tag_a: "a", tag_b: "b"})
Appsignal.set_gauge("my_metric_name", 200, %{tag_a: "b", tag_b: "c"})
```
