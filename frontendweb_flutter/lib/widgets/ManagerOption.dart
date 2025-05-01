import 'package:flutter/material.dart';
import 'TopNavigationMenu.dart';

class ManagerOption extends StatefulWidget {
  final List<String> menuItems;
  final List<Widget> views;
  final double? menuWidth;
  final double? menuHeight;

  const ManagerOption({
    Key? key,
    required this.menuItems,
    required this.views,
    this.menuWidth = double.infinity,
    this.menuHeight = 60,
  }) : super(key: key);

  @override
  _ManagerOptionState createState() => _ManagerOptionState();
}

class _ManagerOptionState extends State<ManagerOption> {
  int _currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          TopNavigationMenu(
            menuItems: widget.menuItems,
            currentIndex: _currentViewIndex,
            
            onItemSelected: (index) {
              setState(() {
                _currentViewIndex = index;
              });
            },
          ),
          Expanded(
            child: widget.views[_currentViewIndex],
          ),
        ],
      ),
    );
  }
}
