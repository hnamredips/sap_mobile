// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:sap_mobile/screens/moduleMM.dart';

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
//   }) : super(key: key);

//   @override
//   _CombinedPurchasePageState createState() => _CombinedPurchasePageState();
// }

// class _CombinedPurchasePageState extends State<CombinedPurchasePage> {
//   int _currentStep = 0;
//   PageController _pageController = PageController();
//   String _selectedPaymentMethod = 'Mastercard';
//   String? certificateLevel; // Biến để lưu trữ level của chứng chỉ

//   @override
//   void initState() {
//     super.initState();
//     fetchCertificateLevel();
//   }

//   Future<void> fetchCertificateLevel() async {
//   try {
//     final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all');

//     if (response.statusCode == 200) {
//       print("API call successful. Response data:");
//       print(response.data); // In ra toàn bộ dữ liệu nhận được từ API

//       // Kiểm tra nếu response là Map và chứa '$values'
//       final data = response.data;
//       if (data is Map<String, dynamic> && data.containsKey('\$values')) {
//         final certificates = data['\$values'] as List<dynamic>;
        
//         print("Extracted certificates list:");
//         print(certificates); // In ra danh sách chứng chỉ

//         // Tìm chứng chỉ phù hợp dựa trên tên
//         final certificate = certificates.firstWhere(
//           (cert) => cert['certificateName'] == widget.iddcertificate,
//           orElse: () => null,
//         );

//         if (certificate != null) {
//           print("Matching certificate found:");
//           print(certificate); // In ra chứng chỉ tìm thấy

//           setState(() {
//             certificateLevel = certificate['level'] ?? 'Không có thông tin';
//           });
//         } else {
//           print("No certificate found matching name: ${widget.iddcertificate}");
//           setState(() {
//             certificateLevel = 'Không tìm thấy thông tin';
//           });
//         }
//       } else {
//         print("Unexpected data format: 'values' field not found or response is not a Map");
//         setState(() {
//           certificateLevel = 'Dữ liệu không hợp lệ';
//         });
//       }
//     } else {
//       throw Exception('Failed to load certificate data');
//     }
//   } catch (e) {
//     print('Error fetching certificate level: $e');
//     setState(() {
//       certificateLevel = 'Lỗi khi lấy dữ liệu';
//     });
//   }
// }

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
//               onPressed: () {
//                 if (_currentStep == 1) {
//                   _pageController.jumpToPage(2);
//                 } else {
//                   _pageController.nextPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.ease,
//                   );
//                 }
//               },
//               child: Text('CONTINUE', style: TextStyle(fontSize: 18)),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//                 backgroundColor: Color(0xFF275998),
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
//                     Text('Certificate Detail',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     buildDetailRow(
//                       'Tên chứng chỉ',
//                       widget.iddcertificate.length > 20
//                           ? '${widget.iddcertificate.substring(0, 20)}...'
//                           : widget.iddcertificate,
//                     ),
//                     buildDetailRow(
//                       'Cấp độ',
//                       certificateLevel ?? 'Đang tải...',
//                     ),
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
//                     Text('Class Detail',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     buildDetailRow(
//                       'Mã lớp',
//                       widget.className.length > 20
//                           ? '${widget.className.substring(0, 20)}...'
//                           : widget.className,
//                     ),
//                     buildDetailRow('Giáo viên', widget.instructorName),
//                     buildDetailRow('Địa điểm học', widget.location),
//                     buildDetailRow('Chi phí', widget.price),
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
//               onSelect: () {
//                 setState(() {
//                   _selectedPaymentMethod = 'VNPAY';
//                 });
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
//           Image.asset(
//             'assets/images/done.png',
//             height: 200,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Successful purchase!',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
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




import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/moduleMM.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all');

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
      final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/Course/get-all');

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
            print("Fetched courseId: $courseId for certificate: ${widget.iddcertificate}");
          } else {
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
      final enrollmentPrice = int.tryParse(widget.price.replaceAll(',', '')) ?? -1;
      if (enrollmentPrice == -1 || currentUserId == null || courseId == null) {
        print("Error: Missing userId, courseId, or price cannot be converted.");
        return;
      }

      final requestData = {
        "userId": currentUserId,
        "courseId": courseId,
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

        await createPayment(enrollmentId!);
      } else {
        throw Exception('Failed to create enrollment');
      }
    } catch (e) {
      print('Error creating enrollment: $e');
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

        // Tự động chuyển sang trang Payment Method sau khi tạo Payment
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

        // Chuyển tiếp đến trang thanh toán khi URL đã được tạo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(url: paymentUrl!),
          ),
        );
      } else {
        throw Exception('Failed to create VNPAY URL');
      }
    } catch (e) {
      print('Error creating VNPAY URL: $e');
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
                    stepIndicator('Confirmation', 2),
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
                    buildConfirmationPage(),
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
              onPressed: () async {
                if (_currentStep == 0) {
                  await createEnrollment();
                } else if (_currentStep == 1) {
                  if (_selectedPaymentMethod == 'VNPAY' && paymentId != null) {
                    await createVnpayUrl(paymentId!);
                  } else {
                    print("VNPAY URL chưa được tạo hoặc không chọn đúng phương thức thanh toán");
                  }
                }
              },
              child: Text('CONTINUE', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF275998),
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
                    buildDetailRow('Tên chứng chỉ', widget.iddcertificate),
                    buildDetailRow('Cấp độ', certificateLevel ?? 'Đang tải...'),
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
                      'Mã lớp',
                      widget.className.length > 20
                          ? '${widget.className.substring(0, 20)}...'
                          : widget.className,
                    ),
                    buildDetailRow('Giáo viên', widget.instructorName),
                    buildDetailRow('Địa điểm học', widget.location),
                    buildDetailRow('Chi phí', widget.price),
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
              onSelect: () {
                setState(() {
                  _selectedPaymentMethod = 'VNPAY';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmationPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/done.png',
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            'Successful purchase!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
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

// Định nghĩa trang WebView cho VNPAY
class PaymentWebView extends StatelessWidget {
  final String url;

  const PaymentWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VNPAY Payment'),
      ),
      body: Center(
        child: Text('$url'),
      ),
    );
  }
}