---
title: "Deploy markers"
---

Markers are little icons used in graphs on AppSignal.com to indicate a change.
This can be a code deploy using a "Deploy marker" or a special event with a
["Custom marker"](custom-marker.html). Deploy markers can also be found under
the "Deploys" page in the AppSignal.com navigation which provides a performance
overview per deploy.

A deploy marker indicates a change in the deployed version of an application.
This can be used to group together occurrences of errors and performance issues
within a certain time frame. From when the version was deployed until a newer
version was deployed.

When a new deploy is detected, the list of incidents is empty for the newest
deployment version. When an error, or any other issue, is reported by AppSignal
in your application it gets listed for the newest deploy as well. On the sample
page for an incident you can see in which deployments an incident occurred with
the help of the rocket (🚀) separator icon.

![Deploy markers in samples
list](/images/screenshots/app_incident_samples_list.png)

## Table of Contents

- [Deploy methods](#deploy-methods)
- [`APP_REVISION` environment variable](#app_revision-environment-variable)
  (recommended method)
- [Create a Deploy marker with curl](#create-a-deploy-marker-with-curl)

## Deploy methods

There are two methods of notifying AppSignal of a new deploy. These two methods
cannot be used together.

1. Using the `APP_REVISION` system environment variable, and;
2. Sending a deploy notification manually to the AppSignal Push API.

The first method (`APP_REVISION` environment variable) is our recommended
approach, because it's the most reliable method and works better for
applications with more than one host. We detect the revision from the
application itself so we know which instance is running what version.

The second approach (sending a deploy notification manually) is a method only
really useful for small applications that use one host. It creates a new deploy
marker at a specific time, regardless of the version the application is
actually running. This also means it's also more error prone.

## `APP_REVISION` environment variable

The recommended approach of letting AppSignal know a new version of your
application is deployed is by using the `APP_REVISION` environment variable.

This variable is set per instance of an application which has the benefit of
every version of an application running at the same time reporting the errors
under the correct deploy rather than the latest AppSignal knows about.

For example: If one machine is still running an older version of the
application all the errors from that instance are reported under the previous
deploy marker rather than the last known deploy marker.

### System environment variable

The `APP_REVISION` value can be any value you use to indicate a
version/revision. For example: a version number `1.4.2` or a git SHA `cf8bc42`.

The revision value should be set in the application's system environment and
updated during a deploy of the application.

```bash
export APP_REVISION="cf8bc42"
# Start your application
# bundle exec rackup app.rb
```

## Create a Deploy marker with curl

Manually creating a deploy marker is a method only really useful for small
applications that use one application instance. It creates a new deploy marker
at a specific time, regardless of the version the application is actually
running. This also means it's also more error prone.

This method requires that you send a POST request to the AppSignal Push API
markers endpoint. The payload of the request is a JSON object with data about
the marker, such as the revision, user who deployed it and the application's
repository.

Read more about how to create Deploy markers with our Push API in our [Push API
endpoint](/push-api/deploy-marker.html) documentation.
