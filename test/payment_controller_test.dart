import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_royal/app/domain/entities/checkout_entity.dart';
import 'package:pos_royal/app/modules/payment/controllers/payment_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PaymentController countdown', () {
    test('startTimer decreases remaining time until expiry', () async {
      final controller = PaymentController();
      final futureExpiry = DateTime.now().add(const Duration(seconds: 10));
      controller.checkoutResult = CheckoutEntity(
        vaExpired:
            '${futureExpiry.year}-${futureExpiry.month.toString().padLeft(2, '0')}-${futureExpiry.day.toString().padLeft(2, '0')} ${futureExpiry.hour.toString().padLeft(2, '0')}:${futureExpiry.minute.toString().padLeft(2, '0')}:${futureExpiry.second.toString().padLeft(2, '0')}',
      );

      controller.startTimer();
      final initialValue = controller.start.value;

      await Future<void>.delayed(const Duration(seconds: 2));

      expect(initialValue, greaterThan(0));
      expect(controller.start.value, lessThan(initialValue));

      controller.onClose();
    });
  });
}
