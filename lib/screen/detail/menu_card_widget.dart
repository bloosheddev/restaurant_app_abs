import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String menuName;

  const MenuCard({super.key, required this.menuName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(8.5), child: Text(menuName)),
    );
  }
}
