import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'purchase_overview.dart'; // Import CombinedPurchasePage

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<dynamic> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/get-all'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courses = data['\$values'];
        });
      } else {
        print('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  String formatDate(String date) {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  }

  String formatCurrency(int price) {
    final format = NumberFormat('#,###', 'en_US');
    return format.format(price) + ' VND';
  }

  // Hàm điều hướng sang CombinedPurchasePage với thông tin của khóa học đã chọn
  void navigateToPurchasePage(course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CombinedPurchasePage(
          className: course['courseName'] ?? 'No Course Name',
          schedule: '${formatDate(course['startTime'])} - ${formatDate(course['endTime'])}',
          students: 'Information unavailable',
          location: course['location'] ?? 'N/A',
          price: formatCurrency(course['price'] ?? 0),
          iddcertificate: course['certificateName'] ?? 'N/A',
          level: course['level'] ?? 'N/A',
          sessions: 'Unknown',
          duration: 'Unknown',
          instructorName: course['instructorName'] ?? 'N/A',
          courseId: course['id'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Courses',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: courses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return GestureDetector(
                    onTap: () => navigateToPurchasePage(course),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['courseName'] ?? 'No Course Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Certificate: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: course['certificateName'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Lecturer: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: course['instructorName'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Start Time: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: formatDate(course['startTime']),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'End Time: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: formatDate(course['endTime']),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Location: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: course['location'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Price: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: formatCurrency(course['price'] ?? 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
