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
        "SAP S/4HANA Materials Management cho phép tích hợp đầy đủ với các module khác như SD và PP.",
        true),
    Question(
        "Trong SAP S/4HANA, bảng 'EKKO' chứa thông tin chi tiết về chứng từ mua hàng.",
        true),
    Question(
        "Công cụ MRP (Material Requirement Planning) không thể sử dụng trong module SAP MM.",
        false),
    Question(
        "Trong quy trình SAP MM, hóa đơn hàng mua (Invoice) luôn được ghi nhận trước khi thực hiện kiểm tra hàng hóa (Goods Receipt).",
        false),
    Question(
        "SAP MM cho phép quản lý cả hàng tồn kho trong kho thực tế và kho ảo.",
        true),
    Question(
        "Mọi dữ liệu chính (Master Data) trong SAP MM đều được lưu trữ trong bảng MARA.",
        true),
    Question(
        "SAP S/4HANA MM chỉ hỗ trợ các hoạt động mua bán cho doanh nghiệp nhỏ và vừa.",
        false),
    Question(
        "Đơn hàng mua (Purchase Order) trong SAP MM có thể được tạo mà không cần sử dụng yêu cầu mua hàng (Purchase Requisition).",
        true),
    Question(
        "Điều chỉnh hàng tồn kho trong SAP MM được thực hiện bằng cách sử dụng các giao dịch như MB1A và MB1B.",
        true),
    Question(
        "Các phiên bản SAP S/4HANA không còn hỗ trợ các báo cáo tài chính dựa trên mô-đun MM.",
        false),
    Question(
        "Quy trình kiểm tra chất lượng (Quality Inspection) không thể được tích hợp trong quy trình nhận hàng (Goods Receipt) của SAP MM.",
        false),
    Question(
        "SAP MM hỗ trợ cả quy trình mua hàng trong nước và quốc tế.", true),
    Question(
        "Các yêu cầu mua hàng trong SAP MM không thể tự động chuyển đổi thành đơn hàng mua.",
        false),
    Question(
        "SAP MM cho phép tích hợp với SAP Ariba để tối ưu hóa quy trình mua sắm.",
        true),
    Question("SAP MM không hỗ trợ quy trình quản lý hợp đồng mua bán dài hạn.",
        false),
    Question(
        "Quy trình đặt hàng gián tiếp (Indirect Procurement) không thể được quản lý trong SAP MM.",
        false),
    Question(
        "SAP MM cho phép tạo báo cáo tùy chỉnh thông qua các công cụ như SAP Query và SAP Fiori.",
        true),
    Question(
        "Trong SAP MM, việc theo dõi hàng hóa trong quá trình vận chuyển không được hỗ trợ.",
        false),
    Question(
        "SAP MM cho phép phân loại nhà cung cấp dựa trên hiệu suất của họ.",
        true),
    Question(
        "SAP MM hỗ trợ việc quản lý các hợp đồng cung cấp theo lịch.", true),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(fontSize: 18)),
                // Cập nhật phần tiến độ dựa trên số lượng câu hỏi
                Text(
                    'Progress: ${(100 * (currentQuestionIndex + 1) / questions.length).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex].questionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        answerSelected == null ? () => checkAnswer(true) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: answerSelected == true
                          ? (isCorrect == true ? Colors.green : Colors.red)
                          : Colors.blue,
                    ),
                    child: Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white, // Màu chữ trắng
                        fontWeight: FontWeight.bold, // Chữ in đậm
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: answerSelected == null
                        ? () => checkAnswer(false)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: answerSelected == false
                          ? (isCorrect == false ? Colors.red : Colors.green)
                          : Colors.blue,
                    ),
                    child: Text(
                      'False',
                      style: TextStyle(
                        color: Colors.white, // Màu chữ trắng
                        fontWeight: FontWeight.bold, // Chữ in đậm
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                    SizedBox(height: 10),
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
            Spacer(), // Đẩy các nút xuống dưới cùng
            ElevatedButton(
              onPressed: answerSelected != null ? nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: answerSelected == null
                    ? Colors.grey
                    : isCorrect!
                        ? Colors.green
                        : Colors.red, // Đổi màu theo trạng thái câu trả lời
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Finish' // Hiển thị "Finish" nếu là câu hỏi cuối cùng
                    : 'Next Question',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
              Center(
                // Đặt nút ở giữa
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Quay lại trang thứ nhất
                    Navigator.pop(context); // Quay lại trang thứ hai
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Thay đổi màu nền nút
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12), // Điều chỉnh padding
                    textStyle:
                        TextStyle(fontSize: 18), // Điều chỉnh kích cỡ chữ
                  ),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white, // Màu chữ trắng
                      fontWeight: FontWeight.bold, // Chữ in đậm
                    ),
                  ),
                ),
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
