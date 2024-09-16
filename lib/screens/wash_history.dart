import 'package:flutter/material.dart';

class CarWashHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of wash history records (mock data)
    final List<Map<String, String>> history = [
      {
        'location': '22 Sandvik Street, Dar es Salaam',
        'date': '13 Sep',
        'time': '20:06',
        'price': '6500 Tsh',
      },
      {
        'location': 'Mwembe Tango, Dar es Salaam',
        'date': '13 Sep',
        'time': '17:27',
        'price': '5500 Tsh',
      },
      {
        'location': 'GTBank Tanzania, Dar es Salaam',
        'date': '13 Sep',
        'time': '07:32',
        'price': '3500 Tsh',
      },
      {
        'location': '22 Sandvik Street, Dar es Salaam',
        'date': '12 Sep',
        'time': '18:46',
        'price': '2500 Tsh',
      },
      {
        'location': 'GTBank Tanzania, Dar es Salaam',
        'date': '12 Sep',
        'time': '07:34',
        'price': '3500 Tsh',
      },
      {
        'location': 'GTBank Tanzania, Dar es Salaam',
        'date': '10 Sep',
        'time': '08:15',
        'price': 'Cancelled',
      },
    ];

    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Service Section
            SizedBox(height: 20),
            Text(
              'Upcoming Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blueGrey[700]),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No upcoming services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Need a wash soon? Schedule ahead for convenience!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            // Add action for scheduling a service
                          },
                          child: Text(
                            'Schedule a service',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Service History Section
            Text(
              'September 2024',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // History List
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.local_car_wash_rounded,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      title: Text(history[index]['location'] ?? ''),
                      subtitle: Text('${history[index]['date']}, ${history[index]['time']}'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            history[index]['price'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: history[index]['price'] == 'Cancelled'
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                          if (history[index]['price'] != 'Cancelled')
                            TextButton.icon(
                              onPressed: () {
                                // Rebook action
                              },
                              icon: Icon(Icons.refresh_rounded, size: 16, color: Colors.blueAccent),
                              label: Text(
                                'Rebook',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
