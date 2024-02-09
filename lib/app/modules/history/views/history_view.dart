import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  HistoryView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    bool showdell = user.email == 'admin@tna.com';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        elevation: 0,
        title: const Text('History'),
        centerTitle: true,
        actions: [
          Visibility(
            visible: showdell,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteAllData();
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('history').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var historyData = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Note')),
                    DataColumn(label: Text('Timestamp')),
                  ],
                  rows: historyData.map<DataRow>((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    return DataRow(
                      cells: [
                        DataCell(Text(data['email'] ?? '')),
                        DataCell(Text(data['name'] ?? '')),
                        DataCell(Text(data['note'] ?? '')),
                        DataCell(
                          Text(
                            data['timestamp'] != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    (data['timestamp'] as Timestamp).toDate())
                                : '',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to delete all data from the 'history' collection
  void deleteAllData() async {
    try {
      await firestore.collection('history').get().then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      Get.snackbar('Success', 'All data deleted from Firebase.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete data from Firebase.');
    }
  }
}
