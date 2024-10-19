import 'package:flutter/material.dart';
import '../../models/booking_info.dart';
import 'booking_summary.dart';

class ServiceBookingPage extends StatefulWidget {
  final BookingInfo bookingInfo;

  ServiceBookingPage({required this.bookingInfo});

  @override
  _ServiceBookingPageState createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends State<ServiceBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedService = 'Car Wash';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> timeSlots = ['08:00 am', '08:45 am', '09:30 am', '10:15 am'];

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  _submitBooking() {
    if (_formKey.currentState!.validate() && _selectedTimeSlot != null) {
      // Update the bookingInfo with selected service, date, and time
      widget.bookingInfo.service = _selectedService;
      widget.bookingInfo.date = _selectedDate;
      widget.bookingInfo.timeSlot = _selectedTimeSlot!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSummary(
            service: widget.bookingInfo.service,
            date: widget.bookingInfo.date,
            time: TimeOfDay
                .now(), // Assuming you want to pass the current time for now
            userName:
                widget.bookingInfo.customerName, // Replace with actual property
            userPhone: widget.bookingInfo.phone, // Replace with actual property
            address: widget.bookingInfo.address, // Replace with actual property
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book A Wash',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(labelText: 'Service Type'),
                items: ['Car Wash', 'Detailing', 'Oil Change']
                    .map((service) => DropdownMenuItem(
                          child: Text(service),
                          value: service,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedService = val!;
                  });
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: EdgeInsets.all(16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 16)),
                      Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Time Slot',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Time Slot'),
                items: timeSlots
                    .map((time) => DropdownMenuItem(
                          child: Text(time),
                          value: time,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedTimeSlot = val;
                  });
                },
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitBooking,
                  child: Text('CONTINUE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
