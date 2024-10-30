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
