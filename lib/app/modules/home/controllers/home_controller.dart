import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';

class HomeController extends GetxController {
  RxBool isLoadingUpdate = false.obs;
  RxBool isLoadingDelete = false.obs;
  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;
  // Inisialisasi firebasefirestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  /* Jika type data future menggunakan async tanpa bintang 
  sedangkan Stream menggunakan async* dari firebasefirestore*/

  Stream<QuerySnapshot<Map<String, dynamic>>> streamProducts() async* {
    // masuk ke dalam collection product
    yield* firestore.collection("product").snapshots();
  }

  Future<Map<String, dynamic>> getProductById(String codeBarang) async {
    try {
      var hasil = await firestore
          .collection("product")
          .where("code", isEqualTo: codeBarang)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada product ini di database.",
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail product dari product code ini.",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak mendapatkan detail product dari product code ini.",
      };
    }
  }
}
