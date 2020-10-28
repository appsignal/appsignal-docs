---
title: "Add a new application"
---

To get a new app running on AppSignal, start by clicking the "add app" link on the application overview page, or use this link to the ["add app" wizard for your organization](https://appsignal.com/redirect-to/organization?to=sites/new).

![Add app](/assets/images/screenshots/dashboard.png)

In the wizard you will first be asked for what language you want to install AppSignal. We currently support Ruby, Elixir & Node.js for error and performance monitoring, and JavaScript for front-end error monitoring.

After choosing a language you will be presented with instructions on how to install AppSignal in your app.

Once the app is deployed AppSignal will start receiving data and you're good to go!

## Installation instructions

Some language integrations and support for libraries require some manual steps to get set up. Please see our installation instructions for the language of your app for more information.

- [Ruby installation instructions](/ruby/installation.html)
- [Elixir installation instructions](/elixir/installation/)
- [Node.js installation instructions](/nodejs/installation.html)
- [Front-end JavaScript installation instructions](/front-end/installation.html)

AppSignal will detect and register new Ruby, Elixir & Node.js applications when it receives data from the application and not before it. Using their installers this should be done automatically. When installing AppSignal manually, please use the demo command line tool ([Ruby](/ruby/command-line/demo.html) / [Elixir](/elixir/command-line/demo.html)) or start your application and perform some requests/jobs to send data to AppSignal.com.

JavaScript applications will create an app beforehand that generate an application-specific Push API key to be used for that application.

## Next steps

- [Configuring applications](/guides/configuration.html) - next guide

---

- [Getting started guides](/guides/) - Guides overview
