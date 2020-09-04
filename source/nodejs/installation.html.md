---
title: "Installation"
---

## Installing Appsignal for Node.js

!> In order to auto-instrument modules, the `Appsignal` module must be both *required and initialized before any other package*.

First, sign up for an AppSignal account and add the `@appsignal/nodejs` package to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs
npm install --save @appsignal/nodejs
```

You can then import and use the package in your bundle:

```js
const { Appsignal } = require("@appsignal/nodejs")

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>"
})
```

!> Installing the AppSignal for Node.js integration builds a native extension. In order to compile it, macOS users will need to install the [Xcode Developer Tools](https://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/). Linux users will need the dependencies outlined [here](https://github.com/nodejs/node-gyp#installation). **Windows is not supported.**

## Uninstalling Appsignal for Node.js

Uninstall AppSignal from your app by following the steps below. When these steps are completed your app will no longer send data to the AppSignal servers.

1. In the `package.json` of your app, delete all lines referencing an `appsignal` package: `"*appsignal/*": "*"`.
2. Run `npm install` or `yarn install` to update your `package.lock`/`yarn.lock` with the removed packages state.
   - Alternatively, run `npm uninstall @appsignal/<package name>` or `yarn remove @appsignal/<package name>` to uninstall an AppSignal package.
3. Remove any AppSignal [configuration](/nodejs/configuration/) from your app.
4. Commit, deploy and restart your app.
  - This will make sure the AppSignal servers won't continue to receive data from your app.
5. Finally, [remove the app](/application/#removing-an-application) on AppSignal.com
