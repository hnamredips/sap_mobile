// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:sap_mobile/screens/moduleMM.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CombinedPurchasePage extends StatefulWidget {
//   final String className;
//   final String schedule;
//   final String students;
//   final String location;
//   final String price;
//   final String iddcertificate;
//   final String level;
//   final String sessions;
//   final String duration;
//   final String instructorName;
//   final int courseId;

//   const CombinedPurchasePage({
//     Key? key,
//     required this.className,
//     required this.schedule,
//     required this.students,
//     required this.location,
//     required this.price,
//     required this.iddcertificate,
//     required this.level,
//     required this.sessions,
//     required this.duration,
//     required this.instructorName,
//     required this.courseId,
//   }) : super(key: key);

//   @override
//   _CombinedPurchasePageState createState() => _CombinedPurchasePageState();
// }

// class _CombinedPurchasePageState extends State<CombinedPurchasePage> {
//   int _currentStep = 0;
//   PageController _pageController = PageController();
//   String _selectedPaymentMethod = 'Mastercard';
//   String? certificateLevel;
//   String? paymentUrl;
//   String? enrollmentId;
//   String? paymentId;
//   String? currentUserId;
//   int? courseId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     fetchCertificateLevel();
//     fetchCourseId();
//   }

//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       currentUserId = prefs.getString('currentUserId');
//     });
//   }

//   Future<void> fetchCertificateLevel() async {
//     try {
//       final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all');

//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data is Map<String, dynamic> && data.containsKey('\$values')) {
//           final certificates = data['\$values'] as List<dynamic>;

//           final certificate = certificates.firstWhere(
//             (cert) => cert['certificateName'] == widget.iddcertificate,
//             orElse: () => null,
//           );

//           if (certificate != null) {
//             setState(() {
//               certificateLevel = certificate['level'] ?? 'Không có thông tin';
//             });
//           } else {
//             setState(() {
//               certificateLevel = 'Không tìm thấy thông tin';
//             });
//           }
//         } else {
//           setState(() {
//             certificateLevel = 'Dữ liệu không hợp lệ';
//           });
//         }
//       } else {
//         throw Exception('Failed to load certificate data');
//       }
//     } catch (e) {
//       setState(() {
//         certificateLevel = 'Lỗi khi lấy dữ liệu';
//       });
//     }
//   }

//   Future<void> fetchCourseId() async {
//     try {
//       final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/Course/get-all');

//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data is Map<String, dynamic> && data.containsKey('\$values')) {
//           final courses = data['\$values'] as List<dynamic>;

//           final course = courses.firstWhere(
//             (c) => c['certificateName'] == widget.iddcertificate,
//             orElse: () => null,
//           );

//           if (course != null) {
//             setState(() {
//               courseId = course['id'];
//             });
//             print("Fetched courseId: $courseId for certificate: ${widget.iddcertificate}");
//           } else {
//             setState(() {
//               courseId = null;
//             });
//             print("No course found for certificate: ${widget.iddcertificate}");
//           }
//         } else {
//           print("Unexpected data format from Course API");
//         }
//       } else {
//         throw Exception('Failed to load course data');
//       }
//     } catch (e) {
//       print('Error fetching courseId: $e');
//     }
//   }

//   Future<void> createEnrollment() async {
//   try {
//     final enrollmentPrice = int.tryParse(widget.price.replaceAll(',', '')) ?? -1;
//     if (enrollmentPrice == -1 || currentUserId == null || widget.courseId == null) {
//       print("Error: Missing userId, courseId, or price cannot be converted.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Đăng ký không thành công. Vui lòng kiểm tra thông tin.'),
//         ),
//       );
//       return;
//     }

//     final requestData = {
//       "userId": currentUserId,
//       "courseId": widget.courseId,
//       "enrollmentPrice": enrollmentPrice,
//     };

//     print("Sending enrollment request with data: $requestData");

//     final response = await Dio().post(
//       'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/create',
//       data: requestData,
//     );

//     if (response.statusCode == 201) {
//       enrollmentId = response.data['id'].toString();
//       print("Enrollment created successfully with ID: $enrollmentId");

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Đăng ký khóa học ${widget.className} thành công.'),
//         ),
//       );

//       await createPayment(enrollmentId!);
//     } else {
//       throw Exception('Failed to create enrollment');
//     }
//   } catch (e) {
//     print('Error creating enrollment: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Đăng ký không thành công. Vui lòng thử lại.'),
//       ),
//     );
//   }
// }

//   Future<void> createPayment(String enrollmentId) async {
//     try {
//       print("Creating payment for enrollmentId: $enrollmentId");
//       final response = await Dio().post(
//         'https://swdsapelearningapi.azurewebsites.net/api/Payment/create?enrollmentId=$enrollmentId',
//       );

//       if (response.statusCode == 200) {
//         paymentId = response.data['id'].toString();
//         print("Payment created successfully with ID: $paymentId");

//         setState(() {
//           _currentStep = 1;
//           _pageController.jumpToPage(1);
//         });
//       } else {
//         throw Exception('Failed to create payment');
//       }
//     } catch (e) {
//       print('Error creating payment: $e');
//     }
//   }

//   Future<void> createVnpayUrl(String paymentId) async {
//     try {
//       print("Creating VNPAY URL for paymentId: $paymentId");
//       final response = await Dio().get(
//         'https://swdsapelearningapi.azurewebsites.net/api/VNPay/CreatePaymentUrl?PaymentId=$paymentId',
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           paymentUrl = response.data;
//         });
//         print("VNPAY URL created successfully: $paymentUrl");

//         if (await canLaunch(paymentUrl!)) {
//           await launch(paymentUrl!, forceSafariVC: false, forceWebView: false);
//         } else {
//           throw 'Could not launch $paymentUrl';
//         }
//       } else {
//         throw Exception('Failed to create VNPAY URL');
//       }
//     } catch (e) {
//       print('Error creating VNPAY URL: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Purchase Flow'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     stepIndicator('Overview', 0),
//                     stepIndicator('Payment Method', 1),
//                     stepIndicator('Confirmation', 2),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   onPageChanged: (int index) {
//                     setState(() {
//                       _currentStep = index;
//                     });
//                   },
//                   children: [
//                     buildOverviewPage(),
//                     buildPaymentMethodPage(),
//                     buildConfirmationPage(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: ElevatedButton(
//               onPressed: (_currentStep == 1 && _selectedPaymentMethod != 'VNPAY')
//                   ? null
//                   : () async {
//                       if (_currentStep == 0) {
//                         await createEnrollment();
//                       } else if (_currentStep == 1) {
//                         setState(() {
//                           _currentStep = 2;
//                           _pageController.jumpToPage(2);
//                         });
//                       }
//                     },
//               child: Text('CONTINUE', style: TextStyle(fontSize: 18)),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//                 backgroundColor: (_currentStep == 1 && _selectedPaymentMethod != 'VNPAY')
//                     ? Colors.grey
//                     : Color(0xFF275998),
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget stepIndicator(String title, int step) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentStep = step;
//           _pageController.jumpToPage(step);
//         });
//       },
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor:
//                 _currentStep == step ? Color(0xFF275998) : Colors.grey[300],
//             child: Text(
//               title[0],
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 5),
//           Text(
//             title,
//             style: TextStyle(
//               color: _currentStep == step ? Color(0xFF275998) : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildOverviewPage() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Overview',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildDetailRow(
//                       'Certificate',
//                       widget.iddcertificate.length > 20
//                           ? '${widget.iddcertificate.substring(0, 20)}...'
//                           : widget.iddcertificate,
//                     ),
//                     buildDetailRow('Level ', certificateLevel ?? 'Loading...'),
//                   ],
//                 ),
//               ),
//             ),
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildDetailRow(
//                       'Class code',
//                       widget.className.length > 20
//                           ? '${widget.className.substring(0, 20)}...'
//                           : widget.className,
//                     ),
//                     buildDetailRow('Lecturer', widget.instructorName),
//                     buildDetailRow('Location', widget.location),
//                     buildDetailRow('Price', widget.price),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDetailRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: TextStyle(fontSize: 16)),
//         Text(value, style: TextStyle(fontSize: 16)),
//       ],
//     );
//   }

//   Widget buildPaymentMethodPage() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Payment Methods',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             _buildPaymentOption(
//               context,
//               label: 'VNPAY',
//               selectedValue: _selectedPaymentMethod,
//               onSelect: () async {
//                 setState(() {
//                   _selectedPaymentMethod = 'VNPAY';
//                 });
//                 if (paymentId != null) {
//                   await createVnpayUrl(paymentId!);
//                 } else {
//                   print("VNPAY URL chưa được tạo hoặc không chọn đúng phương thức thanh toán");
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildConfirmationPage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               await checkEnrollmentStatus();
//             },
//             child: Text('Check Enrollment Status'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> checkEnrollmentStatus() async {
//     try {
//       final response = await Dio().get(
//         'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all?PageSize=50',
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;

//         if (data is Map<String, dynamic> && data.containsKey('\$values')) {
//           final enrollments = data['\$values'] as List<dynamic>;

//           final enrollment = enrollments.firstWhere(
//             (enroll) => enroll['id'].toString() == enrollmentId,
//             orElse: () => null,
//           );

//           if (enrollment != null && enrollment['status'] == 'Success') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Khóa học ${widget.className} đã được thanh toán thành công'),
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Khóa học ${widget.className} chưa thanh toán'),
//               ),
//             );
//           }
//         } else {
//           print("Unexpected data format from Enrollment API");
//         }
//       } else {
//         throw Exception('Failed to load enrollment data');
//       }
//     } catch (e) {
//       print('Error checking enrollment status: $e');
//     }
//   }

//   Widget _buildPaymentOption(
//     BuildContext context, {
//     required String label,
//     required String selectedValue,
//     required VoidCallback onSelect,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ListTile(
//         title: Text(label,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         trailing: Radio<String>(
//           value: label,
//           groupValue: selectedValue,
//           activeColor: Color(0xFF275998),
//           onChanged: (String? value) {
//             onSelect();
//           },
//         ),
//         onTap: onSelect,
//       ),
//     );
//   }
// }

// class PaymentWebView extends StatelessWidget {
//   final String url;

//   const PaymentWebView({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('VNPAY Payment'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             if (await canLaunch(url)) {
//               await launch(url, forceSafariVC: false, forceWebView: false);
//             } else {
//               throw 'Could not launch $url';
//             }
//           },
//           child: Text('Open in Browser'),
//         ),
//       ),
//     );
//   }
// }

import 'package:sap_mobile/screens/home_screen.dart';
import 'package:sap_mobile/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/moduleMM.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CombinedPurchasePage extends StatefulWidget {
  final String className;
  final String schedule;
  final String students;
  final String location;
  final String price;
  final String iddcertificate;
  final String level;
  final String sessions;
  final String duration;
  final String instructorName;
  final int courseId;

  const CombinedPurchasePage({
    Key? key,
    required this.className,
    required this.schedule,
    required this.students,
    required this.location,
    required this.price,
    required this.iddcertificate,
    required this.level,
    required this.sessions,
    required this.duration,
    required this.instructorName,
    required this.courseId,
  }) : super(key: key);

  @override
  _CombinedPurchasePageState createState() => _CombinedPurchasePageState();
}

class _CombinedPurchasePageState extends State<CombinedPurchasePage> {
  int _currentStep = 0;
  PageController _pageController = PageController();
  String _selectedPaymentMethod = 'Mastercard';
  String? certificateLevel;
  String? paymentUrl;
  String? enrollmentId;
  String? paymentId;
  String? currentUserId;
  int? courseId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchCertificateLevel();
    fetchCourseId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('currentUserId');
    });
  }

  Future<void> fetchCertificateLevel() async {
    try {
      final response = await Dio().get(
          'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('\$values')) {
          final certificates = data['\$values'] as List<dynamic>;

          final certificate = certificates.firstWhere(
            (cert) => cert['certificateName'] == widget.iddcertificate,
            orElse: () => null,
          );

          if (certificate != null) {
            setState(() {
              certificateLevel = certificate['level'] ?? 'Không có thông tin';
            });
          } else {
            setState(() {
              certificateLevel = 'Không tìm thấy thông tin';
            });
          }
        } else {
          setState(() {
            certificateLevel = 'Dữ liệu không hợp lệ';
          });
        }
      } else {
        throw Exception('Failed to load certificate data');
      }
    } catch (e) {
      setState(() {
        certificateLevel = 'Lỗi khi lấy dữ liệu';
      });
    }
  }

  Future<void> fetchCourseId() async {
    try {
      final response = await Dio().get(
          'https://swdsapelearningapi.azurewebsites.net/api/Course/get-all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('\$values')) {
          final courses = data['\$values'] as List<dynamic>;

          final course = courses.firstWhere(
            (c) => c['certificateName'] == widget.iddcertificate,
            orElse: () => null,
          );

          if (course != null) {
            setState(() {
              courseId = course['id'];
            });
            print(
                "Fetched courseId: $courseId for certificate: ${widget.iddcertificate}");
          } else {
            setState(() {
              courseId = null;
            });
            print("No course found for certificate: ${widget.iddcertificate}");
          }
        } else {
          print("Unexpected data format from Course API");
        }
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching courseId: $e');
    }
  }

  Future<void> createEnrollment() async {
    try {
      final enrollmentPrice =
          int.tryParse(widget.price.replaceAll(',', '')) ?? -1;
      if (enrollmentPrice == -1 ||
          currentUserId == null ||
          widget.courseId == null) {
        print("Error: Missing userId, courseId, or price cannot be converted.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Đăng ký không thành công. Vui lòng kiểm tra thông tin.'),
          ),
        );
        return;
      }

      final requestData = {
        "userId": currentUserId,
        "courseId": widget.courseId,
        "enrollmentPrice": enrollmentPrice,
      };

      print("Sending enrollment request with data: $requestData");

      final response = await Dio().post(
        'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/create',
        data: requestData,
      );

      if (response.statusCode == 201) {
        enrollmentId = response.data['id'].toString();
        print("Enrollment created successfully with ID: $enrollmentId");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký khóa học ${widget.className} thành công.'),
          ),
        );

        await createPayment(enrollmentId!);
      } else {
        throw Exception('Failed to create enrollment');
      }
    } catch (e) {
      print('Error creating enrollment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký không thành công. Vui lòng thử lại.'),
        ),
      );
    }
  }

  Future<void> createPayment(String enrollmentId) async {
    try {
      print("Creating payment for enrollmentId: $enrollmentId");
      final response = await Dio().post(
        'https://swdsapelearningapi.azurewebsites.net/api/Payment/create?enrollmentId=$enrollmentId',
      );

      if (response.statusCode == 200) {
        paymentId = response.data['id'].toString();
        print("Payment created successfully with ID: $paymentId");

        setState(() {
          _currentStep = 1;
          _pageController.jumpToPage(1);
        });
      } else {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      print('Error creating payment: $e');
    }
  }

  Future<void> createVnpayUrl(String paymentId) async {
    try {
      print("Creating VNPAY URL for paymentId: $paymentId");
      final response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/VNPay/CreatePaymentUrl?PaymentId=$paymentId',
      );

      if (response.statusCode == 200) {
        setState(() {
          paymentUrl = response.data;
        });
        print("VNPAY URL created successfully: $paymentUrl");

        if (await canLaunch(paymentUrl!)) {
          await launch(paymentUrl!, forceSafariVC: false, forceWebView: false);
        } else {
          throw 'Could not launch $paymentUrl';
        }
      } else {
        throw Exception('Failed to create VNPAY URL');
      }
    } catch (e) {
      print('Error creating VNPAY URL: $e');
    }
  }

  Future<void> checkAndNavigate() async {
    try {
      final response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Enrollment/get-all?PageSize=50',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data.containsKey('\$values')) {
          final enrollments = data['\$values'] as List<dynamic>;

          final enrollment = enrollments.firstWhere(
            (enroll) => enroll['id'].toString() == enrollmentId,
            orElse: () => null,
          );

          if (enrollment != null && enrollment['status'] == 'Success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Khóa học ${widget.className} đã được thanh toán thành công'),
              ),
            );
            await Future.delayed(Duration(seconds: 2));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(initialIndex: 1)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Khóa học ${widget.className} chưa thanh toán'),
              ),
            );
          }
        } else {
          print("Unexpected data format from Enrollment API");
        }
      } else {
        throw Exception('Failed to load enrollment data');
      }
    } catch (e) {
      print('Error checking enrollment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Flow'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    stepIndicator('Overview', 0),
                    stepIndicator('Payment Method', 1),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    buildOverviewPage(),
                    buildPaymentMethodPage(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed:
                  (_currentStep == 1 && _selectedPaymentMethod != 'VNPAY')
                      ? null
                      : () async {
                          if (_currentStep == 0) {
                            await createEnrollment();
                          } else if (_currentStep == 1) {
                            await checkAndNavigate();
                          }
                        },
              child: Text('CONTINUE', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor:
                    (_currentStep == 1 && _selectedPaymentMethod != 'VNPAY')
                        ? Colors.grey
                        : Color(0xFF275998),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stepIndicator(String title, int step) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentStep = step;
          _pageController.jumpToPage(step);
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                _currentStep == step ? Color(0xFF275998) : Colors.grey[300],
            child: Text(
              title[0],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: _currentStep == step ? Color(0xFF275998) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOverviewPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                      'Certificate',
                      widget.iddcertificate.length > 20
                          ? '${widget.iddcertificate.substring(0, 20)}...'
                          : widget.iddcertificate,
                    ),
                    buildDetailRow('Level ', certificateLevel ?? 'Loading...'),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                      'Class code',
                      widget.className.length > 20
                          ? '${widget.className.substring(0, 20)}...'
                          : widget.className,
                    ),
                    buildDetailRow('Lecturer', widget.instructorName),
                    buildDetailRow('Location', widget.location),
                    buildDetailRow('Price', widget.price),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildPaymentMethodPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPaymentOption(
              context,
              label: 'VNPAY',
              selectedValue: _selectedPaymentMethod,
              onSelect: () async {
                setState(() {
                  _selectedPaymentMethod = 'VNPAY';
                });
                if (paymentId != null) {
                  await createVnpayUrl(paymentId!);
                } else {
                  print(
                      "VNPAY URL chưa được tạo hoặc không chọn đúng phương thức thanh toán");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String label,
    required String selectedValue,
    required VoidCallback onSelect,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Radio<String>(
          value: label,
          groupValue: selectedValue,
          activeColor: Color(0xFF275998),
          onChanged: (String? value) {
            onSelect();
          },
        ),
        onTap: onSelect,
      ),
    );
  }
}

class PaymentWebView extends StatelessWidget {
  final String url;

  const PaymentWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNPAY Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (await canLaunch(url)) {
              await launch(url, forceSafariVC: false, forceWebView: false);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text('Open in Browser'),
        ),
      ),
    );
  }
}
