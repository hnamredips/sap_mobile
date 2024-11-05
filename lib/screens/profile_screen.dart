import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:sap_mobile/main.dart';
import 'edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUserFullname = '';
  String? currentUserId;
  String currentUserEmail = '';
  String currentUserEducation = '';
  String currentUserPhoneNumber = '';
  String currentUserGender = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('currentUserId');

    if (currentUserId == null) {
      print('User ID không tồn tại. Vui lòng đăng nhập lại.');
      return;
    }

    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/User/get-all-student',
      );

      if (response.statusCode == 200 && response.data.containsKey('\$values')) {
        var users = response.data['\$values'];

        for (var user in users) {
          if (user['id'] == currentUserId) {
            setState(() {
              currentUserFullname = user['fullname'] ?? '';
              currentUserEmail = user['email'] ?? '';
              currentUserEducation = user['education'] ?? '';
              currentUserPhoneNumber = user['phonenumber'] ?? '';
              currentUserGender = user['gender'] ?? '';
            });
            break;
          }
        }
      } else {
        print("Error: Dữ liệu người dùng không hợp lệ.");
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Avatar và Username
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    currentUserFullname.isNotEmpty ? currentUserFullname[0] : '',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  currentUserFullname.length > 18
                      ? '${currentUserFullname.substring(0, 18)}...'
                      : currentUserFullname,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Các mục dẫn đến các trang khác
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      email: currentUserEmail,
                      fullName: currentUserFullname,
                      education: currentUserEducation,
                      phoneNumber: currentUserPhoneNumber,
                      gender: currentUserGender,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('History Purchase'),
              onTap: () {
                // Điều hướng đến trang History Purchase
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                // Điều hướng đến trang Privacy Policy
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                User? user = FirebaseAuth.instance.currentUser;
                bool isGoogleUser = user?.providerData
                        .any((provider) => provider.providerId == 'google.com') ??
                    false;

                if (isGoogleUser) {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                } else {
                  await FirebaseAuth.instance.signOut();
                }

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
