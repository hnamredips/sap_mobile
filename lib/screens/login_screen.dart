import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart'; // Import trang homepage
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện để sử dụng SharedPreferences

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();
  bool _obscureText = true;
  bool _isLoading = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // Nếu người dùng huỷ đăng nhập
      }
      googleUser.authentication.then((googleAuth) async {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = FirebaseAuth.instance.currentUser;

        // Lưu email của người dùng vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentEmail', user?.email ?? '');

        // Lấy ID Token từ Firebase
        final String? idToken = await user?.getIdToken();
        print('Token ne: $idToken'); // Kiểm tra ID Token

        // Thêm ID Token vào header của Dio
        _dio.options.headers['Authorization'] = 'Bearer $idToken';

        // Gọi API với header Authorization chứa ID Token
        var response = await _dio.post(
          'https://swdsapelearningapi.azurewebsites.net/api/User/Login-by-google',
          data: '"$idToken"', // Bao quanh idToken bằng dấu ngoặc kép
        );

        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog(context, "Google Sign-In Failed. Please try again.");
        }
      });
    } catch (e) {
      print(e.toString());
      String errorMessage = 'An unknown error occurred';
      if (e is DioError) {
        errorMessage = 'Error: ${e.message}';
      }
      _showErrorDialog(context, errorMessage);
    }
  }

/////////////////////////////////////
  // Hàm để gọi API đăng nhập bằng email/password
  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please enter both email and password.");
      return;
    }

    try {
      var response = await _dio.post(
        'https://swdsapelearningapi.azurewebsites.net/api/User/login-app',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentEmail', username);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog(context, "Login failed. Incorrect credentials.");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred. Please try again.");
    }
  }

  // Hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Log in',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Nút đăng nhập với Google
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.g_mobiledata),
                        label: Text('Log in with Google'),
                        onPressed: () async => await _loginWithGoogle(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Color(0xFF275998)),
                          foregroundColor: Color(0xFF275998),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Dòng chữ "Or"
                    Text(
                      'Or',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Form nhập thông tin email/password
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Your email or username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Nút đăng nhập
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _login(context),
                            child: Text('Log in'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Color(0xFF275998),
                              foregroundColor: Colors.white,
                            ),
                          ),
                    SizedBox(height: screenHeight * 0.02),

                    // Đăng ký nếu chưa có tài khoản
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}