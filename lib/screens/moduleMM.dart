import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/enroll.dart';
import 'package:sap_mobile/screens/quiz.dart';
import 'package:sap_mobile/screens/view_all_material.dart'; // Import view_all_material.dart
import 'package:sap_mobile/screens/purchase_overview.dart';

class ModuleMM extends StatefulWidget {
  @override
  _ModuleMMState createState() => _ModuleMMState();
}

class _ModuleMMState extends State<ModuleMM> {
  List<dynamic> certificates = []; // Dữ liệu lấy từ API sẽ được lưu ở đây
  List<dynamic> topicAreas = []; // Dữ liệu Topic Area từ API
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
      if (certificateResponse.data != null && certificateResponse.data.containsKey('\$values') &&
          topicAreaResponse.data != null && topicAreaResponse.data.containsKey('\$values')) {
        setState(() {
          certificates = List.from(certificateResponse.data['\$values']); // Lấy dữ liệu certificates
          topicAreas = List.from(topicAreaResponse.data['\$values']); // Lấy dữ liệu topic areas
          isLoading = false; // Tắt trạng thái loading
        });
      } else {
        print('Error: Dữ liệu trả về không chứa trường "\$values"');
        setState(() {
          isLoading = false;
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
        title: Text('MM Certificates'),
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
                              className: 'C_TS462_1',
                              level: certificate['level'] ?? 'Intermediate', // Ví dụ cấp độ, lấy từ API
                              duration: '5 tuần', // Thời gian dự kiến
                              location: 'Google Meet', // Địa điểm
                              fee: '2.500.000', // Chi phí
                              statusfee: 'vnđ/ khóa',
                              idcertificate: '',
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
  final String className;
  final String level;
  final String duration;
  final String location;
  final String fee;
  final String statusfee;
  final String idcertificate;
  final List<dynamic> topics; // Danh sách Topic Areas liên quan đến chứng chỉ

  CertificateDetail(
    this.certificate, {
    required this.className,
    required this.level,
    required this.duration,
    required this.location,
    required this.fee,
    required this.statusfee,
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
                    'Các khóa học trong Certificate',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...topics.map((topic) => CourseItem(courseName: topic['topicName'])).toList(), // Hiển thị các Topic Area
                  SizedBox(height: 10),
                  Text(
                    'Cấp độ: $level                  Thời gian dự kiến: $duration',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Chứng chỉ sau khóa học',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EnrollPage()),
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
                      'Đăng ký',
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