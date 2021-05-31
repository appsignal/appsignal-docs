---
title: "Koa.js"
---

The AppSignal for Node.js integration for Koa (`koa`) v2.0.0+.


## Installation

Add both the `@appsignal/nodejs` and `@appsignal/koa` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs @appsignal/koa
npm install --save @appsignal/nodejs @appsignal/koa
```

You can then import and use the package in your app.

## Usage

The module includes an AppSignal intrumentation plugin for automatically instrumenting the middlewares or routes of your application.

```js
// AT THE VERY TOP OF THE ENTRYPOINT OF YOUR APPLICATION...

const { Appsignal } = require("@appsignal/nodejs");

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>"
});

appsignal.instrument(require("@appsignal/koa"));

// ...ALL THE REST OF YOUR IMPORTS AND CODE GO HERE!

const Koa = require("koa");
const Router = require("@koa/router"); // @koa/router is also supported out of the box!

// Add error handling

app.on("error", (error) => {
  appsignal
    .tracer()
    .currentSpan()
    .addError(error)
    .close()
});

const app = new Koa();
```
