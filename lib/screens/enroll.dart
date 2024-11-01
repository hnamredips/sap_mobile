import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/purchase_overview.dart';

class EnrollPage extends StatefulWidget {
  @override
  _EnrollPageState createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  String? selectedClass;
  String? selectedTime;
  String? selectedStudents;
  String? selectedLocation;
  String? selectedFee;
  String? selectediddcertificate;
  String? selectedlevel;
  String? selectedsessions;
  String? selectedduration;
  bool showOnline = true; // Biến để chuyển đổi giữa lớp Online và Offline

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose class'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOnline = true;
                    });
                  },
                  child: Text(
                    'Online',
                    style: TextStyle(
                      color: showOnline ? Colors.white : Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    backgroundColor: showOnline ? Color(0xFF275998) : Colors.grey[300],
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOnline = false;
                    });
                  },
                  child: Text(
                    'Offline',
                    style: TextStyle(
                      color: !showOnline ? Colors.white : Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    backgroundColor: !showOnline ? Color(0xFF275998) : Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 0, // Khoảng cách giữa các ClassCard theo chiều ngang
                runSpacing: 2.0, // Khoảng cách giữa các hàng ClassCard
                children: [
                  if (showOnline) ...[
                    ClassCard(
                      title: 'C_TS462_A1',
                      isOnline: true,
                      time: '16h - 17h30 thứ 5\n16h - 17h30 thứ 7',
                      students: '17 / 30',
                      location: 'Google Meet',
                      fee: '2.500.000 vnđ/khóa',
                      isSelected: selectedClass == 'C_TS462_A1',
                      iddcertificate: 'C_TS462_MM',
                      level: 'Intermediate',
                      sessions: '10',
                      duration: '5 tuần',
                      onTap: () {
                        setState(() {
                          selectedClass = 'C_TS462_A1';
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
                      title: 'C_TS462_A2',
                      isOnline: true,
                      time: '18h - 19h30 thứ 2\n18h - 19h30 thứ 4',
                      students: '15 / 30',
                      location: 'Google Meet',
                      fee: '2.800.000 vnđ/khóa',
                      isSelected: selectedClass == 'C_TS462_A2',
                      iddcertificate: 'C_TS462_MM',
                      level: 'Advanced',
                      sessions: '12',
                      duration: '6 tuần',
                      onTap: () {
                        setState(() {
                          selectedClass = 'C_TS462_A2';
                          selectedTime = '18h - 19h30 thứ 2\n18h - 19h30 thứ 4';
                          selectedStudents = '15 / 30';
                          selectedLocation = 'Google Meet';
                          selectedFee = '2.800.000 vnđ';
                          selectediddcertificate = 'C_TS462_MM';
                          selectedlevel = 'Advanced';
                          selectedsessions = '12';
                          selectedduration = '6 tuần';
                        });
                      },
                    ),
                  ] else ...[
                    ClassCard(
                      title: 'C_TS462_B1',
                      isOnline: false,
                      time: '16h - 17h30 thứ 2\n19h - 20h30 thứ 6',
                      students: '17 / 30',
                      location: 'Phòng 210 NVH SV',
                      fee: '3.700.000 vnđ/khóa',
                      iddcertificate: 'C_TS462_MM',
                      level: 'Intermediate',
                      sessions: '10',
                      duration: '5 tuần',
                      isSelected: selectedClass == 'C_TS462_B1',
                      onTap: () {
                        setState(() {
                          selectedClass = 'C_TS462_B1';
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
                    ClassCard(
                      title: 'C_TS462_B2',
                      isOnline: false,
                      time: '17h - 18h30 thứ 3\n17h - 18h30 thứ 5',
                      students: '20 / 30',
                      location: 'Phòng 310 NVH SV',
                      fee: '4.000.000 vnđ/khóa',
                      iddcertificate: 'C_TS462_MM',
                      level: 'Advanced',
                      sessions: '12',
                      duration: '6 tuần',
                      isSelected: selectedClass == 'C_TS462_B2',
                      onTap: () {
                        setState(() {
                          selectedClass = 'C_TS462_B2';
                          selectedTime = '17h - 18h30 thứ 3\n17h - 18h30 thứ 5';
                          selectedStudents = '20 / 30';
                          selectedLocation = 'Phòng 310 NVH SV';
                          selectedFee = '4.000.000 vnđ';
                          selectediddcertificate = 'C_TS462_MM';
                          selectedlevel = 'Advanced';
                          selectedsessions = '12';
                          selectedduration = '6 tuần';
                        });
                      },
                    ),
                    ClassCard(
                      title: 'C_TS462_B3',
                      isOnline: false,
                      time: '19h - 20h30 thứ 4\n19h - 20h30 thứ 7',
                      students: '12 / 30',
                      location: 'Phòng 410 NVH SV',
                      fee: '3.500.000 vnđ/khóa',
                      iddcertificate: 'C_TS462_MM',
                      level: 'Beginner',
                      sessions: '8',
                      duration: '4 tuần',
                      isSelected: selectedClass == 'C_TS462_B3',
                      onTap: () {
                        setState(() {
                          selectedClass = 'C_TS462_B3';
                          selectedTime = '19h - 20h30 thứ 4\n19h - 20h30 thứ 7';
                          selectedStudents = '12 / 30';
                          selectedLocation = 'Phòng 410 NVH SV';
                          selectedFee = '3.500.000 vnđ';
                          selectediddcertificate = 'C_TS462_MM';
                          selectedlevel = 'Beginner';
                          selectedsessions = '8';
                          selectedduration = '4 tuần';
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Hiển thị lớp đã chọn
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              selectedClass != null
                  ? 'Course selected: $selectedClass'
                  : 'No class selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                          ),
                        ),
                      );
                    }
                  : null, // Nếu chưa chọn lớp, nút sẽ bị disable
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: selectedClass != null
                    ? Color(0xFF275998) // Màu xanh biển khi được chọn
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
        width: 185, //195
        height: 240, //240
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
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: students,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$location',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\n$fee',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
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
