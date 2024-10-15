import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/purchase_overview.dart';

class EnrollPage extends StatefulWidget {
  @override
  _EnrollPageState createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  String? selectedClass; // Biến lưu trạng thái của lớp được chọn
  String? selectedTime;
  String? selectedStudents;
  String? selectedLocation;
  String? selectedFee;
  String? selectediddcertificate;
  String? selectedlevel;
  String? selectedsessions;
  String? selectedduration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn lớp'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClassCard(
                        title: 'C_TS462_1',
                        isOnline: true,
                        time: '16h - 17h30 thứ 5\n16h - 17h30 thứ 7',
                        students: '17 / 30',
                        location: 'Google Meet',
                        fee: '2.500.000 vnđ/khóa',
                        isSelected: selectedClass == 'C_TS462_1',
                        iddcertificate:'C_TS462_MM' ,
                        level:'Intermediate' ,
                        sessions:'10' ,
                        duration:'5 tuần' ,
                        onTap: () {
                          setState(() {
                            selectedClass = 'C_TS462_1';
                            selectedTime = '16h - 17h30 thứ 5\n16h - 17h30 thứ 7';
                            selectedStudents = '17 / 30';
                            selectedLocation = 'Google Meet';
                            selectedFee = '2.500.000 vnđ';
                            selectediddcertificate = 'C_TS462_MM';
                            selectedlevel = 'Intermediate';
                            selectedsessions = '10';
                            selectedduration = '5 tuần';
                          });
                        }, 
                      ),
                      ClassCard(
                        title: 'C_TS462_2',
                        isOnline: false,
                        time: '16h - 17h30 thứ 2\n19h - 20h30 thứ 6',
                        students: '17 / 30',
                        location: 'Phòng 210 NVH SV',
                        fee: '3.700.000 vnđ/khóa',
                        iddcertificate: 'C_TS462_MM',
                        level:'Intermediate' ,
                        sessions:'10' ,
                        duration:'5 tuần' ,
                        isSelected: selectedClass == 'C_TS462_2',
                        onTap: () {
                          setState(() {
                            selectedClass = 'C_TS462_2';
                            selectedTime = '16h - 17h30 thứ 2\n19h - 20h30 thứ 6';
                            selectedStudents = '17 / 30';
                            selectedLocation = 'Phòng 210 NVH SV';
                            selectedFee = '3.700.000 vnđ';
                            selectediddcertificate = 'C_TS462_MM';
                            selectedlevel = 'Intermediate';
                            selectedsessions = '10';
                            selectedduration = '5 tuần';
                          });
                        }, 
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Nút 'Tiếp tục' nằm sát dưới cùng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedClass != null
                  ? () {
                      // Điều hướng đến PurchaseOverviewPage với các giá trị đã chọn
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CombinedPurchasePage(
                            className: selectedClass!,
                            schedule: selectedTime!,
                            students: selectedStudents!,
                            location: selectedLocation!,
                            price: selectedFee!,
                            iddcertificate: selectediddcertificate!,
                            level: selectedlevel!,
                            sessions: selectedsessions!,
                            duration: selectedduration!,
                            // idcertificate: selectedIDcertificate!,
                          ),
                        ),
                      );
                    }
                  : null, // Nếu chưa chọn lớp, nút sẽ bị disable
              child: Text('Tiếp tục'),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(double.infinity, 50), // Nút chiếm toàn bộ chiều ngang
                backgroundColor: selectedClass != null
                    ? Colors.blue // Màu xanh biển khi được chọn
                    : Colors.grey, // Màu xám khi chưa chọn
                foregroundColor: selectedClass != null
                    ? Colors.white // Chữ trắng khi được chọn
                    : Colors.black54, // Chữ xám mờ khi chưa chọn
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final bool isOnline;
  final String time;
  final String students;
  final String location;
  final String fee;
  final String iddcertificate;
  final String level;
  final String sessions;
  final String duration;
  final bool isSelected; // Biến xác định thẻ có được chọn hay không
  final VoidCallback onTap; // Hàm gọi lại khi người dùng nhấn vào thẻ

  const ClassCard({
    Key? key,
    required this.title,
    required this.isOnline,
    required this.time,
    required this.students,
    required this.location,
    required this.fee,
    required this.iddcertificate,
    required this.level,
    required this.sessions,
    required this.duration,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Gọi hàm khi người dùng nhấn vào thẻ
      child: SizedBox(
        width: 195,
        height: 240,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSelected
                ? BorderSide(color: Colors.blue, width: 2)
                : BorderSide.none, // Viền khi chọn
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề và trạng thái Online/Offline cùng dòng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17, // Kích thước chữ nhỏ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 15, // Kích thước chữ nhỏ
                        color: isOnline ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '\nGiờ học: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold, // In đậm
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal, // Chữ bình thường
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Học viên: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold, // In đậm
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: students,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal, // Chữ bình thường
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Địa điểm học: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold, // In đậm
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$location',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal, // Chữ bình thường
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Chi phí: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold, // In đậm
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$fee',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal, // Chữ bình thường
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}