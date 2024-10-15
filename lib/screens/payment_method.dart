import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethod> {
  String? _selectedPaymentMethod = 'Mastercard'; // Default selected method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stepIndicator('Overview', false),
                stepIndicator('Payment Method', true),
                stepIndicator('Confirmation', false),
              ],
            ),
          ),
          SizedBox(height: 10),
          
          // Payment Methods Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Mastercard option
                _buildPaymentOption(
                  context,
                  icon: Icons.credit_card,
                  label: 'Mastercard',
                  selectedValue: _selectedPaymentMethod,
                  onSelect: () {
                    setState(() {
                      _selectedPaymentMethod = 'Mastercard';
                    });
                  },
                ),

                // Paypal option
                _buildPaymentOption(
                  context,
                  icon: Icons.payment,
                  label: 'Paypal',
                  selectedValue: _selectedPaymentMethod,
                  onSelect: () {
                    setState(() {
                      _selectedPaymentMethod = 'Paypal';
                    });
                  },
                ),

                // Google Pay option
                _buildPaymentOption(
                  context,
                  icon: Icons.account_balance_wallet,
                  label: 'Google Pay',
                  selectedValue: _selectedPaymentMethod,
                  onSelect: () {
                    setState(() {
                      _selectedPaymentMethod = 'Google Pay';
                    });
                  },
                ),

                // Add Payment Method
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Action to add a new payment method
                  },
                  child: Text(
                    'Add Payment Method',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Spacer(),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle the Continue action
              },
              child: Text('CONTINUE', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.orange, // Button color similar to design
                foregroundColor: Colors.white,  // Text color white
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step Indicator Widget
  Widget stepIndicator(String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? Colors.orange : Colors.grey[300],
          child: Text(
            title[0],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }

  // Payment Option Widget
  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String? selectedValue,
    required VoidCallback onSelect,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          size: 36,
          color: selectedValue == label ? Colors.orange : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Radio<String>(
          value: label,
          groupValue: selectedValue,
          activeColor: Colors.orange,
          onChanged: (String? value) {
            onSelect();
          },
        ),
        onTap: onSelect, // When tapping the entire row, it should select the option
      ),
    );
  }
}
