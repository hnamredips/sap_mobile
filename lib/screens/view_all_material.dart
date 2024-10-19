import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
    fetchModules();
  }

  Future<void> fetchModules() async {
    try {
      final response = await Dio().get('https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all');
      if (response.statusCode == 200) {
        setState(() {
          modules = List<String>.from(response.data.map((module) => module['moduleName'] as String));
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load modules';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : GridView.count(
                    crossAxisCount: 2, // 2 cột
                    crossAxisSpacing: 7, // Khoảng cách giữa các cột
                    mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                    childAspectRatio: 1.5, // Tỷ lệ chiều rộng / chiều cao, giúp các ô to hơn
                    children: modules.map((module) {
                      return GestureDetector(
                        onTap: () {
                          navigateToModule(module);
                        },
                        child: buildModuleBox(module),
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
            builder: (context) => ModuleMM()), // Điều hướng đến trang module MM
      );
    } else if (module == 'PP') {
      // Điều hướng đến trang module PP
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ModulePP()));
    }
    // Thêm các điều kiện cho các module khác
  }

  Widget buildModuleBox(String module) {
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
          module,
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