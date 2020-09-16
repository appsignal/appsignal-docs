---
title: "Track request queue time"
---

## Queue times

A common setup for Ruby application is that the Ruby webserver such as Unicorn or Puma runs behind another (outer) webserver such as Nginx or Apache. Those are usually used to terminate SSL connections and handle static assets for example. When your Ruby webserver is busy processing requests, Nginx or Apache can still accept new connections and wait for a Ruby process to become available to handle the request. The outer webserver queue's the request in the meantime.

Ideally there is enough capacity that the outer webserver never has to wait on Ruby, but in practice this can happen when there's a sudden spike of requests.

A good indicator of capacity therefore is the queue time metric, e.g. the amount of time between when the outer webserver accepted the request and Ruby handles the request. A long queue time for a longer period of time indicates that you'll need to scale up the amount of Ruby processes/threads to handle requests, or scale more webservers.

You can find the queue time metrics on the Performance graphs page:

![Screenshot of Queue time graph](/assets/images/screenshots/queue_time_graph.png)

## Setup

AppSignal automatically tracks the queue time on Heroku, but if you run your own server with Nginx or Apache, you'll need to setup the correct headers for queue time tracking to work.

### Nginx

You can use the [`${msec}`](http://nginx.org/en/docs/http/ngx_http_core_module.html#variables) variable with [Nginx 1.2.6](http://nginx.org/en/docs/http/ngx_http_core_module.html#variables) or higher. This is the current time in milliseconds.

```
proxy_set_header X-Request-Start "t=${msec}";
```

### Apache

In Apache [mod_headers](https://httpd.apache.org/docs/current/mod/mod_headers.html) exposes a `"$t"` variable that can be used to track the queue time. Add the header as follows:

```
RequestHeader set X-Request-Start "%t"
```

## Namespaces

From Ruby gem 2.11 and newer queue time is reported for all namespaces. Previously it would only report queue times for the "web" and "background" namespaces. Update to the latest version of the Ruby gem if you do not see queue time graphs for your [custom namespaces](/application/namespaces.html)
