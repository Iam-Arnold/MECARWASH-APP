import 'package:flutter/material.dart';
import 'booking_summary.dart';

class ServiceBookingPage extends StatefulWidget {
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
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSummary(
            service: _selectedService,
            date: _selectedDate,
            time: TimeOfDay(
              hour: int.parse(_selectedTimeSlot!.split(':')[0]),
              minute: int.parse(_selectedTimeSlot!.split(':')[1].split(' ')[0]),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book A Wash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Dropdown
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

              // Custom Calendar UI
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
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
                        'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Hour Selection UI
              Text(
                'Hour',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: timeSlots.map((time) {
                  bool isSelected = _selectedTimeSlot == time;
                  return ChoiceChip(
                    label: Text(
                      time,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.blue),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeSlot = time;
                      });
                    },
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.white,
                    elevation: 1.0,
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
