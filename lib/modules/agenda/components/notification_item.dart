import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final EventNotification notification;
  final void Function(EventNotification) onIgnore;
  final void Function(EventNotification) onAccept;

  const NotificationItem({
    Key key,
    @required this.notification,
    this.onIgnore,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListTile(
              title: Text(Strings.newEvent(notification.event.type)),
              subtitle: Text(Strings.notificationSubtitle(notification.event)),
            ),
          ),
          Expanded(
            child: ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(Strings.rejectNotification),
                    onPressed: () => onIgnore(notification),
                  ),
                  FlatButton(
                    child: Text(Strings.acceptNotification),
                    onPressed: () => onAccept(notification),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
