import 'package:get/get.dart';

class Voucher {
  final String image;
  final String title;
  final String description;
  final String titleVoucher;
  final String subtitleVoucher;
  final String codeVoucher;

  Voucher({
    required this.image,
    required this.title,
    required this.description,
    required this.titleVoucher,
    required this.subtitleVoucher,
    required this.codeVoucher,
  });
}

class VoucherController extends GetxController {
  RxInt selectedIndex = 0.obs;

  final List<Voucher> vouchers = [
    Voucher(
      image: 'img_free_ongkir.png',
      title: 'Diskon 10% Semua Produk',
      description: 'Min. belanja Rp. 500.000',
      titleVoucher: 'DISKON BELANJA',
      subtitleVoucher: '10%',
      codeVoucher: 'IMG10OFF',
    ),
    Voucher(
      image: 'img_discount.png',
      title: 'Gratis Ongkir',
      description: 'Min. belanja Rp. 300.000',
      titleVoucher: 'GRATIS ONGKIR',
      subtitleVoucher: '',
      codeVoucher: 'IMGFREESHIP',
    ),
    // Add more dummy vouchers as needed for testing large lists.
  ];
}
