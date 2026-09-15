import 'package:flutter/material.dart';
import 'package:user_login_project/feature/presentation/view/products_tab.dart';
import '../../../feature/data/model/auth_user.dart';
import '../../../feature/presentation/view/profile_tab.dart';

class MainHomeScreen extends StatefulWidget {
  final AuthUser user;
  
  const MainHomeScreen({super.key, required this.user});
  
  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
  
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const Center(child: Text('Home Feed'),),
      ProductsTab(),
      ProfileTab(user: widget.user)
    ];
    
    final List<String> title = ['Home','Products','Profile'];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title[_currentIndex]),
        backgroundColor: Colors.blue,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        }, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Product'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      ),
    );
  }
  
}