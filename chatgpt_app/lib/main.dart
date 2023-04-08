import 'package:chatgpt_app/cubit/chat/chat_cubit.dart';
import 'package:chatgpt_app/cubit/setting/setting_cubit.dart';
import 'package:chatgpt_app/screens/speech_screen.dart';
import 'package:chatgpt_app/service/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ChatCubit(),
          ),
          BlocProvider(
            create: (context) => SettingCubit(),
          ),
        ],
        child: const SpeechScreen(),
      ),
    );
  }
}
