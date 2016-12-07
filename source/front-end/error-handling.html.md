---
title: "Frontend error catching (beta)"
---

This is a Beta implementation, which means:

* There is no official JavaScript library supported by AppSignal.
* The API might change in the future to support more frameworks.
* This feature is not enabled by default and requires a setup that uses an appsignal.yml config file.

## Introduction

Starting with AppSignal gem version <strong>0.11.8</strong> and up we've added a frontend error catcher to our gem.

## Installation

If you are using Rails, it's included automatically, but still needs configuration (see below). For Sinatra/Rack apps you need to require the `JSExceptionCatcher`

```ruby
::Sinatra::Application.use(Appsignal::Rack::JSExceptionCatcher)
```

## Configuration

Enable frontend error catching by enabling `enable_frontend_error_catching`  in the `appsignal.yml` config file.

```yml
staging:
  <<: *defaults
  active: true
  enable_frontend_error_catching: true
```

### Path

The Rack middleware will expose the following error catcher path `/appsignal_error_catcher`. You can change this path by adding `frontend_error_catching_path` to your `appsignal.yml` config file:

```yml
staging:
  <<: *defaults
  active: true
  enable_frontend_error_catching: true
  frontend_error_catching_path: '/foo/bar'
```

This path will accept POST requests that contain frontend errors in a JSON format.
The gem will take care of processing it and sending it to AppSignal.

## Parameters

| Param | Type | Description  |
| ------ | ------ | -----: |
|  action  |  string  |   model/view/component that triggered the exception  |
|  message  |  string  |  exception message  |
|  name  |  string  |   exception name  |
|  backtrace  |  array  |   array of backtrace lines (strings)  |
|  path  |  string  |   path where the exception happened  |
|  tags  |  hash/object  |   hash/object of tags (e.g. logged in user id)  |
|  environment  |  hash/object  |   hash/object of environment variables  |


## Example of an error JSON POST

The `action`, `message`, `name` and `backtrace` field are required. If they are not
set the error will not be processed.

```json
{
  "action": "IncidentIndexComponent",
  "message": "Foo is not defined",
  "name": "ReferenceError",
  "backtrace": [
    "a/backtrace/line.js:10"
  ],
  "path": "/foo/bar",
  "tags": {
    "user_id": 123
  },
  "environment": {
    "agent": "Mozilla Firefox",
    "platform": "OSX",
    "vendor": "",
    "screen_width": 100,
    "screen_height": 100
  }
}
```

## A sample implementation in CoffeeScript

Currently we do not provide a JavaScript library that catches frontend errors.
The (coffee)script below is something we use to test the functionality, use and modify at your own risk.


```coffeescript
## Example ##
##
##  appsignal = new Appsignal
##  appsignal.tag_request({user_id: 123})
##  appsignal.set_action('ErrorTest')
##
##  try
##    adddlert("Welcome guest!");
##  catch err
##    appsignal.sendError(err)
##

class @Appsignal
  constructor: ->
    @action = ""
    @tags   = {}

  set_action: (action) ->
    @action = action

  tag_request: (tags) ->
    for key or tags
      @tags[key] = tags[key]

  sendError: (error) ->
    data = {
      action:    @action
      message:   error.message
      name:      error.name
      backtrace: error.stack?.split("\n")
      path:      window.location.pathname
      tags:      @tags
      environment: {
        agent:         navigator.userAgent
        platform:      navigator.platform
        vendor:        navigator.vendor
        screen_width:  screen.width
        screen_height: screen.height
      }
    }

    xhr = new XMLHttpRequest()
    xhr.open('POST', '/appsignal_error_catcher', true)
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
    xhr.send(JSON.stringify(data))

appsignal        = new Appsignal
window.appsignal = appsignal

window.onerror = (message, filename, lineno, colno, error) ->
  if error
    appsignal.sendError(error)
  else
    appsignal.sendError(new Error('Null error raised, no exception message available'))
```

Here at AppSignal we're very keen on "eating our own dogfood". This means we use AppSignal to monitor AppSignal and since we're rewriting most of our frontend code to ReactJS we decided that we need to monitor it.

Once we get a good feel of the requirements for JavaScript error catching we plan on supporting an official library that hopefully will support vanilla JS and all the popular frontend frameworks.

You are welcome to try frontend error catching as well and we really like to hear feedback on our implementation. If you have any questions or suggestions, don't hesitate to contact us on <a href="mailto:contact@appsignal.com">contact@appsignal.com</a>.
