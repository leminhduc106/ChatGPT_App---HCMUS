import 'dart:convert';

import 'package:chatgpt_app/models/chatmessage.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:chatgpt_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    final apiKey = apiSecretKey;
    var url = Uri.https("api.openai.com", "v1/completions");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application.json',
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
    return data['choices'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ChatGPT App"),
          backgroundColor: const Color(0xff343541),
        ),
        backgroundColor: const Color(0xff444654),
        body: Center(
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
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: const Color(0xff343541),
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
    return Visibility(
      visible: !isLoading,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: const Color(0xff343541),
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          icon: const Icon(Icons.send),
          iconSize: 25,
          color: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildListMessage() {
    return ListView.builder(
      itemCount: _messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }
}
