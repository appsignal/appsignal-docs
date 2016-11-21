---
title: "Webhooks"
---

AppSignal can send notifications of new incidents to several services, like Campfire and Slack. We also offer webhooks for these notifications.

To receive a webhook, go to the "Integrations" tab the site's sidebar and fill out the url where you'd like to receive your webhook data.

![Webhook](/images/screenshots/app_webhook.png)

Depending on the incident we push three different JSON bodies.

## Marker

```json
{
  "marker":{
    "user": "thijs",
    "site": "AppSignal",
    "environment": "test",
    "revision": "3107ddc4bb053d570083b4e3e425b8d62532ddc9",
    "repository": "git@github.com:appsignal/appsignal.git",
    "url": "https://appsignal.com/test/sites/1385f7e38c5ce90000000000/web/exceptions"
  }
}
```

## Exception

```json
{
  "exception":{
    "exception": "ActionView::Template::Error",
    "site": "AppSignal",
    "message": "undefined method `encoding' for nil:NilClass",
    "action": "App::ErrorController#show",
    "path": "/errors",
    "revision": "3107ddc4bb053d570083b4e3e425b8d62532ddc9",
    "user": "thijs",
    "first_backtrace_line": "/usr/local/rbenv/versions/2.0.0-p353/lib/ruby/2.0.0/cgi/util.rb:7:in `escape'",
    "url": "https://appsignal.com/test/sites/1385f7e38c5ce90000000000/web/exceptions/App::SnapshotsController-show/ActionView::Template::Error",
    "environment": "test"
  }
}
```

## Performance

```json
{
  "performance":{
    "site": "AppSignal",
    "action": "App::ExceptionsController#index",
    "path": "/slow",
    "duration": 552.7897429999999,
    "status": 200,
    "hostname": "frontend.appsignal.com",
    "revision": "3107ddc4bb053d570083b4e3e425b8d62532ddc9",
    "user": "thijs",
    "url": "https://appsignal.com/test/sites/1385f7e38c5ce90000000000/web/performance/App::ExceptionsController-index",
    "environment": "test"
  }
}
```
