import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sap_mobile/firebase_options.dart';
import 'package:sap_mobile/screens/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/view_all_material.dart';
import 'screens/schedule_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart'; // Thêm import cho ChangePasswordScreen
import 'screens/message.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';



Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null){
    print("Some notification Received in background...");
  }

}

Future<void> requestNotificationPermission() async {
  // Kiểm tra và yêu cầu quyền thông báo cho Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await PushNotifications.init();

  await PushNotifications.localNotiInit();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  if (message.notification != null) {
    print("Background Notification Tapped");
    navigatorKey.currentState!.pushNamed("/message", arguments: message);
  }
});


  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadData);
    }
  });

  // Lấy FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");



  runApp(MyApp()); // Chạy ứng dụng
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App', // Tên ứng dụng
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Chủ đề chính với màu xanh dương
      ),
      home: MainScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/homepage': (context) => HomePage(),
        '/schedule': (context) => ScheduleScreen(),
        '/profile': (context) => ProfileScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/message': (context) => Messagen(),
        '/edit-profile': (context) => EditProfileScreen(
          email: 'example@example.com',
          fullName: 'John Doe',
          education: 'Bachelor\'s Degree',
          phoneNumber: '123-456-7890',
          gender: 'Male',
        ), // Thêm route cho EditProfileScreen
        '/change-password': (context) => ChangePasswordScreen(), // Thêm route cho ChangePasswordScreen
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hinh anh tren cung
              Spacer(),
              Image.asset(
                'assets/images/saplearn_logo(1).png', // Duong dan hinh anh
                height: 200,
              ),
              SizedBox(height: 20),

              // Tieu de
              Text(
                'Create your own study plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // Mo ta
              Text(
                'Study according to the study plan, make study more motivated',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Spacer(),

              // Sign up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color(0xFF275998), // Mau nen
                    foregroundColor: Color.fromARGB(255, 255, 255, 255), // Sign up color
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Log in button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Log in'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Color(0xFF275998)), // Vien nut Log in
                    foregroundColor: Color(0xFF345894), // Mau chu Log in
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
