import 'package:flutter_test/flutter_test.dart';
import 'package:retro_messenger/providers/message_detail_provider.dart';

void main() {
  test('index 이동', () {
    final notifier = MessageDetailNotifier();
    notifier.next(3);
    expect(notifier.state.index, 1);
    notifier.prev();
    expect(notifier.state.index, 0);
  });

  test('읽음 토글', () {
    final notifier = MessageDetailNotifier();
    expect(notifier.state.isRead, false);
    notifier.toggleRead();
    expect(notifier.state.isRead, true);
  });
}
