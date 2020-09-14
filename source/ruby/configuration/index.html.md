---
title: "AppSignal Ruby configuration"
---

Configuration. Important, because without it the AppSignal Ruby gem won't
know which application it's instrumenting or in which environment.

In this topic we'll explain how to configure AppSignal, what can be configured
in the Ruby gem, what's the minimal configuration needed and how the
configuration is loaded.

## Minimal required configuration

```yaml
# config/appsignal.yml
production:
  active: true
  push_api_key: "1234-1234-1234"
  name: "My app"
```

```bash
# Environment variables
export APPSIGNAL_PUSH_API_KEY="1234-1234-1234"
export APPSIGNAL_APP_NAME="My app"
export APPSIGNAL_APP_ENV="production"
```

The above configuration options are the only required options. All other
configuration is optional.

If you use Rails you can even skip the app name, we will use the name of your
Rails application.

If you use a framework that is aware of environments and [is supported by the
AppSignal gem](/ruby/integrations/index.html), the environment is detected
automatically.

## Configuration methods

### YAML configuration file

The AppSignal Ruby gem can be configured with a configuration file. During installation the Ruby gem will create a `config/appsignal.yml` file, if selected. In this file some default configuration is supplied and can be modified to fit your application's needs. This `config/appsignal.yml` file supports ERB tags so that system environment variables can also be loaded in this file.

The `config/appsignal.yml` configuration examples shown for configuration options will use the `default` YAML anchor. The AppSignal installer will create an `config/appsignal.yml` file with this anchor by default. If not present, make sure you add the config option to the correct environment.

```yml
# config/appsignal.yml
# Define the "defaults" anchor
default: &defaults
  name: "My app"
  # Supports ERB
  push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"

production:
  # Loads the defaults in the production environment by referencing the anchor
  <<: *defaults
  # production environment specific configuration
  active: true
```

### System environment variable

An alternative way of configuring AppSignal is by using system environment variables on the host the application AppSignal is monitoring is running on. This is common on platforms such as Heroku.

Make sure these environment variables are configured in the way that's compatible with your Operating System and that the values get loaded before your app with AppSignal is started.

```sh
export APPSIGNAL_APP_NAME="My app"
```

## Example configuration file

Here's an example of an `appsignal.yml` configuration file. It's recommended
you only add the configuration you need to your configuration file.

For the full list of options, please see the [configuration
options](/ruby/configuration/options.html) page.

```yaml
# config/appsignal.yml
default: &defaults
  # Your Push API Key, it is possible to set this dynamically using ERB. Requred
  push_api_key: "<%= ENV['APPSIGNAL_PUSH_API_KEY'] %>"

  # Your app's name as reported on AppSignal.com. Required
  name: "My App"

  # Your server's hostname. Optional, auto detected
  hostname: "frontend1.myapp.com"

  # Add default instrumentation of net/http. Default: true
  instrument_net_http: true

  # Skip session data, if it contains private information. Default: false
  skip_session_data: true

  # Ignore these errors (Optional)
  ignore_errors:
    - SystemExit

  # Ignore these actions, used by our Loadbalancer. Optional
  ignore_actions:
    - IsUpController#index

  # Enable allocation tracking for memory metrics. Default: true
  enable_allocation_tracking: true

# Configuration per environment, leave out an environment or set active
# to false to not push metrics for that environment.
development:
  <<: *defaults
  active: true
  # Enable more logging in the `appsignal.log` file. Optional
  debug: true

staging:
  <<: *defaults
  # Configure AppSignal to be active for this environment. Required
  active: true

production:
  <<: *defaults
  # Configure AppSignal to be active for this environment. Required
  active: true

  # Set different path for the log file. Optional, auto detected
  log_path: "/home/my_app/app/shared/log"

  # Set AppSignal working dir. Optional, auto detected
  working_directory_path: "/tmp/appsignal"

  # When it's not possible to connect to the outside world without a proxy.
  # Optional
  http_proxy: "proxy.mydomain.com:8080"
```
