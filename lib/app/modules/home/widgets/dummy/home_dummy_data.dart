import 'package:flutter/material.dart';

class ShortcutItemModel {
  final String id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const ShortcutItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}

class HomeDummyData {
  /// Temporary dummy data for Shortcut items
  /// TODO: Replace with real Shortcut API data when available.
  static const List<ShortcutItemModel> shortcuts = [
    ShortcutItemModel(
      id: 'best_seller',
      title: 'Best Seller',
      icon: Icons.local_fire_department_rounded,
      iconColor: Color(0xFFE53935),
      backgroundColor: Color(0xFFFFF0ED),
      borderColor: Color(0xFFFFDCD4),
    ),
    ShortcutItemModel(
      id: 'promo',
      title: 'Promo',
      icon: Icons.percent_rounded,
      iconColor: Color(0xFFD81B60),
      backgroundColor: Color(0xFFFFF0F3),
      borderColor: Color(0xFFFFD4DC),
    ),
    ShortcutItemModel(
      id: 'top_rated',
      title: 'Top Rated',
      icon: Icons.star_rounded,
      iconColor: Color(0xFF1E88E5),
      backgroundColor: Color(0xFFEEF5FF),
      borderColor: Color(0xFFD4E5FF),
    ),
    ShortcutItemModel(
      id: 'new_arrival',
      title: 'New Arrival',
      icon: Icons.auto_awesome_rounded,
      iconColor: Color(0xFF8E24AA),
      backgroundColor: Color(0xFFF7F0FF),
      borderColor: Color(0xFFE9D8FF),
    ),
  ];

  /// Temporary promo campaign brands for Promo Banner
  static const List<String> promoBrands = [
    'in.the.box',
    'dreamstar',
    'Serta',
    'Comforta',
  ];
}
