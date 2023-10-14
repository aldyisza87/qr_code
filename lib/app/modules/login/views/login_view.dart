import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
        children: [
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            "Sign In to Countinue",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 102, 98, 98)),
          ),
          const SizedBox(
            height: 64,
          ),
          const Text(
            "Email Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            autocorrect: false,
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined),
              hintText: "Your Email Address",
              // labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Password",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(
            () => TextField(
              autocorrect: false,
              controller: passC,
              keyboardType: TextInputType.text,
              obscureText: controller.isHidden.value,
              decoration: InputDecoration(
                hintText: "Your Password",
                //labelText: "Password",
                prefixIcon: const Icon(Icons.key_off_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isHidden.toggle();
                  },
                  icon: Icon(
                    controller.isHidden.isFalse
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil =
                      await authC.login(emailC.text, passC.text);
                  controller.isLoading(false);

                  if (hasil["error"] == true) {
                    Get.snackbar("Error", hasil["message"]);
                  } else {
                    Get.offAllNamed(Routes.home);
                  }
                  // handle login status jika email "admin@gmail.com" maka tampilkan dashboard
                  if (emailC.text == "admin@gmail.com") {
                    Get.offAllNamed(Routes.home);
                  }
                } else {
                  Get.snackbar("Error", "Email dan password wajib diisi.");
                }
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 14),
            child: Obx(
              () => Text(
                controller.isLoading.isFalse ? "Sign In" : "Loading...",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
