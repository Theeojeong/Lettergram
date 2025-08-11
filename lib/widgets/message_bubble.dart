import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String body;
  final String timestamp;
  final String sender;

  const MessageBubble({
    super.key,
    required this.body,
    required this.timestamp,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF003366)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.blueAccent, blurRadius: 2, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Text(timestamp, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(sender, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
