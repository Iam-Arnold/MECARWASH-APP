// import 'package:flutter/material.dart';
// import './map.dart'; // Import your custom map widget
// import '..//search_filter_page.dart'

// class MapLandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Venues Near You'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_alt_outlined), 
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchFilterPage()), 
//               );
//             }
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MapWidget(), // Assuming this is your map widget
//           Positioned(
//             top: 16,
//             left: 16,
//             right: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: 'e.g. burgers, fries, pasta',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     '1100 S Flower St',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text('Burgers • Italian • Hot Vine • Grilled'),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.arrow_forward_ios),
//                         onPressed: () {
//                           // Handle venue details click
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle route navigation
//                     },
//                     child: Text('Get Directions'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
