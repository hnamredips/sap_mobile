import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Thêm DIO để gọi API
import 'package:sap_mobile/screens/view_all_material.dart';
import 'package:sap_mobile/screens/schedule_screen.dart';
import 'package:sap_mobile/screens/search_screen.dart'; // Import SearchScreen
import 'package:sap_mobile/screens/moduleMM.dart'; // Import trang chi tiết module MM, bạn thêm tương tự với PP, SD
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện để sử dụng SharedPreferences

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
  String? currentUserId; // Để lưu trữ currentUserId
  String? currentUserFullname; // Thêm biến để lưu fullname của người dùng
  List<dynamic> modules = []; // Thêm dòng này

  @override
  void initState() {
    super.initState();
    _initializeData(); // Gọi hàm khởi tạo dữ liệu
  }

  Future<void> _initializeData() async {
    await _fetchModules(); // Gọi hàm lấy dữ liệu module từ API
    await _fetchTopCertificates(); // Gọi hàm lấy dữ liệu certificate từ API
    await _fetchCourses(); // Gọi API Get All Course
    await _fetchCertificates(); // Gọi API Get All Certificates
    await _fetchEnrolledCertificates(); // Gọi hàm lấy dữ liệu Enrolled Certificates từ API
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
          modules = List<dynamic>.from(data); // Gán dữ liệu vào modules
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
                certificate['certificateName'].length < 27)
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

  Future<void> _fetchEnrolledCertificates() async {
    try {
      print('Fetching enrolled certificates...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentEmail = prefs.getString('currentEmail');

      if (currentEmail == null) {
        print('Không tìm thấy email đăng nhập. Vui lòng đăng nhập lại.');
        setState(() {
          isLoadingEnrolled = false;
        });
        return;
      }

      var userResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/User/get-all-student',
      );

      if (userResponse.statusCode == 200) {
        var userData = userResponse.data;

        if (userData.containsKey('\$values')) {
          for (var user in userData['\$values']) {
            if (user['email'] == currentEmail) {
              currentUserId = user['id'];
              currentUserFullname = user['fullname'];
              await prefs.setString('currentUserId', currentUserId!);
              print('UserID: $currentUserId'); // In ra UserID vào console
              setState(() {
                currentUserFullname = user['fullname'];
              });
              break;
            }
          }
        }

        if (currentUserId == null) {
          print("User ID not found in user data.");
          setState(() {
            isLoadingEnrolled = false;
          });
          return;
        }

        var enrollmentResponse = await Dio().get(
          'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all?PageSize=50',
        );

        if (enrollmentResponse.statusCode == 200) {
          var enrollmentsData = enrollmentResponse.data['\$values'];
          var confirmedEnrollments = enrollmentsData.where((enrollment) {
            return enrollment['userId'] == currentUserId &&
                enrollment['status'] == 'Success';
          }).toList();

          var courseResponse = await Dio().get(
            'https://swdsapelearningapi.azurewebsites.net/api/Course/get-all?PageSize=50',
          );

          if (courseResponse.statusCode == 200 &&
              courseResponse.data.containsKey('\$values')) {
            var courseData = courseResponse.data['\$values'];
            Map<int, String> courseMap = {
              for (var course in courseData) course['id']: course['courseName']
            };

            setState(() {
              enrolledCertificates = confirmedEnrollments.map((enrollment) {
                final courseId = enrollment['courseId'];
                final courseName = courseMap[courseId] ?? 'Unknown Course';
                final certificateName =
                    certificateNames[courseNames[courseId]] ?? courseName;

                return {
                  'courseName': courseName,
                  'certificateName': certificateName,
                };
              }).toList();
              isLoadingEnrolled = false;
            });
          } else {
            print("Error fetching courses data.");
            setState(() {
              isLoadingEnrolled = false;
            });
          }
        } else {
          print("Error fetching enrollments data.");
          setState(() {
            isLoadingEnrolled = false;
          });
        }
      } else {
        print("Error fetching user data.");
        setState(() {
          isLoadingEnrolled = false;
        });
      }
    } catch (e) {
      print('Error fetching enrolled certificates: $e');
      setState(() {
        isLoadingEnrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Xóa mũi tên quay lại
        title: Text(
        "Hi, ${currentUserFullname ?? ''}",
        style: TextStyle(color: Colors.black), // Đổi màu chữ thành màu đen để phù hợp với nền trắng
      ),
      backgroundColor: Colors.white, // Đặt màu nền của AppBar thành màu trắng
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
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
              //SizedBox(height: 10),

            // Thêm hình ảnh phía dưới tiêu đề "Hi, [Tên người dùng]"
            Container(
              width: double.infinity,
              height: 150, // Chiều cao của ảnh
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/image_homepage(1).png', // Đường dẫn đến ảnh trong assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

              // Categories Slider with "View All" button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 33, 77, 130), fontWeight: FontWeight.bold, ),
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
                        color: Color(0xFF275998),  
                        fontSize: 14,
                        fontWeight: FontWeight.bold
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
                                    // Tìm module tương ứng trong danh sách modules
                                    var module = modules.firstWhere(
                                      (mod) =>
                                          mod['moduleName'] ==
                                          category, // So sánh với tên module
                                      orElse: () =>
                                          null, // Trả về null nếu không tìm thấy
                                    );

                                    // Nếu tìm thấy module, điều hướng đến ModuleMM với moduleId
                                    if (module != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ModuleMM(
                                            moduleId:
                                                module['id'], // Truyền moduleId
                                            moduleName: module[
                                                'moduleName'], // Truyền moduleName
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Xử lý khi không tìm thấy module (tuỳ chọn)
                                      print(
                                          'Module not found for category: $category');
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(31, 18, 17, 17), // Tăng độ mờ đục của màu đen
                                          blurRadius:
                                              7, // Tăng độ mờ của shadow
                                          offset: Offset(0,
                                              5), // Điều chỉnh vị trí của shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(58, 57, 57, 1.0),

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
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 33, 77, 130), fontWeight: FontWeight.bold)),
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
                                  color: Colors.white,
                                  margin: EdgeInsets.all(4),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      certificate['certificateName'],
                                      style: TextStyle(
                                        color: Colors.black,
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
              Text('Enrolled Courses',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 33, 77, 130),  fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              isLoadingEnrolled
                  ? Center(child: CircularProgressIndicator())
                  : enrolledCertificates.isEmpty
                      ? Center(child: Text("No enrolled courses found"))
                      : Column(
                          children: enrolledCertificates.map((enrollment) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(4),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      enrollment['certificateName'],
                                      style: TextStyle(
                                        color: Colors.black,
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
