---
title: "PagerDuty"
---

[PagerDuty](https://www.pagerduty.com) is a great tool to make sure the right person is notified when an error occurs.

AppSignal notifies PagerDuty when performance issues or errors occur. New deploys are not sent to PagerDuty.

## Setup

AppSignal requires a `routing_key` from PagerDuty to send error and performance notifications.

You can create a `routing_key` by adding a new "Integration" under "Configuration" > "Service Directory" > "New service".

Make sure that for "Integration type" the 3rd option (Use our API directly) is checked and "Events API V2" is selected.
The other details can be filled out at your own discretion.

![PagerDuty config](/assets/images/screenshots/pagerduty/service.png)

After saving the form, you can see the `routing_key`.

Use this service key on the AppSignal PagerDuty integration form. After saving, make sure the integration works by clicking "Test hook". If all goes well, it should trigger an incident on PagerDuty.

As always, if you run into any issues, don't hesitate to contact us at <a href="mailto:contact@appsignal.com">contact@appsignal.com</a>.
