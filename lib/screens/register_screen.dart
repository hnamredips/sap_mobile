



// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'home_page.dart'; // Import trang homepage
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   void _signUpWithGoogle() {
//     // Xử lý đăng ký với Google
//   }

//   // Hàm để gọi API đăng ký
//   Future<void> _register(BuildContext context) async {
//     if (_formKey.currentState!.validate() && _agreeToTerms) {
//       try {
//         var dio = Dio();
//         var response = await dio.post(
//           'https://swdsapelearningapi.azurewebsites.net/api/User/registration',
//           data: {
//             'email': _emailController.text,
//             'password': _passwordController.text,
//             'confirmPassword': _confirmPasswordController.text
//           },
//         );
//         if (response.statusCode == 200) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Registration Successful'),
//                 content: Text('Your account has been created successfully.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           _showErrorDialog(context, "Failed to register. Please try again.");
//         }
//       } catch (e) {
//         if (e is DioError && e.response?.statusCode == 400) {
//           _showErrorDialog(context, "Email has already been registered!");
//         } else {
//           _showErrorDialog(context, "An error occurred: $e");
//         }
//       }
//     }
//   }

//   // Hiển thị dialog lỗi
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Notification'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//     if (!emailRegExp.hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           'Sign up',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     // Nút đăng ký với Google
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton.icon(
//                         icon: Icon(Icons.g_mobiledata),
//                         label: Text('Sign Up with Google'),
//                         onPressed: _signUpWithGoogle,
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Color(0xFF275998)),
//                           foregroundColor: Color(0xFF275998),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Dòng chữ "Or"
//                     Text(
//                       'Or',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Form nhập email, mật khẩu
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               labelText: 'Your email or username',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             validator: _validateEmail,
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           TextFormField(
//                             controller: _passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                             ),
//                             obscureText: _obscurePassword,
//                             validator: _validatePassword,
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             decoration: InputDecoration(
//                               labelText: 'Confirm Password',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscureConfirmPassword = !_obscureConfirmPassword;
//                                   });
//                                 },
//                               ),
//                             ),
//                             obscureText: _obscureConfirmPassword,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Điều khoản sử dụng
//                     CheckboxListTile(
//                       title: Text(
//                         'By creating an account, you agree to our Terms & Conditions.',
//                       ),
//                       value: _agreeToTerms,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           _agreeToTerms = value ?? false;
//                         });
//                       },
//                       controlAffinity: ListTileControlAffinity.leading,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Đăng nhập (dòng dưới cùng)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account? ",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/login');
//                           },
//                           child: Text(
//                             "Log in",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             // Nút Next ở giữa phía dưới
//             Center(
//               child: ElevatedButton(
//                 onPressed: () => _register(context), // Gọi API đăng ký
//                 child: Text('Register'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(120, 50),
//                   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   backgroundColor: Color(0xFF275998),
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////////////////////////////////

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
// import 'home_page.dart'; // Import trang homepage
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   clientId: '575550351850-ktdi1a5amhfospkj3ohrkdqdejrkords.apps.googleusercontent.com',
//   scopes: ['email'],
// );

// Future<void> _signUpWithGoogle(BuildContext context) async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       // Người dùng đã hủy quá trình đăng nhập
//       print("Google Sign-In cancelled");
//       return;
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final String? idToken = googleAuth.idToken;

//     if (idToken == null) {
//       // Không nhận được idToken
//       _showErrorDialog(context, "Failed to retrieve idToken. Please try again.");
//       return;
//     }

//     // Gửi idToken đến server qua DIO
//     var dio = Dio();
//     var response = await dio.get(
//       'https://swdsapelearningapi.azurewebsites.net/api/auth/google-auth/signin',
//       queryParameters: {
//         'idToken': idToken,
//       },
//     );

//     if (response.statusCode == 200) {
//       print("Google Sign-In successful: ${response.data}");
//       _showSuccessDialog(context, 'Google Sign-In Successful');
//     } else {
//       print("Google Sign-In failed: ${response.statusMessage}");
//       _showErrorDialog(context, "Google Sign-In Failed. Please try again.");
//     }
//   } catch (e) {
//     print("Error during Google Sign-In: $e");
//     String errorMessage = 'An unknown error occurred';
//     if (e is DioError) {
//       print("DioError: ${e.response?.data}");
//       print("Status Code: ${e.response?.statusCode}");
//       print("Headers: ${e.response?.headers}");
//     }
//     _showErrorDialog(context, errorMessage);
//   }
// }



// void _showSuccessDialog(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(message),
//         content: Text('You have signed in with Google successfully.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomePage()),
//               );
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }


//   // Hàm để gọi API đăng ký bằng email/password
//   // Hàm để gọi API đăng ký bằng email/password
// Future<void> _register(BuildContext context) async {
//   if (_formKey.currentState!.validate() && _agreeToTerms) {
//     try {
//       var dio = Dio();
//       var response = await dio.post(
//         'https://swdsapelearningapi.azurewebsites.net/api/User/registration',
//         data: {
//           'email': _emailController.text,
//           'password': _passwordController.text,
//           'confirmPassword': _confirmPasswordController.text
//         },
//       );

//       if (response.statusCode == 200) {
//         print("Registration successful: ${response.data}");
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Registration Successful'),
//               content: Text('Your account has been created successfully.'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         print("Registration failed: ${response.statusMessage}");
//         _showErrorDialog(context, "Failed to register. Please try again.");
//       }
//     } catch (e) {
//       print("Error during registration: $e");
//       if (e is DioError && e.response?.statusCode == 400) {
//         print("Email already registered: ${e.response?.data}");
//         _showErrorDialog(context, "Email has already been registered!");
//       } else {
//         _showErrorDialog(context, "An error occurred: $e");
//       }
//     }
//   }
// }


//   // Hiển thị dialog lỗi
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Notification'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//     if (!emailRegExp.hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           'Sign up',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     // Nút đăng ký với Google
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton.icon(
//                         icon: Icon(Icons.g_mobiledata),
//                         label: Text('Sign Up with Google'),
//                         onPressed: () => _signUpWithGoogle(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Color(0xFF275998)),
//                           foregroundColor: Color(0xFF275998),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Dòng chữ "Or"
//                     Text(
//                       'Or',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Form nhập email, mật khẩu
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               labelText: 'Your email or username',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             validator: _validateEmail,
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           TextFormField(
//                             controller: _passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                             ),
//                             obscureText: _obscurePassword,
//                             validator: _validatePassword,
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             decoration: InputDecoration(
//                               labelText: 'Confirm Password',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscureConfirmPassword = !_obscureConfirmPassword;
//                                   });
//                                 },
//                               ),
//                             ),
//                             obscureText: _obscureConfirmPassword,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Điều khoản sử dụng
//                     CheckboxListTile(
//                       title: Text(
//                         'By creating an account, you agree to our Terms & Conditions.',
//                       ),
//                       value: _agreeToTerms,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           _agreeToTerms = value ?? false;
//                         });
//                       },
//                       controlAffinity: ListTileControlAffinity.leading,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Đăng nhập (dòng dưới cùng)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account? ",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/login');
//                           },
//                           child: Text(
//                             "Log in",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.01),
//             // Nút Next ở giữa phía dưới
//             Center(
//               child: ElevatedButton(
//                 onPressed: () => _register(context), // Gọi API đăng ký
//                 child: Text('Register'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(120, 50),
//                   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   backgroundColor: Color(0xFF275998),
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'home_page.dart'; // Import trang homepage

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '575550351850-ktdi1a5amhfospkj3ohrkdqdejrkords.apps.googleusercontent.com',
//     scopes: ['email'],
//   );

//   Future<void> _signUpWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         print("Google Sign-In cancelled");
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final String? accessToken = googleAuth.accessToken;

//       if (accessToken == null) {
//         _showErrorDialog(context, "Failed to retrieve tokens. Please try again.");
//         return;
//       }

//       // Thực hiện yêu cầu GET với Dio
//       var dio = Dio();
//       var response = await dio.get(
//   'https://swdsapelearningapi.azurewebsites.net/api/auth/google-auth/signin-google',
//   options: Options(
//     headers: {
//       'Accept': 'application/json',
//     },
//   ),
// );
// _showErrorDialog(context, "1");
// /////
//       if (response.statusCode == 400) {
//   print("Bad Request: ${response.data}");
//   _showErrorDialog(context, "Google Sign-In Failed. Please check your request.");
// }

//       if (response.statusCode == 200) {
//         var responseData = response.data;
//         // Kiểm tra phản hồi có chứa trường "token"
//         if (responseData != null && responseData['token'] != null) {
//           String token = responseData['token'];
//           print("Google Sign-In successful: Token received");
//           _showSuccessDialog(context, 'Google Sign-In Successful');
//           // Lưu token hoặc thực hiện các thao tác tiếp theo
//           // Ví dụ: lưu token vào SharedPreferences hoặc điều hướng đến HomePage
//         } else {
//           print("Google Sign-In response did not include a token");
//           _showErrorDialog(context, "Google Sign-In Failed. No token received.");
//         }
//       } else {
//         print("Google Sign-In failed: ${response.statusMessage}");
//         _showErrorDialog(context, "Google Sign-In Failed. Please try again.");
//       }
//     } catch (e) {
//       print("Error during Google Sign-In: $e");
//       String errorMessage = 'An unknown error occurred';
//       if (e is DioError) {
//         errorMessage = 'Error: ${e.message}';
//         print("DioError: ${e.response?.data}");
//       }
//       _showErrorDialog(context, errorMessage);
//     }
//   }

//   void _showSuccessDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(message),
//           content: Text('You have signed in with Google successfully.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Notification'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           'Sign up',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     // Nút đăng ký với Google
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton.icon(
//                         icon: Icon(Icons.g_mobiledata),
//                         label: Text('Sign Up with Google'),
//                         onPressed: () => _signUpWithGoogle(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(color: Color(0xFF275998)),
//                           foregroundColor: Color(0xFF275998),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     // Các phần khác không đổi...
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
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

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '575550351850-ktdi1a5amhfospkj3ohrkdqdejrkords.apps.googleusercontent.com',
  scopes: ['email'],
);

Future<void> _signUpWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User canceled the sign-in process
      print("Google Sign-In cancelled");
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      // No idToken received
      _showErrorDialog(context, "Failed to retrieve idToken. Please try again.");
      return;
    }

    // Sending idToken to the server
    var dio = Dio();
    var response = await dio.get(
      'https://swdsapelearningapi.azurewebsites.net/api/auth/google-auth/signin',
      queryParameters: {
        'idToken': idToken,
      },
    );

    if (response.statusCode == 200) {
      print("Google Sign-In successful: ${response.data}");
      _showSuccessDialog(context, 'Google Sign-In Successful');
    } else {
      print("Google Sign-In failed: ${response.statusMessage}");
      _showErrorDialog(context, "Google Sign-In Failed. Please try again.");
    }
  } catch (e) {
    print("Error during Google Sign-In: $e");
    String errorMessage = 'An unknown error occurred';
    if (e is DioError) {
  print("DioError: ${e.response?.data}");
  print("Status Code: ${e.response?.statusCode}");
  print("Headers: ${e.response?.headers}");
}
    _showErrorDialog(context, errorMessage);
  }
}


void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
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
}


  // Hàm để gọi API đăng ký bằng email/password
  // Hàm để gọi API đăng ký bằng email/password
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
        print("Registration successful: ${response.data}");
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
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print("Registration failed: ${response.statusMessage}");
        _showErrorDialog(context, "Failed to register. Please try again.");
      }
    } catch (e) {
      print("Error during registration: $e");
      if (e is DioError && e.response?.statusCode == 400) {
        print("Email already registered: ${e.response?.data}");
        _showErrorDialog(context, "Email has already been registered!");
      } else {
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
                        onPressed: () => _signUpWithGoogle(context),
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
<<<<<<< HEAD
=======

>>>>>>> origin/bao
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
                            Navigator.pushNamed(context, '/login');
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