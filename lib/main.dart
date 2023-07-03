import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';

import 'app/modules/loading/loading_screen.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

/* 
Selanjutnya generated options yaitu firebase_option perlu diberikan ke initializeAppmetode. 
Karena ini adalah operasi async, fungsi main dapat dimodifikasi 
untuk memastikan inisialisasi selesai sebelum menjalankan aplikasi.
*/
void main() async {
  // proses inisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // injeksi data dari auth controller berupa user id dan set permanen untuk semua page
  Get.put(AuthController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

// meng inisialisasi firebase auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  /* firebase auth dengan streambuilder ( import package firebase_auth) -> 
    auto login dengan firebase authentication */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // memantau setiap perubahan dari otentikasi
      stream: auth.authStateChanges(),
      builder: (context, snapAuth) {
        // handle status if connection waiting -> LoginScreen(berupa Loading progres indikator)
        if (snapAuth.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "QR Code",

          // cek status snapAuth yang berupa user jika memiliki data -> home jika tidak login
          initialRoute: snapAuth.hasData ? Routes.home : Routes.login,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
