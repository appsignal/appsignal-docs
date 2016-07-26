---
title: "Supported systems & frameworks"
---

## Supported systems

We currently support Ruby 1.9.3+ on Linux or Mac for the latest gem version `1.x`. The gem contains native extensions and a separate light-weight agent process. To use this version just add:

```ruby
gem 'appsignal'
```

## A note on jRuby

We aim to also support jRuby, and are undecided on supporting Windows. If you use Windows and/or jRuby in your production environment and would like to get notified when this is done please
[send us an e-mail](mailto:support@appsignal.com).

At the moment please install the `0.11` gem if you use jRuby or Windows.
Add this line to your Gemfile:

```ruby
gem 'appsignal', '~> 0.11.17'
```

If you're getting a `Java::JavaLang::RuntimeException: Could not generate DH keypair`, use an initializer like this:
```ruby
# config/initializers/java.rb
if 'jruby' == RUBY_ENGINE
  java.security.Security.setProperty("jdk.tls.disabledAlgorithms", "SSLv3, DHE")
end
```

* The JVM SSL has some arbitrary limitations regarding DH keypair size.

## Supported frameworks

AppSignal works with most popular Ruby frameworks such as:

* [Ruby on Rails](#ruby-on-rails)
* [Sinatra](#sinatra)
* [Padrino](#padrino)
* [Grape](#grape)
* [Webmachine](#webmachine)
* [Rack / Other](#rack-other)

<a name="ruby-on-rails"></a>
# Ruby on Rails

[Ruby on Rails](http://rubyonrails.org/) is supported out-of-the-box by AppSignal.
To install follow the installation steps in AppSignal, start by clicking 'Add app' on [the accounts screen](https://appsignal.com/accounts)..

<a name="sinatra"></a>
# Sinatra

[Sinatra](http://www.sinatrarb.com/) is officially supported, but requires a bit of manual configuration.
Follow the installation steps in AppSignal, start by clicking 'Add app' on [the accounts screen](https://appsignal.com/accounts).

After installing the gem you need to add `require 'appsignal/integrations/sinatra'` beneath `require 'sinatra'` in your app.
If you define your app at the top-level this works straight away. If your app is a subclass of `Sinatra::Base` you need to use these middlewares:

```ruby
class MyApp < Sinatra::Base
  use Appsignal::Rack::SinatraInstrumentation
```

After this, add an `appsignal.yml` config file to `/config`. You can find your `push_api_key` by clicking 'Add app' on [the accounts screen](https://appsignal.com/accounts).
Or you can use [Environment variables to configure the gem](/gem-settings/env-vars.html).

<a name="padrino"></a>
# Padrino

[Padrino](http://www.padrinorb.com/) is supported by AppSignal, but requires manual configuration.

After installing the gem, add the following line to `/config/boot.rb`: `require 'appsignal/integrations/padrino`

It should look like:

```yml
# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'appsignal/integrations/padrino'
```

After this, add an `appsignal.yml` config file to `/config`. You can find your `push_api_key` by clicking 'Add app' on [the accounts screen](https://appsignal.com/accounts).

Here's an example of a Padrino config file:

```yml
default: &defaults
  # Your push api key, it is possible to set this dynamically using ERB:
  # push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"
  push_api_key: ""

  # Your app's name
  name: "My Padrino App"

# Configuration per environment, leave out an environment or set active
# to false to not push metrics for that environment.
development:
  <<: *defaults
  active: true

staging:
  <<: *defaults
  active: true

production:
  <<: *defaults
  active: true
```

After these steps, start your Padrino app and wait for data to arrive in AppSignal.


<a name="grape"></a>
# Grape

Grape works with AppSignal `1.1` and up.

For older versions of Appsignal, check [grape-appsignal gem](https://github.com/aai/grape-appsignal) created by [Mark Madsen](https://github.com/idyll).

## Standalone

A standalone Grape app requires a few manual steps to get working.

* Place an `appsignal.yml` config file in `/config` (or use [ENV VARS](/gem-settings/configuration.html))
* Make sure AppSignal is requried (`require 'appsignal').
* Require the grape integration (`require 'appsignal/integrations/grape')
* Start AppSignal (`Appsignal.start`)

An example of an AppSignal Grape config.yml:

``` yaml
default: &defaults
  push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"

  # Your app's name
  name: "ACME app"

# Configuration per environment, leave out an environment or set active
# to false to not push metrics for that environment.
development:
  <<: *defaults
  active: true
  debug: true

production:
  <<: *defaults
  active: true
```

An example of an Grape `config.ru` file:

``` ruby
require File.expand_path('../config/environment', __FILE__)

require 'appsignal'

Appsignal.config = Appsignal::Config.new(
  File.expand_path('../../', __FILE__), # The root of your app
  ENV['RACK_ENV'] # The environment of your app (development/production)
)

Appsignal.start_logger
Appsignal.start

run Acme::App.instance
```

An example of a Grape `api.rb` file:

``` ruby
require 'appsignal/integrations/grape'

module Acme
  class API < Grape::API
    use Appsignal::Grape::Middleware

    prefix 'api'
    format :json
    mount ::Acme::Ping
  end
end
```

A demo project for Grape can be found here: https://github.com/appsignal/grape-on-rack


<a name="webmachine"></a>
# Webmachine

Webmachine works with AppSignal `1.3` and up.

A Webmachine app requires a few manual steps to get working.

* Place an `appsignal.yml` config file in `/config` (or use [ENV VARS](/gem-settings/configuration.html))
* Make sure AppSignal is requried (`require 'appsignal').
* Configure AppSignal (`Appsignal.config`)
* Start Appsignal logger (`Appsignal.start_logger`)
* Start AppSignal (`Appsignal.start`)

An example of an AppSignal Webmachine config.yml:

``` yaml
default: &defaults
  push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"

  # Your app's name
  name: "ACME app"

# Configuration per environment, leave out an environment or set active
# to false to not push metrics for that environment.
development:
  <<: *defaults
  active: true
  debug: true

production:
  <<: *defaults
  active: true
```

An example of a Webmachine `app.rb` file:

``` ruby
require 'webmachine'
require 'appsignal'

Appsignal.config = Appsignal::Config.new(
  Dir.pwd,        # Path to project root directory
  'development'   # Environment
)
Appsignal.start_logger
Appsignal.start


class MyResource < Webmachine::Resource
  def to_html
    "<html><body>Hello, world!</body></html>"
  end
end

# Start a web server to serve requests via localhost
MyResource.run
```

<a name="rack-other"></a>
# Rack/Other

The AppSignal gem has a few requirements that have to be met for it to work properly.

The gem needs the following information:

* Push API key.
* Application root path.
* Application environment.
* Application name.
* A place to log.
* (optional) A config file.
* [A middleware that receives instrumentation](https://github.com/appsignal/appsignal-ruby/blob/master/lib/appsignal/rack/generic_instrumentation.rb)

For example:

``` ruby
require 'appsignal'
# Only run when there's a APPSIGNAL_PUSH_API_KEY
if ENV['APPSIGNAL_PUSH_API_KEY']                       # Push API key
  root_path = File.expand_path(File.dirname(__FILE__)) # Application root path
  Appsignal.config = Appsignal::Config.new(
    root_path,
    'development',                                     # Application environment
    name: 'logbrowser'                                 # Application name
  )

  Appsignal.start_logger(root_path)                    # A place to log.
  Appsignal.start                                      # Start the AppSignal agent
  use Appsignal::Rack::GenericInstrumentation          # Listener middleware
end
```

You can pass a hash of configration options to `Appsignal::Config.new` for more features. For example to enable frontend monitoring and ignore an uptime monitoring action:

``` ruby
Appsignal.config = Appsignal::Config.new(
  root_path,
  'development',
  name:                       'logbrowser',
  enable_frontend_monitoring: true
)
```

By default all actions are grouped under 'unknown'. You can override this for every action by setting the route in the env:

```ruby
env['appsignal.route'] = '/homepage'
```
