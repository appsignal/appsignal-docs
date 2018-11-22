---
title: "Sequel"
---

The [Sequel][sequel] gem is a fast ORM for Ruby. AppSignal supports Sequel
automatically and no manual instrumentation is needed.

## Disable instrumentation

We have a configuration option to disable instrumentation for Sequel.

Read more about [`:instrument_sequel`][instrument-sequel].

## Known issues

### sequel-rails integration

When using the [sequel-rails][sequel-rails] gem the instrumentation from the
sequel-rails gem and AppSignal gem can [conflict when running
migrations][instrumentation-issue].

Because both gems are instrumenting sequel you'll get two instrumentation
events and possible an error. [Disable the AppSignal sequel
instrumentation](#disable-instrumentation) is this occurs.

### Lack of instrumentation

Some Sequel extensions override the AppSignal Ruby gem instrumentation. One
such extension is the [error_sql][error_sql-extension]. This causes AppSignal
to be unable to instrument Sequel. The effect being no Sequel instrumentation
events to appear on AppSignal.com.

To use the AppSignal instrumentations in this scenario, the AppSignal Sequel
instrumentation needs to be loaded manually after all other extensions have
loaded.

```ruby
# Load extension that overrides the AppSignal instrumentation. This is an
# example. Other extensions might override it too.
Sequel::Database.extension :error_sql

# Manually load the instrumentation of sequel with AppSignal in combination
# with an extension that overrides the AppSignal gem instrumentation on load.
#
# Make sure you set `instrument_sequel` to `false` in the AppSignal config.
# http://docs.appsignal.com/ruby/configuration/
#
# Note: Use `Appsignal::Hooks::SequelLogExtension` for Sequel version 4.34
# and below.
Sequel::Database.register_extension(
  :appsignal_integration,
  Appsignal::Hooks::SequelLogConnectionExtension
)
Sequel::Database.extension(:appsignal_integration)
```

Note: only since version `2.0.2` do the other extension's functionality remain
intact after loading the AppSignal instrumentation.

## Example applications

We have two example applications in our examples repository on GitHub.

- [AppSignal + Sequel][example-app]  
  The example shows how to set up AppSignal with Sequel and Rails, without
  ActiveRecord and using only the sequel gem, not the sequel-rails gem.
- [AppSignal + Sequel - manual instrumentation app][example-manual-instrumentation-app]  
  This example shows how to manually load the AppSignal Sequel instrumentation
  in a Rails application, using only the sequel gem, not the sequel-rails gem.

[sequel]: http://sequel.jeremyevans.net/
[sequel-rails]: https://github.com/TalentBox/sequel-rails
[instrument-sequel]: /ruby/configuration/options.html#appsignal_instrument_sequel-instrument_sequel
[instrumentation-issue]: https://github.com/appsignal/appsignal-ruby/issues/91
[example-app]: https://github.com/appsignal/appsignal-examples/tree/rails-5+sequel
[example-manual-instrumentation-app]: https://github.com/appsignal/appsignal-examples/tree/rails-5+sequel-manual-instrumentation
[error_sql-extension]: http://sequel.jeremyevans.net/rdoc-plugins/files/lib/sequel/extensions/error_sql_rb.html
