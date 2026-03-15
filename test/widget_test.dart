// Bu test dosyası otomatik oluşturulmuştur.
// Gerçek testler ilerleyen aşamada eklenecektir.

import 'package:flutter_test/flutter_test.dart';
import 'package:esya_takas/main.dart';

void main() {
  testWidgets('Uygulama başarıyla başlar', (WidgetTester tester) async {
    await tester.pumpWidget(const EsyaTakasUygulamasi());
    // Splash ekranının yüklendiğini doğrula
    expect(find.text('Eşya Takas'), findsOneWidget);
  });
}
