import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retro_messenger/widgets/soft_key_bar.dart';

void main() {
  testWidgets('답장 버튼 콜백', (tester) async {
    var called = false;
    await tester.pumpWidget(MaterialApp(home: SoftKeyBar(onReply: () { called = true; })));
    await tester.tap(find.text('답장'));
    await tester.pump();
    expect(called, isTrue);
  });
}
