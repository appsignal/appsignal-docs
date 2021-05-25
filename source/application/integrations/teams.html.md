---
title: Microsoft Teams
---

Microsoft Teams, the hub for team collaboration in Microsoft 365, integrates the people, content, and tools your team needs to be more engaged and effective.
Google Hangouts Chat is a global integration set up per App.

Website: [microsoft.com/teams](https://microsoft.com/teams)

!> **Warning:** Do not use the "official" [Teams integration from Microsoft](https://appsource.microsoft.com/en-us/product/office/wa104381595?tab=overview). This integration is not supported by AppSignal and as far as we know does not work. It was built without knowledge or consent from AppSignal.

## Adding MS Teams integration to you app

Adding the integration consists of two steps, one on Google Hangouts Chat and one on AppSignal.

### Incoming webhook
Either configure a "connector" under the channel options, or if that option is not available, click the apps icon at the bottom right and search for "Incoming Webhook" and click "Add to team".

<img src="/assets/images/screenshots/teams/webhook.png" style="max-width: 650px" alt="Teams Webhook">

After a couple of redirects you should see a webhook configuration form with a name and image. Choose a descriptive name (e.g. `Errors in #general`).

### AppSignal

On the desired app, head to "Notifiers" and select "MS Teams"

<img src="/assets/images/screenshots/teams/appsignal_form.png" style="max-width: 650px" alt="Teams Webhook Form">

You can test the integration after saving the form, a message should appear in your MS Teams channels.

<img src="/assets/images/screenshots/teams/test.png" style="max-width: 650px" alt="Teams Webhook Test">


If anything went wrong while validating the integration your will be prompted with the error message.
Feel free [contact us](mailto:support@appsignal.com) if you experience any problems while setting up this integration.
