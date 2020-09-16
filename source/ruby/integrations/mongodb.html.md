---
title: "MongoDB instrumentation"
---

## Usage

The AppSignal gem version `1.0` and up supports the [Mongo Ruby Driver] gem and the [Mongoid] gem out-of-the-box.

The Mongoid gem relies on the Mongo Ruby Driver. AppSignal activates Mongo Ruby Driver instrumentation automatically if it is detected in the project. No manual setup is required.

## Metrics

The Mongo Ruby Driver integration will report the following [metrics](/metrics/custom.html) for every query. Once we detect these metrics we'll add a [magic dashboard](https://blog.appsignal.com/2019/03/27/magic-dashboards.html) to your apps.

- `mongodb_query_duration` - [measurement](/metrics/custom.html#measurement)
  - We monitor all queries and calculate mean/90th/95th percentiles per database
  - Tag `database`: The database this query was executed

## Older Mongoid versions and MongoMapper

Older versions of the Mongo driver used in Mongoid 2 and MongoMapper, and Moped used in Mongoid 3, are not officially supported by [older AppSignal integration gems] but might still work.

[Mongo Ruby Driver]: https://github.com/mongodb/mongo-ruby-driver
[Mongoid]: https://github.com/mongodb/mongoid
[older AppSignal integration gems]: /ruby/integrations/appsignal-gems.html
