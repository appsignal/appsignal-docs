---
title: "Custom metrics <sup>Beta</sup>"
---

With AppSignal for both Ruby and Elixir, it's possible to add custom
instrumentation ([Ruby](/ruby/instrumentation/index.html) /
[Elixir](/elixir/instrumentation/index.html)) to get more details about your
application performance. But sometimes you want to track other metrics as well.

To track such metrics, you can send custom metrics to AppSignal.
These metrics enable you to track anything in your application, from new
accounts to database disk usage. These are not replacements for code
instrumentation, but an additional way to make certain data in your code more
accessible and measurable over time.

Also read our blog post [about custom
metrics](http://blog.appsignal.com/blog/2016/01/26/custom-metrics.html).

**Note**: This feature was introduced with the `1.0` version of the AppSignal
Ruby gem. It allows sending various metrics to AppSignal where they can be
graphed. It is also available in the Elixir package.

## Table of Contents

- [Collecting metrics](#collecting-metrics)
- [Metric dashboards](#metric-dashboards)

## Collecting metrics

There are three kinds of metrics we collect:

- [gauge](#guage);
- [measurement](#measurement), and;
- [count](#count).

### Gauge

A gauge is a number. If you set more than one gauge with the same key, the
latest value for that moment in time is persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.set_gauge(key, val)
Appsignal.set_gauge("database_size", 100)
Appsignal.set_gauge("database_size", 10)

# Will yield a graph where the `database_size` is 10
```

### Measurement

With a measurement, the average and count will be persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.add_distribution_value(key, val)
Appsignal.add_distribution_value("memory_usage", 100)
Appsignal.add_distribution_value("memory_usage", 110)

# Will yield a graph where the `memory_usage_count` is 2 and the `memory_usage_mean` is 105
```

### Count

When set multiple times, the sum will be persisted:

```ruby
# The key should be a string, the value a number
# Appsignal.increment_counter(key, val)
Appsignal.increment_counter("login_count", 1)
Appsignal.increment_counter("login_count", 1)

# Will yield a graph where the `login_count` is 2
```

-> Only numbers, letters and underscores (`[a-z0-9_]`) are allowed
   as metric keys. Any other characters will be replaced with an underscore.

## Metric dashboards

This feature is in beta. This means there isn't a UI to configure dashboards,
and this syntax _will_ change in the (near) future. Below is an example of our
YAML structure that will generate a tab on the metrics page with two graphs:

```yaml
-
  title: "Data growth"
  graphs:
    -
      title: "Database size"
      kind: "measurement"
      format: "size"
      filter: "db_[a-z]+._size"
    -
      title: "MongoDB collection count"
      kind: "gauge"
      format: "number"
      fields:
        - db_users_document_count
        - db_account_document_count
```

Each dashboard consists of a title and one or more graphs. For each graph the
following fields are available:

| Field | Type | Description  |
| ------ | ------ | ----- |
| title  | String | Title of the graph. |
| [kind](#kind) | string | The kind of metrics to display, available options are: gauge, measurement and count. This determines the group of metrics where data can be graphed. See the "Sample fields from the last five minutes" section of the metrics editor to see what groups and fields are available.  |
| [format](#format) | String | The formatter for the data, options are: "number, size, percent, duration, throughput. |
| [fields](#fields) | Array<String> | An array of fields to graph. |
| [filter](#filter) | String (Regex) | A regex, matching fields will be graphed. |
| [draw_null_as_zero](#draw-null-as-zero) | Boolean, defaults: true | Graphs have two render options, if `draw_null_as_zero` is true (default) then if no value is received it will draw that point as 0, if `draw_null_as_zero` is set to false, then the previous value will be used, until a new value is received. |

### Kind

There are three kinds of metrics we collect: gauge, measurement and count.

| Field |  Description  |
| ------ | ----- |
| gauge | A gauge contains a number, if another gauge with the same key is set, the highest number will be persisted. |
| measurement | A measurement contains a duration of time, when multiple measurements with the same key are set, the average will be persisted. |
| count | A count is a number that can be incremented, when multiple counts with the same key are set, the count is incremented by the value of each key. |

### Format

For the graphs we have a number of formatters available for the data.

| Format |  Description  |
| ------ | ----- |
| number | A formatted number, 1_000_000 will become `1M` 10_000 will become `10K`. |
| size | Size formatted from megabytes. 1.0 megabytes will become `1Mb`. |
| percent | A percentage, 40 will become `40%`. |
| duration | A duration of time in milliseconds. 100 will become `100ms` 60_000 will become `60sec`. Mostly used for measurements. |
| throughput | Throughput of a metric. It will display the throughput formatted as a number for both the minute and the hour. 10_000 will become `10k / hour 166/min`, Mostly used for count fields. |

### Fields

An array of fields to be graphed. You can either use an array of fields, or a
filter.

```yaml
fields:
  - db_users_document_count
  - db_account_document_count
```
A list of available fields per group can be found on the metric editor page.

### Filter

When using a filter, all fields matching the given (JavaScript)regex will be
graphed. You can either use an array of fields, or a filter.

```yaml
filter: "db_[a-z]+._size"
```

This filter will match any field that begins with `db_` and ends with `_size`,
for example:

* `db_graph_collection_size`
* `db_user_collection_size`

### Draw NULL as zero

There are two options to render lines, if `draw_null_as_zero` is `true`
(default) then if no value is received it will draw that point as 0, if
`draw_null_as_zero` is set to `false`, then the previous value will be used,
until a new value is received.

![draw null as zero](/images/screenshots/draw_null_as_zero.png)

The configuration to generate the graphs above:

```yaml
-
  title: 'draw_null_as_zero: true (default)'
  kind: measurement
  format: duration
  draw_null_as_zero: true
  fields:
    - random_numbers
-
  title: 'draw_null_as_zero: false'
  kind: measurement
  format: duration
  draw_null_as_zero: false
  fields:
    - random_numbers
```
