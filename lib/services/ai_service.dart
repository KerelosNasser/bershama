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
            'content': '''You are "Bershama AI", a professional clinical pharmacist assistant. 
            Your goal is to assist pharmacists in diagnosing symptoms and suggesting appropriate medications.
            
            GUIDELINES:
            1. Always provide the Generic Name and a few Brand Name examples.
            2. Detail the Mechanism of Action briefly.
            3. Provide standard Dosage for adults and children.
            4. IMPORTANT: List critical Contraindications and side effects.
            5. SAFETY: If symptoms sound like a medical emergency (chest pain, severe bleeding, etc.), immediately advise calling emergency services (123 in Egypt).
            6. FORMAT: Use clear markdown with headers and bullet points.
            7. DISCLAIMER: Always end with: "This is an AI suggestion. Final clinical decision must be made by a licensed pharmacist or physician."'''
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
