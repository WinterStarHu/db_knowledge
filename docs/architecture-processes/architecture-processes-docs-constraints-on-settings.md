---
description: 'Constraints on settings can be defined in the `profiles` section of
the `user.xml` configuration file and prohibit users from changing some of the settings with the `SET` query.'
sidebarTitle: 'Constraints on settings'
slug: /operations/settings/constraints-on-settings
title: 'Constraints on settings'
doc_type: 'reference'
---

## Overview {#overview}

In ClickHouse, "constraints" on settings refer to limitations and rules which you can assign to settings. These constraints can be applied to maintain stability, security and predictable behavior of your database.

## Defining constraints {#defining-constraints}

Constraints on settings can be defined in the `profiles` section of the `user.xml` configuration file. They prohibit users from changing some settings using the [`SET`](/reference/statements/set) statement.

Constraints are defined as follows:

```xml
lower_boundary
upper_boundary
lower_boundary
upper_boundary
lower_boundary
upper_boundary
lower_boundary
upper_boundary
value1
value2
value3
```

If the user tries to violate the constraints, an exception is thrown and the setting remains unchanged.

## Types of constraints {#types-of-constraints}

There are a few types of constraints supported in ClickHouse:
- `min`
- `max`
- `disallowed`
- `readonly` (with alias `const`)
- `changeable_in_readonly`

The `min` and `max` constraints specify upper and lower boundaries for a numeric setting and can be used in combination with each other.

The `disallowed` constraint can be used to specify specific value(s) which should not be allowed for a specific setting.

The `readonly` or `const` constraint specifies that the user cannot change the corresponding setting at all.

The `changeable_in_readonly` constraint type allows users to change the setting within the `min`/`max` range even if the `readonly` setting is set to `1`, otherwise settings are not allowed to be changed in `readonly=1` mode.

### Do not make `readonly` changeable in read-only mode {#readonly-changeable-in-readonly}

Keep `readonly` off the `changeable_in_readonly` list in every profile, including profiles you assign to nobody: a profile's name is selectable by any session.

Don't mark `readonly` itself as `changeable_in_readonly`. If you do, a session that starts at `readonly = 1` can run `SET readonly = 0` and regain the ability to run the write queries its existing privileges already allow, unless the same constraint also forbids `0`.

This matters for every profile you define, not only the ones you assign:
- `SET profile` is not access-checked, so any session can select any profile by name. A profile is reachable even when you assign it to nobody, although what it then changes is still checked against the constraints already active in that session.
- Over HTTP, `GET` requests are forced to `readonly = 2` only when the effective value would otherwise be `0`. So a profile that sets `readonly = 1` but also lets `readonly` be changed in read-only mode defeats that protection, because a `GET` request can flip it to `0` and write.

## Multiple constraint profiles {#multiple-constraint-profiles}

If there are multiple profiles active for a user, then constraints are merged.
The Merge process depends on `settings_constraints_replace_previous`:
- **true** (recommended): constraints for the same setting are replaced during
merge, such that the last constraint is used and all previous ones are ignored.
This includes fields that are not set in new constraint.
- **false** (default): constraints for the same setting are merged in a way that
every unset type of constraint is taken from the previous profile and every set type of constraint is replaced by the value from the new profile.

## Read-only mode {#read-only}

Read-only mode is enabled by the `readonly` setting, which is not to be confused with the `readonly` constraint type. When `readonly = 1`, a setting that would otherwise be refused can still be changed if a `changeable_in_readonly` constraint allows it. For what the values of the setting mean, see the [settings reference](/reference/settings/session-settings/other#readonly); for which classes of query each value permits, and for how the HTTP interface sets it, see [permissions for queries](/concepts/features/configuration/settings/permissions-for-queries#readonly).

### Example {#example-read-only}

Let `users.xml` include the following lines:

```xml
10000000000
    ...
5000000000
20000000000
```

The following queries will all throw exceptions:

```sql
SET max_memory_usage=20000000001;
SET max_memory_usage=4999999999;
SET force_index_by_date=1;
```

```text
Code: 452, e.displayText() = DB::Exception: Setting max_memory_usage should not be greater than 20000000000.
Code: 452, e.displayText() = DB::Exception: Setting max_memory_usage should not be less than 5000000000.
Code: 452, e.displayText() = DB::Exception: Setting force_index_by_date should not be changed.
```

## Constraints on MergeTree settings {#constraints-on-merge-tree-settings}

It is possible to set constraints for [merge tree settings](/reference/settings/merge-tree-settings).
These constraints are applied when a table with the MergeTree engine is created or its storage settings are altered.

The name of merge tree setting must be prepended by `merge_tree_` prefix when referenced in the `` section.

### Example {#example-mergetree}

You can forbid creating new tables with explicitly specified `storage_policy`

```xml
```
