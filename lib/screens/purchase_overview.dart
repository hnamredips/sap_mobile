import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  _CombinedPurchasePageState createState() => _CombinedPurchasePageState();
}

class _CombinedPurchasePageState extends State<CombinedPurchasePage> {
  int _currentStep = 0; // Biến để theo dõi bước hiện tại
  PageController _pageController =
      PageController(); // PageController để điều khiển PageView

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
              // Step Indicator
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

              // PageView để chuyển qua lại giữa các bước
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    buildOverviewPage(), // Trang Overview
                    buildPaymentMethodPage(), // Trang Payment Method
                    buildConfirmationPage(), // Trang Confirmation
                  ],
                ),
              ),
            ],
          ),

          // Nút Continue cố định ở cuối màn hình
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 1) {
                  _pageController
                      .jumpToPage(2); // Chuyển đến trang Confirmation
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
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

  // Widget Step Indicator - cho phép nhấn vào để chuyển trang
  Widget stepIndicator(String title, int step) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentStep = step;
          _pageController.jumpToPage(step); // Chuyển tới trang tương ứng
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

  // Trang Overview
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
            // Nội dung trang Overview
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Certificate Detail',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    buildDetailRow('Tên chứng chỉ', widget.iddcertificate),
                    buildDetailRow('Cấp độ', widget.level),
                    buildDetailRow('Thời gian dự kiến', widget.duration),
                    buildDetailRow('Tổng số buổi', widget.sessions),
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
                    Text('Class Detail',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    buildDetailRow('Mã lớp', widget.className),
                    buildDetailRow('Giờ học', widget.schedule),
                    buildDetailRow('Học viên', widget.students),
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

  // Trang Payment Method
  Widget buildPaymentMethodPage() {
    String _selectedPaymentMethod = 'Mastercard'; // Default selected method
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
            // Payment Options
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

  // Trang Confirmation
  Widget buildConfirmationPage() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Căn giữa các widget theo chiều dọc
        children: [
          Image.asset(
            'assets/images/done.png', // Đường dẫn hình ảnh
            height: 200,
          ),
          SizedBox(height: 20), // Khoảng cách giữa hình ảnh và văn bản
          Text(
            'Successful purchase!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Chi tiết hàng trong trang Overview
  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Widget để hiển thị các tùy chọn phương thức thanh toán
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
