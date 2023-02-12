

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
   final documentId;
  const DetailView({super.key, required this.documentId});
 
  @override
  Widget build(BuildContext context) {
     CollectionReference users = FirebaseFirestore.instance.collection('food');
    return Scaffold(
      appBar: AppBar(title: Text('More Details'),),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
    
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
    
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return  Column(
              children: [
                 Center(child: Text('Name ${data['_foodName']}')),
                  SizedBox(height: 20,),
                Center(child: Text('Description =  ${data['_Description']}')),
                   SizedBox(height: 20,),
                Center(child: Text('age of food =  ${data['_ageFood']}')),
                SizedBox(height: 20,),
                Center(child: Text('expiry Date =  ${data['_expiryFood']}')),



              ],
            );
          }
    
          return Text("loading");
        },
      ),
    );
  }
}
