import 'package:flutter/material.dart';
import 'service_booking.dart';
import '../../models/booking_info.dart';

class CustomerPreBookingInfo extends StatefulWidget {
  @override
  _CustomerPreBookingInfoState createState() => _CustomerPreBookingInfoState();
}

class _CustomerPreBookingInfoState extends State<CustomerPreBookingInfo> {
  final TextEditingController _nameController = TextEditingController(text: 'Moe Jehad');
  final TextEditingController _phoneController = TextEditingController(text: '+145987654321');
  final TextEditingController _addressController = TextEditingController(text: '10220 104 Ave NW, Edmonton, AB T5J 1B8, Canada');
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Added email field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Book A Wash', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Information', style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField(Icons.person, 'Name', _nameController),
            SizedBox(height: 10),
            _buildTextField(Icons.phone, 'Phone', _phoneController),
            SizedBox(height: 10),
            _buildTextField(Icons.location_on, 'Address', _addressController),
            SizedBox(height: 10),
            _buildTextField(Icons.email, 'Email', _emailController), // Added email text field
            SizedBox(height: 20),
            Text('Car Information', style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField(null, 'Make', _makeController)),
                SizedBox(width: 10),
                Expanded(child: _buildTextField(null, 'Color', _colorController)),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField(null, 'Model', _modelController),
            SizedBox(height: 10),
            _buildTextField(null, 'Plate Number', _plateNumberController),
            SizedBox(height: 10),
            _buildTextField(null, 'Instruction', _instructionController),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  // Gather all data into a BookingInfo model
                  BookingInfo bookingInfo = BookingInfo(
                    customerName: _nameController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    carMake: _makeController.text,
                    carColor: _colorController.text,
                    carModel: _modelController.text,
                    plateNumber: _plateNumberController.text,
                    instruction: _instructionController.text,
                    service: 'Car Wash', // Placeholder for now
                    date: DateTime.now(), // Placeholder, set in ServiceBookingPage
                    timeSlot: '', // Placeholder, set in ServiceBookingPage
                    email: _emailController.text, // Added email information
                  );
                  // Navigate to ServiceBookingPage and pass BookingInfo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServiceBookingPage(bookingInfo: bookingInfo)),
                  );
                },
                child: Text('NEXT', style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData? icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
