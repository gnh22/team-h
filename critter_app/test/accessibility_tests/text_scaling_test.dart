import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Text Scaling Accessibility Tests', () {
    testWidgets('Text widgets scale correctly with textScaleFactor',
        (WidgetTester tester) async {
      // Build widget with normal text scale
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                'Test Text',
                style: TextStyle(fontSize: 16),
                key: Key('test_text'),
              ),
            ),
          ),
        ),
      );

      // Get size with normal scale
      final normalSize = tester.getSize(find.byKey(Key('test_text')));

      // Rebuild with 2x text scale
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: Center(
                child: Text(
                  'Test Text',
                  style: TextStyle(fontSize: 16),
                  key: Key('test_text'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get size with 2x scale
      final scaledSize = tester.getSize(find.byKey(Key('test_text')));

      // Verify text is larger (height should be approximately 2x)
      expect(scaledSize.height, greaterThan(normalSize.height * 1.8));
      expect(scaledSize.width, greaterThan(normalSize.width * 1.8));
    });

    testWidgets('Container adapts to larger text without clipping',
        (WidgetTester tester) async {
      // Widget with text in a padded container
      Widget buildTestWidget(double textScale) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(textScale),
            ),
            child: Scaffold(
              body: Center(
                child: Container(
                  key: Key('container'),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    'Accessible Text',
                    key: Key('text'),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // Test with normal scale
      await tester.pumpWidget(buildTestWidget(1.0));
      final normalContainer = tester.getSize(find.byKey(Key('container')));

      // Test with 2x scale
      await tester.pumpWidget(buildTestWidget(2.0));
      await tester.pumpAndSettle();
      final scaledContainer = tester.getSize(find.byKey(Key('container')));

      // Container should grow to accommodate larger text
      expect(scaledContainer.height, greaterThan(normalContainer.height));
    });

    testWidgets('Multiple text scales render without overflow',
        (WidgetTester tester) async {
      final textScales = [1.0, 1.5, 2.0, 3.0];

      for (final scale in textScales) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                appBar: AppBar(title: Text('Title')),
                body: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Heading', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 8),
                      Text('Body text that should scale properly'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Button'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify no overflow errors
        expect(tester.takeException(), isNull,
            reason: 'Should not overflow at ${scale}x scale');
      }
    });

    testWidgets('ListTile handles text scaling gracefully',
        (WidgetTester tester) async {
      Widget buildListTile(double scale) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(scale),
            ),
            child: Scaffold(
              body: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Title Text'),
                    subtitle: Text('Subtitle text that is longer'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Test normal scale
      await tester.pumpWidget(buildListTile(1.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Test large scale
      await tester.pumpWidget(buildListTile(2.5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Text with maxLines still scales properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: Container(
                width: 200,
                child: Text(
                  'This is a long text that should wrap and scale',
                  key: Key('wrapped_text'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify text exists and no overflow
      expect(find.byKey(Key('wrapped_text')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Form fields scale text appropriately',
        (WidgetTester tester) async {
      Widget buildForm(double scale) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(scale),
            ),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Test different scales
      await tester.pumpWidget(buildForm(1.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildForm(2.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppBar title scales with accessibility settings',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(1.5),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: Text('App Title'),
              ),
              body: Center(child: Text('Content')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AppBar renders without issues
      expect(find.text('App Title'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Card with text content adapts to scaling',
        (WidgetTester tester) async {
      Widget buildCard(double scale) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(scale),
            ),
            child: Scaffold(
              body: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Card Title',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Card description text'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final scales = [1.0, 1.5, 2.0, 2.5];
      for (final scale in scales) {
        await tester.pumpWidget(buildCard(scale));
        await tester.pumpAndSettle();
        
        expect(find.text('Card Title'), findsOneWidget);
        expect(tester.takeException(), isNull,
            reason: 'Card should handle ${scale}x scaling');
      }
    });
  });

  group('Custom Widget Text Scaling Tests', () {
    // Replace 'YourCustomWidget' with your actual widget
    // This is an example showing how to test your specific widgets
    testWidgets('Custom critter list item scales properly',
        (WidgetTester tester) async {
      // Example: Testing a custom critter card widget
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.bug_report),
                ),
                title: Text('Butterfly'),
                subtitle: Text('Available: March - September'),
                trailing: Text('500 Bells'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('Butterfly'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}