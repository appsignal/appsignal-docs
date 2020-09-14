Sometimes you have a certain action that you don't want to send to AppSignal. The most common use case is an action that your load balancer uses to check if your app is still responding or your entire administration panel.

You can ignore data from these actions being sent to AppSignal by ignoring their specific action name or their namespace in your app's [configuration](../configuration). This works for any code that is wrapped in an AppSignal transaction, such as a controller action or a background worker. The configured action and namespace names should match the action names that are reported in your app in the AppSignal.com UI.

Ignoring actions or namespaces will **ignore all transaction/span data** from this action or namespace. No errors and performance issues will be reported. [Custom metrics data](/metrics/custom.html) recorded in an action will still be reported.
