import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class HomeScreen1 extends StatefulWidget {
  // final String foodName;
  // final String ageFood;
  // final String expiryFood;
  // final String Quantity;
  // final String Description;

  const HomeScreen1({
    super.key,
  });

  @override
  State<HomeScreen1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  var uuid = Uuid().v1();
  final storage = FirebaseStorage.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _foodName = TextEditingController();
  final TextEditingController _ageFood = TextEditingController();
  final TextEditingController _expiryFood = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _Description = TextEditingController();
  PlatformFile? pickedFile;

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _foodName.dispose();
  //   _ageFood.dispose();
  //   _expiryFood.dispose();
  //   _quantity.dispose();
  //   _Description.dispose();
  //   super.dispose();
  // }

  int currentStep = 0;
  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1; //currentStep+=1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1; //currentStep-=1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlBuilders(context, details) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: details.onStepContinue,
            child: const Text('Next'),
          ),
          const SizedBox(width: 20),
          if (currentStep != 0)
            OutlinedButton(
              onPressed: details.onStepCancel,
              child: const Text('Back'),
            ),
        ],
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = '${uuid}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    addFood(_foodName.text, _ageFood.text, _expiryFood.text, _quantity.text,
        _Description.text);
  }

  Future addFood(String _foodName, String _ageFood, String _expiryFood,
      String _quantity, String _Description) async {
    await FirebaseFirestore.instance.collection('food').doc(uuid).set({
      '_foodName': _foodName,
      '_ageFood': _ageFood,
      '_expiryFood': _expiryFood,
      '_quantity': _quantity,
      '_Description': _Description,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(children: [
          Positioned(
            top: 150,
            left: 14,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, right: 165),
              child: Text(
                "Welcome !",
                style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF363f93),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: TextFormField(
              controller: _foodName,
              decoration: InputDecoration(
                labelText: "Enter your name",
              ),
           
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 25, left: 25),
            child: TextFormField(
              controller: _ageFood,
              decoration: InputDecoration(
                labelText: "Enter your phone number",
              ),
             
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
            child: TextFormField(
              controller: _expiryFood,
              decoration: InputDecoration(
                labelText: "Enter your age",
              ),
          
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
            child: TextFormField(
              controller: _Description,
              decoration: InputDecoration(
                labelText: "Date of Birth[dd/mm/yyyy]",
              ),
              
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: Text("choose file")),
              ElevatedButton(onPressed: () { uploadFile();}, child: Text("upload file")),
              ElevatedButton(onPressed: () {addFood(_foodName.text,_ageFood.text,_ageFood.text,_quantity.text,_Description.text);
            }, child: Text("Save")),
            ],
          ),
        ]),
      )),
    );

    
  }
}





