import 'package:flutter_test/flutter_test.dart';

import 'package:project_sralanh/main.dart';

void main() {
  testWidgets('Home loads 오늘의 목표', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('오늘의 목표'), findsOneWidget);
    expect(find.text('홈'), findsOneWidget);
  });
}
