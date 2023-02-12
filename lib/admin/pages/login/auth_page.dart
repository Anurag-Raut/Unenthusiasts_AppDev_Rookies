import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastenot/admin/pages/login/adminlogin.dart';
import 'package:wastenot/admin/pages/login/home_page.dart';

import '../../Admin_dashBoard/admin_dashboard.dart';


class AAuthPage extends StatefulWidget {
  const AAuthPage({super.key});

  @override
  State<AAuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return AdminDashBoard();
          }

          // user is NOT logged in
          else {
            return ALoginPage();
          }
        },
      ),
    );
  }
}
