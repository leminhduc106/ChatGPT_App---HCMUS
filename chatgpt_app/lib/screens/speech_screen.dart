import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_app/main.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../cubit/chat_cubit.dart';
import '../models/chatmessage.dart';
import '../widgets/chat_message.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  var isListening = false;
  var text = 'Hold the button to speak';
  SpeechToText speechToText = SpeechToText();
  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ChatCubit(),
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: bgColor,
                  ),
                  child: const Center(
                      child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Chat Screen'),
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mic),
                  title: const Text('Voice Screen'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpeechScreen()));
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('Speech Screen'),
            backgroundColor: bgColor,
          ),
          floatingActionButton: AvatarGlow(
            endRadius: 75,
            animate: isListening,
            duration: const Duration(milliseconds: 2000),
            glowColor: bgColor,
            repeat: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            showTwoGlows: true,
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return GestureDetector(
                  onTapDown: (details) async {
                    if (!isListening) {
                      var available = await speechToText.initialize();
                      if (available) {
                        setState(() {
                          isListening = true;
                        });
                        speechToText.listen(
                          onResult: (result) {
                            setState(() {
                              text = result.recognizedWords;
                            });
                          },
                        );
                      }
                    }
                  },
                  onTapUp: (details) async {
                    setState(() {
                      isListening = false;
                    });
                    speechToText.stop();

                    context.read<ChatCubit>().addMessage(
                          ChatMessage(
                            text: text,
                            chatMessageType: ChatMessageType.user,
                          ),
                        );
                  },
                  child: CircleAvatar(
                    backgroundColor: bgColor,
                    radius: 35,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: isListening ? Colors.black54 : Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: chatBgColor,
                    ),
                    child: _buildListMessage(scrollController),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildListMessage(ScrollController scrollController) {
  return BlocBuilder<ChatCubit, ChatState>(
    builder: (context, state) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          var message = state.messages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
        },
      );
    },
  );
}
