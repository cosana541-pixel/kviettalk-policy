import '../models/word.dart';

bool wordMatchesSearch(Word word, String query) {
  final normalizedQuery = _normalize(query);
  if (normalizedQuery.isEmpty) {
    return true;
  }

  return _normalize(word.korean).contains(normalizedQuery) ||
      _normalize(word.vietnamese).contains(normalizedQuery);
}

String _normalize(String value) {
  final lower = value.toLowerCase();
  final withoutMarks = lower
      .replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
      .replaceAll('đ', 'd');

  return withoutMarks.replaceAll(RegExp(r'\s+'), '');
}
