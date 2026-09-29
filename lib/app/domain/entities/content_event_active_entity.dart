import 'package:img/app/domain/entities/content_event_active_data_entity.dart';

class ContentEventActiveEntity {
  final bool success;
  final String serverTime;
  final String timezone;
  final String timezoneName;
  final List<ContentEventActiveDataEntity> data;

  ContentEventActiveEntity({
    required this.success,
    required this.serverTime,
    required this.timezone,
    required this.timezoneName,
    required this.data,
  });
}
