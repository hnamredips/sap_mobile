// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:sap_mobile/screens/enroll.dart';
// import 'package:sap_mobile/screens/quiz.dart';
// import 'package:sap_mobile/screens/view_all_material.dart'; // Import view_all_material.dart
// import 'package:sap_mobile/screens/purchase_overview.dart';
// import 'package:sap_mobile/screens/home_page.dart';

// class ModuleMM extends StatefulWidget {
//  @override
//  _ModuleMMState createState() => _ModuleMMState();
// }

// class _ModuleMMState extends State<ModuleMM> {
//  List<dynamic> certificates = []; // Dữ liệu lấy từ API sẽ được lưu ở đây
//  List<dynamic> topicAreas = []; // Dữ liệu Topic Area từ API
//  bool isLoading = true; // Trạng thái loading

//  @override
//  void initState() {
//    super.initState();
//    fetchCertificatesAndTopics(); // Gọi API khi màn hình khởi động
//  }

//  // Hàm gọi API bằng Dio để lấy cả Certificates và Topic Areas
// Future<void> fetchCertificatesAndTopics() async {
//  try {
//    var certificateResponse = await Dio().get(
//      'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
//    );
//    var topicAreaResponse = await Dio().get(
//      'https://swdsapelearningapi.azurewebsites.net/api/TopicArea/get-all',
//    );

//    // Kiểm tra dữ liệu phản hồi từ API
//    if (certificateResponse.data != null &&
//        certificateResponse.data.containsKey('\$values') &&
//        topicAreaResponse.data != null &&
//        topicAreaResponse.data.containsKey('\$values')) {
   
//      // Lọc certificates để chỉ giữ các chứng chỉ có moduleId chứa 14
//      var filteredCertificates = certificateResponse.data['\$values']
//          .where((certificate) =>
//              certificate['moduleIds'] != null &&
//              certificate['moduleIds'].containsKey('\$values') &&
//              certificate['moduleIds']['\$values'].contains(14)
//          ).toList();

//      var filteredTopicAreas = topicAreaResponse.data['\$values']
//          .where((topic) => topic['certificateId'] != null &&
//              filteredCertificates.any((cert) => cert['id'] == topic['certificateId'])
//          ).toList();

//      setState(() {
//        certificates = filteredCertificates; // Chứng chỉ có moduleId = 14
//        topicAreas = filteredTopicAreas; // Lấy topic areas có liên quan đến các chứng chỉ lọc được
//        isLoading = false; // Tắt trạng thái loading
//      });
//    } else {
//      print('Error: Dữ liệu trả về không chứa trường "\$values"');
//      setState(() {
//        isLoading = false;
//      });
//    }
//  } catch (e) {
//    print('Error fetching data: $e');
//    setState(() {
//      isLoading = false; // Tắt loading kể cả khi có lỗi
//    });
//  }
// }


//  // Lọc danh sách Topic Areas dựa trên certificateId
//  List<dynamic> getTopicsByCertificateId(int certificateId) {
//    return topicAreas.where((topic) => topic['certificateId'] == certificateId).toList();
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('MM Certificates'),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back), // Icon quay lại
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//      ),
//      body: isLoading
//          ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải dữ liệu
//          : certificates.isEmpty
//              ? Center(child: Text("No certificates found")) // Thông báo nếu không có chứng chỉ
//              : ListView.builder(
//                  itemCount: certificates.length,
//                  itemBuilder: (context, index) {
//                    var certificate = certificates[index];
//                    return GestureDetector(
//                      onTap: () {
//                        // Khi nhấn vào chứng chỉ, điều hướng đến trang chi tiết và truyền các thông tin cần thiết
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => CertificateDetail(
//                              certificate['certificateName'], // Lấy tên chứng chỉ từ API
//                              level: certificate['level'] ?? 'Intermediate', // Ví dụ cấp độ, lấy từ API
//                              idcertificate: '',
//                              topics: getTopicsByCertificateId(certificate['id']), // Truyền danh sách topic area
//                            ),
//                          ),
//                        );
//                      },
//                      child: Card(
//                        color: Color(0xFF275998), // Thay đổi màu nền
//                        margin: EdgeInsets.all(6),
//                        child: Padding(
//                          padding: EdgeInsets.all(16),
//                          child: Text(
//                            certificate['certificateName'], // Hiển thị tên chứng chỉ
//                            style: TextStyle(
//                              color: Colors.white, // Thay đổi màu chữ sang trắng
//                              fontSize: 16, // Cỡ chữ (có thể điều chỉnh)
//                            ),
//                          ),
//                        ),
//                      ),
//                    );
//                  },
//                ),
//    );
//  }
// }

// class CertificateDetail extends StatelessWidget {
//  final String certificate;
//  final String level;
//  final String idcertificate;
//  final List<dynamic> topics; // Danh sách Topic Areas liên quan đến chứng chỉ

//  CertificateDetail(
//    this.certificate, {
//    required this.level,
//    required this.idcertificate,
//    required this.topics, // Nhận danh sách topics từ constructor
//  });

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(certificate),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//      ),
//      body: Column(
//        children: <Widget>[
//          Expanded(
//            child: SingleChildScrollView(
//              padding: const EdgeInsets.all(16.0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    height: 200, // Chiều cao cố định cho vùng ảnh
//                    width: double.infinity, // Chiều rộng toàn màn hình
//                    color: Colors.grey[300], // Màu nền tạm thời
//                    child: Center(
//                      child: Image.asset(
//                        'assets/images/a1.png', // Đường dẫn đến hình ảnh
//                        fit: BoxFit.contain, // Điều chỉnh hình ảnh để vừa với vùng chứa
//                      ),
//                    ),
//                  ),
//                  SizedBox(height: 20),
//                  Text(
//                    'Topic Area',
//                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                  ),
//                  SizedBox(height: 10),
//                  ...topics.map((topic) => CourseItem(courseName: topic['topicName'])).toList(), // Hiển thị các Topic Area
//                  SizedBox(height: 10),
//                  Text(
//                    'Level: $level',
//                    style: TextStyle(fontSize: 18),
//                  ),
//                  SizedBox(height: 15),
//                  Text(
//                    'Certificate',
//                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                  ),
//                  SizedBox(height: 10),
//                  Container(
//                    height: 100, // Chiều cao 100
//                    width: 170, // Chiều rộng 170
//                    color: Colors.grey[300],
//                    child: Center(
//                      child: Image.asset(
//                        'assets/images/certification.jpg', // Đường dẫn đến hình ảnh
//                        fit: BoxFit.contain, // Điều chỉnh hình ảnh vừa với khung chứa
//                      ),
//                    ),
//                  ),
//                  SizedBox(height: 8),
//                 //  Text(
//                 //    '$idcertificate',
//                 //    style: TextStyle(fontSize: 14),
//                 //  ),
//                  SizedBox(height: 20),
//                ],
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Expanded(
//                  child: ElevatedButton(
//                    onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => Quiz()),
//                      );
//                    },
//                    style: ElevatedButton.styleFrom(
//                      backgroundColor: Color(0xFF275998), // Màu nền
//                      foregroundColor: Colors.white,
//                      padding: EdgeInsets.symmetric(vertical: 15), // Chiều cao nút
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30.0), // Làm tròn góc nút
//                      ),
//                    ),
//                    child: Text(
//                      'Quiz',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//                SizedBox(width: 20), // Khoảng cách giữa hai nút
//                Expanded(
//                  child: ElevatedButton(
//                    onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => EnrollPage()),
//                      );
//                    },
//                    style: ElevatedButton.styleFrom(
//                      backgroundColor: Color(0xFF275998), // Màu nền
//                      foregroundColor: Colors.white,
//                      padding: EdgeInsets.symmetric(vertical: 15), // Chiều cao nút
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30.0), // Làm tròn góc nút
//                      ),
//                    ),
//                    child: Text(
//                      'Enroll',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//  }
// }

// class CourseItem extends StatelessWidget {
//  final String courseName;

//  const CourseItem({required this.courseName});

//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      child: Padding(
//        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Text(courseName, style: TextStyle(fontSize: 16)),
//          ],
//        ),
//      ),
//    );
//  }
// }



import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/enroll.dart';
import 'package:sap_mobile/screens/quiz.dart';

class ModuleMM extends StatefulWidget {
  final int moduleId; // ID của module
  final String moduleName; // Tên của module

  ModuleMM({required this.moduleId, required this.moduleName}); // Constructor

  @override
  _ModuleMMState createState() => _ModuleMMState();
}

class _ModuleMMState extends State<ModuleMM> {
  List<dynamic> certificates = []; // Dữ liệu lấy từ API sẽ được lưu ở đây
  List<dynamic> topicAreas = []; // Dữ liệu Topic Area từ API
  List<dynamic> filteredCourses = []; // Khai báo biến filteredCourses
  List<dynamic> onlineClasses = []; // Khai báo biến onlineClasses
  List<dynamic> offlineClasses = []; // Khai báo biến offlineClasses
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    fetchCertificatesAndTopics(); // Gọi API khi màn hình khởi động
  }

  // Hàm gọi API bằng Dio để lấy cả Certificates và Topic Areas
  Future<void> fetchCertificatesAndTopics() async {
    try {
      var certificateResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
      );
      var topicAreaResponse = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/TopicArea/get-all',
      );

      // Kiểm tra dữ liệu phản hồi từ API
      if (certificateResponse.data != null &&
          certificateResponse.data.containsKey('\$values') &&
          topicAreaResponse.data != null &&
          topicAreaResponse.data.containsKey('\$values')) {
        
        // Lọc certificates để chỉ giữ các chứng chỉ có moduleId chứa moduleId từ tham số
        var filteredCertificates = certificateResponse.data['\$values']
            .where((certificate) =>
                certificate['moduleIds'] != null &&
                certificate['moduleIds'].containsKey('\$values') &&
                certificate['moduleIds']['\$values'].contains(widget.moduleId) // Sử dụng widget.moduleId
            ).toList();

        var filteredTopicAreas = topicAreaResponse.data['\$values']
            .where((topic) => topic['certificateId'] != null &&
                filteredCertificates.any((cert) => cert['id'] == topic['certificateId'])
            ).toList();

        setState(() {
  certificates = filteredCertificates; // Chứng chỉ có moduleId = widget.moduleId
  topicAreas = filteredTopicAreas; // Lấy topic areas có liên quan đến các chứng chỉ lọc được
  filteredCourses = []; // Khởi tạo hoặc cập nhật filteredCourses
  onlineClasses = []; // Khởi tạo hoặc cập nhật onlineClasses
  offlineClasses = []; // Khởi tạo hoặc cập nhật offlineClasses

  // Lọc khóa học cho chứng chỉ
  for (var certificate in certificates) {
    var coursesForCertificate = filteredCourses.where((course) => course['certificateId'] == certificate['id']).toList();
    onlineClasses.addAll(coursesForCertificate.where((classData) => classData['mode'] == "online" && classData['status'] == true));
    offlineClasses.addAll(coursesForCertificate.where((classData) => classData['mode'] == "offline" && classData['status'] == true));
  }

  isLoading = false; // Tắt trạng thái loading
});

      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Tắt loading kể cả khi có lỗi
      });
    }
  }

  // Lọc danh sách Topic Areas dựa trên certificateId
  List<dynamic> getTopicsByCertificateId(int certificateId) {
    return topicAreas.where((topic) => topic['certificateId'] == certificateId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        
          title: Text('${widget.moduleName} Certificates'),
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        title: Text('${widget.moduleName} Certificates'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icon quay lại
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải dữ liệu
          : certificates.isEmpty
              ? Center(child: Text("No certificates found")) // Thông báo nếu không có chứng chỉ
              : ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    var certificate = certificates[index];
                    return GestureDetector(
                      onTap: () {
                        // Khi nhấn vào chứng chỉ, điều hướng đến trang chi tiết và truyền các thông tin cần thiết
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CertificateDetail(
                              certificate['certificateName'], // Lấy tên chứng chỉ từ API
                              level: certificate['level'] ?? 'Intermediate', // Ví dụ cấp độ, lấy từ API
                              idcertificate: certificate['id'], // Truyền certificateId
                              topics: getTopicsByCertificateId(certificate['id']), // Truyền danh sách topic area
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Color(0xFF275998), // Thay đổi màu nền
                        margin: EdgeInsets.all(6),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            certificate['certificateName'], // Hiển thị tên chứng chỉ
                            style: TextStyle(
                              color: Colors.white, // Thay đổi màu chữ sang trắng
                              fontSize: 16, // Cỡ chữ (có thể điều chỉnh)
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class CertificateDetail extends StatelessWidget {
  final String certificate;
  final String level;
  final int idcertificate; // Thay đổi thành int để sử dụng trong điều hướng EnrollPage
  final List<dynamic> topics; // Danh sách Topic Areas liên quan đến chứng chỉ

  CertificateDetail(
    this.certificate, {
    required this.level,
    required this.idcertificate,
    required this.topics, // Nhận danh sách topics từ constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(certificate),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 200, // Chiều cao cố định cho vùng ảnh
                    width: double.infinity, // Chiều rộng toàn màn hình
                    color: Colors.grey[300], // Màu nền tạm thời
                    child: Center(
                      child: Image.asset(
                        'assets/images/a1.png', // Đường dẫn đến hình ảnh
                        fit: BoxFit.contain, // Điều chỉnh hình ảnh để vừa với vùng chứa
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Topic Area',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...topics.map((topic) => CourseItem(courseName: topic['topicName'])).toList(), // Hiển thị các Topic Area
                  SizedBox(height: 10),
                  Text(
                    'Level: $level',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Certificate',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100, // Chiều cao 100
                    width: 170, // Chiều rộng 170
                    color: Colors.grey[300],
                    child: Center(
                      child: Image.asset(
                        'assets/images/certification.jpg', // Đường dẫn đến hình ảnh
                        fit: BoxFit.contain, // Điều chỉnh hình ảnh vừa với khung chứa
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$idcertificate',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Quiz()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF275998), // Màu nền
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15), // Chiều cao nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Làm tròn góc nút
                      ),
                    ),
                    child: Text(
                      'Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Khoảng cách giữa hai nút
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Điều hướng sang EnrollPage và truyền certificateId đã chọn
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnrollPage(
                            certificateId: idcertificate,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF275998), // Màu nền
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15), // Chiều cao nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Làm tròn góc nút
                      ),
                    ),
                    child: Text(
                      'Enroll',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String courseName;

  const CourseItem({required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(courseName, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
