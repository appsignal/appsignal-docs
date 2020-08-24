---
title: "API overview"
---

## Base endpoint

The base endpoint for all API calls is `/api` on the `appsignal.com` domain.

```
https://appsignal.com/api
```

## Responses

The response type supported by the AppSignal API is JSON. On some endpoints
JSONP is also supported.

Make sure all requests to endpoints end with the `.json` extension so no URLs
will have to be updated in the future.

## Authentication

| Parameter   | Type             | Description            |
| ----------- | ---------------- | ---------------------: |
| token       | string, required | Your personal API key. |

All requests to AppSignal API endpoints require a personal API `token` given
as an URL query parameter for authentication.

```
https://appsignal.com/api/[endpoint].json?token=personal_api_key
```

(Replace `[endpoint]` with the endpoint you need.)

Your personal API key can be found on the [personal settings
screen](https://appsignal.com/users/edit).

## Applications

| Parameter   | Type             | Description            |
| ----------- | ---------------- | ---------------------: |
| app_id      | string, required | Application id         |

All endpoints provided by our API are scoped on application-level, not on
organization-level (more than one application).

For the API to know what data to return from which application the application
id needs to be provided in the endpoint URL.

For example, given this string in the API documentation:

```
/api/[app_id]/samples.json
```

The URL becomes:

```
https://appsignal.com/api/5114f7e38c5ce90000000011/samples.json?token=abc
```

The `app_id` for an application can be found in the URL of the
[AppSignal.com](https://appsignal.com/accounts) when an application is opened.
For legacy reasons the URL will mention `/sites` rather than `/applications`.
The id that follows is your application id.

```
https://appsignal.com/demo-organization/sites/5114f7e38c5ce90000000011
```
