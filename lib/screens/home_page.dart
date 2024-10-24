// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:sap_mobile/screens/view_all_material.dart';


// class HomePage extends StatelessWidget {
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
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView( // Thêm Scroll để có thể cuộn màn hình
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Khung tổng thể cho "Lịch học hôm nay" và các mục lịch học
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 225, 224, 224), // Màu nền nhạt cho khung tổng thể
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
//                           Text('Study schedule', style: TextStyle(fontWeight: FontWeight.bold)),
//                           Text('Tất cả', style: TextStyle(color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16),

//                     // Schedule Items
//                     buildScheduleItem('SAP311', 'Online 514', '12:30 - 14:45', true),
//                     SizedBox(height: 10),
//                     buildScheduleItem('SAP323', 'Offline 611', '18:30 - 20:00', false),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Categories Slider with "View All" button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đặt hai phần tử cách xa nhau
//                 children: [
//                   Text(
//                     'Categories',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // Điều hướng sang trang TestPage trong test.dart
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ViewAllMaterial()), // Điều hướng đến TestPage
//                       );
//                     },
//                     child: Text(
//                       'View All', // Bạn có thể đổi thành 'Xem tất cả'
//                       style: TextStyle(
//                         color: Colors.blue, // Màu xanh cho nút View All
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),

//               // Categories Slider
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 80,
//                   enableInfiniteScroll: true,
//                   viewportFraction: 0.33,
//                 ),
//                 items: ['MM', 'PP', 'SD'].map((category) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text(category, style: TextStyle(fontSize: 24)),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 16),

//               // Top Certificate Slider
//               Text('Top Certificate', style: TextStyle(fontSize: 18)),
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 80,
//                   enableInfiniteScroll: true,
//                   viewportFraction: 0.33,
//                 ),
//                 items: [1, 2, 3, 4, 5, 6, 7, 8].map((i) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text('Certificate $i', style: TextStyle(fontSize: 16)),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to build schedule item
//   Widget buildScheduleItem(String subjectCode, String room, String time, bool isOnline) {
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
import 'package:sap_mobile/screens/view_all_material.dart';
import 'package:sap_mobile/screens/search_screen.dart'; // Import SearchScreen
import 'package:sap_mobile/screens/modulemm.dart'; // Import trang chi tiết module MM, bạn thêm tương tự với PP, SD

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, Đạt"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
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
                    buildScheduleItem(
                        'SAP311', 'Online 514', '12:30 - 14:45', true),
                    SizedBox(height: 10),
                    buildScheduleItem(
                        'SAP323', 'Offline 611', '18:30 - 20:00', false),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Categories Slider with "View All" button
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Đặt hai phần tử cách xa nhau
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewAllMaterial()), // Điều hướng đến trang View All Material
                      );
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue, // Màu xanh cho nút View All
fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Categories Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 80,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.33,
                ),
                items: ['MM', 'PP', 'SD'].map((category) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Điều hướng đến từng module tương ứng
                          if (category == 'MM') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModuleMM()), // Điều hướng đến Module MM
                            );
                          }
                          // Thêm các điều hướng tương ứng với PP và SD
                          else if (category == 'PP') {
                            // Điều hướng đến Module PP
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModuleMM()), // Giả định có ModulePP
                            );
                          } else if (category == 'SD') {
                            // Điều hướng đến Module SD
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModuleMM()), // Giả định có ModuleSD
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            child: Text(category, style: TextStyle(fontSize: 24)),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Top Certificate Slider
              Text('Top Certificate', style: TextStyle(fontSize: 18)),
CarouselSlider(
                options: CarouselOptions(
                  height: 80,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.33,
                ),
                items: [1, 2, 3, 4, 5, 6, 7, 8].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Điều hướng đến chi tiết chứng chỉ cụ thể
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CertificateDetail(
                                'Certificate $i', // Truyền tên chứng chỉ
                                className: 'C_TS462_$i', // Truyền className
                                level: 'Intermediate',
                                sessions: 10, // Ví dụ: số buổi học
                                duration: '5 tuần', // Ví dụ: thời gian khóa học
                                location: 'Google Meet', // Ví dụ: địa điểm học
                                fee: '2.500.000', // Ví dụ: chi phí
                                statusfee: 'vnđ/ khóa', // Đơn vị chi phí
                                idcertificate: 'C_TS462_CERT_$i', // Truyền mã chứng chỉ
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            child: Text('Certificate $i', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      );
                    },
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

