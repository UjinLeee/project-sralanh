import 'package:flutter_test/flutter_test.dart';

import 'package:project_sralanh/main.dart';

void main() {
  testWidgets('홈 화면 기본 위젯 표시', (WidgetTester tester) async {
    await tester.pumpWidget(const KhmerLearningApp());

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('오늘의 목표'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
  });
}
