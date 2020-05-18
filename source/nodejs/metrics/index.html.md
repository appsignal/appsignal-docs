---
title: "Metrics"
---

To track application-wide metrics, you can send custom metrics to AppSignal. These metrics enable you to track anything in your application, from newly registered users to database disk usage. These are not replacements for custom instrumentation, but provide an additional way to make certain data in your code more accessible and measurable over time.

With different [types of metrics](#metric-types) (gauges, counters and measurements) you can track any kind of data from your apps and [tag](#metric-tags) them with metadata to easily spot the differences between contexts.

![Custom metrics demo dashboard](/assets/images/screenshots/custom_metrics_dashboard.png)

For the dashboard definition YAML, see our [dashboard definition page](/metrics/custom-metrics/dashboards.html).

Also see our blog post [about custom metrics](http://blog.appsignal.com/blog/2016/01/26/custom-metrics.html) for more information.

## Table of Contents

- [The Metrics object](/nodejs/metrics/meters.html)
- [Minutely probes](/nodejs/metrics/minutely-probes.html)
