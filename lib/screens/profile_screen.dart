
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:sap_mobile/main.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện để sử dụng SharedPreferences
import 'package:dio/dio.dart'; // Thêm DIO để gọi API

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUserFullname = ''; // Tên người dùng mặc định
  String? currentUserId; // ID người dùng hiện tại

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Gọi hàm để lấy thông tin người dùng từ API
  }

  // Hàm lấy thông tin người dùng từ API dựa trên currentUserId
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
              currentUserFullname = user['fullname'] ?? 'Unknown User';
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
        margin: EdgeInsets.only(top: 20), // Điều chỉnh khoảng cách từ đỉnh tại đây
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thêm khoảng trống bằng SizedBox để tạo khoảng cách
            SizedBox(height: 20), // Điều chỉnh chiều cao tùy ý

            // Avatar và Username
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    currentUserFullname.isNotEmpty ? currentUserFullname[0] : '', // Chữ cái đầu tiên của fullname
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  currentUserFullname.length > 18 ? '${currentUserFullname.substring(0, 18)}...' : currentUserFullname,
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
                      email: 'john.doe@example.com', // Replace with actual email
                      fullName: 'John Doe', // Replace with actual full name
                      education: 'Bachelor of Science', // Replace with actual education
                      phoneNumber: '123-456-7890', // Replace with actual phone number
                      gender: 'Male',
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
                // Kiểm tra xem người dùng có đăng nhập bằng Google không
                User? user = FirebaseAuth.instance.currentUser;
                bool isGoogleUser = user?.providerData.any((provider) => provider.providerId == 'google.com') ?? false;

                if (isGoogleUser) {
                  // Đăng xuất khỏi tài khoản Google
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                } else {
                  // Đăng xuất khỏi tài khoản thông thường
                  await FirebaseAuth.instance.signOut();
                }

                // Xóa thông tin tạm thời từ SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Chuyển hướng về màn hình đăng nhập sau khi đăng xuất
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
