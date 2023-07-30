import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            autocorrect: false,
            maxLength: 20,
            controller: codeC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Name Product",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: merekC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Merek",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: kondisiC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Kondisi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: addressC,
            decoration: InputDecoration(
              labelText: "Location",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: noteC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Note",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(
                  controller.isLoading.isFalse ? "Add Product" : "LOADING..."),
            ),
          ),
        ],
      ),
    );
  }
}
