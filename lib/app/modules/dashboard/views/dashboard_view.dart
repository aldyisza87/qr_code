import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        title: const Text('Peminjaman'),
        centerTitle: true,
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
                    DataColumn(label: Text('Asset')),
                    DataColumn(label: Text('Lokasi')),
                    DataColumn(label: Text('Waktu')),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4D4C7D),
        onPressed: () {
          saveToFirebase(data);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  // Function to save data to Firebase
  void saveToFirebase(Map<String, dynamic> data) async {
    try {
      await firestore.collection('history').add({
        'email': data['email'],
        'name': data['name'],
        'note': data['note'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Data saved to history.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data to history.');
    }
  }
}
