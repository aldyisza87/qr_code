import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback ontap;

            switch (index) {
              case 0:
                title = "Add Products";
                icon = Icons.post_add_rounded;
                ontap = () => Get.toNamed(Routes.addProduct);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_rounded;
                ontap = () => Get.toNamed(Routes.detailProduct);
                break;
              case 2:
                title = "QR Code";
                icon = Icons.qr_code_2_rounded;
                ontap = () => print("Open Camera");
                break;
              case 3:
                title = "Catalogue";
                icon = Icons.document_scanner_rounded;
                ontap = () => print("Open Pdf");
                break;
              default:
            }
            return Material(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: ontap,
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Icon(icon),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(title)
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> hasil = await authC.logout();
          if (hasil["error"] == false) {
            Get.offAllNamed(Routes.login);
          } else {
            Get.snackbar("Error", hasil["error"]);
          }
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
