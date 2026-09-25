import 'package:img/app/domain/entities/content_banner_entity.dart';

class ContentBannerModel extends ContentBannerEntity {
  ContentBannerModel({
    required super.createdAt,
    required super.updatedAt,
    required super.deleted,
    required super.id,
    required super.title,
    required super.linkUrl,
    required super.isActive,
    required super.sortOrder,
    required super.type,
    required super.deviceFlag,
    required super.placementSize,
    required super.contentType,
    required super.imageWebUrl,
    required super.imageMobileUrl,
    required super.embedWebContent,
    required super.embedMobileContent,
    required super.targetType,
    required super.targetId,
  });

  factory ContentBannerModel.fromJson(Map<String, dynamic> json) =>
      ContentBannerModel(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deleted: json["deleted"],
        id: json["id"],
        title: json["title"],
        linkUrl: json["link_url"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
        type: json["type"],
        deviceFlag: json["device_flag"],
        placementSize: json["placement_size"],
        contentType: json["content_type"],
        imageWebUrl: json["image_web_url"],
        imageMobileUrl: json["image_mobile_url"],
        embedWebContent: json["embed_web_content"],
        embedMobileContent: json["embed_mobile_content"],
        targetType: json["target_type"],
        targetId: json["target_id"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted": deleted,
        "id": id,
        "title": title,
        "link_url": linkUrl,
        "is_active": isActive,
        "sort_order": sortOrder,
        "type": type,
        "device_flag": deviceFlag,
        "placement_size": placementSize,
        "content_type": contentType,
        "image_web_url": imageWebUrl,
        "image_mobile_url": imageMobileUrl,
        "embed_web_content": embedWebContent,
        "embed_mobile_content": embedMobileContent,
        "target_type": targetType,
        "target_id": targetId,
      };
}
