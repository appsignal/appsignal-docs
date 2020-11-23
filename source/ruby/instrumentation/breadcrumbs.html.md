---
title: "Breadcrumbs"
---

-> 💡 Breadcrumbs are available since Ruby gem version `2.11.2`.

Breadcrumbs where initially implemented in our [Front-end Javascript library](/front-end/breadcrumbs.html) with the idea that it would help debug an issue when you have a trail of breadcrumbs with (user) actions leading up to the error.

We then realized this could also be useful for back-end requests, where you can add a time-ordered list of actions leading up to the error. For example adding breadcrumbs through decision trees that are otherwise not instrumented.

![Breadcrumbs](/assets/images/screenshots/frontend/breadcrumbs.svg)

## Usage

By default, no breadcrumbs are tracked, but it's really easy to track your own.

Wherever an interesting event, operation or state change occurs in your app, you can leave a breadcrumb like so:

```ruby
Appsignal.add_breadcrumb("Navigation", "https://example.com", "", { :response => 200 }, Time.now.utc)
Appsignal.add_breadcrumb("Network", "[GET] https://example.com", "", { :response => 500 })
Appsignal.add_breadcrumb("UI", "closed modal(change_password)", "User closed modal without actions")
```

Only the last 20 added breadcrumbs will be added to the current transaction.

## Breadcrumb Options

| Option | Type | Description  |
| ------ | ------ | ----- |
|  category  |  String  |  Category to label the event under  |
|  action  |  String  |  Contextual information related to the event  |
|  message  |  String  |  (optional) A log message or other string to send to AppSignal  |
|  metadata  |  Object<string, string>  |  (optional) An object of metadata related to the event  |
|  time  |  Time object  |  (optional) Time object that responds to `.to_i`, defaults to `Time.utc`  |
