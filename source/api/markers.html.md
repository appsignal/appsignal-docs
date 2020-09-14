---
title: "Markers API"
---

Markers are little icons used in graphs to indicate a change. This can be a
deploy using a "Deploy marker" or a custom event with a "Custom marker".

This Marker endpoint allows the creation and indexing of markers that are
available per application.

## Marker types

### Deploy markers

Deploy markers are little dots at the bottom of each graph that indicate when a
new revision of an application was deployed. They’re a great way to compare
deploys with each another and see if the new version increased or decreased
application performance.

A list of these markers is also shown on the "Deploys" page on AppSignal.com,
in an Application context.

### Custom markers

Custom markers provide a way to add more context to graphs, allowing you to add
annotations yourself. Create a Custom marker for scaling operations, when there
was a sudden spike in traffic or when a database was acting up.

For more information also read our [blog post about Custom
markers](http://blog.appsignal.com/blog/2016/10/28/custom-markers.html).

## Marker create

This endpoint enables the creation of Deploy and Custom markers.

When creating the payload for this request you can select what type of marker
to create by specifying the `kind` value.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/[app_id]/markers.json</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>POST</td>
  </tr>
  <tr>
    <td>Context</td>
    <td>Applications</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Deploy marker

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>kind</td>
      <td>String</td>
      <td>The kind of marker to be created - "deploy".</td>
    </tr>
    <tr>
      <td>created_at</td>
      <td>Date - <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601</a></td>
      <td>Time at which to insert the marker. Leave empty to use the current time.</td>
    </tr>
    <tr>
      <td>repository</td>
      <td>String</td>
      <td>Git link or reference, e.g. "main".</td>
    </tr>
    <tr>
      <td>revision</td>
      <td>String</td>
      <td>Git revision reference. Used to create git diff links in the UI.</td>
    </tr>
    <tr>
      <td>user</td>
      <td>String</td>
      <td>User that has initiated the deploy.</td>
    </tr>
  </tbody>
</table>

#### Payload example

```json
{
  "marker": {
    "kind": "deploy",
    "created_at": "2015-07-21T15:06:31.737+02:00",
    "repository": "git@github.com:company/repository.git",
    "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
    "user": "user"
  }
}
```

### Custom marker

Used to annotate events that can impact your performance/error rate. Examples are: up/downscale of cloud infrastructure, maintenance on database, cause of error spikes.

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>kind</td>
      <td>String</td>
      <td>The kind of marker to be created - "custom".</td>
    </tr>
    <tr>
      <td>created_at</td>
      <td>Date - <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601</a></td>
      <td>Time at which to insert the marker. Leave empty to use the current time.</td>
    </tr>
    <tr>
      <td>icon</td>
      <td>String - Optional</td>
      <td>Emoji to use for this Custom marker.</td>
    </tr>
    <tr>
      <td>message</td>
      <td>String - Optional</td>
      <td>Message shown when hovering over the marker in the UI. Truncated to 200 characters.</td>
    </tr>
  </tbody>
</table>

#### Payload example

```json
{
  "marker": {
    "kind": "custom",
    "created_at": "2015-07-21T15:06:31.737+02:00",
    "icon": "💩",
    "message": "Accidentlly dropped production DB"
  }
}
```

## Marker index

This endpoint returns a list of markers. Combines both Deploy and Custom
markers.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/[app_id]/markers.json</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>GET</td>
  </tr>
  <tr>
    <td>Context</td>
    <td>Applications</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Parameters

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>kind</td>
      <td>String</td>
      <td>The kind of marker to be created - "custom".</td>
    </tr>
    <tr>
      <td>from</td>
      <td>Date - <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601</a> / Integer - UNIX timestamp</td>
      <td>All times are UTC.</td>
    </tr>
    <tr>
      <td>to</td>
      <td>Date - <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601</a> / Integer - UNIX timestamp</td>
      <td>All times are UTC.</td>
    </tr>
    <tr>
      <td>limit</td>
      <td>Integer</td>
      <td>Limit the number of markers returned.</td>
    </tr>
    <tr>
      <td>count_only</td>
      <td>Boolean</td>
      <td>Set to "true" to only return the number of markers that exist.</td>
    </tr>
  </tbody>
</table>

### Response

```json
{
  "count": 4212,
  "markers": [
    {
      "kind": "deploy",
      "id": "50a61f1b660cd3677775ccb0",
      "created_at": "2015-07-21T15:06:31.737+02:00",
      "closed_at": null,
      "live_for": 107413,
      "live_for_in_words": "1d",
      "gem_version": null,
      "repository": "git@github.com:company/repository.git",
      "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
      "short_revision": "fe00101",
      "git_compare_url": "https://github.com/company/repository/compare/aaa...bbb"
      "user": "user",
      "exception_count": 200,
      "exception_rate": 8.81
    },
    {
      "kind": "custom",
      "icon": "💩",
      "message": "Accidentlly dropped production DB",
      "created_at": "2015-07-21T15:06:31.737+02:00"
    },
    {
      "kind": "notification",
      "message": "Appsignal API issues.",
      "created_at": "2015-07-21T15:06:31.737+02:00"
    }
  ]
}
```

With `"count_only": true`.

```json
{
  "count": 4212
}
```

## Marker show

This endpoint returns the JSON representation of a single marker.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/[app_id]/markers/[marker_id].json</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>GET</td>
  </tr>
  <tr>
    <td>Context</td>
    <td>Applications</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Parameters

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>marker_id</td>
      <td>String</td>
      <td>The id of the marker to return.</td>
    </tr>
  </tbody>
</table>

### Response

The response for Deploy markers and Custom markers is different. Deploy markers
contain more data about a certain deploy while Custom markers only contain the
data given on creation.

#### Deploy marker

```json
{
  "id": "50a61f1b660cd3677775ccb0",
  "created_at": "2015-07-21T15:06:31.737+02:00",
  "closed_at": null,
  "live_for": 107413,
  "live_for_in_words": "1d",
  "gem_version": null,
  "repository": "git@github.com:company/repository.git",
  "revision": "fe001015311af4769a4dad76bdbce4c8f5d022af",
  "short_revision": "fe00101",
  "git_compare_url": "https://github.com/company/repository/compare/aaa...bbb"
  "user": "user",
  "exception_count": 200,
  "exception_rate": 8.81
}
```

#### Custom marker

```json
{
  "kind": "custom",
  "icon": "💩",
  "message": "Accidentlly dropped production DB",
  "created_at": "2015-07-21T15:06:31.737+02:00"
}
```

#### Notification marker

```json
{
  "kind": "notification",
  "message": "Appsignal API issues.",
  "created_at": "2015-07-21T15:06:31.737+02:00"
}
```

## Marker update

This endpoint updates a single marker and returns the JSON representation of
the updated marker.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/[app_id]/markers/[marker_id].json</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>PUT</td>
  </tr>
  <tr>
    <td>Context</td>
    <td>Applications</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Parameters

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>marker_id</td>
      <td>String</td>
      <td>The id of the marker to update.</td>
    </tr>
  </tbody>
</table>

### Payload

The payload is the same as a [create/POST](#marker-create) request and differs
per marker type.

### Response

The response is the same as a [show/GET](#marker-show) request and differs per
marker type.

## Marker delete

This endpoint deletes a single marker.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/[app_id]/markers/[marker_id].json</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>DELETE</td>
  </tr>
  <tr>
    <td>Context</td>
    <td>Applications</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Parameters

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>marker_id</td>
      <td>String</td>
      <td>The id of the marker to delete.</td>
    </tr>
  </tbody>
</table>

### Response

The response body of this request is empty. The status code will return if it
was successful or not.
