---
title: "Node.js Core"
---

Node.js contains several internal modules designed to enable asynchronous I/O capable APIs for your application. AppSignal provides automatic instrumentation for many of these modules.

## `http`

AppSignal for Node.js will auto-instrument any incoming HTTP calls. When you create a new `Span`, it will be child of the `Span` created by the core HTTP integration.

## `https`

Appsignal for Node.js will also auto-instrument any incoming HTTPS calls. When you create a new `Span`, it will be child of the `Span` created by the core HTTPS integration, if the `https` module was used.
