import 'package:flutter/material.dart';
import 'package:project/repositries/location.dart';
import 'History_screen.dart';
import 'history.dart';

class home extends StatefulWidget{
  home({super.key});

  State<home> createState() => _homeStates();
}

class _homeStates extends State<home> {

  int _index = 0;

  final List<Widget> _screens = [
    maps(),
    HistoryScreen(),
  ];


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment 3",),
      ),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
          onTap: (i) {
            setState(() {
              _index = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "home",),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: "Location",)
          ]
      ),
    );
  }
}