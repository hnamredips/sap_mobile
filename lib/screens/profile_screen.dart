import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:sap_mobile/main.dart';
import 'package:sap_mobile/screens/payment.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';



class ProfileScreen extends StatelessWidget {
  final String username = 'John Doe'; // Thay thế bằng tên người dùng thực tế hoặc email

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
                    username[0], // Chữ cái đầu tiên của Username
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  username,
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
