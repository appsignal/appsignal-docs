---
title: Contributing
---

Interested in contributing to AppSignal? Great!

Helping out is possible in many ways. By reporting issues, fixing bugs, adding
features and even fixing typos. [Let us know][contact] if you have any
questions about contributing to any of our projects.

We're very happy sending anyone who contributes Stroopwaffles. Have look at
everyone we sent a package to so far on our [Stroopwaffles page][waffles-page].

## Open Source projects

All open source projects are available on our [AppSignal GitHub organization][github-appsignal].

Our main projects include:

- [AppSignal Ruby library][appsignal-ruby]
- [AppSignal Elixir library][appsignal-elixir]
- [AppSignal Front-end JavaScript library][appsignal-javascript]
- [AppSignal Node.js library][appsignal-nodejs]
- [AppSignal Documentation][appsignal-docs] - That's this website!
- [AppSignal Examples applications][appsignal-examples]

Other projects we have open sourced, and are used internally by other projects,
include:

- [AppSignal Rust agent][appsignal-rust]  
  Early stage proof of concept of AppSignal Rust integration.
- [sql_lexer][sql_lexer]  
  Rust library to lex and sanitize SQL queries.
- [probes.rs][probes-rs]  
  Rust library to read out system stats from a machine running Linux.
- [public_config][public_config]  
  Parts of AppSignal.com configuration that are public, such as magic dashboards.

## Using git and GitHub

We organize most of our git repositories on GitHub using a `main` and
`develop` branch. The `main` branch corresponds to the current stable
release of a project. The `develop` branch is used for development of features
that will end up in the next minor release of a project.

Feature branches are used to submit bug fixes and new features using GitHub
Pull Requests. When submitting a Pull Request the changes are tested against a
variety of Ruby/Elixir versions and dependencies on [Travis
CI][travis-appsignal]. The submitted change is also reviewed by two or more
AppSignal project members before it is accepted.

## Versioning

AppSignal is very open about changes to its product. Changes to integrations
and the application itself are all visible on
[AppSignal.com/changelog][changelog]. Big updates will also be posted on [our
blog][blog].

All AppSignal integration projects use [Semantic Versioning][semver] for
versioning of releases. Documentation and other non-version specific projects
do not use explicit versioning, but will mention related version specific
content, such as in which version a feature was introduced.

Every stable and unstable release is tagged in git with a version tag and can
be found on every project's GitHub page under "Releases".

## Reporting bugs

Report a bug by opening an issue on the GitHub project page of the respective
project. If the bug report contains some sensitive information that is
necessary for the complete report you can also [contact us][contact] to submit
the bug.

When the bug is a security sensitive issue, please refer to the [Security
issues](#security-issues) section.

When submitting a bug fix please create a Pull Request on the project's GitHub
page please submit the change against the `main` branch.

## Feature requests

Missing a feature or integration in AppSignal? Please let us know when
something comes to mind by [sending us an email][contact] or submitting an
issue on the project's GitHub page.

It's also possible to submit a feature on one of our Open Source projects by
creating a Pull Request targeted on the project's `develop` branch.

## Security issues

If you think you've found a security issue with regards to our application,
network or integrations, please let us know immediately by sending an email to
[security@appsignal.com](mailto:security@appsignal.com).

## Code of Conduct

Everyone interacting in AppSignal's codebases and issue trackers is expected
to follow the contributor [code of conduct][coc]. Please report unacceptable
behavior to [contact@appsignal.com][coc-contact].

[contact]: mailto:support@appsignal.com
[blog]: http://blog.appsignal.com/
[changelog]: https://appsignal.com/changelog
[waffles-page]: https://appsignal.com/waffles
[appsignal-ruby]: https://github.com/appsignal/appsignal-ruby
[appsignal-elixir]: https://github.com/appsignal/appsignal-elixir
[appsignal-javascript]: https://github.com/appsignal/appsignal-javascript
[appsignal-nodejs]: https://github.com/appsignal/appsignal-nodejs
[appsignal-rust]: https://github.com/appsignal/appsignal-rs
[appsignal-docs]: https://github.com/appsignal/appsignal-docs
[appsignal-examples]: https://github.com/appsignal/appsignal-examples

[sql_lexer]: https://github.com/appsignal/sql_lexer
[probes-rs]: https://github.com/appsignal/probes-rs
[public_config]: https://github.com/appsignal/public_config

[github-appsignal]: https://github.com/appsignal
[travis-appsignal]: https://travis-ci.org/appsignal
[semver]: http://semver.org/
[coc-contact]: mailto:contact@appsignal.com
[coc]: /appsignal/code-of-conduct.html
