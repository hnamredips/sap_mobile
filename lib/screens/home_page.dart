import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Thêm DIO để gọi API
import 'package:sap_mobile/screens/view_all_material.dart';
import 'package:sap_mobile/screens/search_screen.dart'; // Import SearchScreen
import 'package:sap_mobile/screens/modulemm.dart'; // Import trang chi tiết module MM, bạn thêm tương tự với PP, SD

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> moduleNames = []; // Danh sách moduleName
  List<dynamic> topCertificates = []; // Danh sách certificateName ngắn nhất
  List<dynamic> enrolledCertificates = []; // Danh sách chứng chỉ đã đăng ký
  bool isLoading = true; // Trạng thái loading
  bool isLoadingCertificates = true; // Trạng thái loading cho certificates
  bool isLoadingEnrolled = true; // Trạng thái loading cho Enrolled Certificates
  Map<int, int> courseNames =
      {}; // Để lưu courseId với certificateId từ API Get All Course
  Map<int, String> certificateNames =
      {}; // Để lưu certificateId với certificateName từ API Certificate

  @override
  void initState() {
    super.initState();
    _fetchModules(); // Gọi hàm lấy dữ liệu module từ API
    _fetchTopCertificates(); // Gọi hàm lấy dữ liệu certificate từ API
    _fetchEnrolledCertificates(); // Gọi hàm lấy dữ liệu Enrolled Certificates từ API
    _fetchCourses(); // Gọi API Get All Course
    _fetchCertificates(); // Gọi API Get All Certificates
  }

  // Hàm gọi API và lấy dữ liệu module
  Future<void> _fetchModules() async {
    try {
      print('Fetching modules...');
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all',
      );
      if (response.statusCode == 200 && response.data.containsKey('\$values')) {
        var data = response.data['\$values']; // Lấy dữ liệu từ trường '$values'
        print('Modules fetched: ${data.length} modules found.');
        setState(() {
          moduleNames = List<String>.from(
              data.map((module) => module['moduleName'].toString()));
          isLoading = false; // Tắt loading sau khi nhận dữ liệu
        });
      } else {
        print("Error: Dữ liệu trả về không chứa trường '\$values'");
        setState(() {
          isLoading = false; // Tắt loading trong trường hợp lỗi
        });
      }
    } catch (e) {
      print('Error fetching modules: $e');
      setState(() {
        isLoading = false; // Tắt loading nếu gặp lỗi
      });
    }
  }

  // Hàm gọi API và lấy dữ liệu top 3 certificates
  Future<void> _fetchTopCertificates() async {
    try {
      print('Fetching top certificates...');
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
      );

      if (response.statusCode == 200 && response.data.containsKey('\$values')) {
        var data = response.data['\$values'];
        print('Certificates fetched: ${data.length} certificates found.');

        // Lọc các certificate có certificateName từ 5 đến dưới 8 ký tự
        List<dynamic> filteredCertificates = data
            .where((certificate) =>
                certificate['certificateName'].length >= 15 &&
                certificate['certificateName'].length < 50)
            .toList();

        // Sắp xếp danh sách theo độ dài certificateName
        filteredCertificates.sort((a, b) =>
            a['certificateName'].length.compareTo(b['certificateName'].length));

        // Lấy ra các certificate đã lọc
        setState(() {
          topCertificates = filteredCertificates; // Gán danh sách đã lọc
          isLoadingCertificates = false; // Tắt loading sau khi nhận dữ liệu
        });
      } else {
        print("Error: Dữ liệu trả về không chứa trường '\$values'");
        setState(() {
          isLoadingCertificates = false; // Tắt loading trong trường hợp lỗi
        });
      }
    } catch (e) {
      print('Error fetching certificates: $e');
      setState(() {
        isLoadingCertificates = false; // Tắt loading nếu gặp lỗi
      });
    }
  }

  // Hàm gọi API Get All Course và lưu courseId với certificateId
  Future<void> _fetchCourses() async {
    try {
      print('Fetching courses...');
      var courseResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Course/get-all',
      );

      if (courseResponse.statusCode == 200 &&
          courseResponse.data.containsKey('\$values')) {
        var courseData = courseResponse.data['\$values'];
        print('Courses fetched: ${courseData.length} courses found.');

        // Tạo Map chứa courseId với certificateId
        setState(() {
          courseNames = {
            for (var course in courseData) course['id']: course['certificateId']
          };
        });
      } else {
        print("Error fetching courses data.");
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  // Hàm gọi API Certificate và lưu certificateName
  Future<void> _fetchCertificates() async {
    try {
      print('Fetching certificates...');
      var certificateResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
      );

      if (certificateResponse.statusCode == 200 &&
          certificateResponse.data.containsKey('\$values')) {
        var certificateData = certificateResponse.data['\$values'];
        print(
            'Certificates fetched: ${certificateData.length} certificates found.');

        // Tạo Map chứa certificateId với certificateName
        setState(() {
          certificateNames = {
            for (var certificate in certificateData)
              certificate['id']: certificate['certificateName']
          };
        });
      } else {
        print("Error fetching certificates data.");
      }
    } catch (e) {
      print('Error fetching certificates: $e');
    }
  }

  // Hàm hiển thị Enrolled Certificates
  Future<void> _fetchEnrolledCertificates() async {
    try {
      print('Fetching enrolled certificates...');

      // Bước 1: Lấy danh sách người dùng và tìm userId hiện tại
      var userResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/User/api/users',
      );

      if (userResponse.statusCode == 200) {
        var userData = userResponse.data;

        // In toàn bộ userData để kiểm tra cấu trúc
        print('User Data: $userData');

        // Tìm userId "S71990" từ danh sách người dùng trong "$values"
        String? currentUserId;
        if (userData.containsKey('\$values')) {
          for (var user in userData['\$values']) {
            if (user['id'] == 'S71990') {
              currentUserId = user['id'];
              break;
            }
          }
        }

        // Kiểm tra nếu tìm thấy userId
        if (currentUserId != null) {
          print('Current User ID: $currentUserId'); // Kiểm tra giá trị userId

          // Bước 2: Gọi API Enrollment để lấy danh sách đăng ký
          var enrollmentResponse = await Dio().get(
            'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all',
          );

          if (enrollmentResponse.statusCode == 200) {
            var enrollmentsData = enrollmentResponse.data['\$values'];

            // Lọc danh sách enrollments theo userId hiện tại và status là "Confirmed"
            var confirmedEnrollments = enrollmentsData.where((enrollment) {
              return enrollment['userId'] == currentUserId &&
                  enrollment['status'] == 'Confirmed';
            }).toList();

            // Bước 3: Kết hợp courseId với certificateName thông qua certificateId
            List<Map<String, dynamic>> enrolledCerts = [];
            for (var enrollment in confirmedEnrollments) {
              int courseId = enrollment['courseId'];

              // Kiểm tra courseId có trong courseNames
              if (courseNames.containsKey(courseId)) {
                int certificateId = courseNames[courseId]!;
                String certificateName =
                    certificateNames[certificateId] ?? 'Unknown Certificate';

                enrolledCerts.add({
                  'courseId': courseId,
                  'certificateName': certificateName,
                  'status': enrollment['status'],
                });
              } else {
                print('Course ID $courseId không tìm thấy trong courseNames.');
              }
            }

            // Cập nhật enrolledCertificates và tắt loading
            setState(() {
              enrolledCertificates = enrolledCerts;
              isLoadingEnrolled = false;
            });
          } else {
            print("Error fetching enrollments data.");
            setState(() {
              isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
            });
          }
        } else {
          print("User ID 'S71990' not found in user data.");
          setState(() {
            isLoadingEnrolled = false; // Tắt loading nếu không tìm thấy userId
          });
        }
      } else {
        print("Error fetching user data.");
        setState(() {
          isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
        });
      }
    } catch (e) {
      print('Error fetching enrolled certificates: $e');
      setState(() {
        isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, Đạt"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ModuleMM()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchScreen()), // Điều hướng đến SearchScreen
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Thêm Scroll để có thể cuộn màn hình
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Khung tổng thể cho "Lịch học hôm nay" và các mục lịch học
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 225, 224, 224), // Màu nền nhạt cho khung tổng thể
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Schedule Header
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Study schedule',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Tất cả', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Schedule Items
                    Column(
                      children: [
                        buildScheduleItem(
                          'SAP311',
                          'Online 514',
                          '12:30 - 14:45',
                          true,
                        ),
                        SizedBox(height: 10),
                        buildScheduleItem(
                          'SAP323',
                          'Offline 611',
                          '18:30 - 20:00',
                          false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Categories Slider with "View All" button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAllMaterial()),
                      );
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Categories Slider với moduleNames từ API
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : moduleNames.isEmpty
                      ? Center(child: Text("No modules found"))
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: 60,
                            enableInfiniteScroll: true,
                            viewportFraction: 0.33,
                          ),
                          items: moduleNames.map((category) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    // Điều hướng đến từng module tương ứng
                                    if (category == 'MM') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ModuleMM()),
                                      );
                                    } else if (category == 'PP') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ModuleMM()),
                                      );
                                    } else if (category == 'SD') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ModuleMM()),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF275998),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
              SizedBox(height: 16),

              // Top Certificate List
              Text('Top Certificates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              isLoadingCertificates
                  ? Center(child: CircularProgressIndicator())
                  : topCertificates.isEmpty
                      ? Center(child: Text("No certificates found"))
                      : Column(
                          children: topCertificates.map((certificate) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Color(0xFF275998),
                                  margin: EdgeInsets.all(4),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      certificate['certificateName'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

              SizedBox(height: 16),

              // Enrolled Certificate List
              Text('Enrolled Certificates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              isLoadingEnrolled
                  ? Center(child: CircularProgressIndicator())
                  : enrolledCertificates.isEmpty
                      ? Center(child: Text("No enrolled certificates found"))
                      : Column(
                          children: enrolledCertificates.map((enrollment) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Color(0xFF275998),
                                  margin: EdgeInsets.all(4),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      enrollment['certificateName'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build schedule item
  Widget buildScheduleItem(
      String subjectCode, String room, String time, bool isOnline) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject Code: $subjectCode'),
              Text('Room: $room'),
              Text('Giờ học: $time'),
            ],
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5),
              Text(isOnline ? 'Online' : 'Offline'),
            ],
          ),
        ],
      ),
    );
  }
}
