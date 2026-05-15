import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/ai_service.dart';
import '../core/theme.dart';

class AiHelpController extends GetxController {
  final AiService _aiService = Get.find<AiService>();
  final textController = TextEditingController();
  
  var messages = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    messages.add({'role': 'user', 'content': text});
    
    isLoading.value = true;
    try {
      final response = await _aiService.getMedicalAdvice(text);
      messages.add({'role': 'ai', 'content': response});
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

class AiHelpView extends StatelessWidget {
  const AiHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiHelpController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Pharmacist Help'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppTheme.primaryBlue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['content'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
          if (controller.isLoading.value)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Describe your symptoms...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.primaryBlue),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
