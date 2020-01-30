---
title: "Backtrace links"
---

With backtrace links you can spend less time figuring out where an exception happened and more time debugging the exception.


To enable backtrace links we need to:

* [Enable deploy markers](http://localhost:4567/application/markers/deploy-markers.html).
* Configure the "repo url" for an application, or link your organisation to GitHub.

## Configure the repo url

Owners of an Organisation can specify a Repo url on [the app settings page](https://appsignal.com/redirect-to/app?to=edit).

![App settings repo URL form](/assets/images/screenshots/repo_url.png)

## Link your organisation to GitHub.

Alternatively organisation owners can [link the organisation](https://appsignal.com/redirect-to/app?to=integrations) to GitHub and we'll fill out the "repo url" from the selected repository automatically. You'll also be able to send incidents to GitHub directly from AppSignal.

Once the steps are completed we'll automatically enrich the backtrace lines with a link to the correct revision/file/line on the specified Git repository.

![Backtrace with Git link](/assets/images/screenshots/backtrace_links.png)
