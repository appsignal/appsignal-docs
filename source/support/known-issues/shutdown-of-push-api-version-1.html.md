---
title: Shutdown of AppSignal Push API version 1
---

## Affected components

- AppSignal for Ruby package versions: `v0.11.x` and earlier

## Description

Since the last release of the `0.x` series Ruby gem, a lot has changed about the AppSignal infrastructure. The Ruby gems from the `0.x` series push to a different Push API than the newer `1.x` series, and higher, do. To simplify our infrastructure and remove a lot of old systems we're shutting down the Push API version 1.

After the 30th of August we will shutdown the Push API version 1 and Ruby gems from the `0.x` series will no longer function.

### Upgrading

To upgrade the AppSignal Ruby gem, make sure to remove any version locks you may have for the AppSignal gem in your `Gemfile`, or update it to the latest version listed on [RubyGems.org](https://rubygems.org/gems/appsignal/versions).

```ruby
# Gemfile

gem "appsignal"
```

Then run `bundle update appsignal` to update the AppSignal Ruby gem. Commit the changes to the `Gemfile` and `Gemfile.lock` files, and deploy these changes to your app.

## Symptoms

Before the 30th of August you will have received one or more emails, linking to this page, recommending an upgrade of the AppSignal Ruby gem.

After the 30th of August 2018, no data will be reported to AppSignal.

## Solution

Upgrade to AppSignal for Ruby package version `1.0.0` or higher. We recommend upgrading to the latest version. There should be no problem upgrading to version `2.6` or higher. If you do encounter a problem, let us know at support@appsignal.com.
