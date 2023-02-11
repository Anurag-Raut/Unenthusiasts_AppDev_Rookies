import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
  final storage = FirebaseStorage.instance;

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
    final path = 'files/user!.uid/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    addFood(_foodName.text, _ageFood.text, _expiryFood.text, _quantity.text,
        _Description.text);
  }

  Future addFood(String _foodName, String _ageFood, String _expiryFood,
      String _quantity, String _Description) async {
    await FirebaseFirestore.instance.collection('food').add({
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
      body: Stepper(
        elevation: 0, //Horizontal Impact
        // margin: const EdgeInsets.all(20), //vertical impact
        controlsBuilder: controlBuilders,
        type: StepperType.horizontal,
        physics: const ScrollPhysics(),
        onStepTapped: onStepTapped,
        onStepContinue: continueStep,
        onStepCancel: cancelStep,
        currentStep: currentStep,

        //0, 1, 2
        steps: [
          Step(
              title: const Text('Food Details'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _foodName,
                    decoration: InputDecoration(
                      labelText: 'Enter the Food Name',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _ageFood,
                    decoration: InputDecoration(
                      labelText: 'Enter the Age of Food',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _expiryFood,
                    decoration: InputDecoration(
                      labelText: 'Enter the Expiry Date of Food',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _quantity,
                    decoration: InputDecoration(
                      labelText: 'Enter the Quantity of Food',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _Description,
                    decoration: InputDecoration(
                      labelText: 'Description of Food',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                ],
              ),
              isActive: currentStep >= 0,
              state:
                  currentStep >= 0 ? StepState.complete : StepState.disabled),
          Step(
            title: const Text('Upload an Image'),
            content: Column(
              children: [
                ElevatedButton(
                  child: Text('Select File'),
                  onPressed: selectFile,
                ),
                ElevatedButton(
                  child: Text('Upload File'),
                  onPressed: uploadFile,
                ),
              ],
            ),
            isActive: currentStep >= 0,
            state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }
}
