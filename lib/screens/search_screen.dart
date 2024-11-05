import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sap_mobile/screens/moduleMM.dart'; // Import CertificateDetail screen

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

  Future<void> fetchModules() async {
    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/SapModule/get-all',
      );

      if (response.data != null) {
        setState(() {
          _modules = List<Map<String, dynamic>>.from(response.data['\$values']);
        });
      }
    } catch (e) {
      print('Error fetching modules: $e');
    }
  }

  Future<void> fetchCertificates() async {
    try {
      var response = await Dio().get(
        'https://swdsapelearningapi.azurewebsites.net/api/Certificate/get-all',
      );

      if (response.data != null && response.data['\$values'] != null) {
        setState(() {
          _certificates = List<Map<String, dynamic>>.from(response.data['\$values']);
          _filteredCertificates = _certificates;
        });
      }
    } catch (e) {
      print('Error fetching certificates: $e');
    }
  }

  String getModuleNameById(int moduleId) {
    final module = _modules.firstWhere((mod) => mod['id'] == moduleId, orElse: () => {});
    return module.isNotEmpty ? module['moduleName'] : 'Unknown';
  }

  void _filterCertificates() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCertificates = _certificates.where((certificate) {
        bool matchesQuery = certificate['certificateName']!.toLowerCase().contains(query);
       
        bool matchesModule = _selectedModules.isEmpty ||
            certificate['moduleIds']['\$values'].any((id) => _selectedModules.contains(getModuleNameById(id)));
       
        bool matchesLevel = _selectedLevels.isEmpty || _selectedLevels.contains(certificate['level']);
        return matchesQuery && matchesModule && matchesLevel;
      }).toList();
    });
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
            Navigator.pop(context);
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
                      onTap: () async {
                        // Điều hướng đến CertificateDetail khi nhấn vào module
                        var certificateId = _filteredCertificates[index]['id'];
                        var certificateName = _filteredCertificates[index]['certificateName'] ?? 'Certificate';
                        var level = _filteredCertificates[index]['level'] ?? 'Intermediate';
                        var topics = await fetchTopicsForCertificate(certificateId);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CertificateDetail(
                              certificateName,
                              level: level,
                              idcertificate: '',
                              topics: topics,
                            ),
                          ),
                        );
                      },
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

  // Hàm lấy danh sách topics liên quan đến chứng chỉ
  // Hàm lấy danh sách topics liên quan đến chứng chỉ và lọc theo độ dài ký tự
Future<List<dynamic>> fetchTopicsForCertificate(int certificateId) async {
  try {
    var response = await Dio().get(
      'https://swdsapelearningapi.azurewebsites.net/api/TopicArea/get-all',
    );

    if (response.data != null && response.data['\$values'] != null) {
      return List<Map<String, dynamic>>.from(response.data['\$values'])
          .where((topic) =>
              topic['certificateId'] == certificateId &&
              topic['topicName'] != null &&
              topic['topicName'].length >= 10 &&
              topic['topicName'].length <= 35)
          .toList();
    }
  } catch (e) {
    print('Error fetching topics: $e');
  }
  return [];
}

}
