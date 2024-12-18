import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String email;
  final String fullName;
  final String education;
  final String phoneNumber;
  final String gender;

  EditProfileScreen({
    required this.email,
    required this.fullName,
    required this.education,
    required this.phoneNumber,
    required this.gender,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.fullName;
    _educationController.text = widget.education;
    _phoneNumberController.text = widget.phoneNumber;

    // Kiểm tra và chuyển đổi giá trị của gender
    _selectedGender = widget.gender.isNotEmpty
        ? widget.gender[0].toUpperCase() +
            widget.gender.substring(1).toLowerCase()
        : null;

    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('currentUserId');
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (currentUserId == null) {
        print('User ID không tồn tại. Vui lòng đăng nhập lại.');
        return;
      }

      try {
        var response = await Dio().put(
          'https://swdsapelearningapi.azurewebsites.net/api/User/update-student?id=$currentUserId',
          data: {
            'email': widget.email, // Không thay đổi email
            'fullname': _fullNameController.text,
            'education': _educationController.text,
            'phoneNumber': _phoneNumberController.text,
            'gender': _selectedGender,
            'oldPassword': '',
            'newPassword': ''
          },
        );

        if (response.statusCode == 200) {
          _showSuccessDialog();
        } else {
          print("Error updating profile: ${response.statusCode}");
        }
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Saved'),
          content: Text('Your profile information has been updated.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay về trang trước
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    Navigator.pushNamed(context, '/change-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                controller: TextEditingController(text: widget.email),
                readOnly: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _educationController,
                decoration: InputDecoration(
                  labelText: 'Education',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedGender,
                hint: Text('Select Gender'),
                items: ['Female', 'Male'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.normal), // Không in đậm
      ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      readOnly: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Change'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Color(0xFF275998),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save'),
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
