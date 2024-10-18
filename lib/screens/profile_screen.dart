import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String username = 'John Doe'; // Thay thế bằng tên người dùng thực tế hoặc email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      password: 'your_password_here', // Replace with actual password
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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}