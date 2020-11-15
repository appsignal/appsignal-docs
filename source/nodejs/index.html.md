---
title: "AppSignal for Node.js"
---

AppSignal now supports [Node.js](https://nodejs.org/)!

We're proud to bring the same great performance monitoring and error tracking that we offer Ruby and Elixir customers to the Node.js ecosystem. The package supports pure JavaScript applications and TypeScript applications and can auto-instrument various frameworks and packages with optional plugins. Other frameworks and packages might require some custom instrumentation.

The new Node.js implementation contains some concepts that vary from the Ruby and Elixir implementations. Be sure to check out the [Tracing section][tracing] to familiarize yourself with any differences.

## Supported environments

Our Node.js support tracks the active LTS release and above, which is currently [v10](https://github.com/nodejs/Release) and above.

Node.js is an incredibly flexible runtime, which allows it to be used for a multiple of different use-cases. AppSignal was primarily designed for use on a server, so there are a few places that the Node.js integration is currently not suitable:

- ❌ **Electron apps:** We don't recommend using `@appsignal/nodejs` inside [Electron](https://www.electronjs.org/) applications. As we designed the [agent](/appsignal/terminology.html#agent) to run on a server, it is not currently useful in this environment. It will also lead to possibly [unwanted complexity around cross-compilation](https://www.electronjs.org/docs/tutorial/using-native-node-modules) of the native extension.
- ❌ **Short-lived processes:** Short-lived processes, such as CLI tools, are a poor fit for the agent, which must be able to stay running for a period of time (at least 60 seconds).
- ❌ **Serverless functions:** Serverless functions are meant to be short-lived processes, so they are also a poor fit for the agent.
- ❌ **Statically generated apps:** Some environments (e.g [Gatsby.js](https://www.gatsbyjs.com/), [Next.js on Vercel](https://vercel.com/docs/next.js/overview), [Svelte](https://svelte.dev/) offer some access to Node.js APIs but ultimately compile thier code down to a client side application, and therefore aren't suitable for the Node.js library.

But don't worry! The [`@appsignal/javascript` library](/front-end/) does not require the agent and will work in the places that `@appsignal/nodejs` doesn't currently work, but only error tracking is supported at the moment.

[installation]: /nodejs/installation.html
[configuration]: /nodejs/configuration
[tracing]: /nodejs/tracing
[metrics]: /nodejs/metrics
[integrations]: /nodejs/integrations
