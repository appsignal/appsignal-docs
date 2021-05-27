---
title: "Tagging and Sample Data"
---

You can supply extra context on errors and performance issues using tags and sample data. 
This can help to add information that is not already part of the request, session or environment parameters.


!> **Warning**: Do not use tagging to send personal data such as names or email addresses to AppSignal. If you want to identify a person, consider using a user ID, hash or pseudonymized identifier instead. You can use [link templates](/application/link-templates.html) to link them to your own system.

-> 📖 Also read our guide on [how to set up tags and sample data](/guides/custom-data).

## Tags

Using tags you can easily add more information to errors and performance issues tracked by AppSignal. Maybe while debugging an issue you want to know which user faced the problem, you can pass in the user id or maybe to easily access the user data you can pass in the url of your admin panel (using link templates) which will take you directly to the customer page.

### Link templates

Tags can also be used to create link templates. Read more about link templates
in our [link templates guide](/application/link-templates.html).


## Sample Data

Tags are a great way to pass along the additional details however they are limited to just passing in the key and value pair (You can add multiple key and value pairs.). There will be cases where you want to pass more than just a key and value pair. For example while debugging an api performance issue you might want to have a look at the json payload that came along with the request. In this case you can use sample data (custom data) to store that payload along with the request in AppSignal.

There are 4 kind of sample data.

1. Session data
    * This stores the session data by default; you do not have to pass these in explicitly. AppSignal picks these up automatically (if you are using frameworks), 
2. Params
   * If you are using Ruby on Rails or a Phoenix framework, then AppSignal will fill in the action params for you here automatically.
3. Environment
   * Here AppSignal will display information it receives in the header (e.g. request method, server name/port).
4. Custom Data
   * You can use custom data if additional details you want to send are not related to the above three types. AppSignal does not automatically save anything in [custom data](/guides/custom-data/sample-data.html) unless you specifically tell it.

-> You can [overwrite](/guides/custom-data/sample-data.html) or [filter](/guides/filter-data/filter-session-data.html) the custom data.
