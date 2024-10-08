import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/model/notification/notification.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key, required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(notifications[index].msg!)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${notifications[index].dateTime}'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, _) {
            return const Divider(
              color: Colors.grey,
              thickness: 2,
            );
          },
          itemCount: notifications.length),
    );
  }
}
