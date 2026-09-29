import 'package:flutter/material.dart';
import 'package:img/app/domain/entities/product_tag_entity.dart';

class TagTheme {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const TagTheme({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  static TagTheme fromTag(ProductTagEntity tag, int index) {
    final slug = tag.slug.toLowerCase();
    final name = tag.name.toLowerCase();

    if (slug.contains('best') || name.contains('best')) {
      return const TagTheme(
        icon: Icons.local_fire_department_rounded,
        iconColor: Color(0xFFE53935),
        backgroundColor: Color(0xFFFFF0ED),
        borderColor: Color(0xFFFFDCD4),
      );
    } else if (slug.contains('new') || name.contains('new')) {
      return const TagTheme(
        icon: Icons.auto_awesome_rounded,
        iconColor: Color(0xFF8E24AA),
        backgroundColor: Color(0xFFF7F0FF),
        borderColor: Color(0xFFE9D8FF),
      );
    } else if (slug.contains('promo') || name.contains('promo')) {
      return const TagTheme(
        icon: Icons.percent_rounded,
        iconColor: Color(0xFFD81B60),
        backgroundColor: Color(0xFFFFF0F3),
        borderColor: Color(0xFFFFD4DC),
      );
    } else if (slug.contains('sale') || name.contains('sale')) {
      return const TagTheme(
        icon: Icons.local_offer_rounded,
        iconColor: Color(0xFFFB8C00),
        backgroundColor: Color(0xFFFFF3E0),
        borderColor: Color(0xFFFFE0B2),
      );
    } else if (slug.contains('cuci') ||
        name.contains('cuci') ||
        slug.contains('gudang')) {
      return const TagTheme(
        icon: Icons.inventory_2_rounded,
        iconColor: Color(0xFF00897B),
        backgroundColor: Color(0xFFE0F2F1),
        borderColor: Color(0xFFB2DFDB),
      );
    }

    final defaultThemes = [
      const TagTheme(
        icon: Icons.stars_rounded,
        iconColor: Color(0xFF1E88E5),
        backgroundColor: Color(0xFFEEF5FF),
        borderColor: Color(0xFFD4E5FF),
      ),
      const TagTheme(
        icon: Icons.label_rounded,
        iconColor: Color(0xFF43A047),
        backgroundColor: Color(0xFFE8F5E9),
        borderColor: Color(0xFFC8E6C9),
      ),
    ];
    return defaultThemes[index % defaultThemes.length];
  }
}
