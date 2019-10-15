---
title: "plugin-breadcrumbs-network"
---

The `@appsignal/javascript` plugin for automatically adding a breadcrumb on every network request. Works with both `XMLHttpRequest` and `fetch`.

## Installation

Add the  `@appsignal/plugin-breadcrumbs-network` and `@appsignal/javascript` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```
yarn add @appsignal/javascript @appsignal/plugin-breadcrumbs-network
npm install --save @appsignal/javascript @appsignal/plugin-breadcrumbs-network
```

## Usage

```js
import Appsignal from "@appsignal/javascript"
import { plugin } from "@appsignal/plugin-breadcrumbs-network"

const appsignal = new Appsignal({ 
  key: "YOUR FRONTEND API KEY"
})

appsignal.use(plugin(options))
```

### `plugin` options

The `plugin`  can be initialized with the following options:

| Param | Type | Description  |
| ------ | ------ | ----- |
|  xhrEnabled  |  Boolean  |  (optional) A boolean value representing whether the plugin should bind to `XMLHttpRequest`. Defaults to `true`. |
|  fetchEnabled  |  Boolean  |  (optional) A boolean value representing whether the plugin should bind to `fetch`. Defaults to `true`. |

