import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wastenot/admin/pages/login/auth_page.dart';

class Second_screen extends StatefulWidget {
  const Second_screen({super.key});

  @override
  State<Second_screen> createState() => _Second_screenState();
}

class _Second_screenState extends State<Second_screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Lottie.asset('assets/adminLottie.json'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
          ),
          Text(
            "Admin",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),
            child: const Text(
              'Admin',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AAuthPage()),
              );
              // ...
            },
          ),
        ],
      ),
    );
  }
}
