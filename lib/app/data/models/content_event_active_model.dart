import 'package:img/app/data/models/content_event_active_data_model.dart';
import 'package:img/app/domain/entities/content_event_active_entity.dart';

class ContentEventActiveModel extends ContentEventActiveEntity {
  ContentEventActiveModel({
    required super.success,
    required super.serverTime,
    required super.timezone,
    required super.timezoneName,
    required super.data,
  });

  factory ContentEventActiveModel.fromJson(Map<String, dynamic> json) =>
      ContentEventActiveModel(
        success: json["success"],
        serverTime: json["server_time"],
        timezone: json["timezone"],
        timezoneName: json["timezone_name"],
        data: List<ContentEventActiveDataModel>.from(
            json["data"].map((x) => ContentEventActiveDataModel.fromJson(x))),
      );
}
