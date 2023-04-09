import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chatmessage.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(messages: []));

  void addMessage(ChatMessage message) {
    emit(ChatState(messages: [...state.messages, message]));
  }

  void removeAllMessages() {
    emit(ChatState(messages: []));
  }
}
