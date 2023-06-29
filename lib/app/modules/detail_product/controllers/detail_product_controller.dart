import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  // controller untuk button loading nilai awal = false lalu observasi / pantau
  RxBool isLoadingUpdate = false.obs;
  RxBool isLoadingDelete = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editProduct(Map<String, dynamic> data) async {
    try {
      await firestore.collection("product").doc(data["id"]).update({
        "name": data["name"],
        "qty": data["qty"],
      });
      return {"error": false, "message": "Berhasi update product."};
    } catch (e) {
      return {"error": false, "message": "Tidak dapat update product."};
    }
  }

  // untuk menghapus produk hanya perlu menghapus document id di collection firestore
  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      await firestore.collection("product").doc(id).delete();
      return {"error": false, "message": "Berhasi delete product."};
    } catch (e) {
      return {"error": false, "message": "Tidak dapat delete product."};
    }
  }
}
