import 'dart:convert';

import 'package:chatgpt_app/service/constant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> generateResponse(String prompt) async {
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
          'max_tokens': 100,
          'temperature': 0,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }));
    //Decode the response
    Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['choices'][0]['text'];
  }
}
