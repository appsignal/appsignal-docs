---
title: "Dashboards"
---

-> **Legacy notice**: Dashboards used to be configured through a YAML file and this page explained how the YAML worked. These days we have a nice [visual builder](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm) for both dashboards and graphs that is less error prone and easier to use.  
-> We also switched from YAML to JSON for exporting and importing graphs between apps. This feature can be found in the dashboard options menu and when creating a new dashboard.

This page provides more detailed information about how some dashboard graphs options work. For all other options, please see the help icon with attached tooltip for more information.

[Open the dashboard and graph builder](https://appsignal.com/redirect-to/app?to=dashboard&overlay=dashboardForm) in your app.

## Graphs types

Some data is better understood if the graph is rendered in a different way. We provide three display options:

- Line graph
- Area graph
- Relative area graph

The default graph type is "Line graph". Use "Area graph" to render areas beneath the lines and "Relative area graph" to render a graph with the relative values of each data point. This will render a "percentage" of each data point from 0-100 and fill out the graph accordingly. This can be used to easily show the relation between data points in a graph.

The image below shows the same metric in all three graph types. In the Line and Area graph you can see that the amount of data has increased, but the Relative area graph at the bottom shows that the relation between transmitted/received has not changed over time.

![Graph display example](/assets/images/screenshots/custom_metrics_graph_display.png)

## NULL values

Not always does every point in time have a value for a metric, yet the value is not `0`. In our system we do not record a value for this time and treat this point as `NULL` rather than `0`. This means no value is present and can be interpreted in two ways. Either it was actually `0` or it retains the value of the last known data point in the graph.

The "NULL values" option ("Draw NULL as 0" by default) allows for the configuration of the draw behavior for a graph. If set to "Draw NULL as 0" it will treat the `NULL` value as `0`. If set to "Repeat last known value" it will repeat the last known value until a later point in time specifies a new value.

See the difference in the graph below. With "Draw NULL as 0" the graph makes a sharp drop to `0` every time the app stopped reporting data. With "Repeat last known value" the graph looks less volatile in terms of lines moving up and down.

![Draw NULL as 0 option graph comparison screenshot](/assets/images/screenshots/draw_null_as_zero.png)

The app used to generate these graphs:

```ruby
# app.rb
# gem install "appsignal"
require "appsignal"
Appsignal.config = Appsignal::Config.new(".", "development", { :name => "My app", :active => true, :push_api_key => "00000000-0000-0000-0000-000000000000" })
Appsignal.start
Appsignal.start_logger

[
  [5, 1],
  [7, 1],
  [3, 3],
  [5, 2],
  [2, 5],
  [10, 2],
  [8, 1],
  [4, 2]
].each do |(value, pause)|
  puts "set_gauge random_number #{value}"
  Appsignal.set_gauge("random_numbers", value)
  pause_in_minutes = pause * 60
  puts "Sleeping #{pause} minute(s)"
  sleep pause_in_minutes
end

Appsignal.stop
```
