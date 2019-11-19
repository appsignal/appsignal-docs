---
title: "plugin-path-decorator"
---

## Installation

Add the  `@appsignal/plugin-path-decorator` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add -D @appsignal/javascript @appsignal/plugin-path-decorator
npm install --save @appsignal/javascript @appsignal/plugin-path-decorator
```

## Usage

The `plugin-path-decorator` is a plugin that decorates all outgoing `Span`s with the current path. This is computed by reading from `window.location.pathname`.

```javascript
import { plugin } from `@appsignal/plugin-path-decorator`
appsignal.use(plugin(options))
```

## `plugin` options

The plugin currently takes no options as parameters.
