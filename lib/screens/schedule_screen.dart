import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;
  DateTime _currentWeekStartDate = DateTime(2025, 1, 6); // Bắt đầu từ thứ Hai, ngày 6/1/2025
  List<Map<String, dynamic>> _schedule = [];
  String? currentUserId;
  Map<int, String> courseLocations = {};
  List<Map<String, dynamic>> filteredSchedule = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('currentUserId');
    });

    if (currentUserId != null) {
      checkEnrollmentStatus();
    } else {
      print("User ID not found in SharedPreferences");
    }
  }

  Future<void> checkEnrollmentStatus() async {
  if (currentUserId == null) {
    print("User ID is null, cannot check enrollment status.");
    return;
  }

  try {
    final enrollmentResponse = await http.get(
      Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all?PageSize=50'));
    if (enrollmentResponse.statusCode == 200) {
      final data = json.decode(enrollmentResponse.body);
      final List enrollments = data is Map && data.containsKey('\$values')
          ? data['\$values']
          : (data is List ? data : [data]);

      print("Fetched enrollments data: $enrollments");

      // Lọc các enrollments có `userId` trùng khớp và `status` là 'Success'
      final successfulEnrollments = enrollments.where((enrollment) =>
        enrollment['userId'] == currentUserId &&
        enrollment['status'] == 'Success').toList();

      if (successfulEnrollments.isNotEmpty) {
        // Lặp qua tất cả các khóa học đã đăng ký thành công
        for (var enrollment in successfulEnrollments) {
          final courseId = enrollment['courseId'];
          await fetchCourseLocation(courseId);
          await fetchCourseSessions(courseId);
        }
      } else {
        print("Không tìm thấy enrollment với status 'Success' cho user hiện tại.");
      }
    } else {
      throw Exception('Failed to load enrollment data');
    }
  } catch (e) {
    print("Error fetching enrollment data: $e");
  }
}

Future<void> fetchCourseLocation(int courseId) async {
  try {
    final courseResponse = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/get-all?PageSize=50'));
    if (courseResponse.statusCode == 200) {
      final data = json.decode(courseResponse.body);
      final List courses = data is Map && data.containsKey('\$values') ? data['\$values'] : [data];

      // In toàn bộ dữ liệu courses để kiểm tra cấu trúc và nội dung
      print("Courses Data: $courses");

      for (var course in courses) {
        if (course['id'] == courseId) {
          setState(() {
            courseLocations[courseId] = course['location'] ?? 'No Location';
          });
          break;
        }
      }
    } else {
      throw Exception('Failed to load course data');
    }
  } catch (e) {
    print("Error fetching course location data: $e");
  }
}

Future<void> fetchCourseSessions(int courseId) async {
  try {
    final courseSessionResponse = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/CourseSession/get-all?PageSize=50'));
    if (courseSessionResponse.statusCode == 200) {
      final data = json.decode(courseSessionResponse.body);
      final List courseSessions = data is Map && data.containsKey('\$values') ? data['\$values'] : [data];

      final sessions = courseSessions.where((session) => session['courseId'] == courseId).toList();

      setState(() {
        _schedule.addAll(sessions.map((session) {
          return {
            'title': session['courseName'] ?? 'No Title',
            'sessionName': session['sessionName'] ?? 'No Session Name',
            'sessionDate': DateTime.parse(session['sessionDate']),
            'location': courseLocations[courseId] ?? 'No Location',
          };
        }).toList());
        filterSessionsBySelectedDay();
      });
      print("Schedule loaded: $_schedule");
    } else {
      throw Exception('Failed to load course session data');
    }
  } catch (e) {
    print("Error fetching course session data: $e");
  }
}


  void filterSessionsBySelectedDay() {
  DateTime selectedDate = _currentWeekStartDate.add(Duration(days: _selectedDayIndex));
  
  setState(() {
    filteredSchedule = _schedule.where((session) {
      DateTime sessionDate = session['sessionDate'];
      // So sánh chỉ ngày, tháng, và năm, bỏ qua phần thời gian
      return sessionDate.year == selectedDate.year &&
             sessionDate.month == selectedDate.month &&
             sessionDate.day == selectedDate.day;
    }).toList();
  });
}

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
    filterSessionsBySelectedDay();
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.subtract(Duration(days: 7));
      _selectedDayIndex = 0;
    });
    filterSessionsBySelectedDay();
  }

  void _nextWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.add(Duration(days: 7));
      _selectedDayIndex = 0;
    });
    filterSessionsBySelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Đặt màu nền của AppBar thành màu trắng
      title: Center(
        child: Text(
          'Weekly Timetable',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousWeek,
              ),
              Text(
                'Jan 2025',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextWeek,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                DateTime day = _currentWeekStartDate.add(Duration(days: index));
                return GestureDetector(
                  onTap: () => _selectDay(index),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _selectedDayIndex == index
                          ? Color(0xFF275998)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _weekDays[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedDayIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _selectedDayIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        if (_selectedDayIndex == index)
                          Container(
                            height: 4,
                            width: 24,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: filteredSchedule.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredSchedule.length,
                    itemBuilder: (context, index) {
                      final item = filteredSchedule[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['sessionName']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 18, color: Colors.black),
                                    SizedBox(width: 4),
                                    Text(
                                      "${item['sessionDate'].year}-${item['sessionDate'].month.toString().padLeft(2, '0')}-${item['sessionDate'].day.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 18, color: Colors.black),
                                    SizedBox(width: 4),
                                    Text(
                                      item['location']!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No schedule available")),
          ),
        ],
      ),
    );
  }
}
