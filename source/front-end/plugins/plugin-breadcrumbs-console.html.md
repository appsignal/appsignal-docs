---
title: "plugin-breadcrumbs-console"
---

The `@appsignal/javascript` plugin for automatically adding a breadcrumb on every call to any of the [supported `console` methods](https://github.com/appsignal/appsignal-javascript/blob/develop/packages/plugin-breadcrumbs-console/src/index.ts#L3), e.g. `console.log`, `console.warn`.

## Installation

Add the  `@appsignal/plugin-breadcrumbs-console` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/plugin-breadcrumbs-console
npm install --save @appsignal/javascript @appsignal/plugin-breadcrumbs-console
```

## Usage

```js
import Appsignal from "@appsignal/javascript"
import { plugin } from "@appsignal/plugin-breadcrumbs-console"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

appsignal.use(plugin(options))
```

### `plugin` options

The `plugin`  currently recieves no options.
