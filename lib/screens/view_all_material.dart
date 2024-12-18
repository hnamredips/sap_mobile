import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/moduleMM.dart';

class ViewAllMaterial extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<ViewAllMaterial> {
  List<dynamic> modules = []; // Dữ liệu lấy từ API sẽ được lưu ở đây
  bool isLoading = true; // Trạng thái loading

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
        title: Text(
          'Categories (${modules.length} Modules)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ), // Hiển thị số lượng modules
        backgroundColor: Colors.white, 
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
                            navigateToModule(module['moduleName'], module['id']); // Sử dụng moduleName và id để điều hướng
                          },
                          child: buildModuleBox(module['moduleName']), // Hiển thị moduleName
                        );
                      }).toList(),
                    ),
            ),
    );
  }

  // Hàm điều hướng đến trang module tương ứng
  void navigateToModule(String moduleName, int moduleId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleMM(moduleId: moduleId, moduleName: moduleName), // Truyền cả moduleId và moduleName
    ),
  );
}

    // Thêm các điều kiện cho các module khác nếu cần
  }

  // Hàm tạo widget hiển thị cho mỗi module
  Widget buildModuleBox(String moduleName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền xanh đậm
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF275998),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          moduleName ?? "No name", // Hiển thị tên của module (hoặc 'No name' nếu moduleName là null)
          style: TextStyle(
            fontSize: 22, // Kích thước chữ lớn hơn
            fontWeight: FontWeight.bold,
            color: Color(0xFF275998), // Màu chữ trắng
          ),
        ),
      ),
    );
  }

