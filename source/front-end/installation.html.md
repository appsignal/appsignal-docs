---
title: "Installing AppSignal for JavaScript"
---

First, add the `@appsignal/javascript` package to your `package.json`. Then, run `yarn install`/`npm install`. You'll also need a Push API key from the ["Push and deploy" section](https://appsignal.com/redirect-to/app?to=info) of your App settings page.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/javascript
npm install --save @appsignal/javascript
```

You can then import and use the package in your bundle:

```javascript
import Appsignal from "@appsignal/javascript" // For ES Module
const Appsignal = require("@appsignal/javascript").default // For CommonJS module

const appsignal = new Appsignal({
  key: "YOUR FRONTEND API KEY"
})
```

It’s recommended (although not necessarily required) to use the instance of the `Appsignal` object like a singleton. One way that you can do this is by `export`ing an instance of the library from a `.js`/`.ts` file somewhere in your project.

```javascript
import Appsignal from "@appsignal/javascript"

export default new Appsignal({
  key: "YOUR FRONTEND API KEY"
})
```

Currently, we have no plans to supply a CDN-hosted version of this library.

!> **NOTE:** If you are running a CDN in front of your assets, you'll need to make two changes for error reporting to be able to send errors to our API endpoint. These changes are described below.

### Front-end monitoring and CDN's

First, on your CDN add a cross-origin(CORS) header:

```
Access-Control-Allow-Origin: *
```

And in your app make sure the `crossorigin` attribute is present in all your JavaScript tags.

```html
<script type="text/javascript" src="//cdn.example.com/bundle.js" crossorigin>
```

Or if you are using a Rails helper:

```ruby
  <%= javascript_include_tag "application", :crossorigin => :anonymous %>
```

### Supported browsers

This package can be used in any ECMAScript 5 compatible browser. We aim for compatibility down to Internet Explorer 9 [(roughly 0.22% of all browsers used today)](https://www.w3counter.com/globalstats.php). All browsers older than this can only supported on a “best effort” basis, and full functionality cannot be guaranteed.

When developing, don’t forget to check browser support on [Can I Use?](https://caniuse.com/) and the [ES6 Compatibility Table](https://kangax.github.io/compat-table/es6/), and provide the appropriate polyfills or fallbacks. **In a small percentage of browsers, a `Promise` polyfill may be required to use this library.**
