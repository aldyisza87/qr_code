import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController merekC = TextEditingController();
  final TextEditingController kondisiC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController noteC = TextEditingController();

  final ProductModel product = Get.arguments;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    bool showDelete = user.email == 'admin@tna.com';
    codeC.text = product.code;
    nameC.text = product.name;
    merekC.text = product.merek;
    kondisiC.text = product.kondisi;
    addressC.text = product.address;
    noteC.text = product.note;

    String data = product.code;

    return Scaffold(
      backgroundColor: const Color(0xFF363062),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4C7D),
        elevation: 0,
        title: const Text(
          'Detail',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.8),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 850,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: SizedBox(
                height: 190,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: QrImageView(
                        data: product.code,
                        size: 120,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      data,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Nama Aset',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              trailing: Text(
                product.name,
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.white24,
            ),
            ListTile(
              title: const Text('Merek',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              trailing: Text(
                product.merek,
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.white24,
            ),
            ListTile(
              title: const Text('Lokasi',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              trailing: Text(
                product.address,
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                style: const TextStyle(color: Colors.white54, fontSize: 18),
                controller: noteC,
                decoration: InputDecoration(
                  labelText: 'Lokasi Peminjam',
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  // Tambahkan suffix icon untuk menghapus isi field
                  suffixIcon: noteC.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            noteC.clear(); // Menghapus isi field
                          },
                          icon: const Icon(Icons.clear, color: Colors.white),
                        )
                      : const Icon(Icons.delete,
                          color: Colors
                              .transparent), // Ikon transparan jika tidak ada teks
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (noteC.text.isNotEmpty) {
                    Get.toNamed('/dashboard', arguments: {
                      'email': user.email,
                      'name': nameC.text,
                      'note': noteC.text,
                    });
                  } else {
                    Get.snackbar("Error", "Lokasi peminjam harus diisi");
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text(
                  "PINJAM",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.0),
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.isLoadingUpdate.isFalse) {
                    // kontroler name dan address wajib di isi
                    if (nameC.text.isNotEmpty && addressC.text.isNotEmpty) {
                      controller.isLoadingUpdate(true);
                      Map<String, dynamic> hasil =
                          await controller.editProduct({
                        "id": product.productId,
                        "name": nameC.text,
                        "kondisi": kondisiC.text,
                        "note": noteC.text,
                        "merek": merekC.text,
                        "address": addressC.text,
                      });
                      controller.isLoadingUpdate(false);
                      Get.back();

                      // jika hasil erorr maka tampilkan pesan eror jika berhasil tampilkan snackbar berhasil
                      Get.snackbar(
                          hasil["error"] == true ? "Erorr" : "Berhasil",
                          hasil["message"],
                          duration: const Duration(seconds: 2));
                    } else {
                      Get.snackbar("Error", "Semua data wajib diisi",
                          duration: const Duration(seconds: 2));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF99417),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Obx(
                  () => Text(
                    controller.isLoadingUpdate.isFalse
                        ? "UPDATE "
                        : "Loading...",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.0),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showDelete,
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    side: const BorderSide(color: Colors.white)),
                onPressed: () {
                  Get.defaultDialog(
                    radius: 14,
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
                              ? const Text(
                                  "DELETE",
                                )
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
                  "DELETE ",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
