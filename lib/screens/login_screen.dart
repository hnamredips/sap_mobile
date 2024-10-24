// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'home_page.dart'; // Import trang homepage
// import 'login_screen.dart';


// class RegisterScreen extends StatefulWidget {
//  @override
//  _RegisterScreenState createState() => _RegisterScreenState();
// }


// class _RegisterScreenState extends State<RegisterScreen> {
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final TextEditingController _confirmPasswordController = TextEditingController();


//  final _formKey = GlobalKey<FormState>();
//  bool _agreeToTerms = false;
//  bool _obscurePassword = true;
//  bool _obscureConfirmPassword = true;


//  final GoogleSignIn _googleSignIn = GoogleSignIn(
//    scopes: ['email'],
//  );


//  // Hàm để gọi API đăng ký với Google
//  Future<void> _signUpWithGoogle(BuildContext context) async {
//    try {
//      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//      if (googleUser == null) {
//        // Người dùng đã hủy đăng nhập
//        return;
//      }


//      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//      final String? idToken = googleAuth.idToken;


//      var dio = Dio();
//      var response = await dio.post(
//        'https://swdsapelearningapi.azurewebsites.net/api/auth/google-auth/signin',
//        data: {
//          'idToken': idToken,
//        },
//      );


//      if (response.statusCode == 200) {
//        showDialog(
//          context: context,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              title: Text('Google Sign-In Successful'),
//              content: Text('You have signed in with Google successfully.'),
//              actions: [
//                TextButton(
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(builder: (context) => HomePage()),
//                    );
//                  },
//                  child: Text('OK'),
//                ),
//              ],
//            );
//          },
//        );
//      } else {
//        showDialog(
//          context: context,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              title: Text('Google Sign-In Failed'),
//              content: Text('An error occurred: ${response.statusMessage}'),
//              actions: [
//                TextButton(
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                  child: Text('OK'),
//                ),
//              ],
//            );
//          },
//        );
//      }
//    } catch (e) {
//      String errorMessage = 'An unknown error occurred';
//      if (e is DioError) {
//        if (e.response != null) {
//          errorMessage = 'Error: ${e.response?.statusMessage}';
//        } else {
//          errorMessage = 'Error: ${e.message}';
//        }
//      }
//      showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text('Error'),
//            content: Text(errorMessage),
//            actions: [
//              TextButton(
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//                child: Text('OK'),
//              ),
//            ],
//          );
//        },
//      );
//    }
//  }


//  // Hàm để gọi API đăng ký
//  Future<void> _register(BuildContext context) async {
//    if (_formKey.currentState!.validate() && _agreeToTerms) {
//      try {
//        var dio = Dio();
//        var response = await dio.post(
//          'https://swdsapelearningapi.azurewebsites.net/api/User/registration',
//          data: {
//            'email': _emailController.text,
//            'password': _passwordController.text,
//            'confirmPassword': _confirmPasswordController.text
//          },
//        );


//        if (response.statusCode == 200) {
//          showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text('Registration Successful'),
//                content: Text('Your account has been created successfully.'),
//                actions: [
//                  TextButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(builder: (context) => LoginScreen()),
//                      );
//                    },
//                    child: Text('OK'),
//                  ),
//                ],
//              );
//            },
//          );
//        } else {
//          _showErrorDialog(context, "Failed to register. Please try again.");
//        }
//      } catch (e) {
//        if (e is DioError && e.response?.statusCode == 400) {
//          // Kiểm tra lỗi từ API nếu email đã tồn tại
//          _showErrorDialog(context, "Email has already been registered !");
//        } else {
//          // Hiển thị thông báo lỗi chung
//          _showErrorDialog(context, "An error occurred: $e");
//        }
//      }
//    }
//  }


//  // Hiển thị dialog lỗi
//  void _showErrorDialog(BuildContext context, String message) {
//    showDialog(
//      context: context,
//      builder: (context) {
//        return AlertDialog(
//          title: Text('Notification'),
//          content: Text(message),
//          actions: [
//            TextButton(
//              onPressed: () {
//                Navigator.pop(context);
//              },
//              child: Text('OK'),
//            ),
//          ],
//        );
//      },
//    );
//  }


//  String? _validateEmail(String? value) {
//    if (value == null || value.isEmpty) {
//      return 'Please enter your email';
//    }
//    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//    if (!emailRegExp.hasMatch(value)) {
//      return 'Please enter a valid email';
//    }
//    return null;
//  }


//  String? _validatePassword(String? value) {
//    if (value == null || value.isEmpty) {
//      return 'Please enter your password';
//    }
//    if (value.length < 8) {
//      return 'Password must be at least 8 characters';
//    }
//    return null;
//  }


//  @override
//  Widget build(BuildContext context) {
//    final double screenHeight = MediaQuery.of(context).size.height;


//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Colors.black),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        centerTitle: true,
//        title: Text(
//          'Sign up',
//          style: TextStyle(
//            color: Colors.black,
//            fontSize: 24,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//      ),
//      body: SafeArea(
//        child: Column(
//          children: [
//            Expanded(
//              child: SingleChildScrollView(
//                padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                child: Column(
//                  children: [
//                    SizedBox(height: screenHeight * 0.02),


//                    // Nút đăng ký với Google
//                    SizedBox(
//                      width: double.infinity,
//                      child: OutlinedButton.icon(
//                        icon: Icon(Icons.g_mobiledata),
//                        label: Text('Sign Up with Google'),
//                        onPressed: () => _signUpWithGoogle(context),
//                        style: OutlinedButton.styleFrom(
//                          padding: EdgeInsets.symmetric(vertical: 16),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(12),
//                          ),
//                          side: BorderSide(color: Color(0xFF275998)),
//                          foregroundColor: Color(0xFF275998),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: screenHeight * 0.02),


//                    // Dòng chữ "Or"
//                    Text(
//                      'Or',
//                      style: TextStyle(fontSize: 16, color: Colors.grey),
//                    ),
//                    SizedBox(height: screenHeight * 0.02),


//                    // Form nhập email, mật khẩu
//                    Form(
//                      key: _formKey,
//                      child: Column(
//                        children: [
//                          TextFormField(
//                            controller: _emailController,
//                            decoration: InputDecoration(
//                              labelText: 'Your email or username',
//                              border: OutlineInputBorder(
//                                borderRadius: BorderRadius.circular(12),
//                              ),
//                            ),
//                            validator: _validateEmail,
//                          ),
//                          SizedBox(height: screenHeight * 0.02),
//                          TextFormField(
//                            controller: _passwordController,
//                            decoration: InputDecoration(
//                              labelText: 'Password',
//                              border: OutlineInputBorder(
//                                borderRadius: BorderRadius.circular(12),
//                              ),
//                              suffixIcon: IconButton(
//                                icon: Icon(
//                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                ),
//                                onPressed: () {
//                                  setState(() {
//                                    _obscurePassword = !_obscurePassword;
//                                  });
//                                },
//                              ),
//                            ),
//                            obscureText: _obscurePassword,
//                            validator: _validatePassword,
//                          ),
//                          SizedBox(height: screenHeight * 0.02),
//                          TextFormField(
//                            controller: _confirmPasswordController,
//                            decoration: InputDecoration(
//                              labelText: 'Confirm Password',
//                              border: OutlineInputBorder(
//                                borderRadius: BorderRadius.circular(12),
//                              ),
//                              suffixIcon: IconButton(
//                                icon: Icon(
//                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                                ),
//                                onPressed: () {
//                                  setState(() {
//                                    _obscureConfirmPassword = !_obscureConfirmPassword;
//                                  });
//                                },
//                              ),
//                            ),
//                            obscureText: _obscureConfirmPassword,
//                            validator: (value) {
//                              if (value == null || value.isEmpty) {
//                                return 'Please confirm your password';
//                              }
//                              if (value != _passwordController.text) {
//                                return 'Passwords do not match';
//                              }
//                              return null;
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(height: screenHeight * 0.02),


//                    // Điều khoản sử dụng
//                    CheckboxListTile(
//                      title: Text(
//                        'By creating an account, you agree to our Terms & Conditions.',
//                      ),
//                      value: _agreeToTerms,
//                      onChanged: (bool? value) {
//                        setState(() {
//                          _agreeToTerms = value ?? false;
//                        });
//                      },
//                      controlAffinity: ListTileControlAffinity.leading,
//                    ),
//                    SizedBox(height: screenHeight * 0.02),


//                    // Đăng nhập (dòng dưới cùng)
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        Text(
//                          "Already have an account? ",
//                          style: TextStyle(color: Colors.black),
//                        ),
//                        GestureDetector(
//                          onTap: () {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => LoginScreen()),
//                            );
//                          },
//                          child: Text(
//                            "Log in",
//                            style: TextStyle(
//                              color: Colors.blue,
//                              decoration: TextDecoration.underline,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//            SizedBox(height: screenHeight * 0.01),
//            // Nút Next ở giữa phía dưới
//            Center(
//              child: ElevatedButton(
//                onPressed: () => _register(context), // Gọi API đăng ký
//                child: Text('Register'),
//                style: ElevatedButton.styleFrom(
//                  minimumSize: Size(120, 50),
//                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(20),
//                  ),
//                  backgroundColor: Color(0xFF275998),
//                  foregroundColor: Colors.white,
//                ),
//              ),
//            ),
//            SizedBox(height: 40),
//          ],
//        ),
//      ),
//    );
//  }
// }


import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart'; // Import trang homepage

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

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '575550351850-ktdi1a5amhfospkj3ohrkdqdejrkords.apps.googleusercontent.com',
  scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
);


  // Hàm để gọi API đăng nhập với Google
  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('AAA');
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      print('abc' + idToken.toString());

      var dio = Dio();
      var response = await dio.post(
        'https://swdsapelearningapi.azurewebsites.net/api/auth/google-auth/signin',
        data: {
          'idToken': idToken,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Google Sign-In Successful'),
              content: Text('You have signed in with Google successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog(context, "Google Sign-In Failed. Please try again.");
      }
    } catch (e) {
      print(e.toString());
      String errorMessage = 'An unknown error occurred';
      if (e is DioError) {
        errorMessage = 'Error: ${e.message}';
      }
      _showErrorDialog(context, errorMessage);
    }
  }

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
