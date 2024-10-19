import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

  Future<void> _login(BuildContext context) async {
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
        'https://swdsapelearningapi.azurewebsites.net/api/User/login-app',
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
    // Điều hướng trực tiếp đến trang HomePage
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _forgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
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
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Nút Login với Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.g_mobiledata),
                  label: Text('Login with Google'),
                  onPressed: _loginWithGoogle,
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

              // Form nhập thông tin
              Form(
                child: Column(
                  children: [
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
                            _obscureText ? Icons.visibility_off : Icons.visibility,
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
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Quên mật khẩu
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
              SizedBox(height: screenHeight * 0.02),

              // Nút Login
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _login(context),
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xFF275998),
                        foregroundColor: Colors.white,
                      ),
                    ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}