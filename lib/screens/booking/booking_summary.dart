import 'package:flutter/material.dart';
import 'confirm_booking.dart';

class BookingSummary extends StatefulWidget {
  final String service;
  final DateTime date;
  final TimeOfDay time;

  BookingSummary(
      {required this.service, required this.date, required this.time});

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  String selectedPaymentMethod = 'Cash'; // Default is Cash
  final String merchantPaymentNumber = '13000130'; // Simulated Merchant Payment Number
  bool isPaymentRefApplied = false;
  TextEditingController paymentRefController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Information
              Text('Service: ${widget.service}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Date: ${widget.date.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Time: ${widget.time.format(context)}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Payment Method Section
              Text('Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Lipa Namba Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = 'Lipa Namba';
                                isPaymentRefApplied = false; // Reset ref applied status
                                paymentRefController.clear(); // Clear the input field
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selectedPaymentMethod == 'Lipa Namba'
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Lipa Namba',
                                  style: TextStyle(
                                    color: selectedPaymentMethod == 'Lipa Namba'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        // Cash Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = 'Cash';
                                isPaymentRefApplied = false; // Reset ref applied status
                                paymentRefController.clear(); // Clear the input field
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selectedPaymentMethod == 'Cash'
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Cash',
                                  style: TextStyle(
                                    color: selectedPaymentMethod == 'Cash'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Show Lipa Namba Fields if 'Lipa Namba' is selected
                    if (selectedPaymentMethod == 'Lipa Namba')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Merchant Payment Number',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(merchantPaymentNumber,
                                    style: TextStyle(fontSize: 16)),
                                Icon(Icons.credit_card, color: Colors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Payment Reference Section (only shown if 'Lipa Namba' is selected)
              if (selectedPaymentMethod == 'Lipa Namba')
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Reference', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: paymentRefController,
                              decoration: InputDecoration(
                                hintText: 'Enter Payment Reference',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Payment Reference is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isPaymentRefApplied = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text('Apply', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      if (isPaymentRefApplied)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Text('Payment Reference applied',
                                  style: TextStyle(color: Colors.green)),
                              Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

              SizedBox(height: 20),

              // Next Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod == 'Lipa Namba' &&
                        !_formKey.currentState!.validate()) {
                      // Prevent navigation if payment reference is not valid
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('NEXT',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
