import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../controllers/auth_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.addProduct);
              },
              icon: const Icon(Icons.add_outlined),
            ),
            IconButton(
              onPressed: () async {
                Map<String, dynamic> hasil = await authC.logout();
                if (hasil["error"] == false) {
                  Get.offAllNamed(Routes.login);
                } else {
                  Get.snackbar("Error", hasil["error"]);
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ]),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          // memantau stream dari database product
          builder: (context, snapProduct) {
            // cek jika snap product koneksi sedang waiting maka tampilkan widget CircularProgres / loading view
            if (snapProduct.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // cek data product jika kosong maka tampilkan widget text
            if (snapProduct.data!.docs.isEmpty) {
              return const Center(child: Text("No Products"));
            }

            //Tampung product dalam List dengan nama allProduct dengan awal kosong []
            List<ProductModel> allProducts = [];
            // jika data dalam collection ada maka looping untuk menampilkan product yang ada dalam dokumen "product"
            for (var element in snapProduct.data!.docs) {
              allProducts.add(ProductModel.fromJson(element.data()));
            }
            return ListView.builder(
              itemCount: allProducts.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                // mengambil data product setiap indexnya
                ProductModel product = allProducts[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      // pindah page ke detail product view dimana kita bisa lempar argumen dari product model
                      Get.toNamed(Routes.detailProduct, arguments: product);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text("Name     : ${product.name}"),
                                Text("Quantity : ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: QrImageView(
                              data: product.code,
                              size: 200.0,
                              version: QrVersions.auto,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String barcode = await FlutterBarcodeScanner.scanBarcode(
            "#000000",
            "CANCEL",
            true,
            ScanMode.QR,
          );

          // Get data dari firebase search by product id
          Map<String, dynamic> hasil = await controller.getProductById(barcode);
          if (hasil["error"] == false) {
            Get.toNamed(Routes.detailProduct, arguments: hasil["data"]);
          } else {
            Get.snackbar(
              "Error",
              hasil["message"],
              duration: const Duration(seconds: 2),
            );
          }
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
