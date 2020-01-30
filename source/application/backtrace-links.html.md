---
title: "Backtrace links"
---

With backtrace links you can spend less time figuring out where an exception happened and more time debugging the exception. Backtrace links make every line to source code in your app link to your app's source code on your source code hosting platform of choice.

![Backtrace with Git link](/assets/images/screenshots/backtrace_links.png)

## Steps to enable backtrace links

To enable backtrace links an app on AppSignal.com needs to:

1. [Enable deploy markers](/application/markers/deploy-markers.html).
  - This will allow AppSignal to link to the specific revision of the source code in which the error occurred.
2. Configure the "repo url" for an application, or [link your organization to GitHub](https://appsignal.com/redirect-to/organization?to=admin/integrations/github), so AppSignal knows where to link to.
  - See the steps below for either option.

## Configure the repo url

Owners of an Organization can specify a Repo url on [the app settings page](https://appsignal.com/redirect-to/app?to=edit). This is especially useful for Git hosting platforms that are not GitHub (e.g. GitLab/BitBucket) or private repositories.

![App settings repo URL form](/assets/images/screenshots/repo_url.png)

## Link your app to GitHub

Alternatively organization owners can [link an app to GitHub](https://appsignal.com/redirect-to/app?to=integrations) and the "repo url" from the selected repository will be stored automatically. With the GitHub integration you'll also be able to send incidents to GitHub directly from AppSignal.

Once the steps are completed we'll automatically enrich the backtrace lines with a link to the correct revision/file/line on the specified Git repository.
