import 'package:flutter/material.dart';
import './theme/theme.dart'; // Import the theme file
import './screens/map.dart'; // Import the map screen file
import './components/search_bar.dart';
import './screens/search_filter_page.dart'; // Import the search filter screen

void main() {
  runApp(eDrop());
}

class eDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eDrop',
      theme: AppTheme.themeData, // Use the theme from theme.dart
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Map(), // Map screen
    SearchFilterPage(), // Add your filter page here
    Center(child: Text('Activity Page')), // Placeholder for activity
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.blue,
        title: Text('Hi, Arnold!', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,
                color: Colors.white), // Assuming this is the obscured icon
            onPressed: () {
              // Action for notifications icon
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),            
          ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Search_Bar(),            
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Show page based on navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Filter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Activity',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
