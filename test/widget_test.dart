import 'package:flutter_test/flutter_test.dart';
import 'package:mindcheck/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MindCheck starts on the welcome screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MindCheckApp());
    await tester.pump();

    expect(find.text('Welcome to MindCheck'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started opens the home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MindCheckApp());
    await tester.pump();

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('Welcome to MindCheck'), findsNothing);
  });

  testWidgets('Home screen opens directly once the welcome was seen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MindCheckApp(showWelcome: false));
    await tester.pump();

    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('Welcome to MindCheck'), findsNothing);
  });
}