import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'admin_list.dart';
import 'admin_search.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  final PageController controller = PageController();
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: PageView(
        
        controller: controller,
        children: const [
          Center(child: ListScreen()),
          Center(child: AdminSearch()),
        ],
      ),
    );
  }
}
