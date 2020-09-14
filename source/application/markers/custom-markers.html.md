---
title: "Custom markers"
---

Markers are little icons used in graphs on AppSignal.com to indicate a change.
This can be a code deploy using a ["Deploy marker"](deploy-markers.html) or a
special event with a "Custom marker".

Custom markers can be used for anything from scaling operations, to sudden
spikes in traffic and infrastructure issues such as when a database was acting
up.

See also our announcement posts about Custom markers:

- [Introducing custom markers](http://blog.appsignal.com/2016/10/28/custom-markers.html)
- [Add custom markers from any graph](http://blog.appsignal.com/2016/11/28/custom-markers-from-any-graph.html)

## Creating a custom marker

A custom marker can be created in two ways. Through the UI on AppSignal.com on
the graphs or with a request to our API.

### Using the Graph UI

When on AppSignal.com open a page with a graph on it, any graph. Hover over a
space in a graph and you will be presented with a "Add marker" button. In the
"Add marker" lightbox, select an icon, set a message and create your marker. To
edit or delete a marker, click on the icon and you will be brought back to the
editor.

### Using the AppSignal API

Please read our [Markers API endpoint documentation](/api/markers.html) page
for more information on how to create a marker using the AppSignal API.
