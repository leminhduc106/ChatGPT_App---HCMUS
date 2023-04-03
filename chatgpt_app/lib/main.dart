import 'dart:convert';

import 'package:chatgpt_app/models/chatmessage.dart';
import 'package:chatgpt_app/screens/speech_screen.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:chatgpt_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'cubit/chat_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLoading;
  final TextEditingController _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    const apiKey = apiSecretKey;
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'prompt': prompt,
          'model': 'text-davinci-003',
          'max_tokens': 2000,
          'temperature': 0,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }));
    //Decode the response
    Map<String, dynamic> data = jsonDecode(response.body);
    print("Response: ${response.body}");
    print(apiKey);
    return data['choices'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SpeechScreen()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("ChatGPT App"),
          backgroundColor: bgColor,
        ),
        backgroundColor: chatBgColor,
        body: BlocProvider(
          create: (context) => ChatCubit(),
          child: Center(
            child: Column(children: [
              Expanded(
                child: _buildListMessage(),
              ),
              Visibility(
                  visible: isLoading,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    _buildTextField(),
                    _buildSendButton(),
                  ],
                ),
              )
            ]),
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
          color: const Color(0xff444654),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: _textController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Type a message...",
            hintStyle: TextStyle(color: Colors.white54),
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
                // setState(() {
                context.read<ChatCubit>().addMessage(ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user));
                // isLoading = true;
                // });
                var input = _textController.text;
                _textController.clear();
                Future.delayed(const Duration(milliseconds: 50))
                    .then((value) => _scrollDown());

                // call chatbot api
                // generateResponse(input).then((value) {
                //   setState(() {
                //     isLoading = false;
                //     //display chatbot response
                //     _messages.add(ChatMessage(
                //         text: value, chatMessageType: ChatMessageType.bot));
                //   });
                //   _textController.clear();
                //   Future.delayed(const Duration(milliseconds: 50))
                //       .then((value) => _scrollDown());
                // });
              },
            ),
          ),
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
          itemCount: state.messages.length,
          controller: _scrollController,
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
