---
title: "Tracing"
---

AppSignal provides many ways to provide more insights in your application - by adding more instrumentation, or tagging the data that appears in the UI at AppSignal.com. All of the information that we collect from your application forms part of a broader **trace**, a visual representation of the flow of data through your application.

**Traces** are made of one or many `Span`s. A Trace can be thought of as a _directed acyclic graph (DAG)_ of `Span`s:

![Trace diagram](/assets/images/abstract-trace.png)

## Table of Contents

- [The Tracer object](/nodejs/instrumentation/tracer.html)
- [Async tracing and Scopes](/nodejs/instrumentation/scopes.html)
- [Creating and using a Span](/nodejs/instrumentation/span.html)
- [Span API](/nodejs/instrumentation/span-api.html)
