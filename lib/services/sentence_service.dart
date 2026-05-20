import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/sentence_item.dart';

// assets/data/sentences.json 파일을 읽어 문장 목록으로 바꿉니다.
class SentenceService {
  Future<List<SentenceItem>> loadSentences() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/sentences.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => SentenceItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
