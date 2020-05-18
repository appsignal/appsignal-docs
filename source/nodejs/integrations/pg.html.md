---
title: "node-postgres"
---

The AppSignal for Node.js integration for node-postgres (`pg`) v8.0.0+.

## Installation

Add both the `@appsignal/nodejs` and `@appsignal/pg` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs @appsignal/pg
npm install --save @appsignal/nodejs @appsignal/pg
```

You can then import and use the package in your app. 

## Usage

⚠️ **Important:** Please ensure that you require _and_ initialize the `Appsignal` module before you call `require("pg")` (and the rest of your code).

```js
// ENSURE APPSIGNAL IS THE FIRST THING TO BE REQUIRED/IMPORTED
// INTO YOUR APP!
const { Appsignal } = require("@appsignal/nodejs")
const pgPlugin = require("@appsignal/pg")

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>"
  apiKey: "<YOUR API KEY>"
}).instrument(pgPlugin)

const { Client } = require("pg") // or, this could be a library that depends on `pg`
```

The integration will send the following instrumentation data to AppSignal:

- Query duration
- (Sanitized) SQL query body
- Errors

This also works with any library that depends on `pg` as its database adapter, such as [`knex`](https://github.com/knex/knex) or [TypeORM](https://github.com/typeorm/typeorm).
