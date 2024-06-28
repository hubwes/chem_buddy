import 'package:flutter/material.dart';
import '../widgets/solubility_table_widget.dart';
import '../widgets/ions_list_widget.dart';

class SolubilityMainPage extends StatefulWidget {
  @override
  _SolubilityMainPageState createState() => _SolubilityMainPageState();
}

class _SolubilityMainPageState extends State<SolubilityMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SolubilityTableWidget(),
    IonsListWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Solubility Table' : 'Ions List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
