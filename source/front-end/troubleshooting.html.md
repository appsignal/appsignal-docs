---
title: "Troubleshooting"
---

## CDN hosted assets

Your app's assets are hosted on a CDN and you see the following warning message in the browser's web console:

```
Cross-domain or eval script error detected, error ignored
```

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

## Content Security Policy (CSP)

Your Application's content Security Policy might prevent the error tracking library from sending data to our `https://appsignal-endpoint.net` endpoint.

> Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement to distribution of malware.
> <cite>[https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)</cite>

Make sure to add `https://appsignal-endpoint.net` to your Content Security Policy header, if present.


With just AppSignal in the header:

```
Content-Security-Policy: connect-src ‘self’ https://appsignal-endpoint.net
```

Or, with other content in the header:

```
Content-Security-Policy: <other_content>; connect-src ‘self’ https://appsignal-endpoint.net
```
