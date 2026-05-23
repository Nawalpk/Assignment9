import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/main.dart';

void main() {
  testWidgets('App boots and shows Products app bar', (tester) async {
    await tester.pumpWidget(const MyApp());
    // Pump a few frames so the initial fetchProducts microtask runs.
    await tester.pump();
    expect(find.text('Products'), findsOneWidget);
  });
}
