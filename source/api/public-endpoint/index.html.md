---
title: "Public endpoint"
---

This API is a traffic-optimized endpoint to push data to AppSignal that is not sent through the [AppSignal agent](/appsignal/how-appsignal-operates.html#agent).

## Base URL

```
https://appsignal-endpoint.net
```

## Authentication

Authentication is done with a Public endpoint (or Front-end) API key, which can be found in [App settings](https://appsignal.com/redirect-to/app?to=info).

## URL Parameters

| Parameters | Type | Description |
| --- | ------ | --- |
| api_key | String | **Front-end** API key, can be found in [App settings](https://appsignal.com/redirect-to/app?to=info). |
| name | String | Name of the application, must match existing application on AppSignal. |
| environment | String | Environment of application, must match existing application/environment on AppSignal. |

Full example:

```
https://appsignal-endpoint.net/metrics/statsd?api_key=<api_key>&name=<name>&environment=<environment>
```

-> **Note**: This endpoint is optimized for large amounts of traffic and does not validate the API key or payload, a `200` (`OK`) response is returned when the body size is within the `200k` limit. This doesn't mean the request is accepted when received.

## Endpoints

This API exposes the following endpoints:

* [StatsD](/api/public-endpoint/statsd.html) Send (batched) StatsD-formatted metrics to AppSignal.
