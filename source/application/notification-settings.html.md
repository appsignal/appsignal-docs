---
title: "Notification settings"
---

Whenever AppSignal detects a new error or performance measurement, we open an incident. You can find the incidents in the [Errors](https://appsignal.com/redirect-to/app?to=exceptions) and [Performance](https://appsignal.com/redirect-to/app?to=performance) sections.

AppSignal can send out notifications whenever a new incident, or new instances of an already existing incident, is detected. Notifications can happen by email or by one of our [many notifiers](/application/integrations/).

## Notification options

Whenever a new incident gets created it will inherit the [app's notification defaults](#app-notification-defaults). When an [Error](#error-incident-notification-settings) or [Performance](#performance-incident-notification-settings) incident has been created, its notification settings can be changed on the incident page itself.

If an incident was closed, it will be reopened when a new notification is sent out.

There are four notification options available:

- **Every occurrence**
  - A notification is sent every time an incident is triggered. This option has a cool down of 5 minutes. This means that if an incident is triggered 20 times a minute, for 20 minutes, you'll receive a notification on minute 0, 5, 10, 15 and 20.
- **First in deploy**
  - A notification is sent on the first occurrence of an incident after a new deploy marker is received. You'll need to set up [deploy markers](/application/markers/deploy-markers.html) for AppSignal to detect a deploy and know when an incident occurred for the first time in a deploy.
- **First after close**
  - A notification is sent at the first occurrence of an incident after the incident was previously closed. Incidents can opened and closed in the sidebar in the Incident detail page. This option is is a good option for incidents that aren't triggered by a code bug, but out an outside source (e.g. 3rd party has a connection issue) and can't be closed by deploying a new version of the app.
- **Never notify**
  - No notification is ever sent out when the incident is triggered. Mostly used for errors that will continue to happen and you'd like to keep track of, but aren't getting fixed soon. If you don't want to receive the incident at all, [ignoring the action](/application/data-collection.html#ignore-actions) or [ignoring the error](/application/data-collection.html#ignore-errors) may help.

## Error incident notification settings

Error incidents are identified by the error (class)name, such as `ActiveRecord::RecordNotFound` and if the error happened inside of an action, the action name. (e.g. `StandardError` in `BlogpostsController#show`).

![Error incident notification options](/assets/images/screenshots/error_incident_notification_options.png)

## Performance incident notification settings

Performance incidents are identified by their "action" name, such as `BlogpostsController#show`.

Once we detect a new action we create an incident for it. At this point you can override the default notification settings and change when you'd like to be notified and what threshold the duration of the performance incident has to reach before a notification is sent.

E.g. for actions where response times can be slow, because they interact with 3rd parties, you can set the duration threshold to 10 seconds, while for the homepage you can set a threshold of 200 milliseconds.

The threshold filter is used in combination with the notification settings. E.g. if you have **First in deploy** and **200ms** as the notification settings and threshold, an incident occurrence has to satisfy both in order for a notification to be sent out.

![Performance incident notification options](/assets/images/screenshots/performance_incident_notification_options.png)

## Organization and app namespace defaults

Notification settings on an incident can only be changed after it has occurred at least once. This can be an issue if you never want to be notified, or want to set a different performance incident threshold than the default 200 milliseconds.

It's possible to configure notification defaults [per app namespace](#app-notification-defaults) or even [for the entire organization](#organization-notification-defaults). This will make it easier to apply the desired notification settings to all new incidents and all existing incidents, for which the notification settings haven't been customized.

### App notification defaults

Each application has its own [namespace defaults][app notifications] for notification settings. A new incident in the specified namespace will inherit the default settings set on this page. For more information, see the [notification defaults inheritance](#notification-defaults-inheritance) section.

It's recommended to split up the application in [namespaces](/application/namespaces.html) that group potential incidents by severity. This way you can configure notification settings for a group of incidents and there's no need to configure each incident separately. For example, for an app's admin panel you could create a namespace called `admin` with a default notification setting of "Never notify" as errors that occur in this namespace have less priority.

![Errror incident notification defaults](/assets/images/screenshots/error_incident_notification_defaults.png)

### Organization notification defaults

It's also possible to set up notification defaults on your organization. These defaults will be used when AppSignal detects and creates a new application. When it creates the new app it will apply the organization's notification defaults as the app's app notification defaults. Changes to the organization notification defaults do not apply to already existing apps. For more information, see the [notification defaults inheritance](#notification-defaults-inheritance) section.

These organization level [notification defaults][org notifications] can be set up in the organization's admin panel. It's possible to configure defaults for each namespace detected in any of the current applications in your organization.

![Performance incident notification defaults](/assets/images/screenshots/performance_incident_notification_defaults.png)

## Notification defaults inheritance

The notification settings bubble up from the incident settings to the app's namespace settings. If the notification settings for an incident aren't changed the app's namespace defaults are used. This means you can also change all the incident notification settings for incidents that haven't customized their notification settings by changing the app defaults.

- When a new app is detected by AppSignal, the [organization's namespace defaults][org notifications] are applied.
  - When organization namespace notification defaults are changed, they only apply to new apps.
- When an [app's namespace notification defaults][app notifications] are changed, they apply to all new incidents and existing incidents without customized notification settings.
- When a new incident is detected by AppSignal, the [app's namespace defaults][app notifications] are used.
- When an incident's notification settings are customized, the incident's customized notification settings are used from then on.

[app notifications]: https://appsignal.com/redirect-to/app?to=notifications
[org notifications]: https://appsignal.com/redirect-to/organization?to=admin/notifications/edit
