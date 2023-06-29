import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';
import 'package:qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  final ProductModel product = Get.arguments;
  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Product'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: QrImageView(data: product.code),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              maxLength: 10,
              readOnly: true,
              controller: codeC,
              keyboardType: TextInputType.number,
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
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoadingUpdate.isFalse) {
                  // kontroler name dan qty wajib di isi
                  if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                    controller.isLoadingUpdate(true);
                    Map<String, dynamic> hasil = await controller.editProduct({
                      "id": product.productId,
                      "name": nameC.text,
                      // qty = type data number {mengubah string ke integer}
                      "qty": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoadingUpdate(false);

                    // jika hasil erorr maka tampilkan pesan eror jika berhasil tampilkan snackbar berhasil
                    Get.snackbar(hasil["error"] == true ? "Erorr" : "Berhasil",
                        hasil["message"],
                        duration: const Duration(seconds: 2));
                  } else {
                    Get.snackbar("Error", "Semua data wajib diisi",
                        duration: const Duration(seconds: 2));
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
                () => Text(controller.isLoadingUpdate.isFalse
                    ? "UPDATE PRODUCT"
                    : "LOADING..."),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Product",
                  middleText: "Are you sure to delete this product ? ",
                  actions: [
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("CANCEL"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        controller.isLoadingDelete(true);
                        Map<String, dynamic> hasil =
                            await controller.deleteProduct(product.productId);
                        Get.back(); // untuk menutup dialog snakbar
                        Get.back(); // untuk kembali ke all product
                        Get.snackbar(
                            hasil["error"] == true ? "Erorr" : "Berhasil",
                            hasil["message"],
                            duration: const Duration(seconds: 2));

                        controller.isLoadingDelete(false);
                      },
                      child: Obx(
                        () => controller.isLoadingDelete.isFalse
                            ? const Text("DELETE")
                            : const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 4,
                              ),
                      ),
                    )
                  ],
                );
              },
              child: const Text(
                "Delete Product",
                style: TextStyle(color: Colors.redAccent),
              ),
            )
          ],
        ));
  }
}
