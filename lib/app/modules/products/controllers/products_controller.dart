import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  // Inisialisasi firebasefirestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  /* Jika type data future menggunakan async tanpa bintang 
  sedangkan Stream menggunakan async* dari firebasefirestore*/

  Stream<QuerySnapshot<Map<String, dynamic>>> streamProducts() async* {
    // masuk ke dalam collection product
    yield* firestore.collection("product").snapshots();
  }
}
