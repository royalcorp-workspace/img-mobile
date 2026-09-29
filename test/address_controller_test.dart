import 'package:flutter_test/flutter_test.dart';
import 'package:img/app/data/models/address_model.dart';
import 'package:img/app/data/models/checkout_model.dart';
import 'package:img/app/data/models/variant_model.dart';
import 'package:img/app/domain/entities/order_entity.dart';
import 'package:img/app/modules/address/controllers/address_controller.dart';

void main() {
  test('applyPrimarySelection marks only the selected address as primary', () {
    final controller = AddressController();

    final addresses = [
      AddressModel(id: 'a', isPrimary: true),
      AddressModel(id: 'b', isPrimary: false),
      AddressModel(id: 'c', isPrimary: false),
    ];

    final updated = controller.applyPrimarySelection(addresses, 'b');

    expect(updated.first.id, 'b');
    expect(updated[0].isPrimary, isTrue);
    expect(updated[1].isPrimary, isFalse);
    expect(updated[2].isPrimary, isFalse);
  });

  test(
      'reorderPrimaryAddressFirst moves selected primary address to the first index',
      () {
    final controller = AddressController();

    final addresses = [
      AddressModel(id: 'a', isPrimary: false),
      AddressModel(id: 'b', isPrimary: false),
      AddressModel(id: 'c', isPrimary: true),
    ];

    final updated = controller.reorderPrimaryAddressFirst(addresses, 'c');

    expect(updated.first.id, 'c');
    expect(updated.first.isPrimary, isTrue);
    expect(updated.map((address) => address.id).toList(), ['c', 'a', 'b']);
  });

  test('ItemParams serializes ProductVariantModel without throwing', () {
    final variant = VariantModel(
      id: 'v-1',
      productId: 'p-1',
      sku: 'SKU-1',
      variantName: 'Size M',
      price: 150000,
      finalPrice: 150000,
      stockQty: 10,
      width: 10,
      length: 20,
      height: 5,
      weight: 100,
      status: true,
      priceProductSettings: const [],
    );

    final item = ItemParams(
      productId: 'p-1',
      productVariantId: 'v-1',
      name: 'Test Product',
      quantity: 1,
      unitPrice: 150000,
      total: 150000,
      variant: variant,
    );

    final json = item.toJson();

    expect(json['variant']['id'], 'v-1');
    expect(json['variant']['product_id'], 'p-1');
    expect(json['variant']['variant_name'], 'Size M');
  });

  test('PaymentModel.fromJson accepts double numeric amount values', () {
    final payment = PaymentModel.fromJson({
      'rq_uuid': 'req-1',
      'rs_datetime': '2026-09-02 11:46:17',
      'error_code': '0000',
      'error_message': '',
      'va_number': '4490555396870648',
      'expired': '2026-09-03 11:46:10',
      'description': 'Tagihan No',
      'total_amount': '10000.00',
      'amount': 10000.0,
      'fee': '0.00',
      'bank_code': '014',
      'order_id': 'o-1',
      'order_number': 'ORD-1',
      'payment_method': 'BCAATM',
      'bank_name': 'BCA VA Online',
      'type': 2,
      'type_name': 'Merchant',
      'status': 'pending',
      'reference': 'PAY-1',
      'payment_url': '',
      'cara_bayar': ['Pilih metode pembayaran'],
      'payment_method_detail': {
        'id': 'pm-1',
        'code': 'BCAATM',
        'name': 'BCA VA Online',
        'type': 2,
        'type_name': 'Merchant',
        'bank_name': 'BCA VA Online',
        'provider': 'espay',
        'image': null,
        'has_charge': false,
        'charge_type': 2,
        'charge_value': 0.0,
        'charge_bearer': null,
        'minimum_amount': null,
        'maximum_amount': null,
        'bank_info': {'bank_code': '014'},
        'cara_bayar': ['Pilih metode pembayaran'],
      },
    });

    expect(payment.amount, 10000.0);
    expect(payment.paymentMethodDetail.chargeValue, 0.0);
  });
}
