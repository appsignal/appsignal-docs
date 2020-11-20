---
title: "Find slowest database queries"
---

Requests and background jobs can be slow for all kinds of reasons, but a common one is slow database queries. Large tables and missing indexes may cause database queries to take longer than needed, making an app's users wait longer. With AppSignal's improve > Slow queries feature it becomes easier to find the queries in an app with the most impact so developers know what queries to focus on first.

-> 💻 Open the [Slow queries][slow queries] feature.

## Find slowest queries

In the [slow queries] section a list of queries is displayed in the left hand side table. By default this list is [sorted by impact](#sorting-queries).

Once an query event is opened by clicking on the event name, the right hand side detail panel provides [more insights into each event](#query-details).

The type of events that can be found in the Slow queries section are listed below. They may or may not be grouped under the <abbr title="Object-relational mapping">ORM</abbr> event group name for some integrations. The help tooltips on the [slow queries page][slow queries] is up-to-date with all loaded event groups.

- Elasticsearch
- MongoDB
- MySQL
- PostgreSQL
- Redis
- SQLite
- And more.

### Sorting queries

By default the slow query list is sorted by impact: the queries that take up the most time either by duration of queries or by how often they are performed.

It is also possible to sort this table by "Throughput", how often the query has been recorded, and "Mean", the mean duration of the queries.

### Query details

After selecting a query to inspect further, the right hand side detail panel provides more insights of the selected event over the selected timeframe, such as:

- Full query with optional event title for more context
- The database query event summary:
  - Mean duration of query
  - Throughput, how often the query was recorded
  - The impact of the query in percentage of all database queries in the selected timeframe.
- Response time graph
- Throughput graph
- Actions and performance measurements in which the event occurred
  - Directly go to actions and performance measurements in which the event was recorded to see the impact per request and background jobs in the sample event timeline.

## Next steps?

- [Explore all app events](https://appsignal.com/redirect-to/app?to=queries)
- [Find slow API requests](https://appsignal.com/redirect-to/app?to=improve/requests)
- [Event group naming](/api/event-names.html)

---

- [Getting started guides](/guides/) - Guides overview

[slow queries]: https://appsignal.com/redirect-to/app?to=improve/queries
