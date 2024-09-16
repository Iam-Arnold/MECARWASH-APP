import 'package:flutter/material.dart';

import 'service_booking.dart';

class CustomerPreBookingInfo extends StatelessWidget {
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
        title: Text('Book A Wash'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Your Information" section
            Text(
              'Your Information',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField(Icons.person, 'Moe Jehad'),
            SizedBox(height: 10),
            _buildTextField(Icons.phone, '+145987654321'),
            SizedBox(height: 10),
            _buildTextField(Icons.location_on, '10220 104 Ave NW, Edmonton, AB T5J 1B8, Canada'),
            SizedBox(height: 20),

            // "Car Information" section
            Text(
              'Car Information',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField(null, 'Make')),
                SizedBox(width: 10),
                Expanded(child: _buildTextField(null, 'Color')),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField(null, 'Model'),
            SizedBox(height: 10),
            _buildTextField(null, 'Plate Number'),
            SizedBox(height: 10),
            _buildTextField(null, 'Instruction'),
            SizedBox(height: 30),

            // "Next" button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServiceBookingPage()),
                  );
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData? icon, String hint) {
    return TextField(
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