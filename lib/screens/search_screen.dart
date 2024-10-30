import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _modules = []; // Danh sách module với id và moduleName
  List<String> _levels = ['Associate', 'Specialist', 'Professional'];
  List<String> _selectedModules = [];
  List<String> _selectedLevels = [];
  List<Map<String, dynamic>> _certificates = [];
  List<Map<String, dynamic>> _filteredCertificates = [];

  @override
  void initState() {
    super.initState();
    fetchModules(); // Gọi API để lấy danh sách modules khi khởi động
    fetchCertificates(); // Gọi API để lấy danh sách certificates khi khởi động
  }

  // Hàm gọi API để lấy danh sách modules từ API
  Future<void> fetchModules() async {
    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all',
      );

      // In ra dữ liệu nhận được từ API để kiểm tra
      print("Modules response data: ${response.data}");

      if (response.data != null) {
        setState(() {
          _modules = List<Map<String, dynamic>>.from(response.data['\$values']);
        });
      }
    } catch (e) {
      print('Error fetching modules: $e');
    }
  }

  // Hàm gọi API để lấy danh sách certificates
  Future<void> fetchCertificates() async {
    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
      );

      // In ra dữ liệu nhận được từ API để kiểm tra
      print("Certificates response data: ${response.data}");

      if (response.data != null && response.data['\$values'] != null) {
        setState(() {
          _certificates = List<Map<String, dynamic>>.from(response.data['\$values']);
          _filteredCertificates = _certificates; // Lúc đầu, hiển thị tất cả
        });
      }
    } catch (e) {
      print('Error fetching certificates: $e');
    }
  }

  // Hàm lấy tên module dựa trên module ID
String getModuleNameById(int moduleId) {
  final module = _modules.firstWhere((mod) => mod['id'] == moduleId, orElse: () => {});
  return module.isNotEmpty ? module['moduleName'] : 'Unknown';
}


  // Hàm filter certificates theo query search, module và level
  void _filterCertificates() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCertificates = _certificates.where((certificate) {
        bool matchesQuery = certificate['certificateName']!.toLowerCase().contains(query);
       
        // Kiểm tra nếu certificate có moduleIds và module nằm trong selectedModules
        bool matchesModule = _selectedModules.isEmpty ||
            certificate['moduleIds']['\$values'].any((id) => _selectedModules.contains(getModuleNameById(id)));
       
        bool matchesLevel = _selectedLevels.isEmpty || _selectedLevels.contains(certificate['level']);
        return matchesQuery && matchesModule && matchesLevel;
      }).toList();
    });
  }

  void _selectAllModules() {
    setState(() {
      _selectedModules = _modules.map((module) => module['moduleName'] as String).toList();
    });
  }

  void _selectAllLevels() {
    setState(() {
      _selectedLevels = List.from(_levels);
    });
  }

  void _clearAllModules() {
    setState(() {
      _selectedModules.clear();
    });
  }

  void _clearAllLevels() {
    setState(() {
      _selectedLevels.clear();
    });
  }

  void _showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter by Module',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectAllModules();
                          });
                        },
                        child: Text('Select all'),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _modules.map((module) {
                      return FilterChip(
                        label: Text(module['moduleName']),
                        selected: _selectedModules.contains(module['moduleName']),
                        onSelected: (bool selected) {
                          setModalState(() {
                            if (selected) {
                              _selectedModules.add(module['moduleName']);
                            } else {
                              _selectedModules.removeWhere((name) => name == module['moduleName']);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter by Level',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectAllLevels();
                          });
                        },
                        child: Text('Select all'),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _levels.map((level) {
                      return FilterChip(
                        label: Text(level),
                        selected: _selectedLevels.contains(level),
                        onSelected: (bool selected) {
                          setModalState(() {
                            if (selected) {
                              _selectedLevels.add(level);
                            } else {
                              _selectedLevels.removeWhere((name) => name == level);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            _clearAllModules();
                            _clearAllLevels();
                          });
                        },
                        child: Text('Clear all'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: Color(0xFF275998),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _filterCertificates();
                          Navigator.pop(context); // Đóng filter modal
                        },
                        child: Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFF275998),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        centerTitle: true,
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterDrawer(context); // Hiển thị drawer lọc
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _filterCertificates,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCertificates.length,
                  itemBuilder: (context, index) {
                    String moduleNames = _filteredCertificates[index]['moduleIds']['\$values']
                        .map((id) => getModuleNameById(id))
                        .join(', ');
                    return ListTile(
                      title: Text(_filteredCertificates[index]['certificateName'] ?? ''),
                      subtitle: Text('Module: $moduleNames, Level: ${_filteredCertificates[index]['level']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



