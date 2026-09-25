import 'package:flutter/material.dart';

class DetailProductCard extends StatelessWidget {
  const DetailProductCard({
    super.key,
    required this.widgetKey,
    required this.imageUrls,
    this.pageController,
  });

  final GlobalKey widgetKey;
  final List<String> imageUrls;
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    final images = imageUrls.where((url) => url.isNotEmpty).toList();
    final galleryHeight = MediaQuery.sizeOf(context).width * 1;

    return SizedBox(
      key: widgetKey,
      width: double.infinity,
      height: galleryHeight,
      child: PageView.builder(
        controller: pageController,
        itemCount: images.isEmpty ? 1 : images.length,
        itemBuilder: (context, index) {
          final imageUrl = images.isEmpty ? '' : images[index];
          return ColoredBox(
            color: Colors.white,
            child: Image(
              image: imageUrl.startsWith('http://') ||
                      imageUrl.startsWith('https://')
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/img_product1.jpg'),
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
