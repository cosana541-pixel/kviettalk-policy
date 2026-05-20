import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/app_state.dart';
import 'screens/home_screen.dart';
import 'services/favorite_service.dart';
import 'services/tts_service.dart';
import 'services/word_repository.dart';

void main() {
  runApp(const KVietTalkApp());
}

class KVietTalkApp extends StatelessWidget {
  const KVietTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 앱 전체 상태입니다. 생성 직후 initialize()로 JSON과 즐겨찾기를 불러옵니다.
        ChangeNotifierProvider(
          create: (_) => AppState(
            wordRepository: WordRepository(),
            favoriteService: FavoriteService(),
          )..initialize(),
        ),
        // TTS는 화면에서 바로 사용할 수 있도록 Provider로 등록합니다.
        Provider(create: (_) => TtsService()),
      ],
      child: MaterialApp(
        title: 'K-Viet Talk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 1),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
