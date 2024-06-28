import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chemical_search_page.dart';
import 'search_history_page.dart';


class MainSearchPage extends ConsumerStatefulWidget {
  @override
  _MainSearchPageState createState() => _MainSearchPageState();
}

class _MainSearchPageState extends ConsumerState<MainSearchPage> {
  int _selectedIndex = 0;
  String _currentSearchTerm = '';

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onSearch(String compoundName) {
    setState(() {
      _currentSearchTerm = compoundName;
      _selectedIndex = 0;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          ChemicalSearchPage(
            onSearch: (term) => _onSearch(term),
            searchTerm: _currentSearchTerm,
          ),
          SearchHistoryPage(onSearch: _onSearch),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}