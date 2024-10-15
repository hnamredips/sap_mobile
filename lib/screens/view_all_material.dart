import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/home_page.dart';
import 'package:sap_mobile/screens/home_screen.dart';
import 'moduleMM.dart'; // Import các trang module bạn đã tạo

class ViewAllMaterial extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<ViewAllMaterial> {
  final List<String> modules = [
    'MM',
    'PP',
    'SD',
    'FI',
    'CO',
    'PM',
    'HCM',
    'BI',
    'QM',
    'PS',
    'HR',
    'SCM',
    'CRM',
    'PLM',
    'SRM',
    'GTS',
    'EHS',
    'IS',
    'BW',
    'MDG',
    'S4HANA',
    'FSCM',
    'TM',
    'IBP'
  ];

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    List<String> modulesToShow = showAll ? modules : modules.sublist(0, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories (24 Modules)'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: modulesToShow.map((module) {
                  return GestureDetector(
                    onTap: () {
                      navigateToModule(module);
                    },
                    child: buildModuleBox(module),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
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
        child: Text(
          module,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
