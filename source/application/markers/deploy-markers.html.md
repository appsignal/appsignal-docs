---
title: "Deploy markers"
---

Markers are little icons used in graphs on AppSignal.com to indicate a change. This can be a code deploy using a "Deploy marker" or a special event with a ["Custom marker"](custom-markers.html). Deploy markers can also be found in the ["Deploys" section](https://appsignal.com/redirect-to/app?to=markers) in the app navigation which provides a performance overview per deploy.

A deploy marker indicates a change in the deployed version of an application. This can be used to group together occurrences of errors and performance issues within a certain time frame. From when the version was deployed until a newer version was deployed. Deploy markers are also required to enable [backtrace links] for an app.

When a new deploy is detected, the list of incidents is empty for the newest deployment version. When an error, or any other issue, is reported by AppSignal in your application it gets listed for the newest deploy as well. On the sample page for an incident you can see in which deployments an incident occurred with the help of the rocket (🚀) separator icon.

-> 📖 Also read our guide on [how to set up deploy markers](/guides/deploy-markers.html).

![Deploy markers in samples list](/assets/images/screenshots/app_incident_samples_list.png)

## Deploy methods

There are two methods of notifying AppSignal of a new deploy. These two methods cannot be used together.

1. Using the `revision` config option, and;
2. Creating a deploy notification manually with the AppSignal Push API.

The first method (`revision` config option) is our recommended approach, because it's the most reliable method and works better for applications with more than one host. We detect the revision from the application itself so we know which instance is running what version.

The second approach (creating a deploy marker manually) is a method only really useful for small applications that use one host. It creates a new deploy marker at a specific time, regardless of the version the application is actually running. This also means it's also more error prone.

## Revision config option

The recommended approach of letting AppSignal know a new version of your application is deployed is by using the `revision` config option or the `APP_REVISION` environment variable ([Ruby](/ruby/configuration/options.html#option-revision)/[Elixir](/elixir/configuration/options.html#option-revision))/[Node.js](/nodejs/configuration/options.html#option-revision)). This is automatically detected for [Heroku apps](#heroku-support) using the dyno metadata lab feature.

This config option is set per instance of an application which has the benefit of every version of an application running at the same time reporting the errors under the correct deploy, rather than the latest deploy that [has been reported](#manually-create-a-deploy-marker) to AppSignal.

For example: If one machine is still running an older version of the application all the errors from that instance are reported under the previous deploy marker rather than the last known deploy marker.

AppSignal will create a new deploy marker when it receives [transaction data](/appsignal/terminology.html#transactions). When the revision config option is set for your app, the revision is stored on a transaction that tracks a web request / background job. When our processor on the AppSignal servers detects a new revision it will create a new deploy marker for the parent app with the revision from the transaction.

### Config option

The `revision` config option has been released in [Ruby](/ruby/configuration/options.html#option-revision) gem version `2.6.1`, [Elixir](/elixir/configuration/options.html#option-revision) package version `1.6.3` and [Node.js](/nodejs/configuration/options.html#option-revision) package version `1.0.0`.

```yml
# For Ruby
# config/appsignal.yml
production:
  revision: "abcdef12"
```

```elixir
# For Elixir
# config/appsignal.exs
config :appsignal, :config, revision: "abcdef12"
```

If you're running a version in which this config option is not available we recommend using the [`APP_REVISION` environment variable](#system-environment-variable) instead.

### System environment variable

The `APP_REVISION` value can be any value you use to indicate a version/revision. For example: a version number `1.4.2` or a git SHA `cf8bc42`.

The revision value should be set in the application's system environment and updated during a deploy of the application.

```bash
export APP_REVISION="cf8bc42"
# Start your application
# bundle exec rackup app.rb
```

### Heroku support

When using Heroku with the [Heroku Labs: Dyno Metadata](https://devcenter.heroku.com/articles/dyno-metadata) enabled it will automatically set the `revision` config option to the `HEROKU_SLUG_COMMIT` system environment variable. This will automatically report new deploys when the Heroku app gets deployed.

### Cloud66 Support

If you'd like to use the Deploy Marker feature with [Cloud66](https://www.cloud66.com/), you can do this by adding/updating the following line in your config file:

```yml
# For Ruby
# config/appsignal.yml
production:
  revision: "<%= `git log --pretty=format:'%h' -n 1` %>"
```

## Manually create a Deploy marker

-> Manually creating a deploy marker using this method is only useful for small applications that use one application instance. It creates a new deploy marker at a specific time, regardless of the version the application is actually running. This also means it's also more error prone to group data that shouldn't belong to it under the deploy. We recommend you use the [`revision` config option method](#revision-config-option).

This method of reporting new deploys to AppSignal requires that you send a POST request to the AppSignal Push API markers endpoint. This can be done with a [(deprecated) CLI tool (for Ruby)][notify_of_deploy] or with a manual HTTP POST request for other languages. There is no CLI tool available for our other supported languages.

When the deploy marker create/notify request is received by the AppSignal servers, all data that is processed by our servers after that time is tracked under the newly created deploy.

To create a Deploy marker with a HTTP POST request you can use curl or some other tool like it. The payload of the request is a JSON object with data about the marker, such as the revision, user who deployed it and the application's repository.

Read more about how to create Deploy markers with our API in our [API endpoint](/api/markers.html) documentation.

### Ruby CLI tool

The AppSignal for Ruby gem includes a (deprecated) CLI tool to allow creation of deploy markers from your app. See the [`notify_of_deploy` CLI command][notify_of_deploy] documentation for more information. A similar CLI tool is not available for other language integrations.

[notify_of_deploy]: /ruby/command-line/notify_of_deploy.html
[backtrace links]: /application/backtrace-links.html
