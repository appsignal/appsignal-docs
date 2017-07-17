---
title: "Push api overview"
---

!> **Deprecated**
The V1 API is deprecated, and parts of it will be turned off in the (near) future. Please contact us at <a href="mailto:contact@appsignal.com">contact@appsignal.com</a> if you're interested in building a custom integration on top of the AppSignal API.

The appsignal_server push api is located at `https://push.appsignal.com` and accepts all requests with a valid API key. Make sure you use **https** to keep your data secure.

## Pushing events to the api

The endpoint is `http://push.appsignal.com/v1/log_entries.json?api_key=[push_api_key]&name=[application_name]&environment=[environment]`

Note that the api key is not your personal token used in the "normal" api. The `push_api_key`, `application_name` and `environment` values can be found at "App settings" > "Push & Deploy"


The data format is an array with events encoded in json.

```
[
  {
    "request_id":"650ec2791865a60fd978b3da1d9ee286",
    "log_entry":{
      "action":"BlogPostsController#show",
      "params":{
        "controller":"blog_posts",
        "action":"show",
        "year":"2012",
        "month":"7",
        "day":"21",
        "id":"blog-post-title"
      },
      "format":"html",
      "method":"GET",
      "path":"/blog/2012/7/21/blog-post-title",
      "status":200,
      "view_runtime":950.759,
      "duration":981.6270000000001,
      "time":"2012-08-22T15:29:17+02:00",
      "end":"2012-08-22T15:29:18+02:00",
      "name":"/blog/2012/7/21/blog-post-title",
      "environment":"development",
      "hostname":"localhost"
    },
    "events":[
      {
        "name":"start_processing.action_controller",
        "duration":0.007,
        "time":"2012-08-22T15:29:17+02:00",
        "end":"2012-08-22T15:29:17+02:00",
        "payload":{
          "controller":"BlogPostsController",
          "action":"show",
          },
          "format":"html",
          "method":"GET",
          "path":"/blog/2012/7/21/blog-post-title"
        }
      },
      {
        "name":"render_partial.action_view",
        "duration":291.38100000000003,
        "time":"2012-08-22T15:29:17+02:00",
        "end":"2012-08-22T15:29:18+02:00",
        "payload":{
          "identifier":"/var/www/app/views/blog_posts/_blog_post.html.haml"
        }
      },
    ],
    "exception":{
    },
    "failed":false
  }
]
```

An example of a log entry with an exception:

```
  [
    {
      "request_id":"120b49a2a709d6c9a07657c10d891768",
      "log_entry":{
        "action":"BlogPostsController#index",
        "params":{
          "controller":"blog_posts",
          "action":"index"
        },
        "format":"html",
        "method":"GET",
        "path":"/blog",
        "exception":[
          "RuntimeError",
          "an error occured"
        ],
        "duration":1.4929999999999999,
        "time":"2012-08-22T15:30:45+02:00",
        "end":"2012-08-22T15:30:45+02:00",
        "name":"/blog",
        "environment":"development",
        "hostname":"localhost"
      },
      "events":[
        {
          "name":"start_processing.action_controller",
          "duration":0.004,
          "time":"2012-08-22T15:30:45+02:00",
          "end":"2012-08-22T15:30:45+02:00",
          "payload":{
            "controller":"BlogPostsController",
            "action":"index",
            "params":{
              "controller":"blog_posts",
              "action":"index"
            },
            "format":"html",
            "method":"GET",
            "path":"/blog"
          }
        }
      ],
      "exception":{
        "backtrace":[
          "app/controllers/blog_posts_controller.rb:6:in `index'",
          "script/rails:6:in `require'",
          "script/rails:6:in `<main>'"
        ],
        "exception":"RuntimeError",
        "message":"an error occured"
      },
      "failed":true
    }
  ]
```
