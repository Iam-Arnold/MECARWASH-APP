import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'confirm_booking.dart';

class BookingSummary extends StatefulWidget {
  final String service;
  final String description; // New field: Description of the service
  final DateTime date; // Date object
  final String time; // Time object
  final String userName; // New field: User name
  final String userPhone; // New field: User phone number
  final String address; // New field: Address

  BookingSummary({
    required this.service,
    required this.description, // Description argument
    required this.date,
    required this.time,
    required this.userName,
    required this.userPhone,
    required this.address,
  });

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  String selectedPaymentMethod = 'Cash'; // Default is Cash
  final String merchantPaymentNumber =
      '13000130'; // Simulated Merchant Payment Number
  bool isPaymentRefApplied = false;
  TextEditingController paymentRefController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    // Format the date using intl
    String formattedDate = DateFormat.yMMMMd()
        .format(widget.date); // Formats date in Month day, year format

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Book A Wash',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display user information
              buildSectionTitle('User Information'),
              buildInfoRow('Name', widget.userName),
              buildInfoRow('Phone', widget.userPhone),
              buildInfoRow('Address', widget.address),
              buildDivider(),

              // Display service details with description
              buildSectionTitle('Service Details'),
              buildInfoRow('Service', widget.service),
              buildInfoRow(
                  'Description', widget.description), // Displaying description
              buildInfoRow('Date', formattedDate),
              buildInfoRow('Time', widget.time),
              buildDivider(),

              // Payment Method Section
              buildSectionTitle('Payment'),
              buildPaymentMethodSelector(),

              // Payment Reference Section (only shown if 'Lipa Namba' is selected)
              if (selectedPaymentMethod == 'Lipa Namba')
                buildLipaNambaDetails(),
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

  // Build section title
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 20.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Build an information row
// Build an information row
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.5, // Adjusts width for value text
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // Truncates with dots (...)
              maxLines: 1, // Limits to one line
            ),
          ),
        ],
      ),
    );
  }

  // Build divider
  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(
        thickness: 1,
        color: Colors.grey.shade300,
      ),
    );
  }

  // Build Payment Method Selector
  Widget buildPaymentMethodSelector() {
    return Container(
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
                  child: buildPaymentButton(
                      'Lipa Namba', selectedPaymentMethod == 'Lipa Namba'),
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
                  child: buildPaymentButton(
                      'Cash', selectedPaymentMethod == 'Cash'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build individual payment button
  Widget buildPaymentButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Build Lipa Namba Details
  Widget buildLipaNambaDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Lipa Namba Details'),
        buildInfoRow('Merchant Payment Number', merchantPaymentNumber),
        SizedBox(height: 20),

        // Payment Reference Input
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Payment Reference'),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      ],
    );
  }
}
