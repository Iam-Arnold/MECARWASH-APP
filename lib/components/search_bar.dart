import 'package:flutter/material.dart';

import 'sp_modal.dart';

class Search_Bar extends StatefulWidget {
  final ValueChanged<bool> onSearchActive;

  Search_Bar({required this.onSearchActive});

  @override
  _Search_BarState createState() => _Search_BarState();
}

class _Search_BarState extends State<Search_Bar> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  void _onSearchChanged(String value) {
    if (value.isEmpty && !_isSearchActive) {
      setState(() {
        _isSearchActive = true;
      });
      widget.onSearchActive(true); // Notify parent about active search
    }
  }

  void _onSearchFieldTapped() {
    setState(() {
      _isSearchActive = true; // Activate search when field is tapped
    });
    widget.onSearchActive(true); // Notify parent about active search
    _showSearchModal(); // Show the modal with available service providers
  }

  // Modal to display service providers
  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceProviderModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      onTap: _onSearchFieldTapped,
      decoration: InputDecoration(
        hintText: 'Search for services...',
        suffixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
