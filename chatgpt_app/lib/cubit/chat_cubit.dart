import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chatmessage.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  void addMessage(ChatMessage message) {
    emit(state.copyWith(messages: [...state.messages, message]));
  }
}
