import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';

import '../controllers/chat_controller.dart';
import '../widgets/chat_message_bubble.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: Get.back,
        ),
        title: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.greyWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  Helper.getImagePath('img_logo.webp'),
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IMG Assistant', style: AppTextStyle.mediumBlackBold),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Online', style: AppTextStyle.smallGrey),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProductPreview(),
            const Divider(height: 1, color: AppColors.lightGrey),
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              Helper.getImagePath('img_product1.jpg'),
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kasur Orthopedic Spring Bed Premium',
                    style: AppTextStyle.mediumBlackBold),
                const SizedBox(height: 6),
                Text('180x200', style: AppTextStyle.smallGrey),
                const SizedBox(height: 12),
                Text('Rp 4.250.000', style: AppTextStyle.largeBlackBold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(
      () {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final reversedIndex = controller.messages.length - index - 1;
            final message = controller.messages[reversedIndex];
            return ChatMessageBubble(message: message);
          },
          reverse: true,
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.greyWhite,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: controller.textController,
                onChanged: controller.onDraftChanged,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  hintStyle: AppTextStyle.mediumGrey,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                style: AppTextStyle.mediumBlack,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.send,
                color: controller.draft.value.trim().isEmpty
                    ? AppColors.lightGrey
                    : AppColors.primaryColor,
              ),
              onPressed: controller.draft.value.trim().isEmpty
                  ? null
                  : controller.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
