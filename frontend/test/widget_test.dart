import 'package:flutter_test/flutter_test.dart';
import 'package:krishopaj/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const KrishopajApp());
    expect(find.text('Get Started'), findsOneWidget);
  });
}
