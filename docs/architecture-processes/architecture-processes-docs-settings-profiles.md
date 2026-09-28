---
description: 'A collection of settings grouped under the same name.'
sidebarTitle: 'Settings profiles'
slug: /operations/settings/settings-profiles
title: 'Settings profiles'
doc_type: 'reference'
---

A settings profile is a collection of settings grouped under the same name.

The profile can have any name. You can specify the same profile for different users. The most important thing you can write in the settings profile is `readonly=1`, which ensures read-only access.

Settings profiles can inherit from each other. To use inheritance, indicate one or multiple `profile` settings before the other settings that are listed in the profile. In case when one setting is defined in different profiles, the latest defined is used.

To apply all the settings in a profile, set the `profile` setting.

Example:

Install the `web` profile.

```sql
SET profile = 'web'
```

Settings profiles are declared in the user config file. This is usually `users.xml`.

Example:

```xml

1000000000
100000000000

1000000
any

1000000
1000000000

100000
100000000
break

600
1000000

100

100

```

The example specifies two profiles: `default` and `web`.

The `default` profile has a special purpose: it must always be present and is applied when starting the server. In other words, the `default` profile contains default settings. The name of the default profile can be changed via `default_profile` server setting.

The `background` profile has a special purpose: it might be present to override settings for background operations. The parameter is optional and its name can be changed via `background_profile` server setting.

The `web` profile is a regular profile that can be set using the `SET` query or using a URL parameter in an HTTP query.
