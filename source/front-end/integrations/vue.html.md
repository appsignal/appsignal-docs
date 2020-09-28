---
title: "@appsignal/vue"
---

## Installation

Add the `@appsignal/vue` and `@appsignal/javascript` packages to your `package.json`. Then, run `npm install`/`yarn install`.

You can also add these packages to your `package.json` on the command line:

```sh
yarn add @appsignal/javascript @appsignal/vue
npm install --save @appsignal/javascript @appsignal/vue
```

## Usage

### `Vue.config.errorHandler`

The default Vue integration is a function that binds to Vue's global `errorHandler` hook.

#### Vue v2

In a new Vue v2 app created using `@vue/cli`, your `main.js`/`.ts` file would look something like this:

```js
import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";

import Appsignal from "@appsignal/javascript";
import { errorHandler } from "@appsignal/vue";

const appsignal = new Appsignal({
  key: "YOUR FRONTEND API KEY",
});

Vue.config.errorHandler = errorHandler(appsignal, Vue);

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
```

#### Vue v3

Version 3 of Vue includes a change to the way you'd use our Vue integration. Instead of attaching it to the global `Vue` object, you would use it like this instead:

```js
import { createApp } from "vue";
import App from "./App.vue";

import Appsignal from "@appsignal/javascript";
import { errorHandler } from "@appsignal/vue";

const appsignal = new Appsignal({
  key: "YOUR FRONTEND API KEY",
});

const app = createApp(App).mount("#app");

app.config = {
  errorHandler: errorHandler(appsignal),
};
```
