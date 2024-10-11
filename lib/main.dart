import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';

void main() {
  runApp(MyApp()); // Chạy ứng dụng
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App', // Tên ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue, // Chủ đề chính với màu xanh dương
      ),
      home: HomeScreen(), // Trang chính của ứng dụng sẽ là HomeScreen
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Biến để lưu trữ chỉ số trang hiện tại được chọn

  // Danh sách các trang sẽ hiển thị khi người dùng chọn mục trong BottomNavigationBar
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Trang Home
    const CoursesPage(), // Trang Courses
    const Text('Mock Exams Page'), // Trang Mock Exams
    const Text('Profile Page'), // Trang Profile
  ];

  // Hàm xử lý khi người dùng chọn mục trong BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số trang được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Application'), // Tiêu đề của AppBar
        // Thêm logo nhỏ ở góc trái AppBar
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Khoảng cách giữa logo và các cạnh
          child: Image.asset(
            'assets/logo.jpg', // Đường dẫn đến logo
            fit: BoxFit.contain, // Đảm bảo logo không bị méo
            height: 32, // Chiều cao của logo
          ),
        ),
      ),
      body: Center(
        // Hiển thị trang hiện tại được chọn thông qua chỉ số _selectedIndex
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}