import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio(); // Khởi tạo Dio

  void _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Kiểm tra thông tin đăng nhập
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    try {
      // Gọi API để đăng nhập
      final response = await _dio.post(
        'http://localhost:5250/api/User/login-app',
        data: {
          'username': username,
          'password': password,
        },
      );

      // Kiểm tra mã trạng thái
      if (response.statusCode == 200) {
        // Nếu đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacementNamed(
            context, '/home'); // Chuyển đến trang chính
      } else {
        // Nếu đăng nhập không thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed! Try again.')),
        );
      }
    } catch (e) {
      // Xử lý ngoại lệ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect username or password. Try again.')),
      );
    }
  }

  void _loginWithGoogle() {
    // Xử lý đăng nhập với Google
  }

  void _forgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _forgotPassword(context),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
