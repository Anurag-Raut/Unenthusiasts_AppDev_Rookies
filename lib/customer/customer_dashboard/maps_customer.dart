import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wastenot/customer/customer_dashboard/CustomerDrawer.dart';
import 'package:wastenot/customer/customer_dashboard/main_screen.dart';

class CustomerMap extends StatefulWidget {
  const CustomerMap({Key? key}) : super(key: key);

  @override
  State<CustomerMap> createState() => CustomerMapState();
}

class CustomerMapState extends State<CustomerMap> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.ac_unit),
          onPressed: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustMainScreen()),
                )
        ),
      ),
      
       
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      
     
    );
  }
}
