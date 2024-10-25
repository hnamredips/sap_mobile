// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // Thêm DIO để gọi API
// import 'package:sap_mobile/screens/view_all_material.dart';
// import 'package:sap_mobile/screens/search_screen.dart'; // Import SearchScreen
// import 'package:sap_mobile/screens/modulemm.dart'; // Import trang chi tiết module MM, bạn thêm tương tự với PP, SD

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<String> moduleNames = []; // Danh sách moduleName
//   List<dynamic> topCertificates = []; // Danh sách certificateName ngắn nhất
//   List<dynamic> enrolledCertificates = []; // Danh sách chứng chỉ đã đăng ký
//   bool isLoading = true; // Trạng thái loading
//   bool isLoadingCertificates = true; // Trạng thái loading cho certificates
//   bool isLoadingEnrolled = true; // Trạng thái loading cho Enrolled Certificates

//   @override
//   void initState() {
//     super.initState();
//     _fetchModules(); // Gọi hàm lấy dữ liệu module từ API
//     _fetchTopCertificates(); // Gọi hàm lấy dữ liệu certificate từ API
//     _fetchEnrolledCertificates(); // Gọi hàm lấy dữ liệu Enrolled Certificates từ API
//   }

//   // Hàm gọi API và lấy dữ liệu module
//   Future<void> _fetchModules() async {
//     try {
//       var response = await Dio().get(
//         'https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all',
//       );
//       if (response.statusCode == 200 && response.data.containsKey('\$values')) {
//         var data = response.data['\$values']; // Lấy dữ liệu từ trường '$values'
//         setState(() {
//           moduleNames = List<String>.from(
//               data.map((module) => module['moduleName'].toString()));
//           isLoading = false; // Tắt loading sau khi nhận dữ liệu
//         });
//       } else {
//         print("Error: Dữ liệu trả về không chứa trường '\$values'");
//         setState(() {
//           isLoading = false; // Tắt loading trong trường hợp lỗi
//         });
//       }
//     } catch (e) {
//       print('Error fetching modules: $e');
//       setState(() {
//         isLoading = false; // Tắt loading nếu gặp lỗi
//       });
//     }
//   }

//   // Hàm gọi API và lấy dữ liệu top 3 certificates
//   Future<void> _fetchTopCertificates() async {
//     try {
//       var response = await Dio().get(
//         'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
//       );

//       if (response.statusCode == 200 && response.data.containsKey('\$values')) {
//         var data = response.data['\$values'];

//         // Sắp xếp danh sách theo độ dài certificateName và chọn 3 certificate ngắn nhất
//         List<dynamic> sortedCertificates =
//             data.map<dynamic>((certificate) => certificate).toList();

//         sortedCertificates.sort((a, b) =>
//             a['certificateName'].length.compareTo(b['certificateName'].length));

//         // Lấy ra 3 certificate có certificateName ngắn nhất
//         setState(() {
//           topCertificates =
//               sortedCertificates.take(3).toList(); // Lấy 3 certificates
//           isLoadingCertificates = false; // Tắt loading sau khi nhận dữ liệu
//         });
//       } else {
//         print("Error: Dữ liệu trả về không chứa trường '\$values'");
//         setState(() {
//           isLoadingCertificates = false; // Tắt loading trong trường hợp lỗi
//         });
//       }
//     } catch (e) {
//       print('Error fetching certificates: $e');
//       setState(() {
//         isLoadingCertificates = false; // Tắt loading nếu gặp lỗi
//       });
//     }
//   }

//   // Hàm gọi API và lấy dữ liệu Enrolled Certificates
//   // Hàm gọi API và lấy dữ liệu Enrolled Certificates
//   Future<void> _fetchEnrolledCertificates() async {
//     try {
//       // Gọi API User để lấy danh sách enrollment của user
//       var userResponse = await Dio().get(
//         'https://swdsapelearningapi.azurewebsites.net/api/User/api/users',
//       );

//       if (userResponse.statusCode == 200) {
//         var userData = userResponse.data;

//         // Kiểm tra nếu 'enrollments' không null và chứa trường '$values'
//         if (userData['enrollments'] != null &&
//             userData['enrollments']['\$values'] != null) {
//           var userEnrollments = userData['enrollments']['\$values'];

//           if (userEnrollments.isEmpty) {
//             setState(() {
//               isLoadingEnrolled = false; // Tắt loading nếu không có enrollment
//             });
//             return;
//           }

//           // Lấy tất cả thông tin enrollment từ API
//           var enrollmentResponse = await Dio().get(
//             'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all',
//           );

//           if (enrollmentResponse.statusCode == 200) {
//             var enrollmentsData = enrollmentResponse.data['\$values'];

//             // Lọc ra các chứng chỉ mà user đã thanh toán thành công
//             var successfulEnrollments = enrollmentsData.where((enrollment) {
//               return userEnrollments.any((userEnrollment) =>
//                   userEnrollment['id'] == enrollment['id'] &&
//                   enrollment['status'] ==
//                       'Success'); // Kiểm tra trạng thái thanh toán
//             }).toList();

//             if (successfulEnrollments.isNotEmpty) {
//               setState(() {
//                 enrolledCertificates = successfulEnrollments;
//                 isLoadingEnrolled = false;
//               });
//             } else {
//               setState(() {
//                 isLoadingEnrolled =
//                     false; // Không có chứng chỉ nào đã thanh toán
//               });
//             }
//           } else {
//             setState(() {
//               isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
//             });
//             print("Error fetching enrollments data.");
//           }
//         } else {
//           print("No enrollments found for the user.");
//           setState(() {
//             isLoadingEnrolled = false; // Tắt loading nếu không có enrollments
//           });
//         }
//       } else {
//         setState(() {
//           isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
//         });
//         print("Error fetching user data.");
//       }
//     } catch (e) {
//       print('Error fetching enrolled certificates: $e');
//       setState(() {
//         isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hi, Đạt"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         SearchScreen()), // Điều hướng đến SearchScreen
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Khung tổng thể cho "Lịch học hôm nay" và các mục lịch học
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(
//                       255, 225, 224, 224), // Màu nền nhạt cho khung tổng thể
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Schedule Header
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Study schedule',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Text('Tất cả', style: TextStyle(color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),

//                     // Schedule Items
//                     buildScheduleItem(
//                         'SAP311', 'Online 514', '12:30 - 14:45', true),
//                     SizedBox(height: 10),
//                     buildScheduleItem(
//                         'SAP323', 'Offline 611', '18:30 - 20:00', false),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),

//               // Categories Slider with "View All" button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment
//                     .spaceBetween, // Đặt hai phần tử cách xa nhau
//                 children: [
//                   Text(
//                     'Categories',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ViewAllMaterial()), // Điều hướng đến trang View All Material
//                       );
//                     },
//                     child: Text(
//                       'View All',
//                       style: TextStyle(
//                         color: Colors.blue, // Màu xanh cho nút View All
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 6),

//               // Categories Slider với moduleNames từ API
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : moduleNames.isEmpty
//                       ? Center(child: Text("No modules found"))
//                       : CarouselSlider(
//                           options: CarouselOptions(
//                             height: 60,
//                             enableInfiniteScroll: true,
//                             viewportFraction: 0.33,
//                           ),
//                           items: moduleNames.map((category) {
//                             return Builder(
//                               builder: (BuildContext context) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     // Điều hướng đến từng module tương ứng
//                                     if (category == 'MM') {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ModuleMM()), // Điều hướng đến Module MM
//                                       );
//                                     }
//                                     // Thêm các điều hướng tương ứng với PP và SD
//                                     else if (category == 'PP') {
//                                       // Điều hướng đến Module PP
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ModuleMM()), // Giả định có ModulePP
//                                       );
//                                     } else if (category == 'SD') {
//                                       // Điều hướng đến Module SD
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ModuleMM()), // Giả định có ModuleSD
//                                       );
//                                     }
//                                   },
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     margin:
//                                         EdgeInsets.symmetric(horizontal: 5.0),
//                                     decoration: BoxDecoration(
//                                       color: Color(
//                                           0xFF275998), // Thay đổi màu nền sang mã màu được yêu cầu
//                                       borderRadius: BorderRadius.circular(8),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 5,
//                                           offset: Offset(0, 3),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         category,
//                                         style: TextStyle(
//                                           fontSize: 24,
//                                           color: Colors
//                                               .white, // Thay đổi màu chữ sang trắng
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           }).toList(),
//                         ),
//               SizedBox(height: 12),

//               // Top Certificate List
//               Text('Top Certificates', style: TextStyle(fontSize: 18)),
//               isLoadingCertificates
//                   ? Center(child: CircularProgressIndicator())
//                   : topCertificates.isEmpty
//                       ? Center(child: Text("No certificates found"))
//                       : Column(
//                           children: topCertificates.map((certificate) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical:
//                                       0), // Khoảng cách giữa các Card theo chiều dọc
//                               child: SizedBox(
//                                 width: double
//                                     .infinity, // Card chiếm toàn bộ chiều ngang
//                                 child: Card(
//                                   color: Color(0xFF275998), // Thay đổi màu nền
//                                   margin: EdgeInsets.all(6),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(16),
//                                     child: Text(
//                                       certificate[
//                                           'certificateName'], // Hiển thị tên chứng chỉ
//                                       style: TextStyle(
//                                         color: Colors
//                                             .white, // Thay đổi màu chữ sang trắng
//                                         fontSize:
//                                             16, // Cỡ chữ (có thể điều chỉnh)
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),

//               SizedBox(height: 12),

//               // Enrolled Certificate
//               Text('Enrolled Certificates', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 12),
//               isLoadingEnrolled
//                   ? Center(child: CircularProgressIndicator())
//                   : enrolledCertificates.isEmpty
//                       ? Center(child: Text("No enrolled certificates found"))
//                       : Column(
//                           children: enrolledCertificates.map((enrollment) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 8.0),
//                               child: SizedBox(
//                                 width: double
//                                     .infinity, // Card chiếm toàn bộ chiều ngang
//                                 child: Card(
//                                   color: Color(0xFF275998), // Thay đổi màu nền
//                                   margin: EdgeInsets.all(6),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(16),
//                                     child: Text(
//                                       'Certificate ID: ${enrollment['courseId']}', // Hiển thị ID khóa học
//                                       style: TextStyle(
//                                         color: Colors
//                                             .white, // Thay đổi màu chữ sang trắng
//                                         fontSize:
//                                             16, // Cỡ chữ (có thể điều chỉnh)
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to build schedule item
//   Widget buildScheduleItem(
//       String subjectCode, String room, String time, bool isOnline) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Subject Code: $subjectCode'),
//               Text('Room: $room'),
//               Text('Giờ học: $time'),
//             ],
//           ),
//           Row(
//             children: [
//               Container(
//                 width: 10,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   color: isOnline ? Colors.green : Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               SizedBox(width: 5),
//               Text(isOnline ? 'Online' : 'Offline'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

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
  Map<int, int> courseNames = {}; // Để lưu courseId với certificateId từ API Get All Course
  Map<int, String> certificateNames = {}; // Để lưu certificateId với certificateName từ API Certificate

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

        // Sắp xếp danh sách theo độ dài certificateName và chọn 3 certificate ngắn nhất
        List<dynamic> sortedCertificates =
            data.map<dynamic>((certificate) => certificate).toList();

        sortedCertificates.sort((a, b) =>
            a['certificateName'].length.compareTo(b['certificateName'].length));

        // Lấy ra 3 certificate có certificateName ngắn nhất
        setState(() {
          topCertificates =
              sortedCertificates.take(3).toList(); // Lấy 3 certificates
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

      if (courseResponse.statusCode == 200 && courseResponse.data.containsKey('\$values')) {
        var courseData = courseResponse.data['\$values'];
        print('Courses fetched: ${courseData.length} courses found.');

        // Tạo Map chứa courseId với certificateId
        setState(() {
          courseNames = {
            for (var course in courseData)
              course['id']: course['certificateId']
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

      if (certificateResponse.statusCode == 200 && certificateResponse.data.containsKey('\$values')) {
        var certificateData = certificateResponse.data['\$values'];
        print('Certificates fetched: ${certificateData.length} certificates found.');

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
      // Gọi API User để lấy danh sách enrollment của user
      var userResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/User/api/users',
      );

      if (userResponse.statusCode == 200) {
        var userData = userResponse.data;
        print('User data fetched.');

        // Kiểm tra nếu 'enrollments' không null và chứa trường '$values'
        if (userData['enrollments'] != null && userData['enrollments']['\$values'] != null) {
          var userEnrollments = userData['enrollments']['\$values'];
          print('User enrollments fetched: ${userEnrollments.length} enrollments found.');

          if (userEnrollments.isEmpty) {
            setState(() {
              isLoadingEnrolled = false; // Tắt loading nếu không có enrollment
            });
            return;
          }

          // Lấy tất cả thông tin enrollment từ API
          var enrollmentResponse = await Dio().get(
            'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all',
          );

          if (enrollmentResponse.statusCode == 200) {
            var enrollmentsData = enrollmentResponse.data['\$values'];
            print('Enrollments fetched: ${enrollmentsData.length} enrollments found.');

            // Lọc ra các chứng chỉ mà user đã thanh toán thành công (Confirmed)
            var confirmedEnrollments = enrollmentsData.where((enrollment) {
              return userEnrollments.any((userEnrollment) =>
                  userEnrollment['id'] == enrollment['id'] &&
                  enrollment['status'] == 'Confirmed'); // Kiểm tra trạng thái thanh toán
            }).toList();

            if (confirmedEnrollments.isNotEmpty) {
              // Kết hợp courseId với certificateName thông qua certificateId
              setState(() {
                enrolledCertificates = confirmedEnrollments.map((enrollment) {
                  var courseId = enrollment['courseId'];
                  var certificateId = courseNames[courseId];
                  var certificateName = certificateNames[certificateId] ?? 'Unknown Certificate';
                  print('Confirmed enrollment: CourseId: $courseId, CertificateName: $certificateName');
                  return {
                    'courseId': courseId,
                    'certificateName': certificateName,
                    'status': enrollment['status'],
                  };
                }).toList();
                isLoadingEnrolled = false;
              });
            } else {
              print('No confirmed enrollments found.');
              setState(() {
                isLoadingEnrolled = false; // Không có chứng chỉ nào đã thanh toán
              });
            }
          } else {
            setState(() {
              isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
            });
            print("Error fetching enrollments data.");
          }
        } else {
          print("No enrollments found for the user.");
          setState(() {
            isLoadingEnrolled = false; // Tắt loading nếu không có enrollments
          });
        }
      } else {
        setState(() {
          isLoadingEnrolled = false; // Tắt loading nếu gặp lỗi
        });
        print("Error fetching user data.");
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
                        ModuleMM()), // Điều hướng đến SearchScreen
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
              SizedBox(height: 6),

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
              SizedBox(height: 12),

              // Top Certificate List
              Text('Top Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              isLoadingCertificates
                  ? Center(child: CircularProgressIndicator())
                  : topCertificates.isEmpty
                      ? Center(child: Text("No certificates found"))
                      : Column(
                          children: topCertificates.map((certificate) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0),
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

              SizedBox(height: 12),

              // Enrolled Certificate List
              Text('Enrolled Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              isLoadingEnrolled
                  ? Center(child: CircularProgressIndicator())
                  : enrolledCertificates.isEmpty
                      ? Center(child: Text("No enrolled certificates found"))
                      : Column(
                          children: enrolledCertificates.map((enrollment) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Color(0xFF275998),
                                  margin: EdgeInsets.all(6),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Course: ${enrollment['certificateName']}',
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
