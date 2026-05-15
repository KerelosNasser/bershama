import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService extends GetxService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['OPENROUTER_API_KEY']}',
    },
  ));

  Future<String> getMedicalAdvice(String symptoms) async {
    try {
      final response = await _dio.post('/chat/completions', data: {
        'model': 'deepseek/deepseek-v4-flash:free',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a highly experienced pharmacist assistant for the Bershama app. Provide concise, accurate medical advice based on symptoms. Always advise consulting a real doctor.'
          },
          {'role': 'user', 'content': 'Symptoms: $symptoms'}
        ],
      });

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      return 'Error fetching advice. Please try again later.';
    }
  }
}
