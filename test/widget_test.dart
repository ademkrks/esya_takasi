import 'package:esya_takas/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uygulama basliyor mu', (tester) async {
    await tester.pumpWidget(const EsyaTakasUygulamasi());
    expect(find.text('Esya Takas'), findsOneWidget);
  });
}
