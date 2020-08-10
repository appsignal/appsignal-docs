---
title: "node-postgres"
---

The AppSignal for Node.js integration for node-postgres (`pg`) v8.0.0+.

## Installation

Add the `@appsignal/nodejs` package to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs
npm install --save @appsignal/nodejs
```

You can then import and use the package in your app.

No further steps are required to instrument calls made to your database - this is done automatically. The integration will send the following instrumentation data to AppSignal:

- Query duration
- (Sanitized) SQL query body
- Errors

This also works with any library that depends on `pg` as its database adapter, such as [`knex`](https://github.com/knex/knex) or [TypeORM](https://github.com/typeorm/typeorm).
