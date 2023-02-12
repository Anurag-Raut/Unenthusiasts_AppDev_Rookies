// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wastenot/customer/customer_dashboard/custom_search_delegate.dart';
import 'package:wastenot/customer/customer_dashboard/detailView.dart';
import 'firestoreData.dart';
import 'maps_customer.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static const double fabHeightClosed = 116.0;
  double fabHeight = fabHeightClosed;
  final user = FirebaseAuth.instance.currentUser!;
  List<DocumentReference<Map<String, dynamic>>> docIDs = [];

  List<String> name = [];
  List<String> docIds = [];
  CollectionReference users = FirebaseFirestore.instance.collection('food');
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('food')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              // print(element.reference['']);
              docIDs.add(element.reference);
              docIds.add(element.reference.id);
              // name.add(element.data());
              // print(element.data());
              name.add(element.data()['_foodName']);
            }));
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Waste Not",
        ),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                  context: context,
                  // delegate to customize the search bar

                  delegate:
                      CustomSearchDelegate(docIds: docIds, searchTerms: name));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            onPanelSlide: (position) => setState(() {
              final panelmaxscroll = MediaQuery.of(context).size.height * 0.7 -
                  MediaQuery.of(context).size.height * 0.1;
              fabHeight = position * panelmaxscroll + fabHeightClosed;
            }),
            minHeight: MediaQuery.of(context).size.height * 0.1,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            // backdropEnabled: true, //darken background if panel is open
            color: Colors
                .transparent, //necessary if you have rounded corners for panel
            /// panel itself
            panel: Container(
              decoration: const BoxDecoration(
                // background color of panel
                color: Colors.redAccent,
                // rounded corners of panel
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BarIndicator(),
                  Expanded(
                      child: ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailView(documentId: docIDs[index].id)),
                          )
                        },
                        title: GetData(documentId: docIDs[index].id),
                      );
                    },
                  ))
                ],
              ),
            ),

            /// header of panel while collapsed
            collapsed: Container(
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                children: const [
                  BarIndicator(),
                  Center(
                    child: Text(
                      "Slide Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            /// widget behind panel
            // ignore: prefer_const_constructors
            body: Center(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
          ),
          Positioned(right: 20, bottom: fabHeight, child: buildFAB(context))
        ],
      ),
    );
  }

  buildFAB(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          _determinePosition().then((value) async {
            CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude), zoom: 11);
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          });
        },
        child: Icon(Icons.gps_fixed),
      );
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
        width: 40,
        height: 3,
        decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
