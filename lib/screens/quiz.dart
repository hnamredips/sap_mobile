import 'package:flutter/material.dart';
import 'package:sap_mobile/screens/moduleMM.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<Quiz> {
  int currentQuestionIndex = 0;
  List<Question> questions = [
    Question(
    "SAP S/4HANA Materials Management allows full integration with other modules such as SD and PP.",
    true),
Question(
    "In SAP S/4HANA, the 'EKKO' table contains detailed information about purchasing documents.",
    true),
Question(
    "The MRP (Material Requirement Planning) tool cannot be used in the SAP MM module.",
    false),
Question(
    "In the SAP MM process, the purchase invoice is always recorded before the goods receipt.",
    false),
Question(
    "SAP MM allows management of both physical and virtual warehouse inventories.",
    true),
Question(
    "All master data in SAP MM is stored in the MARA table.",
    true),
Question(
    "SAP S/4HANA MM only supports purchasing activities for small and medium-sized enterprises.",
    false),
Question(
    "A Purchase Order in SAP MM can be created without using a Purchase Requisition.",
    true),
Question(
    "Inventory adjustments in SAP MM are performed using transactions such as MB1A and MB1B.",
    true),
Question(
    "SAP S/4HANA versions no longer support financial reporting based on the MM module.",
    false),
Question(
    "Quality inspection processes cannot be integrated into the Goods Receipt process in SAP MM.",
    false),
Question(
    "SAP MM supports both domestic and international procurement processes.",
    true),
Question(
    "Purchase Requisitions in SAP MM cannot be automatically converted into Purchase Orders.",
    false),
Question(
    "SAP MM allows integration with SAP Ariba to optimize procurement processes.",
    true),
Question(
    "SAP MM does not support long-term contract management processes.",
    false),
Question(
    "Indirect procurement processes cannot be managed in SAP MM.",
    false),
Question(
    "SAP MM allows creating custom reports through tools like SAP Query and SAP Fiori.",
    true),
Question(
    "In SAP MM, tracking goods in transit is not supported.",
    false),
Question(
    "SAP MM allows supplier classification based on their performance.",
    true),
Question(
    "SAP MM supports the management of supply contracts with scheduling agreements.",
    true),

  ];

  int score = 0;
  bool? answerSelected;
  bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dòng hiển thị câu hỏi hiện tại và phần trăm tiến độ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(fontSize: 18)),
                Text(
                  'Progress: ${(100 * (currentQuestionIndex + 1) / questions.length).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Thẻ cố định cho phần câu hỏi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE1E1E1), // Màu nền theo mã E1E1E1
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5), // Stroke mờ trắng
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              height: 150, // Cố định chiều cao thẻ câu hỏi
              child: Center(
                // Chữ nằm giữa
                child: Text(
                  questions[currentQuestionIndex].questionText,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black, // Màu chữ đen
                    fontWeight: FontWeight.normal, // Không in đậm
                  ),
                  maxLines: 5, // Giới hạn tối đa 5 dòng
                  overflow:
                      TextOverflow.ellipsis, // Thêm dấu ba chấm nếu quá dài
                  textAlign: TextAlign.center, // Căn giữa chữ
                ),
              ),
            ),

            SizedBox(height: 10), // Khoảng cách giữa thẻ câu hỏi và nút

            // Nút True
            Container(
              width: double.infinity, // Chiều rộng bằng với thẻ câu hỏi
              child: ElevatedButton(
                onPressed: () => checkAnswer(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF61C273), // Màu xanh lá cây cho nút True
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo tròn góc nhẹ
                    side: BorderSide(
                      color: (answerSelected ==
                              true) // Nếu người dùng chọn True
                          ? Colors.black
                          : Colors
                              .transparent, // Viền đen xung quanh đáp án đã chọn
                      width: 3,
                    ),
                  ),
                  minimumSize: Size(
                      double.infinity, 90), // Chiều cao nút bằng thẻ câu hỏi
                  padding: EdgeInsets.symmetric(
                      vertical: 70), // Điều chỉnh chiều cao nút
                ),
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Kích thước chữ
                  ),
                ),
              ),
            ),

            SizedBox(height: 10), // Khoảng cách giữa hai nút

// Nút False
            Container(
              width: double.infinity, // Chiều rộng bằng với thẻ câu hỏi
              child: ElevatedButton(
                onPressed: () => checkAnswer(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE53A42), // Màu đỏ cho nút False
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo tròn góc nhẹ
                    side: BorderSide(
                      color: (answerSelected ==
                              false) // Nếu người dùng chọn False
                          ? Colors.black
                          : Colors
                              .transparent, // Viền đen xung quanh đáp án đã chọn
                      width: 3,
                    ),
                  ),
                  minimumSize: Size(
                      double.infinity, 90), // Chiều cao nút bằng thẻ câu hỏi
                  padding: EdgeInsets.symmetric(
                      vertical: 70), // Điều chỉnh chiều cao nút
                ),
                child: Text(
                  'False',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Kích thước chữ
                  ),
                ),
              ),
            ),

            Spacer(),

            // Phần hiển thị kết quả chỉ khi đã chọn đáp án
            if (answerSelected != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect! ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect! ? 'Amazing!' : 'Ups.. that\'s wrong',
                      style: TextStyle(
                        color: isCorrect! ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Answer: ${questions[currentQuestionIndex].answer ? "True" : "False"}',
                      style: TextStyle(
                        color: isCorrect! ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 0),

            // Nút Next Question luôn hiển thị và bị disable nếu chưa chọn đáp án
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: answerSelected != null ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: answerSelected == null
                      ? Colors.grey
                      : (isCorrect! ? Color(0xFF275998) : Color(0xFF275998)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  currentQuestionIndex == questions.length - 1
                      ? 'Finish'
                      : 'Next Question',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAnswer(bool userAnswer) {
    setState(() {
      answerSelected = userAnswer;
      isCorrect = userAnswer == questions[currentQuestionIndex].answer;
      if (isCorrect!) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        answerSelected = null;
        isCorrect = null;
      } else {
        // Quiz finished
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Quiz Finished!'),
            content: Text('Your score is $score/${questions.length}'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Đặt khoảng cách đều giữa hai nút
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng dialog
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Quiz()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF275998), // Thay đổi màu nền nút
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10), // Điều chỉnh padding
                      textStyle:
                          TextStyle(fontSize: 18), // Điều chỉnh kích cỡ chữ
                    ),
                    child: Text(
                      'Retake Quiz',
                      style: TextStyle(
                        color: Colors.white, // Màu chữ trắng
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Quay lại trang trước
                      Navigator.pop(context); // Quay lại trang thứ hai
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF275998), // Thay đổi màu nền nút
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10), // Điều chỉnh padding
                      textStyle:
                          TextStyle(fontSize: 18), // Điều chỉnh kích cỡ chữ
                    ),
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white, // Màu chữ trắng
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}

class Question {
  final String questionText;
  final bool answer;

  Question(this.questionText, this.answer);
}
