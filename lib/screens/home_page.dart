import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/home_tabs/account.dart';
import 'package:meesho_dice/screens/home_tabs/home_tab.dart';
import 'package:meesho_dice/screens/home_tabs/order_tab.dart';
import 'package:meesho_dice/widgets/home_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    OrderTab(),
    AccountTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(136.0),
        child: AppBar(
          title: HomeAppbarLeading(userName: "userName"),
          actions: HomeAppbarTrailing().getAppBarACtions(),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(12),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 12.0, left: 16.0, right: 16.0),
                child: SearchBar(hintText: "Search"),
              )),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Icon(Icons.home) : Icon(Icons.ac_unit),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
