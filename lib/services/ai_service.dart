import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AiService extends GetxService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer sk-or-v1-placeholder', // Replace with real key or move to env
    },
  ));

  Future<String> getMedicalAdvice(String symptoms) async {
    try {
      final response = await _dio.post('/chat/completions', data: {
        'model': 'google/gemini-2.0-flash-001',
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
