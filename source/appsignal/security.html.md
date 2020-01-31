---
title: "Security overview"
---

These are the things we do at AppSignal to keep your data safe.

## Language specific libraries

The [Ruby gem](https://github.com/appsignal/appsignal-ruby) and the [Elixir package](https://github.com/appsignal/appsignal-elixir) are public code, hosted on GitHub. You can browse the source to see how we handle the data. Our closed-source [agent](/appsignal/terminology.html#agent) will send the actual data to the AppSignal servers.

We have built several systems to filter or redact sensitive data from reaching our servers, please see the [scrub data guide](/appsignal/scrub-data) for more information.

## System agent

With the release of the AppSignal Ruby gem version 1.0 on the 12th of January 2016 we started shipping all our language specific libraries with a system agent.

When an application with AppSignal integration starts the language integration starts a separate UNIX process. The Ruby gem and Elixir package will send all transaction samples to this agent through a UNIX socket. The agent will periodically sends the transaction samples to the AppSignal servers.

The system agent will also collect host specific data such as CPU usage, load average, memory usage, disk usage, etc. See the [Host metrics](/metrics/host.html) for more information.

The data is sent through a secure (SSL) connection to our servers.

The code of this system agent is not publicly available, but uses the same basic principle of how our Ruby gem pre `1.0` sends the data to our servers.

## Payment information

All payments are handled through [Stripe](https://stripe.com). We do not store
or log any credit card information on our servers. The payment provider is PCI
compliant, and all credit card and other payment data is also sent over a
secure (SSL) connection.

## The AppSignal application

AppSignal runs exclusively on secure (SSL) connections and is hosted in a top
tier data center. The data center is monitored 24/7, both physically and
virtually. Your data is stored redundantly and any sensitive information is
stored in separate databases from other customers and long-term data (e.g.
graphs). Our systems are kept up-to-date with the latest security patches and
our network is locked down with firewalls and limited access.

## Your data

All the data we collect from your application is yours and can be retrieved at any point in time through [our API](/api/index.html). You can remove your data at any time in the [App Settings](https://appsignal.com/redirect-to/app?to=edit) for your app.

## Incidents

If you think you've found a security issue with regards to our application,
network or integrations, please let us know immediately by sending an email to
[security@appsignal.com](mailto:security@appsignal.com).
