 
import 'package:curved_bottom_navigation_bar/curved_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(   
        body: Center(
            child: CurvedBottomNavigationBar(
        selectedItemColor: Colors.red,
        selectedItemFontStyle: const TextStyle(fontWeight: FontWeight.normal,color: Colors.red),
          backgroundColor: Colors.white,
          unselectedIconColor: Colors.grey,
          selectedIndex: _selectedIndex,
          onItemTapped: (v) {
            setState(() {
              _selectedIndex = v;
            });
          },
          labels: const <String>["Home", "Cart", "Notifications", "Profile"],
          icons: const <IconData>[
            Icons.home,
            Icons.shopping_cart,
            Icons.notifications,
            Icons.person
          ],
          screens:  <Widget>[
             Container(
              color: Colors.black,
            ),
                Container(
              color: Colors.green,
           ),
                     Container(
              color: Colors.orange,
           ),
                   Container(
              color: Colors.yellow,
          ),
          ],
        )),
      ),
    );
  }
}
