import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_app/cubit/chat/chat_cubit.dart';
import 'package:chatgpt_app/cubit/setting/setting_cubit.dart';
import 'package:chatgpt_app/service/api_service.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:chatgpt_app/service/tts.dart';
import 'package:chatgpt_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  final _scrollController = ScrollController();
  late bool isLoading;
  late FocusNode _focusNode;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Speech Screen'),
          backgroundColor: bgColor,
        ),
        body: BlocProvider(
          create: (context) => ChatCubit(),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: chatBgColor,
                  child: _buildListMessage(),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 190, vertical: 16),
                  color: chatBgColor,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    _buildTextField(),
                    _buildSendButton(),
                  ],
                ),
              ),
              AvatarGlow(
                endRadius: 35,
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
                                  _textController.text = text;
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
                        await speechToText.stop();
                      },
                      child: CircleAvatar(
                        backgroundColor: bgColor,
                        radius: 25,
                        child: Icon(
                          isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                "Hold to speak",
                style: TextStyle(
                  fontSize: 12,
                  color: isListening ? Colors.black54 : Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          focusNode: _focusNode,
          textCapitalization: TextCapitalization.sentences,
          controller: _textController,
          style: const TextStyle(color: Colors.black54),
          decoration: const InputDecoration(
            hintText: "Start typing or talking...",
            hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, settingState) {
            return Visibility(
              visible: !isLoading,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  iconSize: 25,
                  color: Colors.white,
                  onPressed: () {
                    //display user input
                    if (_textController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter a message'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    setState(() {
                      context.read<ChatCubit>().addMessage(ChatMessage(
                          text: _textController.text,
                          chatMessageType: ChatMessageType.user));
                      isLoading = true;
                    });
                    var input = _textController.text;
                    _textController.clear();
                    _focusNode.unfocus();
                    Future.delayed(const Duration(milliseconds: 50))
                        .then((value) => _scrollDown());

                    // call chatbot api
                    ApiService.generateResponse(input).then((value) {
                      setState(() {
                        isLoading = false;
                        //display chatbot response
                        context.read<ChatCubit>().addMessage(ChatMessage(
                            text: value, chatMessageType: ChatMessageType.bot));
                      });
                      _textController.clear();
                      Future.delayed(const Duration(milliseconds: 50))
                          .then((value) => _scrollDown());
                      settingState.isAutoRead
                          ? TextToSpeech.speak(
                              value, settingState.currentLanguage!)
                          : null;
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget _buildListMessage() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
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
}
