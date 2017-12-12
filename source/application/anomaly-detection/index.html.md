---
title: "Anomaly detection"
---

With Anomaly detection you can configure Triggers to send notifications when a metric value goes over, or dips below, a threshold. For example: When the error rate of an application goes over 5 % or free memory dips below 100MB.

Anomaly detection works by detecting changes in metric values on a minutely basis. When a threshold condition is reached we will notify you of the new alert created by this event, and we'll notify you again when the situation no longer occurs.

Sometimes it's good to know immediately when a threshold is reached, at other times it may be good to wait a few minutes before alerting you. For this you can use [warm-ups and cooldowns](#warm-up-and-cooldown).

## Table of Contents

- [Alert states](#alert-states)
- [Triggers](#setting-up-triggers)
  - [Editing triggers](#editing-triggers)
- [Warm-up and cooldown](#warm-up-and-cooldown)
  - [Warm-up](#warm-up)
  - [Cooldown](#cooldown)

## Alert states

TODO: Some text explaining the flow of alerts.

<object data="/images/anomaly_detection_alerts_flow.svg"></object>

## Setting up triggers

Anomaly detection can be configured per app in the "Anomaly detection" section in the main navigation. By default you will see the latest alerts created by triggers that you've configured for the app.

In the top navigation you can switch to the triggers page to create new and edit existing triggers.

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

When a metric value goes over a certain threshold condition it will open an Alert. When a warm-up time is configured it will wait with notifying you until after the warm-up time, as long as the metric value is still above the threshold.

If the Alert is no longer occurring when the warm-up time is over the Alert is immediately closed. You can still see the occurrence in the AppSignal web interface, but no notification will be send.

### Cooldown

When an Alert is opened by a Trigger it will automatically close when the Trigger threshold condition is no longer reached. When the threshold is reached again it will open another Alert. This may result in more notifications than wanted.

In order to not get overwhelmed with notifications about a Trigger threshold condition that constantly dips below and above a certain value you can use Trigger cooldowns.

Triggers with cooldowns wait for the specified amount of time in minutes before closing an Alert. When it doesn't occur again in the cooldown time the Alert is finally closed. If it does occur, the Alert is reopened without an explicit notification.
