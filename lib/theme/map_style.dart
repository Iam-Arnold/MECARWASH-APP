class MapStyle {
  static const String style = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#E3F2FD"  // Light blue for general areas
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"  // Hides unnecessary icons
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#1E88E5"  // Medium blue for text labels
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#FFFFFF",  // White text outline for clarity
          "weight": 2
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#BBDEFB"  // Very light blue for administrative areas
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#FF0000",  // Red for country labels to stand out
          "weight": 1.5
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#E1F5FE"  // Soft blue for points of interest
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#FFFFFF"  // Light blue for roads
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#1E88E5"  // Medium blue for road labels
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#B3E5FC"  // Light blue for water
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#E0F7FA"  // Light blue for landscape areas
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#B3E5FC"  // Light blue for transit areas
        }
      ]
    }
  ]
  ''';
}
