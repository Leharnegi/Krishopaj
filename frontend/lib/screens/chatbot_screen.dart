import 'dart:async';
import 'package:flutter/material.dart';

/// Port of screens/ChatbotScreen.js
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatMessage {
  final String id;
  final String text;
  final String sender;
  _ChatMessage({required this.id, required this.text, required this.sender});
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_ChatMessage> _messages = [
    _ChatMessage(id: '1', text: '🌱 Hello! I\'m your Farming Assistant. Ask me anything about crops, soil, irrigation, or pests!', sender: 'bot'),
  ];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _getBotReply(String message) {
    final msg = message.toLowerCase();
    if (msg.contains('crop')) {
      return '🌾 You can grow crops like wheat, rice, or maize depending on your soil and season.';
    } else if (msg.contains('fertilizer')) {
      return '🧪 Use organic compost or NPK fertilizers for better yield.';
    } else if (msg.contains('water') || msg.contains('irrigation')) {
      return '💧 Drip irrigation is efficient and saves water.';
    } else if (msg.contains('weather')) {
      return '☁️ Check weather forecasts before sowing to avoid crop damage.';
    } else if (msg.contains('pest')) {
      return '🐛 Use neem oil or organic pesticides to control pests.';
    } else if (msg.contains('soil')) {
      return '🌱 Test your soil to understand nutrient levels and pH balance.';
    } else if (msg.contains('yield')) {
      return '📈 Proper fertilization, irrigation, and pest control increase crop yield.';
    } else {
      return '🤖 I can help with crops, fertilizers, irrigation, soil, pests, and yield. Ask me anything!';
    }
  }

  void _sendMessage() {
    final input = _inputController.text;
    if (input.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), text: input, sender: 'user'));
    });
    _inputController.clear();
    _scrollToBottom();

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(_ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          text: _getBotReply(input),
          sender: 'bot',
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F3),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final item = _messages[index];
                  final isUser = item.sender == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.text,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black, fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Ask about farming...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
