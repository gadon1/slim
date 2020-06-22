import 'dart:math';

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

  double levenshteinScore(String str) {
    if (this.length == 0) return str.length.toDouble();
    if (str.length == 0) return this.length.toDouble();

    List<List<int>> matrix = List.generate(this.length + 1,
        (index) => List.generate(str.length + 1, (index) => 0));

    for (int i = 0; i <= this.length; i++) matrix[i][0] = i;
    for (int j = 0; j <= str.length; j++) matrix[0][j] = j;

    for (int i = 1; i <= this.length; i++) {
      for (int j = 1; j <= str.length; j++) {
        int cost = this.codeUnitAt(i - 1) == str.codeUnitAt(j - 1) ? 0 : 1;
        matrix[i][j] = min(min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1),
            matrix[i - 1][j - 1] + cost);
      }
    }

    final int levenshteinDistance = matrix[this.length][str.length];
    return levenshteinDistance / max(this.length, str.length);
  }
}
