import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/enroll.dart';
import 'package:sap_mobile/screens/view_all_material.dart'; // Import view_all_material.dart

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
                  builder: (context) => CertificateDetail(certificates[index]),
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

  CertificateDetail(this.certificate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chứng chỉ C_TS462_MM'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Thêm logic quay lại
          },
        ),
      ),
      body: Padding(
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
            SizedBox(
                height:
                    20), // Khoảng cách giữa vùng ảnh và phần nội dung bên dưới
            Text(
              'Là một chứng chỉ toàn cầu nghiêng về module MM ... abcxyz...',
              style: TextStyle(fontSize: 16),
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
              'Tổng số buổi: 10                Thời gian dự kiến: 5 tuần\nCấp độ: Intermediate',
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

            SizedBox(height: 30),
            Row(
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
                        MaterialPageRoute(builder: (context) => EnrollPage()), // Điều hướng đến TestPage
                      );
                    // Logic khi nhấn "Đăng ký"
                  },
                  child: Text('Đăng ký'),
                ),
              ],
            )
          ],
        ),
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
