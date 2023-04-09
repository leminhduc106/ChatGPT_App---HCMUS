import 'package:chatgpt_app/cubit/setting/setting_cubit.dart';
import 'package:chatgpt_app/models/chatmessage.dart';
import 'package:chatgpt_app/service/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget({
    Key? key,
    required this.text,
    required this.chatMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chatMessageType == ChatMessageType.bot
        ? BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                color: const Color(0xff343541),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          child: Image.asset(
                            "assets/images/chatbot.png",
                            scale: 1.5,
                          ),
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                    state.isAutoRead
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              TextToSpeech.speak(text, state.currentLanguage);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: const Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          )
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: const Color(0xff444654),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: const CircleAvatar(
                      child: Icon(Icons.person),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
