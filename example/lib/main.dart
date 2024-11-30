import 'package:curved_bottom_navigation_bar/curved_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// A demo app showcasing the [CurvedBottomNavigationBar].
class MyApp extends StatefulWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The index of the currently selected navigation item.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /// The main screen's body with the [CurvedBottomNavigationBar].
        body: Center(
          child: CurvedBottomNavigationBar(
            /// The color of the selected item's icon and label.
            selectedItemColor: Colors.red,

            /// The font style for the selected item's label.
            selectedItemFontStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.red,
            ),

            /// The background color of the navigation bar.
            backgroundColor: Colors.white,

            /// The color of unselected item icons.
            unselectedIconColor: Colors.grey,

            /// The index of the currently selected item.
            selectedIndex: _selectedIndex,

            /// Callback when an item is tapped.
            /// Updates the [selectedIndex] to display the corresponding screen.
            onItemTapped: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            /// Labels for each navigation item.
            labels: const <String>[
              "Home",
              "Cart",
              "Notifications",
              "Profile"
            ],

            /// Icons corresponding to each navigation item.
            icons: const <IconData>[
              Icons.home,
              Icons.shopping_cart,
              Icons.notifications,
              Icons.person,
            ],

            /// Screens displayed for each navigation item.
            screens: <Widget>[
              /// Screen for the "Home" tab.
              Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Home Screen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              /// Screen for the "Cart" tab.
              Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'Cart Screen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              /// Screen for the "Notifications" tab.
              Container(
                color: Colors.orange,
                child: const Center(
                  child: Text(
                    'Notifications Screen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              /// Screen for the "Profile" tab.
              Container(
                color: Colors.yellow,
                child: const Center(
                  child: Text(
                    'Profile Screen',
                    style: TextStyle(color: Colors.black),
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
