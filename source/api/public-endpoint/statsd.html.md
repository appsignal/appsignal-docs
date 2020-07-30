---
title: "Public Endpoint - StatsD"
---

This StatsD API endpoint is provided to add additional metrics to AppSignal, where an existing integration can't be used or the language used isn't supported (yet).

This endpoint is meant for integrations that send aggregated metrics over a small period, it's preferred to send one request every 5 seconds with 100 metrics than 100 requests per 5 minutes with one metric each.

Endpoint [POST]:

| Endpoint | Description|
| ------ | ------ |
| **https://appsignal-endpoint.net/metrics/statsd** | Accepts (Dog)StatsD data |

URL Parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
| api_key | string | **Front-end** API key, can be found under "App settings" |
|  name  |  string  |   Name of the application, must match existing application on AppSignal|
|  environment  |  string |  Environment of application, must match existing application/environment on AppSignal.  |


```
https://appsignal-endpoint.net/metrics/statsd?api_key=<api_key>&name=<name>&environment=<environment>
```

Body parameters:

The post body should contain (Dog)statsD formatted metrics separated by a newline.

For example:

```
login_count:1|c|#hostname:frontend1
stripe_api_duration:19|ms|#function:payment,domain:appsignal
cpu_usage:55.1|g|#hostname:frontend1,cpu:0
```

-> **Note**: This endpoint is optimised for traffic and does not validate the API key or payload, a `200`(`OK`) is returned when the body size is within the `200k` limit. This doesn't mean the request is accepted when processed.
