import 'package:flutter_test/flutter_test.dart';

import 'package:dian_dian/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DianDianApp());
    // The app should render the title during loading
    expect(find.text('\u70B9\u70B9'), findsOneWidget);
  });
}
