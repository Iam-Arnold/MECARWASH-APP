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
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedService = 'Standard Car Wash'; // Default selected service
  bool waxPolishSelected = false;
  bool interiorDetailingSelected = false;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> timeSlots = [
    '1:00 AM',
    '2:00 AM',
    '3:00 AM',
    '6:00 AM',
    '7:00 AM',
    '8:00 AM'
  ];

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
            time: widget.bookingInfo.timeSlot,
            userName: widget.bookingInfo.customerName,
            userPhone: widget.bookingInfo.phone,
            address: widget.bookingInfo.address,
            description: _descriptionController.text, // Pass description here
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.lightBlue;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Choose Your Service',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _sectionTitle('Select Service'),
              Column(
                children: [
                  _buildRadioTile('Standard Car Wash', themeColor),
                  _buildRadioTile('Premium Car Wash', themeColor),
                ],
              ),
              _sectionTitle('Extras'),
              _buildCheckboxTile('Wax & Polish Service', waxPolishSelected,
                  (val) {
                setState(() {
                  waxPolishSelected = val!;
                });
              }, themeColor),
              _buildCheckboxTile(
                  'Premium Interior Detailing', interiorDetailingSelected,
                  (val) {
                setState(() {
                  interiorDetailingSelected = val!;
                });
              }, themeColor),
              SizedBox(height: 16),
              _sectionTitle('How would you prefer the service?'),
              _buildDescriptionField(themeColor), // Add description field here
              SizedBox(height: 16),
              _sectionTitle('Choose Your Appointment'),
              GestureDetector(
                onTap: _pickDate,
                child: _buildDatePicker(themeColor),
              ),
              SizedBox(height: 16),
              _sectionTitle('Time Slot'),
              _buildTimeSlotGrid(themeColor),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitBooking,
                  child: Text('CONTINUE',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, Color themeColor) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      value: title,
      groupValue: _selectedService,
      activeColor: themeColor,
      onChanged: (val) {
        setState(() {
          _selectedService = val!;
        });
      },
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged, Color themeColor) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      value: value,
      activeColor: themeColor,
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(Color themeColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: themeColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.calendar_today, color: themeColor),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGrid(Color themeColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: timeSlots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 3, // Height and width ratio of the grid
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTimeSlot = timeSlots[index];
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _selectedTimeSlot == timeSlots[index]
                  ? themeColor
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedTimeSlot == timeSlots[index]
                    ? themeColor
                    : Colors.grey,
              ),
            ),
            child: Text(
              timeSlots[index],
              style: TextStyle(
                color: _selectedTimeSlot == timeSlots[index]
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionField(Color themeColor) {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Describe how you prefer the service...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeColor),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
