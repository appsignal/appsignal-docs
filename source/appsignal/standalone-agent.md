---
title: "Standalone AppSignal Agent"
---

When we introduced host metrics we knew that in order to provide a full picture of your infrastructure we needed not only to monitor your application servers, but also any servers your application depends on, for example database servers.

In order to do this we added a standalone mode to our AppSignal agent. With this flag enabled, you can run the agent without having to start it from a Ruby/Elixir process.

## Installation

Right now we don't have an automated installation process, so it is your responsibility to download the correct agent version and update it. New releases will become available once they're pushed to the Ruby gem repository.

You can find a list of all architecture and Operating System variants in the Ruby repository's [agent.yml file](https://github.com/appsignal/appsignal-ruby/blob/master/ext/agent.yml).

Our agent downloads are scoped by agent version and platform. Find out what platform to download by determining the platform (`uname -s`) and the architecture (`uname -m`).

Once you have downloaded the correct agent archive, extract it and copy over the `appsignal-agent` binary to a `bin` directory that's available to your host's [`$PATH`](https://en.wikipedia.org/wiki/PATH_(variable)) environment variable.

The download location works as follows:

```
# Example:
https://appsignal-agent-releases.global.ssl.fastly.net/ea78a58/appsignal-x86_64-linux-agent.tar.gz

# Explained:
https://appsignal-agent-releases.global.ssl.fastly.net/{agent version}/appsignal-{architecture}-{operating system}-agent.tar.gz
^                                                      ^                         ^              ^                  ^
|                                                      |                         |              |                  Package type, containing only the agent binary
|                                                      |                         |              Host Operating System
|                                                      |                         x86_64 (64-bit)/x86 (32-bit) (where available)
|                                                      Agent version
Download domain
```

## Configuration

The agent needs the following configuration set in environment variables to boot in standalone mode.

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

-> **Note**: The method with which environment variables are configure may be different on your Operating System of choice.

## Running the agent

You can either start the agent manually like so:

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

### Init script

Or use your favourite system startup manager. An example of an init script can be found below.

```conf
# /etc/init.d/appsignal
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

- Ensure that the init script is exectuable with `chmod +x /etc/init.d/appsignal`.
- Start the service with: `service appsignal start`
- Stop the service with: `service appsignal stop`
- Configure it to run at boot-time: `update-rc.d appsignal defaults`
