import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_royal/app/core/helper/helper.dart';
import 'package:pos_royal/app/core/styles/app_color.dart';
import 'package:pos_royal/app/core/styles/app_text_style.dart';
import 'package:pos_royal/app/core/utils/log/logger.dart';

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final conv = controller.selectedConversation.value;
                    final title = conv != null && conv.subject.isNotEmpty
                        ? conv.subject
                        : 'IMG Assistant';
                    return Text(
                      title,
                      style: AppTextStyle.mediumBlackBold,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
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
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: AppColors.black),
        //     onPressed: () => controller.fetchMessages(),
        //   ),
        // ],
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
            color: Colors.black.withValues(alpha: 0.04),
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
                Text(controller.productByID.value.name ?? '-',
                    style: AppTextStyle.mediumBlackBold),
                const SizedBox(height: 6),
                Text(
                    controller
                            .productByID
                            .value
                            .variants?[controller.selectedIndex.value]
                            .variantName ??
                        '-',
                    style: AppTextStyle.smallGrey),
                const SizedBox(height: 12),
                Text(
                    Helper.formatCurrency(controller
                            .productByID
                            .value
                            .variants?[controller.selectedIndex.value]
                            .finalPrice
                            .toInt() ??
                        0),
                    style: AppTextStyle.largeBlackBold),
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
        if (controller.isLoading.value && controller.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (controller.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 48, color: AppColors.lightGrey),
                const SizedBox(height: 12),
                Text(
                  'Belum ada pesan. Mulai obrolan sekarang!',
                  style: AppTextStyle.mediumGrey,
                ),
              ],
            ),
          );
        }

        logger.info(controller.messages.length);
        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return ChatMessageBubble(message: message);
          },
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error banner (shows when send fails / pending)
          Obx(() {
            if (controller.error.value.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.redContrast,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.error.value,
                      style: AppTextStyle.smallWhite,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.retryPending,
                    child: const Text('Coba lagi',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          }),
          Row(
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
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
        ],
      ),
    );
  }
}
