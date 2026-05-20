import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:korean_vietnamese_app/main.dart';

void main() {
  testWidgets('K-Viet Talk first screen smoke test', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const KVietTalkApp());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
    });
    await tester.pump();

    expect(find.text('K-Viet Talk'), findsWidgets);
    expect(find.text('Học tiếng Hàn dễ dàng mỗi ngày'), findsOneWidget);
    expect(find.text('Từ vựng'), findsWidgets);
    expect(find.text('Câu đố'), findsWidgets);
  });
}
