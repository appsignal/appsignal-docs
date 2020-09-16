---
title: "Webhooks"
---

AppSignal can send notifications of new incidents to several services, see our full list on the [integrations](/application/integrations). We also offer webhooks for these notifications so you handle new incidents in your own system.

To receive a webhook, go to the "Notifications" tab the site's sidebar, click the "Add integration" and fill out the URL where you'd like to receive your webhook data.

![Webhook](/assets/images/screenshots/app_webhook.png)

There are multiple webhooks available. Which payloads the webhook receives can be configured in the configuration form for the webhook as seen in the screenshot above.

## Deploy markers

```json
{
  "marker": {
    "time": "2019-01-10 10:45:41 +0100",
    "marker_id": "5c3714455ac13f7df09437f0",
    "site": "My test app",
    "environment": "development",
    "revision": "abc123",
    "user": "tom",
    "repository": "https://github.com/my_org/my_repo",
    "url": "https://appsignal.com/test/sites/5bd867fa2213937f3666ae7b/dashboard"
  }
}
```

### Fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>marker</code></td>
      <td><code>Hash&lt;String, Any&gt;</code></td>
      <td>The webhook payload concerns a marker incident.</td>
    </tr>
  </tbody>
</table>

#### Deploy marker sub-fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>time</code></td>
      <td><code>String</code></td>
      <td>Timestamp at which the deploy marker was created.</td>
    </tr>
    <tr>
      <td><code>marker_id</code></td>
      <td><code>String</code></td>
      <td>Internal AppSignal marker id for the deploy marker.</td>
    </tr>
    <tr>
      <td><code>site</code></td>
      <td><code>String</code></td>
      <td>App name as seen on AppSignal.com. Using the <code>site</code> field instead of <code>app</code> for legacy reasons.</td>
    </tr>
    <tr>
      <td><code>environment</code></td>
      <td><code>String</code></td>
      <td>App environment of the app as seen on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>revision</code></td>
      <td><code>String</code></td>
      <td>The <a href="application/markers/deploy-marker.html">deploy marker</a> revision name.</td>
    </tr>
    <tr>
      <td><code>user</code></td>
      <td><code>String</code></td>
      <td>The user that created the marker.</td>
    </tr>
    <tr>
      <td><code>repository</code></td>
      <td><code>String</code></td>
      <td>Url to the repository as configured for the app on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>url</code></td>
      <td><code>String</code></td>
      <td>Url to the app on AppSignal.com that triggered the webhook.</td>
    </tr>
  </tbody>
</table>

## Exception incidents

```json
{
  "exception": {
    "time": "2019-01-09 09:03:57 UTC",
    "incident_id": "5bdb1fb079681b4c5e19d9f7",
    "number": 3,
    "site": "My test app",
    "environment": "development",
    "app_url": "https://appsignal.com/test/sites/5bd867fa2213937f3666ae7b",
    "url": "https://appsignal.com/test/sites/5bd867fa2213937f3666ae7b/incidents/3?timestamp=2019-01-09T09%3A03%3A57Z",
    "revision": "abc123",
    "user": "tom",
    "namespace": "web",
    "exception": "Appsignal::Demo::TestError",
    "message": "Hello world! This is an error used for demonstration purposes.",
    "app_backtrace": [
      "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/lib/appsignal/demo.rb:49:in `create_example_error_request'",
      "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/lib/appsignal/demo.rb:35:in `transmit'",
      "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/lib/appsignal/cli/demo.rb:53:in `run'",
      "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/lib/appsignal/cli.rb:31:in `run'",
      "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/bin/appsignal:7:in `<top (required)>'",
      "/Users/tombruijn/.gem/ruby/2.5.3/bin/appsignal:23:in `load'",
      "/Users/tombruijn/.gem/ruby/2.5.3/bin/appsignal:23:in `<top (required)>'",
      "/Users/tombruijn/.gem/ruby/2.5.3/bin/bundle:23:in `<main>'"
    ],
    "first_backtrace_line": "/Users/tombruijn/.gem/ruby/2.5.3/gems/appsignal-2.8.1/lib/appsignal/demo.rb:49:in `create_example_error_request'",
    "action": "DemoController#hello",
    "path": "/hello",
    "hostname": "Toms-MacBook-Pro.local",
    "action_label": "request",
    "metadata": {
      "demo_sample": "true",
      "method": "GET",
      "path": "/hello"
    }
  }
}
```

### Fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>exception</code></td>
      <td><code>Hash&lt;String, Any&gt;</code></td>
      <td>The webhook payload concerns a exception incident.</td>
    </tr>
  </tbody>
</table>

#### Exception sub-fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>time</code></td>
      <td><code>String</code></td>
      <td>Timestamp at which the exception occurred.</td>
    </tr>
    <tr>
      <td><code>incident_id</code></td>
      <td><code>String</code></td>
      <td>Internal AppSignal incident id for the incident.</td>
    </tr>
    <tr>
      <td><code>number</code></td>
      <td><code>Integer</code></td>
      <td>Incident id as shown on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>site</code></td>
      <td><code>String</code></td>
      <td>App name as seen on AppSignal.com. Using the <code>site</code> field instead of <code>app</code> for legacy reasons.</td>
    </tr>
    <tr>
      <td><code>environment</code></td>
      <td><code>String</code></td>
      <td>App environment of the app as seen on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>app_url</code></td>
      <td><code>String</code></td>
      <td>Url to the app on AppSignal.com that triggered the webhook.</td>
    </tr>
    <tr>
      <td><code>url</code></td>
      <td><code>String</code></td>
      <td>Url to the specific sample for the incident on AppSignal.com that triggered this webhook.</td>
    </tr>
    <tr>
      <td><code>revision</code></td>
      <td><code>String</code></td>
      <td>The <a href="application/markers/deploy-marker.html">deploy marker</a> revision name.</td>
    </tr>
    <tr>
      <td><code>user</code></td>
      <td><code>String</code></td>
      <td>The user that created the marker. The user value can also be <code>null</code> if not set for a deploy marker revision.</td>
    </tr>
    <tr>
      <td><code>namespace</code></td>
      <td><code>String</code></td>
      <td>The namespace in which this exception occurred.</td>
    </tr>
    <tr>
      <td><code>exception</code></td>
      <td><code>String</code></td>
      <td>The exception type that was recorded by AppSignal.</td>
    </tr>
    <tr>
      <td><code>message</code></td>
      <td><code>String</code></td>
      <td>The exception message with more details about the exception.</td>
    </tr>
    <tr>
      <td><code>app_backtrace</code></td>
      <td><code>Array&lt;String&gt;</code></td>
      <td>The lines of the backtrace concerning the app from which they originated. This excludes any backtrace lines from libraries that are included in the app.</td>
    </tr>
    <tr>
      <td><code>first_backtrace_line</code></td>
      <td><code>String</code></td>
      <td>The first backtrace line from the <code>app_backtrace</code> field.</td>
    </tr>
    <tr>
      <td><code>action</code></td>
      <td><code>String</code></td>
      <td>The action in which this exception occurred. Either a controller action, background worker or a manually set action.</td>
    </tr>
    <tr>
      <td><code>path</code></td>
      <td><code>String</code></td>
      <td>The request path on which the exception occurred. This is only set for web requests. This is metadata set by the AppSignal integration by default and is also included in the <code>metadata</code> field.</td>
    </tr>
    <tr>
      <td><code>hostname</code></td>
      <td><code>String</code></td>
      <td>The hostname of the host that this exception occurred on.</td>
    </tr>
    <tr>
      <td><code>action_label</code></td>
      <td><code>String</code></td>
      <td>A human friendly label for the type of action this exception occurred on. Uses <code>request</code> for the <code>web</code> namespace and <code>job</code> for the <code>background</code> namespace. All other namespaces use <code>action</code>.</td>
    </tr>
    <tr>
      <td><code>metadata</code></td>
      <td><code>Hash&lt;String, String&gt;</code></td>
      <td>This includes user set metadata (see for <a href="/ruby/instrumentation/tagging.html">Ruby</a> / <a href="/elixir/instrumentation/tagging.html">Elixir</a>).</td>
    </tr>
  </tbody>
</table>

####^exception Metadata fields

You can add your own metadata by tagging samples (for <a href="/ruby/instrumentation/tagging.html">Ruby</a> / <a href="/elixir/instrumentation/tagging.html">Elixir</a>).

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>demo_sample</code></td>
      <td><code>String</code></td>
      <td>Set by the AppSignal integration for demo samples send using our demo command line tool (<a href="/ruby/command-line/demo.html">Ruby</a> / <a href="/elixir/command-line/demo.html">Elixir</a>). Not set for all other samples.</td>
    </tr>
    <tr>
      <td><code>method</code></td>
      <td><code>String</code></td>
      <td>The request method used to perform a request. Only available for (web) requests.</td>
    </tr>
    <tr>
      <td><code>path</code></td>
      <td><code>String</code></td>
      <td>The request path on which the exception occurred. This is only set for web requests. Contains the same value as the <code>path</code> field.</td>
    </tr>
  </tbody>
</table>

## Performance incidents

```json
{
  "performance": {
    "time": "2019-01-10 09:38:08 UTC",
    "incident_id": "5bdb1fb301925b0c4b6c7017",
    "number": 1,
    "site": "My test app",
    "environment": "development",
    "app_url": "https://appsignal.com/test/sites/5bd867fa2213937f3666ae7b",
    "url": "https://appsignal.com/test/sites/5bd867fa2213937f3666ae7b/incidents/1?timestamp=2019-01-10T09%3A38%3A08Z",
    "revision": "abc123",
    "user": "tom",
    "namespace": "web",
    "duration": 2004.904052734375,
    "action": "DemoController#hello",
    "path": "/hello",
    "hostname": "Toms-MacBook-Pro.local",
    "action_label": "request",
    "metadata": {
      "demo_sample": "true",
      "method": "GET",
      "path": "/hello"
    }
  }
}
```

### Fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>performance</code></td>
      <td><code>Hash&lt;String, Any&gt;</code></td>
      <td>The webhook payload concerns a performance incident.</td>
    </tr>
  </tbody>
</table>

#### Performance sub-fields

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>time</code></td>
      <td><code>String</code></td>
      <td>Timestamp at which the performance incident occurred.</td>
    </tr>
    <tr>
      <td><code>incident_id</code></td>
      <td><code>String</code></td>
      <td>Internal AppSignal incident id for the incident.</td>
    </tr>
    <tr>
      <td><code>number</code></td>
      <td><code>Integer</code></td>
      <td>Incident id as shown on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>site</code></td>
      <td><code>String</code></td>
      <td>App name as seen on AppSignal.com. Using the <code>site</code> field instead of <code>app</code> for legacy reasons.</td>
    </tr>
    <tr>
      <td><code>environment</code></td>
      <td><code>String</code></td>
      <td>App environment of the app as seen on AppSignal.com.</td>
    </tr>
    <tr>
      <td><code>app_url</code></td>
      <td><code>String</code></td>
      <td>Url to the app on AppSignal.com that triggered the webhook.</td>
    </tr>
    <tr>
      <td><code>url</code></td>
      <td><code>String</code></td>
      <td>Url to the specific sample for the incident on AppSignal.com that triggered this webhook.</td>
    </tr>
    <tr>
      <td><code>revision</code></td>
      <td><code>String</code></td>
      <td>The <a href="application/markers/deploy-marker.html">deploy marker</a> revision name.</td>
    </tr>
    <tr>
      <td><code>user</code></td>
      <td><code>String</code></td>
      <td>The user that created the marker. The user value can also be <code>null</code> if not set for a deploy marker revision.</td>
    </tr>
    <tr>
      <td><code>namespace</code></td>
      <td><code>String</code></td>
      <td>The namespace in which this performance incident occurred.</td>
    </tr>
    <tr>
      <td><code>duration</code></td>
      <td><code>Float</code></td>
      <td>The time in milliseconds measured which the request/job/action took to complete.</td>
    </tr>
    <tr>
      <td><code>action</code></td>
      <td><code>String</code></td>
      <td>The action in which this performance incident occurred. Either a controller action, background worker or a manually set action.</td>
    </tr>
    <tr>
      <td><code>path</code></td>
      <td><code>String</code></td>
      <td>The request path on which the performance incident occurred. This is only set for web requests. This is metadata set by the AppSignal integration by default and is also included in the <code>metadata</code> field.</td>
    </tr>
    <tr>
      <td><code>hostname</code></td>
      <td><code>String</code></td>
      <td>The hostname of the host that this performance incident occurred on.</td>
    </tr>
    <tr>
      <td><code>action_label</code></td>
      <td><code>String</code></td>
      <td>A human friendly label for the type of action this performance incident occurred on. Uses <code>request</code> for the <code>web</code> namespace and <code>job</code> for the <code>background</code> namespace. All other namespaces use <code>action</code>.</td>
    </tr>
    <tr>
      <td><code>metadata</code></td>
      <td><code>Hash&lt;String, String&gt;</code></td>
      <td>This includes user set metadata (see for <a href="/ruby/instrumentation/tagging.html">Ruby</a> / <a href="/elixir/instrumentation/tagging.html">Elixir</a>).</td>
    </tr>
  </tbody>
</table>

####^performance Metadata fields

You can add your own metadata by tagging samples (for <a href="/ruby/instrumentation/tagging.html">Ruby</a> / <a href="/elixir/instrumentation/tagging.html">Elixir</a>).

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>demo_sample</code></td>
      <td><code>String</code></td>
      <td>Set by the AppSignal integration for demo samples send using our demo command line tool (<a href="/ruby/command-line/demo.html">Ruby</a> / <a href="/elixir/command-line/demo.html">Elixir</a>). Not set for all other samples.</td>
    </tr>
    <tr>
      <td><code>method</code></td>
      <td><code>String</code></td>
      <td>The request method used to perform a request. Only available for (web) requests.</td>
    </tr>
    <tr>
      <td><code>path</code></td>
      <td><code>String</code></td>
      <td>The request path on which the performance incident occurred. This is only set for web requests. Contains the same value as the <code>path</code> field.</td>
    </tr>
  </tbody>
</table>
