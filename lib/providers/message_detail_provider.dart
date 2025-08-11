import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageDetailState {
  final int index;
  final bool isRead;
  const MessageDetailState({required this.index, required this.isRead});

  MessageDetailState copyWith({int? index, bool? isRead}) =>
      MessageDetailState(index: index ?? this.index, isRead: isRead ?? this.isRead);
}

class MessageDetailNotifier extends StateNotifier<MessageDetailState> {
  MessageDetailNotifier() : super(const MessageDetailState(index: 0, isRead: false));

  void next(int total) {
    if (state.index < total - 1) {
      state = state.copyWith(index: state.index + 1);
    }
  }

  void prev() {
    if (state.index > 0) {
      state = state.copyWith(index: state.index - 1);
    }
  }

  void toggleRead() {
    state = state.copyWith(isRead: !state.isRead);
  }
}

final messageDetailProvider =
    StateNotifierProvider<MessageDetailNotifier, MessageDetailState>((ref) => MessageDetailNotifier());
