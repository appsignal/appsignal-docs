---
title: "Supported Operating Systems"
---

The AppSignal integrations for Ruby, Elixir & Node.js contain native extensions and a separate lightweight agent process. These native extensions are supported on most Linux distributions, FreeBSD and macOS/OSX. If an Operating System you use is not supported, please [get in touch](mailto:support@appsignal.com).

## Support table

We currently only support running AppSignal on machines with an Intel based architecture.

| Operating System                                            | 32-bit support | 64-bit support |
| ----------------------------------------------------------- | -------------- | -------------- |
| macOS/OSX                                                   |                |                |
| &nbsp;&nbsp;&nbsp;&nbsp; - `darwin` <sup>1</sup>            |                | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - `ARM` Apple Silicon <sup>8</sup> |                |                |
| Linux <sup>2 3</sup>                                        | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Alpine Linux <sup>4 5</sup>      |                | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - CentOS                           | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Debian                           | ✓              | ✓              |
| &nbsp;&nbsp;&nbsp;&nbsp; - Fedora                           | ✓              | ✓              |
| FreeBSD <sup>1</sup>                                        |                | ✓              |
| Microsoft Windows <sup>6</sup>                              |                |                |
| &nbsp;&nbsp;&nbsp;&nbsp; - Subsystem for Linux <sup>7</sup> |                | ? <sup>7</sup> |

- `1`: Does not support [host metrics][host-metrics] (yet).
- `2`: Depending on the integration version some older versions of the Operating System are supported. See the [Linux](#linux) section for more information.
- `3`: Older systems may require a dynamic builds, which is required for JRuby, which are supported since Ruby gem `2.8.0`. See the [Linux](#linux) section for more information.
- `4`: Supported since AppSignal for [Ruby](/ruby) version `2.1.x` and AppSignal for [Elixir](/elixir) version `0.11.0`.
- `5`: Dynamic builds (which are required for JRuby) are supported since Ruby gem `2.8.0`.
- `6`: Does not work directly on Microsoft Window's system. See also point 7.
- `7`: We do not provide support for this setup. May work with the Windows subsystem for Linux. See also the [Microsoft Windows WSL section](#microsoft-windows-subsystem-for-linux) for more information.
- `8`: We do not provide support for Apple Silicon currently. If you use an Apple Silicon based machine it's possible to run AppSignal (and the parent app) through Rosetta 2.

## Linux

AppSignal tries to support Linux as best as possible, but some changes in our build process have caused some problems with supporting certain Linux distributions and versions. Our agent and extension are compiled against libc, and based on which version of libc we compile against we support certain older versions of Linux distributions and some not.

### Supported versions

AppSignal support for versions of libc has changed over the past few versions of the Ruby gem and Elixir package.

This is the list of version of libc/musl AppSignal was compiled against over the last version of our integrations:

- AppSignal for Ruby `v1.0.0` - `v2.0.x`
  AppSignal for Elixir `v0.0.x` - `v0.10.x`
  - libc `v2.5`
  - musl `N/A`
- AppSignal for Ruby `v2.1.x` - `v2.3.x`
  AppSignal for Elixir `v0.11.x` - `v1.3.x`
  - libc `N/A` - see [DNS timeouts known issue](/support/known-issues/dns-timeouts.html).
  - musl `v1.1.16`
- AppSignal for Ruby `v2.4.x` and higher
  AppSignal for Elixir `v1.4.x` and higher
  - libc `v2.15`
  - musl `v1.1.16` - see [Alpine Linux install problems after upgrading](/support/known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html).

If your system uses an older libc version than AppSignal extension is compiled against, you will experience problems installing or running the AppSignal agent. If this is the case you can instead [opt-in to the musl build](#musl-build-override), which doesn't have this issue. This should no longer be a problem for AppSignal Ruby gem `v2.4.1` & Elixir package `v1.4.3` and higher, in these packages automatic detection for older libc versions was added and they will automatically switch to the musl build.

**Warning for JRuby**: JRuby support on Alpine Linux (musl build) is supported since Ruby gem `2.8.0`. This scenario requires a dynamic build of the AppSignal extension, which is not supported for the musl build for older versions of the gem.

You can see which version of libc your system uses by running the following command: `ldd --version 2>&1`

Example of output on Ubuntu 12.04:

```
$ ldd --version 2>&1
ldd (Ubuntu EGLIBC 2.15-0ubuntu10.18) 2.15
Copyright (C) 2012 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.
```

### Musl build override

To opt-in to the musl build manually, add the `APPSIGNAL_BUILD_FOR_MUSL` environment variable to your system environment before installing AppSignal and compiling your application.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_MUSL=1
gem install appsignal
# or with Bundler
bundle install

# For Elixir
export APPSIGNAL_BUILD_FOR_MUSL=1
mix deps.get
mix compile
```

### Linux ARM build override

To opt-in to the experimental Linux ARM build, add the `APPSIGNAL_BUILD_FOR_LINUX_ARM` environment variable to your system environment before installing AppSignal and compiling your application. This build is opt-in because it requires more testing, and we don't want to automatically install it on ARM systems in case something doesn't work as expected.

-> This build is currently only available for the Ruby gem, [let us know](mailto:support@appsignal.com) if you wish to try it for other integrations such as Elixir or Node.js.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_LINUX_ARM=1
gem install appsignal
# or with Bundler
bundle install
```

### Alpine Linux

[Alpine Linux] support was added in version `2.1.0` of the AppSignal for Ruby gem. (JRuby is not supported on Alpine Linux.) Our AppSignal for Elixir package supports Alpine Linux since version `0.11.0`.

The following system dependencies are required for Alpine Linux:

```sh
# Dependencies for the AppSignal Ruby gem
apk add --update alpine-sdk coreutils

# Dependencies for the AppSignal for Elixir package version 1.7.0 and newer
apk add --update alpine-sdk coreutils
# Dependencies for the AppSignal for Elixir package version 1.6.3 and older
apk add --update alpine-sdk coreutils curl
```

In AppSignal for Ruby version `2.4.0` and AppSignal for Elixir `1.4.0` we started shipping a separate build for Alpine Linux. If you upgraded from an earlier version and are have problems compiling your app, our detection isn't working properly. See our [upgrading issue](/support/known-issues/alpine-linux-ruby-gem-2-4-elixir-package-1-4-upgrade-problems.html) for more information.

For both the Ruby gem and Elixir package, detection is based on the output from `ldd --version`.

If your app is unable to call the `ldd` program or the detection is off for some reason, you can force the Alpine Linux compatible build by providing a special environment variable on install.

```sh
# For Ruby
export APPSIGNAL_BUILD_FOR_MUSL=1
gem install appsignal
# or with Bundler
bundle install

# For Elixir
export APPSIGNAL_BUILD_FOR_MUSL=1
mix deps.get
mix compile
```

####^alpine-linux Ruby

For the Ruby gem add this to your `Gemfile`:

```ruby
gem "appsignal", ">= 2.1.0" # or a newer version
```

For the latest available version see the full list on [RubyGems.org](https://rubygems.org/gems/appsignal/versions) and if you run into any problems please [let us know](mailto:support@appsignal.com).

####^alpine-linux Elixir

If you're using Elixir, add this to your `mix.exs` file:

```elixir
{:appsignal, ">= 1.0.0"} # or a newer version
```

For the latest available version see the full list on [Hex.pm](https://hex.pm/packages/appsignal) and if you run into any problems please [let us know](mailto:support@appsignal.com).

### CentOS

CentOS is fully supported by the AppSignal extension. Depending on your CentOS version you may need to select another build type for AppSignal Ruby gem `v2.4.0` and AppSignal for Elixir `v1.4.0` and higher.

The following system dependencies are required for CentOS:

```sh
# Dependencies for the AppSignal Ruby gem
yum install gcc gcc-c++ make openssl-devel

# Dependencies for the AppSignal Elixir package
yum install gcc gcc-c++ make openssl-devel curl
```

For CentOS 7 and higher there is no problem upgrading to AppSignal for Ruby `v2.4.0` and AppSignal for Elixir `1.4.0` and higher.

For CentOS 6 and older versions you will need to opt-in to the musl build for AppSignal instead. For more information, see the [Linux section](#linux).

### Debian / Ubuntu

The following system dependencies are required for Debian Linux distributions:

```sh
# Dependencies for the AppSignal Ruby gem
apt-get update
apt-get install build-essential ca-certificates

# Dependencies for the AppSignal Elixir package
apt-get update
apt-get install build-essential ca-certificates curl
```

### Fedora

The following system dependencies are required for Fedora Linux distributions:

```sh
# Dependencies for the AppSignal Ruby gem
dnf install gcc gcc-c++ make openssl-devel

# Dependencies for the AppSignal Elixir package
dnf install gcc gcc-c++ make openssl-devel curl
```

## FreeBSD

Support for FreeBSD systems was added in AppSignal for Ruby gem `2.4.0` and AppSignal for Elixir package `1.4.0`. It currently does not support the [host metrics][host-metrics] feature.

The following system dependencies are required for FreeBSD Linux distributions:

```sh
pkg install gcc gmake openssl-devel
```

## macOS

macOS (OS X) `10.14.x` and up is supported by AppSignal for Ruby, Elixir & Node.js. It currently does not support the [host metrics][host-metrics] feature.

Please make sure Xcode is installed with the command line build tools.

```sh
xcode-select --install
```

-> **Note**: We do not provide support for Apple Silicon currently. If you use an Apple Silicon based machine it's possible to run AppSignal (and the parent app) through Rosetta 2.

## Microsoft Windows

We currently have no plans to support the [Microsoft Windows](https://www.microsoft.com/en-us/windows/) Operating System. We do try to make the AppSignal libraries installable on Microsoft Windows without any errors or build issues so that the app it's installed in continues to operate.

If you use Microsoft Windows and would like us to support it, [send us an e-mail](mailto:support@appsignal.com).

### Ruby

To install the AppSignal Ruby gem on Microsoft Windows, make sure you have the [RubyInstaller](https://rubyinstaller.org/) DevKit installed before installing AppSignal. Otherwise there will be the following error during installation of our C-extension. We will not install the C-extension on Microsoft Windows, but the Ruby installation detects it's part of the gem and will not continue without the DevKit.

```sh
$ gem install appsignal
Fetching appsignal 2.2.1
Installing appsignal 2.2.1 with native extensions
Gem::InstallError: The 'appsignal' native gem requires installed build tools.
Please update your PATH to include build tools or download the DevKit
from 'http://rubyinstaller.org/downloads' and follow the instructions
at 'http://github.com/oneclick/rubyinstaller/wiki/Development-Kit'
```

### Microsoft Windows Subsystem for Linux

!> We do not provide support for the Microsoft Windows Subsystem for Linux.

The [Microsoft Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL) is a layer between Microsoft Windows and a [Linux](#linux) distribution. This allows users to run certain GNU/Linux distributions, that are available in the Microsoft Store, on their Microsoft Windows computer.

Running an app on WSL using an AppSignal integration will not cause any errors or build issues, as described in the [Microsoft Windows section](#microsoft-windows).

Running AppSignal on WSL will work as well as the WSL supports it. Follow the steps for your [Linux distribution](#linux) on this page in the WSL environment to properly install the AppSignal dependencies, before installing AppSignal in your app.

In our testing using the Ubuntu WSL, we've found that most AppSignal features will work, but we can't say how accurate the information gathered from it is. Some small differences between WSL's implementation and our Linux test setups, may cause odd behavior or inaccurately reporting of metrics. We do not actively test against WSL and cannot guarantee its successful operation. <u>We do not provide support for AppSignal on the WSL.</u>

Not all AppSignal features will work on the WSL system, in our testing we've confirmed [host metrics](/metrics/host.html) for disks (usage and IO) do not work.

Use AppSignal in our app on the WSL system to test AppSignal's integration in your app in a development environment, but not do not use this setup in a production environment. Always test your app using AppSignal on a staging environment with a similar environment (Operating System) to the app's production environment first.

[Alpine Linux]: https://alpinelinux.org/
[musl]: https://www.musl-libc.org/
[Rust]: https://www.rust-lang.org/en-US/
[host-metrics]: /metrics/host.html
