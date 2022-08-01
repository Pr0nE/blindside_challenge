extension ObjectExtension on Object {
  /// Null-aware version of `as`.
  /// 
  /// Returns `null` if fails.
  T? asOrNull<T>() => this is T ? this as T : null;
}
