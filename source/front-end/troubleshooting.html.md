---
title: "Troubleshooting"
---

### My assets are hosted on a CDN and I see the following log message in the console: "Cross-domain or eval script error detected, error ignored"

This is normal browser behaviour and is a consequence of the [Same-Origin Policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy), a security measure designed to protect your users from [Cross-Site Request Forgery](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)) (CSRF) attacks. Luckily, this is a fairly easy problem to remedy.

First, on your CDN, add a cross-origin (CORS) header:

```
Access-Control-Allow-Origin: *
```

In your app, make sure the `crossorigin` attribute is present in all your JavaScript tags.

```html
<script type="text/javascript" src="//cdn.example.com/bundle.js" crossorigin="anonymous">
```

Or if you are using a Rails helper:

```ruby
<%= javascript_include_tag "application", :crossorigin => :anonymous %>
```
