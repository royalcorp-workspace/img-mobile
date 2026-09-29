class ContentBannerEntity {
  final String createdAt;
  final String updatedAt;
  final bool deleted;
  final String id;
  final String title;
  final dynamic linkUrl;
  final bool isActive;
  final int sortOrder;
  final int type;
  final int deviceFlag;
  final int placementSize;
  final int contentType;
  final dynamic imageWebUrl;
  final dynamic imageMobileUrl;
  final dynamic embedWebContent;
  final dynamic embedMobileContent;
  final dynamic targetType;
  final dynamic targetId;

  ContentBannerEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.id,
    required this.title,
    required this.linkUrl,
    required this.isActive,
    required this.sortOrder,
    required this.type,
    required this.deviceFlag,
    required this.placementSize,
    required this.contentType,
    required this.imageWebUrl,
    required this.imageMobileUrl,
    required this.embedWebContent,
    required this.embedMobileContent,
    required this.targetType,
    required this.targetId,
  });
}
