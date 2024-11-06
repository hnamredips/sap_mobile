import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool isOldPasswordRequired = true; // Đánh dấu yêu cầu nhập mật khẩu cũ

  @override
  void initState() {
    super.initState();
    _checkOldPasswordRequirement();
  }

  Future<void> _checkOldPasswordRequirement() async {
    try {
      // Giả sử API trả về thông tin người dùng, bao gồm cả mật khẩu hiện tại
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/User/get-user-info',
      );

      if (response.statusCode == 200) {
        // Kiểm tra nếu mật khẩu cũ là `null`
        setState(() {
          isOldPasswordRequired = response.data['password'] != null;
        });
      }
    } catch (e) {
      print('Error checking old password requirement: $e');
    }
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      String oldPassword = _oldPasswordController.text;
      String newPassword = _newPasswordController.text;

      try {
        // Gửi yêu cầu thay đổi mật khẩu với hoặc không có `oldPassword`
        var response = await Dio().put(
          'https://swdsapelearningapi.azurewebsites.net/api/User/change-password',
          data: {
            'oldPassword': isOldPasswordRequired ? oldPassword : null,
            'newPassword': newPassword,
          },
        );

        if (response.statusCode == 200) {
          // Hiển thị thông báo thành công
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Password Changed'),
                content: Text('Your password has been successfully changed.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Quay lại trang trước
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          _showErrorDialog("Failed to change password. Please try again.");
        }
      } catch (e) {
        _showErrorDialog("An error occurred while changing password: $e");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isOldPasswordRequired) // Chỉ hiển thị nếu cần nhập mật khẩu cũ
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureOldPassword,
                  validator: (value) {
                    if (isOldPasswordRequired && (value == null || value.isEmpty)) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
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
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50), // Giữ nguyên khoảng cách
              Center(
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text('Change Password'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF275998),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
