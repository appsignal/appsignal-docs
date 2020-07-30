---
title: "Public endpoint"
---

## Public endpoint

This API is a traffic-optimised endpoint to push data to AppSignal that is not sent through the agent.


Base URL:

```
https://appsignal-endpoint.net
```

Authentication:

Authentication is done with a Public endpoint (or Front-end) API key, which can be found under "App settings".

URL Parameters:

| Param | Type | Description  |
| ------ | ------ | -----: |
| api_key | string | **Front-end** API key, can be found under "App settings" |
|  name  |  string  |   Name of the application, must match existing application on AppSignal|
|  environment  |  string |  Environment of application, must match existing application/environment on AppSignal.  |


Full example:

```
https://appsignal-endpoint.net/metrics/statsd?api_key=<api_key>&name=<name>&environment=<environment>
```

-> **Note**: This endpoint is optimised for traffic and does not validate the API key or payload, a `200`(`OK`) is returned when the body size is within the `200k` limit. This doesn't mean the request is accepted when processed.


## Endpoints

This API exposes the following endpoints:

* [StatsD](/api/public-endpoint/statsd.html) Send (batched) StatsD-formatted metrics to AppSignal.
