---
title: "Active Job"
---

-> **Note**: Full support for Active Job was added in Ruby gem 2.11.0.

Active Job is a framework for declaring jobs and making them run on a variety of queuing backends shipped with Rails.

The Active Job integration tracks the execution and events from the job being performed.

## Metadata

- Job name, e.g. `MyBackgroundJob#perform` as used to group the job for AppSignal incidents.
- Events, all `*.active_job` events.
- Arguments, the argument given to the job with `perform_later`.
- Queue, if the adapter supports multiple queues it tags the sample with the queue name.
  - Tag: `queue`, value `String`
- Queue time, on Rails 6 and newer, job queue times are reported for the [namespace](/application/namespaces.html) in which the jobs are being processed. This graph can be found on the [Performance > Graphs page](https://appsignal.com/redirect-to/app?to=performance/graphs).
- Priority, if the adapter supports job priority it tags the sample with the configured priority.
  - Tag: `priority`, value `String/Number`
- Active job id, the job id as reported by the Active Job. This is the internal job id used by Active Job.
  - Tag: `active_job_id`, value `String`
- Provider job id, the job id as reported by the Active Job adapter. This is the internal job id used by the adapter.
  - Tag: `provider_job_id`, value `String/Number`

## Supported adapters

The Active Job integration supports all [Active Job adapters](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html). It may also support adapters not listed on that page, but available as a separate gem. These are not tested against.

## Integration with AppSignal supported libraries

Background job libraries AppSignal integrates with separately wrap the Active Job integration. This allows these integrations to more accurately report events and metadata from those libraries themselves and not just Active Job.

If a library is not listed here, the Active Job integration will only instrument the Active Job execution of the job.

- [Delayed::Job](delayed-job.html)
- [Que](que.html)
- [Resque](resque.html)
- [Sidekiq](sidekiq.html)

## Reported metrics

- `active_job_queue_job_count` - [counter](/metrics/custom.html#counter)
  - A _counter_ metric reporting the number of processed and failed jobs per queue.
  - Tag `queue`:
    - Named queue in which jobs are processed, e.g. `default` or `mailer`.
  - Tag `status`:
    - Status of each job, either `processed` or `failed`. Jobs that are `failed` are also counted as `processed`.
- `active_job_queue_priority_job_count` - [counter](/metrics/custom.html#counter)
  - A _counter_ metric reporting the number of processed and failed jobs per queue and priority. This metric is only reported if the Active Job adapter supports a priority system.
  - Tag `queue`:
    - Named queue in which jobs are processed, e.g. `default` or `mailer`.
  - Tag `status`:
    - Status of each job, either `processed` or `failed`. Jobs that are `failed` are also counted as `processed`.
  - Tag `priority`:
    - Priority given to each job, e.g. `0` or `1`.
