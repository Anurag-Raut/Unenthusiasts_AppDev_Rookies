// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wastenot/customer/customer_dashboard/panelwidget.dart';
import 'maps_customer.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height * 0.1,
           maxHeight: MediaQuery.of(context).size.height * 0.7,
           parallaxEnabled: true,
           parallaxOffset: 0.5,
        // backdropEnabled: true, //darken background if panel is open
        color: Colors.transparent, //necessary if you have rounded corners for panel
        /// panel itself
        panel: Container(
          decoration: const BoxDecoration(
            // background color of panel
            color: Colors.redAccent,
            // rounded corners of panel
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0),),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              BarIndicator(),
              Center(
                child: Text("This is the sliding Widget",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        /// header of panel while collapsed
        collapsed: Container(
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0),),
          ),
          child: Column(
            children: const [
              BarIndicator(),
              Center(
                child: Text("This is the collapsed Widget",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        /// widget behind panel
        // ignore: prefer_const_constructors
        body: Center(
          child: CustomerMap(),
        ),
      ),
    );
  }
}

class BarIndicator extends StatelessWidget {
  const BarIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: 40, height: 3,
        decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}