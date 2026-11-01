import 'package:flutter_test/flutter_test.dart';
import 'package:mindcheck/main.dart';

void main() {
  testWidgets('MindCheck app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const MindCheckApp());

    expect(find.text('Welcome to MindCheck'), findsOneWidget);
  });
}