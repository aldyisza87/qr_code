import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/widget/text_field.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController merekC = TextEditingController();
  final TextEditingController kondisiC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController noteC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF363062),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        elevation: 0,
        title: const Text(
          'New Asset',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.8),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(
            controller: codeC,
            labelText: "Product Code",
            maxLength: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: nameC,
            labelText: "Name Product",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: merekC,
            labelText: "Merek",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: kondisiC,
            labelText: "Kondisi",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: addressC,
            labelText: "Location",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            controller: noteC,
            labelText: "Note",
            hint: "Peminjam - Lokasi",
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    merekC.text.isNotEmpty &&
                    kondisiC.text.isNotEmpty &&
                    noteC.text.isNotEmpty &&
                    addressC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil = await controller.addProduct({
                    "code": codeC.text,
                    "name": nameC.text,
                    "merek": merekC.text,
                    "kondisi": kondisiC.text,
                    "note": noteC.text,
                    // mengubah text menjadi integer jika gagal try maka nilai defaultnya 0
                    "address": addressC.text,
                  });
                  controller.isLoading(false);

                  Get.back();
                  Get.snackbar(hasil["error"] == true ? "error" : "Succes",
                      hasil["message"]);
                } else {
                  Get.snackbar("Error", "Semua wajib di isi");
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF99417),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 14),
            child: Obx(
              () => Text(
                controller.isLoading.isFalse ? "Add New Item" : "Loading...",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
