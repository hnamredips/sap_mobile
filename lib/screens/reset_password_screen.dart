import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _resetPassword() {
	// Xử lý đặt lại mật khẩu
  }

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: Text('Reset Password'),
	  ),
	  body: Padding(
		padding: const EdgeInsets.all(16.0),
		child: Column(
		  mainAxisAlignment: MainAxisAlignment.center,
		  children: [
			TextField(
			  controller: _newPasswordController,
			  decoration: InputDecoration(labelText: 'New Password'),
			  obscureText: true,
			),
			TextField(
			  controller: _confirmPasswordController,
			  decoration: InputDecoration(labelText: 'Confirm New Password'),
			  obscureText: true,
			),
			SizedBox(height: 20),
			ElevatedButton(
			  onPressed: _resetPassword,
			  child: Text('Reset Password'),
			),
		  ],
		),
	  ),
	);
  }
}