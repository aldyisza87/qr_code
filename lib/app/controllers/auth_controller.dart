import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  /* cek konsisi auth yang di tampung di uid?  ada/tidak 
  Null ? tidak ada user login : uid -> ada user sedang login
  */
  String? uid;
  late FirebaseAuth auth;

  Future<Map<String, dynamic>> login(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      return {
        "error": false,
        "message": "Berhasil login.",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "error": false,
        "message": "${e.message}",
      };
    } catch (e) {
      return {
        "error": false,
        "message": "Tidak dapat login.",
      };
    }
  }

  @override
  void onInit() {
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });

    super.onInit();
  }
}
