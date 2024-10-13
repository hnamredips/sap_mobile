import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/courses_page.dart';
import 'screens/view_all_material.dart';
import 'screens/homepage_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

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
      home: MainScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/homepage': (context) => HomepageScreen(),
        '/schedule': (context) => ScheduleScreen(),
        '/profile': (context) => ProfileScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hinh anh tren cung 
              Spacer(),
              Image.asset(
                'assets/images/saplearn_logo(1).png', // Duong dan hinh anh 
                height: 200,
              ),
              SizedBox(height: 20),

              // Tieu de
              Text(
                'Create your own study plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // Mo ta 
              Text(
                'Study according to the study plan, make study more motivated',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Spacer(),

              // Sign up button 
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color(0xFF275998), // Mau nen 
                    foregroundColor: Color.fromARGB(255, 255, 255, 255), // Sign up color 
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Log in button 
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Log in'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Color(0xFF275998)), // Vien nut Log in 
                    foregroundColor: Color(0xFF345894), // Mau chu Log in 
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
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