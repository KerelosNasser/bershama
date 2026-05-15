import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/ai_service.dart';
import '../core/theme.dart';

class AiHelpController extends GetxController {
  final AiService _aiService = Get.find<AiService>();
  final textController = TextEditingController();
  final scrollController = ScrollController();
  
  var messages = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial greeting
    messages.add({
      'role': 'ai', 
      'content': 'Hello! I am your **Bershama AI Pharmacist**. Describe the symptoms or ask about specific medication interactions. How can I assist you today?'
    });
  }

  void sendMessage({String? customText}) async {
    final text = customText ?? textController.text.trim();
    if (text.isEmpty) return;

    if (customText == null) textController.clear();
    messages.add({'role': 'user', 'content': text});
    _scrollToBottom();
    
    isLoading.value = true;
    try {
      final response = await _aiService.getMedicalAdvice(text);
      messages.add({'role': 'ai', 'content': response});
      _scrollToBottom();
    } finally {
      isLoading.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

class AiHelpView extends StatelessWidget {
  const AiHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiHelpController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('AI Pharmacist Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isUser = message['role'] == 'user';
                return _buildChatBubble(message['content'] ?? '', isUser);
              },
            )),
          ),
          _buildQuickPrompts(controller),
          _buildInputArea(controller),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String content, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isUser 
          ? Text(content, style: const TextStyle(color: Colors.white, fontSize: 15))
          : MarkdownBody(
              data: content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                h3: const TextStyle(color: AppTheme.primaryBlue, fontSize: 16, fontWeight: FontWeight.bold),
                listBullet: const TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildQuickPrompts(AiHelpController controller) {
    final prompts = ['Common Cold 🤒', 'Stomach Pain 🤢', 'Safety Check 🛡️'];
    return Obx(() {
      if (controller.isLoading.value) return const SizedBox.shrink();
      return Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(prompts[index]),
                backgroundColor: Colors.white,
                side: BorderSide(color: AppTheme.primaryBlue.withOpacity(0.2)),
                onPressed: () => controller.sendMessage(customText: prompts[index]),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildInputArea(AiHelpController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  hintText: 'Type symptoms or questions...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: controller.isLoading.value
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: controller.sendMessage,
                  ),
            )),
          ],
        ),
      ),
    );
  }
}
