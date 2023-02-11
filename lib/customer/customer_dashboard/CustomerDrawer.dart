import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'customer_dashboard.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
   late MenuController menuController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
      
        

          ItemHiddenMenu(
              name: "homePage",
              baseStyle: TextStyle(),
              selectedStyle: TextStyle()),
          CustomerDashboard())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      // disableAppBarDefault: true,
      elevationAppBar: 0.1,

      backgroundColorAppBar: Colors.red[400],
    
      
      
      
      // : AppBar(backgroundColor: Colors.transparent,),
        screens: _pages, backgroundColorMenu: Colors.deepPurple);
  }
}
