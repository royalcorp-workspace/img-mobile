import 'package:flutter/material.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import '../../../domain/entities/chat_message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  const ChatMessageBubble({super.key, required this.message});

  String get _timeLabel {
    final dt = message.createdAt ?? message.updatedAt ?? DateTime.now();
    final hours = dt.hour.toString().padLeft(2, '0');
    final minutes = dt.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isMe;
    final isPending = message.id.startsWith('temp_');
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_timeLabel, style: timeStyle),
                      if (isPending) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: isUser ? Colors.white70 : Colors.grey,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
