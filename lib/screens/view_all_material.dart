import 'package:flutter/material.dart';

class ViewAllMaterial extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<ViewAllMaterial> {
  // Danh sách 24 modules SAP
  final List<String> modules = [
    'MM', 'PP', 'SD', 'FI', 'CO', 'PM', 'HCM', 'BI',
    'QM', 'PS', 'HR', 'SCM', 'CRM', 'PLM', 'SRM', 'GTS',
    'EHS', 'IS', 'BW', 'MDG', 'S4HANA', 'FSCM', 'TM', 'IBP'
  ];

  // Biến để lưu trạng thái hiển thị: hiển thị toàn bộ hay chỉ 10 module
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    // Xác định số lượng module cần hiển thị
    List<String> modulesToShow = showAll ? modules : modules.sublist(0, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories (24 Modules)'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Sử dụng Expanded để GridView chiếm khoảng trống còn lại mà không tràn
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Hiển thị 2 module trên mỗi dòng
                crossAxisSpacing: 12, // Khoảng cách giữa các module theo chiều ngang
                mainAxisSpacing: 12, // Khoảng cách giữa các module theo chiều dọc
                childAspectRatio: 2.5, // Tỷ lệ giữa chiều rộng và chiều cao
                children: modulesToShow.map((module) {
                  return buildModuleBox(module);
                }).toList(),
              ),
            ),
            SizedBox(height: 12), // Khoảng cách giữa GridView và nút
            // Nút hiển thị thêm
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll; // Thay đổi trạng thái hiển thị
                  });
                },
                child: Text(showAll ? 'Hiển thị ít hơn' : 'Hiển thị thêm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo một ô module
  Widget buildModuleBox(String module) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền của ô
        borderRadius: BorderRadius.circular(8), // Bo góc cho ô
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Màu bóng đổ
            blurRadius: 5, // Độ mờ của bóng
            offset: Offset(0, 3), // Vị trí bóng đổ
          ),
        ],
      ),
      child: Center(
        child: Text(
          module,
          style: TextStyle(
            fontSize: 20, // Kích thước chữ
            fontWeight: FontWeight.bold, // Chữ in đậm
          ),
        ),
      ),
    );
  }
}
