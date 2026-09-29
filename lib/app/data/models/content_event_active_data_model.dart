import 'package:img/app/domain/entities/content_event_active_data_entity.dart';

class ContentEventActiveDataModel extends ContentEventActiveDataEntity {
  ContentEventActiveDataModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.timezone,
    required super.timezoneName,
    required super.isActive,
    required super.eventType,
    required super.bannerImage,
    required super.bannerImageUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.popups,
  });

  factory ContentEventActiveDataModel.fromJson(Map<String, dynamic> json) =>
      ContentEventActiveDataModel(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        timezone: json["timezone"],
        timezoneName: json["timezone_name"],
        isActive: json["is_active"],
        eventType: json["event_type"],
        bannerImage: json["banner_image"],
        bannerImageUrl: json["banner_image_url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        popups: List<ContentEventActivePopupEntity>.from(json["popups"]
            .map((x) => ContentEventActivePopupModel.fromJson(x))),
      );
}

class ContentEventActivePopupModel extends ContentEventActivePopupEntity {
  ContentEventActivePopupModel({
    required super.id,
    required super.eventId,
    required super.title,
    required super.imageUrl,
    required super.linkUrl,
    required super.buttonText,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ContentEventActivePopupModel.fromJson(Map<String, dynamic> json) =>
      ContentEventActivePopupModel(
        id: json["id"],
        eventId: json["event_id"],
        title: json["title"],
        imageUrl: json["image_url"],
        linkUrl: json["link_url"],
        buttonText: json["button_text"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "title": title,
        "image_url": imageUrl,
        "link_url": linkUrl,
        "button_text": buttonText,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
