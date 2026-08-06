import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

import '../models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageBubble({super.key, required this.message});

  String get _timeLabel {
    final hours = message.timestamp.hour.toString().padLeft(2, '0');
    final minutes = message.timestamp.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final backgroundColor =
        isUser ? AppColors.primaryColor : AppColors.greyWhite;
    final textStyle =
        isUser ? AppTextStyle.mediumWhite : AppTextStyle.mediumBlack;
    final timeStyle =
        isUser ? AppTextStyle.xSmallWhite : AppTextStyle.xSmallGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.text, style: textStyle),
                  const SizedBox(height: 6),
                  Text(_timeLabel, style: timeStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
