---
title: Asana
---

[Asana][asana] is the work management platform teams use to stay focused on the goals, projects, and daily tasks that grow business. Easily organize and plan workflows, projects, and more, so you can keep your team's work on schedule.

Asana is a personal integration set up per user. This means it needs to be configured per user in AppSignal who want to use the Asana integration for AppSignal apps.

<img src="/images/screenshots/asana/create_task.png" style="max-width: 650px" alt="Create an Asana task in AppSignal">

## Adding Asana to your app

- First open [Asana][asana] and go to your "Profile settings".
  - Open the "Apps" tab.
  - Click on the "Manage Developer Apps" link to get your API token.

<img src="/images/screenshots/asana/profile_settings.png" style="max-width: 650px" alt="Asana profile settings - Apps tab">

- Next, open your app on [AppSignal.com](https://appsignal.com/accounts).
  - Open the "Integrations" page for the app.
  - Click on "Configure" for the Asana integration.
  - Paste your Asana API token in the "API token" field.
  - Copy and paste the project ID of the Asana project you want to link in the "Project ID" field.
      - The project ID is part of the Asana URL: `https://app.asana.com/0/<project_id>/board`
  - Click the "create integration" button to create your Asana integration.

The integration has now been created! You can now send errors and performance issues to Asana from the incident details screen.

If anything went wrong while validating the integration your will be prompted with the error message.
Feel free [contact us](mailto:support@appsignal.com) if you experience any problems while setting up this integration.

[asana]: https://asana.com
