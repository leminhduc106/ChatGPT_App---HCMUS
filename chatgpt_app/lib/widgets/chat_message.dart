import 'package:chatgpt_app/models/chatmessage.dart';
import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: chatMessageType == ChatMessageType.bot
          ? const Color(0xff343541)
          : const Color(0xff444654),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 16),
              child: chatMessageType == ChatMessageType.bot
                  ? CircleAvatar(
                      child: Image.asset(
                        "assets/images/chatbot.png",
                        scale: 1.5,
                      ),
                    )
                  : const CircleAvatar(
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