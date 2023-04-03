part of 'chat_cubit.dart';

class ChatState extends Equatable {
  List<ChatMessage> messages;

  ChatState({
    this.messages = const [],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [messages];
}
