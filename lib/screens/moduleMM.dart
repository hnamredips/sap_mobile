import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/enroll.dart';
import 'package:sap_mobile/screens/view_all_material.dart'; // Import view_all_material.dart
import 'package:sap_mobile/screens/purchase_overview.dart';

class ModuleMM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CertificateList();
  }
}

class CertificateList extends StatelessWidget {
  final List<String> certificates = [
    'SAP Certified Application Associate - Procurement with SAP ERP',
    'SAP Certified Application Associate - Procurement with SAP S/4HANA',
    'SAP Certified Application Associate - Inventory Management and Physical Inventory with SAP ERP',
    'SAP Certified Application Associate - Inventory Management and Physical Inventory with SAP S/4HANA',
    'SAP Certified Application Associate - Material Valuation with SAP ERP',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MM (6 Certificates)'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icon quay lại
          onPressed: () {
            // Điều hướng về ViewAllMaterial khi nhấn nút trở lại
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CertificateDetail(
                    certificates[index],
                    className: 'C_TS462_1',
                    level: 'Intermediate', // Ví dụ cấp độ
                    sessions: 10, // Tổng số buổi
                    duration: '5 tuần', // Thời gian dự kiến
                    location: 'Google Meet', // Địa điểm
                    fee: '2.500.000', // Chi phí
                    statusfee: 'vnđ/ khóa',
                    idcertificate: 'C_TS462_MM',
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(certificates[index]),
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
  final int sessions;
  final String duration;
  final String location;
  final String fee;
  final String statusfee;
  final String idcertificate;

  CertificateDetail(
    this.certificate, {
    required this.className,
    required this.level,
    required this.sessions,
    required this.duration,
    required this.location,
    required this.fee,
    required this.statusfee,
    required this.idcertificate,
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
            // Thêm logic quay lại
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
                  // Vùng trống hình chữ nhật để thêm ảnh sau
                  Container(
                    height: 200, // Chiều cao cố định cho vùng ảnh
                    width: double.infinity, // Chiều rộng toàn màn hình
                    color: Colors.grey[300], // Màu nền tạm thời
                    child: Center(
                      child: Text(
                        'Vùng để thêm ảnh',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Các khóa học trong Certificate',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CourseItem(courseName: 'Master Data in SAP MM', session: 3),
                  CourseItem(courseName: 'Procurement Process', session: 2),
                  CourseItem(courseName: 'Inventory Management', session: 3),
                  CourseItem(courseName: 'Invoice Verification', session: 2),
                  SizedBox(height: 20),
                  Text(
                    'Tổng số buổi: $sessions                Thời gian dự kiến: $duration\nCấp độ: $level',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Chứng chỉ sau khóa học',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100, // Chiều cao 120
                    width: 170, // Chiều rộng 200
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$idcertificate',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic khi nhấn "Test thử"
                  },
                  child: Text('Flashcard'),
                ),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnrollPage()), // Điều hướng đến EnrollPage
                  );
                },
                child: Text('Đăng ký'),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String courseName;
  final int session;

  const CourseItem({required this.courseName, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(courseName, style: TextStyle(fontSize: 16)),
            Text('$session buổi', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
