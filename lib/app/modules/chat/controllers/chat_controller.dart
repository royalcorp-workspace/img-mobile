import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_message.dart';

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final draft = ''.obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    messages.assignAll([
      ChatMessage(
        text:
            'Halo, selamat datang di IMG Official Store. Ada yang bisa kami bantu?',
        sender: ChatSender.store,
      ),
    ]);
  }

  void onDraftChanged(String value) {
    draft.value = value;
  }

  void sendMessage() {
    final trimmed = draft.value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    messages.add(ChatMessage(text: trimmed, sender: ChatSender.user));
    draft.value = '';
    textController.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add(
        ChatMessage(
          text:
              'Terima kasih! Produk ready stock untuk ukuran 180x200. Silakan klik tombol di bawah untuk melanjutkan.',
          sender: ChatSender.store,
        ),
      );
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
