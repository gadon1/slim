/// Useful extension methods on [String]
extension SlimStringX on String {
  /// True if null or empty
  bool get isNullOrEmpty => (this ?? '').isEmpty;

  /// True if not null or empty
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;

  /// String format with with format variables, format is %index
  String format(List<dynamic> variables) {
    if (variables == null || variables.isEmpty) return this;
    String res = this;
    for (int i = 0; i < variables.length; i++)
      res = res.replaceAll("%$i", "${variables[i]}");
    return res;
  }
}
