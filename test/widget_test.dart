import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/main.dart';

void main() {
  testWidgets('renders the initial app shell', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Hello World!'), findsOneWidget);
  });
}
