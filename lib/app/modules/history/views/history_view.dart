import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'dart:typed_data';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  HistoryView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    bool showDelete = user.email == 'admin@tna.com';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        elevation: 0,
        title: const Text('History'),
        centerTitle: true,
        actions: [
          Visibility(
            visible: showDelete,
            child: IconButton(
                onPressed: () async {
                  await generateAndPrintPdf();
                },
                icon: const Icon(Icons.download)),
          ),
          Visibility(
            visible: showDelete,
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

              var historyData = snapshot.data!.docs
                  .map((document) => document.data() as Map<String, dynamic>)
                  .toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Asset')),
                    DataColumn(label: Text('Lokasi')),
                    DataColumn(label: Text('Waktu')),
                  ],
                  rows: historyData.map<DataRow>((data) {
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

  Future<Uint8List> generatePdf(List<Map<String, dynamic>> historyData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(children: [
          pw.Text(
            'Report data history : ',
            style: pw.TextStyle(
              fontSize: 18.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.0),
              1: const pw.FlexColumnWidth(1.0),
              2: const pw.FlexColumnWidth(1.0),
              3: const pw.FlexColumnWidth(1.0),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text('Email'),
                  pw.Text('Asset'),
                  pw.Text('Lokasi'),
                  pw.Text('Waktu'),
                ],
              ),
              for (var data in historyData)
                pw.TableRow(
                  children: [
                    pw.Text(data['email'] ?? ''),
                    pw.Text(data['name'] ?? ''),
                    pw.Text(data['note'] ?? ''),
                    pw.Text(
                      data['timestamp'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format((data['timestamp'] as Timestamp).toDate())
                          : '',
                    ),
                  ],
                ),
            ],
          ),
        ]),
      ),
    );

    return pdf.save();
  }

  Future<void> generateAndPrintPdf() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('history').get();

      List<Map<String, dynamic>> historyData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      Uint8List pdfBytes = await generatePdf(historyData);

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'history_report.pdf',
      );

      Get.snackbar('Success', 'PDF generated and printed.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate or print the PDF.');
    }
  }
}
