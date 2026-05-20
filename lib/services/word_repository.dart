import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/word.dart';

// 로컬 JSON 파일을 읽는 전용 클래스입니다.
// 나중에 데이터 파일이 바뀌어도 화면 코드는 거의 수정하지 않아도 됩니다.
class WordRepository {
  Future<List<Word>> loadWords() async {
    final jsonString = await rootBundle.loadString('assets/data/words.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Word.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
