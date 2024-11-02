// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:sap_mobile/screens/purchase_overview.dart';

// class EnrollPage extends StatefulWidget {
//   @override
//   _EnrollPageState createState() => _EnrollPageState();
// }

// class _EnrollPageState extends State<EnrollPage> {
//   String? selectedClass;
//   String? selectedTime;
//   String? selectedStudents;
//   String? selectedLocation;
//   String? selectedFee;
//   String? selectediddcertificate;
//   String? selectedlevel;
//   String? selectedsessions;
//   String? selectedduration;
//   String? selectedinstructorName;
//   bool showOnline = true;
//   List<dynamic> onlineClasses = [];
//   List<dynamic> offlineClasses = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     print("Starting fetchData...");
//     try {
//       final response21 = await http.get(
//         Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/21'),
//       );

//       final response22 = await http.get(
//         Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/22'),
//       );

//       final response23 = await http.get(
//         Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/23'),
//       );

//       if (response21.statusCode == 200 && response22.statusCode == 200 && response23.statusCode == 200) {
//         final data21 = json.decode(response21.body);
//         final data22 = json.decode(response22.body);
//         final data23 = json.decode(response23.body);

//         List<dynamic> courses = [];

//         if (data21 is List<dynamic>) {
//           courses.addAll(data21);
//         } else {
//           courses.add(data21);
//         }

//         if (data22 is List<dynamic>) {
//           courses.addAll(data22);
//         } else {
//           courses.add(data22);
//         }

//         setState(() {
//           onlineClasses = courses
//               .where((classData) =>
//                   classData['mode'] == "online" && classData['status'] == true)
//               .toList();
//         });

//         List<dynamic> coursesOffline = [];
//         if (data23 is List<dynamic>) {
//           coursesOffline.addAll(data23);
//         } else {
//           coursesOffline.add(data23);
//         }

//         setState(() {
//           offlineClasses = coursesOffline
//               .where((classData) =>
//                   classData['mode'] == "offline" && classData['status'] == true)
//               .toList();
//         });

//         print("Filtered onlineClasses: $onlineClasses");
//         print("Filtered offlineClasses: $offlineClasses");
//       } else {
//         throw Exception('Failed to load course data');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   String formatDate(String date) {
//     return date.substring(0, 10); 
//   }

//   String formatCurrency(int price) {
//     final format = NumberFormat('#,###', 'en_US');
//     return format.format(price);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('List of classes'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         showOnline = true;
//                       });
//                     },
//                     child: Text(
//                       'Online',
//                       style: TextStyle(
//                         color: showOnline ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(150, 50),
//                       backgroundColor:
//                           showOnline ? Color(0xFF275998) : Colors.grey[300],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         showOnline = false;
//                       });
//                     },
//                     child: Text(
//                       'Offline',
//                       style: TextStyle(
//                         color: !showOnline ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(150, 50),
//                       backgroundColor:
//                           !showOnline ? Color(0xFF275998) : Colors.grey[300],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Wrap(
//                 spacing: 0,
//                 runSpacing: 5.0,
//                 children: [
//                   if (showOnline && onlineClasses.isNotEmpty) ...[
//                     for (var classData in onlineClasses) ...[
//                       ClassCard(
//                         title: classData['courseName'] ?? 'Không có tên',
//                         certificateName: classData['certificateName'] ?? 'Không có thông tin',
//                         instructorName: classData['instructorName'] ?? 'Không có thông tin',
//                         isOnline: true,
//                         startTime: formatDate(classData['startTime']),
//                         endTime: formatDate(classData['endTime']),
//                         location: classData['location'] ?? 'Không có thông tin',
//                         fee: formatCurrency(classData['price']),
//                         isSelected: selectedClass == classData['courseName'],
//                         onTap: () {
//                           setState(() {
//                             selectedClass = classData['courseName'];
//                             selectedTime = formatDate(classData['startTime']) + ' - ' + formatDate(classData['endTime']);
//                             selectedStudents = 'Thông tin học viên';
//                             selectedLocation = classData['location'] ?? 'Không có thông tin';
//                             selectedFee = formatCurrency(classData['price']);
//                             selectediddcertificate = classData['certificateName'] ?? 'Không có thông tin';
//                             selectedlevel = classData['level'] ?? 'Không có thông tin';
//                             selectedsessions = classData['sessions'].toString();
//                             selectedduration = classData['duration'] ?? 'Không có thông tin';
//                             selectedinstructorName = classData['instructorName'] ?? 'Không có thông tin';
//                           });
//                         },
//                       ),
//                     ],
//                   ] else if (!showOnline && offlineClasses.isNotEmpty) ...[
//                     for (var classData in offlineClasses) ...[
//                       ClassCard(
//                         title: classData['courseName'] ?? 'Không có tên',
//                         certificateName: classData['certificateName'] ?? 'Không có thông tin',
//                         instructorName: classData['instructorName'] ?? 'Không có thông tin',
//                         isOnline: false,
//                         startTime: formatDate(classData['startTime']),
//                         endTime: formatDate(classData['endTime']),
//                         location: classData['location'] ?? 'Không có thông tin',
//                         fee: formatCurrency(classData['price']),
//                         isSelected: selectedClass == classData['courseName'],
//                         onTap: () {
//                           setState(() {
//                             selectedClass = classData['courseName'];
//                             selectedTime = formatDate(classData['startTime']) + ' - ' + formatDate(classData['endTime']);
//                             selectedStudents = 'Thông tin học viên';
//                             selectedLocation = classData['location'] ?? 'Không có thông tin';
//                             selectedFee = formatCurrency(classData['price']);
//                             selectediddcertificate = classData['certificateName'] ?? 'Không có thông tin';
//                             selectedlevel = classData['level'] ?? 'Không có thông tin';
//                             selectedsessions = classData['sessions'].toString();
//                             selectedduration = classData['duration'] ?? 'Không có thông tin';
//                             selectedinstructorName = classData['instructorName'] ?? 'Không có thông tin';
//                           });
//                         },
//                       ),
//                     ],
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               selectedClass != null
//                   ? 'Selected classes: $selectedClass'
//                   : 'Please select a class',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: selectedClass != null
//                   ? () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CombinedPurchasePage(
//                             className: selectedClass!,
//                             schedule: selectedTime!,
//                             students: selectedStudents!,
//                             location: selectedLocation!,
//                             price: selectedFee!,
//                             iddcertificate: selectediddcertificate!,
//                             level: selectedlevel!,
//                             sessions: selectedsessions!,
//                             duration: selectedduration!,
//                             instructorName: selectedinstructorName!,
//                           ),
//                         ),
//                       );
//                     }
//                   : null, // Nếu chưa chọn lớp, nút sẽ bị disable
//               child: Text('Continue'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//                 backgroundColor: selectedClass != null
//                     ? Color(0xFF275998) // Màu xanh biển khi được chọn
//                     : Colors.grey, // Màu xám khi chưa chọn
//                 foregroundColor: selectedClass != null
//                     ? Colors.white // Chữ trắng khi được chọn
//                     : Colors.black54, // Chữ xám mờ khi chưa chọn
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ClassCard extends StatelessWidget {
//   final String title;
//   final String certificateName;
//   final String instructorName;
//   final bool isOnline;
//   final String startTime;
//   final String endTime;
//   final String location;
//   final String fee;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const ClassCard({
//     Key? key,
//     required this.title,
//     required this.certificateName,
//     required this.instructorName,
//     required this.isOnline,
//     required this.startTime,
//     required this.endTime,
//     required this.location,
//     required this.fee,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: 350,
//         height: 230,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: isSelected
//                 ? BorderSide(color: Colors.blue, width: 2)
//                 : BorderSide.none,
//           ),
//           elevation: 3,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Certificate: ',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: certificateName,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Lecturer: ',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: instructorName,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.normal,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Start Time: ',
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: startTime,
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     text: 'End Time: ',
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: endTime,
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Location: ',
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: location,
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Price: ',
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: '$fee VND',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  String? selectedinstructorName;
  bool showOnline = true;
  List<dynamic> onlineClasses = [];
  List<dynamic> offlineClasses = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("Starting fetchData...");
    try {
      final response21 = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/21'),
      );

      final response22 = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/22'),
      );

      final response23 = await http.get(
        Uri.parse('https://swdsapelearningapi.azurewebsites.net/api/Course/23'),
      );

      if (response21.statusCode == 200 && response22.statusCode == 200 && response23.statusCode == 200) {
        final data21 = json.decode(response21.body);
        final data22 = json.decode(response22.body);
        final data23 = json.decode(response23.body);

        List<dynamic> courses = [];

        if (data21 is List<dynamic>) {
          courses.addAll(data21);
        } else {
          courses.add(data21);
        }

        if (data22 is List<dynamic>) {
          courses.addAll(data22);
        } else {
          courses.add(data22);
        }

        setState(() {
          onlineClasses = courses
              .where((classData) =>
                  classData['mode'] == "online" && classData['status'] == true)
              .toList();
        });

        List<dynamic> coursesOffline = [];
        if (data23 is List<dynamic>) {
          coursesOffline.addAll(data23);
        } else {
          coursesOffline.add(data23);
        }

        setState(() {
          offlineClasses = coursesOffline
              .where((classData) =>
                  classData['mode'] == "offline" && classData['status'] == true)
              .toList();
        });

        print("Filtered onlineClasses: $onlineClasses");
        print("Filtered offlineClasses: $offlineClasses");
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String formatDate(String date) {
    return date.substring(0, 10); 
  }

  String formatCurrency(int price) {
    final format = NumberFormat('#,###', 'en_US');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of classes'),
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
                Expanded(
                  child: ElevatedButton(
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
                      backgroundColor:
                          showOnline ? Color(0xFF275998) : Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
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
                      backgroundColor:
                          !showOnline ? Color(0xFF275998) : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 0,
                runSpacing: 5.0,
                children: [
                  if (showOnline && onlineClasses.isNotEmpty) ...[
                    for (var classData in onlineClasses) ...[
                      ClassCard(
                        title: classData['courseName'] ?? 'Không có tên',
                        certificateName: classData['certificateName'] ?? 'Không có thông tin',
                        instructorName: classData['instructorName'] ?? 'Không có thông tin',
                        isOnline: true,
                        startTime: formatDate(classData['startTime']),
                        endTime: formatDate(classData['endTime']),
                        location: classData['location'] ?? 'Không có thông tin',
                        fee: formatCurrency(classData['price']),
                        isSelected: selectedClass == classData['courseName'],
                        onTap: () {
                          setState(() {
                            selectedClass = classData['courseName'];
                            selectedTime = formatDate(classData['startTime']) + ' - ' + formatDate(classData['endTime']);
                            selectedStudents = 'Thông tin học viên';
                            selectedLocation = classData['location'] ?? 'Không có thông tin';
                            selectedFee = formatCurrency(classData['price']);
                            selectediddcertificate = classData['certificateName'] ?? 'Không có thông tin';
                            selectedlevel = classData['level'] ?? 'Không có thông tin';
                            selectedsessions = classData['sessions'].toString();
                            selectedduration = classData['duration'] ?? 'Không có thông tin';
                            selectedinstructorName = classData['instructorName'] ?? 'Không có thông tin';
                          });
                        },
                      ),
                    ],
                  ] else if (!showOnline && offlineClasses.isNotEmpty) ...[
                    for (var classData in offlineClasses) ...[
                      ClassCard(
                        title: classData['courseName'] ?? 'Không có tên',
                        certificateName: classData['certificateName'] ?? 'Không có thông tin',
                        instructorName: classData['instructorName'] ?? 'Không có thông tin',
                        isOnline: false,
                        startTime: formatDate(classData['startTime']),
                        endTime: formatDate(classData['endTime']),
                        location: classData['location'] ?? 'Không có thông tin',
                        fee: formatCurrency(classData['price']),
                        isSelected: selectedClass == classData['courseName'],
                        onTap: () {
                          setState(() {
                            selectedClass = classData['courseName'];
                            selectedTime = formatDate(classData['startTime']) + ' - ' + formatDate(classData['endTime']);
                            selectedStudents = 'Thông tin học viên';
                            selectedLocation = classData['location'] ?? 'Không có thông tin';
                            selectedFee = formatCurrency(classData['price']);
                            selectediddcertificate = classData['certificateName'] ?? 'Không có thông tin';
                            selectedlevel = classData['level'] ?? 'Không có thông tin';
                            selectedsessions = classData['sessions'].toString();
                            selectedduration = classData['duration'] ?? 'Không có thông tin';
                            selectedinstructorName = classData['instructorName'] ?? 'Không có thông tin';
                          });
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              selectedClass != null
                  ? 'Selected classes: $selectedClass'
                  : 'Please select a class',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedClass != null
                  ? () {
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
                            instructorName: selectedinstructorName!,
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
  final String certificateName;
  final String instructorName;
  final bool isOnline;
  final String startTime;
  final String endTime;
  final String location;
  final String fee;
  final bool isSelected;
  final VoidCallback onTap;

  const ClassCard({
    Key? key,
    required this.title,
    required this.certificateName,
    required this.instructorName,
    required this.isOnline,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.fee,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 350,
        height: 230,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSelected
                ? BorderSide(color: Colors.blue, width: 2)
                : BorderSide.none,
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Certificate: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: certificateName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Lecturer: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: instructorName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Start Time: ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: startTime,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'End Time: ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: endTime,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Location: ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: location,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'Price: ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: '$fee VND',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
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
