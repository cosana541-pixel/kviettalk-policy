import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/conversation_item.dart';

// 로컬 JSON 회화 데이터를 읽는 전용 서비스입니다.
class ConversationService {
  Future<List<ConversationItem>> loadConversations() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/conversations.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => ConversationItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
