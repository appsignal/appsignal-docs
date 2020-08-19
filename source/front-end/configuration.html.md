---
title: "AppSignal for JavaScript configuration"
---

## `Appsignal` options

The `Appsignal` object can be initialized with the following options:

| Param | Type | Description  |
| ------ | ------ | ----- |
|  key  |  string  |  Your AppSignal Push API key.  |
|  uri  |  string  |  (optional) The full URI of an AppSignal Push API endpoint. This setting will not have to be changed. |
|  namespace  |  string  |   (optional) A namespace for errors.  |
|  revision  |  string  |   (optional) A Git SHA of the current revision. |
|  ignoreErrors  |  RegExp[]  |   (optional) An array of `RegExp`s to check against the `message` property of a given `Error`. If it matches, the error is ignored. |
