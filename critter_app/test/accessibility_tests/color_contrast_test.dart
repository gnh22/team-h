import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Contrast helpers
double luminance(Color c) => c.computeLuminance();

double contrastRatio(Color a, Color b) {
  final l1 = luminance(a);
  final l2 = luminance(b);
  final brightest = (l1 > l2) ? l1 : l2;
  final darkest = (l1 > l2) ? l2 : l1;
  return (brightest + 0.05) / (darkest + 0.05);
}

void main() {
  testWidgets('Text meets color contrast requirements', (tester) async {
    const bgColor = Colors.white;
    const fgColor = Colors.black;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: bgColor,
          body: const Text(
            "Hello",
            style: TextStyle(color: fgColor),
          ),
        ),
      ),
    );

    final ratio = contrastRatio(fgColor, bgColor);

    expect(ratio >= 4.5, true, reason: "Contrast ratio = $ratio, needs 4.5:1");
  });
}
