---
title: "Public Endpoint - StatsD"
---

This StatsD API endpoint is provided to add additional metrics to AppSignal, where an existing integration can't be used or the language used isn't supported (yet).

This endpoint is meant for integrations that send aggregated metrics over a small period, it's preferred to send one request every 5 seconds with 100 metrics than 100 requests per 5 minutes with one metric each.

## Endpoint

Request method: `POST`

| Endpoint | Description|
| --- | --- |
| https://appsignal-endpoint.net/metrics/statsd | Accepts (Dog)StatsD data |

## URL parameters

| Parameter | Type | Description |
| --- | --- | --- |
| api_key | String | **Front-end** API key, can be found in [App settings](https://appsignal.com/redirect-to/app?to=info). |


```
https://appsignal-endpoint.net/metrics/statsd?api_key=<api_key>
```

## Body parameters

The post body should contain (Dog)statsD formatted metrics separated by a newline.

For example:

```
login_count:1|c|#hostname:frontend1
stripe_api_duration:19|ms|#function:payment,domain:appsignal
cpu_usage:55.1|g|#hostname:frontend1,cpu:0
```

-> **Note**: This endpoint is optimized for large amounts of traffic and does not validate the API key or payload, a `200` (`OK`) response is returned when the body size is within the `200k` limit. This doesn't mean the request is accepted when received.
