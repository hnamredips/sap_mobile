// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vnpay_flutter/vnpay_flutter.dart';

// class Example extends StatefulWidget {
//   const Example({Key? key}) : super(key: key);

//   @override
//   State<Example> createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> {
//   String responseCode = '';

//   Future<void> onPayment() async {
//     final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
//       url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
//       version: '2.0.1',
//       tmnCode: 'xxxx', //vnpay tmn code, get from vnpay
//       txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
//       orderInfo: 'Pay 300.000 VND', //order info, default is Pay Order
//       amount: 30000,
//       returnUrl: 'xxxxxx', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
//       ipAdress: '192.168.10.10',
//       vnpayHashKey: '8HP1L81DWM79OIWQ8XLQMZM8FIXPU0P2', //vnpay hash key, get from vnpay
//       vnPayHashType: VNPayHashType.HMACSHA512, //hash type. Default is HMACSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2,
//       vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
//     );
//     await VNPAYFlutter.instance.show(
//       paymentUrl: paymentUrl,
//       onPaymentSuccess: (params) {
//         setState(() {
//           responseCode = params['vnp_ResponseCode'];
//         });
//       },
//       onPaymentError: (params) {
//         setState(() {
//           responseCode = 'Error';
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Response Code: $responseCode'),
//             TextButton(
//               onPressed: onPayment,
//               child: const Text('300.000VND'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }