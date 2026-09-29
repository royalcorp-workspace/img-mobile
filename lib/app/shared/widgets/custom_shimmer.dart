import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    // Mengatur durasi keceptan kilatan shimmer
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // Mengulang animasi tanpa henti
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Menggeser posisi gradien berdasarkan nilai animasi
              transform: _SlidingGradientTransform(
                  slidePercent: _animController.value),
              colors: [
                Colors.grey[300]!, // Warna dasar
                Colors.grey[100]!, // Warna kilatan terang (tengah)
                Colors.grey[300]!, // Warna dasar
              ],
              stops: const [0.1, 0.3, 0.4],
            ).createShader(bounds);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.borderRadius,
            ),
          ),
        );
      },
    );
  }
}

// Helper class untuk menggeser matriks posisi gradien secara linear
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
        bounds.width * (slidePercent - 0.5) * 2, 0.0, 0.0);
  }
}
