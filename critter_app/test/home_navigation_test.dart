import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:critter_app/views/home_page.dart';
import 'package:critter_app/views/glossary_page.dart';
import 'package:critter_app/views/filter_page.dart';
import 'package:critter_app/viewmodels/critter_viewmodel.dart';

class MockCritterViewModel extends Mock implements CritterViewModel {}

void main() {
  late MockCritterViewModel mockVM;

    setUp(() {
    mockVM = MockCritterViewModel();

    when(() => mockVM.loading).thenReturn(false);
    when(() => mockVM.error).thenReturn(null);
    when(() => mockVM.critters).thenReturn([]);
    when(() => mockVM.allCritters).thenReturn([]);
    when(() => mockVM.hour).thenReturn(12);
    when(() => mockVM.minute).thenReturn(0);
    when(() => mockVM.current).thenReturn(DateTime(2025, 1, 1));
    when(() => mockVM.hemisphere).thenReturn("north");
  });


  Widget createTestApp() {
    return ChangeNotifierProvider<CritterViewModel>.value(
      value: mockVM,
      child: const MaterialApp(home: HomePage()),
    );
  }

  testWidgets("Tapping Glossary navigates to GlossaryPage",
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text("Glossary"));
    await tester.pumpAndSettle();

    expect(find.byType(GlossaryPage), findsOneWidget);
  });

  testWidgets("Tapping Filter navigates to CustomFilterPage",
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text("Filter"));
    await tester.pumpAndSettle();

    expect(find.byType(CustomFilterPage), findsOneWidget);
  });
}
