/// GetX already provides a `trPlural` extension on String:
///   `'singular_key'.trPlural('plural_key', count, {'count': '$count'})`
///
/// Convention used in this app:
///   - Singular key ends in `.one`
///   - Plural key ends in `.other`
///   - Both contain `{count}` placeholder for interpolation.
///
/// Example:
///   ```dart
///   'home.snack.imported.one'.trPlural(
///     'home.snack.imported.other',
///     count,
///     {'count': '$count'},
///   )
///   ```
///
/// This file is kept as a place to document the convention; no extension is
/// declared here to avoid clashing with GetX's built-in extension.
library;
