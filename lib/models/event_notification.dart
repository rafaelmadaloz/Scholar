//import 'package:app_tcc/models/event.dart';
//
//class EventNotification {
//  final Event event;
//  final DateTime createdAt;
//
//  EventNotification({
//    this.event,
//    this.createdAt,
//  });
//}

library event_notification;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'event.dart';
import 'serializers.dart';

part 'event_notification.g.dart';

abstract class EventNotification implements Built<EventNotification, EventNotificationBuilder> {

  Event get event;

  EventNotification._();

  factory EventNotification([updates(EventNotificationBuilder b)]) = _$EventNotification;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(EventNotification.serializer, this);
  }

  static EventNotification fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(EventNotification.serializer, json);
  }

  static Serializer<EventNotification> get serializer => _$eventNotificationSerializer;

}