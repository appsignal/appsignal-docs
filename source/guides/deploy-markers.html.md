---
title: "Reporting deploys to track improvements"
---

Every time an app gets deployed, changes that affect the app start running. By tracking deploys in AppSignal, error incidents and performance measurements are grouped per deploy. They will also allow for AppSignal.com to link directly from an [error backtrace]([error backtrace links]) to the line of code in your app for that version of the app.

We will track deploys in AppSignal using deploy markers. Read more about [deploy markers], what they're used for, how to send them, and more.

## Configuring AppSignal

To report deploys to AppSignal we will use [deploy markers]. In this guide we will focus on the `revision` config option method of reporting deploy markers. (Other methods may be available, more details about why we prefer this method can be found on the [deploy markers] page.)

The `revision` config option is configured differently per integration language. See the list of integrations below for the one your app uses.

Heroku apps using the "Dyno Metadata" labs feature will [automatically report deploys][heroku support].

### Automatically update the revision

We recommend fetching the revision config option value from the SCM (Git/SVN/other) system dynamically on start or on deploy. This way the value doesn't have to be manually updated per deploy. If a Git SHA (or other SCM revision value) is used it will also be compatible with [error backtrace links].

An example for Git:

```bash
git log --pretty=format:'%h' -n 1
# Will output the current commit's short SHA
```

We will use the Git example in the integration examples below.

### Ruby

In the Ruby integration we will load the Git revision in the `config/appsignal.yml` config file. By using ERB we call the `git log` command and set the output as the `revision` config option.

```ruby
# config/appsignal.yml
production:
  revision: "<%= `git log --pretty=format:'%h' -n 1` %>"
  # Other config
```
[Ruby `revision` configuration option details](/ruby/configuration/options.html#option-revision)

### Elixir

In the Elixir integration we will load the Git revision in the `config/appsignal.exs` config file (your file location may differ). In this `.exs` command we call the `git log` command with Elixir and set the output as the `revision` config option.

```elixir
# config/appsignal.exs
{revision, _exitcode} = System.cmd("git", ["log", "--pretty=format:%h", "-n 1"])
config :appsignal, :config,
  revision: revision
  # Other config
```
[Elixir `revision` configuration option details](/elixir/configuration/options.html#option-revision)

### Node.js

In the Node.js integration load the Git revision in the app's config file. In this `.js` command we call the `git log` command with Node.js and set the output as the `revision` config option.

```javascript
var childProcess = require("child_process");
var REVISION = childProcess.execSync("git log --pretty=format:'%h' -n 1").toString();
const appsignal = new Appsignal({
  revision: REVISION
  // Other config
})
```
[Node.js `revision` configuration option details](/nodejs/configuration/options.html#option-revision)

### JavaScript

In the front-end JavaScript integration it's not possible to call the `git` executable, because the integration runs in the browser. Instead, set the "revision" value from the back-end app—such as a Rails or Phoenix app—into the HTML body as a property. Then load that property in the JavaScript config file.

```html
<body data-app-revision="REVISION VALUE">
  <!-- Rest of the HTML -->
```

```javascript
const body = document.querySelector("body");
const appsignal = new Appsignal({
  revision: body.dataset.appRevision
  // Other config
});
```
[JavaScript `revision` configuration option details](/front-end/configuration/options.html#option-revision)

## Deploy

After the app has been configured with the `revision` option, commit your changes and deploy the app. When the app starts AppSignal will create a deploy in the [deploys section] for your app.

Are deploys not being reported or incorrectly? [Contact us][contact] and we will help you out!

## Next steps

- [Grouping parts of your app with namespaces](/guides/namespaces.html) - next guide
- [Setting up backtrace links][error backtrace links]

---

- [Add a new application](/guides/new-application.html) - previous guide
- [Getting started guides](/guides/) - Guides overview

[deploy markers]: /application/markers/deploy-markers.html
[heroku support]: /application/markers/deploy-markers.html#heroku-support
[error backtrace links]: /application/backtrace-links.html
[deploys section]: https://appsignal.com/redirect-to/app?to=markers
[contact]: mailto:support@appsignal.com
