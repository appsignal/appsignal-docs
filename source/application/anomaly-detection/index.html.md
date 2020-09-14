---
title: "Anomaly detection"
---

With [Anomaly detection](https://appsignal.com/redirect-to/app?to=alerts) you can configure Triggers to send notifications when a metric value goes over, or dips below, a threshold value. For example: When the error rate of an application goes over 5 % or free memory dips below 100MB.

Anomaly detection works by detecting changes in metric values on a minutely basis. When a threshold condition is reached we will notify you of the newly alert created by this event, and we'll notify you again when the situation no longer occurs.

Sometimes it's good to know immediately when a threshold is reached, at other times it may be good to wait a few minutes before alerting you. For this you can use [warm-ups and cooldowns](#warm-up-and-cooldown).

## Alert states

Alerts can have four different states:

- **Warming up** means that this Alert is in its warm-up phase. You can configure this per Trigger. It allows you to wait for a condition to be true for a few minutes before you get alerted.
- **Ongoing** means that this Alert is active. Its threshold condition is currently reached.
- **Cooling down** means that an Alert is not over the threshold condition anymore, but will not be closed until the cooldown duration is over. If it reaches its threshold again within the cooldown period, it will move back to the "ongoing" status.
- **Closed** means the Alert is not ongoing and not in the cooling down period. We don't call them "solved" because you still might want to look at what happened here.

    <img src="/assets/images/anomaly_detection_alerts_flow.svg" class="full">

### When will I be notified?

After you've configured notifications, you will be notified when an alert goes into the ongoing phase, for reminders you set up during that phase, and when it's closed again.

### Email alerts

In each email you receive about any alert, we'll send you a full overview of all your alerts. You'll see an overview of new alerts, reminders, ongoing alerts and closed alerts.

## Setting up triggers

Anomaly detection can be configured per app in the ["Anomaly detection" section](https://appsignal.com/redirect-to/app?to=alerts) in the app navigation. By default you will see the latest alerts created by triggers that you've configured for the app.

In the top navigation you can switch to the [triggers page](https://appsignal.com/redirect-to/app?to=triggers) to create new and edit existing triggers.

Triggers can be configured for a variety of metrics, such as, but not limited to:

- Error rates
- Error (absolute) counts
- App throughput
- Performance of actions (slow actions)
- Queue time
- Host metrics
  - CPU load
  - Disk I/O
  - Disk usage
  - Load averages
  - Memory usage
  - Network usage

### Editing triggers

Created Alerts are based on a certain threshold condition from a Trigger. When the Trigger configuration changes, the linked alerts no longer match with the parent Trigger. For this reason it's not possible to directly edit a Trigger's configuration.

Instead, when editing a Trigger, a new Trigger with the new configuration is created while the old Trigger and its linked Alerts are archived. Currently, archived Triggers and Alerts are not visible in the AppSignal web interface.

## Warm-up and cooldown

Warm-up and cooldown settings can be configured on a per Trigger basis. The setting allows you to configure the amount of minutes the system waits before opening an Alert and closing it.

### Warm-up

An Alert is opened when a Trigger's threshold condition is met (e.g. the error rate is higher than 5%).

When a trigger has a warm-up period configured, the alert will only open once the warm-up time has passed. The threshold condition must be met for the entire warm-up period for the alert to open.

When the threshold isn't met for the entire warm-up period, the alert is removed. These alerts aren't included in the [alerts table](https://appsignal.com/redirect-to/app?to=alerts). This reduces noise in the alerts table.

Alerts in the warm-up phase are displayed in the AppSignal web interface, but they do not send any notifications. 

### Cooldown

Alerts opened by a Trigger are automatically closed when the threshold condition is no longer met. If the threshold is met again, another alert will open. If a metric keeps dipping above and below the threshold, this will cause noisy notifications.

Use cooldown periods to reduce this noise. A trigger with a cooldown will wait for the specified amount of time before closing an alert. If the threshold isn't met during the cooldown period, the alert is closed. If the threshold is met, the alert is reopened without a notification. 

## Data processing

The metrics used by triggers to create alerts are not instantly processed when the metrics are sent in the app. The metrics data goes through multiple systems before it arrives in our processor. The data may also need to be sent from multiple servers, [sending data at different intervals](/appsignal/how-appsignal-operates.html#agent). The processor then waits* until all the data for a minute has arrived before processing that data and creating/updating alerts.

If you experience problems with the metrics being reported by AppSignal for Anomaly detection, make sure the app's servers are all reporting the same time by configuring them using [NTP](https://en.wikipedia.org/wiki/Network_Time_Protocol). Incorrect or different reported times for data sent by multiple app servers can result in Alerts never being opened or closed.

Learn more about how AppSignal processes data for Anomaly detection and what this means for the alerts on the [data life cycle page][data life cycle].

*: For the specific wait time, consult our [data life cycle page][data life cycle].

[data life cycle]: /appsignal/data-life-cycle.html
