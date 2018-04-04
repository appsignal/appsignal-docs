---
title: "Standalone AppSignal Agent"
---

When we introduced host metrics we knew that in order to provide  a full picture of your infrastructure we needed not only to monitor your application servers, but also any servers your application depends on, for example database servers.

In order to do this we added a standalone mode to our AppSignal agent. With this flag enabled, you can run the agent without having to start it from a Ruby/Elixir process.

## Installation

Right now we don’t have an automated installation process, so it’s up to you to download the correct agent version.

You can find a list of all agent versions [here in the Ruby repository](https://github.com/appsignal/appsignal-ruby/blob/master/ext/agent.yml)

Our agent downloads are scoped by agent version and platform, you can find out what platform to get by determining the platform (`uname -s`) and the architecture (`uname -m`).

Once you have the right agent archive you have to extract it and you can copy over the `appsignal-agent` binary to a bin directory.

## Configuration

The agent needs the following environment variables to boot in standalone mode.

-> **Note**: All the agent environment variables are prepended with an underscore (`_`)

```
_APPSIGNAL_AGENT_STANDALONE=true
_APPSIGNAL_ACTIVE=true
_APPSIGNAL_PUSH_API_KEY=<your api key>
_APPSIGNAL_APP_NAME=AppSignal
_APPSIGNAL_ENVIRONMENT=<environment>
_APPSIGNAL_ENABLE_HOST_METRICS=true
_APPSIGNAL_LOG=stdout
```

## Running the agent

You can either start the agent manually

```
_APPSIGNAL_AGENT_STANDALONE=true \
_APPSIGNAL_ACTIVE=true \
_APPSIGNAL_PUSH_API_KEY=<push api key> \
_APPSIGNAL_APP_NAME=AppSignal \
_APPSIGNAL_ENVIRONMENT=<environment> \
_APPSIGNAL_ENABLE_HOST_METRICS=true \
_APPSIGNAL_LOG=stdout \
/path/to/appsignal-agent
```

Or use your favourite system startup manager. An example of an init script can be found below.

```
description "Appsignal Agent"

start on runlevel [2]
stop on runlevel [016]

env _APPSIGNAL_AGENT_STANDALONE=true
env _APPSIGNAL_ACTIVE=true
env _APPSIGNAL_PUSH_API_KEY=<push api key>
env _APPSIGNAL_APP_NAME=AppSignal
env _APPSIGNAL_ENVIRONMENT=<environment>
env _APPSIGNAL_ENABLE_HOST_METRICS=true
env _APPSIGNAL_LOG=stdout

respawn            # respawn the service if it dies
respawn limit 5 10 # stop respawning if it fails 5 times in 10 seconds

script
  exec /usr/local/bin/appsignal-agent
end script
```
