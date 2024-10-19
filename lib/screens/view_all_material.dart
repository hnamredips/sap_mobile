import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/moduleMM.dart';
import 'moduleMM.dart'; // Import các trang module bạn đã tạo

class ViewAllMaterial extends StatefulWidget {
  @override
  _ViewAllMaterialState createState() => _ViewAllMaterialState();
}

class _ViewAllMaterialState extends State<ViewAllMaterial> {
  List<String> modules = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    fetchModules(); // Gọi API khi màn hình khởi động
  }

  // Hàm gọi API bằng Dio
  Future<void> fetchModules() async {
    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all',
      );

      // In ra toàn bộ dữ liệu nhận được từ API để kiểm tra
      print("Response data: ${response.data}");

      // Truy cập vào trường $values
      if (response.data != null && response.data['\$values'] != null) {
        print("Modules found: ${response.data['\$values']}"); // In ra danh sách các module

        // Gán dữ liệu từ '$values' của API vào danh sách modules
        setState(() {
          modules = List.from(response.data['\$values']); // Chuyển đổi '$values' thành List
          isLoading = false; // Tắt trạng thái loading
        });
      } else {
        print('Error: "\$values" is null or response is null');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Tắt loading kể cả khi có lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories (${modules.length} Modules)'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải dữ liệu
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: modules.isEmpty
                  ? Center(child: Text("No modules found")) // Hiển thị thông báo nếu không có modules
                  : GridView.count(
                      crossAxisCount: 2, // 2 cột
                      crossAxisSpacing: 7, // Khoảng cách giữa các cột
                      mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                      childAspectRatio: 1.5, // Tỷ lệ chiều rộng / chiều cao, giúp các ô to hơn
                      children: modules.map((module) {
                        return GestureDetector(
                          onTap: () {
                            navigateToModule(module['moduleName']); // Sử dụng moduleName để điều hướng
                          },
                          child: buildModuleBox(module['moduleName']), // Hiển thị moduleName
                        );
                      }).toList(),
                    ),
            ),
    );
  }

  // Hàm điều hướng đến trang module tương ứng
  void navigateToModule(String module) {
    if (module == 'MM') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModuleMM(), // Điều hướng đến trang module MM
        ),
      );
    }
    // Thêm các điều kiện cho các module khác
  }

  // Hàm tạo widget hiển thị cho mỗi module
  Widget buildModuleBox(String moduleName) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF275998), // Màu nền xanh đậm
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
        child: Text(
          moduleName ?? "No name", // Hiển thị tên của module (hoặc 'No name' nếu moduleName là null)
          style: TextStyle(
            fontSize: 22, // Kích thước chữ lớn hơn
            fontWeight: FontWeight.bold,
            color: Colors.white, // Màu chữ trắng
          ),
        ),
      ),
    );
  }
}