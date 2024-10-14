import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart'; // Add this line to import the LoginScreen class

class RegisterScreenStep2 extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _selectedEducation = 'FPTU';

  final _formKey = GlobalKey<FormState>();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Xử lý đăng ký
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegExp = RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Form nhập thông tin
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            DropdownButtonFormField<String>(
                              value: _selectedEducation,
                              decoration: InputDecoration(
                                labelText: 'Education',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: ['FPTU', 'Khác'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                _selectedEducation = newValue!;
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: _validatePhoneNumber,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Thanh trạng thái (trang thứ hai)
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, size: 10, color: Colors.grey[400]),
                            SizedBox(width: 5),
                            Icon(Icons.circle, size: 10, color: Color(0xFF275998)), // Trang hiện tại
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nút Register sát góc dưới phải
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _register,
                  child: Text('Next'), // Đổi thành "Next" giống ảnh
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 40), // Kích thước nhỏ gọn
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Khoảng cách padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Bo tròn góc nhiều hơn
                    ),
                    backgroundColor: Color(0xFF275998), // Màu nền xanh đậm
                    foregroundColor: Colors.white, // Màu chữ trắng
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
