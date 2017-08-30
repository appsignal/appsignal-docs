---
title: "Terminology"
---

At AppSignal we use a lot of technical terms. Read on to learn more about the
language of AppSignal.

- [Agent](#agent)
- [Alerting](#alerting)
- [Allocations](#allocations)
- [API](#api)
- [API key](#api-key)
- [Applications](#applications)
- [AppSignal vs Appsignal vs appsignal](#appsignal-vs-appsignal-vs-appsignal)
- [Blog](#blog)
- [Changelog](#changelog)
- [Configuration](#configuration)
- [CPU usage](#cpu-usage)
- [Elixir Alchemy](#elixir-alchemy)
- [Environments](#environments)
- [Errors](#errors)
- [Events](#events)
- [Exceptions](#errors)
- [Extension](#extension)
- [Impact](#impact)
- [Instrumentation](#instrumentation)
- [Instrumentation events](#instrumentation-events)
- [Libraries](#libraries)
  - [Integrations](#library-integrations)
- [Markers](#markers)
- [Metadata](#metadata)
- [Metrics](#metrics)
- [Namespace](#namespace)
- [Organizations](#organizations)
- [Owners](#owners)
- [Performance issues](#performance-issues)
- [Push API](#push-api)
- [Push API key](#push-api-key)
- [Response time](#response-time)
- [Ruby Magic](#ruby-magic)
- [Samples](#samples)
- [Stroopwafels](#stroopwaffles)
- [Stroopwaffles](#stroopwaffles)
- [Teams](#teams)
- [Third-party integrations](#third-party-integrations)
- [Transactions](#transactions)
- [Throughput](#throughput)
- [Queue time](#queue-time)
- [User account](#user-account)

## Agent

AppSignal uses an "agent" to communicate with the AppSignal servers and
instrument the hosts an application is running on. The host data used in our
[host metrics](/metrics/host.html) feature.

The agent is started by the language specific [library](#libraries) and runs as
a separate UNIX process on the application's host. The language library and
agent communicate with each other through a UNIX socket using a [C
extension](#extension).

The instrumentation data collected by the agent is sent to the AppSignal
servers in transactions. The [transaction](#transactions) data is processed and
used to detect events worth [alerting](#alerting) users about.

Read more about the [life cycle of an AppSignal
request](/appsignal/request-lifecycle.html).

## Alerting

AppSignal sends alerts whenever a problem is detected with an
[application](#applications). These alerts can be emails, Slack messages, a
PagerDuty alert, and more depending on which [third-party
integrations](#third-party-integrations) are configured.

[Errors](#errors) and [slow requests](#performance-issues) that occur when an
application is running are detected using AppSignal [libraries](#libraries).
Once a problematic event is detected an alert is sent out to alert users of a
problem.

## Allocations

During an HTTP request or a background job an application uses memory. Every
data structure that's loaded and object that's instantiated takes up memory.
When a request or job handles a lot of data it's possible a lot more memory is
used than normally.

The AppSignal integration libraries keep track of allocations per
[transaction](#transactions). The integration also keeps track what part of the
application allocates more memory objects than other, so it's possible to see
if the application's ORM or template library was taking up more memory.

On AppSignal.com the number of allocations is displayed in an Integer for an
action, event groups and for specific events. This allocation number is the
number of objects have been created in memory during an action/group/event. The
size of the created object is not tracked.

## API

An API is an "Application Programming Interface". The term API is a very broad
and is used in many ways. In the context of our documentation we refer to the
AppSignal HTTP REST API when using "API".

The AppSignal API is a HTTP REST API which can be used to retrieve data from
the AppSignal servers and augment the existing data with more information such
as [Markers](#markers).

The API differs from the [Push API](#push-api) in its purpose. While the Push
API is used to send data to AppSignal by the [agent](#agent), the HTTP REST
API is primarily used to retrieve data from AppSignal. This allow users to use
the available data in other tooling.

Read more about [our API](/api/index.html).

## API key

In order to connect with the AppSignal [API](#api) it's necessary to
authenticate yourself. Every user has their own API key to authenticate with
AppSignal.

Your own API key can be found on your [user
profile](https://appsignal.com/users/edit).

This key is not to be confused with the [Push API key](#push-api-key) which is
used by [applications](#applications) with an AppSignal [agent](#agent)
installed.

## Applications

Applications (previously known as "sites", also referred to as "apps") are Ruby
and Elixir applications monitored by AppSignal.

After installing the AppSignal [library](#libraries) in an application
AppSignal starts monitoring these applications. Once we receive data from an
application, we register it using the application name and environment it's
running in.

An application can have multiple [environments](#environments) as long as every
environment uses the same name.

- "Demo application" - Development
- "Demo application" - Production
- "Demo application" - Staging
- "Demo application" - Test

Multiple applications can exist in one [organization](#organizations).

Read more about applications in our [Applications
documentation](/application/index.html).

## AppSignal vs Appsignal vs appsignal

Three different capitalized versions of the AppSignal name?

Yes.. Let's explain!

- `AppSignal` - The name of the company, the application and almost everything
  else related to AppSignal. You're probably right using this capitalized
  version.
- `Appsignal` - The Ruby and Elixir integration name in the code. Only used in
  the Ruby and Elixir code context.
- `appsignal` - The AppSignal Ruby gem and Elixir package name.

## Blog

We have a blog at [blog.appsignal.com](http://blog.appsignal.com/)!

On our blog we post all things relevant to AppSignal, such as new features, new
major agent releases, [Ruby Magic](#ruby-magic) articles and other awesome
stories from our internal process. Such as [how to eat
stroopwafels](http://blog.appsignal.com/blog/2016/02/01/stroopwafels-and-how-to-eat-them.html).

## Changelog

We keep a full product changelog at
[appsignal.com/changelog](https://appsignal.com/changelog).

All our new features, agent releases and other changes to the product can be
found in this neatly organized list.

We also have a small indicator in our left-hand-side navigation that notifies
you if there's a new entry to the changelog.

## Configuration

The configuration is part of the libraries running in applications. It tells
the AppSignal [libraries](#libraries) what to instrument in an
[application](#applications), which application it is and in which environment
it's running.

The AppSignal libraries have multiple methods of configuration. The most common
method of configuration is the usage of an `appsignal.yml` configuration file.
The usage of environment variables is also recommended.

For the configuration of the Ruby agent we recommend you read the
[configuration topic](/ruby/configuration/index.html) to get started.

## CPU usage

During the operation of an application the CPU usage can vary wildly. Some
operations of an application can request more CPU time than others.

Other factors can also affect the CPU usage. If the monitored application is
not the only process on the host machine other processes can also affect the
CPU usage metric. For example, if a database running on the same machine has to
perform a complicated query it will request more CPU time.

On AppSignal.com the CPU usage of an application is displayed in two ways. For
an action where an error/performance issue occurred and for host metrics. This
way it's possible to see if the performance of an action was directly affected
by a busy CPU or if the entire host was affected for longer periods of time.

## Elixir Alchemy

Want to learn more about Elixir? In our email series Elixir Alchemy (1x p/mo)
we dive deeper into Elixir and Erlang.
You can sign up here:
[appsignal.com/elixir-alchemy](https://appsignal.com/elixir-alchemy).

## Environments

Most [application](#applications) can be run in different modes. During
development of an application other rules apply and errors are not usually
shown in the form of a "500 internal server error" page like they do in
"production".

AppSignal also understands the concept of an environment allowing different
settings be configured per environment. For every environment a separate
application is created on AppSignal.com to be configured with its own set of
[alerting rules](#alerts) and [third-party
integrations](#third-party-integrations).

## Errors

Errors are problems that occur during the runtime of an application. This can
be anything ranging from a catastrophic failure causing the application to
crash or a simple typo causing an error page.

Once an error occurs in an application AppSignal sends an alerts and records
the details of the error for later viewing on AppSignal.com.

Read more about the [errors feature](https://appsignal.com/tour/errors) on our
tour page. To learn more about error handling in Ruby, read our [Exception
handling](/ruby/instrumentation/exception-handling.html) topic describing how
to effectively track errors with AppSignal.

## Events

An event is something that happened. This is a very vague statement, because
the concept of an event is something very high-level. An [error](#errors) is an
event, and so is an [performance issue](#performance-issue).

AppSignal monitors many events inside an application an on a server using [host
metrics](#metrics). By collecting many different types of events and combining
the data we hope to provide an as complete as possible picture to gain more
insights in [applications](#applications).

Also see [instrumentation events](#instrumentation-events).

## Extension

The AppSignal [libraries](#libraries) and [agent](#agent) are in constant
communication with each other. The libraries send data to the agent over a UNIX
socket. To do so in a uniform way the libraries use an extension to the
programming language they're written in. This extension is written in the
C-language and installed when the language specific agent is installed.

## Impact

The impact of an action on an application is based on its usage compared to
other actions. When one controller action or job takes more time or is executed
more often than others its impact grows.

For example:

- Action A is triggered 1000 times with an average duration of 0.5 seconds.
  The combined duration is 500 seconds.
- Action B is triggered 500 times with an average duration of 3 seconds.
  The combined duration is 1500 seconds.

Total combined duration of both actions is 2000 seconds.

- Action A has an impact of 25% (500 / 2000).
- Action B has an impact of 75% (1500 / 2000).

## Instrumentation

Instrumentation is what powers AppSignal. Without it, we wouldn't know anything
about what's going on inside Applications.

Instrumentation are hooks inside or around frameworks and libraries AppSignal
uses to monitor application code. This instrumentation reports errors and slow
code which is sent to AppSignal for analysis. Once a problem is detected an
alert is sent.

Learn more about [Ruby instrumentation](/ruby/instrumentation/index.html).

## Instrumentation events

With any kind of code there are multiple levels of code at work. Databases are
accessed, JSON is parsed, views are rendered, etc. All these pieces of logic
are separate events picked up by the AppSignal instrumentation.

These individual events make it possible to see which parts of the code are
slower than others and by how much exactly.

Also see [instrumentation](#instrumentation).

## Libraries

AppSignal uses language specific libraries to monitor applications. Currently
we have a [Ruby](/ruby/index.html) gem and [Elixir](/elixir/index.html)
package. These libraries include hooks into frameworks and libraries to
instrument code blocks such as database calls, file system calls and view
rendering.

Every library is specialized in instrumentation of its subject language. Most
AppSignal libraries also includes an "[agent](#agent)" which the libraries use
to communicate with the AppSignal servers.

### Library integrations

AppSignal libraries integrate with a variety of different libraries and
frameworks specific for the programming language. The Ruby gem integrates with
pure Ruby, Rails, Sinatra and other available frameworks. The Elixir package
integrates with pure Elixir and Phoenix.

These automatic integrations make it easier to get more insight in applications
without having to add AppSignal [instrumentation](#instrumentation) manually.

Read more about what [Ruby integrations we
offer](/ruby/integrations/index.html).

## Markers

Markers are little icons used in graphs on AppSignal.com to indicate a change.
This can be a code deploy using a "Deploy marker" or a special event with a
"Custom marker". These custom markers can be anything from scaling operations,
sudden spikes in traffic or when a database was acting up.

Read more about [markers](/application/markers/index.html).

## Metadata

Metadata is data that gives information about other data.

Metadata is information about an error or performance issue that provides more
context to the data collected. By sending extra metadata on a
[sample](#samples) it's easier to track down what the circumstances were around
the particular issue.

By default the metadata of a request includes the hostname on which the issue
occurred, the SCM revision on which the application is running, the request id
of the request the sample was derived from. It also includes data such as the
request path and the request method for web requests.

## Metrics

AppSignal provides two kinds of metrics.

- [Custom metrics](/metrics/custom.html)
- [Host metrics](/metrics/host.html)

Custom metrics allows the collection of data from just about anything. With a
couple lines of code it's possible to track and graph data such as the number
of registered users, visits on a page, database sizes, etc.

Host metrics is about data from the server an application is running on. Data
such as [CPU usage](#cpu-usage), load averages, memory usage, etc. gives more
insight on performance issues than just the code itself. Maybe the disk space
is running out causing the application to run much slower.

Read more about [metrics](https://appsignal.com/for/metrics) on our tour page.

## Namespace

Namespaces are grouping mechanisms used by AppSignal to differentiate between
different parts of the same application. By default AppSignal splits an
application up into two namespaces: "Web" and "Background".

HTTP requests that are being monitored by AppSignal will be added to the "Web"
namespace and jobs performed by background job libraries are added to the
"Background" namespace. It's also possible to configure your own namespaces to
differentiate between requests on an application and a private administration
panel.

For more information about namespaces, please see our
[namespaces](/application/namespaces.html) documentation.

## Organizations

Organizations are used to group together [applications](#applications) and
[users](#user-account) for a business. A business can have many users and
clients that can be [notified](#alerting) whenever there's a problem with an
applications.

[Billing](/organization/billing.html) for applications is done on organization
level rather than per application.

[Team management](/organization/team/index.html) is made easy using
organizations. Whole teams can invited to an organization so there's no need
for sharing sign-in details.

Read more about organizations in our [Organizations
documentation](/organization/index.html).

## Owners

[Organizations](#organizations) have people that manage the organization. These
owners decide who's a member of an organization, in which [team](#teams) they
do or do not belong and decide how the billing is done.

Organization owners can manage everything about an organization and the
[applications](#applications) that belong to it. If you do not have permission
to view or change something, ask your organization's owner to change them for
you or give you more permissions.

## Performance issues

Using performance monitoring it's possible to deep dive in individual requests
and see what parts of an application are slow. Using this information it's
possible to find and improve problem areas.

When AppSignal detects a slow web request or operation it will send an alert,
because slow code can be as damaging as an [error](#errors) appearing.

Read more about the [performance
feature](https://appsignal.com/for/performance) on our tour page.

## Push API

The AppSignal "Push API" is the API endpoint used by the AppSignal
[agent](#agent) to send the collected data to. This is different from the
normal AppSignal [API](#api) which is primary used to read data and add more
context to the data that's sent to AppSignal.

This Push API is the API where application instrumentation is sent to from
applications using the [Push API key](#push-api-key).

## Push API key

The "Push API key" is the API key used by applications to authenticate
themselves when sending data to the AppSignal servers. This data is sent to the
[Push API](#push-api).

This key is required for every application, but is the same for every
[application](#applications) in an [organization](#organizations). This allows
users to easily create more applications in an organization, for different
[environments](#environments) for example.

The Push API key for an application is given during the creation of an new
application, and can also be found in an [application
settings'](/application/settings.html#push-amp-deploy) "Push & deploy" tab.

Note: This key is not to be confused with the user specific [API key](#api-key)
which can be used to authenticate a user on the [AppSignal API](/api) to
retrieve data about your apps from our system.

## Response time

The response time of an application's action is the time spent processing the
action. The longer an action took to perform the more it qualifies as a
performance issue.

The duration of this action is displayed on AppSignal.com for
performance issues and in graphs for controllers/jobs and on host-level.

## Ruby Magic

Did you know we write articles about the magic that is Ruby? We do!

It's called Ruby Magic and you can sign up for it on
[appsignal.com/ruby-magic](https://appsignal.com/ruby-magic).

A list of all the Ruby Magic articles we've written so far can be found on [our
blog](http://blog.appsignal.com/).

## Samples

When a page request is slow a hundred times in a row, it's not as relevant to
see all the slow requests, a smaller sample of these requests tell the same
story.

Instead the AppSignal [agent](#agent) only sends a small set of performance
issues to the AppSignal servers. This saves data sent to the servers, the data
processed on the application host and on the AppSignal servers, while still
telling the same story about the issues.

## Stroopwaffles

Also written as "stroopwafels" in Dutch.

At AppSignal, we love stroopwaffles. We've shipped over 25,000 of them to
customers, friends and conferences. If you work at a tech company and have had
a stroopwaffle at the office, chances it came from us.

We've written a whole article about what stroopwaffles are and how you should
eat them. Read on to [become a stroopwaffle
expert](http://blog.appsignal.com/blog/2016/02/01/stroopwafels-and-how-to-eat-them.html).

Now I'm hungry for a stroopwaffle.

## Tags

Error and performance issue [samples](#samples) can be tagged. By tagging these
samples it's easier to find and identify certain issues. By tagging it's
possible to add more [metadata](#metadata) to a sample that can be used in
[link templates](/application/link-templates.html) to easily link to
the relevant data in your own application.

Read more about [tagging requests](/ruby/instrumentation/tagging.html).

## Teams

To manage members of [organizations](#organizations), organization owners can
utilize teams to give access to applications. [Users](#user-account) that are
part of a team can only access the applications the team they belong to have
access to. If a user is part of more than one team this user can access all
applications of all the teams they belong to.

Teams give permission management to [owners](#owners) of an organization to
limit user access to applications without the need for multiple organizations.

Read more about organization [team management](/organization/team/teams.html).

## Third-party integrations

AppSignal.com provides connections with other services such as Slack and
PagerDuty to more effectively alert users about problems that are detected.
These integrations can be manage through the UI on AppSignal.com on an
application by application basis.

Read more about [which third-party integrations we
offer](/application/integrations/).

## Transactions

Transactions are created by the AppSignal [libraries](#libraries) for every
monitored web request and background job. Within this transaction the agents
monitor for errors and slow code. A transaction is created at the start of a
web request or when a background job is started. Once the request or job
finishes, or crashes, the transaction is closed and sent to the [agent](#agent)
for processing.

[Tags](#tags) and [metadata](#metadata) are added on transaction-level to more
easily identify differences between transaction samples.

## Throughput

The throughput of an application is the total number of requests sent through
an action/job in a certain time frame. The throughput can differ per action and
per host.

On AppSignal.com the throughput is displayed per action and displayed in graphs
for every host.

## Queue time

When a server or application is busy processing a lot of requests it's possible
certain requests are queued before they are processed. The time waiting to be
processed is referred to as "queue time".

Since queue time can negatively affect users' experience using an application
this metric is tracked by AppSignal for HTTP requests and background jobs.

## User account

Every user using AppSignal has their own user account. With this user account
you can configure your personal notifications just how you want it.

Many users can belong to one or more organizations. No need for separate user
accounts for every organization.

[Organizations](#organizations) manage which users can access which
applications and who can manage the billing as an [owner](#owners).
