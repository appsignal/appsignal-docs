---
title: "The life cycle of app data"
---

There are a lot of moving parts working together to get the data from apps on your servers to AppSignal's servers and finally in a human readable format on AppSignal.com. This page will describe the process data from apps follow to become incident data, entries in tables, points in graphs, alerts for [Anomaly detection](/application/anomaly-detection) and notifications.

AppSignal is eventually consistent. This means that, even though we try to minimize this, there is no arbitrary duration between a request, background job or metric data being recorded in an app and this data being displayed data on AppSignal.com.

Requests that are sent later than others will appear first in AppSignal.com. By breaking down the process we can tell you why this happens.

## Language libraries

The AppSignal language libraries ([Ruby](/ruby), [Elixir](/elixir), [JavaScript for Front-end](/front-end)) collect transaction and metrics data. [Transactions](/appsignal/terminology.html#transactions) are HTTP requests, background jobs and other custom transactions. Metrics data is based on the transaction data but can also be set using our [custom metrics](/metrics/custom.html).

Each incoming HTTP request, or background job, is wrapped in a "transaction". This transaction collects all instrumentation that's being generated during the request, this includes events, parameters, session data and tags. When your app has served the request, the transaction is closed and sent to our agent and placed into a queue. This queue consists of transaction and metrics data.

The [AppSignal agent](/appsignal/terminology.html#agent) transmits this transaction and metrics data in combined payloads every 30 seconds to the [Push API](#push-api). The transmission interval for app instances do not all occur at the same exact time. Exactly when the agent transmits data is based on when in a minute the agent was started. This means that data for the same second on two different app instances can arrive about 30 seconds apart, not including retries. This the reason AppSignal is eventually consistent.

Read more about how the language libraries, our extension and agent work together to get the data from your app to the AppSignal servers on the [How our integrations operate](/appsignal/how-appsignal-operates.html) page.

## Push API

Our Push API only has one purpose, to receive data from apps and push it onto a queue as fast and efficiently as possible. From here our processors start processing the transaction and metric data from the apps.

## Processing

The AppSignal processor will store new samples for errors and performance measurements based on the transactions, create new incidents or update existing incidents, create metrics based on the transaction data and process custom metrics.

During this process we also detect changes in metrics specified in Anomaly detection Triggers to create and notify about new and on going alerts. Read more about how this is done in the [Anomaly detection](#anomaly-detection) section.

The processed data then gets stored in our data buckets. This is split between minutely and hourly metrics buckets for your organization. We store data in the minutely resolution for up to 12 hours, after which it is still available in the hourly resolution.

Finally when all the processing is done we send out [notifications](/application/integrations/) for new errors, new performance measurements, deploys and [Anomaly detection](#anomaly-detection) alerts.

### Anomaly detection

When metric data arrives in our processors, or is created by our processors, they are not immediately used to process [Anomaly detection](/application/anomaly-detection) Triggers to create or update alerts. The AppSignal processors wait for up to _180 seconds_ (3 minutes) before processing data for a minute. This delay about the same maximum delay [<sup>1</sup>][retries] it takes for metrics to appear in graphs on AppSignal.com.

Read on to learn why this processing delay is present.

#### Transmitting the data

Like transaction data from [language libraries](#language-libries), metrics data goes through multiple systems to end up at our servers. This process takes time. Our processor needs to wait for the AppSignal agent transmission interval after a minute has passed, before it can process data for that minute.

#### Clock drift on app servers

 Read more about how AppSignal handles time, what clock drift is and how to set up NTP synchronization on our [about time page](/support/about-time.html).

#### Processing of metrics data

After waiting for up to _180 seconds_ (3 minutes) the processor determines that all the data for a minute is present, and it will start processing triggers and creating or updating alerts. It will look back _180 seconds_ (3 minutes) since the last data has arrived for an application. Data that is older will be ignored for processing triggers and alerts that processing tick.

When the processor has finished processing metrics for a minute, it will start sending out notifications shortly after for new, on going and closed alerts. To extend this delay longer would also mean that notifications arrive later. To reduce this delay would mean we could miss data for a minute providing alerts and notifications about metric data that is incomplete.

## Conclusion

It can take up to _90 seconds_ [<sup>1</sup>][retries] for transaction and metrics data to appear. This is a worst-case scenario. If it hasn't appeared after that time something has gone wrong somewhere in the transmission or processing pipeline.

It takes _180 seconds_ [<sup>1</sup>][retries] (3 minutes) for metrics graphs and Anomaly detection alerts to be created/updated.

We're constantly trying to minimize this time, but have to balance the amount of requests our Push API receives and data size of each request with processing speed.

If you would like to know more about this subject, don't hesitate to [contact us](mailto:support@appsignal.com)!

---

<a name="retries-footnote"></a>
<sup>1</sup>: This time does not account for retries of data being transmitted from app servers. Data that has failed to be transmitted, because a server has lost its internet connection for example, will be retried up to 30 minutes by our agent.

[retries]: #retries-footnote
