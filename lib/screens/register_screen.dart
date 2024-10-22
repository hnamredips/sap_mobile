import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import trang homepage
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signUpWithGoogle() {
   // Xử lý đăng ký với Google
 }

  // Hàm để gọi API đăng ký
  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      try {
        var dio = Dio();
        var response = await dio.post(
          'https://swdsapelearningapi.azurewebsites.net/api/User/registration',
          data: {
            'email': _emailController.text,
            'password': _passwordController.text,
            'confirmPassword': _confirmPasswordController.text
          },
        );

        if (response.statusCode == 200) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('Your account has been created successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        } else {
          _showErrorDialog(context, "Failed to register. Please try again.");
        }
      } catch (e) {
        if (e is DioError && e.response?.statusCode == 400) {
          // Kiểm tra lỗi từ API nếu email đã tồn tại
          _showErrorDialog(context, "Email has already been registered !");
        } else {
          // Hiển thị thông báo lỗi chung
          _showErrorDialog(context, "An error occurred: $e");
        }
      }
    }
  }

  // Hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notification'),
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
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
          'Sign up',
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

                    // Nút đăng ký với Google
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.g_mobiledata),
                        label: Text('Sign Up with Google'),
                        onPressed: _signUpWithGoogle,
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

                    // Form nhập email, mật khẩu
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Your email or username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: _validateEmail,
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
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: _validatePassword,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Điều khoản sử dụng
                    CheckboxListTile(
                      title: Text(
                        'By creating an account, you agree to our Terms & Conditions.',
                      ),
                      value: _agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Đăng nhập (dòng dưới cùng)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Log in",
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
            SizedBox(height: screenHeight * 0.01),
            // Nút Next ở giữa phía dưới
            Center(
              child: ElevatedButton(
                onPressed: () => _register(context), // Gọi API đăng ký
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Color(0xFF275998),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


