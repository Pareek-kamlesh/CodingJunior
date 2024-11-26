import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_python_compiler/main.dart';

void main() {
  testWidgets('Interactive Python Compiler test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(PythonCompilerApp());

    // Verify initial UI elements
    expect(find.text('Interactive Python Compiler'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter Python code into the text field
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'print("Hello, World!")');
    await tester.pump();

    // Verify the text is entered correctly
    expect(find.text('print("Hello, World!")'), findsOneWidget);

    // Simulate tapping the Submit button
    final submitButtonFinder = find.widgetWithText(ElevatedButton, 'Submit');
    expect(submitButtonFinder, findsOneWidget);
    await tester.tap(submitButtonFinder);
    await tester.pump();

    // Since the actual execution depends on the backend, here we assume the output appears.
    // In a real-world test, you would mock the backend response.
    // For now, verify that the UI updates occur (e.g., output area exists).
    final outputFinder = find.textContaining("Output:");
    expect(outputFinder, findsOneWidget);

    // Simulate tapping the Clear button
    final clearButtonFinder = find.widgetWithText(ElevatedButton, 'Clear');
    expect(clearButtonFinder, findsOneWidget);
    await tester.tap(clearButtonFinder);
    await tester.pump();

    // Verify that the text field is cleared
    expect(find.text('print("Hello, World!")'), findsNothing);
  });
}
