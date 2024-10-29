import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Thêm import cho RemoteMessage nếu cần

class Messagen extends StatefulWidget {
  const Messagen({super.key});

  @override
  State<Messagen> createState() => _MessagenState();
}

class _MessagenState extends State<Messagen> {
  Map<String, dynamic> payload = {}; // Khai báo và khởi tạo payload

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
   
    if (data is RemoteMessage) {
      payload = data.data;
    }

    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Your Message")),
      body: Center(
        child: Text(payload.toString()),
      ),
    );
  }
}
