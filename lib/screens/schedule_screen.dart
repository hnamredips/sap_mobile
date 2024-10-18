import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;

  List<String> _days = ['21', '22', '23', '24', '25', '26', '27'];
  List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  List<Map<String, String>> _schedule = [
    {
      'time': '11:35 13:05',
      'title': 'C_TS462_1',
      'location': 'Online 100',
      'details': 'Google Meet',
    },
    {
      'time': '13:15 14:45',
      'title': 'C_TS462_2',
      'location': 'Offline 111',
      'details': 'Room 111',
    },
    // Thêm các buổi học khác ở đây
  ];

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Horizontal Day Selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _days
                  .asMap()
                  .entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () => _selectDay(entry.key),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _selectedDayIndex == entry.key
                              ? Color(0xFF275998)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _weekDays[entry.key],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedDayIndex == entry.key
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedDayIndex == entry.key
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            if (_selectedDayIndex == entry.key)
                              Container(
                                height: 4,
                                width: 24,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Time and Course Rows
          Expanded(
            child: ListView.builder(
              itemCount: _schedule.length,
              itemBuilder: (context, index) {
                final item = _schedule[index];
                return Row(
                  children: [
                    // Time Column
                    Container(
                      padding: EdgeInsets.all(16),
                      width: 100,
                      child: Text(
                        item['time']!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // Course Details Column
                    Expanded(
                      child: Card(
                        color: Colors.white, // Đổi màu nền của Card
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Đổi màu chữ thành trắng
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    item['location']!,
                                    style: TextStyle(color: Colors.black), // Đổi màu chữ thành trắng
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                item['details']!,
                                style: TextStyle(color: Colors.black), // Đổi màu chữ thành trắng
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}