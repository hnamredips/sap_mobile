import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  void _submit(BuildContext context) {
    // Điều hướng đến màn hình đặt lại mật khẩu
    Navigator.pushNamed(context, '/reset-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}