/// Useful extension methods on [String]
extension SlimStringX on String {
  /// True if null or empty
  bool get isNullOrEmpty => (this ?? '').isEmpty;

  /// True if not null or empty
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;
}
