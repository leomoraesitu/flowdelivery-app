import 'package:flowdelivery_app/app/app.dart';
import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the app shell without Supabase config', (tester) async {
    await tester.pumpWidget(const FlowDeliveryApp());

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SignInPage), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, AppTheme.light);
  });
}
