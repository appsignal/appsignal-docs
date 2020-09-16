---
title: "Sourcemaps API"
---

Sourcemaps are used to get the original line and column number from a minified backtrace.

This API provides an easy way to upload private sourcemaps for use with [frontend errors](/front-end/sourcemaps.html).

## Sourcemap create

This endpoint enables the creation of private sourcemaps.

<table>
  <tr>
    <td>Endpoint</td>
    <td><code>/api/sourcemaps</code></td>
  </tr>
  <tr>
    <td>Request method</td>
    <td><code>POST</code></td>
  </tr>
    <tr>
    <td>Content-Type</td>
    <td><code>multipart/form-data</code></td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes (<a href="appsignal/terminology.html#push-api-key">Push API key</a>)</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Parameters

All parameters, except for `file` can be sent either in the POST body or as GET parameters. All parameters are __required__.

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
      <td><code>push_api_key</code></td>
      <td>String</td>
      <td>Your organization's <a href="appsignal/terminology.html#push-api-key">Push API key</a>.</td>
    </tr>
    <tr>
      <td><code>app_name</code></td>
      <td>String</td>
      <td>Name of application in AppSignal the sourcemap is meant for.</td>
    </tr>
    <tr>
      <td><code>environment</code></td>
      <td>String</td>
      <td>Environment of application in AppSignal the sourcemap is meant for.</td>
    </tr>
    <tr>
      <td><code>revision</code></td>
      <td>String</td>
      <td><a href="/application/markers/deploy-markers.html">Deploy marker</a> revision reference.</td>
    </tr>
    <tr>
      <td><code>name</code></td>
      <td>Array of Strings</td>
      <td>List of filenames that the sourcemap covers. This should be a full URL to the minified JavaScript file.</td>
    </tr>
    <tr>
      <td><code>file</code></td>
      <td>File</td>
      <td>Sourcemap to upload.</td>
    </tr>
  </tbody>
</table>

### Responses

- The API will return a `201` HTTP status code if successful.
- The API will return a `400` HTTP status code with a JSON response when a validation error has occurred.
- The API will return a `404` HTTP status code if none of the referenced objects can be found.

400 response body example:

```json
{ "errors": ["The following errors were found: Name can't be empty"] }
```

### Example

```bash
curl -k -X POST -H 'Content-Type: multipart/form-data' \
  -F 'name[]=https://localhost:3000/application.min.js' \
  -F 'revision=abcdef' \
  -F 'file=@/~project/application.js.map' \
  'https://appsignal.com/api/sourcemaps?push_api_key=xxx&app_name=MyApp&environment=development'
```
