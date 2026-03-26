import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_sralanh/main.dart';
import 'package:project_sralanh/providers/word_book_provider.dart';

void main() {
  testWidgets('Home loads 오늘의 목표', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WordBookProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 목표'), findsOneWidget);
    expect(find.text('홈'), findsAtLeastNWidgets(1));
  });
}
