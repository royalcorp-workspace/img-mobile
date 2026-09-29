class ContentEventActiveDataEntity {
  final String id;
  final String title;
  final String slug;
  final dynamic description;
  final String startDate;
  final String endDate;
  final String timezone;
  final String timezoneName;
  final bool isActive;
  final String eventType;
  final String bannerImage;
  final String bannerImageUrl;
  final String createdAt;
  final String updatedAt;
  final List<ContentEventActivePopupEntity> popups;

  ContentEventActiveDataEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.timezone,
    required this.timezoneName,
    required this.isActive,
    required this.eventType,
    required this.bannerImage,
    required this.bannerImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.popups,
  });
}

class ContentEventActivePopupEntity {
  final String id;
  final String eventId;
  final String title;
  final dynamic imageUrl;
  final dynamic linkUrl;
  final String buttonText;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  ContentEventActivePopupEntity({
    required this.id,
    required this.eventId,
    required this.title,
    required this.imageUrl,
    required this.linkUrl,
    required this.buttonText,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
