# Elixir Releases

AppSignal’s Elixir integration does not require any extra configuration for apps deployed through [Distillery](https://github.com/bitwalker/distillery) or Elixir 1.9’s releases feature, but the agent needs to be built on a machine with the same architecture as the machine you'll be hosting your application on. AppSignal for Elixir doesn't support cross-compilation at this time.

## Debugging releases

Since released applications can be more difficult to debug, here are the steps we take when a support request for a deployed Elixir application comes in.

### Development mode

First and foremost, we check if the problem is caused by the release by making sure everything works in development, on your local machine. Start your app locally, on your development machine, in the development environment:

    $ mix phx.server

Request some pages in your app, and sign into AppSignal to see if any performance samples come in. If possible, trigger an exception in one of your app’s controllers to see if it ends up on your errors page too.

-> **Note**: Running AppSignal in your development environment will create a “dev” environment on your account overview in AppSignal, where the data will appear.

If you don’t receive any data, double-check the steps in the [installation guide](https://docs.appsignal.com/elixir/installation.html) and the [Phoenix](https://docs.appsignal.com/elixir/integrations/phoenix.html) guide to make sure everything in your app is set up properly.

If the install guide doesn’t show any missed steps, run the [diagnose command](https://docs.appsignal.com/elixir/command-line/diagnose.html#usage) (still on your local machine):

    $ mix appsignal.diagnose --send-report

The diagnose command runs diagnostics, and the `--send-report` option sends the report to our servers. Then, contact [support](mailto:support@appsignal.com) with the support token you receive at the end of the report.

### Diagnose

If everything works locally in development, but your production install isn’t yet, run the diagnose command on your release binary.

    # Elixir releases
    $ bin/your_app eval ":appsignal_tasks.diagnose()"

    # Distillery
    $ bin/your_app command appsignal_tasks diagnose

When asked to send the report to AppSignal, choose “Y”. Then, contact [support](mailto:support@appsignal.com) with the support token you receive at the end of the report.
