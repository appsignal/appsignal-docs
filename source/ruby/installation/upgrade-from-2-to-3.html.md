---
title: "Upgrade from AppSignal for Ruby gem 2.x to 3.x"
---

AppSignal for Ruby 3.0 is a major release as it changes the way it instruments other gems, removes support for older Ruby versions, removes the integrated JavaScript integration and removes previously deprecated modules. Follow this guide to make the upgrade process smoother.

## Upgrade to the latest 2.x series

Before upgrading to AppSignal for Ruby gem 3.0, please first upgrade to the latest gem from the 2.x series. This version will log and print deprecation warnings for things that will be removed in version 3.x of the gem. Run the tests for your app the gem is integrated with, fix any deprecation warnings and errors you may encounter. This upgrade step will make upgrading an easier process.

First, in the app's `Gemfile`, update the version lock to `~> 2.0` and run `bundle update appsignal` in a terminal in the same directory as the `Gemfile`.

```ruby
# Gemfile

gem "appsignal", "~> 2.0"
```

After all deprecation warnings have been resolved that appeared during testing and running the app, remove the version lock from the `Gemfile` and run `bundle update appsignal` again to update to AppSignal for Ruby 3.0.

## Removed Ruby 1.9 supported

The 3.x series of the Ruby gem will no longer support Ruby 1.9 and older versions. Ruby 1.9 has been End of Life since [23th of February 2015](https://www.ruby-lang.org/en/news/2015/02/23/support-for-ruby-1-9-3-has-ended/) and should no longer be used in production. Future versions of the AppSignal for Ruby gem may drop other End of Life versions of Ruby.

Please upgrade to a newer version of Ruby to continue using AppSignal for Ruby moving forward.

## Compatibility with other instrumentation gems

In the 3.x series the AppSignal for Ruby gem changed the internals of all its integrations of other gems. Instead of aliasing methods to provide instrumentation, the 3.x series uses `Module.prepend` (introduced in Ruby 2.0), a method to include Ruby Modules in classes and ensuring the included module gets called first.

__What does this means for your apps?__

Other instrumentation gems may either use the method aliasing or `Module.prepend` method to providing instrumentation. These instrumentation methods are __incompatible__ with one another if used on the same Ruby methods. If one gem uses method aliasing, and another `Module.prepend` the app will be caught in a loop and raise a [`stack level too deep (SystemStackError)`][module prepend issue].

The Ruby ecosystem seems to be moving towards the `Module.prepend` method of providing instrumentation so the AppSignal gem has updated its instrumentation method to be more compatible with other gems.

If an app starts encountering this issue with the AppSignal for Ruby 3.x series, upgrade other APM and error reporting gems in the app. They may have been updated to instrument using `Module.prepend` as well.

If the issue persists, please contact the maintainers of the other gems to update their implementation to `Module.prepend`, and downgrade the AppSignal for Ruby gem to the 2.x series for now. Please also [inform us][contact], so we can keep a list of compatible gems.

For more information and background of this change, see [issue 603 on the Ruby gem issue tracker][module prepend issue].

## Moved modules

Some modules in the gem have been moved or renamed. The 2.x series of the gem will print a warning if it encounters any with the new location of the called module. This warning is printed by a fallback when the old module name is called. This warning will no longer be printed if the new module name is being called instead.

If an app extended or monkeypatched an AppSignal module, the module name needs to be updated for the patch to work again. Do be warned that we do not provide support for these patches. If a private module has been removed without replacement, we do not provide the integration any more or it has been merged into another module.

## Removed JavaScript integration

The AppSignal for Ruby gem included a JavaScript exception tracking middleware, which has been removed in the 3.x series. Instead we recommend you use our dedicated [AppSignal for Front-end JavaScript integration](/front-end/).

### Removed options

The following options will no longer affect the AppSignal for Ruby gem, it can be removed from your apps.

- `enable_frontend_error_catching` - removed config option
  - `APPSIGNAL_ENABLE_FRONTEND_ERROR_CATCHING` - removed environment variable config option
- `frontend_error_catching_path` - removed config option
  - `APPSIGNAL_FRONTEND_ERROR_CATCHING_PATH` - removed environment variable config option

### Removed classes

The following classes have been removed from the Ruby gem and calling them will result in a `NameError`.

- `Appsignal::JSExceptionTransaction` - removed JavaScript transaction class
- `Appsignal::Rack::JSExceptionCatcher` - removed middleware

## Removed `appsignal notify_of_deploy` command

The `appsignal notify_of_deploy` command has been removed. Instead we recommend using the [`revision`](/ruby/configuration/options.html#option-revision) config option to report deploys more accurately. For more information on the topic of deploy markers, please see our [deploy markers section](/application/markers/deploy-markers.html).

If the `revision` option is not a good replacement for your deploy method, please use our [deploy markers API page](/api/markers.html) about how to send the request to notify AppSignal of deploys. And see our [Push & deploy page](https://appsignal.com/redirect-to/app?to=info) for your app for an example using your app's config.

## Removed deprecations

In AppSignal for Ruby 2.x series and older, some behavior of the AppSignal gem may have been deprecated. Most of these deprecations have been removed in the 3.x series.

On the latest release in the AppSignal for Ruby 2.x series, all these deprecations should print an warning to STDERR and to the [`appsignal.log`](/support/debugging.html#log-location) when still used. Please check the app output and logs while on the latest 2.x series gem and fix all deprecation warnings before upgrading. Each deprecation should print/log a warning with the changes needed to resolve the warning.

## Welcome to 3.x!

This guide should cover upgrading most Ruby applications to 3.x. If you have any questions, ran into errors, or would like assistance upgrading to the new version, please don't hesitate to [contact support][contact].

[contact]: mailto:support@appsignal.com
[module prepend issue]: https://github.com/appsignal/appsignal-ruby/issues/603
