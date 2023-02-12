import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:wastenot/provider/pages/login/home_page.dart';
import 'package:wastenot/provider/pages/login/providelogin.dart';

import '../landing_page/landingpage.dart';

class PAuthPage extends StatefulWidget {
  const PAuthPage({super.key});

  @override
  State<PAuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<PAuthPage> {
   
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
 // user is logged in
          if (snapshot.hasData) {
            return HomeScreen1();
          }

          // user is NOT logged in
          else {
            return ProviderLoginPage();
          }
        },
      ),
    );
  }
}
